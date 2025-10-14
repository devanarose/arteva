import 'package:erp_demo/widget/web_product_card.dart';
import 'package:flutter/material.dart';
import '../screens/product_detail.dart';
import 'product_card.dart';

final List<Map<String, dynamic>> productList = [
  {
    'p_id': 'p1',
    'imageUrl': 'assets/images/products/paint1.png',
    'title': 'Camel Artist Oil Colours - 40ml - Loose Tubes',
    'subtitle': 'A premium choice for oil painting enthusiasts.',
    'price': 252,
    'c_id': 'c1',
    'description' : 'Camel Artists Acrylic Colour Tubes - Camel Artists Acrylic Colour Tubes come in 40ml tubes. These tubes provide artists with a convenient and versatile way to access high-quality acrylic paint for their projects. Whether youre working on canvas, paper, wood, or other surfaces, these 40ml tubes offer ample paint for various painting sessions, allowing artists to explore their creativity without worrying about running out of paint too quickly.\n\nKey Features:\n\nHigh-Quality Pigments: Formulated with high-quality pigments, these acrylic colors offer rich, vibrant hues that retain their intensity over time.\n\nVersatile Application: Suitable for a wide range of surfaces including canvas, paper, wood, fabric, and more, providing flexibility in artistic endeavors.\n\nExcellent Coverage: These acrylic colors provide excellent coverage and opacity, allowing for smooth and even application, ensuring prsional-looking results.\n\nQuick Drying: Acrylic paints dry quickly to a durable finish, enabling artists to work efficiently and layer colors without waiting for extended drying times.\n\nIntermixable: Camel Artists Acrylic Colour Tubes can be easily mixed together to create custom shades and hues, offering endless possibilities for experimentation and creativity.\n\n\tConvenient Tube Size: Packaged in 40ml tubes, with 60 different shades, these acrylic colors offer a convenient and portable option for artists, providing ample paint for various projects.\n\nLong-Lasting: These acrylic colors are resistant to fading and yellowing over time, ensuring that artworks retain their vibrancy and quality for years to come.\n\nWide Range of Colors: Available in a diverse range of colors, artists can easily find the perfect shades to suit their artistic preferences and project requirements.\n\nCountry of Origin: India',
  },
  {
    'p_id': 'p2',
    'imageUrl': 'assets/images/products/pencil1.jpg',
    'title': 'Caran DAche Grafwood Graphite Pencils - 4H to 9B - Set of 15',
    'subtitle': 'Crafted for professionals in art, architecture, and design',
    'price': 4752,
    'c_id': 'c5',
    'description' : 'Caran DAche Grafwood Extra-Fine Graphite Pencils offer an unmatched range of 15 degrees of hardness from 4H to 9B, crafted for professionals in art, architecture, and design. Each pencil is coated with a varnish that matches the graphite grade, making identification intuitive and visual.\n\n-Full range from 4H to 9B - 15 degrees of graphite hardness.\n\n-Premium FSC-certified cedar wood construction.\n\nSuperior quality graphite leads from hard to soft.\n\nHexagonal barrel for ergonomic grip and control\n\nDiameter varies from 2.1mm to 3.6mm for different techniques\n\nVarnish color precisely indicates graphite grade\n\nSwiss Made - trusted by professionals worldwide\n\nTechniques Supported\n\nPointillism\n\nHatching and crosshatching\n\nSketching and shading\n\nTechnical and scientific drawing\n\nBlending and blurring\n\nMixed media and detailed illustrations\n\nRecommended Usage\n\n9B - 3B: Ideal for uniform shading and bold, expressive stroke\n\n2B - H: Perfect for precise hatching and layering\n\n2H - 4H: Best for fine detailing, technical drawing, and light line work',
    'section': 'popular',

  },
  {
    'p_id': 'p3',
    'imageUrl': 'assets/images/products/paint2.jpg',
    'title': 'Camel Premium Poster Colours-15Ml (Loose - Colours)',
    'subtitle': 'Ideal for a smooth matte finish and opaque mass tone.',
    'price': 24.0,
    'c_id': 'c1',
    'description' : 'Camel Premium Poster Colours in 15ml tubes are a versatile and high-quality range of poster paints designed for artists, students, and hobbyists. These poster colours offer excellent coverage, vibrant pigments, and smooth application, making them ideal for various art projects. Camel Premium Poster Colours are available in 54 different shades.\n\nCamel Premium Poster Colours 15ml Bottle Ideal for a smooth matte finish and a completely opaque mass tone. Made from the finest pigments, they give high covering capacity with a brush Easy to mix, flows easily, and dry quickly.\n\nGives brighter artwork and superior visual impact Must be carefully used as they are moderately permanent and lose their brilliance on intermixing.\n\nEach 15ml tube contains rich and opaque poster paint that can be easily applied on paper, cardboard, and other suitable surfaces. The consistency of the paint allows for smooth brushstrokes, seamless blending, and precise detailing, ensuring your artwork stands out.\n\nThe Camel Premium Poster Colours exhibit impressive color saturation, providing bright and bold hues that capture attention. From primary colors to a wide range of shades, the color selection allows for endless creative possibilities.\n\nThese poster colours dry quickly, allowing you to work efficiently and build layers without smudging. Once dry, the colors retain their vibrancy and do not fade easily, ensuring the longevity of your artwork.\n\nWhether youre creating posters, illustrations, crafts, or school projects, Camel Premium Poster Colours in 15ml tubes are a reliable choice. The compact size of the tubes makes them convenient for travel and easy to store in your art supplies collection.\n\nUnleash your creativity with these versatile poster colours and bring your ideas to life with vibrant and eye-catching artwork.\n\nCountry of Origin: India',
    'section': 'popular',

  },
  {
    'p_id': 'p4',
    'imageUrl': 'assets/images/products/paint3.jpg',
    'title': 'Camel Artist Watercolour Tube Set',
    'subtitle': 'The Camel Artist Watercolour Tube Set offers vibrant, high-quality pigments in 12- and 24-shade options with various tube sizes, providing versatile, portable, and affordable watercolor paints suitable for artists of all skill levels.',
    'price': 441,
    'description' : '',
    'c_id': 'c1',
    'section': 'new',

  },
  {
    'p_id': 'p5',
    'imageUrl': 'assets/images/products/stationary1.jpg',
    'title': 'Ystudio | Rollerball Pen | Black Brassing',
    'subtitle': 'Ystudios 10th anniversary fountain pen celebrates the brand’s heritage with a beautifully crafted solid brass body, combining timeless design, balanced weight, ergonomic comfort, and the evolving patina that uniquely tells the users story.',
    'price': 11475,
    'description' : '',
    'c_id': 'c5',
    'section': 'new',

  },
];

class WebProducts extends StatelessWidget {
  const WebProducts({super.key});

  @override
  Widget build(BuildContext context) {

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
                  width: 250,
                  // width: MediaQuery.of(context).size.width - 130,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetail(p_id: product['p_id']!, title: product['title']!,),
                        ),
                      );
                    },
                    child: WebProductCard(
                      imageUrl: product['imageUrl']!,
                      title: product['title']!,
                      subtitle: product['subtitle']!,
                      price: product['price']!, //double.parse(product['price']!.replaceAll('Rs ', '')),
                      p_id: product['p_id']!,
                      description: product['description']!,
                    ),
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
