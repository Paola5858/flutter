import 'dart:ui';
import 'package:flutter/material.dart';
import '../cadastros.dart';
import '../models/domain.dart';
import '../screens/cadastro_screen.dart';
import '../widgets/indicador_card.dart';
import 'cadastros/cadastro_indicador.dart';

class DashboardScreen extends StatefulWidget {
  final DashboardExtracao dashboard;

  const DashboardScreen({super.key, required this.dashboard});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TipoPeriodo periodo = TipoPeriodo.dia;
  String itemSelecionado = 'início';

  @override
  Widget build(BuildContext context) {
    final medicoes = widget.dashboard.filtrarPorPeriodo(periodo);
    final resumo = widget.dashboard.calcularResumoStatus();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            tooltip: 'abrir menu principal',
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'painel de extração',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      drawer: Drawer(
        width: 326,
        backgroundColor: const Color(0xff111a17),
        child: _MenuPrincipal(
          itemSelecionado: itemSelecionado,
          onItemSelected: (item) async {
            Navigator.of(context).pop();
            if (item == 'indicador') {
              setState(() => itemSelecionado = item);
              final indicador = await Navigator.of(context).push<Indicador>(
                MaterialPageRoute(builder: (_) => const CadastroIndicadorPage()),
              );
              if (!mounted || indicador == null) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${indicador.nome} entrou na sua central de indicadores.'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: const Color(0xff2c6149),
                ),
              );
              return;
            }
            final config = cadastros[item];
            if (config != null) {
              setState(() => itemSelecionado = item);
              await Navigator.of(context).push(MaterialPageRoute(builder: (_) => CadastroScreen(config: config)));
              return;
            }
            setState(() => itemSelecionado = item);
          },
        ),
      ),
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
                            Text('leitura em tempo quase real', style: TextStyle(color: Color(0xff9aa9a1), fontSize: 12)),
                          ]),
                          Text('${medicoes.length.toString().padLeft(2, '0')} sinais', style: const TextStyle(color: Color(0xffb8d5a8), fontSize: 12)),
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

class _MenuPrincipal extends StatefulWidget {
  final String itemSelecionado;
  final ValueChanged<String> onItemSelected;

  const _MenuPrincipal({
    required this.itemSelecionado,
    required this.onItemSelected,
  });

  @override
  State<_MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<_MenuPrincipal> {
  bool cadastroAberto = false;

  static const itensCadastro = [
    ('unidade', Icons.account_tree_outlined),
    ('setor', Icons.view_quilt_outlined),
    ('equipamento', Icons.precision_manufacturing_outlined),
    ('indicador', Icons.insights_rounded),
    ('funcionário', Icons.badge_outlined),
    ('tipo de medição', Icons.tune_rounded),
    ('parâmetro', Icons.settings_suggest_outlined),
  ];

  Widget montarMenu() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff172820), Color(0xff101614), Color(0xff0d1211)],
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          children: [
            _MenuHeader(),
            const SizedBox(height: 26),
            const _MenuSectionLabel(label: 'visão geral'),
            const SizedBox(height: 9),
            _MenuItem(
              icon: Icons.grid_view_rounded,
              label: 'início',
              selected: widget.itemSelecionado == 'início',
              onTap: () => widget.onItemSelected('início'),
            ),
            const SizedBox(height: 22),
            const _MenuSectionLabel(label: 'gestão da usina'),
            const SizedBox(height: 9),
            _MenuItem(
              icon: Icons.app_registration_rounded,
              label: 'cadastro',
              selected: cadastroAberto,
              trailing: AnimatedRotation(
                turns: cadastroAberto ? .5 : 0,
                duration: const Duration(milliseconds: 220),
                child: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
              ),
              onTap: () => setState(() => cadastroAberto = !cadastroAberto),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 240),
              crossFadeState: cadastroAberto ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: const EdgeInsets.only(left: 12, top: 8),
                child: Column(
                  children: itensCadastro.map((item) => _MenuSubItem(
                    icon: item.$2,
                    label: item.$1,
                    selected: widget.itemSelecionado == item.$1,
                    onTap: () => widget.onItemSelected(item.$1),
                  )).toList(),
                ),
              ),
              secondChild: const SizedBox.shrink(),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xffb8d5a8).withValues(alpha: .08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xffb8d5a8).withValues(alpha: .14)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.eco_outlined, color: Color(0xffb8d5a8), size: 20),
                  SizedBox(width: 11),
                  Expanded(child: Text('cada dado conta uma história do campo.', style: TextStyle(color: Color(0xffd9e8d2), fontSize: 12, height: 1.3))),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Divider(color: Color(0x1fffffff)),
            const SizedBox(height: 10),
            const Text('usina aurora  ·  safra 2026', style: TextStyle(color: Color(0xff718079), fontSize: 10)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => montarMenu();
}

class _MenuHeader extends StatelessWidget {
  const _MenuHeader();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xff456b4f), Color(0xff294735)]),
      borderRadius: BorderRadius.circular(25),
      border: Border.all(color: const Color(0xffb8d5a8).withValues(alpha: .22)),
      boxShadow: [BoxShadow(color: const Color(0xff8bb77f).withValues(alpha: .13), blurRadius: 28, offset: const Offset(0, 12))],
    ),
    child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        CircleAvatar(radius: 21, backgroundColor: Color(0x28ffffff), child: Icon(Icons.water_drop_outlined, color: Color(0xffe3f1d9), size: 22)),
        Spacer(),
        Icon(Icons.more_horiz_rounded, color: Color(0xffc6dec1)),
      ]),
      SizedBox(height: 22),
      Text('menu principal', style: TextStyle(color: Color(0xfff1f8eb), fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -.4)),
      SizedBox(height: 5),
      Text('controle claro para decisões melhores.', style: TextStyle(color: Color(0xffc6dec1), fontSize: 11)),
    ]),
  );
}

