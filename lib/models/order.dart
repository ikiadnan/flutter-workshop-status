import 'dart:convert';

List<Order> orderFromJson(String str) => new List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
    int id;
    DateTime createdAt;
    DateTime updatedAt;
    String createdBy;
    String updatedBy;
    int orderId;
    String customerName;
    String customerAddress;
    String phoneNumber;
    String carId;
    String carPlateNum;
    List<String> items = [];
    List<int> itemsCount = [];
    String status;
    
    Order({
      this.id,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.orderId,
      this.customerName,
      this.customerAddress,
      this.phoneNumber,
      this.carId,
      this.carPlateNum,
      this.items,
      this.itemsCount,
      this.status
    });

    factory Order.fromJson(Map<String, dynamic> json) => new Order(
      id: json["id"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      orderId: json["order_id"],
      customerName: json["customer_name"],
      customerAddress: json["customer_address"],
      phoneNumber: json["phone"],
      carId: json["car_id"],
      carPlateNum: json["car_plate"],
      items: json["items"],
      itemsCount: json["items_count"],
      status: json["status"]
    );

    Map<String, dynamic> toJson() => {
      //"id": id,
      "created_at": createdAt.toString(),
      "updated_at": updatedAt.toString(),
      "created_by": createdBy,
      "updated_by": updatedBy,
      "order_id": orderId,
      "customer_name": customerName,
      "customer_address": customerAddress,
      "phone": phoneNumber,
      "car_id": carId,
      "car_plate": carPlateNum,
      "items": items,
      "items_count": itemsCount,
      "status": status
    };
}