import 'package:erp_demo/screens/product_detail.dart';
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
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
      ),
      body: wishlistItems.isEmpty
          ? const Center(child: Text('Your wishlist is empty'))
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
        child: GridView.builder(
          padding: const EdgeInsets.only(bottom: 90),
          itemCount: wishlistItems.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 230,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 0.5,
          ),
          itemBuilder: (context, index) {
            final item = wishlistItems[index];
            return ProductCard(
              p_id: item.p_id,
              imageUrl: item.image,
              title: item.title,
              subtitle: item.subtitle,
              price: item.price,
              description: '',
              isWishlistView: true,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(p_id: item.p_id, title: item.title,),),);
              },
            );
          },
        ),
      ),
    );
  }
}
