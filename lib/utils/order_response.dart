import 'package:cat_app/models/order.dart';

class OrderResponse {
  final  List<Order> order;
  final String apiMore;
  OrderResponse(this.order, this.apiMore);
}