import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/marca_entity.dart';

part 'marca_event.freezed.dart';

@freezed
class MarcaEvent with _$MarcaEvent {
  const factory MarcaEvent.save({required Marca marca, String? id}) = _Save;
}