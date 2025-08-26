import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';

class WishlistCard extends StatelessWidget {
  final String p_id;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String price;

  const WishlistCard({
    super.key,
    required this.p_id,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      height: 350,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imageUrl,
              height: 190,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            price,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Consumer<WishlistProvider>(
                builder: (context, wishlistProvider, _) {
                  final isWishlisted = wishlistProvider.isWishlisted(p_id);

                  return IconButton(
                    icon: Icon(
                      isWishlisted ? Icons.favorite : Icons.favorite_border,
                      size: 28,
                      color: isWishlisted
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    onPressed: () {
                      wishlistProvider.removeFromWishlist(p_id);
                    },
                  );
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final cartProvider = Provider.of<CartProvider>(context, listen: false);
                    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);

                    cartProvider.addItem(
                      CartItem(
                        p_id: p_id,
                        title: title,
                        subtitle: subtitle,
                        image: imageUrl,
                        price: int.parse(price.replaceAll(RegExp(r'[^0-9]'), '')),
                      ),
                    );

                    wishlistProvider.removeFromWishlist(p_id);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Added to Bag'),
                        duration: const Duration(seconds: 1),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 90),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Add to kaa',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
