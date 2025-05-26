import 'package:admin_hrm/local/hive_storage.dart';
import 'package:admin_hrm/service/kpi_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'kpi_event.dart';
import 'kpi_state.dart';

class KPIBloc extends Bloc<KPIEvent, KPIState> {
  final KPIService service;
  final GlobalStorage globalStorage;

  KPIBloc(this.service, this.globalStorage) : super(KPIInitial()) {
    on<LoadKPIs>(_onLoad);
    on<AddKPI>(_onAdd);
    on<UpdateKPI>(_onUpdate);
    on<DeleteKPI>(_onDelete);
  }

  Future<void> _onLoad(LoadKPIs event, Emitter emit) async {
    emit(KPILoading());
    try {
      final list = await service.getListKPI();
      globalStorage.fetchAllKpis(list);
      emit(KPILoaded(list));
    } catch (e) {
      emit(KPIError(e.toString()));
    }
  }

  Future<void> _onAdd(AddKPI event, Emitter emit) async {
    try {
      await service.addKPI(event.kpi);
      emit(KPISuccess());
      add(LoadKPIs());
    } catch (e) {
      emit(KPIError(e.toString()));
    }
  }

  Future<void> _onUpdate(UpdateKPI event, Emitter emit) async {
    try {
      await service.updateKPI(event.kpi);
      emit(KPISuccess());
      add(LoadKPIs());
    } catch (e) {
      emit(KPIError(e.toString()));
    }
  }

  Future<void> _onDelete(DeleteKPI event, Emitter emit) async {
    try {
      await service.deleteKPI(event.id);
      emit(KPISuccess());
      add(LoadKPIs());
    } catch (e) {
      emit(KPIError(e.toString()));
    }
  }
}
