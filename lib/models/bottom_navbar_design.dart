import 'package:flutter/material.dart';

class BottomNavBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();

    final double curveDepth = 50;
    final double curveWidth = 100;
    final double centerX = size.width / 2;

    final double leftPoint = centerX - curveWidth / 2;
    final double rightPoint = centerX + curveWidth / 2;

    path.lineTo(leftPoint - 20, 0);

    path.cubicTo(
      leftPoint, 0,
      leftPoint + 15, curveDepth,
      centerX, curveDepth,
    );
    path.cubicTo(
      rightPoint - 15, curveDepth,
      rightPoint, 0,
      rightPoint + 20, 0,
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
