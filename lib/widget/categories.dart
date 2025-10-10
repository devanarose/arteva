import 'dart:io';
import 'package:flutter/material.dart';
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
  late Future<List<CategoriesssItem>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureCategories = DBHelper.instance.getAllCategories();
  }

  Future<String?> _getFullImagePath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/$filename';
    return File(path).existsSync() ? path : null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoriesssItem>>(
      future: _futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No categories available."));
        }

        final categories = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 22, right: 8),
              child: Text(
                'Popular Categories',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16, right: 8),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 9),
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return FutureBuilder<String?>(
                    future: _getFullImagePath(category.imagePath),
                    builder: (context, snapshot) {
                      final imagePath = snapshot.data;

                      return Column(
                        children: [
                          Material(
                            color: Colors.white,
                            shape: const CircleBorder(),
                            elevation: 1,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(900),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryProductsPage(categoryId: category.id.toString(), categoryName: category.c_name,),));
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                alignment: Alignment.center,
                                child: ClipOval(
                                  child: imagePath != null
                                      ? Image.file(
                                    File(imagePath),
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                  )
                                      : const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: 70,
                            child: Text(
                              category.c_name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
