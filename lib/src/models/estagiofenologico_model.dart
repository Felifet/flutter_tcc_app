class EstagioFenologico {
  int? id;
  String descricao;

  EstagioFenologico({this.id, required this.descricao});

  // Construtor para criar um objeto a partir de um map
  factory EstagioFenologico.fromMap(Map<String, dynamic> map) {
    return EstagioFenologico(
      id: map['id'],
      descricao: map['descricao'],
    );
  }

  // Converte o objeto em um map para salvar no banco de dados
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'descricao': descricao,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
