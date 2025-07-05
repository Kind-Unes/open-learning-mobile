import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:open_learning/theme/app_colors.dart';

/// A reusable widget that provides Islamic geometric pattern background
/// similar to the traditional Islamic geometric designs
class AppBackground extends StatefulWidget {
  final Widget? child;
  final Color? patternColor;
  final double? patternOpacity;
  final bool animated;
  final Duration animationDuration;

  const AppBackground({
    super.key,
    this.child,
    this.patternColor,
    this.patternOpacity = 0.03,
    this.animated = true,
    this.animationDuration = const Duration(seconds: 20),
  });

  @override
  State<AppBackground> createState() => _AppBackgroundState();
}

class _AppBackgroundState extends State<AppBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    if (widget.animated) {
      _animationController = AnimationController(
        duration: widget.animationDuration,
        vsync: this,
      );

      _animation = Tween<double>(
        begin: 0.0,
        end: 2 * math.pi,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ));

      _animationController.repeat();
    }
  }

  @override
  void dispose() {
    if (widget.animated) {
      _animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animated) {
      return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              // Background Pattern
              Positioned.fill(
                child: CustomPaint(
                  painter: IslamicPatternPainter(
                    animationValue: _animation.value,
                    patternColor: widget.patternColor ?? AppColors.primary,
                    opacity: widget.patternOpacity ?? 0.03,
                  ),
                ),
              ),
              // Child content
              if (widget.child != null) widget.child!,
            ],
          );
        },
      );
    } else {
      return Stack(
        children: [
          // Static Background Pattern
          Positioned.fill(
            child: CustomPaint(
              painter: IslamicPatternPainter(
                animationValue: 0.0,
                patternColor: widget.patternColor ?? AppColors.primary,
                opacity: widget.patternOpacity ?? 0.03,
              ),
            ),
          ),
          // Child content
          if (widget.child != null) widget.child!,
        ],
      );
    }
  }
}

/// Custom painter that creates Islamic geometric patterns
class IslamicPatternPainter extends CustomPainter {
  final double animationValue;
  final Color patternColor;
  final double opacity;

  IslamicPatternPainter({
    required this.animationValue,
    required this.patternColor,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Create paint objects for different elements
    final strokePaint = Paint()
      ..color = patternColor.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final fillPaint = Paint()
      ..color = patternColor.withOpacity(opacity * 0.3)
      ..style = PaintingStyle.fill;

    // Draw the main Islamic geometric grid
    _drawIslamicGrid(canvas, size, strokePaint);
    
    // Draw decorative Islamic stars
    _drawIslamicStars(canvas, size, strokePaint, fillPaint);
    
    // Draw connecting geometric lines
    _drawConnectingLines(canvas, size, strokePaint);
    
    // Draw corner decorative elements
    _drawCornerDecorations(canvas, size, strokePaint);
  }

  void _drawIslamicGrid(Canvas canvas, Size size, Paint paint) {
    const double gridSize = 60.0;
    final double offsetX = (animationValue * gridSize * 0.1) % gridSize;
    final double offsetY = (animationValue * gridSize * 0.1) % gridSize;

    // Draw hexagonal/octagonal grid pattern
    for (double x = -offsetX; x < size.width + gridSize; x += gridSize) {
      for (double y = -offsetY; y < size.height + gridSize; y += gridSize) {
        final center = Offset(
          x + gridSize / 2 + 10 * math.sin(animationValue + y / 100),
          y + gridSize / 2 + 10 * math.cos(animationValue + x / 100),
        );
        
        // Draw octagonal pattern
        _drawOctagon(canvas, center, gridSize * 0.25, paint);
        
        // Draw inner decorative elements
        _drawInnerDecoration(canvas, center, gridSize * 0.15, paint);
      }
    }
  }

  void _drawOctagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const int sides = 8;
    
    for (int i = 0; i < sides; i++) {
      final angle = (i * 2 * math.pi) / sides + animationValue * 0.1;
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

  void _drawInnerDecoration(Canvas canvas, Offset center, double radius, Paint paint) {
    // Draw inner cross pattern
    final paint2 = Paint()
      ..color = patternColor.withOpacity(opacity * 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Horizontal line
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      paint2,
    );
    
    // Vertical line
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      paint2,
    );
    
    // Diagonal lines
    canvas.drawLine(
      Offset(center.dx - radius * 0.7, center.dy - radius * 0.7),
      Offset(center.dx + radius * 0.7, center.dy + radius * 0.7),
      paint2,
    );
    
    canvas.drawLine(
      Offset(center.dx - radius * 0.7, center.dy + radius * 0.7),
      Offset(center.dx + radius * 0.7, center.dy - radius * 0.7),
      paint2,
    );
  }

  void _drawIslamicStars(Canvas canvas, Size size, Paint strokePaint, Paint fillPaint) {
    const double starSpacing = 120.0;
    final int starsX = (size.width / starSpacing).ceil();
    final int starsY = (size.height / starSpacing).ceil();

    for (int i = 0; i < starsX; i++) {
      for (int j = 0; j < starsY; j++) {
        final center = Offset(
          i * starSpacing + starSpacing / 2 + 15 * math.sin(animationValue + j * 0.5),
          j * starSpacing + starSpacing / 2 + 15 * math.cos(animationValue + i * 0.5),
        );
        
        if (center.dx >= 0 && center.dx <= size.width && 
            center.dy >= 0 && center.dy <= size.height) {
          _drawEightPointStar(canvas, center, 12, strokePaint, fillPaint);
        }
      }
    }
  }

  void _drawEightPointStar(Canvas canvas, Offset center, double radius, Paint strokePaint, Paint fillPaint) {
    final path = Path();
    const int points = 8;
    const double innerRatio = 0.6;

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi) / points + animationValue * 0.05;
      final currentRadius = (i % 2 == 0) ? radius : radius * innerRatio;
      
      final x = center.dx + currentRadius * math.cos(angle);
      final y = center.dy + currentRadius * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    
    // Draw filled star with very low opacity
    canvas.drawPath(path, fillPaint);
    // Draw star outline
    canvas.drawPath(path, strokePaint);
  }

