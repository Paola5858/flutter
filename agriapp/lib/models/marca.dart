class Marca {
  final int? id;
  final String nome;

  Marca({this.id, required this.nome});

  factory Marca.fromJson(Map<String, dynamic> json) {
    return Marca(
      id: json['id'],
      nome: json['nome'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'nome': nome};
  }
}