import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/modelo.dart';

class ModeloService{

  final String url = 'https://x8ki-letl-twmt.n7.xano.io/api:ijUECDHD/modelo';


  Future<List<Modelo>> listar() async{
    final resposta = await http.get(Uri.parse(url));
    final List listaJson = jsonDecode(resposta.body);
    return listaJson.map((item) => Modelo.fromJson(item)).toList();
  }


  Future<void> cadastrar(Modelo modelo) async{
    await http.post(
      Uri.parse(url),
      headers: {"Content-Type" : "application/json"},
      body: jsonEncode(modelo.toJson),
    );
  }

Future<void> editar(int id, Modelo modelo) async{
  await http.patch(
    Uri.parse('$url/$id'),
    headers: {"Content-Type" : "application/json"},
    body: jsonEncode(modelo.toJson),
  );
}

Future<void> excluir(int id) async{
 await http.delete(Uri.parse('$url/$id'));
}
}