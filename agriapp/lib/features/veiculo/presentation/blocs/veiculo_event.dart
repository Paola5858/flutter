import 'package:equatable/equatable.dart';

abstract class VeiculoEvent extends Equatable {
  const VeiculoEvent();

  @override
  List<Object> get props => [];
}

class FetchVeiculosEvent extends VeiculoEvent {}
