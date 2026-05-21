import 'package:equatable/equatable.dart';

class VeiculoEntity extends Equatable {
  final String id;
  final String placa;
  final String marca;
  final String? descricao;
  final int? ano;
  final int? horimetro;
  final String? marcaId;
  final String? modeloId;

  const VeiculoEntity({
    required this.id,
    required this.placa,
    required this.marca,
    this.descricao,
    this.ano,
    this.horimetro,
    this.marcaId,
    this.modeloId,
  });

  @override
  List<Object> get props => [id, placa, marca];
}
