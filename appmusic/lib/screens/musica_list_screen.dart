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
  late Future<List<MusicaModel>> future;

  @override
  void initState() {
    super.initState();
    future = MusicaService.listarMusicas();
  }

  Future<void> carregarMusicas() async {
    setState(() {
      future = MusicaService.listarMusicas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'refrão',
          style: TextStyle(
            fontFamily: 'Bricolage Grotesque',
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<MusicaModel>>(
        future: future,
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
                  'Erro: ${snapshot.error}',
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
                  color: Colors.white70,
                  fontFamily: 'Hanken Grotesk',
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 4, bottom: 100),
            itemCount: musics.length,
            itemBuilder: (context, i) => MusicaCard(musica: musics[i]),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.amber,
        shape: const CircleBorder(),
        onPressed: () async {
          final atualizou = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CadastrarMusicaScreen(),
            ),
          );

          if (atualizou == true) {
            carregarMusicas();
          }
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 28,
        ),
      ),
    );
  }
}
