class Veiculo {
  final int? id;
  final String descricao;
  final int marcaId;
  final int modeloId;
  final int ano;
  final int horimetro;


  Veiculo({
    this.id,
    required this.descricao,
    required this.marcaId,
    required this.modeloId,
    required this.ano,
    required this.horimetro,
  });

  factory Veiculo.fromJson(Map<String, dynamic> json) {
    return Veiculo(
      id: json['id'],
      descricao: json['descricao'],
      marcaId: json['marca_id'],
      modeloId: json['modelo_id'],
      ano: json['ano'],
      horimetro: json['horimetro'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descricao': descricao,
      'marca_id': marcaId,
      'modelo_id': modeloId,
      'ano': ano,
      'horimetro': horimetro,
    };
  }
}