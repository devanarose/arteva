import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../database/DBHelper.dart';
import '../models/categoriesss_item.dart';
import '../screens/category_page.dart';

class CategoriesGrid extends StatefulWidget {
  const CategoriesGrid({super.key});

  @override
  State<CategoriesGrid> createState() => _CategoriesGridState();
}

class _CategoriesGridState extends State<CategoriesGrid> {
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
          // return SizedBox(
          //   width: double.infinity,
          //   height: 560,
          //   child: const Center(child: Text("No categories available.")),
          // );
        }

        final categories = snapshot.data!;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            final category = categories[index];

            return FutureBuilder<String?>(
              future: _getFullImagePath(category.imagePath),
              builder: (context, snapshot) {
                final imagePath = snapshot.data;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      shape: const CircleBorder(),
                      elevation: 4,
                      color: Colors.white,
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        splashColor: Theme.of(context).primaryColor.withAlpha(80),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => CategoryProductsPage(categoryId: category.id.toString(), categoryName: category.c_name,),),);
                        },
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: ClipOval(
                              child: imagePath != null
                                  ? Image.file(
                                File(imagePath),
                                fit: BoxFit.cover,
                                width: 68,
                                height: 68,
                              )
                                  : const Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      category.c_name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
