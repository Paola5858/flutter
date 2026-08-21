enum TipoComparacao { maiorMelhor, menorMelhor, faixaIdeal }

enum TipoPeriodo { dia, semana, mes, safra }

enum StatusIndicador { dentroMeta, foraMeta, atencao }

class Usina {
  final int id;
  final String nome;
  final String localizacao;

  const Usina({required this.id, required this.nome, required this.localizacao});

  factory Usina.fromJson(Map<String, dynamic> json) => Usina(
        id: json['id'] as int,
        nome: json['nome'] as String,
        localizacao: json['localizacao'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'localizacao': localizacao,
      };
}

class Unidade {
  final int id;
  final String nome;
  final Usina usina;

  const Unidade({required this.id, required this.nome, required this.usina});

  factory Unidade.fromJson(Map<String, dynamic> json) => Unidade(
        id: json['id'] as int,
        nome: json['nome'] as String,
        usina: Usina.fromJson(Map<String, dynamic>.from(json['usina'] as Map)),
      );

  Map<String, dynamic> toJson() => {'id': id, 'nome': nome, 'usina': usina.toJson()};
}

class Equipamento {
  final int id;
  final String nome;
  final Unidade unidade;

  const Equipamento({required this.id, required this.nome, required this.unidade});

  factory Equipamento.fromJson(Map<String, dynamic> json) => Equipamento(
        id: json['id'] as int,
        nome: json['nome'] as String,
        unidade: Unidade.fromJson(Map<String, dynamic>.from(json['unidade'] as Map)),
      );

  Map<String, dynamic> toJson() => {'id': id, 'nome': nome, 'unidade': unidade.toJson()};
}

class Safra {
  final int id;
  final String nomeSafra;
  final DateTime dataInicio;
  final DateTime dataFim;

  const Safra({required this.id, required this.nomeSafra, required this.dataInicio, required this.dataFim});

  int diasRestantes([DateTime? hoje]) {
    final dias = dataFim.difference(hoje ?? DateTime.now()).inDays;
    return dias < 0 ? 0 : dias;
  }

