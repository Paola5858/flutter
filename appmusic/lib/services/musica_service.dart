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
    required int artistaId,
    required String nomeMusica,
    required String genero,
  }) async {
    await ApiClient.post('/musicas', {
      'artista_id': artistaId,
      'nome_musica': nomeMusica,
      'genero': genero,
    });
  }
}
