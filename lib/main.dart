import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cat_app/providers/auth.dart';
import 'package:cat_app/providers/order.dart';

import 'package:cat_app/views/loading.dart';
import 'package:cat_app/views/login.dart';
import 'package:cat_app/views/register.dart';
// import 'package:flutter_todo/views/password_reset.dart';
import 'package:cat_app/views/orders.dart';
import 'package:cat_app/views/invoice.dart';
import 'package:cat_app/views/dashboard.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => Router(),
          '/login': (context) => LogIn(),
          '/register': (context) => Register(),
          '/print': (context) => InvoicePage(),
        },
      ),
    ),
  );
}

class Router extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);

    return Consumer<AuthProvider>(
      builder: (context, user, child) {
        switch (user.status) {
          case Status.Uninitialized:
            return Loading();
          case Status.Unauthenticated:
            return LogIn();
          case Status.Authenticated:
            return ChangeNotifierProvider(
              create: (context) => OrderProvider(authProvider),
              child: Dashboard(),
            );
          default:
            return LogIn();
        }
      },
    );
  }
}