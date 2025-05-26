import 'package:admin_hrm/data/model/kpi/kpi_model.dart';

abstract class KPIState {}

class KPIInitial extends KPIState {}

class KPILoading extends KPIState {}

class KPILoaded extends KPIState {
  final List<KPIModel> kpis;
  KPILoaded(this.kpis);
}

class KPISuccess extends KPIState {
  KPISuccess();
}

class KPIError extends KPIState {
  final String message;
  KPIError(this.message);
}
