class Marca {
  final String? id;
  final String nome;

  Marca({this.id, required this.nome});

  Marca copyWith({String? id, String? nome}) {
    return Marca(id: id ?? this.id, nome: nome ?? this.nome);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome};
  }

  factory Marca.fromJson(Map<String, dynamic> json) {
    return Marca(id: json['id'] as String?, nome: json['nome'] as String);
  }
}
