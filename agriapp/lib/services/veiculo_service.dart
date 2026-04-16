import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/veiculo.dart';

class VeiculoService{

  final String url = 'https://x8ki-letl-twmt.n7.xano.io/api:ijUECDHD/veiculo';


  Future<List<Veiculo>> listar() async{
    final resposta = await http.get(Uri.parse(url));
    final List listaJson = jsonDecode(resposta.body);
    return listaJson.map((item) => Veiculo.fromJson(item)).toList();
  }


  Future<void> cadastrar(Veiculo veiculo) async{
    await http.post(
      Uri.parse(url),
      headers: {"Content-Type" : "application/json"},
      body: jsonEncode(veiculo.toJson),
    );
  }

Future<void> editar(int id, Veiculo veiculo) async{
  await http.patch(
    Uri.parse('$url/$id'),
    headers: {"Content-Type" : "application/json"},
    body: jsonEncode(veiculo.toJson),
  );
}

Future<void> excluir(int id) async{
 await http.delete(Uri.parse('$url/$id'));
}
}