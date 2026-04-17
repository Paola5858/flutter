import 'package:freezed_annotation/freezed_annotation.dart';

part 'veiculo_event.freezed.dart';

@freezed
class VeiculoEvent with _$VeiculoEvent {
  const factory VeiculoEvent.fetchVeiculos() = FetchVeiculos;
}
