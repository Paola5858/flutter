import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_theme.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _submitting = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    try {
      // Sem backend de autenticação no escopo atual.
      // A intenção aqui é manter o redesign e seguir a navegação existente.
      await Future<void>.delayed(const Duration(milliseconds: 350));

      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/musicas');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: AppTheme.ink,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final topPad = constraints.maxHeight * 0.06;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20).copyWith(top: topPad),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: media.size.height - topPad),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'refrão',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.playfairDisplay(
                              textStyle: const TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.7,
                                height: 0.95,
                                color: AppTheme.cream,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 34),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _EditorialUnderlineField(
                              controller: _email,
                              label: 'e-mail',
                              hint: 'seu@exemplo.com',
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) {
                                final value = v?.trim() ?? '';
                                if (value.isEmpty) return 'Obrigatório';
                                if (!value.contains('@')) return 'E-mail inválido';
                                return null;
                              },
                              obscureText: false,
                            ),
                            const SizedBox(height: 18),
                            _EditorialUnderlineField(
                              controller: _password,
                              label: 'senha',
                              hint: '••••••••',
                              keyboardType: TextInputType.text,
                              validator: (v) {
                                final value = v ?? '';
                                if (value.trim().isEmpty) return 'Obrigatório';
                                if (value.trim().length < 4) return 'Muito curta';
                                return null;
                              },
                              obscureText: true,
                            ),
                            const SizedBox(height: 28),
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.amber,
                                  foregroundColor: AppTheme.ink,
                                  elevation: 0,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 18),
                                ),
                                onPressed: _submitting ? null : _handleLogin,
                                child: Text(
                                  _submitting ? 'entrando...' : 'entrar',
                                  style: GoogleFonts.spaceGrotesk(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.2,
                                      fontSize: 16,
                                      color: AppTheme.ink,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'entrada editorial / sem ruído',
                              style: GoogleFonts.spaceGrotesk(
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                  color: AppTheme.cream.withOpacity(0.65),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EditorialUnderlineField extends StatelessWidget {
  const _EditorialUnderlineField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.validator,
    required this.keyboardType,
    required this.obscureText,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: GoogleFonts.spaceGrotesk(
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15,
          color: AppTheme.cream,
        ),
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: GoogleFonts.spaceGrotesk(
          textStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.35,
            color: AppTheme.cream.withOpacity(0.72),
          ),
        ),
        hintStyle: GoogleFonts.spaceGrotesk(
          textStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
            color: AppTheme.cream.withOpacity(0.55),
          ),
        ),
        filled: false,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.graphite, width: 1),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.graphite, width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppTheme.amber, width: 1.6),
        ),
        errorStyle: GoogleFonts.spaceGrotesk(
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppTheme.amber,
          ),
        ),
      ),
      validator: validator,
    );
  }
}
