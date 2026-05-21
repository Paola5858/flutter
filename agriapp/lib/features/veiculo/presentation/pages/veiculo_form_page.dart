import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/tokens.dart';
import '../../../marca/domain/entities/marca_entity.dart';
import '../../../modelo/domain/entities/modelo_entity.dart';
import '../../../../widgets/meu_dropdown.dart';
import '../../domain/entities/veiculo_entity.dart';
import '../blocs/veiculo_bloc.dart';
import '../blocs/veiculo_event.dart';
import '../blocs/veiculo_state.dart';

class VeiculoFormPage extends StatefulWidget {
  final VeiculoEntity? veiculo;
  const VeiculoFormPage({super.key, this.veiculo});

  @override
  State<VeiculoFormPage> createState() => _VeiculoFormPageState();
}

class _VeiculoFormPageState extends State<VeiculoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _placaController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _anoController = TextEditingController();
  final _horimetroController = TextEditingController();

  String? marcaId;
  String? modeloId;
  List<Marca> marcas = [];
  List<Modelo> modelos = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void dispose() {
    _placaController.dispose();
    _descricaoController.dispose();
    _anoController.dispose();
    _horimetroController.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    if (widget.veiculo != null) {
      _placaController.text = widget.veiculo!.placa;
      _descricaoController.text = widget.veiculo!.descricao ?? '';
      _anoController.text = widget.veiculo!.ano?.toString() ?? '';
      _horimetroController.text = widget.veiculo!.horimetro?.toString() ?? '';
      marcaId = widget.veiculo!.marcaId;
      modeloId = widget.veiculo!.modeloId;
    }
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final v = VeiculoEntity(
        id: widget.veiculo?.id ?? DateTime.now().toString(),
        placa: _placaController.text,
        marca: 'marca',
        descricao: _descricaoController.text,
        ano: int.tryParse(_anoController.text),
        horimetro: int.tryParse(_horimetroController.text),
        marcaId: marcaId,
        modeloId: modeloId,
      );
      if (widget.veiculo == null) {
        context.read<VeiculoBloc>().add(VeiculoEvent.create(v));
      } else {
        context.read<VeiculoBloc>().add(VeiculoEvent.update(v));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ColorTokens>()!;

    return Scaffold(
      backgroundColor: tokens.surface,
      appBar: AppBar(
        title: Text(widget.veiculo == null ? 'Novo Veículo' : 'Editar Veículo'),
        backgroundColor: tokens.surface,
        elevation: 0,
      ),
      body: BlocConsumer<VeiculoBloc, VeiculoState>(
        listener: (context, state) {
          state.maybeWhen(
            success: () => Navigator.pop(context),
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
              padding: const EdgeInsets.all(16.0),
              children: [
                TextFormField(
                  key: const Key('veiculo_placa_field'),
                  controller: _placaController,
                  enabled: !isLoading,
                  decoration: const InputDecoration(labelText: 'Placa'),
                  validator: (value) => (value == null || value.isEmpty) ? 'Informe a placa' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descricaoController,
                  enabled: !isLoading,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                ),
                const SizedBox(height: 12),
                MeuDropdown(
                  label: 'Marca',
                  initialValue: marcaId != null ? int.tryParse(marcaId!) : null,
                  items: marcas,
                  onChanged: (val) => setState(() => marcaId = val?.toString()),
                ),
                MeuDropdown(
                  label: 'Modelo',
                  initialValue: modeloId != null ? int.tryParse(modeloId!) : null,
                  items: modelos,
                  onChanged: (val) => setState(() => modeloId = val?.toString()),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _anoController,
                  keyboardType: TextInputType.number,
                  enabled: !isLoading,
                  decoration: const InputDecoration(labelText: 'Ano'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _horimetroController,
                  keyboardType: TextInputType.number,
                  enabled: !isLoading,
                  decoration: const InputDecoration(labelText: 'Horímetro / KM'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    key: const Key('save_veiculo_btn'),
                    onPressed: isLoading ? null : _handleSave,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('SALVAR'),
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
