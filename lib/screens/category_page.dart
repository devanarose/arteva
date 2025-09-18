import 'package:erp_demo/screens/product_detail.dart';
import 'package:flutter/material.dart';

import '../database/DBHelper.dart';
import '../models/product_item.dart';
import '../widget/product_card.dart';

class CategoryProductsPage extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryProductsPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  List<ProductItem> _categoryProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategoryProducts();
  }

  Future<void> _loadCategoryProducts() async {
    final products = await DBHelper.instance.getAllProducts();
    final filtered = products.where((p) => p.c_id == widget.categoryId).toList();

    setState(() {
      _categoryProducts = filtered;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
        child: _categoryProducts.isEmpty
            ? const Center(
          child: Text('No products found in this category.'),
        )
            : GridView.builder(
          itemCount: _categoryProducts.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 230,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 0.49,
          ),
          itemBuilder: (context, index) {
            final product = _categoryProducts[index];
            return ProductCard(
              p_id: product.p_id.toString(),
              imageUrl: product.imageUrl,
              title: product.title,
              subtitle: product.subtitle,
              price: product.price,
              description: product.description,
              isCategoryView: true,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetail(p_id: product.p_id.toString(), title: product.title,),),);
              },
            );
          },
        ),
      ),
    );
  }
}
