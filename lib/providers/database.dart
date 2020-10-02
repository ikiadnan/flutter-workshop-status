import 'dart:async';
import 'dart:io';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'package:cat_app/models/user.dart';
import 'package:cat_app/models/order.dart';

final userTable = 'users';
final orderTable = 'orders';
final serviceCostTable = 'service_cost';
final itemPriceTable = 'item_price';

final adminName = 'admin';
final adminEmail = 'admin@gmail.com';
final adminPassword = 'abc';



class DatabaseProvider with ChangeNotifier {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database _database;
  final _userRef = intMapStoreFactory.store('users');
  final _orderRef = intMapStoreFactory.store('orders');

  Future<Database> get database async {
    // If completer is null, AppDatabaseClass is newly instantiated, so database is not yet opened
    if (_dbOpenCompleter == null) {
      _dbOpenCompleter = Completer();
      // Calling _openDatabase will also complete the completer with database instance
      _database = await initDatabaseProvider();
    }
    // If the database is already opened, awaiting the future will happen instantly.
    // Otherwise, awaiting the returned future will take some time - until complete() is called
    // on the Completer in _openDatabase() below.
    return _dbOpenCompleter.future;
  }


  Completer<Database> _dbOpenCompleter;

  Future<dynamic> insertAdminUser() async {
    var userlist = await getAllUserSortedByName();
    for(var user in userlist){
      if(user.name == adminName && user.password == adminPassword){
        return;
      }
    }
    User admin = User(name: adminName, email: adminEmail, password: adminPassword);
    return await insertNewUser(admin);
  }

  Future<dynamic> insertNewUser(User user) async {
    return await _userRef.add(await database, user.toJson());
  }

  // Map<String, String> body = {
  //     'name': name,
  //     'email': email,
  //     'password': password,
  //     'password_confirmation': passwordConfirm,
  //   };
  Future<int> registerNewUser(Map<String, String> body) async {
    int statusCode = 200; //OK
    if(body['password'] != body['password_confirmation']){
      statusCode = 422; 
    } else{
      User newUser = User(name: body['name'], email: body['email'], password: body['password']);
      await insertNewUser(newUser);
    }
    return statusCode;
  }

  Future<List<User>> getAllUserSortedByName() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);

    final recordSnapshots = await _userRef.find(
      await database,
      finder: finder,
    );
    // Making a List<User> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final user = User.fromJson(snapshot.value);
      print(user.toJson());
      // An ID is a key of a record from the database.
      user.id = snapshot.key;
      return user;
    }).toList();
  }
  Future<bool> authenticateUser(String email, String password) async {
    var userlist = await getAllUserSortedByName();
    for(var user in userlist){
      if(user.email == email && user.password == password) return true;
    }
    return false;
  }
  
  Future<bool> authenticateLoggedInUser(User loggedinUser) async {
    var userlist = await getAllUserSortedByName();
    for(var user in userlist){
      if(user.email == loggedinUser.email && user.password == loggedinUser.password) return true;
    }
    return false;
  }

  Future<List<Order>> getAllOrderSortedById() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('created_at', false),
    ]);

    final recordSnapshots = await _orderRef.find(
      await database,
      finder: finder,
    );
    // Making a List<User> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final order = Order.fromJson(snapshot.value);
      order.id = snapshot.key;
      print(order.id.toString() + order.toJson().toString());
      return order;
    }).toList();
  }

  Future<int> createNewOrder(Order order) async {
    return await _orderRef.add(await database, order.toJson());
  }

  Future<Map<String,dynamic>> updateOrder(int orderId, Order order) async {
    return await _orderRef.record(orderId).update(await database, order.toJson());
  }

  initDatabaseProvider() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "cat_app.db");
    _database = await databaseFactoryIo.openDatabase(path);
    _dbOpenCompleter.complete(_database);
    insertAdminUser();
  }
}