import 'package:flutter/material.dart' ;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:erp_demo/models/banner_item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final List<BannerItem> bannerItems = [
    BannerItem(
      imagePath: 'assets/images/acrylic_paint.png',
      title: 'Acrylic Paints',
      subtitle: 'Bold & Vibrant Colors',
    ),
    BannerItem(
      imagePath: 'assets/images/sketching_pencils.png',
      title: 'Sketching Pencils',
      subtitle: 'Perfect for Precision',
    ),
    BannerItem(
      imagePath: 'assets/images/oil_colors.png',
      title: 'Oil Colors',
      subtitle: 'Rich Pigment Blends',
    ),
    BannerItem(
      imagePath: 'assets/images/watercolor_papers.png',
      title: 'Watercolor Papers',
      subtitle: 'Smooth & Absorbent',
    ),
  ];

  int _activeIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 26),
        CarouselSlider.builder(
          itemCount: bannerItems.length,
          carouselController: _controller,
          options: CarouselOptions(
            height: 210,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            onPageChanged: (index, _) {
              setState(() => _activeIndex = index);
            },
          ),
          itemBuilder: (context, index, _) {
            final item = bannerItems[index];
            return buildBanner(
              imagePath: item.imagePath,
              title: item.title,
              subtitle: item.subtitle,
            );
          },

        ),
        const SizedBox(height: 8),
        buildIndicator()
      ],
    );
  }

  Widget buildBannerCard(String path) => ClipRRect(
    borderRadius: BorderRadius.circular(30),
    child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      elevation: 5,
      child: Image.asset(path, fit: BoxFit.cover, width: double.infinity),
    ),
  );

  Widget buildIndicator() => AnimatedSmoothIndicator(
    activeIndex: _activeIndex,
    count: bannerItems.length,
    effect: WormEffect(
      dotHeight: 6,
      dotWidth: 6,
      spacing: 8,
      dotColor: Colors.black,
      activeDotColor: Theme.of(context).primaryColor,
    ),
  );

  Widget buildBanner({
    required String imagePath,
    required String title,
    required String subtitle,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withValues(alpha: 0.6), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),


          Positioned(
            left: 16,
            bottom: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),


          Positioned(
            right: 16,
            bottom: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Handle navigation
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: const Text('Shop Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
