import 'package:flutter/material.dart';
import '../../domain/entities/marca_entity.dart';
import '../../data/services/marca_service.dart';
import 'marca_form_screen.dart';

class MarcaScreen extends StatefulWidget {
  const MarcaScreen({super.key});
  @override
  State<MarcaScreen> createState() => _MarcaScreenState();
}

class _MarcaScreenState extends State<MarcaScreen> {
  final service = MarcaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marcas')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const MarcaFormScreen()));
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Marca>>(
        future: service.getMarcas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar marcas'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma marca encontrada'));
          } else {
            final marcas = snapshot.data!;
            return ListView.builder(
              itemCount: marcas.length,
              itemBuilder: (context, index) {
                final marca = marcas[index];
                return ListTile(
                  title: Text(marca.nome),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () async {
                          await Navigator.push(context, MaterialPageRoute(builder: (_) => MarcaFormScreen(marca: marca)));
                          setState(() {});
                        },
                      ),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await service.excluirMarca(marca.id!);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}