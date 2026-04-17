// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'veiculo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VeiculoModel _$VeiculoModelFromJson(Map<String, dynamic> json) => VeiculoModel(
  id: (json['id'] as num?)?.toInt(),
  descricao: json['descricao'] as String,
  marcaId: (json['marca_id'] as num).toInt(),
  modeloId: (json['modelo_id'] as num).toInt(),
  ano: (json['ano'] as num).toInt(),
  horimetro: (json['horimetro'] as num).toInt(),
);

Map<String, dynamic> _$VeiculoModelToJson(VeiculoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'descricao': instance.descricao,
      'marca_id': instance.marcaId,
      'modelo_id': instance.modeloId,
      'ano': instance.ano,
      'horimetro': instance.horimetro,
    };
