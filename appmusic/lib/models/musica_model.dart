class MusicaModel {
  final int id;
  final String nomeMusica;
  final String genero;
  final int? artistaId;
  final String? nomeArtista;

  MusicaModel({
    required this.id,
    required this.nomeMusica,
    required this.genero,
    this.artistaId,
    this.nomeArtista,
  });

  factory MusicaModel.fromJson(Map<String, dynamic> json) {
    return MusicaModel(
      id: json['id'],
      nomeMusica: json['nome_musica'],
      genero: json['genero'],
      artistaId: json['artista_id'],
      // addon pode vir como objeto ou mapa
      nomeArtista: (json['_artistas'] is Map)
          ? (json['_artistas'] as Map)['nome_artista']
          : null,
    );
  }
}
