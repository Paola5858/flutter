import 'package:equatable/equatable.dart';
import '../../domain/entities/veiculo_entity.dart';

abstract class VeiculoState extends Equatable {
  const VeiculoState();

  @override
  List<Object> get props => [];
}

class VeiculoInitial extends VeiculoState {}

class VeiculoLoading extends VeiculoState {}

class VeiculoLoaded extends VeiculoState {
  final List<VeiculoEntity> veiculos;

  const VeiculoLoaded(this.veiculos);

  @override
  List<Object> get props => [veiculos];
}

class VeiculoError extends VeiculoState {
  final String message;

  const VeiculoError(this.message);

  @override
  List<Object> get props => [message];
}
