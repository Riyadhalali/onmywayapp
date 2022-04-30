import 'package:flutter/material.dart';

class CustomChatBubble extends CustomPainter {
  CustomChatBubble({this.color, @required this.isOwn});
  final Color color;
  final bool isOwn;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? Colors.blue
      ..style = PaintingStyle.fill;

    Path path;
    double triangleHeight = 10.0;
    double triangleWidth = 10.0;
    double roundedBorder = 5.0;

    Path drawBubbleBody() {
      if (!isOwn) {
        path = Path()
          ..lineTo(0, size.height)
          ..lineTo(triangleWidth, size.height - triangleHeight)
          ..lineTo(size.width - roundedBorder, size.height - triangleHeight)
          ..quadraticBezierTo(size.width, size.height - triangleHeight, size.width,
              size.height - triangleHeight - roundedBorder)
          ..lineTo(size.width, roundedBorder)
          ..quadraticBezierTo(size.width, 0, size.width - roundedBorder, 0);
        path.close();
      }
      if (isOwn) {
        path = Path()
          ..moveTo(size.width - roundedBorder, 0)
          ..lineTo(roundedBorder, 0)
          ..quadraticBezierTo(0, 0, 0, roundedBorder)
          ..lineTo(0, size.height - triangleHeight - roundedBorder)
          ..quadraticBezierTo(
              0, size.height - triangleHeight, roundedBorder, size.height - triangleHeight)
          ..lineTo(size.width - triangleWidth, size.height - triangleHeight)
          ..lineTo(size.width, size.height)
          ..lineTo(size.width, roundedBorder)
          ..quadraticBezierTo(size.width, 0, size.width - roundedBorder, 0);
      }
      return path;
    }

    canvas.drawPath(drawBubbleBody(), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
// TODO: implement shouldRepaint
    return true;
  }
}
