import 'package:flutter/material.dart';

class BorderShape extends StatelessWidget {
  final Color color;
  final double height, width;
  final double? angle;

  const BorderShape(
      {super.key,
      required this.color,
      required this.height,
      required this.width,
      this.angle});

  @override
  Widget build(BuildContext context) => Transform.rotate(
      angle: angle ?? 0,
      child: CustomPaint(
          size: Size(width, height),
          painter: BorderShapePainter(color: color)));
}

class BorderShapePainter extends CustomPainter {
  Color color;

  BorderShapePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width / 6, 0);
    path_0.lineTo(0, 0);
    path_0.lineTo(0, size.height);
    path_0.lineTo(size.width, size.height);
    path_0.lineTo(size.width, size.height / 1.2);
    path_0.lineTo(size.width / 6, size.height / 1.2);
    path_0.lineTo(size.width / 6, 0);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = color;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
