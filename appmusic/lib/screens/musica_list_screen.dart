import 'package:flutter/material.dart';

import '../core/app_theme.dart';
import '../models/musica_model.dart';
import '../services/musica_service.dart';
import '../widgets/musica_card.dart';
import 'cadastrar_musica_screen.dart';

class MusicaListScreen extends StatefulWidget {
  const MusicaListScreen({super.key});

  @override
  State<MusicaListScreen> createState() => _MusicaListScreenState();
}

class _MusicaListScreenState extends State<MusicaListScreen> {
  late Future<List<MusicaModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = MusicaService.listarMusicas();
  }

  Future<void> _reload() async {
    setState(() {
      _future = MusicaService.listarMusicas();
    });
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
          'refrão',
          style: TextStyle(
            fontFamily: 'Bricolage Grotesque',
            fontWeight: FontWeight.w900,
            fontSize: 22,
            letterSpacing: -0.2,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<MusicaModel>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.amber),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Erro ao carregar: ${snapshot.error}',
                  style: const TextStyle(
                    color: AppTheme.rust,
                    fontFamily: 'Hanken Grotesk',
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final musics = snapshot.data ?? [];

          if (musics.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma música cadastrada.',
                style: TextStyle(
                  color: Color(0xFFF3ECDF),
                  fontFamily: 'Hanken Grotesk',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 10, bottom: 100),
            itemCount: musics.length,
            itemBuilder: (context, i) {
              return MusicaCard(musica: musics[i]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.amber,
        foregroundColor: AppTheme.ink,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        onPressed: () async {
          final shouldRefresh = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => const CadastrarMusicaScreen(),
            ),
          );

          if (shouldRefresh == true && mounted) {
            await _reload();
          }
        },
        child: const Icon(
          Icons.add,
          color: AppTheme.ink,
          size: 28,
        ),
      ),
    );
  }
}

