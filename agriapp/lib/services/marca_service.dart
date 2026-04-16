import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/marca.dart';

class MarcaService{

  final String url = 'https://x8ki-letl-twmt.n7.xano.io/api:ijUECDHD/marca';


  Future<List<Marca>> listar() async{
    final resposta = await http.get(Uri.parse(url));
    final List listaJson = jsonDecode(resposta.body);
    return listaJson.map((item) => Marca.fromJson(item)).toList();
  }


  Future<void> cadastrar(Marca marca) async{
    await http.post(
      Uri.parse(url),
      headers: {"Content-Type" : "application/json"},
      body: jsonEncode(marca.toJson),
    );
  }

Future<void> editar(int id, Marca marca) async{
  await http.patch(
    Uri.parse('$url/$id'),
    headers: {"Content-Type" : "application/json"},
    body: jsonEncode(marca.toJson),
  );
}

Future<void> excluir(int id) async{
 await http.delete(Uri.parse('$url/$id'));
}
}