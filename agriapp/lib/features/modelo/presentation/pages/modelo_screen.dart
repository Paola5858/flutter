import 'package:flutter/material.dart';
import '../../domain/entities/modelo_entity.dart';
import '../../data/services/modelo_service.dart';
import 'modelo_form_screen.dart';

class ModeloScreen extends StatefulWidget {
  const ModeloScreen({super.key});
  @override
  State<ModeloScreen> createState() => _ModeloScreenState();
}

class _ModeloScreenState extends State<ModeloScreen> {
  final service = ModeloService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modelos de Carros")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const ModeloFormScreen()));
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Modelo>>(
        future: service.listar(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final lista = snapshot.data!;
          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, i) {
              return ListTile(
                leading: const Icon(Icons.car_repair),
                title: Text(lista[i].nome),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        await Navigator.push(context, MaterialPageRoute(builder: (_) => ModeloFormScreen(modelo: lista[i])));
                        setState(() {});
                    }),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await service.excluir(lista[i].id!);
                        setState(() {});
                    }),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}