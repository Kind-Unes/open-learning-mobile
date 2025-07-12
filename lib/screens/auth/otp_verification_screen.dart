import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:pinput/pinput.dart';
import 'package:open_learning/theme/app_colors.dart';
import 'package:open_learning/widgets/islamic_components.dart';
import 'package:open_learning/widgets/islamic_patterns.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String? email;
  final String? phoneNumber;

  const OtpVerificationScreen({super.key, this.email, this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with TickerProviderStateMixin {
  final _otpController = TextEditingController();
  final _focusNode = FocusNode();

  late AnimationController _fadeController;
  late AnimationController _patternController;
  late AnimationController _breathController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _patternAnimation;
  late Animation<double> _breathAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  bool _isLoading = false;
  bool _canResend = false;
  int _resendCountdown = 60;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _patternController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );

    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _patternAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _patternController, curve: Curves.linear),
    );

    _breathAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.elasticInOut),
    );

    _fadeController.forward();
    _patternController.repeat();
    _breathController.repeat(reverse: true);
    _rotationController.repeat();
    _pulseController.repeat(reverse: true);

    _startResendCountdown();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _patternController.dispose();
    _breathController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startResendCountdown() {
    _canResend = false;
    _resendCountdown = 60;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendCountdown--;
          if (_resendCountdown <= 0) {
            _canResend = true;
          }
        });
      }
      return _resendCountdown > 0 && mounted;
    });
  }

  Future<void> _handleVerifyOtp() async {
    if (_otpController.text.length != 6) {
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال رمز التحقق كاملاً'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();

    try {
      // Simulate OTP verification
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to next screen (simulated)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم التحقق بنجاح!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to main app or next screen
      // Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في التحقق: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleResendOtp() async {
    if (!_canResend) return;

    HapticFeedback.lightImpact();

    try {
      // Simulate resending OTP
      await Future.delayed(const Duration(seconds: 1));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم إرسال رمز التحقق مرة أخرى'),
          backgroundColor: Colors.green,
        ),
      );

      _startResendCountdown();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في إرسال الرمز: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
              AppColors.primary,
              AppColors.primary.withOpacity(0.85),
              AppColors.background,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            // make it can't scroll
            slivers: [
              // Top Islamic Header Section as SliverAppBar
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.41,
                floating: false,
                pinned: true,
                snap: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildIslamicTopSection(),
                  collapseMode: CollapseMode.parallax,
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: Container(),
                ),
              ),

              // Form Card as Sliver
              SliverToBoxAdapter(child: _buildFormCard()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIslamicTopSection() {
    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          // Islamic Geometric Background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                _patternAnimation,
                _breathAnimation,
                _rotationAnimation,
              ]),
              builder: (context, child) {
                return CustomPaint(
                  painter: IslamicGeometricPatternPainter(
                    _patternAnimation.value,
                    _breathAnimation.value,
                    _rotationAnimation.value,
                  ),
                );
              },
            ),
          ),

          // Overlay Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.3),
                  radius: 1.2,
                  colors: [
                    Colors.transparent,
                    AppColors.primary.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                // Top Row with Back Button
                Padding(
                  padding: EdgeInsets.only(top: 50.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            LucideIcons.arrowRight,
                            color: Colors.white,
                            size: 18.r,
                          ),
                        ),
                      ),

                      Container(), // Empty space for balance
                    ],
                  ),
                ),

                // Islamic Logo Section
                _buildIslamicLogoSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIslamicLogoSection() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer Islamic Ring
            AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: CustomPaint(
                    size: Size(160.w, 160.w),
                    painter: IslamicRingPainter(_pulseAnimation.value),
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
                  child: Container(
                    width: 130.w,
                    height: 130.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Logo Container
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 130.w,
                    height: 130.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Colors.white.withOpacity(0.95)],
                      ),
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.1),
                          blurRadius: 50,
                          offset: const Offset(0, 0),
                          spreadRadius: 15,
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Logo Content
                        Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22.r),
                            child: Image.asset(
                              "assets/images/app-logo.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Shine Effect
                        AnimatedBuilder(
                          animation: _patternAnimation,
                          builder: (context, child) {
                            return Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22.r),
                                  gradient: LinearGradient(
                                    begin: Alignment(
                                      -1.0 +
                                          2.0 * (_patternAnimation.value % 1.0),
                                      -1.0,
                                    ),
                                    end: Alignment(
                                      1.0 +
                                          2.0 * (_patternAnimation.value % 1.0),
                                      1.0,
                                    ),
                                    colors: [
                                      Colors.transparent,
                                      Colors.white.withOpacity(0.3),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.5, 1.0],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),

        // App Title with Islamic Style
        Container(
          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 16.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'تحقق من هويتك',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
              Gap(4.h),
              Text(
                'التحقق من هويتك باستخدام رمز التحقق',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormCard() {
    return ClipPath(
      clipper: IslamicCardClipper(),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, AppColors.background, Colors.white],
            stops: const [0.0, 0.5, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, -15),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Islamic Card Background Pattern
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _patternAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: IslamicCardPatternPainter(
                      _patternAnimation.value,
                      _breathAnimation.value,
                    ),
                  );
                },
              ),
            ),

            // Main Content
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 0.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildWelcomeSection(),
                  Gap(20.h),
                  _buildOtpInputSection(),
                  Gap(12.h),
                  _buildResendSection(),
                  Gap(10.h),
                  _buildVerifyButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 6.w,
              height: 50.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.accent,
                    AppColors.primary.withOpacity(0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(3.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(2, 0),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'تحقق من رمز التحقق',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Gap(12.w),
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withOpacity(0.2),
                              AppColors.accent.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          LucideIcons.shieldCheck,
                          color: AppColors.primary,
                          size: 24.r,
                        ),
                      ),
                    ],
                  ),
                  Gap(8.h),
                  Text(
                    widget.email != null
                        ? 'تم إرسال رمز التحقق إلى ${widget.email}'
                        : widget.phoneNumber != null
                        ? 'تم إرسال رمز التحقق إلى ${widget.phoneNumber}'
                        : 'تم إرسال رمز التحقق إليك',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                      height: 1.6,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOtpInputSection() {
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 60.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primary.withOpacity(0.8), width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: AppColors.primary.withOpacity(0.1),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Colors.red.withOpacity(0.8), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
    );

    return Column(
      children: [
        Text(
          'أدخل رمز التحقق المكون من 6 أرقام وحروف',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(24.h),
        Pinput(
          controller: _otpController,
          focusNode: _focusNode,
          length: 6,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          submittedPinTheme: submittedPinTheme,
          errorPinTheme: errorPinTheme,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          showCursor: true,
          cursor: Container(
            width: 2.w,
            height: 24.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(1.r),
            ),
          ),
          onCompleted: (pin) {
            // Auto-verify when all 6 characters are entered
            if (pin.length == 6) {
              _handleVerifyOtp();
            }
          },
          hapticFeedbackType: HapticFeedbackType.lightImpact,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          enabled: !_isLoading,
        ),
      ],
    );
  }

  Widget _buildResendSection() {
    return Column(
      children: [
        Text(
          'لم تتلق الرمز؟',
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Gap(8.h),
        if (_canResend)
          GestureDetector(
            onTap: _handleResendOtp,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.1),
                    AppColors.primary.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                'إعادة إرسال الرمز',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
        else
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.border.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              'إعادة الإرسال خلال $_resendCountdown ثانية',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVerifyButton() {
    return IslamicComponents.buildIslamicButton(
      text: 'تحقق من الرمز',
      onPressed: _handleVerifyOtp,
      patternAnimation: _patternAnimation,
      isLoading: _isLoading,
      suffixIcon: LucideIcons.shieldCheck,
    );
  }
}
