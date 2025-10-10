import 'package:flutter/material.dart';

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
    return Row(
      children: [
        _buildNavButton(context, label: "Home", route: '/homescreen'),
        _buildNavButton(context, label: "Wishlist", route: '/wishlist'),
        _buildNavButton(context, label: "Categories", route: '/categories'),
      ],
    );
  }

  Widget _buildNavButton(BuildContext context,
      {required String label, required String route}) {
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
