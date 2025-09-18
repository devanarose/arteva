import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item_card.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_page.dart';

class Buttons extends StatelessWidget {
  final String p_id;
  final String title;
  final String subtitle;
  final String image;
  final double price;

  const Buttons({
    super.key,
    required this.p_id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final cartItems = context.watch<CartProvider>().items;
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        final isInCart = cartProvider.isInCart(p_id);
        final cartItem = cartProvider.getItem(p_id);

        // void handleBuyNow() {
        //   if (!isInCart) {
        //     cartProvider.addItem(
        //       CartItem(
        //         p_id: p_id,
        //         title: title,
        //         subtitle: subtitle,
        //         image: image,
        //         price: price,
        //       ),
        //     );
        //   }
        //
        //   WidgetsBinding.instance.addPostFrameCallback((_) {
        //     print("navigating");
        //     Navigator.pushNamed(context, CartPage.routeName);
        //   });
        // }

        if (isInCart) {
          return Row(
            children: [
              Flexible(
                flex: 0,
                child: Container(
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
                      color: Theme.of(context).primaryColor,
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => cartProvider.decreaseQuantity(p_id),
                        child: Icon(Icons.remove, size: 20, color: Theme.of(context).primaryColor),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${cartItem?.quantity ?? 1}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () => cartProvider.increaseQuantity(p_id),
                        child: Icon(Icons.add, size: 20, color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => handleBuyNow(context),
                  // onPressed: handleBuyNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 3,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.shopping_cart_outlined, size: 20),
                  label: const Text(
                    'Go To Cart',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                        title: title,
                        subtitle: subtitle,
                        image: image,
                        price: price,
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
                  onPressed: () => handleBuyNow(context),
                  // onPressed: handleBuyNow,
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
  void handleBuyNow(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final isInCart = cartProvider.isInCart(p_id);

    if (!isInCart) {
      cartProvider.addItem(
        CartItem(
          p_id: p_id,
          title: title,
          subtitle: subtitle,
          image: image,
          price: price,
        ),
      );
    }

    // Use microtask instead of postFrameCallback
    Future.microtask(() {
      Navigator.pushNamed(context, CartPage.routeName);
    });
  }

}