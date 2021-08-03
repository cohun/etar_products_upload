
class PartModel{
  final int id;
  final String name;
  final String type;
  final String unit;
  final String pieces;

  PartModel({this.id, this.name, this.type, this.unit, this.pieces});

  factory PartModel.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }
    final int id = data['id'];
    final String name = data['name'];
    final String type = data['type'];
    final String unit = data['unit'];
    final String pieces = data['pieces'];

    return PartModel(
      id: id,
      name: name,
      type: type,
      unit: unit,
      pieces: pieces,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'unit': unit,
      'pieces': pieces,
    };
  }

}