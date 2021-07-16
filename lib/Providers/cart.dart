import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  // Key are Products id
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void addItem(String productId, String title, double price) {
    // ProductId is the key
    if (_items.containsKey(productId)) {
      _items.update(productId, (existingElement) {
        print(existingElement.quantity + 1);
        return CartItem(
          id: existingElement.id,
          title: existingElement.title,
          price: existingElement.price,
          quantity: existingElement.quantity + 1,
        );
      });
    } else {
      _items.putIfAbsent(productId, () {
        return CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        );
      });
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
        (cartItem) {
          return CartItem(
              id: cartItem.id,
              title: cartItem.title,
              price: cartItem.price,
              quantity: cartItem.quantity - 1);
        },
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
