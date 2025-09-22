import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';

class CartItemWidget extends StatefulWidget {
  final String productId;
  final CartItem item;

  const CartItemWidget({super.key, required this.productId, required this.item,});

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  late Future<File?> _imageFileFuture;

  @override
  void initState() {
    super.initState();
    _imageFileFuture = _getImageFile(widget.item.image);
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context, listen: false).userId!;
    final cartProvider = Provider.of<CartProvider>(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<File?>(
              future: _imageFileFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Image.file(
                    snapshot.data!,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                  );
                }
                return const SizedBox(
                  height: 80,
                  width: 80,
                  child: Icon(Icons.image_not_supported),
                );
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(widget.item.subtitle, maxLines: 2, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(
                    '₹${(widget.item.price * widget.item.quantity).toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => cartProvider.decreaseQuantity(widget.item.cartId,userId),
                      ),
                      Text('${widget.item.quantity}', style: const TextStyle(fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => cartProvider.increaseQuantity(widget.item.cartId,userId),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => cartProvider.removeItem(widget.item.cartId,userId),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<File?> _getImageFile(String? filename) async {
    if (filename == null || filename.isEmpty) return null;
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    print(file);
    return file.existsSync() ? file : null;
  }
}
