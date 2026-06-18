class MusicaModel {
  final int id;
  final String nomeMusica;
  final String genero;
  final int artistaId;
  final String? nomeArtista; // vem do addon configurado na etapa 5, passo 4

  MusicaModel({
    required this.id,
    required this.nomeMusica,
    required this.genero,
    required this.artistaId,
    this.nomeArtista,
  });

  factory MusicaModel.fromJson(Map<String, dynamic> json) {
    return MusicaModel(
      id: json['id'],
      nomeMusica: json['nome_musica'],
      genero: json['genero'],
      artistaId: json['artista_id'],
      // ajuste a chave abaixo pro nome exato que o addon do xano devolver
      nomeArtista: json['_artistas']?['nome_artista'],
    );
  }
}
