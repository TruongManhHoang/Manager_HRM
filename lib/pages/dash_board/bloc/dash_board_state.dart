part of 'dash_board_bloc.dart';

class DashboardState extends Equatable {
  final List<double> weeklySales;
  final List<OrderModel> orders;
  final Map<OrderStatus,int> orderStatusData;
  final Map<OrderStatus, double> totalAmounts;

   const DashboardState({
    this.weeklySales = const [],
    this.orders = const [],
    this.orderStatusData = const {},
    this.totalAmounts = const {},
  });


  DashboardState copyWith({
    List<double>? weeklySales,
    List<OrderModel>? orders,
    Map<OrderStatus, int>? orderStatusData,
    Map<OrderStatus, double>? totalAmounts,
  }) {
    return DashboardState(
      weeklySales: weeklySales ?? this.weeklySales,
      orders: orders ?? this.orders,
      orderStatusData: orderStatusData ?? this.orderStatusData,
      totalAmounts: totalAmounts ?? this.totalAmounts,
    );
  }
  @override
  List<Object?> get props => [weeklySales, orders, orderStatusData, totalAmounts];
}