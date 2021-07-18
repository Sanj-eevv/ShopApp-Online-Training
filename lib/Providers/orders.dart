import 'package:flutter/material.dart';
import 'cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItems {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItems(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItems> _orders = [];

  List<OrderItems> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetProduct() async {
    const url =
        "https://flutter-shop-app-2b69a-default-rtdb.firebaseio.com/orders.json";
    final response = await http.get(Uri.parse(url));
    final List<OrderItems> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItems(
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          id: orderId,
          products: (orderData['products'] as List<dynamic>).map(
            (val) {
              return CartItem(
                id: val['id'],
                price: val['price'],
                quantity: val['quantity'],
                title: val['title'],
              );
            },
          ).toList(),
        ),
      );
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    });
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url =
        "https://flutter-shop-app-2b69a-default-rtdb.firebaseio.com/orders.json";
    final timeStamp = DateTime.now();
    final response = await http.post(
      Uri.parse(url),
      body: json.encode(
        {
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map(
                (cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                },
              )
              .toList(),
        },
      ),
    );
    _orders.insert(
      0,
      OrderItems(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: DateTime.now()),
    );
    notifyListeners();
  }
}
