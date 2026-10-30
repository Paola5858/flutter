export 'domain.dart';

class IndicadorRest {
  final int? id;
  final String nome;
  final String descricao;
  final String url;

  const IndicadorRest({this.id, required this.nome, required this.descricao, required this.url});

  factory IndicadorRest.fromJson(Map<String, dynamic> json) => IndicadorRest(
        id: _int(json['Id'] ?? json['id']),
        nome: _text(json['Nome'] ?? json['nome']),
        descricao: _text(json['Descricao'] ?? json['descricao']),
        url: _text(json['Url'] ?? json['url']),
      );

  Map<String, dynamic> toJson() => {'Nome': nome, 'Descricao': descricao, 'Url': url};
}

int? _int(dynamic value) => value is num ? value.toInt() : int.tryParse(value?.toString() ?? '');
String _text(dynamic value) => value?.toString() ?? '';
