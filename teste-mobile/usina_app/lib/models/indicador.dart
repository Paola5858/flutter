class Indicador {
  final int id;
  final String nome;
  final double valor;
  final String unidade;
  final DateTime data;

  const Indicador({
    required this.id,
    required this.nome,
    required this.valor,
    required this.unidade,
    required this.data,
  });

  Indicador copyWith({
    int? id,
    String? nome,
    double? valor,
    String? unidade,
    DateTime? data,
  }) {
    return Indicador(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      valor: valor ?? this.valor,
      unidade: unidade ?? this.unidade,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'valor': valor,
        'unidade': unidade,
        'data': data.toIso8601String(),
      };

  factory Indicador.fromMap(Map<String, dynamic> map) => Indicador(
        id: map['id'] as int,
        nome: map['nome'] as String,
        valor: (map['valor'] as num).toDouble(),
        unidade: map['unidade'] as String,
        data: DateTime.parse(map['data'] as String),
      );

  @override
  String toString() => 'Indicador(id: $id, nome: $nome, valor: $valor $unidade, data: $data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Indicador && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
