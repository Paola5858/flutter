import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/veiculo_entity.dart';

part 'veiculo_event.freezed.dart';

@freezed
class VeiculoEvent with _$VeiculoEvent {
  const factory VeiculoEvent.refresh() = _Refresh;
  const factory VeiculoEvent.create(VeiculoEntity veiculo) = _Create;
  const factory VeiculoEvent.update(VeiculoEntity veiculo) = _Update;
  const factory VeiculoEvent.delete(String id) = _Delete;
}
