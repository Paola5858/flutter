import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/theme/app_tokens.dart';
import '../../models/domain.dart';

class CadastroIndicadorPage extends StatefulWidget {
  final ValueChanged<Indicador>? onSaved;

  const CadastroIndicadorPage({super.key, this.onSaved});

  @override
  State<CadastroIndicadorPage> createState() => _CadastroIndicadorPageState();
}

class _CadastroIndicadorPageState extends State<CadastroIndicadorPage> {
  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final descricaoController = TextEditingController();
  final urlController = TextEditingController();
  bool salvando = false;

  @override
  void initState() {
    super.initState();
    nomeController.addListener(_atualizarPreview);
    descricaoController.addListener(_atualizarPreview);
    urlController.addListener(_atualizarPreview);
  }

  void _atualizarPreview() => setState(() {});

  @override
  void dispose() {
    nomeController
      ..removeListener(_atualizarPreview)
      ..dispose();
    descricaoController
      ..removeListener(_atualizarPreview)
      ..dispose();
    urlController
      ..removeListener(_atualizarPreview)
      ..dispose();
    super.dispose();
  }

  String? _validarNome(String? valor) {
    final nome = valor?.trim() ?? '';
    if (nome.isEmpty) return 'dê um nome para esse indicador';
    if (nome.length < 3) return 'use pelo menos 3 caracteres';
    return null;
  }

  String? _validarDescricao(String? valor) {
    final descricao = valor?.trim() ?? '';
    if (descricao.isEmpty) return 'explique o que esse indicador acompanha';
    if (descricao.length < 10) return 'adicione um pouco mais de contexto';
    return null;
  }

  String? _validarUrl(String? valor) {
    final url = valor?.trim() ?? '';
    if (url.isEmpty) return 'informe a url da fonte do indicador';
    final uri = Uri.tryParse(url);
    if (uri == null ||
        !uri.hasScheme ||
        !uri.hasAuthority ||
        uri.scheme != 'https') {
      return 'use uma url https válida';
    }
    return null;
  }

  Future<void> salvar() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(formKey.currentState?.validate() ?? false)) return;

    setState(() => salvando = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));

    final indicador = Indicador(
      id: DateTime.now().millisecondsSinceEpoch,
      nome: nomeController.text.trim().toLowerCase(),
      descricao: descricaoController.text.trim().toLowerCase(),
      url: urlController.text.trim(),
      tipoInformacao: const TipoInformacao(
        id: 99,
        nome: 'indicador personalizado',
        unidadeMedida: UnidadeMedida(id: 99, nome: 'unidade', simbolo: 'u'),
      ),
      metaValor: 0,
      comparacaoIdeal: TipoComparacao.faixaIdeal,
    );

    if (!mounted) return;
    setState(() => salvando = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('indicador cadastrado com sucesso.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.mineralSoft,
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (mounted) Navigator.of(context).pop(indicador);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mineral,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          tooltip: 'voltar ao painel',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'novo indicador',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            tooltip: 'limpar formulário',
            icon: const Icon(Icons.refresh_rounded, size: 20),
            onPressed: () {
              formKey.currentState?.reset();
              nomeController.clear();
              descricaoController.clear();
              urlController.clear();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          const _CadastroBackground(),
          SafeArea(
            top: false,
            child: Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 34),
                children: [
                  const _PageIntro(),
                  const SizedBox(height: 22),
                  _PreviewCard(
                    nome: nomeController.text,
                    descricao: descricaoController.text,
                  ),
                  const SizedBox(height: 24),
                  _SectionLabel(
                    index: '01',
                    title: 'identidade do indicador',
                    caption: 'um nome claro facilita cada decisão depois.',
                  ),
                  const SizedBox(height: 12),
                  _GlassField(
                    controller: nomeController,
                    label: 'nome',
                    hint: 'ex.: eficiência da moagem',
                    icon: Icons.insights_rounded,
                    textInputAction: TextInputAction.next,
                    validator: _validarNome,
                  ),
                  const SizedBox(height: 14),
                  _GlassField(
                    controller: descricaoController,
                    label: 'descrição',
                    hint: 'o que esse indicador ajuda a acompanhar?',
                    icon: Icons.notes_rounded,
                    maxLength: 160,
                    validator: _validarDescricao,
                  ),
                  const SizedBox(height: 24),
                  _SectionLabel(
                    index: '02',
                    title: 'origem do dado',
                    caption: 'aponte para a fonte que alimenta essa leitura.',
                  ),
                  const SizedBox(height: 12),
                  _GlassField(
                    controller: urlController,
                    label: 'url da fonte',
                    hint: 'https://exemplo.com/dados',
                    icon: Icons.link_rounded,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    validator: _validarUrl,
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      const Icon(
                        Icons.lock_outline_rounded,
                        size: 13,
                        color: AppColors.inkMuted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'aceitamos apenas fontes com conexão segura',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .48),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _SaveButton(salvando: salvando, onPressed: salvar),
                  const SizedBox(height: 15),
                  Center(
                    child: Text(
                      'os dados ficam nesta sessão por enquanto.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .38),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CadastroBackground extends StatelessWidget {
  const _CadastroBackground();

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.mineralRaised, AppColors.mineral, AppColors.surface],
      ),
    ),
    child: Stack(
      children: [
        Positioned(
          top: -90,
          right: -55,
          child: _GlowOrb(size: 220, color: AppColors.moss),
        ),
        Positioned(
          bottom: 80,
          left: -120,
          child: _GlowOrb(size: 270, color: AppColors.mossStrong),
        ),
      ],
    ),
  );
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color.withValues(alpha: .1),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: .24),
          blurRadius: 110,
          spreadRadius: 25,
        ),
      ],
    ),
  );
}

