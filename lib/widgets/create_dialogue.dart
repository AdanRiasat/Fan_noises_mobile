import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fan_noises/db/fan.dart';
import 'package:fan_noises/db/fan_controller.dart';
import 'package:fan_noises/themes/app.theme.dart';
import '../generated/l10n.dart';

enum AudioSaveError { storageFull, unknown }

class AudioSaveException implements Exception {
  final AudioSaveError type;
  AudioSaveException(this.type);
}

class CreateDialogue extends StatefulWidget {
  const CreateDialogue({super.key});

  @override
  State<CreateDialogue> createState() => _CreateDialogueState();
}

class _CreateDialogueState extends State<CreateDialogue> {
  static const _allowedExtensions = [
    'mp3',
    'wav',
    'ogg',
    'm4a',
    'aac',
    'mp4',
    'flac',
  ];

  static const _noSpaceErrorCode = 28;
  static const _largeFileWarningBytes = 50000000;

  final _nameController = TextEditingController();

  String? _selectedPath;
  String? _nameError;
  String? _pathError;
  String? _sizeWarning;
  String? _saveError;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String? _getExtension(String path) {
    final fileName = path.split('/').last;
    final dotIndex = fileName.lastIndexOf('.');

    if (dotIndex <= 0 || dotIndex == fileName.length - 1) {
      return null; // no extension
    }

    return fileName.substring(dotIndex + 1).toLowerCase();
  }

  bool _isStorageFullError(FileSystemException e) {
    final errorCode = e.osError?.errorCode;
    if (errorCode == _noSpaceErrorCode) return true;

    final message = e.message.toLowerCase();
    final osMessage = e.osError?.message.toLowerCase() ?? '';
    return message.contains('no space') ||
        message.contains('not enough space') ||
        osMessage.contains('no space') ||
        osMessage.contains('not enough space');
  }

  Future<String> _saveAudioFile(String selectedPath) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = selectedPath.split('/').last;

      final audioDir = Directory('${appDir.path}/audio');
      if (!await audioDir.exists()) {
        await audioDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final newPath = '${audioDir.path}/$timestamp-$fileName';

      final copied = await File(selectedPath).copy(newPath);

      if (!await copied.exists() || await copied.length() == 0) {
        throw AudioSaveException(AudioSaveError.unknown);
      }

      return newPath;
    } on AudioSaveException {
      rethrow;
    } on FileSystemException catch (e) {
      if (_isStorageFullError(e)) {
        throw AudioSaveException(AudioSaveError.storageFull);
      }
      throw AudioSaveException(AudioSaveError.unknown);
    } catch (_) {
      throw AudioSaveException(AudioSaveError.unknown);
    }
  }

  Future<void> _deleteOrphanedAudio(String? path) async {
    if (path == null) return;

    try {
      await File(path).delete();
    } catch (_) {
      // Best effort cleanup only.
    }
  }

  Future<void> _pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result == null || !mounted) return;

    final path = result.files.single.path!;
    final extension = _getExtension(path);

    if (extension == null || !_allowedExtensions.contains(extension)) {
      setState(() {
        _selectedPath = null;
        _pathError = extension == null
            ? S.of(context).noFileExtension
            : S.of(context).unsupportedAudioFormat;
        _sizeWarning = null;
        _saveError = null;
      });
      return;
    }

    final fileSize = result.files.single.size;

    setState(() {
      _selectedPath = path;
      _pathError = null;
      _saveError = null;
      _sizeWarning = fileSize > _largeFileWarningBytes
          ? S.of(context).largeAudioFileWarning
          : null;
    });
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();

    setState(() {
      _nameError = name.isEmpty ? S.of(context).addNameToFan : null;
      _pathError = (_selectedPath == null || _selectedPath == "")
          ? S.of(context).fanNeedsAudio(name)
          : null;
      _saveError = null;
    });

    if (_nameError != null || _pathError != null) return;

    setState(() => _isSaving = true);

    String? audioPath;
    try {
      audioPath = await _saveAudioFile(_selectedPath!);

      final newFan = Fan(name: name, audioPaths: [audioPath], isCustom: true);
      newFan.id = await FanController.instance.addFan(newFan);

      if (!mounted) return;
      Navigator.pop(context, newFan);
    } on AudioSaveException catch (e) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
        _saveError = e.type == AudioSaveError.storageFull
            ? S.of(context).audioSaveErrorStorageFull
            : S.of(context).audioSaveErrorUnknown;
      });
    } on DatabaseException catch (e) {
      await _deleteOrphanedAudio(audioPath);

      if (!mounted) return;

      final nameTaken = e.isUniqueConstraintError();
      setState(() {
        _isSaving = false;
        _nameError = nameTaken ? S.of(context).fanNameTaken : null;
        _saveError = nameTaken ? null : S.of(context).audioSaveErrorUnknown;
      });
    } catch (_) {
      await _deleteOrphanedAudio(audioPath);

      if (!mounted) return;

      setState(() {
        _isSaving = false;
        _saveError = S.of(context).audioSaveErrorUnknown;
      });
    }
  }

  Widget _note(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: color),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        S.of(context).addFan,
        style: TextStyle(color: AppTheme.primaryText),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            cursorColor: AppTheme.secondaryText,
            onChanged: (_) {
              if (_nameError != null) {
                setState(() => _nameError = null);
              }
            },
            decoration: InputDecoration(
              labelText: S.of(context).fanName,
              errorText: _nameError,
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
          const SizedBox(height: 16),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondary,
            ),
            icon: Icon(Icons.attach_file, color: AppTheme.primaryText),
            label: Text(
              S.of(context).chooseAudioFile,
              style: TextStyle(color: AppTheme.primaryText),
            ),
            onPressed: _isSaving ? null : _pickAudioFile,
          ),

          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              S.of(context).gaplessFormatNote,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.secondaryText,
              ),
            ),
          ),

          if (_selectedPath != null)
            _note(_selectedPath!.split('/').last, AppTheme.secondaryText),

          if (_sizeWarning != null) _note(_sizeWarning!, Colors.amber),

          if (_pathError != null) _note(_pathError!, Colors.red),

          if (_saveError != null) _note(_saveError!, Colors.red),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: Text(
            S.of(context).cancel,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.primaryText,
                  ),
                )
              : Text(
                  S.of(context).save,
                  style: const TextStyle(color: Colors.white),
                ),
        ),
      ],
    );
  }
}
