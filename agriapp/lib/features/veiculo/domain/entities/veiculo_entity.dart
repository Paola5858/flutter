import 'package:equatable/equatable.dart';

class VeiculoEntity extends Equatable {
  final int? id;
  final String descricao;
  final int marcaId;
  final int modeloId;
  final int ano;
  final int horimetro;

  const VeiculoEntity({
    this.id,
    required this.descricao,
    required this.marcaId,
    required this.modeloId,
    required this.ano,
    required this.horimetro,
  });

  @override
  List<Object?> get props => [id, descricao, marcaId, modeloId, ano, horimetro];
}