class _PageIntro extends StatelessWidget {
  const _PageIntro();

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'cadastro de indicador',
        style: TextStyle(
          color: AppColors.moss,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: .5,
        ),
      ),
      SizedBox(height: 8),
      Text(
        'dê nome ao que merece atenção.',
        style: TextStyle(
          fontSize: 31,
          height: 1.04,
          fontWeight: FontWeight.w600,
          letterSpacing: -1.2,
        ),
      ),
      SizedBox(height: 11),
      Text(
        'crie uma nova lente para enxergar a operação com mais clareza.',
        style: TextStyle(color: AppColors.inkMuted, fontSize: 12, height: 1.4),
      ),
    ],
  );
}

class _PreviewCard extends StatelessWidget {
  final String nome;
  final String descricao;

  const _PreviewCard({required this.nome, required this.descricao});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(22),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: .12),
              Colors.white.withValues(alpha: .035),
            ],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: .13)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.moss.withValues(alpha: .14),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.auto_graph_rounded,
                color: AppColors.ink,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nome.trim().isEmpty
                        ? 'seu indicador aparece aqui'
                        : nome.trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    descricao.trim().isEmpty
                        ? 'a prévia acompanha o que você digita.'
                        : descricao.trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _SectionLabel extends StatelessWidget {
  final String index;
  final String title;
  final String caption;

  const _SectionLabel({
    required this.index,
    required this.title,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        index,
        style: const TextStyle(
          color: AppColors.moss,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(width: 11),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 3),
            Text(
              caption,
              style: const TextStyle(color: AppColors.inkMuted, fontSize: 10),
            ),
          ],
        ),
      ),
    ],
  );
}

class _GlassField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  const _GlassField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.validator,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    maxLength: maxLength,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    validator: validator,
    style: const TextStyle(color: AppColors.ink, fontSize: 13),
    cursorColor: AppColors.moss,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 12),
      labelStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 12),
      floatingLabelStyle: const TextStyle(color: AppColors.moss, fontSize: 12),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 13, right: 8),
        child: Icon(icon, color: AppColors.inkMuted, size: 19),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 48),
      filled: true,
      fillColor: Colors.white.withValues(alpha: .055),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: .1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: .1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.moss, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.critical),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.critical, width: 1.2),
      ),
      errorStyle: const TextStyle(color: AppColors.critical, fontSize: 10),
      counterStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 10),
    ),
  );
}

class _SaveButton extends StatelessWidget {
  final bool salvando;
  final VoidCallback onPressed;

  const _SaveButton({required this.salvando, required this.onPressed});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 54,
    child: ElevatedButton.icon(
      onPressed: salvando ? null : onPressed,
      icon: salvando
          ? const SizedBox(
              width: 17,
              height: 17,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.mineral,
              ),
            )
          : const Icon(Icons.check_rounded, size: 19),
      label: Text(
        salvando ? 'salvando...' : 'salvar indicador',
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.mineral,
        backgroundColor: AppColors.moss,
        disabledBackgroundColor: AppColors.mossStrong,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
        elevation: 0,
      ),
    ),
  );
}

class CadastroIndicadorForm extends CadastroIndicadorPage {
  const CadastroIndicadorForm({super.key, super.onSaved});
}
