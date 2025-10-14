import 'package:flutter/material.dart';

class WebCartItem {
  final String p_id;
  final String title;
  final String subtitle;
  final String image;
  final double price;
  int quantity;

  WebCartItem({
    required this.p_id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.price,
    this.quantity = 1,
  });
}

class WebCartProvider extends ChangeNotifier {
  final List<WebCartItem> _items = [];
  List<WebCartItem> get items => _items;

  int get uniqueItemCount => _items.length;
  int get cartCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get total => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void addItem(WebCartItem newItem) {
    final index = _items.indexWhere((item) => item.p_id == newItem.p_id);
    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(newItem);
    }
    notifyListeners();
  }

  void increaseQuantity(String id) {
    final index = _items.indexWhere((item) => item.p_id == id);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String id) {
    final index = _items.indexWhere((item) => item.p_id == id);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  bool isInCart(String id) {
    return _items.any((item) => item.p_id == id);
  }

  WebCartItem? getItem(String id) {
    try {
      return _items.firstWhere((item) => item.p_id == id);
    } catch (_) {
      return null;
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.p_id == id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

// int _cartCount = 0;
//
// //int get cartCount => _cartCount;
//
// void addToCart() {
//   _cartCount++;
//   notifyListeners();
// }
//
// void clearCart() {
//   _cartCount = 0;
//   notifyListeners();
// }