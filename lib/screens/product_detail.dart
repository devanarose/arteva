import 'dart:io';

import 'package:erp_demo/screens/cart_page.dart';
import 'package:erp_demo/widget/buttons.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../database/DBHelper.dart';
import '../models/product_item.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';

class ProductDetail extends StatefulWidget {
  final String p_id;
  final String title;

  const ProductDetail({
    super.key,
    required this.p_id,
    required this.title,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  late Future<ProductItem?> _productFuture;

  ProductItem? product;
  bool isLoading = true;
  String? fullImagePath;


  @override
  void initState() {
    super.initState();
    _productFuture = _loadProduct();
    print("rebuilding");
  }

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 280, width: double.infinity, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Container(height: 20, width: 150, color: Colors.grey.shade300),
          const SizedBox(height: 10),
          Container(height: 20, width: 100, color: Colors.grey.shade300),
          const SizedBox(height: 20),
          Container(height: 16, width: 130, color: Colors.grey.shade300),
          const SizedBox(height: 8),
          Container(height: 60, width: double.infinity, color: Colors.grey.shade300),
        ],
      ),
    );
  }


  Future<ProductItem?> _loadProduct() async {
    print("Loading product...");
    final fetchedProduct = await DBHelper.instance.getProductById(widget.p_id);
    if (fetchedProduct != null) {
      final dir = await getApplicationDocumentsDirectory();
      final fullPath = '${dir.path}/${fetchedProduct.imageUrl}';
      final imageExists = File(fullPath).existsSync();
      fullImagePath = imageExists ? fullPath : null;
      return fetchedProduct;
    } else {
      return null;
    }
  }

  //
  // Future<String?> _getFullImagePath(String? filename) async {
  //   if (filename == null) return null;
  //   final directory = await getApplicationDocumentsDirectory();
  //   return '${directory.path}/$filename';
  // }

  Widget _buildImage() {
    if (fullImagePath != null) {
      return Image.file(
        File(fullImagePath!),
        height: 280,
        fit: BoxFit.contain,
      );
    } else {
      return const Icon(Icons.image_not_supported, size: 280);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<ProductItem?>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
           return _buildShimmer();
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Product not found"));
          }

          final product = snapshot.data!;
          final priceInt = product.price.toInt();

          return Column(
            children: [
              Expanded(
                child: SafeArea(
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
                            Center(child: _buildImage()),
                            const SizedBox(height: 20),
                            Text(product.title, style: TextStyle(fontSize: 20)),
                            const SizedBox(height: 10),
                            Text(
                              '₹${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text("Product Description", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                            const SizedBox(height: 8),
                            Text(
                              product.description,
                              style: TextStyle(fontSize: 14, height: 1.5),
                            ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /// BOTTOM NAVIGATION BAR
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Consumer<WishlistProvider>(
                        builder: (context, wishlistProvider, _) {
                          final isWishlisted = wishlistProvider.isWishlisted(widget.p_id);
                          return GestureDetector(
                            onTap: () {
                              if (isWishlisted) {
                                wishlistProvider.removeFromWishlist(widget.p_id);
                              } else {
                                wishlistProvider.addToWishlist(
                                  WishlistItem(
                                    p_id: widget.p_id,
                                    title: product!.title,
                                    subtitle: product!.subtitle,
                                    image: product!.imageUrl,
                                    price: product!.price,
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
                                color: isWishlisted ? Theme.of(context).primaryColor : Colors.grey,
                                size: 26,
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Buttons(
                          p_id: widget.p_id,
                          title: product.title,
                          subtitle: product.subtitle,
                          image: product.imageUrl,
                          price: product.price,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
