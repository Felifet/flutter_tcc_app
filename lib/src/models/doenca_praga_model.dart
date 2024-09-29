class DoencaPraga {
  final int? id; // Pode ser nullable se for opcional
  final String descricaoCurta;
  final String? descricaoLonga;

  DoencaPraga({
    this.id, // Removido o required para permitir criação sem ID
    required this.descricaoCurta,
    this.descricaoLonga,
  });

  // Converte um Map para uma instância de DoencaPraga
  factory DoencaPraga.fromMap(Map<String, dynamic> map) {
    return DoencaPraga(
      id: map['id'],
      descricaoCurta: map['descricaoCurta'],
      descricaoLonga: map['descricaoLonga'],
    );
  }

  // Converte uma instância de DoencaPraga para um Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descricaoCurta': descricaoCurta,
      'descricaoLonga': descricaoLonga,
    };
  }
}
