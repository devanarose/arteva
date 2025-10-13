import 'package:erp_demo/widget/web_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class WebHeaderSplit extends StatelessWidget {
  final String currentRoute;
  final Function(String) onNavigate;

  const WebHeaderSplit({
    super.key,
    required this.currentRoute,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final cartProvider = Provider.of<CartProvider>(context);
    final int cartCount = cartProvider.uniqueItemCount;
    return Row(
      children: [
        _buildNavButton(context, label: "Home", route: '/homescreen'),
        _buildNavButton(context, label: "Wishlist", route: '/wishlist'),
        _buildNavButton(context, label: "Categories", route: '/categories'),
        if(!isMobile)
        _buildNavButton(context, route: '/cartpage', icon: Icons.shopping_cart, cartCount: cartCount,),
      ],
    );
  }

  Widget _buildNavButton(BuildContext context, {required String route, String? label, IconData? icon, int? cartCount,}) {
    final bool isActive = currentRoute == route;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () {
          if (currentRoute != route) {
            onNavigate(route);
          }
        },
        child: icon != null
            ? Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: isActive ? Theme.of(context).primaryColor : Colors.white, size: 22,),
            if (cartCount != null && cartCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle,),
                  constraints:
                  const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    '$cartCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        )
            : Text(
          label!,
          style: TextStyle(
            color: isActive ? Theme.of(context).primaryColor : Colors.white,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
