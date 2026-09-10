class Usuario {
  final int? id;
  final String nome;
  final String email;
  final String senha;
  final String? fotoPath;

  const Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.fotoPath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'email': email,
        'senha': senha,
        'fotoPath': fotoPath,
      };
}
