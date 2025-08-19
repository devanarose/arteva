import 'package:flutter/material.dart';
import 'product_card.dart';

class Products extends StatelessWidget {
  const Products({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> productList = [
      {
        'imageUrl': 'assets/images/products/paint1.png',
        'title': 'Camel Artist Oil Colours - 40ml - Loose Tubes',
        'subtitle': 'A premium choice for oil painting enthusiasts.',
        'price': 'Rs 252',
      },
      {
        'imageUrl': 'assets/images/products/pencil1.jpg',
        'title': 'Caran DAche Grafwood Graphite Pencils - 4H to 9B - Set of 15',
        'subtitle': 'Crafted for professionals in art, architecture, and design',
        'price': 'Rs 4,752',
      },
      {
        'imageUrl': 'assets/images/products/paint2.jpg',
        'title': 'Camel Premium Poster Colours-15Ml (Loose - Colours)',
        'subtitle': 'Ideal for a smooth matte finish and opaque mass tone.',
        'price': 'Rs 24',
      },
    ];

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
              itemCount: productList.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final product = productList[index];
                return SizedBox(
                  width: MediaQuery.of(context).size.width - 130,
                  child: ProductCard(
                    imageUrl: product['imageUrl']!,
                    title: product['title']!,
                    subtitle: product['subtitle']!,
                    price: product['price']!,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
