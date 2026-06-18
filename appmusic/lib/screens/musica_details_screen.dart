import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/musica_model.dart';
import '../services/musica_service.dart';

class MusicaDetailsScreen extends StatefulWidget {
  const MusicaDetailsScreen({super.key, required this.musica});

  final MusicaModel musica;

  @override
  State<MusicaDetailsScreen> createState() => _MusicaDetailsScreenState();
}

class _MusicaDetailsScreenState extends State<MusicaDetailsScreen> {
  final nomeMusicaController = TextEditingController();
  final generoController = TextEditingController();

  bool isSaving = false;
  bool isDeleting = false;

  @override
  void initState() {
    super.initState();
    nomeMusicaController.text = widget.musica.nomeMusica;
    generoController.text = widget.musica.genero;
  }

  @override
  void dispose() {
    nomeMusicaController.dispose();
    generoController.dispose();
    super.dispose();
  }

  Future<void> salvarEdicao() async {
    if (!mounted) return;
    setState(() => isSaving = true);

    try {
      await MusicaService.atualizarMusica(
        musicaId: widget.musica.id,
        nomeMusica: nomeMusicaController.text.trim(),
        genero: generoController.text.trim(),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.rust,
            content: Text(
              'Erro ao atualizar: $e',
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

  Future<void> deletar() async {
    if (!mounted) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cream,
        title: const Text(
          'Confirmar',
          style: TextStyle(
            fontFamily: 'Bricolage Grotesque',
            fontWeight: FontWeight.w900,
          ),
        ),
        content: const Text(
          'Deseja excluir esta música? ',
          style: TextStyle(
            fontFamily: 'Hanken Grotesk',
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                fontFamily: 'Space Mono',
                color: AppTheme.ink,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Excluir',
              style: TextStyle(
                fontFamily: 'Space Mono',
                color: AppTheme.rust,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => isDeleting = true);
    try {
      await MusicaService.deletarMusica(musicaId: widget.musica.id);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.rust,
            content: Text(
              'Erro ao deletar: $e',
              style: const TextStyle(
                fontFamily: 'Hanken Grotesk',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.ink,
      appBar: AppBar(
        backgroundColor: AppTheme.ink,
        foregroundColor: AppTheme.cream,
        title: const Text(
          'Detalhes',
          style: TextStyle(
            fontFamily: 'Bricolage Grotesque',
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: isDeleting ? null : deletar,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
                      widget.musica.nomeMusica,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontFamily: 'Bricolage Grotesque',
                            color: AppTheme.ink,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.musica.nomeArtista ?? 'Artista',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontFamily: 'Hanken Grotesk',
                            color: AppTheme.ink.withOpacity(0.75),
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.amber.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            widget.musica.genero,
                            style: const TextStyle(
                              fontFamily: 'Space Mono',
                              color: AppTheme.ink,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cream,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: nomeMusicaController,
                      decoration: const InputDecoration(
                        labelText: 'Nome da música',
                        labelStyle: TextStyle(
                          fontFamily: 'Space Mono',
                          color: Colors.black54,
                          fontWeight: FontWeight.w800,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Hanken Grotesk',
                        color: AppTheme.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: generoController,
                      decoration: const InputDecoration(
                        labelText: 'Gênero',
                        labelStyle: TextStyle(
                          fontFamily: 'Space Mono',
                          color: Colors.black54,
                          fontWeight: FontWeight.w800,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Hanken Grotesk',
                        color: AppTheme.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.amber,
                          foregroundColor: AppTheme.ink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: isSaving ? null : salvarEdicao,
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
                          isSaving ? 'Salvando...' : 'Salvar edição',
                          style: const TextStyle(
                            fontFamily: 'Space Mono',
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.3,
                          ),
                        ),
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
}
