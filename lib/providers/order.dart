import 'package:flutter/material.dart';

import 'package:cat_app/providers/auth.dart';
import 'package:cat_app/utils/exceptions.dart';
import 'package:cat_app/utils/order_response.dart';
//import 'package:cat_app/services/api.dart';
import 'package:cat_app/models/order.dart';
import 'package:cat_app/providers/database.dart';

class OrderProvider with ChangeNotifier {
  bool _initialized = false;

  // AuthProvier
  AuthProvider authProvider;

  // Stores separate lists for open and closed todos.
  List<Order> _inprogressOrders = List<Order>();
  List<Order> _doneOrders = List<Order>();

  // The API is paginated. If there are more results we store
  // the API url in order to lazily load them later.
  String _openTodosApiMore; 
  String _closedTodosApiMore;

  // API Service
  //ApiService apiService;

  // Provides access to private variables.
  bool get initialized => _initialized;
  List<Order> get inProgressOrders => _inprogressOrders;
  List<Order> get doneOrders => _doneOrders;
  String get openTodosApiMore => _openTodosApiMore;
  String get closedTodosApiMore => _closedTodosApiMore;

  // AuthProvider is required to instaniate our ApiService.
  // This gives the service access to the user token and provider methods.
  OrderProvider(AuthProvider authProvider) {
    //this.apiService = ApiService(authProvider);
    this.authProvider = authProvider;

    init();
  }

  void init() async {
    try {
      //TodoResponse openTodosResponse = await apiService.getTodos('open');
     // TodoResponse closedTodosResponse = await apiService.getTodos('closed');

      _initialized = true;
      // _openTodos = openTodosResponse.todos;
      // _openTodosApiMore = openTodosResponse.apiMore;
      // _closedTodos = closedTodosResponse.todos;
      // _closedTodosApiMore = closedTodosResponse.apiMore;

      notifyListeners();
    }
    // on AuthException {
    //   // API returned a AuthException, so user is logged out.
    //   await authProvider.logOut(true);
    // }
    catch (Exception) {
      print(Exception);
    }
  }

  Future<int> addOrder(Order order) async {
      return await DatabaseProvider.dbProvider.createNewOrder(order);
      //notifyListeners();
  }

  Future<List<Map<String,dynamic>>> getAllOrder() async {
    return await DatabaseProvider.dbProvider.getAllOrderSortedById();
  }

  Future<bool> toggleTodo(Order order) async {
    List<Order> inprogressOdersModified = _inprogressOrders;
    List<Order> doneOrdersModified = _doneOrders;

    // Get current status in case there's an error and new status isn't set.
    String status = order.status;

    // Get the new status for the the todo.
    String statusModified = order.status == 'inprogress' ? 'done' : 'inprogress';

    // Set the todo status to processing while we wait for the API call to complete.
    order.status = 'inprogress';
    notifyListeners();

    // Updates the status via an API call.
    //try {
      //await apiService.toggleTodoStatus(todo.id, statusModified);
    //}
    // on AuthException {
    //   // API returned a AuthException, so user is logged out.
    //   await authProvider.logOut(true);
    //   return false;
    // }
    // catch (Exception) {
    //   print(Exception);

    //   // If API update failed, we set the status back to original state.
    //   todo.status = status;
    //   notifyListeners();
    //   return false;
    // }

    // Modify the todo with the new status.
    Order modifiedOrder = order;
    modifiedOrder.status = statusModified;

    if (statusModified == 'inprogress') {
      inprogressOdersModified.add(modifiedOrder);
      doneOrdersModified.remove(order);
    }

    if (statusModified == 'done') {
      inprogressOdersModified.add(modifiedOrder);
      doneOrdersModified.remove(order);
    }

    _inprogressOrders = doneOrdersModified;
    _doneOrders = inprogressOdersModified;
    notifyListeners();
    return true;

  }

  Future<void> loadMore(String activeTab) async {
    // Set apiMore based on the activeTab.
    String apiMore = (activeTab == 'open') ? _openTodosApiMore : _closedTodosApiMore;

    // If there's no more items to load, return early.
    if (apiMore == null) {
      return;
    }

    try {
      // Make the API call to get more todos.
      //TodoResponse todosResponse = await apiService.getTodos(activeTab, url: apiMore);

      // Get the current todos for the active tab.
      //List<Todo> currentTodos = (activeTab == 'open') ? _openTodos : _closedTodos;

      // Combine current todos with new results from API.
      //List<Todo> allTodos = [...currentTodos, ...todosResponse.todos];

      // if (activeTab == 'open') {
      //   _openTodos = allTodos;
      //   _openTodosApiMore = todosResponse.apiMore;
      // }

      // if (activeTab == 'closed') {
      //   _closedTodos = allTodos;
      //   _closedTodosApiMore = todosResponse.apiMore;
      // }

      notifyListeners();
    }
    // on AuthException {
    //   // API returned a AuthException, so user is logged out.
    //   await authProvider.logOut(true);
    // }
    catch (Exception) {
      print(Exception);
    }

  }
}