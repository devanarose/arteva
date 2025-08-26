import 'package:flutter/material.dart';
import '../screens/product_detail.dart';
import 'product_card.dart';

class NewArrivals extends StatelessWidget {
  const NewArrivals({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> productList = [
      {
        'p_id': 'p4',
        'imageUrl': 'assets/images/products/paint3.jpg',
        'title': 'Camel Artist Watercolour Tube Set',
        'subtitle': 'The Camel Artist Watercolour Tube Set offers vibrant, high-quality pigments in 12- and 24-shade options with various tube sizes, providing versatile, portable, and affordable watercolor paints suitable for artists of all skill levels.',
        'price': 'Rs 441',
        'description' : '',
        'c_id': 'c1',
      },
      {
        'p_id': 'p1',
        'imageUrl': 'assets/images/products/paint1.png',
        'title': 'Camel Artist Oil Colours - 40ml - Loose Tubes',
        'subtitle': 'A premium choice for oil painting enthusiasts.',
        'price': 'Rs 252',
        'description' : '',
        'c_id': 'c1',
      },
      {
        'p_id': 'p5',
        'imageUrl': 'assets/images/products/stationary1.jpg',
        'title': 'Ystudio | Rollerball Pen | Black Brassing',
        'subtitle': 'Ystudios 10th anniversary fountain pen celebrates the brand’s heritage with a beautifully crafted solid brass body, combining timeless design, balanced weight, ergonomic comfort, and the evolving patina that uniquely tells the users story.',
        'price': 'Rs 11,475',
        'description' : '',
        'c_id': 'c5',
      },
    ];

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
              itemCount: productList.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final product = productList[index];
                return SizedBox(
                  width: 250,
                  // width: MediaQuery.of(context).size.width - 130,
                  child: ProductCard(
                    imageUrl: product['imageUrl']!,
                    title: product['title']!,
                    subtitle: product['subtitle']!,
                    price: product['price']!,
                    p_id: product['p_id']!, description: '',
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(p_id: product['p_id']!, title: product['title']!,),),);
                    },
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
