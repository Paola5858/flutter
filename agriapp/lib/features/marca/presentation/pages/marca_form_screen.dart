import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/marca_entity.dart';
import '../../../../core/theme/tokens.dart';
import '../blocs/marca_bloc.dart';
import '../blocs/marca_event.dart';
import '../blocs/marca_state.dart';

class MarcaFormScreen extends StatefulWidget {
  final Marca? marca;
  const MarcaFormScreen({super.key, this.marca});

  @override
  State<MarcaFormScreen> createState() => _MarcaFormScreenState();
}

class _MarcaFormScreenState extends State<MarcaFormScreen> {
  final controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.marca != null) {
      controller.text = widget.marca!.nome;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ColorTokens>()!;

    return Scaffold(
      backgroundColor: tokens.surface,
      appBar: AppBar(
        title: Text(widget.marca == null ? 'Nova Marca' : 'Editar Marca'),
        backgroundColor: tokens.surface,
        elevation: 0,
      ),
      body: BlocConsumer<MarcaBloc, MarcaState>(
        listener: (context, state) {
          state.maybeWhen(
            success: (marca) => Navigator.pop(context, marca),
            error: (msg) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg), backgroundColor: tokens.error),
            ),
            orElse: () {},
          );
        },
        builder: (context, state) {
          final isLoading = state.maybeWhen(loading: () => true, orElse: () => false);

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(SpacingTokens.md),
              children: [
                Semantics(
                  label: 'campo nome da marca',
                  child: TextFormField(
                    controller: controller,
                    enabled: !isLoading,
                    style: TypographyTokens.bodyLarge.copyWith(color: tokens.textPrimary),
                    decoration: InputDecoration(
                      labelText: 'Nome da Marca',
                      hintText: 'ex: John Deere',
                      border: const OutlineInputBorder(),
                      labelStyle: TextStyle(color: tokens.primary),
                    ),
                    validator: (val) =>
                        (val == null || val.isEmpty) ? 'nome obrigatório' : null,
                  ),
                ),
                const SizedBox(height: SpacingTokens.lg),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tokens.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<MarcaBloc>().add(
                                    MarcaEvent.save(
                                      marca: Marca(nome: controller.text),
                                      id: widget.marca?.id,
                                    ),
                                  );
                            }
                          },
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Text(widget.marca == null ? 'CADASTRAR' : 'SALVAR ALTERAÇÕES'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