  void _drawConnectingLines(Canvas canvas, Size size, Paint paint) {
    final paint2 = Paint()
      ..color = patternColor.withOpacity(opacity * 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    // Draw horizontal connecting lines
    for (double y = 60; y < size.height; y += 120) {
      final path = Path();
      for (double x = 0; x <= size.width; x += 10) {
        final offsetY = y + 5 * math.sin((x / 50) + animationValue * 2);
        if (x == 0) {
          path.moveTo(x, offsetY);
        } else {
          path.lineTo(x, offsetY);
        }
      }
      canvas.drawPath(path, paint2);
    }

    // Draw vertical connecting lines
    for (double x = 60; x < size.width; x += 120) {
      final path = Path();
      for (double y = 0; y <= size.height; y += 10) {
        final offsetX = x + 5 * math.sin((y / 50) + animationValue * 2);
        if (y == 0) {
          path.moveTo(offsetX, y);
        } else {
          path.lineTo(offsetX, y);
        }
      }
      canvas.drawPath(path, paint2);
    }
  }

  void _drawCornerDecorations(Canvas canvas, Size size, Paint paint) {
    final decorationPaint = Paint()
      ..color = patternColor.withOpacity(opacity * 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    // Top-left corner
    _drawCornerPattern(canvas, const Offset(30, 30), decorationPaint);
    
    // Top-right corner
    _drawCornerPattern(canvas, Offset(size.width - 30, 30), decorationPaint, flipX: true);
    
    // Bottom-left corner
    _drawCornerPattern(canvas, Offset(30, size.height - 30), decorationPaint, flipY: true);
    
    // Bottom-right corner
    _drawCornerPattern(canvas, Offset(size.width - 30, size.height - 30), decorationPaint, flipX: true, flipY: true);
  }

  void _drawCornerPattern(Canvas canvas, Offset center, Paint paint, {bool flipX = false, bool flipY = false}) {
    final path = Path();
    final scaleX = flipX ? -1.0 : 1.0;
    final scaleY = flipY ? -1.0 : 1.0;

    // Create decorative corner arc
    for (double t = 0; t <= 1; t += 0.1) {
      final angle = t * math.pi / 2;
      final radius = 20 + 5 * math.sin(animationValue * 3 + t * 4);
      final x = center.dx + radius * math.cos(angle) * scaleX;
      final y = center.dy + radius * math.sin(angle) * scaleY;
      
      if (t == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    canvas.drawPath(path, paint);

    // Add small decorative circles
    for (int i = 0; i < 3; i++) {
      final angle = (i * math.pi / 6) + animationValue * 0.5;
      final radius = 15.0;
      final x = center.dx + radius * math.cos(angle) * scaleX;
      final y = center.dy + radius * math.sin(angle) * scaleY;
      
      canvas.drawCircle(
        Offset(x, y),
        2.0,
        Paint()..color = patternColor.withOpacity(opacity * 1.2),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is IslamicPatternPainter &&
        (oldDelegate.animationValue != animationValue ||
         oldDelegate.patternColor != patternColor ||
         oldDelegate.opacity != opacity);
  }
}

/// Extension for easy usage
extension AppBackgroundExtension on Widget {
  /// Wraps the widget with AppBackground
  Widget withIslamicBackground({
    Color? patternColor,
    double? patternOpacity = 0.03,
    bool animated = true,
    Duration animationDuration = const Duration(seconds: 20),
  }) {
    return AppBackground(
      patternColor: patternColor,
      patternOpacity: patternOpacity,
      animated: animated,
      animationDuration: animationDuration,
      child: this,
    );
  }
}