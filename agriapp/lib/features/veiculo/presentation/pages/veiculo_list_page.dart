import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/tokens.dart';
import 'veiculo_form_page.dart';
import '../blocs/veiculo_bloc.dart';
import '../blocs/veiculo_event.dart';
import '../blocs/veiculo_state.dart';

// leviatã rule: slivers pra 60fps, responsive breakpoints, aria semantics aaa.
class VeiculoListPage extends StatelessWidget {
  const VeiculoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<ColorTokens>()!;

    return Scaffold(
      backgroundColor: tokens.surface,
      floatingActionButton: FloatingActionButton(
        key: const Key('add_veiculo_btn'),
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const VeiculoFormPage()));
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 768;

            return RefreshIndicator(
              color: tokens.primary,
              onRefresh: () async =>
                  context.read<VeiculoBloc>().add(const VeiculoEvent.refresh()),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverAppBar(
                    floating: true,
                    title: Semantics(
                      header: true,
                      child: Text(
                        'Frota Agrícola',
                        style: TextStyle(color: tokens.textPrimary),
                      ),
                    ),
                    backgroundColor: tokens.surface,
                    elevation: 0,
                  ),
                  BlocBuilder<VeiculoBloc, VeiculoState>(
                    builder: (context, state) {
                      return state.when(
                        initial: () =>
                            const SliverToBoxAdapter(child: SizedBox.shrink()),
                        loading: () => const SliverFillRemaining(
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (msg) => SliverFillRemaining(
                          child: Center(
                            child: Text(
                              'erro crítico: $msg',
                              style: TextStyle(color: tokens.error),
                            ),
                          ),
                        ),
                        loaded: (veiculos) => SliverPadding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop
                                ? constraints.maxWidth * 0.2
                                : 16.0,
                            vertical: 16.0,
                          ),
                          sliver: SliverList.builder(
                            itemCount: veiculos.length,
                            itemBuilder: (context, index) {
                              final veiculo = veiculos[index];
                              return Semantics(
                                label: 'veículo placa ${veiculo.placa}',
                                button: true,
                                child: Hero(
                                  tag: 'veiculo_${veiculo.id}',
                                  child: Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    color: tokens.surface,
                                    elevation: 2,
                                    child: ListTile(
                                      leading: const Icon(Icons.directions_car),
                                      title: Text(veiculo.placa),
                                      subtitle: Text(
                                        'Ano: ${veiculo.ano ?? '-'} | Horas: ${veiculo.horimetro ?? '-'}',
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, color: Colors.blue),
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) => VeiculoFormPage(veiculo: veiculo),
                                                ),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () {
                                              context.read<VeiculoBloc>().add(
                                                    VeiculoEvent.delete(veiculo.id),
                                                  );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        success: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
