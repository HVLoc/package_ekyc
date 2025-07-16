import 'package:flutter/material.dart';
import 'package:package_ekyc/core/core.src.dart';

class CustomShapePainterLiveNess extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Vẽ các khối màu vào canvas
    Paint paint = Paint();

    // Tạo một Path đại diện cho phần bên ngoài của hình tròn
    double radius = size.width / 2 - 30; // Bán kính của hình tròn
    Offset center =
        Offset(size.width / 2, size.height / 2.2); // Tâm của hình tròn
    Path clipPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    clipPath.fillType = PathFillType.evenOdd;

    // Cắt bỏ phần bên trong của các khối theo hình tròn
    canvas.clipPath(clipPath);

    // Vẽ các khối màu đã được cắt bỏ

    // Vẽ khối màu 1
    paint.color = AppColors.basicWhite;
    canvas.drawRect(
        Rect.fromLTRB(0, 0, size.width * 0.5, size.height * 0.5), paint);

    // Vẽ khối màu 2
    paint.color = AppColors.basicWhite;
    canvas.drawRect(
        Rect.fromLTRB(size.width * 0.5, 0, size.width, size.height * 0.5),
        paint);

    // Vẽ khối màu 3
    paint.color = AppColors.basicWhite;
    canvas.drawRect(
        Rect.fromLTRB(0, size.height * 0.5, size.width * 0.5, size.height),
        paint);

    // Vẽ khối màu 4
    paint.color = AppColors.basicWhite;
    canvas.drawRect(
        Rect.fromLTRB(
            size.width * 0.5, size.height * 0.5, size.width, size.height),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
