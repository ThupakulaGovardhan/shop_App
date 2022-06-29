import 'package:flutter/material.dart';
import 'package:flutter_application_20/providers/cart.dart';
import 'package:flutter_application_20/providers/orders.dart';
import 'package:flutter_application_20/screens/splash_screen.dart';
import 'package:flutter_application_20/screens/test.dart';
import 'providers/auth.dart';
import 'package:flutter_application_20/screens/cart_screen.dart';
import 'package:flutter_application_20/screens/edit_product_screen.dart';
import 'package:flutter_application_20/screens/orders_screen.dart';


import 'package:flutter_application_20/screens/product_detail_screeen.dart';

import 'package:flutter_application_20/screens/products_overview_screen.dart';
import 'package:flutter_application_20/screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import './providers/products.dart';
import './screens/auth_screen.dart';
// this is my testing commit code....
void main () {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
    ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products("","",[]),    
             update : (ctx, auth, previousProducts) => Products(
          auth.token,
          auth.userId,
           previousProducts == null ? [] : previousProducts.items,
          ),
             ),
       
       ChangeNotifierProvider.value(
      value: Cart(),
      ),
      ChangeNotifierProxyProvider<Auth, Orders>(
        create: (_) => Orders("","",[]),
        update : (ctx, auth, previousOrders) =>  Orders(
          auth.token,
          auth.userId,
          previousOrders == null ? [] : previousOrders.orders,
        ),
      ),
    ],
    child: Consumer<Auth>(
      builder: (ctx, auth, _) => MaterialApp(
      debugShowCheckedModeBanner : false,
      title: 'MyShop',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
        fontFamily: 'Lato',

      ),
      home: 
      // TestScreen(),
      auth.isAuth?AuthScreen()
     // ? ProductsOverViewScreen()
     
      : FutureBuilder(
        future: auth.tryAutoLogin(),
        builder: (ctx, authResultSnapshot) =>
         authResultSnapshot.connectionState == 
         ConnectionState.waiting     ? SplashScreen() 
     
      // : AuthScreen(),
       : ProductsOverViewScreen(),
        
        
      ),
      routes: {
      ProductDetailScreen .routeName: (ctx) => ProductDetailScreen(), 
      CartScreen.routeName: (ctx) => CartScreen(),
      OrdersScreen.routeName: (ctx) => OrdersScreen(),
      UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
      EditProductScreen.routeName: (ctx) => EditProductScreen(),
       ProductsOverViewScreen.routeName: (ctx) => ProductsOverViewScreen(),
      AuthScreen.routeName: (ctx) => AuthScreen(),
     SplashScreen.routeName: (ctx) => SplashScreen(),
      },
    ),
    ), 
    );
  }
}