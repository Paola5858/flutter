import 'package:flutter/material.dart';

class VeiculoFormPage extends StatefulWidget {
  const VeiculoFormPage({super.key});

  @override
  State<VeiculoFormPage> createState() => _VeiculoFormPageState();
}

class _VeiculoFormPageState extends State<VeiculoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _placaController = TextEditingController();
  final _marcaController = TextEditingController();

  @override
  void dispose() {
    _placaController.dispose();
    _marcaController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veículo salvo localmente')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Veículo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                key: const Key('veiculo_placa_field'),
                controller: _placaController,
                decoration: const InputDecoration(labelText: 'Placa'),
                validator: (value) => value?.isEmpty ?? true ? 'Informe a placa' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('veiculo_marca_field'),
                controller: _marcaController,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (value) => value?.isEmpty ?? true ? 'Informe a marca' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                key: const Key('save_veiculo_btn'),
                onPressed: _handleSave,
                child: const Text('SALVAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
