class Product {
  int? id;
  String tipo;
  String nomeComercial;
  String principioAtivo;
  String? classificacaoToxicologica;
  String? formulacao;
  double? dosagemComercial;
  int intervaloDeSeguranca;
  int? vigencia;

  Product({
    this.id,
    required this.tipo,
    required this.nomeComercial,
    required this.principioAtivo,
    this.classificacaoToxicologica,
    this.formulacao,
    this.dosagemComercial,
    required this.intervaloDeSeguranca,
    this.vigencia,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tipo': tipo,
      'nomeComercial': nomeComercial,
      'principioAtivo': principioAtivo,
      'classificacaoToxicologica': classificacaoToxicologica,
      'formulacao': formulacao,
      'dosagemComercial': dosagemComercial,
      'intervaloDeSeguranca': intervaloDeSeguranca,
      'vigencia': vigencia,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      tipo: map['tipo'],
      nomeComercial: map['nomeComercial'],
      principioAtivo: map['principioAtivo'],
      classificacaoToxicologica: map['classificacaoToxicologica'],
      formulacao: map['formulacao'],
      dosagemComercial: map['dosagemComercial'],
      intervaloDeSeguranca: map['intervaloDeSeguranca'],
      vigencia: map['vigencia'],
    );
  }
}
