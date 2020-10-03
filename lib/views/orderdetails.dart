import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:cat_app/providers/auth.dart';
import 'package:cat_app/providers/order.dart';
import 'package:cat_app/providers/database.dart';
import 'package:cat_app/models/user.dart';
import 'package:cat_app/models/order.dart';
import 'package:cat_app/models/ordercomment.dart';
import 'package:cat_app/utils/validate.dart';
import 'package:cat_app/styles/styles.dart';
import 'package:cat_app/widgets/styled_flat_button.dart';
import 'package:cat_app/widgets/notification_text.dart';


List<String> listStatus = ["Queued", "Ketok", "Dempul", "Epoxy", "Cat", "Poles", "Perakitan", "Finishing"];

class OrderDetails extends StatelessWidget {
  OrderDetails(this.order, this.comment);
  final Order order;
  final OrderComment comment;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      appBar: AppBar(
        title: Text(order.customerName),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: ()=> Navigator.pop(context),
        // ),
        backgroundColor: Color(0xFF102C58),
      ),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
            child: OrderDetailsForm(order: order, comment: comment,),
          ),
        ),
      ),
    );
  }
}

class OrderDetailsForm extends StatefulWidget {
  const OrderDetailsForm({this.order, this.comment, Key key}) : super(key: key);
  final Order order;
  final OrderComment comment;
  @override
  OrderDetailsFormState createState() => OrderDetailsFormState();
}

