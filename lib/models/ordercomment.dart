import 'dart:convert';

List<OrderComment> orderCommentFromJson(String str) => new List<OrderComment>.from(json.decode(str).map((x) => OrderComment.fromJson(x)));

String orderToJson(List<OrderComment> data) => json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

//List<String> listStatus = ["Queued", "Ketok", "Dempul", "Epoxy", "Cat", "Poles", "Perakitan", "Finishing"];

class OrderComment {
    int id;
    DateTime createdAt;
    DateTime updatedAt;
    String createdBy;
    String updatedBy;
    String imageQueued;
    String commentQueued;
    String imageKetok;
    String commentKetok;
    String imageDempul;
    String commentDempul;
    String imageEpoxy;
    String commentEpoxy;
    String imageCat;
    String commentCat;
    String imagePoles;
    String commentPoles;
    String imagePerakitan;
    String commentPerakitan;
    String imageFinishing;
    String commentFinishing;
    
    OrderComment({
      this.id,
      this.createdAt,
      this.updatedAt,
      this.createdBy,
      this.updatedBy,
      this.imageQueued,
      this.commentQueued,
      this.imageKetok,
      this.commentKetok,
      this.imageDempul,
      this.commentDempul,
      this.imageEpoxy,
      this.commentEpoxy,
      this.imageCat,
      this.commentCat,
      this.imagePoles,
      this.commentPoles,
      this.imagePerakitan,
      this.commentPerakitan,
      this.imageFinishing,
      this.commentFinishing
    });

    factory OrderComment.fromJson(Map<String, dynamic> json) => new OrderComment(
      id: json["id"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      createdBy: json["created_by"],
      updatedBy: json["updated_by"],
      imageQueued: json["image_queued"],
      commentQueued: json["comment_queued"],
      imageKetok: json["image_ketok"],
      commentKetok: json["comment_ketok"],
      imageDempul: json["image_dempul"],
      commentDempul: json["comment_dempul"],
      imageEpoxy: json["image_epoxy"],
      commentEpoxy: json["comment_epoxy"],
      imageCat: json["image_cat"],
      commentCat: json["comment_cat"],
      imagePoles: json["image_poles"],
      commentPoles: json["comment_poles"],
      imagePerakitan: json["image_perakitan"],
      commentPerakitan: json["comment_perakitan"],
      imageFinishing: json["image_finishing"],
      commentFinishing: json["comment_finishing"]
    );

    Map<String, dynamic> toJson() => {
      //"id": id,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
      "created_by": createdBy,
      "updated_by": updatedBy,
      "image_queued": imageQueued,
      "comment_queued": commentQueued,
      "image_ketok": imageKetok,
      "comment_ketok": commentKetok,
      "image_dempul": imageDempul,
      "comment_dempul": commentDempul,
      "image_epoxy": imageEpoxy,
      "comment_epoxy": commentEpoxy,
      "image_cat": imageCat,
      "comment_cat": commentCat,
      "image_poles": imagePoles,
      "comment_poles": commentPoles,
      "image_perakitan": imagePerakitan,
      "comment_perakitan": commentPerakitan,
      "image_finishing": imageFinishing,
      "comment_finishing": commentFinishing,
      
    };
}