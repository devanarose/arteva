import 'package:flutter/material.dart';

class WishlistItem {
  final String title;
  final String subtitle;
  final String image;
  final String price;

  WishlistItem({
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
    if (!_items.any((existing) => existing.title == item.title)) {
      _items.add(item);
      notifyListeners();
    }
  }

  void removeFromWishlist(String title) {
    _items.removeWhere((item) => item.title == title);
    notifyListeners();
  }

  bool isWishlisted(String title) {
    return _items.any((item) => item.title == title);
  }
}
