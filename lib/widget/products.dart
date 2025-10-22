import 'package:flutter/material.dart';
import '../database/DBHelper.dart';
import '../models/product_item.dart';
import '../screens/product_detail.dart';
import 'product_card.dart';

class Products extends StatelessWidget {
  const Products({super.key});


  // @override
  // void initState() {
  //   super.initState();
  //   loadProducts();
  // }

  // Future<void> loadProducts() async {
  //   final popular = allProducts.where((p) => p.section.toLowerCase() == 'popular').toList();
  //   setState(() {
  //     products = popular;
  //   });
  // }
    Future<List<ProductItem>> loadProducts() async {
    final allProducts = await DBHelper.instance.getAllProducts();
    return allProducts.where((p) => p.section.toLowerCase() == 'popular').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Popular Items', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 370,
            child: FutureBuilder<List<ProductItem>>(
              future: loadProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading products'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No popular products found'));
                }

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final product = snapshot.data![index];
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
