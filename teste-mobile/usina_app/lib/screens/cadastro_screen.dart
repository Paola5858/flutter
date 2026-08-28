import 'dart:ui';
import 'package:flutter/material.dart';
import '../cadastros.dart';

class CadastroScreen extends StatefulWidget {
  final CadastroConfig config;

  const CadastroScreen({super.key, required this.config});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String?> _selecionados = {};

  @override
  void initState() {
    super.initState();
    for (final campo in widget.config.campos) {
      if (campo.tipo == TipoCampo.seleciona) {
        _selecionados[campo.rotulo] = campo.opcoes.isNotEmpty ? campo.opcoes.first : null;
      } else {
        _controllers[campo.rotulo] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _salvar() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.config.titulo} registrado com sucesso.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xff294735),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          tooltip: 'voltar',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(config.titulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ),
      body: Stack(
        children: [
          const _FundoVerde(),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 34),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _Cabecalho(config: config),
                      const SizedBox(height: 24),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [Colors.white.withValues(alpha: .1), Colors.white.withValues(alpha: .035)]),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white.withValues(alpha: .13)),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  for (final campo in config.campos) ...[
                                    _Campo(
                                      campo: campo,
                                      controller: _controllers[campo.rotulo],
                                      valorSelecionado: _selecionados[campo.rotulo],
                                      aoSelecionar: (valor) => setState(() => _selecionados[campo.rotulo] = valor),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  const SizedBox(height: 6),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _salvar,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xffb8d5a8),
                                        foregroundColor: const Color(0xff13211a),
                                        padding: const EdgeInsets.symmetric(vertical: 15),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        elevation: 0,
                                      ),
                                      child: const Text('salvar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
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

class _Cabecalho extends StatelessWidget {
  final CadastroConfig config;
  const _Cabecalho({required this.config});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xff456b4f), Color(0xff294735)]),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xffb8d5a8).withValues(alpha: .22)),
          boxShadow: [BoxShadow(color: const Color(0xff8bb77f).withValues(alpha: .13), blurRadius: 28, offset: const Offset(0, 12))],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(color: const Color(0x28ffffff), borderRadius: BorderRadius.circular(15)),
              child: Icon(config.icone, color: const Color(0xffe3f1d9), size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('novo ${config.titulo}', style: const TextStyle(color: Color(0xfff1f8eb), fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -.4)),
                const SizedBox(height: 4),
                Text(config.subtitulo, style: const TextStyle(color: Color(0xffc6dec1), fontSize: 11)),
              ]),
            ),
          ],
        ),
      );
}

class _Campo extends StatelessWidget {
  final CadastroCampo campo;
  final TextEditingController? controller;
  final String? valorSelecionado;
  final ValueChanged<String?> aoSelecionar;

  const _Campo({required this.campo, this.controller, this.valorSelecionado, required this.aoSelecionar});

  @override
  Widget build(BuildContext context) {
    const borda = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: Color(0x33ffffff)),
    );
    if (campo.tipo == TipoCampo.seleciona) {
      return DropdownButtonFormField<String>(
        initialValue: valorSelecionado,
        decoration: InputDecoration(
          labelText: campo.rotulo,
          labelStyle: const TextStyle(color: Color(0xff9aa9a1), fontSize: 12),
          filled: true,
          fillColor: Colors.white.withValues(alpha: .06),
          border: borda,
          enabledBorder: borda,
          focusedBorder: borda.copyWith(borderSide: const BorderSide(color: Color(0xffb8d5a8))),
        ),
        dropdownColor: const Color(0xff172820),
        style: const TextStyle(color: Color(0xffe8f3e2), fontSize: 13),
        items: campo.opcoes
            .map((opcao) => DropdownMenuItem(value: opcao, child: Text(opcao, style: const TextStyle(color: Color(0xffe8f3e2), fontSize: 13))))
            .toList(),
        onChanged: aoSelecionar,
      );
    }

    final isNumero = campo.tipo == TipoCampo.numero;
    return TextFormField(
      controller: controller,
      keyboardType: isNumero ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
      style: const TextStyle(color: Color(0xffe8f3e2), fontSize: 13),
      decoration: InputDecoration(
        labelText: campo.rotulo,
        hintText: campo.dica.isNotEmpty ? campo.dica : null,
        hintStyle: const TextStyle(color: Color(0xff718079), fontSize: 11),
        labelStyle: const TextStyle(color: Color(0xff9aa9a1), fontSize: 12),
        filled: true,
        fillColor: Colors.white.withValues(alpha: .06),
        border: borda,
        enabledBorder: borda,
        focusedBorder: borda.copyWith(borderSide: const BorderSide(color: Color(0xffb8d5a8))),
      ),
      validator: (valor) {
        final texto = valor?.trim() ?? '';
        if (texto.isEmpty) return 'informe ${campo.rotulo.toLowerCase()}';
        if (isNumero && double.tryParse(texto.replaceAll(',', '.')) == null) return 'valor inválido';
        return null;
      },
    );
  }
}

class _FundoVerde extends StatelessWidget {
  const _FundoVerde();

  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xff172820), Color(0xff0d1211), Color(0xff101614)]),
        ),
        child: Stack(children: [
          Positioned(top: -90, right: -50, child: _GlowVerde(size: 230, color: Color(0xff8bb77f))),
          Positioned(bottom: -110, left: -90, child: _GlowVerde(size: 260, color: Color(0xff456b4f))),
        ]),
      );
}

class _GlowVerde extends StatelessWidget {
  final double size;
  final Color color;
  const _GlowVerde({required this.size, required this.color});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: .12),
          boxShadow: [BoxShadow(color: color.withValues(alpha: .2), blurRadius: 100, spreadRadius: 25)],
        ),
      );
}
