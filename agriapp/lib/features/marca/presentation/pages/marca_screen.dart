import 'package:agriapp/features/marca/domain/entities/marca_entity.dart';
import 'package:flutter/material.dart';

import '../../data/services/marca_service.dart';

class MarcaScreen extends StatelessWidget {
  const MarcaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marcas')),
      body: FutureBuilder<List<Marca>>(
        future: MarcaService().getMarcas(),
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
                );
              },
            );
          }
        },
      ),
    );
  }
}