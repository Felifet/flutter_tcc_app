class Cultivar {
  int? id;
  String nome;

  Cultivar({this.id, required this.nome});

  // Converter o objeto Cultivar em um Map para o banco de dados
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  // Converter um Map em um objeto Cultivar
  factory Cultivar.fromMap(Map<String, dynamic> map) {
    return Cultivar(
      id: map['id'],
      nome: map['nome'],
    );
  }
}
