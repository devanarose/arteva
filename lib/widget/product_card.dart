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
        height: 350,
        margin: const EdgeInsets.only(right:4,left: 4, bottom: 8, top: 8),
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
                        size: 28,
                        color: isWishlisted ? Theme.of(context).primaryColor : Colors.grey,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (isWishlisted) {
                          wishlistProvider.removeFromWishlist(widget.title);
                        } else {
                          wishlistProvider.addToWishlist(
                            WishlistItem(
                              title: widget.title,
                              subtitle: widget.subtitle,
                              image: widget.imageUrl,
                              price: widget.price,
                            ),
                          );
                        }
                      },
                    );
                  },
                ),

                Spacer(),

                Consumer<CartProvider>(
                  builder: (context, cartProvider, _) {
                    final isInCart = cartProvider.isInCart(widget.title);
                    final cartItem = cartProvider.getItem(widget.title);

                    return isInCart
                        ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              cartProvider.decreaseQuantity(widget.title);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Theme.of(context).primaryColor),
                              ),
                              child: Icon(Icons.remove, size: 14, color: Theme.of(context).primaryColor),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${cartItem?.quantity ?? 1}',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              cartProvider.increaseQuantity(widget.title);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).primaryColor,
                              ),
                              child: const Icon(Icons.add, size: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )
                        : SizedBox(
                      width: 170,
                      // height: 36,
                      child: ElevatedButton(
                        onPressed: () {
                          cartProvider.addItem(
                            CartItem(
                              title: widget.title,
                              subtitle: widget.subtitle,
                              image: widget.imageUrl,
                              price: int.parse(widget.price.replaceAll(RegExp(r'[^0-9]'), '')),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Add to Bag',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

