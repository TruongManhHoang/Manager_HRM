// File: blocs/kpi/kpi_event.dart
import 'package:admin_hrm/data/model/kpi/kpi_model.dart';

abstract class KPIEvent {}

class LoadKPIs extends KPIEvent {
  LoadKPIs();
}

class AddKPI extends KPIEvent {
  final KPIModel kpi;
  AddKPI(this.kpi);
}

class UpdateKPI extends KPIEvent {
  final KPIModel kpi;
  UpdateKPI(this.kpi);
}

class DeleteKPI extends KPIEvent {
  final String id;

  DeleteKPI(this.id);
}