class _MenuSectionLabel extends StatelessWidget {
  final String label;
  const _MenuSectionLabel({required this.label});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(left: 13), child: Text(label, style: const TextStyle(color: Color(0xff75867e), fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.1)));
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Widget? trailing;
  final VoidCallback onTap;
  const _MenuItem({required this.icon, required this.label, required this.selected, required this.onTap, this.trailing});
  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    dense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    tileColor: selected ? const Color(0xffb8d5a8).withValues(alpha: .13) : Colors.transparent,
    leading: Icon(icon, color: selected ? const Color(0xffc7e1b9) : const Color(0xff90a198), size: 21),
    title: Text(label, style: TextStyle(color: selected ? const Color(0xffe8f3e2) : const Color(0xffb7c3bd), fontSize: 13, fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
    trailing: trailing,
  );
}

class _MenuSubItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _MenuSubItem({required this.icon, required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    dense: true,
    contentPadding: const EdgeInsets.only(left: 13, right: 8),
    leading: Icon(icon, color: selected ? const Color(0xffb8d5a8) : const Color(0xff6e7f76), size: 17),
    title: Text(label, style: TextStyle(color: selected ? const Color(0xffdcebd5) : const Color(0xff9aa9a1), fontSize: 12)),
    trailing: selected ? const Icon(Icons.circle, color: Color(0xffb8d5a8), size: 6) : null,
  );
}

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xff172820), Color(0xff0d1211), Color(0xff101614)]),
        ),
        child: Stack(children: [
          Positioned(top: -80, right: -45, child: _Glow(size: 210, color: Color(0xff8bb77f))),
          Positioned(top: 420, left: -105, child: _Glow(size: 250, color: Color(0xff456b4f))),
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
        Container(width: 38, height: 38, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .08), borderRadius: BorderRadius.circular(13), border: Border.all(color: Colors.white.withValues(alpha: .14))), child: const Icon(Icons.water_drop_outlined, size: 19, color: Color(0xffb8d5a8))),
        const SizedBox(width: 11),
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('usina aurora', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)), Text('painel de extração', style: TextStyle(color: Color(0xff9aa9a1), fontSize: 11))]),
        const Spacer(),
        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9), decoration: BoxDecoration(color: const Color(0xffb8d5a8).withValues(alpha: .12), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xffb8d5a8).withValues(alpha: .22))), child: Row(children: [Container(width: 6, height: 6, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xff91dfb7))), const SizedBox(width: 7), Text('online', style: TextStyle(color: const Color(0xffe8f3e2), fontSize: 11, fontWeight: FontWeight.w600))])),
      ]);
}

class _Intro extends StatelessWidget {
  final Safra safra;
  const _Intro({required this.safra});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('bom dia, operação.', style: TextStyle(color: Color(0xffe8f3e2), fontSize: 14)),
        const SizedBox(height: 7),
        const Text('o campo em números,\nsem complicar.', style: TextStyle(fontSize: 30, height: 1.07, fontWeight: FontWeight.w600, letterSpacing: -1.1)),
        const SizedBox(height: 13),
        Row(children: [const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xffb8d5a8)), const SizedBox(width: 7), Text('${safra.nomeSafra}  ·  ${safra.diasRestantes()} dias restantes', style: const TextStyle(color: Color(0xff9aa9a1), fontSize: 12))]),
      ]);
}

class _PeriodFilter extends StatelessWidget {
  final TipoPeriodo value;
  final ValueChanged<TipoPeriodo> onChanged;
  const _PeriodFilter({required this.value, required this.onChanged});
  @override
  Widget build(BuildContext context) => Row(children: TipoPeriodo.values.map((item) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 7), child: GestureDetector(onTap: () => onChanged(item), child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: value == item ? const Color(0xffb8d5a8) : Colors.white.withValues(alpha: .06), borderRadius: BorderRadius.circular(12), border: Border.all(color: value == item ? const Color(0xffb8d5a8) : Colors.white.withValues(alpha: .09))), child: Center(child: Text(item.name, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: value == item ? const Color(0xff261722) : const Color(0xffb7c3bd))))))))).toList());
}

class _SummaryCard extends StatelessWidget {
  final Map<StatusIndicador, int> resumo;
  final int total;
  const _SummaryCard({required this.resumo, required this.total});
  @override
  Widget build(BuildContext context) => ClipRRect(borderRadius: BorderRadius.circular(24), child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18), child: Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.white.withValues(alpha: .12), Colors.white.withValues(alpha: .035)]), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withValues(alpha: .13))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [const Text('resumo operacional', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)), const Spacer(), Text('$total leituras', style: const TextStyle(color: Color(0xff9aa9a1), fontSize: 11))]), const SizedBox(height: 17), Row(children: [_StatusPill(label: 'dentro da meta', value: resumo[StatusIndicador.dentroMeta] ?? 0, color: const Color(0xff91dfb7)), _StatusPill(label: 'atenção', value: resumo[StatusIndicador.atencao] ?? 0, color: const Color(0xfff2c476)), _StatusPill(label: 'fora', value: resumo[StatusIndicador.foraMeta] ?? 0, color: const Color(0xffec8fa9))])]))));
}

class _StatusPill extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _StatusPill({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) => Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value.toString().padLeft(2, '0'), style: TextStyle(color: color, fontSize: 22, fontWeight: FontWeight.w600)), const SizedBox(height: 3), Text(label, style: const TextStyle(color: Color(0xffb9acb8), fontSize: 10))]));
}
