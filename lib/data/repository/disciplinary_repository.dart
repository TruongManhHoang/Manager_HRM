import 'package:admin_hrm/data/model/disciplinary/disciplinary_model.dart';
import 'package:admin_hrm/service/disciplinary_service.dart';

class DisciplinaryRepository {
  final DisciplinaryService _service;

  DisciplinaryRepository(this._service);

  Future<void> addDisciplinary(DisciplinaryModel disciplinary) =>
      _service.createDisciplinary(disciplinary);

  Future<void> updateDisciplinary(DisciplinaryModel disciplinary) =>
      _service.updateDisciplinary(disciplinary.id!, disciplinary);

  Future<void> deleteDisciplinary(String id) => _service.deleteDisciplinary(id);

  Future<DisciplinaryModel?> getDisciplinary(String id) =>
      _service.getDisciplinaryById(id);
  Future<List<DisciplinaryModel>> getAllDisciplinarys() =>
      _service.getAllDisciplinarys();
  Future<List<DisciplinaryModel>> fetchAllDisciplinary() =>
      _service.getAllDisciplinary();

  Stream<List<DisciplinaryModel>> watchAllDisciplinary() =>
      _service.streamAllDisciplinary();
}
