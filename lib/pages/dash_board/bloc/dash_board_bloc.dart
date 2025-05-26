import 'package:admin_hrm/constants/enum.dart';
import 'package:admin_hrm/data/model/order_model.dart';
import 'package:admin_hrm/utils/helpers/helper_functions.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../data/model/order_data.dart';

part 'dash_board_state.dart';
part 'dash_board_event.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(const DashboardState()) {
    on<CalculateWeeklySalesEvent>(_onCalculateWeeklySalesEvent);
    on<CalculateOrderStatusEvent>(_onCalculateOrderStatusEvent);
  }

  void _onCalculateWeeklySalesEvent(
      DashboardEvent event, Emitter<DashboardState> emit) {
    final orders = DashBoardOrderData.orders;
    List<double> weeklySales = List.filled(7, 0.0);

    final now = DateTime.now();
    final startOfWeek = THelperFunctions.getStartOfWeek(now);
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    for (var order in orders) {
      if (order.orderDate
              .isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
          order.orderDate.isBefore(endOfWeek)) {
        int dayIndex =
            (order.orderDate.weekday - 1) % 7; // 0 = Monday, 6 = Sunday
        dayIndex = dayIndex < 0 ? dayIndex + 7 : dayIndex;
        weeklySales[dayIndex] += order.totalAmount;
      }
    }

    emit(state.copyWith(weeklySales: weeklySales));
  }

  void _onCalculateOrderStatusEvent(
      DashboardEvent event, Emitter<DashboardState> emit) {
    final orders = DashBoardOrderData.orders;
    Map<OrderStatus, int> orderStatusData = {};
    Map<OrderStatus, double> totalAmounts = {};

    totalAmounts = {for (var status in OrderStatus.values) status: 0.0};
    for (var order in orders) {
      //Count Order
      final status = order.status;
      orderStatusData[status] = (orderStatusData[status] ?? 0) + 1;

      // Calculate Total Amount for each status
      totalAmounts[status] = (totalAmounts[status] ?? 0) + order.totalAmount;
    }

    emit(state.copyWith(
        orderStatusData: orderStatusData, totalAmounts: totalAmounts));
  }
}
