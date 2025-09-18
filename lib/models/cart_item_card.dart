import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../screens/product_detail.dart';
class CartItemm extends StatelessWidget {
  final CartItem item;
  const CartItemm({super.key, required this.item});

  Future<File?> _getFullImagePath(String? filename) async {
    if (filename == null || filename.isEmpty) return null;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    return file.existsSync() ? file : null;
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Stack(
      children: [
        GestureDetector(
          onTap: () {Navigator.push( context, MaterialPageRoute(builder: (_) => ProductDetail(p_id: item.p_id, title: item.title),),);
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF1F8F6),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withAlpha(20),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: FutureBuilder<File?>(
                    future: _getFullImagePath(item.image),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Image.file(
                          snapshot.data!,
                          height: 90,
                          width: 90,
                          fit: BoxFit.cover,
                        );
                      }
                      return const SizedBox(
                        height: 90,
                        width: 90,
                        child: Center(
                          child: Icon(Icons.image_not_supported, size: 40),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.teal),
                                  onPressed: () => cartProvider.decreaseQuantity(item.p_id),
                                  splashRadius: 20,
                                ),
                                Selector<CartProvider, int>(
                                  selector: (_, provider) {
                                    return provider.items.firstWhere((i) => i.p_id == item.p_id).quantity;
                                  },
                                  builder: (context, quantity, _) {
                                    return Text(
                                      '$quantity',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, color: Colors.teal),
                                  onPressed: () => cartProvider.increaseQuantity(item.p_id),
                                  splashRadius: 20,
                                ),
                              ],
                            ),
                          ),
                          Selector<CartProvider, double>( //looking for change in cart
                            selector: (_, provider) {
                              final currentItem = provider.items.firstWhere((i) => i.p_id == item.p_id);
                              return currentItem.price * currentItem.quantity;
                            },
                            builder: (context, itemTotalPrice, _) {
                              return Text(
                                '₹${itemTotalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 45,
          left: 230,
          child: GestureDetector(
            onTap: () => cartProvider.removeItem(item.p_id),
            child: Container(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              padding: const EdgeInsets.all(3),
              child: const Icon(Icons.delete_outline, size: 25, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
