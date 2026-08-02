import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fan_noises/db/fan.dart';
import 'package:fan_noises/db/fan_controller.dart';
import 'package:fan_noises/pages/home.dart';
import 'package:fan_noises/themes/app.theme.dart';
import '../generated/l10n.dart';

class ManageFans extends StatefulWidget {
  const ManageFans({super.key, required this.setFab, required this.onNavigate});

  final void Function(Widget page) onNavigate;
  final void Function(FloatingActionButton?) setFab;

  @override
  State<ManageFans> createState() => _ManageFansState();
}

class _ManageFansState extends State<ManageFans> {
  List<Fan> _fans = [];

  int? _editingFanId;
  final _nameController = TextEditingController();

  final FocusNode _editFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    widget.setFab(
      FloatingActionButton(
        onPressed: () async {
          await _openAddFanDialog();
        },
        backgroundColor: AppTheme.secondary,
        child: Icon(Icons.add, color: AppTheme.primaryText),
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
    _editFocusNode.dispose();
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
    String? nameError;
    String? pathError;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                S.of(context).addFan,
                style: TextStyle(color: AppTheme.primaryText),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    cursorColor: AppTheme.secondaryText,
                    decoration: InputDecoration(
                      labelText: S.of(context).fanName,
                      errorText: nameError,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.secondaryText),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.secondaryText),
                      ),
                      floatingLabelStyle: TextStyle(
                        color: AppTheme.secondaryText, // focused label color
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondary,
                    ),
                    icon: Icon(Icons.attach_file, color: AppTheme.primaryText),
                    label: Text(
                      S.of(context).chooseAudioFile,
                      style: TextStyle(color: AppTheme.primaryText),
                    ),
                    onPressed: () async {
                      const allowedExtensions = [
                        'mp3',
                        'wav',
                        'ogg',
                        'm4a',
                        'aac',
                        'mp4',
                      ];

                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.audio,
                      );

                      if (result != null) {
                        final path = result.files.single.path!;
                        final extension = path.split('.').last.toLowerCase();

                        if (!allowedExtensions.contains(extension)) {
                          setDialogState(() {
                            selectedPath = null;
                            pathError =
                                S.of(context).unsupportedAudioFormat;
                          });

                          return;
                        }

                        setDialogState(() {
                          selectedPath = path;
                        });
                      }
                    },
                  ),

                  if (selectedPath != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        selectedPath!.split('/').last,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.secondaryText,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  if (pathError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        pathError!,
                        style: const TextStyle(fontSize: 12, color: Colors.red),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    S.of(context).cancel,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final name = nameController.text.trim();

                    if (name.isEmpty) {
                      setDialogState(() {
                        nameError = S.of(context).addNameToFan;
                      });
                      return;
                    }

                    if (selectedPath == "" || selectedPath == null) {
                      setDialogState(() {
                        pathError = S.of(context).fanNeedsAudio(name);
                      });
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

                    if (!context.mounted) return;
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    S.of(context).save,
                    style: const TextStyle(color: Colors.white),
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
        title: Text(S.of(context).deleteFan),
        content: Text(S.of(context).deleteFanConfirm(fan.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              S.of(context).cancel,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              S.of(context).delete,
              style: const TextStyle(color: Colors.white),
            ),
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
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Text(
                    S.of(context).yourFans,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryText,
                    ),
                  ),
                ),
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0,
                        ),
                        title: isEditing == true
                            ? TextField(
                                controller: _nameController,
                                focusNode: _editFocusNode,
                                onSubmitted: (newName) async {
                                  if (newName.trim().isNotEmpty &&
                                      newName.trim() != fan.name) {
                                    await FanController.instance.updateFanName(
                                      fan.id!,
                                      newName.trim(),
                                    );
                                  }

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
                                onTapOutside: (_) async {
                                  if (!_editFocusNode.hasFocus) return;

                                  final newName = _nameController.text.trim();

                                  if (newName.isNotEmpty &&
                                      newName != fan.name) {
                                    await FanController.instance.updateFanName(
                                      fan.id!,
                                      newName.trim(),
                                    );
                                  }

                                  setState(() {
                                    _editingFanId = null;
                                    fan.name = newName.trim();
                                  });
                                },
                              )
                            : GestureDetector(
                                child: Text(
                                  fan.name,
                                  style: TextStyle(
                                    color: AppTheme.secondaryText,
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _editingFanId = fan.id!;
                                    _nameController.text = fan.name;
                                  });

                                  _editFocusNode.requestFocus();
                                },
                              ),
                        trailing: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(Icons.delete),
                          constraints: const BoxConstraints(),
                          color: AppTheme.secondaryText,
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondary,
                  ),
                  onPressed: () {
                    widget.onNavigate(Home());
                  },
                  child: Text(
                    S.of(context).homeTitle,
                    style: TextStyle(color: AppTheme.primaryText),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
