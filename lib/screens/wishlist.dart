import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/wishlist_provider.dart';
import '../widget/product_card.dart';

class Wishlist extends StatelessWidget {
  const Wishlist({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistItems = Provider.of<WishlistProvider>(context).items;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Your Wishlist'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: wishlistItems.isEmpty
          ? const Center(child: Text('Your wishlist is empty'))
          : Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: wishlistItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 16,
            childAspectRatio: 0.44,
          ),
          itemBuilder: (context, index) {
            final item = wishlistItems[index];
            return ProductCard(
              imageUrl: item.image,
              title: item.title,
              subtitle: item.subtitle,
              price: item.price,
            );
          },
        ),
      ),
    );
  }
}
