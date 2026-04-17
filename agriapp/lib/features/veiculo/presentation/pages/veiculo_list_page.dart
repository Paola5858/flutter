import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/veiculo_bloc.dart';
import '../../../../core/theme/tokens.dart';

class VeiculoListPage extends StatelessWidget {
  const VeiculoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ColorTokenSet>()!;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text('frota ativa', style: TextStyle(color: colors.textPrimary)),
        backgroundColor: colors.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: BlocBuilder<VeiculoBloc, VeiculoState>(
          builder: (context, state) {
            if (state is VeiculoLoading) {
              return Center(
                child: CircularProgressIndicator(color: colors.primary),
              );
            }
            if (state is VeiculoError) {
              return Center(
                child: Text(
                  state.message,
                  semanticsLabel: 'erro ao carregar veículos',
                  style: TextStyle(color: colors.error),
                ),
              );
            }
            if (state is VeiculoLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: state.veiculos.length,
                itemBuilder: (context, index) {
                  final veiculo = state.veiculos[index];
                  return Semantics(
                    label:
                        'veículo marca ${veiculo.marca}, placa ${veiculo.placa}',
                    child: _VeiculoCard(veiculo: veiculo),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colors.primary,
        onPressed: () => context.read<VeiculoBloc>().add(FetchVeiculosEvent()),
        child: Icon(
          Icons.sync,
          color: colors.surface,
          semanticsLabel: 'sincronizar dados',
        ),
      ),
    );
  }
}

class _VeiculoCard extends StatelessWidget {
  final VeiculoEntity veiculo;
  const _VeiculoCard({required this.veiculo});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ColorTokenSet>()!;

    return Hero(
      tag: 'veiculo_${veiculo.id}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: colors.primary.withAlpha(25),
          onTap: () {
            // push details page
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: colors.textPrimary.withAlpha(15)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colors.primary.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(Icons.agriculture, color: colors.primary),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        veiculo.marca,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        veiculo.placa,
                        style: TextStyle(
                          color: colors.textPrimary.withAlpha(150),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
