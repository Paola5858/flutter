import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/usuario.dart';

class CadastroUsuarioPage extends StatefulWidget {
  final ValueChanged<Usuario>? onSaved;

  const CadastroUsuarioPage({super.key, this.onSaved});

  @override
  State<CadastroUsuarioPage> createState() => _CadastroUsuarioPageState();
}

class _CadastroUsuarioPageState extends State<CadastroUsuarioPage> {
  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  XFile? fotoSelecionada;
  bool senhaVisivel = false;
  bool salvando = false;
  bool carregandoFoto = false;

  @override
  void initState() {
    super.initState();
    _recuperarImagemPerdida();
  }

  Future<void> _recuperarImagemPerdida() async {
    final resposta = await picker.retrieveLostData();
    if (!mounted || resposta.isEmpty) return;
    final arquivos = resposta.files;
    if (arquivos != null && arquivos.isNotEmpty) {
      setState(() => fotoSelecionada = arquivos.first);
    }
  }

  void mostrarMensagem(String mensagem, {bool erro = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        behavior: SnackBarBehavior.floating,
        backgroundColor: erro ? const Color(0xff793d4b) : const Color(0xff2c6149),
      ),
    );
  }

  Future<void> _selecionarFoto(ImageSource source) async {
    setState(() => carregandoFoto = true);
    try {
      final imagem = await picker.pickImage(source: source, imageQuality: 85, maxWidth: 1200);
      if (!mounted) return;
      if (imagem != null) setState(() => fotoSelecionada = imagem);
    } on PlatformException catch (erro) {
      mostrarMensagem(
        source == ImageSource.camera ? 'não foi possível acessar a câmera: ${erro.message ?? erro.code}' : 'não foi possível abrir suas fotos: ${erro.message ?? erro.code}',
        erro: true,
      );
    } catch (_) {
      mostrarMensagem('não foi possível carregar essa imagem. tente outra vez.', erro: true);
    } finally {
      if (mounted) setState(() => carregandoFoto = false);
    }
  }

  Future<void> selecionarFoto() => _selecionarFoto(ImageSource.gallery);

  Future<void> tirarFoto() => _selecionarFoto(ImageSource.camera);

  Future<void> _abrirOpcoesFoto() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xff172820),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 38, height: 4, decoration: BoxDecoration(color: Colors.white.withValues(alpha: .18), borderRadius: BorderRadius.circular(99))),
            const SizedBox(height: 20),
            const Align(alignment: Alignment.centerLeft, child: Text('como você quer aparecer?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
            const SizedBox(height: 5),
            const Align(alignment: Alignment.centerLeft, child: Text('escolha uma imagem que represente você na operação.', style: TextStyle(color: Color(0xff9eaca4), fontSize: 11))),
            const SizedBox(height: 19),
            Row(children: [
              Expanded(child: _SourceButton(icon: Icons.photo_library_outlined, label: 'galeria', onTap: () { Navigator.pop(context); selecionarFoto(); })),
              const SizedBox(width: 12),
              Expanded(child: _SourceButton(icon: Icons.camera_alt_outlined, label: 'câmera', onTap: () { Navigator.pop(context); tirarFoto(); })),
            ]),
            if (fotoSelecionada != null) ...[
              const SizedBox(height: 10),
              TextButton.icon(onPressed: () { setState(() => fotoSelecionada = null); Navigator.pop(context); }, icon: const Icon(Icons.delete_outline_rounded, size: 17), label: const Text('remover foto'), style: TextButton.styleFrom(foregroundColor: const Color(0xffffafbd))),
            ],
          ]),
        ),
      ),
    );
  }

  String? _validarNome(String? valor) {
    final nome = valor?.trim() ?? '';
    if (nome.isEmpty) return 'informe seu nome';
    if (nome.length < 3) return 'use pelo menos 3 caracteres';
    return null;
  }

  String? _validarEmail(String? valor) {
    final email = valor?.trim() ?? '';
    if (email.isEmpty) return 'informe seu e-mail';
    final valido = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
    return valido ? null : 'digite um e-mail válido';
  }

  String? _validarSenha(String? valor) {
    final senha = valor ?? '';
    if (senha.length < 6) return 'use pelo menos 6 caracteres';
    if (!RegExp(r'[A-Za-z]').hasMatch(senha) || !RegExp(r'\d').hasMatch(senha)) return 'misture letras e números';
    return null;
  }

  Future<void> salvar() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(formKey.currentState?.validate() ?? false)) return;

    setState(() => salvando = true);
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final usuario = Usuario(
      id: DateTime.now().millisecondsSinceEpoch,
      nome: nomeController.text.trim().toLowerCase(),
      email: emailController.text.trim().toLowerCase(),
      senha: senhaController.text.trim(),
      fotoPath: fotoSelecionada?.path,
    );
    widget.onSaved?.call(usuario);
    if (!mounted) return;
    setState(() => salvando = false);
    mostrarMensagem('usuário validado com sucesso.');
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (mounted) Navigator.of(context).pop(usuario);
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xff100d16),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.of(context).pop()),
          title: const Text('novo usuário', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          actions: [IconButton(tooltip: 'limpar formulário', icon: const Icon(Icons.refresh_rounded, size: 20), onPressed: () { formKey.currentState?.reset(); nomeController.clear(); emailController.clear(); senhaController.clear(); setState(() => fotoSelecionada = null); }), const SizedBox(width: 8)],
        ),
        body: Stack(children: [
          const _UsuarioBackground(),
          SafeArea(top: false, child: Form(key: formKey, child: ListView(padding: const EdgeInsets.fromLTRB(20, 12, 20, 34), children: [
            const _UsuarioIntro(),
            const SizedBox(height: 22),
            _AvatarPicker(foto: fotoSelecionada, carregando: carregandoFoto, onTap: _abrirOpcoesFoto),
            const SizedBox(height: 8),
            Center(child: Text(fotoSelecionada == null ? 'adicione uma foto para personalizar seu perfil' : 'foto pronta para o seu perfil', style: const TextStyle(color: Color(0xff9eaca4), fontSize: 10))),
            const SizedBox(height: 26),
            const _FieldSection(index: '01', title: 'quem está na operação?', caption: 'seu nome aparece nas próximas interações do app.'),
            const SizedBox(height: 12),
            _GlassUserField(controller: nomeController, label: 'nome completo', hint: 'ex.: paola machado', icon: Icons.person_outline_rounded, textInputAction: TextInputAction.next, validator: _validarNome),
            const SizedBox(height: 14),
            _GlassUserField(controller: emailController, label: 'e-mail', hint: 'voce@usina.com', icon: Icons.alternate_email_rounded, keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, validator: _validarEmail),
            const SizedBox(height: 24),
            const _FieldSection(index: '02', title: 'proteção de acesso', caption: 'uma senha forte mantém seus dados no lugar certo.'),
            const SizedBox(height: 12),
            _GlassUserField(controller: senhaController, label: 'senha', hint: 'mínimo de 6 caracteres', icon: Icons.lock_outline_rounded, obscureText: !senhaVisivel, suffixIcon: IconButton(icon: Icon(senhaVisivel ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 19), onPressed: () => setState(() => senhaVisivel = !senhaVisivel)), validator: _validarSenha),
            const SizedBox(height: 9),
            const Row(children: [Icon(Icons.shield_outlined, size: 13, color: Color(0xff8ca69a)), SizedBox(width: 6), Text('use letras e números para uma senha mais segura', style: TextStyle(color: Color(0xff7e8b85), fontSize: 10))]),
            const SizedBox(height: 28),
            _UserSaveButton(salvando: salvando, onPressed: salvar),
            const SizedBox(height: 15),
            Center(child: Text('os dados ficam nesta sessão por enquanto.', style: TextStyle(color: Colors.white.withValues(alpha: .38), fontSize: 10))),
          ]))),
        ]),
      );
}

