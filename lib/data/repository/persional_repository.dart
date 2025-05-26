import 'package:admin_hrm/data/model/personnel_management.dart';
import 'package:admin_hrm/service/persional_service.dart';

class PersionalRepository {
  final PersionalService persionalService;

  PersionalRepository({required this.persionalService});

  Future<void> createPersonnel(PersionalManagement personnel) async {
    try {
      await persionalService.addPersional(personnel);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PersionalManagement>> getAllPersonnel() async {
    try {
      return await persionalService.getAllPersonnel();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePersional(PersionalManagement personnel) async {
    try {
      persionalService.updatePersionel(personnel);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePersonnel(String id) async {
    try {
      persionalService.deletePersonnel(id);
    } catch (e) {
      rethrow;
    }
  }
}
