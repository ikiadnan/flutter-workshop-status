import 'dart:convert';

List<Order> todoFromJson(String str) => new List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String todoToJson(List<Order> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
    DateTime createdAt;
    DateTime updatedAt;
    String createdBy;
    String updatedBy;
    int id;
    String customerName;
    String customerAddress;
    int idCar;
    List<String> items = [];
    List<int> itemsCount = [];
    String status;
    
    Order({
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.id,
      this.customerName,
      this.customerAddress,
      this.idCar,
      this.items,
      this.itemsCount,
      this.status
    });

    factory Order.fromJson(Map<String, dynamic> json) => new Order(
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      id: json["id"],
      customerName: json["customer_name"],
      customerAddress: json["customer_address"],
      idCar: json["id_car"],
      items: json["items"],
      itemsCount: json["items_count"],
      status: json["status"]
    );

    Map<String, dynamic> toJson() => {
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
      "created_by": createdBy,
      "updated_by": updatedBy,
      "id": id,
      "customer_name": customerName,
      "customer_address": customerAddress,
      "id_car": idCar,
      "items": items,
      "items_count": itemsCount,
      "status": status
    };
}