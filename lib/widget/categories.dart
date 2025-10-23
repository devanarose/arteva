import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../helpers/api_helper.dart';
import '../models/categoriesss_item.dart';
import '../database/DBHelper.dart';
import '../screens/category_page.dart';
import 'package:path_provider/path_provider.dart';

class Categories extends StatefulWidget {
  static final String route = '/categories';

  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  late Future<List<Map<String, dynamic>>> _futureCategories;
  final ScrollController _scrollController = ScrollController();

  void _scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 600,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 600,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
  @override
  void initState() {
    super.initState();
    _futureCategories = fetchCategories();
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    final response = await APIHelper.category();
    if (response['status'] == true && response['data'] != null) {
      return List<Map<String, dynamic>>.from(response['data']);
    } else {
      return [];
    }
  }

  // Future<String?> _getFullImagePath(String filename) async {
  //   final dir = await getApplicationDocumentsDirectory();
  //   final path = '${dir.path}/$filename';
  //   return File(path).existsSync() ? path : null;
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          print('category log: ${snapshot.error} ');
          return const SizedBox.shrink();
        }

        final categories = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Padding(
              // padding: EdgeInsets.only(left: 22, right: 8),
              padding: EdgeInsets.only(left: 22, right: 8, top: 10, bottom: 10),
              child: Text(
                'Popular Categories',
                style: TextStyle(color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: kIsWeb ? 160 : 130,
              child: kIsWeb
                  ? Stack(
                alignment: Alignment.center,
                children: [
                  ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: false,
                      child: ListView.separated(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 48),
                        itemCount: categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 50),
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return _buildWebCategory(context, category);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: 5,
                    child: _buildArrowButton(Icons.arrow_back_ios_new_rounded, _scrollLeft),
                  ),
                  Positioned(
                    right: 5,
                    child: _buildArrowButton(Icons.arrow_forward_ios_rounded, _scrollRight),
                  ),
                ],
              )
                  : ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16, right: 8),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 9),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _buildMobileCategory(context, category);
                },
              ),
            ),
          ],
        );
        // return Column(
        //   children: [
        //     Material(
        //       color: Colors.white,
        //       shape: const CircleBorder(),
        //       elevation: 1,
        //       child: InkWell(
        //         borderRadius: BorderRadius.circular(900),
        //         onTap: () {
        //           Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryProductsPage(categoryId: category['category_id'].toString(), categoryName: category['category_name'],),),);
        //         },
        //         child: Container(
        //           width: kIsWeb? 150:80,
        //           height: kIsWeb? 150:80,
        //           alignment: Alignment.center,
        //           child: ClipOval(
        //             child: category['category_image'] != null ?
        //             Image.network(
        //               category['category_image'],
        //               width: kIsWeb? 100:48,
        //               height: kIsWeb? 100:48,
        //               fit: BoxFit.cover,
        //               errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        //             ) : const Icon(Icons.image_not_supported),
        //           ),
        //         ),
        //       ),
        //     ),
        //     const SizedBox(height: 4),
        //     SizedBox(
        //       width: kIsWeb?  150: 90,
        //       child: Text(
        //         category['category_name'],
        //         textAlign: TextAlign.center,
        //         style: const TextStyle(fontSize: 12),
        //         overflow: TextOverflow.ellipsis,
        //         maxLines: 2,
        //       ),
        //     ),
        //   ],
        // );
      }
    );
  }


  Widget _buildArrowButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.green.shade600, size: 20),
        onPressed: onPressed,
      ),
    );
  }


  Widget _buildWebCategory(BuildContext context, Map<String, dynamic> category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryProductsPage(categoryId: category['category_id'].toString(), categoryName: category['category_name'],),),);
        },
        hoverColor: Colors.transparent,
        child: Container(
          width: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  category['category_image'],
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 60, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                category['category_name'] ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileCategory(BuildContext context, Map<String, dynamic> category) {
    return Column(
      children: [
        Material(
          color: Colors.white,
          shape: const CircleBorder(),
          elevation: 1,
          child: InkWell(
            borderRadius: BorderRadius.circular(900),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryProductsPage(categoryId: category['category_id'].toString(), categoryName: category['category_name'],),),);
            },
            child: Container(
              width: 80, height: 80,
              alignment: Alignment.center,
              child: ClipOval(
                child: category['category_image'] != null
                    ? Image.network(
                  category['category_image'],
                  width: 48, height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                )
                    : const Icon(Icons.image_not_supported),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 90,
          child: Text(
            category['category_name'],
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}