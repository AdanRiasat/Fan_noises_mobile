import 'dart:convert';

class Fan {
  final int? id;
  final String name;
  final List<String> audioPaths;

  Fan({this.id, required this.name, required this.audioPaths});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'audioPaths': jsonEncode(audioPaths)};
  }

  factory Fan.fromMap(Map<String, dynamic> map) {
    return Fan(
      id: map['id'],
      name: map['name'],
      audioPaths: List<String>.from(jsonDecode(map['audioPaths']) as List),
    );
  }
}
