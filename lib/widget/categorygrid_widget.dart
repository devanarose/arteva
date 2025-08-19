import 'package:flutter/material.dart';
import '../models/category_item.dart';

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
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
                splashColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                onTap: () {
                  debugPrint('Tapped on ${category.name}');
                },
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: ClipOval(
                      child: Image.asset(
                        category.imagePath,
                        fit: BoxFit.cover,
                        width: 68,
                        height: 68,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              category.name,
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
  }
}
