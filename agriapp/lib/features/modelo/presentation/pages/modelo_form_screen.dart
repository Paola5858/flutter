import 'package:flutter/material.dart';
import '../../domain/entities/modelo_entity.dart';
import '../../data/services/modelo_service.dart';

class ModeloFormScreen extends StatefulWidget {
  final Modelo? modelo;
  const ModeloFormScreen({super.key, this.modelo});

  @override
  State<ModeloFormScreen> createState() => _ModeloFormScreenState();
}

class _ModeloFormScreenState extends State<ModeloFormScreen> {
  final controller = TextEditingController();
  final service = ModeloService();

  @override
  void initState() {
    super.initState();
    if (widget.modelo != null) {
      controller.text = widget.modelo!.nome;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.modelo == null ? "Novo Modelo" : "Editar Modelo")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: controller, decoration: const InputDecoration(labelText: "Nome do Modelo")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final m = Modelo(nome: controller.text);
                if (widget.modelo == null) {
                  await service.cadastrar(m);
                } else {
                  await service.editar(widget.modelo!.id!, m);
                }
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text("SALVAR MODELO"),
            )
          ],
        ),
      ),
    );
  }
}