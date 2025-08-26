import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';

class ProductCard extends StatefulWidget {
  final String p_id,imageUrl,title,subtitle,price,description;
  final VoidCallback? onTap;
  final bool isWishlistView, isCategoryView;



  const ProductCard({
    super.key,
    required this.p_id,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.description,
    this.onTap,this.isWishlistView = false, this.isCategoryView = false,
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
          // mainAxisSize: MainAxisSize.min,
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
                    final isWishlisted = wishlistProvider.isWishlisted(widget.p_id);

                    return IconButton(
                      icon: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        size: 28,
                        color: isWishlisted ? Theme.of(context).primaryColor : Colors.grey,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        if (isWishlisted) {
                          wishlistProvider.removeFromWishlist(widget.p_id);
                        } else {
                          wishlistProvider.addToWishlist(
                            WishlistItem(
                              p_id: widget.p_id,
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
                    final isInCart = cartProvider.isInCart(widget.p_id);
                    final cartItem = cartProvider.getItem(widget.p_id);

                    return isInCart
                        ? SizedBox(
                      width: (widget.isWishlistView || widget.isCategoryView) ? 110 : 170,
                      height: 40,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.5)),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => cartProvider.decreaseQuantity(widget.p_id),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                ),
                                child: Center(
                                  child: Icon(Icons.remove, size: 18, color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                '${cartItem?.quantity ?? 1}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Expanded(
                              child: InkWell(
                                onTap: () => cartProvider.increaseQuantity(widget.p_id),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Theme.of(context).primaryColor),
                                    ),
                                    child: Icon(Icons.add, size: 16, color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    )
                        : SizedBox(
                      width: (widget.isWishlistView || widget.isCategoryView) ? 110 : 170,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          cartProvider.addItem(
                            CartItem(
                              p_id: widget.p_id,
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
                        child: Text(
                          'Add to cart',
                          style: TextStyle(
                            fontSize: (widget.isWishlistView || widget.isCategoryView) ? 10.8 : 14,
                            fontWeight: FontWeight.w600,
                          ),
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

