import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/veiculo_entity.dart';

part 'veiculo_state.freezed.dart';

@freezed
class VeiculoState with _$VeiculoState {
  const factory VeiculoState.initial() = _Initial;
  const factory VeiculoState.loading() = _Loading;
  const factory VeiculoState.loaded(List<VeiculoEntity> veiculos) = _Loaded;
  const factory VeiculoState.error(String message) = _Error;
}
