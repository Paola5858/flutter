import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../services/artista_service.dart';
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
      // fluxo: cria artista -> cria música com artistaId retornado
      final artistaId = await ArtistaService.criarArtista(
        nomeArtistaController.text.trim(),
      );

      await MusicaService.criarMusica(
        artistaId: artistaId,
        nomeMusica: nomeMusicaController.text.trim(),
        genero: generoSelecionado,
      );

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.rust,
            content: Text(
              'Erro ao salvar: $e',
              style: const TextStyle(
                fontFamily: 'Hanken Grotesk',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'cadastrar',
          style: TextStyle(
            fontFamily: 'Bricolage Grotesque',
            fontWeight: FontWeight.w900,
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
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.cream,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Nova música',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
                              fontFamily: 'Bricolage Grotesque',
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                      const SizedBox(height: 18),

                      TextFormField(
                        controller: nomeArtistaController,
                        style: const TextStyle(fontFamily: 'Hanken Grotesk'),
                        decoration: InputDecoration(
                          labelText: 'Nome do artista',
                          labelStyle: const TextStyle(
                            fontFamily: 'Space Mono',
                            color: Colors.black54,
                            fontWeight: FontWeight.w700,
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.55),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Obrigatório';
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      TextFormField(
                        controller: nomeMusicaController,
                        style: const TextStyle(fontFamily: 'Hanken Grotesk'),
                        decoration: InputDecoration(
                          labelText: 'Nome da música',
                          labelStyle: const TextStyle(
                            fontFamily: 'Space Mono',
                            color: Colors.black54,
                            fontWeight: FontWeight.w700,
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.55),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Obrigatório';
                          return null;
                        },
                      ),

                      const SizedBox(height: 14),

                      DropdownButtonFormField<String>(
                        initialValue: generoSelecionado,
                        decoration: InputDecoration(
                          labelText: 'Gênero',
                          labelStyle: const TextStyle(
                            fontFamily: 'Space Mono',
                            color: Colors.black54,
                            fontWeight: FontWeight.w700,
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.55),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: const TextStyle(
                          fontFamily: 'Hanken Grotesk',
                          color: Colors.black,
                        ),
                        dropdownColor: AppTheme.cream,
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
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: isSaving ? null : salvar,
                          icon: isSaving
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.6,
                                    color: Colors.black,
                                  ),
                                )
                              : const Icon(Icons.save),
                          label: Text(
                            isSaving ? 'Salvando...' : 'Salvar',
                            style: const TextStyle(
                              fontFamily: 'Space Mono',
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Ao salvar, o artista é criado e a música é registrada usando o id retornado.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontFamily: 'Hanken Grotesk',
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
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
}
