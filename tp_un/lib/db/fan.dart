class Fan {
  final int? id;
  final String name;
  final String audioPath;

  Fan({this.id, required this.name, required this.audioPath});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'audioPath': audioPath};
  }

  factory Fan.fromMap(Map<String, dynamic> map) {
    return Fan(id: map['id'], name: map['name'], audioPath: map['audioPath']);
  }
}
