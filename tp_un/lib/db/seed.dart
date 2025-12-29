import 'package:sqflite/sqflite.dart';

class Seed {
  static Future<void> insert(Database db) async {
    final fans = [
      {'name': 'Fan xyz72 mini', 'audioPath': 'audio/vine-boom.mp3'},
      {'name': 'Personal fan', 'audioPath': 'audio/vine-boom.mp3'},
      {'name': 'Fan 32', 'audioPath': 'audio/vine-boom.mp3'},
    ];

    for (final fan in fans) {
      await db.insert('fans', fan);
    }
  }
}
