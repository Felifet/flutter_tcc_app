class RegistroManejo {
  final int? id;
  final DateTime datetime;
  final int cicloId;
  final int glebaId;
  final int manejoId;

  RegistroManejo({
    this.id, // Corrigido para permitir null
    required this.datetime,
    required this.cicloId,
    required this.glebaId,
    required this.manejoId,
  });

  factory RegistroManejo.fromMap(Map<String, dynamic> map) {
    return RegistroManejo(
      id: map['id'],
      datetime: DateTime.parse(map['datetime']),
      cicloId: map['ciclo_id'],
      glebaId: map['gleba_id'],
      manejoId: map['manejo_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Permite null para inserções
      'datetime': datetime.toIso8601String(),
      'ciclo_id': cicloId,
      'gleba_id': glebaId,
      'manejo_id': manejoId,
    };
  }
}
