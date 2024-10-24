class Gleba {
  int? id;
  String nomeIdentificador;
  double area;
  int? cultivarId;

  Gleba({
    this.id,
    required this.nomeIdentificador,
    required this.area,
    this.cultivarId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nomeIdentificador': nomeIdentificador,
      'area': area,
      'cultivar_id': cultivarId, // Apenas cultivar_id é necessário
    };
  }

  factory Gleba.fromMap(Map<String, dynamic> map) {
    return Gleba(
      id: map['id'],
      nomeIdentificador: map['nomeIdentificador'],
      area: map['area'],
      cultivarId: map['cultivar_id'],
    );
  }
}
