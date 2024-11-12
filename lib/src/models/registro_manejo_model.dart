class RegistroManejo {
  final int? id;
  final DateTime datetime;
  final int cicloId;
  final int glebaId;
  final int manejoId;

  // Campos adicionais para exibir na tela
  String? glebaNomeIdentificador;
  String? cicloDescricao;
  String? manejoDescricao;

  RegistroManejo({
    this.id,
    required this.datetime,
    required this.cicloId,
    required this.glebaId,
    required this.manejoId,
    this.glebaNomeIdentificador,
    this.cicloDescricao,
    this.manejoDescricao,
  });

  factory RegistroManejo.fromMap(Map<String, dynamic> map) {
    return RegistroManejo(
      id: map['id'],
      datetime: DateTime.parse(map['datetime']),
      cicloId: map['ciclo_id'],
      glebaId: map['gleba_id'],
      manejoId: map['manejo_id'],
      glebaNomeIdentificador: map['gleba_nome_identificador'],
      cicloDescricao: map['ciclo_descricao'],
      manejoDescricao: map['manejo_descricao'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'datetime': datetime.toIso8601String(),
      'ciclo_id': cicloId,
      'gleba_id': glebaId,
      'manejo_id': manejoId,
    };
  }
}
