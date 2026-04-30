import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/marca_service.dart';
import 'marca_event.dart';
import 'marca_state.dart';

class MarcaBloc extends Bloc<MarcaEvent, MarcaState> {
  final MarcaService _marcaService;

  MarcaBloc(this._marcaService) : super(const MarcaState.initial()) {
    on<MarcaEvent>((event, emit) async {
      await event.map(
        save: (saveEvent) async {
          emit(const MarcaState.loading());
          try {
            if (saveEvent.id != null) {
              await _marcaService.editarMarca(saveEvent.id!, saveEvent.marca);
            } else {
              await _marcaService.cadastrarMarca(saveEvent.marca);
            }
            emit(MarcaState.success(saveEvent.marca));
          } catch (e) {
            emit(MarcaState.error(e.toString()));
          }
        },
      );
    });
  }
}