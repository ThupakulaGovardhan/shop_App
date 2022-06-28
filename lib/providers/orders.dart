import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_20/providers/cart.dart';
import 'package:flutter_application_20/providers/products.dart';
import 'package:http/http.dart' as http;

class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

 final String authToken;
 final String userId;

 Orders(this.authToken, this.userId, this._orders); 

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
  final url = Uri.parse('https://flutter-application-ec999-default-rtdb.firebaseio.com / orders/$userId.json?auth=$authToken');  
  final responce = await http.get(url);
  final List<OrderItem> loadedOrders = [];
  final extractedData = json.decode(responce.body) as Map<String, dynamic>;
  if (extractedData == null) {
    return;
  }
  extractedData.forEach((orderId, orderData) { 
    loadedOrders.add(
      OrderItem(
        id: orderId, 
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
         products: (orderData['products'] as List<dynamic>)
         .map((item) => CartItem(
           id: item['id'],
           price: item['price'],
           quantity: item['quantity'],
           title: item['title'],
           ),
           )
         .toList(),
         ),
         );
  });
  _orders = loadedOrders.reversed.toList();
  notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse('https://flutter-application-ec999-default-rtdb.firebaseio.com / orders/$userId.json?auth=$authToken');
   final timestamp = DateTime.now();
   final responce = await http.post(
     url, 
     body: json.encode({
    'amount' : total,
    'dateTime': timestamp.toIso8601String(),
    'products': cartProducts.map((cp) => {
       'id': cp.id,
       'title': cp.title,
       'quantity': cp.quantity,
       'price': cp.price,    
    })
    .toList(),
   }),);
    _orders.insert(
      0,
      OrderItem(
      id: json.decode(responce.body) ['name'],
      amount: total,
      dateTime: DateTime.now(),
      products: cartProducts,
    ),
    );
    notifyListeners();
  }
}
