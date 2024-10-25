class Aplicacao {
  int? id;
  DateTime datetime;
  double volumeCalda;
  double volumeProduto;
  String motivo;
  int glebaId;
  int produtoId;
  int? doencaPragaId;
  int cicloId;
  // Adicionando o campo para armazenar o nome do produto
  String? produtoNomeComercial;

  Aplicacao({
    this.id,
    required this.datetime,
    required this.volumeCalda,
    required this.volumeProduto,
    required this.motivo,
    required this.glebaId,
    required this.produtoId,
    this.doencaPragaId,
    required this.cicloId,
  });

  // Converter um Aplicacao para um Map (para inserir no banco de dados)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'datetime': datetime.toIso8601String(),
      'volumeCalda': volumeCalda,
      'volumeProduto': volumeProduto,
      'motivo': motivo,
      'gleba_id': glebaId,
      'produto_id': produtoId,
      'doencaPraga_id': doencaPragaId,
      'ciclo_id': cicloId,
    };
  }

  // Criar um Aplicacao a partir de um Map (para recuperar do banco de dados)
  factory Aplicacao.fromMap(Map<String, dynamic> map) {
    return Aplicacao(
      id: map['id'],
      datetime: DateTime.parse(map['datetime']),
      volumeCalda: map['volumeCalda'],
      volumeProduto: map['volumeProduto'],
      motivo: map['motivo'],
      glebaId: map['gleba_id'],
      produtoId: map['produto_id'],
      doencaPragaId: map['doencaPraga_id'],
      cicloId: map['ciclo_id'],
    );
  }
}
