import 'package:admin_hrm/data/model/position/position_model.dart';
import 'package:admin_hrm/service/positon_service.dart';

class PositiionRepository {
  final PositionService positionService;
  PositiionRepository(this.positionService);
  Future<void> createPosition(PositionModel positionModel) async {
    await positionService.addPosition(positionModel);
  }

  Future<List<PositionModel>> getPositions() async {
    return await positionService.getPositions();
  }

  Future<void> updatePosition(PositionModel positionModel) async {
    await positionService.updatePosition(positionModel);
  }

  Future<void> deletePosition(String id) async {
    await positionService.deletePosition(id);
  }
}
