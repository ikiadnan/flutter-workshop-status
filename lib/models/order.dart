import 'dart:convert';

List<Order> orderFromJson(String str) => new List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
    int id;
    String createdAt;
    String updatedAt;
    String createdBy;
    String updatedBy;
    int orderId;
    String customerName;
    String customerAddress;
    String phoneNumber;
    String carId;
    String carPlateNum;
    int statusCommentRefId;
    int itemsRefId;
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
      this.itemsRefId,
      this.status,
      this.statusCommentRefId
    });

    factory Order.fromJson(Map<String, dynamic> json) => new Order(
      id: json["id"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      orderId: json["order_id"],
      customerName: json["customer_name"],
      customerAddress: json["customer_address"],
      phoneNumber: json["phone"],
      carId: json["car_id"],
      carPlateNum: json["car_plate"],
      itemsRefId: json["items_ref_id"],
      status: json["status"],
      statusCommentRefId: json["status_comment_ref_id"]
    );

    factory Order.fromOrderAndCommentRef(Order order, int ref) => new Order(
      id: order.id,
      createdAt: order.createdAt,
      updatedAt: order.updatedAt,
      createdBy: order.createdBy,
      updatedBy: order.updatedBy,
      orderId: order.orderId,
      customerName: order.customerName,
      customerAddress: order.customerAddress,
      phoneNumber: order.phoneNumber,
      carId: order.carId,
      carPlateNum: order.carPlateNum,
      itemsRefId: order.itemsRefId,
      status: order.status,
      statusCommentRefId: ref
    );
    Map<String, dynamic> toJson() => {
      //"id": id,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "created_by": createdBy,
      "updated_by": updatedBy,
      "order_id": orderId,
      "customer_name": customerName,
      "customer_address": customerAddress,
      "phone": phoneNumber,
      "car_id": carId,
      "car_plate": carPlateNum,
      "items_ref_id": itemsRefId,//leaves?.map((leave) => leave.toJson())?.toList(growable: false)
      "status": status,
      "status_comment_ref_id": statusCommentRefId
    };
}