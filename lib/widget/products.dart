import 'package:flutter/material.dart';
import '../database/DBHelper.dart';
import '../models/product_item.dart';
import '../screens/product_detail.dart';
import 'product_card.dart';

class Products extends StatelessWidget {
  const Products({super.key});

  Future<List<ProductItem>> loadProducts() async {
    final allProducts = await DBHelper.instance.getAllProducts();
    return allProducts.where((p) => p.section.toLowerCase() == 'popular').toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductItem>>(
      future: loadProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          print('error for products:');
          print(snapshot.error);
          return const SizedBox.shrink();
        }
        if( !snapshot.hasData || snapshot.data!.isEmpty){
          print('not has data');
          return const SizedBox.shrink();
        }

        final products = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Popular Items',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 370,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return SizedBox(
                      width: 250,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(p_id: product.p_id.toString(), title: product.title,),),);
                        },
                        child: ProductCard(
                          imageUrl: product.imageUrl,
                          title: product.title,
                          subtitle: product.subtitle,
                          price: product.price,
                          p_id: product.p_id.toString(),
                          description: product.description,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
