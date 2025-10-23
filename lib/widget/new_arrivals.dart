import 'package:flutter/material.dart';
import '../database/DBHelper.dart';
import '../models/product_item.dart';
import '../screens/product_detail.dart';
import 'product_card.dart';

class NewArrivals extends StatelessWidget {
  const NewArrivals({super.key});

  Future<List<ProductItem>> _fetchNewArrivals() async {
    final allProducts = await DBHelper.instance.getAllProducts();
    return allProducts.where((p) => p.section.toLowerCase() == 'new').toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductItem>>(
      future: _fetchNewArrivals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          print('New arrivals error: ${snapshot.error}');
          return const SizedBox.shrink();
        }

        final products = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'New Arrivals',
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