class _UsuarioBackground extends StatelessWidget {
  const _UsuarioBackground();
  @override
  Widget build(BuildContext context) => Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xff27192b), Color(0xff100d16), Color(0xff14231d)])), child: Stack(children: [Positioned(top: -90, right: -55, child: _UsuarioGlow(size: 220, color: Color(0xff8ebd84))), Positioned(bottom: 80, left: -120, child: _UsuarioGlow(size: 270, color: Color(0xff765dd1)))]));
}

class _UsuarioGlow extends StatelessWidget {
  final double size;
  final Color color;
  const _UsuarioGlow({required this.size, required this.color});
  @override
  Widget build(BuildContext context) => Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: .1), boxShadow: [BoxShadow(color: color.withValues(alpha: .24), blurRadius: 110, spreadRadius: 25)]));
}

class _UsuarioIntro extends StatelessWidget {
  const _UsuarioIntro();
  @override
  Widget build(BuildContext context) => const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('cadastro de usuário', style: TextStyle(color: Color(0xffb8d5a8), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: .5)), SizedBox(height: 8), Text('uma pessoa real\npor trás dos dados.', style: TextStyle(fontSize: 31, height: 1.04, fontWeight: FontWeight.w600, letterSpacing: -1.2)), SizedBox(height: 11), Text('crie seu acesso e deixe a operação reconhecer quem faz acontecer.', style: TextStyle(color: Color(0xffb9acb8), fontSize: 12, height: 1.4))]);
}

