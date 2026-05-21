class Modelo {
  final String? id;
  final String nome;
  final String? marcaId;

  Modelo({this.id, required this.nome, this.marcaId});

  Modelo copyWith({String? id, String? nome, String? marcaId}) {
    return Modelo(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      marcaId: marcaId ?? this.marcaId,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome, 'marcaId': marcaId};
  }

  factory Modelo.fromJson(Map<String, dynamic> json) {
    return Modelo(
      id: json['id'] as String?,
      nome: json['nome'] as String,
      marcaId: json['marcaId'] as String?,
    );
  }
}