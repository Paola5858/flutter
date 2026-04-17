import 'package:equatable/equatable.dart';

class VeiculoEntity extends Equatable {
  final String id;
  final String placa;
  final String marca;

  const VeiculoEntity({
    required this.id,
    required this.placa,
    required this.marca,
  });

  @override
  List<Object> get props => [id, placa, marca];
}
