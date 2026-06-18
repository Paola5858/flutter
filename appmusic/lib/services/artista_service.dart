import '../core/api_client.dart';

class ArtistaService {
  static Future<int> criarArtista(String nomeArtista) async {
    final data = await ApiClient.post('/artistas', {
      'nome_artista': nomeArtista,
    });
    return data['id'];
  }
}
