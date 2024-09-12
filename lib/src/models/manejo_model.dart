class Manejo {
  int? id;
  String nome;
  String descricao;

  Manejo({this.id, required this.nome, required this.descricao});

  // Converter um Manejo para Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
    };
  }

  // Converter de Map para Manejo
  factory Manejo.fromMap(Map<String, dynamic> map) {
    return Manejo(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
    );
  }
}
