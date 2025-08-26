import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../widget/products.dart';

class ProductDetail extends StatelessWidget {
  final String p_id;
  final String title;

  const ProductDetail({
    super.key,
    required this.p_id,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final product = productList.firstWhere((product) => product['p_id'] == p_id);
    final priceInt = int.parse(product['price']!.replaceAll(RegExp(r'[^0-9]'), ''));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            elevation: 1,
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        product['imageUrl']!,
                        height: 280,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    product['title']!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product['price']!,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Product Description",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product['description']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Consumer<WishlistProvider>(
                builder: (context, wishlistProvider, _) {
                  final isWishlisted = wishlistProvider.isWishlisted(p_id);
                  return GestureDetector(
                    onTap: () {
                      if (isWishlisted) {
                        wishlistProvider.removeFromWishlist(p_id);
                      } else {
                        wishlistProvider.addToWishlist(
                          WishlistItem(
                            p_id: p_id,
                            title: product['title']!,
                            subtitle: product['subtitle']!,
                            image: product['imageUrl']!,
                            price: product['price']!,
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border,
                        color: isWishlisted
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        size: 26,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Consumer<CartProvider>(
                  builder: (context, cartProvider, _) {
                    final isInCart = cartProvider.isInCart(p_id);
                    final cartItem = cartProvider.getItem(p_id);

                    void handleBuyNow() {
                      if (!isInCart) {
                        cartProvider.addItem(
                          CartItem(
                            p_id: p_id,
                            title: product['title']!,
                            subtitle: product['subtitle']!,
                            image: product['imageUrl']!,
                            price: priceInt,
                          ),
                        );
                      }
                      Navigator.pushNamed(context, '/cartpage');
                    }

                    if (isInCart) {
                      return Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                              border: Border.all(
                                  color: Theme.of(context).primaryColor, width: 1),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () =>
                                      cartProvider.decreaseQuantity(p_id),
                                  child: Icon(Icons.remove,
                                      size: 20,
                                      color: Theme.of(context).primaryColor),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  '${cartItem?.quantity ?? 1}',
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 16),
                                InkWell(
                                  onTap: () =>
                                      cartProvider.increaseQuantity(p_id),
                                  child: Icon(Icons.add,
                                      size: 20,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: handleBuyNow,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 3,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text(
                                'Buy Now',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                cartProvider.addItem(
                                  CartItem(
                                    p_id: p_id,
                                    title: product['title']!,
                                    subtitle: product['subtitle']!,
                                    image: product['imageUrl']!,
                                    price: priceInt,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                              label: const Text(
                                'Add to Cart',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 4,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: handleBuyNow,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 4,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: const Text(
                                'Buy Now',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
