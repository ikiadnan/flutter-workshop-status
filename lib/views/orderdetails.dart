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
import 'package:cat_app/widgets/popup_notification.dart';



List<String> listStatus = ["Queued", "Ketok", "Dempul", "Epoxy", "Cat", "Poles", "Perakitan", "Finishing", "Done"];

class OrderDetails extends StatelessWidget {
  OrderDetails(this.order, this.comment);
  final Order order;
  final OrderComment comment;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      appBar: AppBar(
        title: Text("Update data"),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: ()=> Navigator.pop(context),
        // ),
        backgroundColor: Color(0xFF102C58),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              color: Colors.white
            ),
            onPressed: (){
              remove(context,order);
            }
          ),
        ],
      ),
      body: Center(
        child: Container(
          child: OrderDetailsForm(order: order, comment: comment,),
        ),
      ),
    );
  }
  Future<void> remove(BuildContext context, Order order) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return 
        Column(
          children: [
            Text("Are you sure?"),
            Row(
              children: [
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () async {
                    var result = await DatabaseProvider.dbProvider.removeOrder(order).then((value) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Text("Success!");
                        }
                      );
                    });
                  }
                ),
                FlatButton(
                  child: Text("No"),
                  onPressed: (){
                    Navigator.pop(context);
                  }
                ),
              ],
            ),
          ],
        );
      },
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
      User user = User.fromJson(Provider.of<AuthProvider>(context,listen: false).user);
      
      if(_imageFile != null) {
        //Map<String,String> sc = {"image": _imageFile.path, "comment": newComment};
        //newStatusComment.add(sc);
        // newStatusComment.addAll({_imageFile.path: newComment});
        if(updatedComment == null){
          updatedComment = OrderComment.fromJson(
            {
              "created_at": DateTime.now().toIso8601String(),
              "updated_at": DateTime.now().toIso8601String(),
              "created_by": user.name,
              "updated_by": user.name,
              "image_queued": _imageFile.path,
              "comment_queued": newComment,
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
        
        newStatus = listStatus[listStatus.indexOf(newStatus)+1];
      } else if(isAddNewStatus) return;

      updatedOrder = Order(
        createdAt: oldOrder.createdAt,
        updatedAt: DateTime.now(),
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
        setState((){
          isAddNewStatus = false;
          isEditMode = false;
        });
        // showModalBottomSheet(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return Text("Success!");
        //   }
        // );
        PopupNotification("Popup");
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
          //SizedBox(height: 15),
          isAddNewStatus ? newCommentAndPicture(): newCommentAndPictureBtn(),
          //SizedBox(height: 15),
          showCommentsAndImages(),
        ],
      ),
    );
  }

  Widget newCommentAndPictureBtn(){
    if(newStatus == "Done"){
      return Container();
    } else
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left:5, right: 5),
      height: 80,
      child: StyledFlatButton(
        "Update status",
        onPressed: (){
          setState((){
            isAddNewStatus = true;
          });
        },
      ),
    );
  }
  Widget viewForm(){
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
        margin: EdgeInsets.all(20),
        height: 150,
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
                    Text(DateFormat.yMMMd().format(oldOrder.createdAt),
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
                    Text(DateFormat.yMMMd().format(oldOrder.createdAt),
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
      for(int i=commentCount - 1; i>= 0;i--){
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
    return Card(
      margin: EdgeInsets.only(bottom:10),
      child: Stack(
        //alignment: Alignment.center,
        children: [
          Positioned(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Proses " + status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  ),
                ),
                
                ClipRRect(
                  //borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                  child: image == null ? Image(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      image: AssetImage("assets/images/header.jpg"),
                      fit: BoxFit.fitHeight,
                    ) : Image.file(File(image)),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    comment,
                    style: TextStyle(
                      //fontWeight: FontWeight.bold,
                    )
                  ),
                ),
                // //SizedBox(height: 15.0),
                // TextFormField(
                //   enabled: false,
                //   initialValue: comment,
                //   maxLines: 2,
                //   decoration: Styles.input.copyWith(
                //     hintText: 'Comment',
                //   ),
                //   validator: (value) {
                //     newComment = value.trim();
                //     return Validate.requiredField(value,"comment is required");
                //   }
                // ),
              ],
            ), 
          ),
          
          Positioned(
            top: 5,
            right: 5,
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
        ],
      ),
    );
  }
  Widget newCommentAndPicture(){
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Stack(
          //alignment: Alignment.center,
          children: [
            Positioned(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    child: Text(
                      "Proses " + newStatus,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )
                    ),
                  ),
                  SizedBox(height: 15.0),
                  ClipRRect(
                    child: _imageFile == null?
                    Image(
                      width: double.infinity,
                      height: 100,
                      fit: BoxFit.fitWidth,
                      image: AssetImage("assets/images/placeholder.jpg"),
                    ) : Image.file(File(_imageFile.path)),
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    child: TextFormField(
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
                  ),
                  SizedBox(height: 15.0),
                  Container(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    child: StyledFlatButton(
                      'Update',
                      onPressed: update,
                    ),
                  ),
                ],
              ), 
            ),
            
            Positioned(
              top: -15,
              right: 0,
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
              top: 35,
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
        GallerySaver.saveImage(recordedImage.path, albumName: "realworker").then((path) {
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
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(20),
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
                StyledFlatButton(
                  'Update',
                  onPressed: update,
                ),
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: (){
                    setState((){
                      if(form.validate()) isEditMode = false;
                    });
                  },
                ),
              ],    
            ),   
            // Positioned(
            //   top: -10,
            //   right: -10,
            //   child: IconButton(
            //     icon: Icon(Icons.check),
            //     onPressed: (){
            //       setState((){
            //         if(form.validate()) isEditMode = false;
            //       });
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
