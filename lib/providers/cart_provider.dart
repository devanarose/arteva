

import 'package:flutter/material.dart';
import 'package:erp_demo/database/DBHelper.dart';

class CartItem {
  final int cartId;
  final String p_id;
  final String title;
  final String subtitle;
  final String image;
  final double price;
  final int quantity;

  CartItem({
    required this.cartId,
    required this.p_id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.price,
    required this.quantity,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      cartId: map['cart_id'],
      p_id: map['p_id'].toString(),
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      image: map['imageUrl'] ?? '',
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'],
    );
  }
}

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get items => _cartItems;

  int get uniqueItemCount => _cartItems.length;
  int get cartCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get total => _cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  int? _userId;

  CartProvider();

  void setUserId(int userId) {
    if (_userId != userId) {
      _userId = userId;
      loadItems(userId);
    }
  }

  Future<void> loadItems(int userId) async {
    print('dndhddhdddhhhhhhhhhhhhhhhhhhh : $_userId');
    final cartData = await DBHelper.instance.getCartItems(userId);
    _cartItems = cartData.map((item) => CartItem.fromMap(item)).toList();
    notifyListeners();
  }

  Future<void> addItem(String pId, int userId, {int quantity = 1}) async {
    await DBHelper.instance.addOrUpdateCartItem(userId, int.parse(pId), quantity);
    await loadItems(userId);
  }

  Future<void> increaseQuantity(int cartId, int userId) async {
    print('increased: $cartId');
    final item = _cartItems.firstWhere((item) => item.cartId == cartId, orElse: () => throw Exception("Item not found"));
    await DBHelper.instance.updateCartItemQuantity(cartId, item.quantity + 1);
    await loadItems(userId);
  }

  Future<void> decreaseQuantity(int cartId, int userId) async {
    print('decreased: $cartId');
    final item = _cartItems.firstWhere((item) => item.cartId == cartId, orElse: () => throw Exception("Item not found"));

    if (item.quantity > 1) {
      await DBHelper.instance.updateCartItemQuantity(cartId, item.quantity - 1);
    } else {
      await DBHelper.instance.removeCartItem(cartId);
    }

    await loadItems(userId);
  }

  Future<void> removeItem(int cartId, int userId) async {
    print('removed : $cartId');
    await DBHelper.instance.removeCartItem(cartId);
    await loadItems(userId);
  }

  Future<void> clearCart(int userId) async {
    await DBHelper.instance.clearCart(userId);
    await loadItems(userId);
  }

  bool isInCart(String pId) {
    return _cartItems.any((item) => item.p_id == pId);
  }

  CartItem? getItem(String pId) {
    try {
      return _cartItems.firstWhere((item) => item.p_id == pId);
    } catch (_) {
      return null;
    }
  }
}
