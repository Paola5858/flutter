class ArtistaModel {
  final int id;
  final String nomeArtista;

  ArtistaModel({required this.id, required this.nomeArtista});

  factory ArtistaModel.fromJson(Map<String, dynamic> json) {
    return ArtistaModel(
      id: json['id'],
      nomeArtista: json['nome_artista'],
    );
  }
}
