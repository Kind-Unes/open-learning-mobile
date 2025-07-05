import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:open_learning/theme/app_colors.dart';


class IslamicCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final cornerRadius = 32.0;
    final decorativeHeight = 20.0;

    // Start from top-left with Islamic curve
    path.moveTo(cornerRadius, 0);

    // Top edge with Islamic arches
    for (double x = cornerRadius; x < size.width - cornerRadius; x += 80) {
      final centerX = x + 40;
      if (centerX < size.width - cornerRadius) {
        path.lineTo(centerX - 20, 0);
        path.quadraticBezierTo(centerX, decorativeHeight, centerX + 20, 0);
      }
    }
    path.lineTo(size.width - cornerRadius, 0);

    // Rounded corners
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
    path.lineTo(size.width, size.height - cornerRadius);
    path.quadraticBezierTo(
      size.width,
      size.height,
      size.width - cornerRadius,
      size.height,
    );
    path.lineTo(cornerRadius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);
    path.lineTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class IslamicGeometricPatternPainter extends CustomPainter {
  final double animationValue;
  final double breathValue;
  final double rotationValue;

  IslamicGeometricPatternPainter(
    this.animationValue,
    this.breathValue,
    this.rotationValue,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.15)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

    final fillPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.06)
          ..style = PaintingStyle.fill;

    // Draw Islamic star patterns
    _drawIslamicStars(canvas, size, strokePaint, fillPaint);

    // Draw geometric grid
    _drawIslamicGrid(canvas, size, strokePaint);

    // Draw flowing arabesques
    _drawArabesques(canvas, size, strokePaint);
  }

  void _drawIslamicStars(
    Canvas canvas,
    Size size,
    Paint strokePaint,
    Paint fillPaint,
  ) {
    const starCount = 12;
    for (int i = 0; i < starCount; i++) {
      final progress = (animationValue * 0.2 + i * 0.3) % 1.0;
      final angle = (i * 2 * math.pi / starCount) + rotationValue * 0.5;

      final x =
          size.width / 2 +
          (120 + 40 * math.sin(progress * 2 * math.pi)) * math.cos(angle);
      final y =
          size.height / 2 +
          (80 + 30 * math.cos(progress * 2 * math.pi)) * math.sin(angle);

      if (x >= 0 && x <= size.width && y >= 0 && y <= size.height) {
        _drawEightPointStar(
          canvas,
          Offset(x, y),
          15 * breathValue,
          strokePaint,
          fillPaint,
        );
      }
    }
  }

  void _drawEightPointStar(
    Canvas canvas,
    Offset center,
    double radius,
    Paint strokePaint,
    Paint fillPaint,
  ) {
    final path = Path();
    const points = 8;
    const innerRadius = 0.6;

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi) / points;
      final r = (i % 2 == 0) ? radius : radius * innerRadius;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  void _drawIslamicGrid(Canvas canvas, Size size, Paint paint) {
    const gridSize = 60.0;
    final offsetX = (animationValue * gridSize * 0.3) % gridSize;
    final offsetY = (animationValue * gridSize * 0.3) % gridSize;

    paint.color = Colors.white.withOpacity(0.08);

    // Draw hexagonal grid
    for (double x = -offsetX; x < size.width + gridSize; x += gridSize * 0.75) {
      for (double y = -offsetY; y < size.height + gridSize; y += gridSize) {
        final centerX = x + (((y / gridSize).floor() % 2) * gridSize * 0.375);
        final centerY = y;

        _drawIslamicHexagon(
          canvas,
          Offset(centerX, centerY),
          gridSize * 0.25,
          paint,
        );
      }
    }
  }

  void _drawIslamicHexagon(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
  ) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi) / 3;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawArabesques(Canvas canvas, Size size, Paint paint) {
    paint.color = Colors.white.withOpacity(0.1);
    paint.strokeWidth = 2;

    final path = Path();
    for (double t = 0; t <= 1; t += 0.02) {
      final x = size.width * t;
      final y =
          size.height * 0.3 +
          40 *
              math.sin(t * 4 * math.pi + animationValue * 2) *
              math.cos(t * 2 * math.pi + animationValue);

      if (t == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Mirror pattern
    final path2 = Path();
    for (double t = 0; t <= 1; t += 0.02) {
      final x = size.width * t;
      final y =
          size.height * 0.7 -
          40 *
              math.sin(t * 4 * math.pi + animationValue * 2) *
              math.cos(t * 2 * math.pi + animationValue);

      if (t == 0) {
        path2.moveTo(x, y);
      } else {
        path2.lineTo(x, y);
      }
    }

    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class IslamicRingPainter extends CustomPainter {
  final double pulseValue;

  IslamicRingPainter(this.pulseValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Draw multiple Islamic rings
    for (int ring = 0; ring < 4; ring++) {
      final radius = 40.0 + ring * 20.0;
      final opacity = 0.6 - ring * 0.12;
      final strokeWidth = 3.0 - ring * 0.5;

      final paint =
          Paint()
            ..color = Colors.white.withOpacity(opacity * pulseValue)
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke;

      // Draw Islamic geometric ring pattern
      _drawIslamicRing(canvas, center, radius, paint, ring);
    }
  }

  void _drawIslamicRing(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
    int ringIndex,
  ) {
    const segments = 16;
    final path = Path();

    for (int i = 0; i < segments; i++) {
      final startAngle = (i * 2 * math.pi) / segments;
      final endAngle =
          ((i + 0.7) * 2 * math.pi) / segments; // Gap for Islamic pattern

      final startX = center.dx + radius * math.cos(startAngle);
      final startY = center.dy + radius * math.sin(startAngle);

      if (i == 0) {
        path.moveTo(startX, startY);
      }

      // Create arc segment
      final rect = Rect.fromCircle(center: center, radius: radius);
      path.addArc(rect, startAngle, endAngle - startAngle);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class IslamicCardPatternPainter extends CustomPainter {
  final double animationValue;
  final double breathValue;

  IslamicCardPatternPainter(this.animationValue, this.breathValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.primary.withOpacity(0.04 * 1.2)
          ..style = PaintingStyle.fill;

    final strokePaint =
        Paint()
          ..color = AppColors.primary.withOpacity(0.08 * 1.2)
          ..strokeWidth = 1
          ..style = PaintingStyle.stroke;

    // Draw subtle Islamic motifs
    _drawIslamicMotifs(canvas, size, paint, strokePaint);

    // Draw corner decorations
    _drawCornerDecorations(canvas, size, strokePaint);

    // Draw flowing patterns
    _drawFlowingPatterns(canvas, size, strokePaint);
  }

  void _drawIslamicMotifs(
    Canvas canvas,
    Size size,
    Paint fillPaint,
    Paint strokePaint,
  ) {
    const motifSize = 40.0;
    final rows = (size.height / (motifSize * 2)).floor();
    final cols = (size.width / (motifSize * 2)).floor();

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final x =
            col * motifSize * 2 +
            motifSize +
            20 * math.sin(animationValue + row * 0.5);
        final y =
            row * motifSize * 2 +
            motifSize +
            15 * math.cos(animationValue + col * 0.5);

        if (x > 0 && x < size.width && y > 0 && y < size.height) {
          _drawIslamicFlower(
            canvas,
            Offset(x, y),
            motifSize * 0.3,
            fillPaint,
            strokePaint,
          );
        }
      }
    }
  }

  void _drawIslamicFlower(
    Canvas canvas,
    Offset center,
    double radius,
    Paint fillPaint,
    Paint strokePaint,
  ) {
    const petals = 8;

    for (int i = 0; i < petals; i++) {
      final angle = (i * 2 * math.pi) / petals;
      final petalPath = Path();

      // Create petal shape
      final petalTip = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );

      final leftControl = Offset(
        center.dx + radius * 0.3 * math.cos(angle - 0.5),
        center.dy + radius * 0.3 * math.sin(angle - 0.5),
      );

      final rightControl = Offset(
        center.dx + radius * 0.3 * math.cos(angle + 0.5),
        center.dy + radius * 0.3 * math.sin(angle + 0.5),
      );

      petalPath.moveTo(center.dx, center.dy);
      petalPath.quadraticBezierTo(
        leftControl.dx,
        leftControl.dy,
        petalTip.dx,
        petalTip.dy,
      );
      petalPath.quadraticBezierTo(
        rightControl.dx,
        rightControl.dy,
        center.dx,
        center.dy,
      );

      canvas.drawPath(petalPath, fillPaint);
      canvas.drawPath(petalPath, strokePaint);
    }
  }

  void _drawCornerDecorations(Canvas canvas, Size size, Paint paint) {
    paint.color = AppColors.primary.withOpacity(0.1);

    // Top corners
    _drawCornerArabesque(canvas, const Offset(50, 50), paint);
    _drawCornerArabesque(canvas, Offset(size.width - 50, 50), paint, true);

    // Bottom corners
    _drawCornerArabesque(
      canvas,
      Offset(50, size.height - 50),
      paint,
      false,
      true,
    );
    _drawCornerArabesque(
      canvas,
      Offset(size.width - 50, size.height - 50),
      paint,
      true,
      true,
    );
  }

  void _drawCornerArabesque(
    Canvas canvas,
    Offset corner,
    Paint paint, [
    bool flipX = false,
    bool flipY = false,
  ]) {
    final path = Path();
    final scale = flipX ? -1.0 : 1.0;
    final scaleY = flipY ? -1.0 : 1.0;

    path.moveTo(corner.dx, corner.dy);
    path.quadraticBezierTo(
      corner.dx + 30 * scale,
      corner.dy + 10 * scaleY,
      corner.dx + 25 * scale,
      corner.dy + 25 * scaleY,
    );
    path.quadraticBezierTo(
      corner.dx + 10 * scale,
      corner.dy + 30 * scaleY,
      corner.dx,
      corner.dy + 25 * scaleY,
    );

    canvas.drawPath(path, paint);
  }

  void _drawFlowingPatterns(Canvas canvas, Size size, Paint paint) {
    paint.color = AppColors.accent.withOpacity(0.06);

    final path = Path();
    for (double x = 0; x < size.width; x += 5) {
      final y =
          size.height * 0.8 +
          30 *
              math.sin((x / 60) + animationValue * 2) *
              math.cos((x / 40) + animationValue);

      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class IslamicButtonPatternPainter extends CustomPainter {
  final double animationValue;

  IslamicButtonPatternPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

    // Draw flowing Islamic pattern
    final path = Path();
    for (double x = 0; x < size.width; x += 10) {
      final y =
          size.height / 2 +
          12 *
              math.sin((x / 30) + animationValue * 3) *
              math.cos((x / 20) + animationValue * 2);

      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw decorative dots
    for (int i = 0; i < 8; i++) {
      final x = (i + 1) * (size.width / 9);
      final y = size.height / 2 + 15 * math.sin(animationValue * 2 + i * 0.8);
      final opacity = 0.4 * (0.5 + 0.5 * math.sin(animationValue * 3 + i));

      canvas.drawCircle(
        Offset(x, y),
        3,
        Paint()..color = Colors.white.withOpacity(opacity),
      );
    }

    // Draw Islamic geometric elements
    for (int i = 0; i < 4; i++) {
      final x = (i + 1) * (size.width / 5);
      final y = size.height / 2;
      final rotation = animationValue + i * 0.5;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      _drawMiniIslamicStar(canvas, 8, paint);

      canvas.restore();
    }
  }

  void _drawMiniIslamicStar(Canvas canvas, double size, Paint paint) {
    final path = Path();
    const points = 4;

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi) / points;
      final radius = (i % 2 == 0) ? size : size * 0.5;
      final x = radius * math.cos(angle);
      final y = radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
