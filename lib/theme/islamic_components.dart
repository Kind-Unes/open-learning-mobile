import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:open_learning/theme/app_colors.dart';
import 'package:open_learning/widgets/islamic_patterns.dart';

/// Global Islamic-themed components for the app
class IslamicComponents {
  IslamicComponents._();

  /// Creates a global Islamic-styled button with patterns and animations
  static Widget buildIslamicButton({
    required String text,
    required VoidCallback onPressed,
    required Animation<double> patternAnimation,
    bool isLoading = false,
    double? width,
    double? height,
    IconData? suffixIcon,
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
    BorderRadius? borderRadius,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 60.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              backgroundColor ?? AppColors.primary,
              (backgroundColor ?? AppColors.primary).withOpacity(0.8),
              AppColors.accent.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: borderRadius ?? BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: (backgroundColor ?? AppColors.primary).withOpacity(0.4),
              blurRadius: 25,
              offset: const Offset(0, 10),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Islamic Pattern Background
            Positioned.fill(
              child: ClipRRect(
                borderRadius: borderRadius ?? BorderRadius.circular(20.r),
                child: AnimatedBuilder(
                  animation: patternAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: IslamicButtonPatternPainter(
                        patternAnimation.value,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Button content
            Center(
              child: Opacity(
                opacity: isLoading ? 0.7 : 1.0,
                child:
                    isLoading
                        ? SizedBox(
                          width: 28.w,
                          height: 28.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: textColor ?? Colors.white,
                          ),
                        )
                        : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              text,
                              style: TextStyle(
                                fontSize: fontSize ?? 20.sp,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: textColor ?? Colors.white,
                              ),
                            ),
                            if (suffixIcon != null) ...[
                              Gap(16.w),
                              Container(
                                padding: EdgeInsets.all(6.w),
                                decoration: BoxDecoration(
                                  color: (textColor ?? Colors.white)
                                      .withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(
                                  suffixIcon,
                                  size: 20.r,
                                  color: textColor ?? Colors.white,
                                ),
                              ),
                            ],
                          ],
                        ),
              ),
            ),

            // Touch feedback effect
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: isLoading ? null : onPressed,
                borderRadius: borderRadius ?? BorderRadius.circular(20.r),
                splashColor: (textColor ?? Colors.white).withOpacity(0.2),
                highlightColor: (textColor ?? Colors.white).withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Creates a Google authentication button matching Google's official design
  static Widget buildGoogleButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
    double? width,
    double? height,
  }) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 56.h,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey.shade300, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
        child:
            isLoading
                ? SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.grey.shade600,
                  ),
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Google logo SVG recreation
                    Container(
                      width: 20.w,
                      height: 20.w,
                      child: CustomPaint(painter: GoogleLogoPainter()),
                    ),
                    Gap(12.w),
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                        letterSpacing: 0.25,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

/// Custom painter for Google logo
class GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width * 0.4;

    // Google colors
    final redPaint = Paint()..color = const Color(0xFFEA4335);
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    final greenPaint = Paint()..color = const Color(0xFF34A853);
    final bluePaint = Paint()..color = const Color(0xFF4285F4);

    // Draw the simplified Google "G"

    // Blue arc (main body of G)
    final blueRect = Rect.fromCircle(
      center: Offset(centerX, centerY),
      radius: radius,
    );
    canvas.drawArc(
      blueRect,
      -math.pi / 2, // Start at top
      math.pi, // Draw 180 degrees
      false,
      Paint()
        ..color = bluePaint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.15,
    );

    // Red arc (top right)
    canvas.drawArc(
      blueRect,
      -math.pi / 2, // Start at top
      math.pi / 3, // Draw 60 degrees
      false,
      Paint()
        ..color = redPaint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.15,
    );

    // Yellow arc (top left)
    canvas.drawArc(
      blueRect,
      -math.pi / 2 + math.pi / 3, // Continue from red
      math.pi / 3, // Draw 60 degrees
      false,
      Paint()
        ..color = yellowPaint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.15,
    );

    // Green arc (bottom left)
    canvas.drawArc(
      blueRect,
      -math.pi / 2 + 2 * math.pi / 3, // Continue from yellow
      math.pi / 3, // Draw 60 degrees
      false,
      Paint()
        ..color = greenPaint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.15,
    );

    // Draw the horizontal line of the G
    final lineStart = Offset(centerX, centerY);
    final lineEnd = Offset(centerX + radius * 0.6, centerY);
    canvas.drawLine(
      lineStart,
      lineEnd,
      Paint()
        ..color = bluePaint.color
        ..strokeWidth = size.width * 0.15
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
