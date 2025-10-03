import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../screens/cart_page.dart';
import '../models/bottom_navbar_design.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -5,
      right: -5,
      bottom: -7,
      child: SizedBox(
        height: 90,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned.fill(child: Container(color: Colors.transparent)),
            ClipPath(
              clipper: BottomNavBarClipper(),
              child: Container(
                height: 70,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.home_filled, color: currentIndex == 0 ? Theme.of(context).primaryColor : Colors.grey),
                      onPressed: () => onTabSelected(0),
                    ),
                    Transform.translate(
                      offset: const Offset(-30, 0),
                      child: IconButton(
                        icon: Icon(Icons.favorite, color: currentIndex == 1 ? Theme.of(context).primaryColor : Colors.grey),
                        onPressed: () => onTabSelected(1),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(30, 0),
                      child: IconButton(
                        icon: Icon(Icons.category_sharp, color: currentIndex == 3 ? Theme.of(context).primaryColor : Colors.grey),
                        onPressed: () => onTabSelected(3),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.person_2_rounded, color: currentIndex == 4 ? Theme.of(context).primaryColor : Colors.grey),
                      onPressed: () => onTabSelected(4),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: -30,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()),);
                },
                child: Opacity(
                  opacity: currentIndex == 2 ? 0.0 : 1.0,
                  child: Container(
                    height: 100,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Consumer<CartProvider>(
                      builder: (context, cartProvider, _) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Center(
                              child: Icon(Icons.shopping_cart, color: Colors.white, size: 28),
                            ),
                            if (cartProvider.uniqueItemCount > 0 && currentIndex != 2)
                              Positioned(
                                right: 1,
                                top: 15,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                  child: Text(
                                    '${cartProvider.uniqueItemCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
