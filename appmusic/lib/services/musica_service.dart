import '../core/api_client.dart';
import '../models/musica_model.dart';

class MusicaService {
  static Future<List<MusicaModel>> listarMusicas() async {
    final data = await ApiClient.get('/musicas');
    return (data as List)
        .map((json) => MusicaModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static Future<void> criarMusica({
    required String nomeArtista,
    required String nomeMusica,
    required String genero,
  }) async {
    // Backend agora faz o upsert do artista em uma única requisição.
    await ApiClient.post('/musicas', {
      'nome_artista': nomeArtista,
      'nome_musica': nomeMusica,
      'genero': genero,
    });
  }

  static Future<void> atualizarMusica({
    required int musicaId,
    required String nomeMusica,
    required String genero,
  }) async {
    await ApiClient.patch('/musicas/$musicaId', {
      'nome_musica': nomeMusica,
      'genero': genero,
    });
  }

  static Future<void> deletarMusica({required int musicaId}) async {
    await ApiClient.delete('/musicas/$musicaId');
  }
}