class OrderDetailsFormState extends State<OrderDetailsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Order oldOrder;
  OrderComment oldOrderComment;
  
  Order updatedOrder;
  OrderComment updatedComment;
  String newCustomerName;
  String newCustomerAddress;
  String newCustomerPhone;
  String newCarId;
  String newCarPlateNum;
  String newStatus;
  int newItemsRefId;
  int newStatusCommentRefId;

  bool isEditMode = false;
  bool isAddNewStatus = false;
  String newComment = "";
  final ImagePicker _picker = ImagePicker();
  PickedFile _imageFile;
  File image;

  @override
  void initState(){
    super.initState();
    oldOrder = widget.order;
    oldOrderComment = widget.comment;
    updatedComment = widget.comment;
    newCustomerName = widget.order.customerName;
    newCustomerAddress = widget.order.customerAddress;
    newCustomerPhone = widget.order.phoneNumber;
    newCarId = widget.order.carId;
    newCarPlateNum = widget.order.carPlateNum;
    newStatus = widget.order.status;
    if(listStatus.indexOf(newStatus) == 0) {
      newItemsRefId = null;
      newStatusCommentRefId = null;
    } else{
      newItemsRefId = widget.order.itemsRefId;
      newStatusCommentRefId = widget.order.statusCommentRefId;
    }
  }
  Future<void> update() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      //await Provider.of<OrderProvider>(context, listen: false).addOrder(order);
      newStatus = listStatus[listStatus.indexOf(newStatus)+1];
      User user = User.fromJson(Provider.of<AuthProvider>(context,listen: false).user);
      
      if(_imageFile != null) {
        //Map<String,String> sc = {"image": _imageFile.path, "comment": newComment};
        //newStatusComment.add(sc);
        // newStatusComment.addAll({_imageFile.path: newComment});
        if(updatedComment == null){
          updatedComment = OrderComment.fromJson(
            {
              "created_at": DateFormat.yMMMd().format(new DateTime.now()),
              "updated_at": DateFormat.yMMMd().format(new DateTime.now()),
              "created_by": user.name,
              "updated_by": user.name,
              "image_ketok": _imageFile.path,
              "comment_ketok": newComment,
              // "image_dempul": imageDempul,
              // "comment_dempul": commentDempul,
              // "image_epoxy": imageEpoxy,
              // "comment_epoxy": commentEpoxy,
              // "image_cat": imageCat,
              // "comment_cat": commentCat,
              // "image_poles": imagePoles,
              // "comment_poles": commentPoles,
              // "image_perakitan": imagePerakitan,
              // "comment_perakitan": commentPerakitan,
              // "image_finishing": imageFinishing,
              // "comment_finishing": commentFinishing,
            }
          );
        } else {
          String statusString = newStatus.toLowerCase();
          var uc = updatedComment.toJson();
          uc["updated_by"] = user.name;
          uc["image_$statusString"] = _imageFile.path;
          uc["comment_$statusString"] = newComment;
          updatedComment = OrderComment.fromJson(uc);
        }
      }
      updatedOrder = Order(
        createdAt: oldOrder.createdAt,
        updatedAt: DateFormat.yMMMd().format(new DateTime.now()),
        createdBy: oldOrder.createdBy,
        updatedBy: user.name,
        orderId: oldOrder.orderId,
        customerName: newCustomerName,
        customerAddress: newCustomerAddress,
        phoneNumber: newCustomerPhone,
        carId: newCarId,
        carPlateNum: newCarPlateNum,
        itemsRefId: oldOrder.itemsRefId,
        status: newStatus,
        statusCommentRefId: newStatusCommentRefId
      );
      var result = await DatabaseProvider.dbProvider.updateOrder(oldOrder.id, updatedOrder, updatedComment);
      if(result != null){
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        scrollDirection: Axis.vertical,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isEditMode ? editForm(): viewForm(),
          SizedBox(height: 15.0),
          showCommentsAndImages(),
          isAddNewStatus ? newCommentAndPicture(): newCommentAndPictureBtn(),
          SizedBox(height: 15.0),
          StyledFlatButton(
            'Update',
            onPressed: update,
          ),
        ],
      ),
    );
  }

  Widget newCommentAndPictureBtn(){
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(5),
      height: 80,
      decoration: BoxDecoration(
      border: Border.all(
        color: Colors.grey,
      ),
      borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: Column(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.add_circle_outline,
              color: Colors.grey,
            ),
            onPressed: (){
              setState((){
                isAddNewStatus = true;
              });
            },
          ),
          Text("Update status",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
  Widget viewForm(){
    return Container(
      padding: EdgeInsets.all(10),
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Positioned(
            top: -10,
            right: -10,
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: (){
                if(!isAddNewStatus){
                  setState((){
                    isEditMode = true;
                  });
                }
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Text("Name: ",
                    style: TextStyle(
                    fontWeight: FontWeight.bold,
                    //fontSize: 12,
                    ),
                  ),
                  Text(newCustomerName,
                    style: TextStyle(
                    //fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Car Model: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      //fontSize: 12,
                    ),
                  ),
                  Text(newCarId + " ",
                    style: TextStyle(
                    //fontSize: 12,
                    ),
                  ),
                  Text('('+ oldOrder.carPlateNum + ')',
                    style: TextStyle(
                    //fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Order Date: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      //fontSize: 12,
                    ),
                  ),
                  Text(oldOrder.createdAt.toString(),
                    style: TextStyle(
                      //fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Estimated work finish: ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      //fontSize: 12,
                    ),
                  ),
                  Text(oldOrder.createdAt.toString(),
                    style: TextStyle(
                      //fontSize: 12,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text("Status: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      //fontSize: 12,
                    ),
                  ),
                  Text(newStatus,
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget showCommentsAndImages(){
    List<Widget> widgetList = [];
    // for(int i = 1; i< listStatus.indexOf(newStatus); i++){
    //   widgetList.add(commentAndImages(listStatus[i],newStatusComment[i]));
    //   SizedBox(height: 15.0);
    // }
    int commentCount = listStatus.indexOf(newStatus);
    if(updatedComment!=null){
      var c = updatedComment.toJson();
      for(int i=1; i<= commentCount;i++){
        String stat = listStatus[i].toLowerCase();
        widgetList.add(commentAndImages(stat,c["image_$stat"], c["comment_$stat"]));
        widgetList.add(SizedBox(height: 15.0));
      }

    }
    // newStatusComment.map((image, comment) {
    //   widgetList.add(commentAndImages(listStatus[i],image, comment));
    //   SizedBox(height: 15.0);
    // });
    
    return Column(
      children: widgetList,
    );
  }
  Widget commentAndImages(String status, String image, String comment){
    return Container(
      padding: EdgeInsets.all(10),
      //height: 300,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.white,
      ),
      child: Stack(
        //alignment: Alignment.center,
        children: [
          Positioned(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Proses " + status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ),
                SizedBox(height: 15.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.file(File(image)),
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  enabled: false,
                  initialValue: comment,
                  maxLines: 5,
                  decoration: Styles.input.copyWith(
                    hintText: 'Comment',
                  ),
                  validator: (value) {
                    newComment = value.trim();
                    return Validate.requiredField(value,"comment is required");
                  }
                ),
              ],
            ), 
          ),
          
          Positioned(
            top: -10,
            right: -10,
            child: IconButton(
              icon: Icon(Icons.edit),
              onPressed: (){
                //setState((){
                  // isAddNewStatus = false;
                  // _imageFile = null;
                //});
              },
            ),
          ),
          // Positioned(
          //   left: -10,
          //   top: 55,
          //   child: FlatButton(
          //     child: Container(
          //       padding: EdgeInsets.all(10),
          //       decoration: BoxDecoration(
          //         border: Border.all(
          //           color: Colors.white,
          //         ),
          //         borderRadius: BorderRadius.all(Radius.circular(5)),
          //         color: Color(0xAA000000),
          //       ),
          //       child: Text( _imageFile == null ? "Take a photo" : "update photo",
          //         style: TextStyle(
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),
          //     onPressed: () async {
          //       chooseImageSource(context);
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
  Widget newCommentAndPicture(){
    return Container(
      padding: EdgeInsets.all(10),
      //height: 300,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.white,
      ),
      child: Stack(
        //alignment: Alignment.center,
        children: [
          Positioned(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Proses " + listStatus[listStatus.indexOf(newStatus) + 1],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ),
                SizedBox(height: 15.0),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: _imageFile == null?
                  Image(
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.fitWidth,
                    image: AssetImage("assets/images/placeholder.jpg"),
                  ) : Image.file(File(_imageFile.path)),
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  //enabled: false,
                  //initialValue: newCustomerName,
                  maxLines: 5,
                  decoration: Styles.input.copyWith(
                    hintText: 'Comment',
                  ),
                  validator: (value) {
                    newComment = value.trim();
                    return Validate.requiredField(value,"Name is required");
                  }
                ),
              ],
            ), 
          ),
          
          Positioned(
            top: -10,
            right: -10,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: (){
                setState((){
                  isAddNewStatus = false;
                  _imageFile = null;
                });
              },
            ),
          ),
          Positioned(
            left: -10,
            top: 55,
            child: FlatButton(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Color(0xAA000000),
                ),
                child: Text( _imageFile == null ? "Take a photo" : "update photo",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              onPressed: () async {
                chooseImageSource(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void chooseImageSource(BuildContext context){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Row(
          children: [
            FlatButton(
              child: Text("Camera"),
              onPressed: (){
                takeCameraPhoto();
                Navigator.pop(context);
              }
            ),
            FlatButton(
              child: Text("Gallery"),
              onPressed: (){
                takeGalleryPhoto();
                Navigator.pop(context);
              }
            ),
          ],
        );
      },
    );
  }

  void takeGalleryPhoto() async {
    _picker.getImage(source: ImageSource.gallery).then((recordedImage) {
      if (recordedImage != null && recordedImage.path != null) {
        setState(() {
            _imageFile = recordedImage;
        });
      }
    });
  }

  void takeCameraPhoto() async {
    _picker.getImage(source: ImageSource.camera)
        .then((recordedImage) {
      if (recordedImage != null && recordedImage.path != null) {
        setState(() {
          //firstButtonText = 'saving in progress...';
        });
        GallerySaver.saveImage(recordedImage.path).then((path) {
        print(recordedImage.path);
          setState(() {
            _imageFile = recordedImage;
            //firstButtonText = 'image saved!';
          });
        });
      }
    });
  }

  Widget editForm(){
    final form = _formKey.currentState;
    return Container(
      padding: EdgeInsets.all(10),
      height: 500,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Consumer<AuthProvider>(
                builder: (context, provider, child) => provider.notification ?? NotificationText(''),
              ),
              SizedBox(height: 15.0),
              TextFormField(
                //enabled: false,
                initialValue: newCustomerName,
                decoration: Styles.input.copyWith(
                  hintText: 'Nama',
                ),
                validator: (value) {
                  newCustomerName = value.trim();
                  return Validate.requiredField(value,"Name is required");
                }
              ),
              SizedBox(height: 15.0),
              TextFormField(
                //enabled: false,
                initialValue: newCustomerAddress,
                decoration: Styles.input.copyWith(
                  hintText: 'Alamat',
                ),
                validator: (value) {
                  newCustomerAddress = value.trim();
                  return Validate.requiredField(value,"Address is required");
                }
              ),
              SizedBox(height: 15.0),
              TextFormField(
                //enabled: false,
                initialValue: newCustomerPhone,
                keyboardType: TextInputType.number,
                decoration: Styles.input.copyWith(
                  hintText: 'Nomor telepon',
                ),
                validator: (value) {
                  newCustomerPhone = value.trim();
                  return Validate.requiredField(value,"Phone is required");
                }
              ),
              SizedBox(height: 15.0),
              TextFormField(
                //enabled: false,
                initialValue: newCarId,
                decoration: Styles.input.copyWith(
                  hintText: 'Car Model',
                ),
                validator: (value) {
                  newCarId = value.trim();
                  return Validate.requiredField(value,"Car model is required");
                }
              ),
              SizedBox(height: 15.0),
              TextFormField(
                //enabled: false,
                initialValue: newCarPlateNum,
                decoration: Styles.input.copyWith(
                  hintText: 'Car Plate',
                ),
                validator: (value) {
                  newCarPlateNum = value.trim();
                  return Validate.requiredField(value,"Car plate is required");
                }
              ),
              SizedBox(height: 15.0),
              Container(
                padding: EdgeInsets.all(10),
                // height: valueContainerHeight * 0.5,
                height: 50,
                decoration: ShapeDecoration(
                  //color: Colors.white70,
                  shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 0.5, 
                    style: BorderStyle.none,
                    //color: colorPage,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5)),
                  ),
                ),
                child:
                Text("Status: " + newStatus,
                ),
              ),
            ],    
          ),   
          Positioned(
            top: -10,
            right: -10,
            child: IconButton(
              icon: Icon(Icons.check),
              onPressed: (){
                setState((){
                  if(form.validate()) isEditMode = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
