import 'dart:math';
import 'package:admin_hrm/constants/enum.dart';
import 'package:admin_hrm/data/model/order_model.dart';
import 'package:admin_hrm/utils/helpers/helper_functions.dart';

class DashBoardOrderData {
  static List<OrderModel> get orders {
    final now = DateTime.now();
    final monday = THelperFunctions.getStartOfWeek(now);
    const allStatuses = OrderStatus.values;
    final random = Random();

    return List.generate(20, (i) {
      final status = allStatuses[i % allStatuses.length]; // phân bố đều
      return OrderModel(
        id: 'ORD${i + 1}',
        status: status,
        totalAmount: 50.0 + random.nextInt(200), // từ 50 đến 250
        orderDate:
            monday.add(Duration(days: random.nextInt(7))), // random trong tuần
      );
    });
  }
}
