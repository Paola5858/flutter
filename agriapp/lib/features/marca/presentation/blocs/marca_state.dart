import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/marca_entity.dart';

part 'marca_state.freezed.dart';

@freezed
class MarcaState with _$MarcaState {
  const factory MarcaState.initial() = _Initial;
  const factory MarcaState.loading() = _Loading;
  const factory MarcaState.success(Marca marca) = _Success;
  const factory MarcaState.error(String message) = _Error;
}