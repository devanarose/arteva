import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../screens/cart_page.dart';

class ProductCard extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String price;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.price,
    this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // bool isFavorite = false;
  //
  // void toggleFavorite() {
  //   setState(() {
  //     isFavorite = !isFavorite;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 230,
        height: 370,
        margin: const EdgeInsets.only(right: 16, bottom: 16),
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
                widget.imageUrl,
                height: 190,
                width: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              widget.subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              widget.price,
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
                    final isWishlisted = wishlistProvider.isWishlisted(widget.title);

                    return IconButton(
                      icon: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        size: 30,
                        color: isWishlisted ? Theme.of(context).primaryColor : Colors.grey,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (isWishlisted) {
                          wishlistProvider.removeFromWishlist(widget.title);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Removed from wishlist'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          wishlistProvider.addToWishlist(
                            WishlistItem(
                              title: widget.title,
                              subtitle: widget.subtitle,
                              image: widget.imageUrl,
                              price: widget.price,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Added to wishlist'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),


                const SizedBox(width: 6),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final cartProvider = Provider.of<CartProvider>(context, listen: false);
                      cartProvider.addItem(
                        CartItem(
                          title: widget.title,
                          subtitle: widget.subtitle,
                          image: widget.imageUrl,
                          price: int.parse(widget.price.replaceAll(RegExp(r'[^0-9]'), '')),
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Item added to cart')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: const Text('Add to Bag'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

