import 'package:flutter/material.dart';
import '../widget/product_card.dart';
import '../widget/products.dart';

class CategoryProductsPage extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const CategoryProductsPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> filteredProducts = productList.where((product) {
      return product['c_id'] == categoryId;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
        child: filteredProducts.isEmpty
            ? const Center(
          child: Text('No products found in this category.'),
        )
            : GridView.builder(
          itemCount: filteredProducts.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 230,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            childAspectRatio: 0.49,
          ),
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
            return ProductCard(
              p_id: product['p_id']!,
              imageUrl: product['imageUrl']!,
              title: product['title']!,
              subtitle: product['subtitle']!,
              price: product['price']!,
              isCategoryView: true, description: '',
            );
          },
        ),
      ),
    );
  }
}
