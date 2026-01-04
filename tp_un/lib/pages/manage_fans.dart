import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tp_un/db/fan.dart';
import 'package:tp_un/db/fan_controller.dart';
import 'package:tp_un/pages/home.dart';
import 'package:tp_un/widgets/drawer.dart';

class ManageFans extends StatefulWidget {
  const ManageFans({super.key, required this.setFab});

  final void Function(FloatingActionButton?) setFab;

  @override
  State<ManageFans> createState() => _ManageFansState();
}

class _ManageFansState extends State<ManageFans> {
  List<Fan> _fans = [];

  int? _editingFanId;
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    widget.setFab(
      FloatingActionButton(
        onPressed: () async {
          await _openAddFanDialog();
        },
        child: const Icon(Icons.add),
      ),
    );

    FanController.instance.getFans().then((fans) {
      setState(() {
        _fans = fans;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    widget.setFab(null);
    _nameController.dispose();
  }

  Future<String> _saveAudioFile(String selectedPath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = selectedPath.split('/').last;

    final audioDir = Directory('${appDir.path}/audio');
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final newPath = '${audioDir.path}/$timestamp-$fileName';

    await File(selectedPath).copy(newPath);

    return newPath;
  }

  Future<void> _openAddFanDialog() async {
    final nameController = TextEditingController();
    String? selectedPath;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("Add fan"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Fan name"),
                  ),
                  SizedBox(height: 16),

                  ElevatedButton.icon(
                    icon: Icon(Icons.attach_file),
                    label: const Text("Choose audio file"),
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.audio,
                      );

                      if (result != null) {
                        setDialogState(() {
                          selectedPath = result.files.single.path;
                        });
                      }
                    },
                  ),

                  if (selectedPath != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        selectedPath!.split('/').last,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final name = nameController.text.trim();

                    if (selectedPath == "" ||
                        selectedPath == null ||
                        name == "") {
                      return;
                    }

                    final audioPath = await _saveAudioFile(selectedPath!);

                    final newFan = Fan(
                      name: name,
                      audioPaths: [audioPath],
                      isCustom: true,
                    );
                    final fanId = await FanController.instance.addFan(newFan);
                    newFan.id = fanId;

                    setState(() {
                      _fans.add(newFan);
                    });

                    Navigator.pop(context, true);
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDelete(Fan fan) async {
    final bool? result = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Fan"),
        content: Text("Delete ${fan.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (result == true) {
      await FanController.instance.deleteFan(fan.id!);

      setState(() {
        _fans.removeWhere((f) => f.id == fan.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Your fans", style: const TextStyle(fontSize: 20)),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _fans.length,
                  itemBuilder: (context, index) {
                    final fan = _fans[index];
                    final isEditing = _editingFanId == fan.id!;
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ListTile(
                        title: isEditing == true
                            ? TextField(
                                controller: _nameController,
                                onSubmitted: (newName) async {
                                  if (newName.trim().isEmpty) return;

                                  await FanController.instance.updateFanName(
                                    fan.id!,
                                    newName.trim(),
                                  );

                                  setState(() {
                                    _editingFanId = null;
                                    fan.name = newName.trim();
                                  });
                                },
                                onEditingComplete: () {
                                  setState(() {
                                    _editingFanId = null;
                                  });
                                },
                              )
                            : GestureDetector(
                                child: Text(fan.name),
                                onTap: () {
                                  setState(() {
                                    _editingFanId = fan.id!;
                                    _nameController.text = fan.name;
                                  });
                                },
                              ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await _confirmDelete(fan);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (context) => Home()));
                  },
                  child: Text("Home"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
