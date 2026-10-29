class Safra {
  final int? id;
  final String nomeSafra;
  final DateTime dataInicio;
  final DateTime dataFim;

  const Safra({this.id, required this.nomeSafra, required this.dataInicio, required this.dataFim});

  factory Safra.fromJson(Map<String, dynamic> json) => Safra(
        id: _int(json['Id'] ?? json['id']),
        nomeSafra: _string(json['NomeSafra'] ?? json['nomeSafra']),
        dataInicio: DateTime.parse(_string(json['DataInicio'] ?? json['dataInicio'])),
        dataFim: DateTime.parse(_string(json['DataFim'] ?? json['dataFim'])),
      );

  Map<String, dynamic> toJson() => {
        'NomeSafra': nomeSafra,
        'DataInicio': _date(dataInicio),
        'DataFim': _date(dataFim),
      };
}

class Unidade {
  final int? id;
  final String nome;
  const Unidade({this.id, required this.nome});
  factory Unidade.fromJson(Map<String, dynamic> json) => Unidade(id: _int(json['Id'] ?? json['id']), nome: _string(json['Nome'] ?? json['nome']));
  Map<String, dynamic> toJson() => {'Nome': nome};
}

class UnidadeMedida {
  final int? id;
  final String nome;
  final String simbolo;
  const UnidadeMedida({this.id, required this.nome, required this.simbolo});
  factory UnidadeMedida.fromJson(Map<String, dynamic> json) => UnidadeMedida(id: _int(json['Id'] ?? json['id']), nome: _string(json['Nome'] ?? json['nome']), simbolo: _string(json['Simbolo'] ?? json['simbolo']));
  Map<String, dynamic> toJson() => {'Nome': nome, 'Simbolo': simbolo};
}

class Equipamento {
  final int? id;
  final String nome;
  final int unidadeId;
  const Equipamento({this.id, required this.nome, required this.unidadeId});
  factory Equipamento.fromJson(Map<String, dynamic> json) => Equipamento(id: _int(json['Id'] ?? json['id']), nome: _string(json['Nome'] ?? json['nome']), unidadeId: _int(json['UnidadeId'] ?? json['unidadeId']) ?? 0);
  Map<String, dynamic> toJson() => {'Nome': nome, 'UnidadeId': unidadeId};
}

class TipoInformacao {
  final int? id;
  final String nome;
  final int unidadeMedidaId;
  const TipoInformacao({this.id, required this.nome, required this.unidadeMedidaId});
  factory TipoInformacao.fromJson(Map<String, dynamic> json) => TipoInformacao(id: _int(json['Id'] ?? json['id']), nome: _string(json['Nome'] ?? json['nome']), unidadeMedidaId: _int(json['UnidadeMedidaId'] ?? json['unidadeMedidaId']) ?? 0);
  Map<String, dynamic> toJson() => {'Nome': nome, 'UnidadeMedidaId': unidadeMedidaId};
}

class Medicao {
  final int? id;
  final int safraId;
  final int equipamentoId;
  final int tipoInformacaoId;
  final double valor;
  final DateTime data;
  const Medicao({this.id, required this.safraId, required this.equipamentoId, required this.tipoInformacaoId, required this.valor, required this.data});
  factory Medicao.fromJson(Map<String, dynamic> json) => Medicao(id: _int(json['Id'] ?? json['id']), safraId: _int(json['SafraId'] ?? json['safraId']) ?? 0, equipamentoId: _int(json['EquipamentoId'] ?? json['equipamentoId']) ?? 0, tipoInformacaoId: _int(json['TipoInformacaoId'] ?? json['tipoInformacaoId']) ?? 0, valor: _double(json['Valor'] ?? json['valor']), data: DateTime.parse(_string(json['Data'] ?? json['data'])));
  Map<String, dynamic> toJson() => {'SafraId': safraId, 'EquipamentoId': equipamentoId, 'TipoInformacaoId': tipoInformacaoId, 'Valor': valor, 'Data': data.toIso8601String()};
}

int? _int(dynamic value) => value is num ? value.toInt() : int.tryParse(value?.toString() ?? '');
double _double(dynamic value) => value is num ? value.toDouble() : double.tryParse(value?.toString().replaceAll(',', '.') ?? '') ?? 0;
String _string(dynamic value) => value?.toString() ?? '';
String _date(DateTime value) => value.toIso8601String().substring(0, 10);
