import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/veiculo_entity.dart';
import '../../domain/usecases/get_veiculos.dart';

part 'veiculo_event.dart';
part 'veiculo_state.dart';
part 'veiculo_bloc.freezed.dart';

class VeiculoBloc extends Bloc<VeiculoEvent, VeiculoState> {
  final GetVeiculos getVeiculos;

  VeiculoBloc(this.getVeiculos) : super(const VeiculoState.initial()) {
    on<VeiculoEvent>((event, emit) async {
      await event.map(fetchVeiculos: (e) async => await _onFetchVeiculos(emit));
    });
  }

  Future<void> _onFetchVeiculos(Emitter<VeiculoState> emit) async {
    emit(const VeiculoState.loading());
    try {
      final veiculos = await getVeiculos();
      emit(VeiculoState.loaded(veiculos));
    } catch (e) {
      emit(VeiculoState.error(e.toString()));
    }
  }
}