  factory Safra.fromJson(Map<String, dynamic> json) => Safra(
        id: json['id'] as int,
        nomeSafra: json['nomeSafra'] as String,
        dataInicio: DateTime.parse(json['dataInicio'] as String),
        dataFim: DateTime.parse(json['dataFim'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nomeSafra': nomeSafra,
        'dataInicio': dataInicio.toIso8601String(),
        'dataFim': dataFim.toIso8601String(),
      };
}

class UnidadeMedida {
  final int id;
  final String nome;
  final String simbolo;

  const UnidadeMedida({required this.id, required this.nome, required this.simbolo});

  factory UnidadeMedida.fromJson(Map<String, dynamic> json) => UnidadeMedida(
        id: json['id'] as int,
        nome: json['nome'] as String,
        simbolo: json['simbolo'] as String,
      );

  Map<String, dynamic> toJson() => {'id': id, 'nome': nome, 'simbolo': simbolo};
}

class TipoInformacao {
  final int id;
  final String nome;
  final UnidadeMedida unidadeMedida;

  const TipoInformacao({required this.id, required this.nome, required this.unidadeMedida});

  factory TipoInformacao.fromJson(Map<String, dynamic> json) => TipoInformacao(
        id: json['id'] as int,
        nome: json['nome'] as String,
        unidadeMedida: UnidadeMedida.fromJson(Map<String, dynamic>.from(json['unidadeMedida'] as Map)),
      );

  Map<String, dynamic> toJson() => {'id': id, 'nome': nome, 'unidadeMedida': unidadeMedida.toJson()};
}

class Indicador {
  final int id;
  final String nome;
  final String descricao;
  final String url;
  final TipoInformacao tipoInformacao;
  final double metaValor;
  final TipoComparacao comparacaoIdeal;

  const Indicador({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.url,
    required this.tipoInformacao,
    required this.metaValor,
    required this.comparacaoIdeal,
  });

  bool avaliar(double valor) {
    switch (comparacaoIdeal) {
      case TipoComparacao.maiorMelhor:
        return valor >= metaValor;
      case TipoComparacao.menorMelhor:
        return valor <= metaValor;
      case TipoComparacao.faixaIdeal:
        return (valor - metaValor).abs() <= metaValor * .05;
    }
  }

  factory Indicador.fromJson(Map<String, dynamic> json) => Indicador(
        id: json['id'] as int,
        nome: json['nome'] as String,
        descricao: json['descricao'] as String? ?? '',
        url: json['url'] as String? ?? '',
        tipoInformacao: TipoInformacao.fromJson(Map<String, dynamic>.from(json['tipoInformacao'] as Map)),
        metaValor: (json['metaValor'] as num).toDouble(),
        comparacaoIdeal: TipoComparacao.values.byName(json['comparacaoIdeal'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'descricao': descricao,
        'url': url,
        'tipoInformacao': tipoInformacao.toJson(),
        'metaValor': metaValor,
        'comparacaoIdeal': comparacaoIdeal.name,
      };
}

class Medicao {
  final int id;
  final Safra safra;
  final Equipamento equipamento;
  final TipoInformacao tipoInformacao;
  final double valor;
  final DateTime data;
  final TipoPeriodo periodo;

  const Medicao({required this.id, required this.safra, required this.equipamento, required this.tipoInformacao, required this.valor, required this.data, required this.periodo});

  StatusIndicador calcularStatus(Indicador indicador) {
    final distancia = indicador.metaValor == 0 ? 0 : ((valor - indicador.metaValor).abs() / indicador.metaValor);
    if (indicador.avaliar(valor)) return StatusIndicador.dentroMeta;
    return distancia <= .12 ? StatusIndicador.atencao : StatusIndicador.foraMeta;
  }

  double calcularVariacao(Medicao anterior) => anterior.valor == 0 ? 0 : ((valor - anterior.valor) / anterior.valor) * 100;

  factory Medicao.fromJson(Map<String, dynamic> json) => Medicao(
        id: json['id'] as int,
        safra: Safra.fromJson(Map<String, dynamic>.from(json['safra'] as Map)),
        equipamento: Equipamento.fromJson(Map<String, dynamic>.from(json['equipamento'] as Map)),
        tipoInformacao: TipoInformacao.fromJson(Map<String, dynamic>.from(json['tipoInformacao'] as Map)),
        valor: (json['valor'] as num).toDouble(),
        data: DateTime.parse(json['data'] as String),
        periodo: TipoPeriodo.values.byName(json['periodo'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'safra': safra.toJson(),
        'equipamento': equipamento.toJson(),
        'tipoInformacao': tipoInformacao.toJson(),
        'valor': valor,
        'data': data.toIso8601String(),
        'periodo': periodo.name,
      };
}

class DashboardExtracao {
  final Safra safra;
  final List<Medicao> medicoes;
  final List<Indicador> indicadores;

  const DashboardExtracao({required this.safra, required this.medicoes, required this.indicadores});

  List<Medicao> filtrarPorPeriodo(TipoPeriodo periodo) => medicoes.where((medicao) => medicao.periodo == periodo).toList();

  Medicao obterIndicadorPrincipal() => medicoes.reduce((a, b) => a.valor >= b.valor ? a : b);

  Map<StatusIndicador, int> calcularResumoStatus() {
    final resumo = {for (final status in StatusIndicador.values) status: 0};
    for (final medicao in medicoes) {
      final indicador = indicadores.firstWhere((item) => item.tipoInformacao.id == medicao.tipoInformacao.id, orElse: () => indicadores.first);
      resumo[medicao.calcularStatus(indicador)] = resumo[medicao.calcularStatus(indicador)]! + 1;
    }
    return resumo;
  }
}

class Motor {
  final int id;
  final String nome;
  final Equipamento equipamento;

  const Motor({required this.id, required this.nome, required this.equipamento});
}

class Sensor {
  final int id;
  final String nome;
  final TipoInformacao tipoInformacao;

  const Sensor({required this.id, required this.nome, required this.tipoInformacao});
}

class SensorDoMotor {
  final Motor motor;
  final Sensor sensor;
  final DateTime instaladoEm;

  const SensorDoMotor({required this.motor, required this.sensor, required this.instaladoEm});
}

class RegistroDeEnvioDeDadosDosSensores {
  final int id;
  final SensorDoMotor sensorDoMotor;
  final double valor;
  final DateTime enviadoEm;

  const RegistroDeEnvioDeDadosDosSensores({required this.id, required this.sensorDoMotor, required this.valor, required this.enviadoEm});

  Map<String, dynamic> toJson() => {'id': id, 'valor': valor, 'enviadoEm': enviadoEm.toIso8601String()};
}
