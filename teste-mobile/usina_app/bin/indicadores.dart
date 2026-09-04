import 'package:usina_app/models/domain.dart';

void main() {
  final agora = DateTime.now();
  const usina = Usina(id: 1, nome: 'usina aurora', localizacao: 'sertão nordestino');
  const unidade = Unidade(id: 1, nome: 'extração principal', usina: usina);
  const equipamento = Equipamento(id: 1, nome: 'linha de moagem 01', unidade: unidade);
  final safra = Safra(id: 1, nomeSafra: 'safra 2026', dataInicio: DateTime(2026, 4, 1), dataFim: DateTime(2026, 11, 30));
  const tonelada = UnidadeMedida(id: 1, nome: 'tonelada', simbolo: 't');
  const celsius = UnidadeMedida(id: 2, nome: 'graus celsius', simbolo: '°c');
  const percentual = UnidadeMedida(id: 3, nome: 'percentual', simbolo: '%');
  const producao = TipoInformacao(id: 1, nome: 'produção de açúcar', unidadeMedida: tonelada);
  const temperatura = TipoInformacao(id: 2, nome: 'temperatura', unidadeMedida: celsius);
  const umidade = TipoInformacao(id: 3, nome: 'umidade', unidadeMedida: percentual);
  const indicadores = [
    Indicador(id: 1, nome: 'produção de açúcar', descricao: 'volume produzido no turno atual', url: '', tipoInformacao: producao, metaValor: 800, comparacaoIdeal: TipoComparacao.maiorMelhor),
    Indicador(id: 2, nome: 'temperatura', descricao: 'temperatura média da linha', url: '', tipoInformacao: temperatura, metaValor: 72, comparacaoIdeal: TipoComparacao.menorMelhor),
    Indicador(id: 3, nome: 'umidade', descricao: 'nível de umidade da matéria-prima', url: '', tipoInformacao: umidade, metaValor: 58, comparacaoIdeal: TipoComparacao.faixaIdeal),
  ];
  final medicoes = [
    Medicao(id: 1, safra: safra, equipamento: equipamento, tipoInformacao: producao, valor: 850.5, data: agora, periodo: TipoPeriodo.dia),
    Medicao(id: 2, safra: safra, equipamento: equipamento, tipoInformacao: temperatura, valor: 75.2, data: agora.subtract(const Duration(minutes: 8)), periodo: TipoPeriodo.dia),
    Medicao(id: 3, safra: safra, equipamento: equipamento, tipoInformacao: umidade, valor: 60, data: agora.subtract(const Duration(minutes: 14)), periodo: TipoPeriodo.dia),
  ];
  final dashboard = DashboardExtracao(safra: safra, indicadores: indicadores, medicoes: medicoes);

  // Usina / Unidade / Equipamento / Safra
  final eq = medicoes.first.equipamento;
  print('=== USINA ===');
  print('  id: ${eq.unidade.usina.id}  |  nome: ${eq.unidade.usina.nome}  |  localização: ${eq.unidade.usina.localizacao}');
  print('  unidade  → id: ${eq.unidade.id}  |  nome: ${eq.unidade.nome}');
  print('  equipamento → id: ${eq.id}  |  nome: ${eq.nome}');
  print('');
  print('=== SAFRA ===');
  print('  id: ${safra.id}  |  nome: ${safra.nomeSafra}');
  print('  início: ${safra.dataInicio.toLocal().toString().substring(0, 10)}  |  fim: ${safra.dataFim.toLocal().toString().substring(0, 10)}  |  dias restantes: ${safra.diasRestantes()}');
  print('');

  // Indicadores
  print('=== INDICADORES ===');
  for (final ind in indicadores) {
    print('  [${ind.id}] ${ind.nome}');
    print('      descricao : ${ind.descricao}');
    print('      tipo info : ${ind.tipoInformacao.nome}');
    print('      unid medida: ${ind.tipoInformacao.unidadeMedida.nome} (${ind.tipoInformacao.unidadeMedida.simbolo})');
    print('      meta      : ${ind.metaValor} ${ind.tipoInformacao.unidadeMedida.simbolo}  |  comparação: ${ind.comparacaoIdeal.name}');
    print('');
  }

  // Medicoes
  print('=== MEDICOES ===');
  for (final medicao in dashboard.filtrarPorPeriodo(TipoPeriodo.dia)) {
    final indicador = indicadores.firstWhere((i) => i.tipoInformacao.id == medicao.tipoInformacao.id);
    final status = medicao.calcularStatus(indicador);
    final simbolo = medicao.tipoInformacao.unidadeMedida.simbolo;
    final statusLabel = switch (status) {
      StatusIndicador.dentroMeta => 'dentro da meta',
      StatusIndicador.atencao    => 'atencao',
      StatusIndicador.foraMeta   => 'fora da meta',
    };
    print('  [${medicao.id}] ${indicador.nome}');
    print('      safra     : ${medicao.safra.nomeSafra}');
    print('      equipamento: ${medicao.equipamento.nome}');
    print('      unidade   : ${medicao.equipamento.unidade.nome}');
    print('      usina     : ${medicao.equipamento.unidade.usina.nome}');
    print('      tipo info : ${medicao.tipoInformacao.nome} (${medicao.tipoInformacao.unidadeMedida.simbolo})');
    print('      valor     : ${medicao.valor} $simbolo  |  meta: ${indicador.metaValor} $simbolo');
    print('      periodo   : ${medicao.periodo.name}  |  data: ${medicao.data.toLocal().toString().substring(0, 16)}');
    print('      status    : $statusLabel');
    print('');
  }

  // DashboardExtracao resumo
  final resumo = dashboard.calcularResumoStatus();
  print('=== DASHBOARD EXTRACAO — RESUMO ===');
  print('  total medicoes : ${dashboard.medicoes.length}');
  print('  dentro da meta : ${resumo[StatusIndicador.dentroMeta]}');
  print('  atencao        : ${resumo[StatusIndicador.atencao]}');
  print('  fora da meta   : ${resumo[StatusIndicador.foraMeta]}');
}
