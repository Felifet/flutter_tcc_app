class RegistroEstagioFenologico {
  int? id;
  DateTime datetime;
  int? cicloId;
  int? glebaId;
  int? estagioFenologicoId;

  RegistroEstagioFenologico({
    this.id,
    required this.datetime,
    this.cicloId,
    this.glebaId,
    this.estagioFenologicoId,
  });

  // Método para converter o objeto em um Map (usado para operações no banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'datetime': datetime.toIso8601String(),
      'ciclo_id': cicloId,
      'gleba_id': glebaId,
      'estagioFenologico_id': estagioFenologicoId,
    };
  }

  // Método para criar um objeto a partir de um Map (usado para recuperar dados do banco de dados)
  factory RegistroEstagioFenologico.fromMap(Map<String, dynamic> map) {
    return RegistroEstagioFenologico(
      id: map['id'],
      datetime: DateTime.parse(map['datetime']),
      cicloId: map['ciclo_id'],
      glebaId: map['gleba_id'],
      estagioFenologicoId: map['estagioFenologico_id'],
    );
  }
}
