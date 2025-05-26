import 'package:admin_hrm/utils/helpers/helper_functions.dart';

import '../../constants/enum.dart';

class OrderModel {
  final String id;
  final OrderStatus status;
  final double totalAmount;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final String paymentMethod;

  OrderModel({
    required this.id,
    required this.status,
    required this.totalAmount,
    required this.orderDate,
    this.deliveryDate,
    this.paymentMethod = 'Credit Card',
  });

  String get formattedOrderDate => THelperFunctions.getFormattedDate(orderDate);
  String get formattedDeliveryDate => deliveryDate != null
      ? THelperFunctions.getFormattedDate(deliveryDate!)
      : '';
  String get orderStatusText => status == OrderStatus.pending
      ? 'Pending'
      : status == OrderStatus.shipped
          ? 'Shipped'
          : status == OrderStatus.delivered
              ? 'Delivered'
              : status == OrderStatus.cancelled
                  ? 'Cancelled'
                  : '';
}

class OrderData {
  static final List<OrderModel> orders = [
    OrderModel(
      id: '1',
      status: OrderStatus.pending,
      totalAmount: 100,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 3)),
    ),
    OrderModel(
      id: '2',
      status: OrderStatus.shipped,
      totalAmount: 200,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 5)),
    ),
    OrderModel(
      id: '3',
      status: OrderStatus.delivered,
      totalAmount: 300,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 7)),
    ),
    OrderModel(
      id: '4',
      status: OrderStatus.cancelled,
      totalAmount: 400,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 2)),
    ),
    OrderModel(
      id: '5',
      status: OrderStatus.pending,
      totalAmount: 500,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 4)),
    ),
    OrderModel(
      id: '6',
      status: OrderStatus.shipped,
      totalAmount: 600,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 6)),
    ),
    OrderModel(
      id: '7',
      status: OrderStatus.delivered,
      totalAmount: 700,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 8)),
    ),
    OrderModel(
      id: '8',
      status: OrderStatus.cancelled,
      totalAmount: 800,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 1)),
    ),
    OrderModel(
      id: '9',
      status: OrderStatus.pending,
      totalAmount: 900,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 3)),
    ),
    OrderModel(
      id: '10',
      status: OrderStatus.shipped,
      totalAmount: 1000,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 5)),
    ),
    OrderModel(
      id: '11',
      status: OrderStatus.delivered,
      totalAmount: 1100,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 7)),
    ),
    OrderModel(
      id: '12',
      status: OrderStatus.cancelled,
      totalAmount: 1200,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 2)),
    ),
    OrderModel(
      id: '13',
      status: OrderStatus.pending,
      totalAmount: 1300,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 4)),
    ),
    OrderModel(
      id: '14',
      status: OrderStatus.shipped,
      totalAmount: 1400,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 6)),
    ),
    OrderModel(
      id: '15',
      status: OrderStatus.delivered,
      totalAmount: 1500,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 8)),
    ),
    OrderModel(
      id: '16',
      status: OrderStatus.cancelled,
      totalAmount: 1600,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 1)),
    ),
    OrderModel(
      id: '17',
      status: OrderStatus.pending,
      totalAmount: 1700,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 3)),
    ),
    OrderModel(
      id: '18',
      status: OrderStatus.shipped,
      totalAmount: 1800,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 5)),
    ),
    OrderModel(
      id: '19',
      status: OrderStatus.delivered,
      totalAmount: 1900,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 7)),
    ),
    OrderModel(
      id: '20',
      status: OrderStatus.cancelled,
      totalAmount: 2000,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 2)),
    ),
    OrderModel(
      id: '21',
      status: OrderStatus.pending,
      totalAmount: 2100,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 4)),
    ),
    OrderModel(
      id: '22',
      status: OrderStatus.shipped,
      totalAmount: 2200,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 6)),
    ),
    OrderModel(
      id: '23',
      status: OrderStatus.delivered,
      totalAmount: 2300,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 8)),
    ),
    OrderModel(
      id: '24',
      status: OrderStatus.cancelled,
      totalAmount: 2400,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 1)),
    ),
    OrderModel(
      id: '25',
      status: OrderStatus.pending,
      totalAmount: 2500,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 3)),
    ),
    OrderModel(
      id: '26',
      status: OrderStatus.shipped,
      totalAmount: 2600,
      orderDate: DateTime.now(),
      deliveryDate: DateTime.now().add(const Duration(days: 5)),
    ),
  ];
}
