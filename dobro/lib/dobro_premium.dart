import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const _ink = Color(0xFF211A17);
const _cream = Color(0xFFF3ECDF);
const _amber = Color(0xFFE08A2D);
const _moss = Color(0xFF6B7A4F);
const _rust = Color(0xFFB23A2E);

class DobroApp extends StatelessWidget {
  const DobroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: _ink,
        colorScheme: const ColorScheme.dark(
          primary: _amber,
          surface: _ink,
          error: _rust,
        ),
      ),
      home: const DobroPage(),
    );
  }
}

class DobroPage extends StatefulWidget {
  const DobroPage({super.key});

  @override
  State<DobroPage> createState() => _DobroPageState();
}

class _DobroPageState extends State<DobroPage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  String? _resultado;
  bool _isError = false;
  bool _isCalculating = false;
  bool _hasCalculated = false;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
  }

  String _formatarNumero(double valor) {
    if (valor == valor.truncateToDouble()) {
      return valor.truncate().toString();
    }

    final texto = valor.toStringAsFixed(2);
    return texto.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  Future<void> _calcular() async {
    _focusNode.unfocus();
    final texto = _controller.text.trim().replaceAll(',', '.');
    final numero = double.tryParse(texto);

    if (numero == null) {
      _animCtrl.reset();
      setState(() {
        _resultado = texto.isEmpty
            ? 'campo vazio — digite um número primeiro'
            : '"$texto" não é um número válido';
        _isError = true;
        _hasCalculated = true;
        _isCalculating = false;
      });
      _animCtrl.forward();
      return;
    }

    setState(() => _isCalculating = true);

    await Future.delayed(const Duration(milliseconds: 280));

    final dobro = numero * 2;
    final resultadoStr = _formatarNumero(dobro);

    _animCtrl.reset();
    setState(() {
      _resultado = resultadoStr;
      _isError = false;
      _hasCalculated = true;
      _isCalculating = false;
    });
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'dobro',
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 11,
                  letterSpacing: 4,
                  color: _amber,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'de um\nnúmero',
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: _cream,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'ENTRADA',
                style: GoogleFonts.spaceMono(
                  fontSize: 10,
                  letterSpacing: 3,
                  color: _cream.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,\-]')),
                ],
                style: GoogleFonts.bricolageGrotesque(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: _cream,
                ),
                cursorColor: _amber,
                decoration: InputDecoration(
                  hintText: 'ex: 42',
                  hintStyle: GoogleFonts.bricolageGrotesque(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: _cream.withValues(alpha: 0.18),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: _cream.withValues(alpha: 0.2), width: 1.5),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: _amber, width: 2),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.only(bottom: 8),
                ),
                onSubmitted: (_) => _calcular(),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: _isCalculating ? null : _calcular,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 56,
                  decoration: BoxDecoration(
                    color: _isCalculating ? _amber.withValues(alpha: 0.7) : _amber,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: _isCalculating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: _ink,
                            ),
                          )
                        : Text(
                            'CALCULAR',
                            style: GoogleFonts.spaceMono(
                              fontSize: 13,
                              letterSpacing: 3,
                              fontWeight: FontWeight.w700,
                              color: _ink,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              if (_hasCalculated)
                FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: _isError ? _buildErro() : _buildResultado(),
                  ),
                ),
              if (!_hasCalculated)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_upward_rounded,
                            color: _cream.withValues(alpha: 0.12), size: 32),
                        const SizedBox(height: 12),
                        Text(
                          'digite um número e\ntoque em calcular',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.spaceMono(
                            fontSize: 12,
                            color: _cream.withValues(alpha: 0.2),
                            height: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultado() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RESULTADO',
          style: GoogleFonts.spaceMono(
            fontSize: 10,
            letterSpacing: 3,
            color: _moss.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            _resultado ?? '',
            style: GoogleFonts.bricolageGrotesque(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              color: _cream,
              height: 1.0,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _moss.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            'dobro de ${_controller.text.trim()}',
            style: GoogleFonts.spaceMono(
              fontSize: 11,
              color: _moss,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ERRO',
          style: GoogleFonts.spaceMono(
            fontSize: 10,
            letterSpacing: 3,
            color: _rust.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _resultado ?? '',
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _rust,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
