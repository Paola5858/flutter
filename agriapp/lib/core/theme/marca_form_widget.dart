import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/marca_bloc.dart';
import '../blocs/marca_event.dart';
import '../../domain/entities/marca_entity.dart';
import '../../../../core/theme/tokens.dart';

class MarcaFormWidget extends StatefulWidget {
  final Marca? marca;
  const MarcaFormWidget({super.key, this.marca});

  @override
  State<MarcaFormWidget> createState() => _MarcaFormWidgetState();
}

class _MarcaFormWidgetState extends State<MarcaFormWidget> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.marca?.nome);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ColorTokens>()!;

    return Padding(
      padding: const EdgeInsets.all(SpacingTokens.md),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nome da Marca',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(tokens.radiusAsymmetric)),
              ),
              validator: (v) => v?.isEmpty ?? true ? 'obrigatório' : null,
            ),
            const SizedBox(height: SpacingTokens.lg),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<MarcaBloc>().add(MarcaEvent.save(marca: Marca(nome: _controller.text), id: widget.marca?.id));
                }
              },
              child: const Text('CONFIRMAR'),
            ),
          ],
        ),
      ),
    );
  }
}
