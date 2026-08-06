import 'package:flutter/material.dart';

void main() => runApp(const DobroApp());

class DobroApp extends StatelessWidget {
  const DobroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DobroPage(),
    );
  }
}

class DobroPage extends StatefulWidget {
  const DobroPage({super.key});

  @override
  State<DobroPage> createState() => _DobroPageState();
}

class _DobroPageState extends State<DobroPage> {
  final TextEditingController controller = TextEditingController();
  String resultado = '';

  void calcularDobro() {
    final texto = controller.text.trim().replaceAll(',', '.');
    final numero = double.tryParse(texto);
    setState(() {
      if (numero == null) {
        resultado = 'Digite um número válido';
      } else {
        final dobro = numero * 2;
        resultado = 'Dobro: $dobro';
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dobro de um número')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Digite um número',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: calcularDobro,
              child: const Text('Calcular'),
            ),
            const SizedBox(height: 12),
            Text(
              resultado,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
