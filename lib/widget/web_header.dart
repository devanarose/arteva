import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';

class WebHeader extends StatelessWidget {
  final String currentRoute;
  final Function(String) onNavigate;

  const WebHeader({
    super.key,
    required this.currentRoute,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final username = authProvider.user?['firstName'] ?? "Guest";

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          color: Colors.black,

          child: isMobile ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.palette, color: Colors.white, size: 32),
                  SizedBox(width: 10),
                  Text(
                    'ArtEva',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/cartpage'),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 26),
                    if (cartProvider.uniqueItemCount > 0)
                      Positioned(
                        right: 0, top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle,),
                          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                          child: Text(
                            '${cartProvider.uniqueItemCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.palette, color: Colors.white, size: 32),
                  SizedBox(width: 10),
                  Text(
                    'ArtEva',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Times New Roman',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildNavButton(context, label: "Home", route: '/homescreen'),
                  _buildNavButton(context, label: "Wishlist", route: '/wishlist'),
                  _buildNavButton(context, label: "Categories", route: '/categories'),
                  const SizedBox(width: 24),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/cartpage'),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 26),
                        if (cartProvider.uniqueItemCount > 0)
                          Positioned(
                            right: 0, top: 0,
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle,),
                              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                              child: Text(
                                '${cartProvider.uniqueItemCount}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 29),
                  Row(
                    children: [
                      const Icon(Icons.account_circle_outlined, color: Colors.white, size: 26),
                      const SizedBox(width: 8),
                      Text(username, style: const TextStyle(color: Colors.white, fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

       if (isMobile)
        Container(
          width: double.infinity,
          height: 44,
          color: Colors.grey[900],
          alignment: Alignment.center,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _buildNavButton(context, label: "Home", route: '/homescreen'),
                _buildNavButton(context, label: "Wishlist", route: '/wishlist'),
                _buildNavButton(context, label: "Categories", route: '/categories'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavButton(BuildContext context, {
    required String label,
    required String route,
  }) {
    final bool isActive = currentRoute == route;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: isActive ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () => onNavigate(route),
        child: Text(
          label,
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
