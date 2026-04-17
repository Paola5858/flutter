import 'package:flutter_bloc/flutter_bloc.dart';
import 'veiculo_event.dart';
import 'veiculo_state.dart';
import '../../domain/usecases/get_veiculos.dart';

class VeiculoBloc extends Bloc<VeiculoEvent, VeiculoState> {
  final GetVeiculos getVeiculos;

  VeiculoBloc(this.getVeiculos) : super(const VeiculoState.initial()) {
    on<VeiculoEvent>(_onEvent);
  }

  Future<void> _onEvent(VeiculoEvent event, Emitter<VeiculoState> emit) async {
    await event.when(refresh: () => _onRefresh(emit));
  }

  Future<void> _onRefresh(Emitter<VeiculoState> emit) async {
    emit(const VeiculoState.loading());
    try {
      final veiculos = await getVeiculos();
      emit(VeiculoState.loaded(veiculos));
    } catch (e) {
      emit(VeiculoState.error(e.toString()));
    }
  }
}
