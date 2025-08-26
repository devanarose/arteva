import 'package:flutter/material.dart';

class WishlistItem {
  final String p_id;
  final String title;
  final String subtitle;
  final String image;
  final String price;

  WishlistItem({
    required this.p_id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.price,
  });
}

class WishlistProvider extends ChangeNotifier {
  final List<WishlistItem> _items = [];

  List<WishlistItem> get items => _items;

  void addToWishlist(WishlistItem item) {
    if (!_items.any((existing) => existing.p_id == item.p_id)) {
      _items.add(item);
      notifyListeners();
    }
  }

  void removeFromWishlist(String p_id) {
    _items.removeWhere((item) => item.p_id == p_id);
    notifyListeners();
  }

  bool isWishlisted(String p_id) {
    return _items.any((item) => item.p_id == p_id);
  }
}
