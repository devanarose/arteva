import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


import '../helpers/api_helper.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  int _activeIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  late Future<List<dynamic>> _bannersFuture;

  @override
  void initState() {
    super.initState();
    _bannersFuture = fetchBanners();
  }

  Future<List<dynamic>> fetchBanners() async {
    final response = await APIHelper.banner();
    if (response['status'] == true && response['data'] != null) {
      return response['data'];
    } else {
      throw Exception('Failed to load banners');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _bannersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final bannerItems = snapshot.data ?? [];
        if (bannerItems.isEmpty) {
          return const Center(child: Text('No banners available'));
        }

        return Column(
          children: [
            const SizedBox(height: 26),
            CarouselSlider.builder(
              itemCount: bannerItems.length,
              carouselController: _controller,
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: kIsWeb? 1.0: 0.93,
                aspectRatio: kIsWeb ? 16 / 7 : 16 / 9,
                onPageChanged: (index, _) {
                  setState(() => _activeIndex = index);
                },
              ),
              itemBuilder: (context, index, _) {
                final item = bannerItems[index];
                return buildBanner(
                  banner_image: item['banner_image'],
                  banner_name: item['banner_name'],
                );
              },
            ),
            const SizedBox(height: 8),
            buildIndicator(bannerItems.length),
          ],
        );
      },
    );
  }

  Widget buildIndicator(int count) => AnimatedSmoothIndicator(
    activeIndex: _activeIndex,
    count: count,
    effect: WormEffect(
      dotHeight: 6, dotWidth: 6, spacing: 8, dotColor: Colors.black, activeDotColor: Theme.of(context).primaryColor,
    ),
  );

  Widget buildBanner({
    required String banner_name,
    required String banner_image,
  }) {
    return ClipRRect(
      borderRadius: kIsWeb? BorderRadius.circular(0): BorderRadius.circular(20) ,
      child: AspectRatio(
        aspectRatio: kIsWeb ? 16 / 7 : 16 / 9,
        child: Image.network(
          banner_image,
          // fit: BoxFit.fitHeight,
          fit: BoxFit.cover,
          // fit: BoxFit.contain,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image)),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
