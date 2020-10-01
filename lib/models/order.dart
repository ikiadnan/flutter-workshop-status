import 'dart:convert';

List<Order> todoFromJson(String str) => new List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String todoToJson(List<Order> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
    DateTime createdAt;
    DateTime updatedAt;
    String createdBy;
    String updatedBy;
    int orderId;
    String customerName;
    String customerAddress;
    int carId;
    List<String> items = [];
    List<int> itemsCount = [];
    String status;
    
    Order({
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.orderId,
      this.customerName,
      this.customerAddress,
      this.carId,
      this.items,
      this.itemsCount,
      this.status
    });

    factory Order.fromJson(Map<String, dynamic> json) => new Order(
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      orderId: json["order_id"],
      customerName: json["customer_name"],
      customerAddress: json["customer_address"],
      carId: json["car_id"],
      items: json["items"],
      itemsCount: json["items_count"],
      status: json["status"]
    );

    Map<String, dynamic> toJson() => {
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
      "created_by": createdBy,
      "updated_by": updatedBy,
      "order_id": orderId,
      "customer_name": customerName,
      "customer_address": customerAddress,
      "car_id": carId,
      "items": items,
      "items_count": itemsCount,
      "status": status
    };
}