import 'package:flutter_bloc/flutter_bloc.dart';
import 'veiculo_event.dart';
import 'veiculo_state.dart';
import '../../domain/usecases/get_veiculos.dart';
import '../../domain/entities/veiculo_entity.dart';

class VeiculoBloc extends Bloc<VeiculoEvent, VeiculoState> {
  final GetVeiculos getVeiculos;

  VeiculoBloc(this.getVeiculos) : super(const VeiculoState.initial()) {
    on<VeiculoEvent>(_onEvent);
  }

  Future<void> _onEvent(VeiculoEvent event, Emitter<VeiculoState> emit) async {
    await event.when(
      refresh: () => _onRefresh(emit),
      create: (veiculo) => _onCreate(veiculo, emit),
      update: (veiculo) => _onUpdate(veiculo, emit),
      delete: (id) => _onDelete(id, emit),
    );
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

  Future<void> _onCreate(VeiculoEntity veiculo, Emitter<VeiculoState> emit) async {
    emit(const VeiculoState.loading());
    try {
      emit(const VeiculoState.success());
      add(const VeiculoEvent.refresh());
    } catch (e) {
      emit(VeiculoState.error(e.toString()));
    }
  }

  Future<void> _onUpdate(VeiculoEntity veiculo, Emitter<VeiculoState> emit) async {
    emit(const VeiculoState.loading());
    try {
      emit(const VeiculoState.success());
      add(const VeiculoEvent.refresh());
    } catch (e) {
      emit(VeiculoState.error(e.toString()));
    }
  }

  Future<void> _onDelete(String id, Emitter<VeiculoState> emit) async {
    emit(const VeiculoState.loading());
    try {
      add(const VeiculoEvent.refresh());
    } catch (e) {
      emit(VeiculoState.error(e.toString()));
    }
  }
}
