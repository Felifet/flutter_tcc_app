class Ciclo {
  final int? id;
  final String descricao;

  Ciclo({this.id, required this.descricao});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricao': descricao,
    };
  }

  factory Ciclo.fromMap(Map<String, dynamic> map) {
    return Ciclo(
      id: map['id'],
      descricao: map['descricao'],
    );
  }
}
