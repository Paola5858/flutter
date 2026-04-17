import 'package:json_annotation/json_annotation.dart';

part 'veiculo_model.g.dart';

@JsonSerializable()
class VeiculoModel {
  final int? id;
  final String descricao;
  @JsonKey(name: 'marca_id')
  final int marcaId;
  @JsonKey(name: 'modelo_id')
  final int modeloId;
  final int ano;
  final int horimetro;

  VeiculoModel({
    this.id,
    required this.descricao,
    required this.marcaId,
    required this.modeloId,
    required this.ano,
    required this.horimetro,
  });

  factory VeiculoModel.fromJson(Map<String, dynamic> json) =>
      _$VeiculoModelFromJson(json);

  Map<String, dynamic> toJson() => _$VeiculoModelToJson(this);
}
