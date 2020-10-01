import 'package:cat_app/providers/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cat_app/providers/auth.dart';
import 'package:cat_app/providers/order.dart';
import 'package:cat_app/models/order.dart';
import 'package:cat_app/widgets/order_list.dart';
import 'package:cat_app/widgets/add_order.dart';

class Orders extends StatefulWidget {
  @override
  OrdersState createState() => OrdersState();
}

class OrdersState extends State<Orders> {

  bool loading = false;
  String activeTab = 'inprogress';

  toggleTodo(BuildContext context, Order order) async {

    String statusModified = order.status == 'inprogress' ? 'done' : 'inprogress';

    bool updated = await Provider.of<OrderProvider>(context).toggleTodo(order);

    // Default status message.
    Widget statusMessage = getStatusMessage('Error has occured.');

    if (true == updated) {
      if (statusModified == 'inprogress') {
        statusMessage = getStatusMessage('Order is in progress');
      }

      if (statusModified == 'done') {
        statusMessage = getStatusMessage('Order is done');
      }
    }

    if (mounted) {
      Scaffold.of(context).showSnackBar(statusMessage);
    }
  }

  Widget getStatusMessage(String message) {
    return SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
    );
  }

  void loadMore() async {

    // If we're already loading return early.
    if (loading) {
      return;
    }

    setState(() { loading = true; });

    // Loads more items in the activeTab.
    await Provider.of<OrderProvider>(context).loadMore(activeTab);

    // If auth token has expired, widget is disposed and state is not set.
    if (mounted) {
      setState(() { loading = false; });
    }
  }

  void showAddTaskSheet(context) {

    // The addTodo function is passed to the AddTodo widget
    // because modals do not have access to the Provider.
    Function addOrder = Provider.of<OrderProvider>(context).addOrder;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return AddOrder(addOrder);
      },
    );
  }

  void displayProfileMenu(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Log out'),
                onTap: () {
                  Provider.of<AuthProvider>(context, listen: false).logOut();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    final inprogressOrders = Provider.of<OrderProvider>(context).inProgressOrders;
    final doneOrders = Provider.of<OrderProvider>(context).doneOrders;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('To Do List'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_circle),
              tooltip: 'Profile',
              onPressed: () {
                displayProfileMenu(context);
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.check_box_outline_blank)),
              Tab(icon: Icon(Icons.check_box)),
            ],
            onTap: (int index) {
              setState(() {
                activeTab = index == 1 ? 'closed' : 'open';
              });
            },
          ),
        ),
        body: TabBarView(
          children: [
            orderList(context, inprogressOrders, toggleTodo, loadMore),
            orderList(context, doneOrders, toggleTodo, loadMore),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //showAddTaskSheet(context);
            Navigator.of(context).pushNamed('\print');
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

}
