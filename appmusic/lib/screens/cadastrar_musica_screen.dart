import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../services/musica_service.dart';

class CadastrarMusicaScreen extends StatefulWidget {
  const CadastrarMusicaScreen({super.key});

  @override
  State<CadastrarMusicaScreen> createState() => _CadastrarMusicaScreenState();
}

class _CadastrarMusicaScreenState extends State<CadastrarMusicaScreen> {
  final nomeArtistaController = TextEditingController();
  final nomeMusicaController = TextEditingController();

  String generoSelecionado = 'Rap';

  final formKey = GlobalKey<FormState>();
  bool isSaving = false;

  @override
  void dispose() {
    nomeArtistaController.dispose();
    nomeMusicaController.dispose();
    super.dispose();
  }

  Future<void> salvar() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    try {
      await MusicaService.criarMusica(
        nomeArtista: nomeArtistaController.text.trim(),
        nomeMusica: nomeMusicaController.text.trim(),
        genero: generoSelecionado,
      );

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.rust,
          content: Text(
            'Erro ao salvar: $e',
            style: const TextStyle(
              fontFamily: 'Hanken Grotesk',
              fontWeight: FontWeight.w700,
              color: Color(0xFFF3ECDF),
            ),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ink,
      appBar: AppBar(
        backgroundColor: AppTheme.ink,
        foregroundColor: AppTheme.cream,
        elevation: 0,
        title: const Text(
          'cadastrar',
          style: TextStyle(
            fontFamily: 'Bricolage Grotesque',
            fontWeight: FontWeight.w900,
            fontSize: 22,
            letterSpacing: -0.2,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Nova música',
                        style: TextStyle(
                          fontFamily: 'Bricolage Grotesque',
                          color: Color(0xFFF3ECDF),
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          letterSpacing: -0.2,
                        ),
                      ),
const SizedBox(height: 8),
                      const Text(
                        'Salve e volte: o item aparece imediatamente na lista.',
                        style: TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          color: Color(0xFFF3ECDF),
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: nomeArtistaController,
                        style: const TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          color: Color(0xFFF3ECDF),
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: _inputDecoration(
                          labelText: 'Nome do artista',
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Obrigatório';
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      TextFormField(
                        controller: nomeMusicaController,
                        style: const TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          color: Color(0xFFF3ECDF),
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: _inputDecoration(
                          labelText: 'Nome da música',
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Obrigatório';
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      DropdownButtonFormField<String>(
                        value: generoSelecionado,
                        decoration: _inputDecoration(
                          labelText: 'Gênero',
                        ),
                        dropdownColor: AppTheme.ink,
                        style: const TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          color: Color(0xFFF3ECDF),
                          fontWeight: FontWeight.w800,
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Rap', child: Text('Rap')),
                          DropdownMenuItem(value: 'Rock', child: Text('Rock')),
                          DropdownMenuItem(value: 'Pop', child: Text('Pop')),
                          DropdownMenuItem(value: 'Funk', child: Text('Funk')),
                          DropdownMenuItem(
                            value: 'Eletrônica',
                            child: Text('Eletrônica'),
                          ),
                        ],
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() => generoSelecionado = v);
                        },
                      ),

                      const SizedBox(height: 22),

                      SizedBox(
                        height: 52,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.amber,
                            foregroundColor: AppTheme.ink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          onPressed: isSaving ? null : salvar,
                          icon: isSaving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.6,
                                    color: AppTheme.ink,
                                  ),
                                )
                              : const Icon(Icons.save),
                          label: Text(
                            isSaving ? 'Salvando...' : 'Salvar',
                            style: const TextStyle(
                              fontFamily: 'Space Mono',
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Ao salvar, a música fica registrada no backend e volta para esta tela com refresh.',
                        style: TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          color: Color(0xFFF3ECDF),
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String labelText}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        fontFamily: 'Space Mono',
        color: Color(0xFFF3ECDF).withOpacity(0.72),
        fontWeight: FontWeight.w800,
      ),
      filled: true,
      fillColor: AppTheme.ink.withOpacity(0.25),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Color(0xFFF3ECDF).withOpacity(0.18)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Color(0xFFF3ECDF).withOpacity(0.18)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppTheme.amber, width: 1.6),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.ink.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.cream.withOpacity(0.14)),
      ),
      child: child,
    );
  }
}
