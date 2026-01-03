import 'dart:convert';

import 'package:sqflite/sqflite.dart';

class Seed {
  static Future<void> insert(Database db) async {
    final fans = [
      {
        'name': 'Fan xyz72 mini',
        'audioPaths': jsonEncode([
          'assets/audio/vine-boom.mp3',
          'assets/audio/white-noise.mp3',
          'assets/audio/white-noise-soft.mp3',
        ]),
        'isCustom': false,
      },
      {
        'name': 'Personal fan',
        'audioPaths': jsonEncode([
          'assets/audio/vine-boom.mp3',
          'assets/audio/white-noise.mp3',
          'assets/audio/white-noise-soft.mp3',
        ]),
        'isCustom': false,
      },
      {
        'name': 'Fan 32',
        'audioPaths': jsonEncode([
          'assets/audio/vine-boom.mp3',
          'assets/audio/white-noise.mp3',
          'assets/audio/white-noise-soft.mp3',
        ]),
        'isCustom': false,
      },
    ];

    for (final fan in fans) {
      await db.insert('fans', fan);
    }
  }
}
