import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../core/theme/app_tokens.dart';
import '../models/domain.dart';
import '../services/session_storage.dart';
import 'dashboard_screen.dart';

class LoginPage extends StatefulWidget {
  final DashboardExtracao dashboard;

  const LoginPage({super.key, required this.dashboard});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'aluno@usina.com');
  final _passwordController = TextEditingController(text: '123456');
  final _storage = const SessionStorage();

  bool _loading = false;
  bool _obscurePassword = true;
  bool _locationNoticeShown = false;

  Future<Position?> _getLocation() async {
    if (kIsWeb) {
      _showLocationNotice('localização indisponível no navegador. o acesso continua sem coordenadas.');
      return null;
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationNotice('gps desligado. o acesso continua sem coordenadas.');
      return null;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      _showLocationNotice('permissão negada. o acesso continua sem coordenadas.');
      return null;
    }

    if (permission == LocationPermission.deniedForever) {
      _showLocationNotice(
        'permissão bloqueada. você pode liberar a localização nas configurações.',
      );
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );
    } catch (_) {
      _showLocationNotice('não foi possível ler o gps agora. o acesso continua.');
      return null;
    }
  }

  void _showLocationNotice(String message) {
    if (!mounted || _locationNoticeShown) return;
    _locationNoticeShown = true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.mineralRaised,
      ),
    );
  }

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _loading = true;
      _locationNoticeShown = false;
    });

    await Future<void>.delayed(const Duration(milliseconds: 320));
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text;

    if (email != 'aluno@usina.com' || password != '123456') {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('e-mail ou senha inválidos. tente a credencial da aula.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.critical,
        ),
      );
      return;
    }

    final position = await _getLocation().timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        _showLocationNotice('localização indisponível. o acesso continua sem coordenadas.');
        return null;
      },
    );
    await _storage.saveLogin(
      email: email,
      latitude: position?.latitude,
      longitude: position?.longitude,
    );

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => DashboardScreen(dashboard: widget.dashboard),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _LoginBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 470),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _BrandMark(),
                      const SizedBox(height: 52),
                      const Text(
                        'bem-vinda de volta,',
                        style: TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 14,
                          letterSpacing: .2,
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        'vamos ler o campo.',
                        style: TextStyle(
                          color: AppColors.ink,
                          fontSize: 31,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1.1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'entre para acompanhar a operação com contexto, não com achismo.',
                        style: TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 13,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 28),
                      _GlassLoginCard(
                        formKey: _formKey,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        obscurePassword: _obscurePassword,
                        loading: _loading,
                        onTogglePassword: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        onSubmit: _login,
                      ),
                      const SizedBox(height: 16),
                      const _CredentialHint(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginBackground extends StatelessWidget {
  const _LoginBackground();

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
            Positioned(top: -100, right: -80, child: _Orb(270, AppColors.moss)),
            Positioned(bottom: -120, left: -120, child: _Orb(310, AppColors.mossStrong)),
          ],
        ),
      );
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb(this.size, this.color);

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: .08),
          boxShadow: [BoxShadow(color: color.withValues(alpha: .22), blurRadius: 110, spreadRadius: 30)],
        ),
      );
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: AppColors.moss.withValues(alpha: .16),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppColors.moss.withValues(alpha: .38)),
            ),
            child: const Icon(Icons.water_drop_outlined, color: AppColors.moss),
          ),
          const SizedBox(width: 12),
          const Text(
            'usina aurora',
            style: TextStyle(color: AppColors.ink, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      );
}

class _GlassLoginCard extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool loading;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;

  const _GlassLoginCard({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.loading,
    required this.onTogglePassword,
    required this.onSubmit,
  });

  InputDecoration decoration(String label, IconData icon, {Widget? suffix}) => InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 19),
        suffixIcon: suffix,
      );

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .055),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withValues(alpha: .12)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .16), blurRadius: 34, offset: const Offset(0, 18))],
        ),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('acesso operacional', style: TextStyle(color: AppColors.ink, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 5),
              const Text('credencial temporária para o exercício', style: TextStyle(color: AppColors.inkMuted, fontSize: 11)),
              const SizedBox(height: 22),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: decoration('e-mail', Icons.alternate_email_rounded),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'informe o e-mail';
                  if (!value.contains('@')) return 'use um e-mail válido';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: passwordController,
                obscureText: obscurePassword,
                onFieldSubmitted: (_) => onSubmit(),
                decoration: decoration(
                  'senha',
                  Icons.lock_outline_rounded,
                  suffix: IconButton(
                    tooltip: obscurePassword ? 'mostrar senha' : 'ocultar senha',
                    onPressed: onTogglePassword,
                    icon: Icon(obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  ),
                ),
                validator: (value) => value == null || value.length < 6 ? 'use pelo menos 6 caracteres' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: loading ? null : onSubmit,
                  icon: loading
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.arrow_forward_rounded, size: 19),
                  label: Text(loading ? 'validando acesso...' : 'entrar na operação'),
                ),
              ),
              const SizedBox(height: 13),
              const Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 15, color: AppColors.moss),
                  SizedBox(width: 7),
                  Expanded(child: Text('a localização é registrada apenas no momento do acesso e não bloqueia o login.', style: TextStyle(color: AppColors.inkMuted, fontSize: 10, height: 1.35))),
                ],
              ),
            ],
          ),
        ),
      );
}

class _CredentialHint extends StatelessWidget {
  const _CredentialHint();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.moss.withValues(alpha: .07),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: AppColors.moss.withValues(alpha: .12)),
        ),
        child: const Row(
          children: [
            Icon(Icons.info_outline_rounded, size: 16, color: AppColors.moss),
            SizedBox(width: 9),
            Expanded(child: Text('aula: aluno@usina.com · senha: 123456', style: TextStyle(color: AppColors.inkMuted, fontSize: 10))),
          ],
        ),
      );
}
