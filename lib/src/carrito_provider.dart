// carrito_provider.dart
import 'package:flutter/material.dart';

class CarritoProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void addToCart(Map<String, dynamic> item) {
    _cartItems.add(item);
    notifyListeners(); // Notifica a todos los oyentes sobre el cambio
  }

  void removeFromCart(Map<String, dynamic> item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  double get totalAmount {
    double total = 0.0;
    for (var item in _cartItems) {
      total += double.tryParse(item['price'].toString()) ?? 0.0;
    }
    return total;
  }
}
