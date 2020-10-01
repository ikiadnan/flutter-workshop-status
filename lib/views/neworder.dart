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

class NewOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create new order'),
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
            child: NewOrderForm(),
          ),
        ),
      ),
    );
  }
}

class NewOrderForm extends StatefulWidget {
  const NewOrderForm({Key key}) : super(key: key);

  @override
  NewOrderFormState createState() => NewOrderFormState();
}

class NewOrderFormState extends State<NewOrderForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Order order;
  String customerName;
  String customerAddress;
  String customerPhone;
  String carId;
  String carPlateNum;

  Future<void> submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      //await Provider.of<OrderProvider>(context, listen: false).addOrder(order);
      User user = User.fromJson(Provider.of<AuthProvider>(context,listen: false).user);
      order = Order(
        orderId: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        createdBy: user.name,
        updatedBy: user.name,
        customerName: customerName,
        customerAddress: customerAddress,
        phoneNumber: customerPhone,
        carId: carId,
        carPlateNum: carPlateNum,
        status: "ketok",
      );
      int result = await DatabaseProvider.dbProvider.createNewOrder(order);
      if(result != null){
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Consumer<AuthProvider>(
            builder: (context, provider, child) => provider.notification ?? NotificationText(''),
          ),
          SizedBox(height: 15.0),
          TextFormField(
            decoration: Styles.input.copyWith(
              hintText: 'Nama',
            ),
            validator: (value) {
              customerName = value.trim();
              return Validate.requiredField(value,"Name is required");
            }
          ),
          SizedBox(height: 15.0),
          TextFormField(
            decoration: Styles.input.copyWith(
              hintText: 'Alamat',
            ),
            validator: (value) {
              customerAddress = value.trim();
              return Validate.requiredField(value,"Address is required");
            }
          ),
          SizedBox(height: 15.0),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: Styles.input.copyWith(
              hintText: 'Nomor telepon',
            ),
            validator: (value) {
              customerPhone = value.trim();
              return Validate.requiredField(value,"Phone is required");
            }
          ),
          SizedBox(height: 15.0),
          TextFormField(
            decoration: Styles.input.copyWith(
              hintText: 'Car Model',
            ),
            validator: (value) {
              carId = value.trim();
              return Validate.requiredField(value,"Car model is required");
            }
          ),
          SizedBox(height: 15.0),
          TextFormField(
            decoration: Styles.input.copyWith(
              hintText: 'Car Plate',
            ),
            validator: (value) {
              carPlateNum = value.trim();
              return Validate.requiredField(value,"Car plate is required");
            }
          ),
          SizedBox(height: 15.0),
          StyledFlatButton(
            'Create',
            onPressed: submit,
          ),
        ],
      ),
    );
  }
}
