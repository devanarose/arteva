import 'package:flutter/material.dart';
import '../models/category_item.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
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
              return Column(
                children: [
                  Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 1,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(900),
                      splashColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                      onTap: () {
                        print('Tapped on ${category.name}');
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        alignment: Alignment.center,
                        child: ClipOval(
                          child: Image.asset(
                            category.imagePath,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 70,
                    child: Text(
                      category.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}
