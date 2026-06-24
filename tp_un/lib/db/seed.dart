import 'dart:convert';

import 'package:sqflite/sqflite.dart';

class Seed {
  static Future<void> insert(Database db) async {
    final fans = [
      {
        'name': 'Seville Classics Fan',
        'audioPaths': jsonEncode([
          'assets/audio/main-fan-1.wav',
          'assets/audio/main-fan-2.wav',
          'assets/audio/main-fan-3.wav',
        ]),
        'isCustom': false,
      },
      {
        'name': 'White Noise',
        'audioPaths': jsonEncode([
          'assets/audio/white-noise-1.wav',
          'assets/audio/white-noise-2.wav',
          'assets/audio/white-noise-3.wav',
        ]),
        'isCustom': false,
      },
      {
        'name': 'Holmes Fan',
        'audioPaths': jsonEncode([
          'assets/audio/holmes-1.wav',
          'assets/audio/holmes-2.wav',
          'assets/audio/holmes-3.wav',
        ]),
        'isCustom': false,
      },
    ];

    for (final fan in fans) {
      await db.insert('fans', fan);
    }
  }
}
