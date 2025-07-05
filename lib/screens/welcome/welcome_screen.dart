import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:open_learning/theme/app_colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  // Multiple animation controllers for complex layered animations
  late AnimationController _masterController;
  late AnimationController _patternController;
  late AnimationController _breathController;
  late AnimationController _rotationController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _particleController;

  // Animations
  late Animation<double> _masterAnimation;
  late Animation<double> _patternAnimation;
  late Animation<double> _breathAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers with different durations
    _masterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _patternController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    );

    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 35),
    );

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    // Initialize animations with different curves
    _masterAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _masterController, curve: Curves.easeOutCubic),
    );

    _patternAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _patternController, curve: Curves.linear),
    );

    _breathAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _floatingAnimation = Tween<double>(begin: -20.0, end: 20.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.elasticInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    // Start animations
    _masterController.forward();
    _patternController.repeat();
    _breathController.repeat(reverse: true);
    _rotationController.repeat();
    _floatingController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
    _particleController.repeat();

    // Delayed slide animation
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _slideController.forward();
    });
  }

  @override
  void dispose() {
    _masterController.dispose();
    _patternController.dispose();
    _breathController.dispose();
    _rotationController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _navigateToAuth() {
    HapticFeedback.lightImpact();
    // Navigation logic here
    Navigator.pushNamed(context, '/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withOpacity(0.9),
              AppColors.primary,
              AppColors.primaryDark,
              AppColors.accent.withOpacity(0.8),
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated Islamic Background Patterns
            _buildAnimatedBackground(),

            // Floating Particles
            _buildFloatingParticles(),

            // Main Content
            _buildMainContent(),

            // Bottom Action Section
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _patternAnimation,
          _breathAnimation,
          _rotationAnimation,
          _particleAnimation,
        ]),
        builder: (context, child) {
          return CustomPaint(
            painter: ComplexIslamicBackgroundPainter(
              _patternAnimation.value,
              _breathAnimation.value,
              _rotationAnimation.value,
              _particleAnimation.value,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingParticles() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _floatingAnimation,
          _particleAnimation,
          _pulseAnimation,
        ]),
        builder: (context, child) {
          return CustomPaint(
            painter: FloatingParticlesPainter(
              _floatingAnimation.value,
              _particleAnimation.value,
              _pulseAnimation.value,
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            Gap(60.h),

            // Epic Logo Section
            _buildEpicLogoSection(),

            Gap(40.h),

            // Welcome Text Section
            _buildWelcomeTextSection(),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildEpicLogoSection() {
    return FadeTransition(
      opacity: _masterAnimation,
      child: Column(
        children: [
          // Main Logo with Complex Animations
          Stack(
            alignment: Alignment.center,
            children: [
              // Outermost Rotating Ring
              AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value,
                    child: CustomPaint(
                      size: Size(220.w, 220.w),
                      painter: OuterIslamicRingPainter(),
                    ),
                  );
                },
              ),

              // Middle Breathing Ring
              AnimatedBuilder(
                animation: _breathAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _breathAnimation.value,
                    child: CustomPaint(
                      size: Size(180.w, 180.w),
                      painter: MiddleIslamicRingPainter(
                        _patternAnimation.value,
                      ),
                    ),
                  );
                },
              ),

              // Inner Pulsing Ring
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 150.w,
                      height: 150.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.05),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Logo Container with Advanced Effects
              AnimatedBuilder(
                animation: Listenable.merge([
                  _breathAnimation,
                  _pulseAnimation,
                ]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _breathAnimation.value * 0.9 + 0.1,
                    child: Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(0.98),
                            Colors.white.withOpacity(0.95),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(28.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.6),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 40,
                            offset: const Offset(0, 15),
                            spreadRadius: 5,
                          ),
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 60,
                            offset: const Offset(0, 0),
                            spreadRadius: 20,
                          ),
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.1),
                            blurRadius: 80,
                            offset: const Offset(0, 0),
                            spreadRadius: 30,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Logo Image
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25.r),
                              child: Image.asset(
                                'assets/images/app-logo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // Magical Shine Effect
                          AnimatedBuilder(
                            animation: _patternAnimation,
                            builder: (context, child) {
                              return Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25.r),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment(
                                          -1.0 +
                                              3.0 *
                                                  (_patternAnimation.value %
                                                      1.0),
                                          -1.0,
                                        ),
                                        end: Alignment(
                                          1.0 +
                                              3.0 *
                                                  (_patternAnimation.value %
                                                      1.0),
                                          1.0,
                                        ),
                                        colors: [
                                          Colors.transparent,
                                          Colors.white.withOpacity(0.4),
                                          Colors.white.withOpacity(0.8),
                                          Colors.white.withOpacity(0.4),
                                          Colors.transparent,
                                        ],
                                        stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Border Highlight
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.r),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Floating Elements Around Logo
              ...List.generate(8, (index) {
                return AnimatedBuilder(
                  animation: Listenable.merge([
                    _rotationAnimation,
                    _floatingAnimation,
                  ]),
                  builder: (context, child) {
                    final angle =
                        (index * 2 * math.pi / 8) +
                        _rotationAnimation.value * 0.5;
                    final distance = 100.w + _floatingAnimation.value;
                    final x = distance * math.cos(angle);
                    final y = distance * math.sin(angle);

                    return Transform.translate(
                      offset: Offset(x, y),
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.8),
                              Colors.white.withOpacity(0.3),
                              Colors.transparent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),

          Gap(40.h),

          // App Title with Stunning Effects
          AnimatedBuilder(
            animation: _masterAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, 50 * (1 - _masterAnimation.value)),
                child: Opacity(
                  opacity: _masterAnimation.value,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 20.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.25),
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(25.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 25,
                          offset: const Offset(0, 8),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.1),
                          blurRadius: 40,
                          offset: const Offset(0, 0),
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'أكاديمية التعلم المفتوح',
                          style: TextStyle(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 2.0,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                              Shadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 25,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Gap(8.h),
                        Text(
                          'Open Learning Academy',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeTextSection() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _masterAnimation,
        child: Column(
          children: [
            // Main Welcome Message
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'ابدأ رحلتك في التعلم',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.95),
                      letterSpacing: 0.8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gap(8.h),
                  Text(
                    'اكتشف عالماً من المعرفة والعلوم الإسلامية',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 50.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.2),
              ],
            ),
          ),
          child: Column(
            children: [
              // Start Journey Button
              GestureDetector(
                onTap: _navigateToAuth,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.95 + 0.05 * _pulseAnimation.value,
                      child: Container(
                        width: double.infinity,
                        height: 65.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.white.withOpacity(0.95),
                              Colors.white.withOpacity(0.9),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(22.r),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.8),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 12),
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              blurRadius: 40,
                              offset: const Offset(0, 0),
                              spreadRadius: 15,
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Button Pattern Background
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.r),
                                child: AnimatedBuilder(
                                  animation: _patternAnimation,
                                  builder: (context, child) {
                                    return CustomPaint(
                                      painter: ButtonPatternPainter(
                                        _patternAnimation.value,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            // Button Content
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppColors.primary.withOpacity(0.8),
                                          AppColors.primaryDark,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 24.r,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Gap(16.w),
                                  Text(
                                    'ابدأ الرحلة',
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.0,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Touch Ripple Effect
                            Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                onTap: _navigateToAuth,
                                borderRadius: BorderRadius.circular(20.r),
                                splashColor: AppColors.primary.withOpacity(0.1),
                                highlightColor: AppColors.primary.withOpacity(
                                  0.05,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              Gap(24.h),

              // Bottom decorative text
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  'مرحباً بك في عالم التعلم الإسلامي',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Enhanced Custom Painters for Complex Islamic Patterns

class ComplexIslamicBackgroundPainter extends CustomPainter {
  final double patternValue;
  final double breathValue;
  final double rotationValue;
  final double particleValue;

  ComplexIslamicBackgroundPainter(
    this.patternValue,
    this.breathValue,
    this.rotationValue,
    this.particleValue,
  );

  @override
  void paint(Canvas canvas, Size size) {
    // Draw multiple layers of Islamic patterns
    _drawMainGeometricPattern(canvas, size);
    _drawSecondaryPattern(canvas, size);
    _drawArabesque(canvas, size);
    _drawStarField(canvas, size);
  }

  void _drawMainGeometricPattern(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.08)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

    const gridSize = 80.0;
    final offsetX = (patternValue * gridSize * 0.3) % gridSize;
    final offsetY = (patternValue * gridSize * 0.3) % gridSize;

    for (double x = -offsetX; x < size.width + gridSize; x += gridSize) {
      for (double y = -offsetY; y < size.height + gridSize; y += gridSize) {
        final centerX =
            x + gridSize / 2 + 20 * math.sin(rotationValue + y / 100);
        final centerY =
            y + gridSize / 2 + 20 * math.cos(rotationValue + x / 100);

        _drawComplexStar(
          canvas,
          Offset(centerX, centerY),
          25 * breathValue,
          paint,
        );
      }
    }
  }

  void _drawComplexStar(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
  ) {
    final path = Path();
    const points = 12;
    const innerRadius = 0.6;

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi) / points + rotationValue * 0.1;
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

    canvas.drawPath(path, paint);
  }

  void _drawSecondaryPattern(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.06)
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

    // Draw interconnected hexagons
    const hexSize = 40.0;
    for (double x = 0; x < size.width; x += hexSize * 1.5) {
      for (double y = 0; y < size.height; y += hexSize * math.sqrt(3)) {
        final offsetX =
            ((y / (hexSize * math.sqrt(3))).floor() % 2) * hexSize * 0.75;
        final centerX = x + offsetX + 30 * math.sin(patternValue + x / 200);
        final centerY = y + 30 * math.cos(patternValue + y / 200);

        _drawHexagon(canvas, Offset(centerX, centerY), hexSize * 0.4, paint);
      }
    }
  }

  void _drawHexagon(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi) / 3 + rotationValue * 0.2;
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

  void _drawArabesque(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

    // Draw flowing arabesque patterns
    for (int layer = 0; layer < 3; layer++) {
      final path = Path();
      final yOffset = size.height * (0.2 + layer * 0.3);
      final amplitude = 40.0 + layer * 20.0;
      final frequency = 0.02 + layer * 0.01;

      for (double x = 0; x <= size.width; x += 5) {
        final y =
            yOffset +
            amplitude *
                math.sin(x * frequency + patternValue * 2 + layer) *
                math.cos(x * frequency * 0.5 + rotationValue + layer);

        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      paint.color = Colors.white.withOpacity(0.08 - layer * 0.02);
      canvas.drawPath(path, paint);
    }
  }

  void _drawStarField(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.6)
          ..style = PaintingStyle.fill;

    // Draw twinkling stars
    for (int i = 0; i < 50; i++) {
      final x = (i * 73.0) % size.width;
      final y = (i * 127.0) % size.height;
      final twinkle = math.sin(particleValue * 3 + i * 0.5);
      final opacity = 0.3 + 0.7 * ((twinkle + 1) / 2);
      final starSize = 1.5 + 1.5 * ((twinkle + 1) / 2);

      paint.color = Colors.white.withOpacity(opacity * 0.4);
      canvas.drawCircle(Offset(x, y), starSize, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class FloatingParticlesPainter extends CustomPainter {
  final double floatingValue;
  final double particleValue;
  final double pulseValue;

  FloatingParticlesPainter(
    this.floatingValue,
    this.particleValue,
    this.pulseValue,
  );

  @override
  void paint(Canvas canvas, Size size) {
    _drawFloatingOrbs(canvas, size);
    _drawMagicalDust(canvas, size);
    _drawEnergyWaves(canvas, size);
  }

  void _drawFloatingOrbs(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 15; i++) {
      final baseX = (i * 123.0) % size.width;
      final baseY = (i * 187.0) % size.height;

      final x = baseX + floatingValue * math.sin(particleValue + i * 0.7);
      final y = baseY + floatingValue * math.cos(particleValue * 0.8 + i * 0.5);

      final orbSize = 3.0 + 2.0 * math.sin(particleValue * 2 + i);
      final opacity = 0.2 + 0.3 * math.cos(particleValue * 1.5 + i);

      // Create gradient orb
      final gradient = RadialGradient(
        colors: [
          Colors.white.withOpacity(opacity),
          Colors.white.withOpacity(opacity * 0.5),
          Colors.transparent,
        ],
      );

      final rect = Rect.fromCircle(center: Offset(x, y), radius: orbSize * 2);
      paint.shader = gradient.createShader(rect);

      canvas.drawCircle(Offset(x, y), orbSize * pulseValue, paint);
    }
  }

  void _drawMagicalDust(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.fill;

    for (int i = 0; i < 100; i++) {
      final progress = (particleValue + i * 0.1) % 1.0;
      final x = (i * 17.0) % size.width;
      final y = progress * size.height;

      final dustSize = 0.5 + 1.5 * math.sin(particleValue * 4 + i);
      final opacity = math.sin(progress * math.pi);

      paint.color = Colors.white.withOpacity(opacity * 0.4);
      canvas.drawCircle(
        Offset(x + 20 * math.sin(progress * 6), y),
        dustSize,
        paint,
      );
    }
  }

  void _drawEnergyWaves(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

    for (int wave = 0; wave < 5; wave++) {
      final path = Path();
      final waveProgress = (particleValue + wave * 0.2) % 1.0;
      final centerY = size.height * (0.2 + wave * 0.2);
      final amplitude = 20.0 + wave * 10.0;

      final opacity = math.sin(waveProgress * math.pi);
      paint.color = Colors.white.withOpacity(opacity * 0.3);

      for (double x = 0; x <= size.width; x += 8) {
        final y =
            centerY +
            amplitude *
                math.sin((x / 50) + particleValue * 3 + wave) *
                math.exp(-waveProgress * 2);

        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class OuterIslamicRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.2)
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke;

    // Draw outer decorative ring with Islamic patterns
    for (int ring = 0; ring < 3; ring++) {
      final radius = 80.0 + ring * 15.0;
      final opacity = 0.25 - ring * 0.05;
      paint.color = Colors.white.withOpacity(opacity);

      _drawDecorativeRing(canvas, center, radius, paint);
    }
  }

  void _drawDecorativeRing(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint,
  ) {
    const segments = 24;
    final path = Path();

    for (int i = 0; i < segments; i++) {
      final startAngle = (i * 2 * math.pi) / segments;
      final endAngle = ((i + 0.8) * 2 * math.pi) / segments;

      final rect = Rect.fromCircle(center: center, radius: radius);

      if (i % 2 == 0) {
        path.addArc(rect, startAngle, endAngle - startAngle);
      }
    }

    canvas.drawPath(path, paint);

    // Add decorative dots
    for (int i = 0; i < segments; i++) {
      if (i % 3 == 0) {
        final angle = (i * 2 * math.pi) / segments;
        final x = center.dx + (radius + 8) * math.cos(angle);
        final y = center.dy + (radius + 8) * math.sin(angle);

        canvas.drawCircle(
          Offset(x, y),
          3,
          Paint()..color = Colors.white.withOpacity(0.4),
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MiddleIslamicRingPainter extends CustomPainter {
  final double animationValue;

  MiddleIslamicRingPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.3)
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

    // Draw animated middle ring with flowing patterns
    const segments = 16;
    final path = Path();

    for (int i = 0; i < segments; i++) {
      final baseAngle = (i * 2 * math.pi) / segments;
      final animatedAngle = baseAngle + animationValue * 0.5;
      final radius = 70.0 + 10 * math.sin(animationValue * 3 + i);

      final x = center.dx + radius * math.cos(animatedAngle);
      final y = center.dy + radius * math.sin(animatedAngle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);

    // Draw inner decorative elements
    for (int i = 0; i < 8; i++) {
      final angle = (i * 2 * math.pi / 8) + animationValue;
      final innerRadius = 60.0;
      final x = center.dx + innerRadius * math.cos(angle);
      final y = center.dy + innerRadius * math.sin(angle);

      _drawMiniStar(canvas, Offset(x, y), 6, paint);
    }
  }

  void _drawMiniStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    const points = 6;

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi) / points;
      final radius = (i % 2 == 0) ? size : size * 0.5;
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

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ButtonPatternPainter extends CustomPainter {
  final double animationValue;

  ButtonPatternPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.primary.withOpacity(0.1)
          ..strokeWidth = 1.0
          ..style = PaintingStyle.stroke;

    // Draw subtle flowing pattern inside button
    final path = Path();
    for (double x = 0; x < size.width; x += 8) {
      final y =
          size.height / 2 +
          8 *
              math.sin((x / 25) + animationValue * 4) *
              math.cos((x / 35) + animationValue * 2);

      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw decorative elements
    for (int i = 0; i < 6; i++) {
      final x = (i + 1) * (size.width / 7);
      final y = size.height / 2 + 12 * math.sin(animationValue * 3 + i * 0.8);
      final opacity = 0.4 * (0.5 + 0.5 * math.sin(animationValue * 2 + i));

      canvas.drawCircle(
        Offset(x, y),
        2.5,
        Paint()..color = AppColors.primary.withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
