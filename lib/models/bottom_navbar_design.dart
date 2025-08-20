import 'package:flutter/material.dart';
class BottomNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final double curveRadius = 100;
    final double curveWidth = 110;

    final double centerX = size.width / 2;

    path.lineTo(centerX - curveWidth / 2, 0);

    path.quadraticBezierTo(
      centerX,
      curveRadius,
      centerX + curveWidth / 2, 0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
