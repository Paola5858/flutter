import 'package:flutter_bloc/flutter_bloc.dart';
import 'veiculo_event.dart';
import 'veiculo_state.dart';
import '../../domain/usecases/get_veiculos.dart';

class VeiculoBloc extends Bloc<VeiculoEvent, VeiculoState> {
  final GetVeiculos getVeiculos;

  VeiculoBloc(this.getVeiculos) : super(VeiculoInitial()) {
    on<FetchVeiculosEvent>(_onFetchVeiculos);
  }

  Future<void> _onFetchVeiculos(
    FetchVeiculosEvent event,
    Emitter<VeiculoState> emit,
  ) async {
    emit(VeiculoLoading());
    try {
      final veiculos = await getVeiculos();
      emit(VeiculoLoaded(veiculos));
    } catch (e) {
      emit(VeiculoError(e.toString()));
    }
  }
}
