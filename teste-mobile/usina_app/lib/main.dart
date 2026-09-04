import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'models/domain.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(UsinaApp(dashboard: criarDashboardDemo()));
}

DashboardExtracao criarDashboardDemo() {
  final agora = DateTime.now();
  const usina = Usina(
    id: 1,
    nome: 'usina aurora',
    localizacao: 'sertão nordestino',
  );
  const unidade = Unidade(id: 1, nome: 'extração principal', usina: usina);
  const equipamento = Equipamento(
    id: 1,
    nome: 'linha de moagem 01',
    unidade: unidade,
  );
  final safra = Safra(
    id: 1,
    nomeSafra: 'safra 2026',
    dataInicio: DateTime(2026, 4, 1),
    dataFim: DateTime(2026, 11, 30),
  );
  const tonelada = UnidadeMedida(id: 1, nome: 'tonelada', simbolo: 't');
  const celsius = UnidadeMedida(id: 2, nome: 'graus celsius', simbolo: '°c');
  const percentual = UnidadeMedida(id: 3, nome: 'percentual', simbolo: '%');
  const producao = TipoInformacao(
    id: 1,
    nome: 'produção de açúcar',
    unidadeMedida: tonelada,
  );
  const temperatura = TipoInformacao(
    id: 2,
    nome: 'temperatura',
    unidadeMedida: celsius,
  );
  const umidade = TipoInformacao(
    id: 3,
    nome: 'umidade',
    unidadeMedida: percentual,
  );
  const indicadores = [
    Indicador(
      id: 1,
      nome: 'produção de açúcar',
      descricao: 'volume produzido no turno atual',
      url: '',
      tipoInformacao: producao,
      metaValor: 800,
      comparacaoIdeal: TipoComparacao.maiorMelhor,
    ),
    Indicador(
      id: 2,
      nome: 'temperatura',
      descricao: 'temperatura média da linha',
      url: '',
      tipoInformacao: temperatura,
      metaValor: 72,
      comparacaoIdeal: TipoComparacao.menorMelhor,
    ),
    Indicador(
      id: 3,
      nome: 'umidade',
      descricao: 'nível de umidade da matéria-prima',
      url: '',
      tipoInformacao: umidade,
      metaValor: 58,
      comparacaoIdeal: TipoComparacao.faixaIdeal,
    ),
  ];
  return DashboardExtracao(
    safra: safra,
    indicadores: indicadores,
    medicoes: [
      Medicao(
        id: 1,
        safra: safra,
        equipamento: equipamento,
        tipoInformacao: producao,
        valor: 850.5,
        data: agora,
        periodo: TipoPeriodo.dia,
      ),
      Medicao(
        id: 2,
        safra: safra,
        equipamento: equipamento,
        tipoInformacao: temperatura,
        valor: 75.2,
        data: agora.subtract(const Duration(minutes: 8)),
        periodo: TipoPeriodo.dia,
      ),
      Medicao(
        id: 3,
        safra: safra,
        equipamento: equipamento,
        tipoInformacao: umidade,
        valor: 60,
        data: agora.subtract(const Duration(minutes: 14)),
        periodo: TipoPeriodo.dia,
      ),
    ],
  );
}

class UsinaApp extends StatelessWidget {
  final DashboardExtracao dashboard;

  const UsinaApp({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'usina aurora',
      theme: AppTheme.dark,
      home: DashboardScreen(dashboard: dashboard),
    );
  }
}