class _AvatarPicker extends StatelessWidget {
  final XFile? foto;
  final bool carregando;
  final VoidCallback onTap;
  const _AvatarPicker({required this.foto, required this.carregando, required this.onTap});
  @override
  Widget build(BuildContext context) => Center(child: GestureDetector(onTap: carregando ? null : onTap, child: Stack(alignment: Alignment.bottomRight, children: [Container(width: 128, height: 128, padding: const EdgeInsets.all(4), decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [Color(0xffb8d5a8), Color(0xff547861)]), boxShadow: [BoxShadow(color: const Color(0xff9cc390).withValues(alpha: .22), blurRadius: 28, spreadRadius: 3)]), child: ClipOval(child: foto == null ? Container(color: const Color(0xff294735), child: const Icon(Icons.person_rounded, color: Color(0xffd9ecd1), size: 60)) : Image.file(File(foto!.path), fit: BoxFit.cover))), Container(width: 38, height: 38, decoration: BoxDecoration(color: const Color(0xffb8d5a8), shape: BoxShape.circle, border: Border.all(color: const Color(0xff172820), width: 3)), child: carregando ? const Padding(padding: EdgeInsets.all(9), child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xff203225))) : const Icon(Icons.add_a_photo_outlined, size: 17, color: Color(0xff203225)))])));
}

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SourceButton({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(onPressed: onTap, icon: Icon(icon, size: 18), label: Text(label), style: OutlinedButton.styleFrom(foregroundColor: const Color(0xffd9ecd1), side: BorderSide(color: const Color(0xffb8d5a8).withValues(alpha: .26)), backgroundColor: Colors.white.withValues(alpha: .045), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))));
}

class _FieldSection extends StatelessWidget {
  final String index;
  final String title;
  final String caption;
  const _FieldSection({required this.index, required this.title, required this.caption});
  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(index, style: const TextStyle(color: Color(0xffb8d5a8), fontSize: 11, fontWeight: FontWeight.w700)), const SizedBox(width: 11), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)), const SizedBox(height: 3), Text(caption, style: const TextStyle(color: Color(0xff9e9ba2), fontSize: 10))]))]);
}

class _GlassUserField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  const _GlassUserField({required this.controller, required this.label, required this.hint, required this.icon, this.keyboardType, this.textInputAction, this.obscureText = false, this.suffixIcon, this.validator});
  @override
  Widget build(BuildContext context) => TextFormField(controller: controller, keyboardType: keyboardType, textInputAction: textInputAction, obscureText: obscureText, validator: validator, style: const TextStyle(color: Color(0xfff1ebe9), fontSize: 13), cursorColor: const Color(0xffb8d5a8), decoration: InputDecoration(labelText: label, hintText: hint, hintStyle: const TextStyle(color: Color(0xff77737d), fontSize: 12), labelStyle: const TextStyle(color: Color(0xffa99eae), fontSize: 12), floatingLabelStyle: const TextStyle(color: Color(0xffc6e1b9), fontSize: 12), prefixIcon: Padding(padding: const EdgeInsets.only(left: 13, right: 8), child: Icon(icon, color: const Color(0xff91a99b), size: 19)), prefixIconConstraints: const BoxConstraints(minWidth: 48), suffixIcon: suffixIcon, filled: true, fillColor: Colors.white.withValues(alpha: .055), contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withValues(alpha: .1))), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withValues(alpha: .1))), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xff9ec58f), width: 1.2)), errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xffe49aaa))), focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xffe49aaa), width: 1.2)), errorStyle: const TextStyle(color: Color(0xffffaebd), fontSize: 10));
}

class _UserSaveButton extends StatelessWidget {
  final bool salvando;
  final VoidCallback onPressed;
  const _UserSaveButton({required this.salvando, required this.onPressed});
  @override
  Widget build(BuildContext context) => SizedBox(height: 54, child: ElevatedButton.icon(onPressed: salvando ? null : onPressed, icon: salvando ? const SizedBox(width: 17, height: 17, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xff203225))) : const Icon(Icons.check_rounded, size: 19), label: Text(salvando ? 'validando...' : 'criar usuário', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)), style: ElevatedButton.styleFrom(foregroundColor: const Color(0xff203225), backgroundColor: const Color(0xffb8d5a8), disabledBackgroundColor: const Color(0xff789273), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)), elevation: 0)));
}
