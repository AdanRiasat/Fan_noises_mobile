import 'dart:convert';

class Fan {
  int? id;
  String name;
  List<String> audioPaths;
  bool isCustom;

  Fan({
    this.id,
    required this.name,
    required this.audioPaths,
    required this.isCustom,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'audioPaths': jsonEncode(audioPaths),
      'isCustom': isCustom ? 1 : 0,
    };
  }

  factory Fan.fromMap(Map<String, dynamic> map) {
    return Fan(
      id: map['id'],
      name: map['name'],
      audioPaths: List<String>.from(jsonDecode(map['audioPaths']) as List),
      isCustom: map['isCustom'] == 1,
    );
  }
}
