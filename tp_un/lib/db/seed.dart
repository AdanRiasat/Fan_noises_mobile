import 'dart:convert';

import 'package:sqflite/sqflite.dart';

class Seed {
  static Future<void> insert(Database db) async {
    final fans = [
      {
        'name': 'Seville Classics Fan',
        'audioPaths': jsonEncode([
          'assets/audio/main_fan1.2.mp3',
          'assets/audio/main_fan2.2.mp3',
          'assets/audio/main_fan3.3.wav',
        ]),
        'isCustom': false,
      },
      {
        'name': 'White Noise',
        'audioPaths': jsonEncode([
          'assets/audio/white_noise1.mp3',
          'assets/audio/white_noise3.mp3',
          'assets/audio/white-noise-soft.mp3',
        ]),
        'isCustom': false,
      },
      {
        'name': 'Holmes Fan',
        'audioPaths': jsonEncode([
          'assets/audio/holmes1.mp3',
          'assets/audio/holmes2.mp3',
          'assets/audio/holmes3.mp3',
        ]),
        'isCustom': false,
      },
    ];

    for (final fan in fans) {
      await db.insert('fans', fan);
    }
  }
}
