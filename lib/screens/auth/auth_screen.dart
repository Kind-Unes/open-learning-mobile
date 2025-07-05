import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:open_learning/theme/app_colors.dart';
import 'package:open_learning/theme/islamic_components.dart';
import 'package:open_learning/widgets/islamic_patterns.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
  bool _isSignUp = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool get _isEmailValid => RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  ).hasMatch(_emailController.text.trim());
  bool get _isPasswordValid => _passwordController.text.length >= 8;
  bool get _isFormValid {
    if (_isSignUp) {
      return _isEmailValid &&
          _isPasswordValid &&
          _firstNameController.text.trim().isNotEmpty &&
          _lastNameController.text.trim().isNotEmpty &&
          _passwordController.text == _confirmPasswordController.text;
    }
    return _isEmailValid && _passwordController.text.isNotEmpty;
  }

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
    _emailController.addListener(() => setState(() {}));
    _passwordController.addListener(() => setState(() {}));
    _firstNameController.addListener(() => setState(() {}));
    _lastNameController.addListener(() => setState(() {}));
    _confirmPasswordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _patternController.dispose();
    _breathController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_isFormValid) {
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isSignUp
                ? 'الرجاء إكمال جميع الحقول بشكل صحيح'
                : 'الرجاء إدخال بيانات صحيحة',
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();

    // Simulate loading
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    // Navigate to next screen (simulated)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isSignUp ? 'تم إنشاء الحساب بنجاح' : 'تم تسجيل الدخول بنجاح',
        ),
      ),
    );
  }

  Future<void> _handleGoogleAuth() async {
    setState(() => _isLoading = true);
    HapticFeedback.lightImpact();

    try {
      // Simulate Google authentication
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to next screen (simulated)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isSignUp
                ? 'تم إنشاء الحساب بنجاح عبر جوجل'
                : 'تم تسجيل الدخول بنجاح عبر جوجل',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في المصادقة عبر جوجل: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
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
                // Top Row with Back Button and Auth Toggle
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

                      // Auth Toggle Button
                      GestureDetector(
                        onTap: () => setState(() => _isSignUp = !_isSignUp),
                        child: Container(
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
                            _isSignUp
                                ? LucideIcons.logIn
                                : LucideIcons.userPlus,
                            color: Colors.white,
                            size: 18.r,
                          ),
                        ),
                      ),
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
                        // Logo Content (replace with your actual logo)
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
                'أكاديمية التعلم المفتوح',
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
                'Open Learning Academy',
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
              padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 40.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(),
                  Gap(20.h),
                  if (_isSignUp) ...[_buildNameInputSection(), Gap(10.h)],
                  _buildEmailInputSection(),
                  Gap(10.h),
                  _buildPasswordInputSection(),
                  if (_isSignUp) ...[
                    Gap(10.h),
                    _buildConfirmPasswordInputSection(),
                  ],
                  Gap(32.h),
                  _buildContinueButton(),
                  Gap(20.h),
                  _buildOrDivider(),
                  Gap(20.h),
                  _buildGoogleButton(),
                  Gap(32.h),
                  _buildTermsSection(),
                  _isSignUp ? Gap(120.h) : Gap(300.h),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            Gap(16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'أهلاً وسهلاً',
                        style: TextStyle(
                          fontSize: 25.sp,
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
                          LucideIcons.bookOpen,
                          color: AppColors.primary,
                          size: 24.r,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _isSignUp
                        ? 'أنشئ حساباً جديداً للانضمام إلى رحلة التعلم'
                        : 'سجل دخولك للوصول إلى عالم التعلم',
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

  Widget _buildNameInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                controller: _firstNameController,
                hintText: 'الاسم الأول',
                icon: LucideIcons.user,
                isValid: _firstNameController.text.trim().isNotEmpty,
              ),
            ),
            Gap(16.w),
            Expanded(
              child: _buildInputField(
                controller: _lastNameController,
                hintText: 'الاسم الأخير',
                icon: LucideIcons.user,
                isValid: _lastNameController.text.trim().isNotEmpty,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmailInputSection() {
    return _buildInputField(
      controller: _emailController,
      hintText: 'أدخل بريدك الإلكتروني',
      icon: LucideIcons.mail,
      keyboardType: TextInputType.emailAddress,
      isValid: _isEmailValid,
    );
  }

  Widget _buildPasswordInputSection() {
    return _buildInputField(
      controller: _passwordController,
      hintText: 'أدخل كلمة المرور قوية',
      icon: LucideIcons.lock,
      isPassword: true,
      obscureText: _obscurePassword,
      onToggleObscure:
          () => setState(() => _obscurePassword = !_obscurePassword),
      isValid: _isPasswordValid,
    );
  }

  Widget _buildConfirmPasswordInputSection() {
    return _buildInputField(
      controller: _confirmPasswordController,
      hintText: 'أعد كتابة كلمة المرور',

      icon: LucideIcons.lock,
      isPassword: true,
      obscureText: _obscureConfirmPassword,
      onToggleObscure:
          () => setState(
            () => _obscureConfirmPassword = !_obscureConfirmPassword,
          ),
      isValid:
          _passwordController.text == _confirmPasswordController.text &&
          _confirmPasswordController.text.isNotEmpty,
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleObscure,
    required bool isValid,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color:
              controller.text.isNotEmpty
                  ? (isValid
                      ? AppColors.primary.withOpacity(0.6)
                      : Colors.red.withOpacity(0.6))
                  : AppColors.border.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color:
                controller.text.isNotEmpty
                    ? (isValid
                        ? AppColors.primary.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1))
                    : Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: TextFormField(
          controller: controller,
          enabled: !_isLoading,
          keyboardType: keyboardType,
          obscureText: obscureText,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            fillColor: AppColors.background,
            filled: true,
            prefixIcon: Container(
              margin: EdgeInsets.all(12.w),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20.r),
            ),
            suffixIcon:
                isPassword
                    ? IconButton(
                      onPressed: onToggleObscure,
                      icon: Icon(
                        obscureText ? LucideIcons.eyeOff : LucideIcons.eye,
                        color: AppColors.textSecondary,
                        size: 20.r,
                      ),
                    )
                    : controller.text.isNotEmpty
                    ? Container(
                      margin: EdgeInsets.all(12.w),
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors:
                              isValid
                                  ? [
                                    Colors.green.withOpacity(0.2),
                                    Colors.green.withOpacity(0.1),
                                  ]
                                  : [
                                    Colors.red.withOpacity(0.2),
                                    Colors.red.withOpacity(0.1),
                                  ],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        isValid ? LucideIcons.check : LucideIcons.x,
                        color: isValid ? Colors.green : Colors.red,
                        size: 20.r,
                      ),
                    )
                    : null,
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.6),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(18.r),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: 20.h,
              horizontal: 16.w,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return IslamicComponents.buildIslamicButton(
      text: 'متابعة',
      onPressed: _handleSubmit,
      patternAnimation: _patternAnimation,
      isLoading: _isLoading,
      suffixIcon: LucideIcons.arrowRight,
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.border.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Gap(16.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.border.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            'أو',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Gap(16.w),
        Expanded(
          child: Container(
            height: 1.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.border.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return IslamicComponents.buildGoogleButton(
      text: _isSignUp ? 'Continue with Google' : 'Continue with Google',
      onPressed: _handleGoogleAuth,
      isLoading: _isLoading,
    );
  }

  Widget _buildTermsSection() {
    return Center(
      child: Text.rich(
        TextSpan(
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          children: [
            const TextSpan(text: 'بالمتابعة، أوافق على '),
            TextSpan(
              text: 'الشروط والأحكام',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
            const TextSpan(text: ' و'),
            TextSpan(
              text: 'سياسة الخصوصية',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
