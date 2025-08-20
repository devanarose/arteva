import 'package:flutter/material.dart';

class CartItem {
  final String title;
  final String subtitle;
  final String image;
  final int price;
  int quantity;

  CartItem({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.price,
    this.quantity=1,
  });
}
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  List<CartItem> get items => _items;
  int get uniqueItemCount => _items.length;

  int get cartCount => _items.fold(0,(sum,item) => sum + item.quantity);
  double get total => _items.fold(0,(sum,item) => sum + (item.price * item.quantity));

  void addItem(CartItem newItem){
    final index = _items.indexWhere((item) => item.title == newItem.title);
    if( index >= 0){
      _items[index].quantity +=1;
    }
    else{
      _items.add(newItem);
    }
    notifyListeners();
  }

  void increaseQuantity(String title) {
    final index = _items.indexWhere((item) => item.title == title);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decreaseQuantity(String title) {
    final index = _items.indexWhere((item) => item.title == title);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  bool isInCart(String title) {
    return _items.any((item) => item.title == title);
  }

  CartItem? getItem(String title) {
    try {
      return _items.firstWhere((item) => item.title == title);
    } catch (_) {
      return null;
    }
  }

  void clear(){
    _items.clear();
    notifyListeners();
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
}