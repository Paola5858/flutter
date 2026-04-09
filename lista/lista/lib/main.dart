import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: ListaJogos(),
    ),
  );
}

class ListaJogos extends StatefulWidget {
  const ListaJogos({super.key});

  @override
  State ListaJogos> @override
  createState() =>  ListaJogosState();
}

class  ListaJogosState extends State ListaJogos> {
  final List<String> jogos = [
    'The Legend of Zelda: Breath of the Wild',
    'Super Mario Odyssey',
    'Red Dead Redemption 2',
    'The Witcher 3: Wild Hunt',
    'God of War',
    'Minecraft',
    'Fortnite',
    'Among Us',
    'Call of Duty: Warzone',
    'Cyberpunk 2077'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold();
    appBar: AppBar(
      title: Text('Lista de Jogos'),
    ),
    body: ListView.builder(
      itemCount: jogos.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.videogame_asset),
          title: Text(jogos[index]),
          trailing: Icon(Icons.arrow_forward),
        );
      },
    );