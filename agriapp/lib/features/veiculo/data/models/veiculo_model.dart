import 'package:json_annotation/json_annotation.dart';

part 'veiculo_model.g.dart';

@JsonSerializable()
class VeiculoModel {
  final String id;
  final String placa;
  final String marca;

  VeiculoModel({required this.id, required this.placa, required this.marca});

  factory VeiculoModel.fromJson(Map<String, dynamic> json) =>
      _$VeiculoModelFromJson(json);

  Map<String, dynamic> toJson() => _$VeiculoModelToJson(this);
}
