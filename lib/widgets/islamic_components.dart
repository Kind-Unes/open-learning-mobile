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
}
