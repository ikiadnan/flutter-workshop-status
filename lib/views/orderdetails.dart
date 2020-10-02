import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';

import 'package:cat_app/providers/auth.dart';
import 'package:cat_app/providers/order.dart';
import 'package:cat_app/providers/database.dart';
import 'package:cat_app/models/user.dart';
import 'package:cat_app/models/order.dart';
import 'package:cat_app/utils/validate.dart';
import 'package:cat_app/styles/styles.dart';
import 'package:cat_app/widgets/styled_flat_button.dart';
import 'package:cat_app/widgets/notification_text.dart';


List<String> listStatus = ["Queued", "Ketok", "Dempul", "Epoxy", "Cat", "Poles", "Perakitan", "Finishing"];

class OrderDetails extends StatelessWidget {
  OrderDetails(this.order);
  final Order order;
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
            child: OrderDetailsForm(order: order),
          ),
        ),
      ),
    );
  }
}

class OrderDetailsForm extends StatefulWidget {
  const OrderDetailsForm({this.order, Key key}) : super(key: key);
  final Order order;
  @override
  OrderDetailsFormState createState() => OrderDetailsFormState();
}

class OrderDetailsFormState extends State<OrderDetailsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Order oldOrder;
  
  Order updatedOrder;
  String newCustomerName;
  String newCustomerAddress;
  String newCustomerPhone;
  String newCarId;
  String newCarPlateNum;
  String newStatus;

  bool isEditMode = false;
  bool isAddNewStatus = false;

  @override
  void initState() {
    super.initState();
    oldOrder = widget.order;
    newCustomerName = widget.order.customerName;
    newCustomerAddress = widget.order.customerAddress;
    newCustomerPhone = widget.order.phoneNumber;
    newCarId = widget.order.carId;
    newCarPlateNum = widget.order.carPlateNum;
    newStatus = widget.order.status;
  }
  Future<void> update() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      //await Provider.of<OrderProvider>(context, listen: false).addOrder(order);
      User user = User.fromJson(Provider.of<AuthProvider>(context,listen: false).user);
      updatedOrder = Order(
        orderId: oldOrder.orderId,
        customerName: newCustomerName,
        customerAddress: newCustomerAddress,
        phoneNumber: newCustomerPhone,
        carId: newCarId,
        carPlateNum: newCarPlateNum,
        status: newStatus,
        createdAt: oldOrder.createdAt,
        updatedAt: DateTime.now().toUtc(),
        updatedBy: user.name,
        createdBy: oldOrder.createdBy,
      );
      print(oldOrder.id);
      var result = await DatabaseProvider.dbProvider.updateOrder(oldOrder.id, updatedOrder);
      if(result != null){
        print(result);
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
                setState((){
                  isEditMode = true;
                });
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

  Widget newCommentAndPicture(){
    bool isPictureAdded = false;
    return Container(
      padding: EdgeInsets.all(10),
      height: 300,
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image(
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.fitWidth,
                    image: AssetImage("assets/images/placeholder.jpg"),
                  ),
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  //enabled: false,
                  //initialValue: newCustomerName,
                  maxLines: 5,
                  decoration: Styles.input.copyWith(
                    hintText: 'Nama',
                  ),
                  validator: (value) {
                    //newCustomerName = value.trim();
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
                });
              },
            ),
          ),
          Positioned(
            right: 10,
            top: 50,
            child: StyledFlatButton(
              'Add',
              onPressed: (){},
            ),
          ),
        ],
      ),
    );
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
                // DropdownButtonHideUnderline(
                //   child: ButtonTheme(
                //     alignedDropdown: true,
                //     child: DropdownButton(
                //       //iconEnabledColor: colorPage,
                //       hint: Text("-"),
                //       value: newStatus,
                //       items: listStatus.map((value) {
                //         return DropdownMenuItem(
                //           child: Text(
                //             value,
                //             style: TextStyle(
                //               //fontWeight: FontWeight.bold,
                //               //fontSize: valueTextTitle,
                //               //color: colorPage,
                //             ),
                //           ),
                //           value: value,
                //         );
                //       }).toList(),
                //       onChanged: (value) {
                //         setState(() {
                //           newStatus = value;
                //         });
                //       },
                //     ),
                //   ),
                // ),
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
