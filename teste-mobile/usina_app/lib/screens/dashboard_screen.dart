import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/domain.dart';
import '../widgets/indicador_card.dart';

class DashboardScreen extends StatefulWidget {
  final DashboardExtracao dashboard;

  const DashboardScreen({super.key, required this.dashboard});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TipoPeriodo periodo = TipoPeriodo.dia;

  @override
  Widget build(BuildContext context) {
    final medicoes = widget.dashboard.filtrarPorPeriodo(periodo);
    final resumo = widget.dashboard.calcularResumoStatus();
    return Scaffold(
      body: Stack(
        children: [
          const _AmbientBackground(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 34),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _TopBar(safra: widget.dashboard.safra),
                      const SizedBox(height: 28),
                      _Intro(safra: widget.dashboard.safra),
                      const SizedBox(height: 22),
                      _PeriodFilter(value: periodo, onChanged: (value) => setState(() => periodo = value)),
                      const SizedBox(height: 22),
                      _SummaryCard(resumo: resumo, total: widget.dashboard.medicoes.length),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('indicadores', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w600, letterSpacing: -.5)),
                            SizedBox(height: 4),
                            Text('leitura em tempo quase real', style: TextStyle(color: Color(0xffa99eae), fontSize: 12)),
                          ]),
                          Text('${medicoes.length.toString().padLeft(2, '0')} sinais', style: const TextStyle(color: Color(0xffe7a7bc), fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 13),
                      ...medicoes.map((medicao) {
                        final indicador = widget.dashboard.indicadores.firstWhere((item) => item.tipoInformacao.id == medicao.tipoInformacao.id);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 13),
                          child: IndicadorCard(indicador: indicador, medicao: medicao),
                        );
                      }),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xff28172b), Color(0xff100d16), Color(0xff171327)]),
        ),
        child: Stack(children: [
          Positioned(top: -80, right: -45, child: _Glow(size: 210, color: Color(0xffe36f9a))),
          Positioned(top: 420, left: -105, child: _Glow(size: 250, color: Color(0xff7c6de5))),
        ]),
      );
}

class _Glow extends StatelessWidget {
  final double size;
  final Color color;
  const _Glow({required this.size, required this.color});
  @override
  Widget build(BuildContext context) => Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: .12), boxShadow: [BoxShadow(color: color.withValues(alpha: .2), blurRadius: 100, spreadRadius: 25)]));
}

class _TopBar extends StatelessWidget {
  final Safra safra;
  const _TopBar({required this.safra});
  @override
  Widget build(BuildContext context) => Row(children: [
        Container(width: 38, height: 38, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .08), borderRadius: BorderRadius.circular(13), border: Border.all(color: Colors.white.withValues(alpha: .14))), child: const Icon(Icons.water_drop_outlined, size: 19, color: Color(0xfff2a5bd))),
        const SizedBox(width: 11),
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('usina aurora', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)), Text('painel de extração', style: TextStyle(color: Color(0xffa99eae), fontSize: 11))]),
        const Spacer(),
        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9), decoration: BoxDecoration(color: const Color(0xffe5a2bb).withValues(alpha: .12), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xffe5a2bb).withValues(alpha: .22))), child: Row(children: [Container(width: 6, height: 6, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xff91dfb7))), const SizedBox(width: 7), Text('online', style: TextStyle(color: const Color(0xfff1c9d7), fontSize: 11, fontWeight: FontWeight.w600))])),
      ]);
}

class _Intro extends StatelessWidget {
  final Safra safra;
  const _Intro({required this.safra});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('bom dia, operação.', style: TextStyle(color: Color(0xfff0dbe3), fontSize: 14)),
        const SizedBox(height: 7),
        const Text('o campo em números,\nsem complicar.', style: TextStyle(fontSize: 30, height: 1.07, fontWeight: FontWeight.w600, letterSpacing: -1.1)),
        const SizedBox(height: 13),
        Row(children: [const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xffe7a7bc)), const SizedBox(width: 7), Text('${safra.nomeSafra}  ·  ${safra.diasRestantes()} dias restantes', style: const TextStyle(color: Color(0xffb9acb8), fontSize: 12))]),
      ]);
}

class _PeriodFilter extends StatelessWidget {
  final TipoPeriodo value;
  final ValueChanged<TipoPeriodo> onChanged;
  const _PeriodFilter({required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) => Row(children: TipoPeriodo.values.map((item) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 7), child: GestureDetector(onTap: () => onChanged(item), child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: value == item ? const Color(0xffe7a7bc) : Colors.white.withValues(alpha: .06), borderRadius: BorderRadius.circular(12), border: Border.all(color: value == item ? const Color(0xffe7a7bc) : Colors.white.withValues(alpha: .09))), child: Center(child: Text(item.name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: value == item ? const Color(0xff261722) : const Color(0xffbdb0bd))))))))).toList());
}

class _SummaryCard extends StatelessWidget {
  final Map<StatusIndicador, int> resumo;
  final int total;
  const _SummaryCard({required this.resumo, required this.total});
  @override
  Widget build(BuildContext context) => ClipRRect(borderRadius: BorderRadius.circular(24), child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18), child: Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.white.withValues(alpha: .12), Colors.white.withValues(alpha: .035)]), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withValues(alpha: .13))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [const Text('resumo operacional', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)), const Spacer(), Text('$total leituras', style: const TextStyle(color: Color(0xffa99eae), fontSize: 11))]), const SizedBox(height: 17), Row(children: [_StatusPill(label: 'dentro da meta', value: resumo[StatusIndicador.dentroMeta] ?? 0, color: const Color(0xff91dfb7)), _StatusPill(label: 'atenção', value: resumo[StatusIndicador.atencao] ?? 0, color: const Color(0xfff2c476)), _StatusPill(label: 'fora', value: resumo[StatusIndicador.foraMeta] ?? 0, color: const Color(0xffec8fa9))])]))));
}

class _StatusPill extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _StatusPill({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) => Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value.toString().padLeft(2, '0'), style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w600)), const SizedBox(height: 3), Text(label, style: const TextStyle(color: Color(0xffb9acb8), fontSize: 10))]));
}
