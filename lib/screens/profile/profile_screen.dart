import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:open_learning/screens/base/base_screen.dart';
import 'package:open_learning/theme/app_colors.dart';
import 'package:open_learning/theme/app_theme.dart';
import 'dart:math' as math;

import 'package:open_learning/utils/app_extension.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _floatingController;
  late AnimationController _shimmerController;
  late AnimationController _appBarController;
  late AnimationController _patternController;
  late AnimationController _breathController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _appBarAnimation;
  late Animation<double> _patternAnimation;
  late Animation<double> _breathAnimation;

  // Profile form controllers
  final _firstNameController = TextEditingController(text: 'محمد');
  final _lastNameController = TextEditingController(text: 'الأحمد');

  // Password form controllers
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _showProfileInfo = true;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _appBarController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _patternController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _breathController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _floatingAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    _appBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _appBarController, curve: Curves.easeOutCubic),
    );

    _patternAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _patternController, curve: Curves.linear),
    );

    _breathAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _appBarController.forward();
    _patternController.repeat();
    _breathController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatingController.dispose();
    _shimmerController.dispose();
    _appBarController.dispose();
    _patternController.dispose();
    _breathController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const BackgroundPattern(),
          _buildCustomPaint(),
          Column(
            children: [
              // Custom App Bar
              _buildCustomAppBar(),
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      _buildFloatingProfileCard(),
                      const SizedBox(height: 20),
                      _buildToggleSection(),
                      const SizedBox(height: 20),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (child, animation) {
                          return SlideTransition(
                            position: animation.drive(
                              Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: Offset.zero,
                              ),
                            ),
                            child: child,
                          );
                        },
                        child:
                            _showProfileInfo
                                ? _buildAdvancedProfileSection()
                                : _buildAdvancedPasswordSection(),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomPaint() {
    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: IslamicPatternPainter(_floatingAnimation.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildAdvancedSaveButton() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child:
                  _isLoading
                      ? const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.white,
                          ),
                        ),
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              LucideIcons.save,
                              size: 20,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'حفظ التغييرات',
                            style: AppTheme.body.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdvancedChangePasswordButton() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 1000),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.accent, Color(0xFFD4941A)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.accent.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child:
                  _isLoading
                      ? const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.white,
                          ),
                        ),
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              LucideIcons.key,
                              size: 20,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'تغيير كلمة المرور',
                            style: AppTheme.body.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
            ),
          ),
        );
      },
    );
  }

  void _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Show success message
    _showAdvancedSuccessMessage('تم حفظ المعلومات بنجاح');
  }

  void _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showAdvancedErrorMessage('كلمات المرور غير متطابقة');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Clear password fields
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    // Show success message
    _showAdvancedSuccessMessage('تم تغيير كلمة المرور بنجاح');
  }

  void _showAdvancedSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  LucideIcons.check,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: AppTheme.body.copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showAdvancedErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  LucideIcons.fileWarning,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: AppTheme.body.copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return AnimatedBuilder(
      animation: _appBarAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -100 * (1 - _appBarAnimation.value)),
          child: Container(
            height: 120.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.9),
                  AppColors.primary.withOpacity(0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // App Bar Pattern
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _patternAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: IslamicAppBarPatternPainter(
                          _patternAnimation.value,
                          _breathAnimation.value,
                        ),
                      );
                    },
                  ),
                ),

                // App Bar Content
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        // Back Button
                        Container(
                          width: 45.w,
                          height: 45.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              LucideIcons.arrowRight,
                              color: Colors.white,
                              size: 18.r,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),

                        Gap(16.w),

                        // Title Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'الملف الشخصي',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 0.8,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'إدارة المعلومات الشخصية',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Profile Avatar
                        AnimatedBuilder(
                          animation: _breathAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _breathAnimation.value,
                              child: Container(
                                width: 45.w,
                                height: 45.w,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white,
                                      Colors.white.withOpacity(0.9),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  LucideIcons.user,
                                  color: AppColors.primary,
                                  size: 20.r,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingProfileCard() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.1),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.15),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        AnimatedBuilder(
                          animation: _shimmerAnimation,
                          builder: (context, child) {
                            return Container(
                              width: double.infinity,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primary.withOpacity(0.7),
                                    AppColors.primary,
                                  ],
                                  stops:
                                      [
                                            _shimmerAnimation.value - 0.3,
                                            _shimmerAnimation.value,
                                            _shimmerAnimation.value + 0.3,
                                          ]
                                          .map((stop) => stop.clamp(0.0, 1.0))
                                          .toList(),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                LucideIcons.user,
                                size: 55,
                                color: AppColors.white,
                              ),
                            );
                          },
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.accent, Color(0xFFD4941A)],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.white,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accent.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              LucideIcons.camera,
                              size: 18,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'محمد الأحمد',
                      style: AppTheme.titleMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'mohamed.ahmed@email.com',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 15,
                left: 15,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    LucideIcons.crown,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedStatsRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 1,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withOpacity(0.0),
                  AppColors.primary.withOpacity(0.3),
                  AppColors.primary.withOpacity(0.0),
                ],
              ),
            ),
          ),
          _buildAdvancedStatItem(
            'مكتملة',
            'المعلومات',
            LucideIcons.award,
            AppColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedStatItem(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTheme.caption.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTheme.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSliverToggleSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _showProfileInfo = true),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color:
                          _showProfileInfo
                              ? AppColors.primary
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow:
                          _showProfileInfo
                              ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                              : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.user,
                          color:
                              _showProfileInfo
                                  ? AppColors.white
                                  : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'المعلومات الشخصية',
                          style: AppTheme.bodySmall.copyWith(
                            color:
                                _showProfileInfo
                                    ? AppColors.white
                                    : AppColors.textSecondary,
                            fontWeight:
                                _showProfileInfo
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _showProfileInfo = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color:
                          !_showProfileInfo
                              ? AppColors.accent
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow:
                          !_showProfileInfo
                              ? [
                                BoxShadow(
                                  color: AppColors.accent.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                              : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.lock,
                          color:
                              !_showProfileInfo
                                  ? AppColors.white
                                  : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'كلمة المرور',
                          style: AppTheme.bodySmall.copyWith(
                            color:
                                !_showProfileInfo
                                    ? AppColors.white
                                    : AppColors.textSecondary,
                            fontWeight:
                                !_showProfileInfo
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedProfileSection() {
    return Container(
      key: const ValueKey('profile'),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Container(
            width: double.infinity,

            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.2),
                            AppColors.primary.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        LucideIcons.pen,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تحديث المعلومات الشخصية',
                          style: AppTheme.headline.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'قم بتحديث معلوماتك الشخصية هنا',
                          style: AppTheme.caption,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildAdvancedProfileForm(),
                const SizedBox(height: 24),
                _buildAdvancedImageSection(),
                const SizedBox(height: 32),
                _buildAdvancedSaveButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedPasswordSection() {
    return Container(
      key: const ValueKey('password'),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: AppColors.accent.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.accent.withOpacity(0.2),
                            AppColors.accent.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        LucideIcons.shield,
                        color: AppColors.accent,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تغيير كلمة المرور',
                          style: AppTheme.headline.copyWith(
                            color: AppColors.accent,
                          ),
                        ),
                        Text(
                          'قم بإدخال كلمة المرور الحالية والجديدة',
                          style: AppTheme.caption,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildAdvancedPasswordForm(),
                const SizedBox(height: 32),
                _buildAdvancedChangePasswordButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedProfileForm() {
    return Column(
      children: [
        _buildAdvancedTextField(
          controller: _firstNameController,
          labelText: 'الاسم الأول',
          icon: LucideIcons.user,
          color: AppColors.primary,
          delay: 200,
        ),
        const SizedBox(height: 20),
        _buildAdvancedTextField(
          controller: _lastNameController,
          labelText: 'الاسم الأخير',
          icon: LucideIcons.users,
          color: AppColors.primary,
          delay: 400,
        ),
      ],
    );
  }

  Widget _buildAdvancedPasswordForm() {
    return Column(
      children: [
        _buildAdvancedTextField(
          controller: _currentPasswordController,
          labelText: 'كلمة المرور الحالية',
          icon: LucideIcons.lock,
          color: AppColors.accent,
          isPassword: true,
          isPasswordVisible: _isPasswordVisible,
          onToggleVisibility: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
          delay: 200,
        ),
        const SizedBox(height: 20),
        _buildAdvancedTextField(
          controller: _newPasswordController,
          labelText: 'كلمة المرور الجديدة',
          icon: LucideIcons.keyRound,
          color: AppColors.accent,
          isPassword: true,
          isPasswordVisible: _isNewPasswordVisible,
          onToggleVisibility: () {
            setState(() {
              _isNewPasswordVisible = !_isNewPasswordVisible;
            });
          },
          delay: 400,
        ),
        const SizedBox(height: 20),
        _buildAdvancedTextField(
          controller: _confirmPasswordController,
          labelText: 'تأكيد كلمة المرور الجديدة',
          icon: LucideIcons.shieldCheck,
          color: AppColors.accent,
          isPassword: true,
          isPasswordVisible: _isConfirmPasswordVisible,
          onToggleVisibility: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
          delay: 600,
        ),
      ],
    );
  }

  Widget _buildAdvancedTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required Color color,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onToggleVisibility,
    int delay = 0,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                obscureText: isPassword && !isPasswordVisible,
                style: AppTheme.body,
                decoration: AppTheme.getInputDecoration(
                  labelText: labelText,
                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 20, color: color),
                  ),
                  suffixIcon:
                      isPassword
                          ? IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? LucideIcons.eyeOff
                                  : LucideIcons.eye,
                              color: color.withOpacity(0.7),
                            ),
                            onPressed: onToggleVisibility,
                          )
                          : null,
                ).copyWith(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: AppColors.background,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdvancedImageSection() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: context.width,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.05),
                  AppColors.primary.withOpacity(0.02),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    LucideIcons.upload,
                    size: 32,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'تحديث الصورة الشخصية',
                  style: AppTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text('اضغط لاختيار صورة جديدة', style: AppTheme.caption),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildToggleSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showProfileInfo = true),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color:
                        _showProfileInfo
                            ? AppColors.primary
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow:
                        _showProfileInfo
                            ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                            : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.user,
                        color:
                            _showProfileInfo
                                ? AppColors.white
                                : AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'المعلومات الشخصية',
                        style: AppTheme.bodySmall.copyWith(
                          color:
                              _showProfileInfo
                                  ? AppColors.white
                                  : AppColors.textSecondary,
                          fontWeight:
                              _showProfileInfo
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _showProfileInfo = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color:
                        !_showProfileInfo
                            ? AppColors.accent
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow:
                        !_showProfileInfo
                            ? [
                              BoxShadow(
                                color: AppColors.accent.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ]
                            : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.lock,
                        color:
                            !_showProfileInfo
                                ? AppColors.white
                                : AppColors.textSecondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'كلمة المرور',
                        style: AppTheme.bodySmall.copyWith(
                          color:
                              !_showProfileInfo
                                  ? AppColors.white
                                  : AppColors.textSecondary,
                          fontWeight:
                              !_showProfileInfo
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IslamicPatternPainter extends CustomPainter {
  final double animationValue;

  IslamicPatternPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.primary.withOpacity(0.03)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 4);
    final radius = 100.0;

    // Draw animated geometric patterns
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4) + (animationValue * math.pi / 180);
      final startX = center.dx + radius * math.cos(angle);
      final startY = center.dy + radius * math.sin(angle);

      final endX = center.dx + (radius + 40) * math.cos(angle);
      final endY = center.dy + (radius + 40) * math.sin(angle);

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }

    // Draw subtle geometric shapes
    paint.color = AppColors.accent.withOpacity(0.02);
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi / 3) + (animationValue * math.pi / 360);
      final x = size.width - 100 + 30 * math.cos(angle);
      final y = size.height - 200 + 30 * math.sin(angle);

      canvas.drawCircle(Offset(x, y), 20, paint);
    }

    // Add flowing lines
    final path = Path();
    paint.color = AppColors.primary.withOpacity(0.05);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;

    path.moveTo(0, size.height * 0.7);
    for (double x = 0; x <= size.width; x += 20) {
      final y =
          size.height * 0.7 +
          20 * math.sin((x / 50) + (animationValue * math.pi / 180));
      path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class IslamicAppBarPatternPainter extends CustomPainter {
  final double animationValue;
  final double breathValue;

  IslamicAppBarPatternPainter(this.animationValue, this.breathValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    // Draw flowing wave pattern
    final path = Path();
    for (double x = 0; x <= size.width; x += 8) {
      final y =
          size.height * 0.7 +
          15 *
              math.sin((x / 40) + animationValue * 2) *
              math.cos((x / 60) + animationValue);

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
      final y = size.height * 0.8;
      final opacity = 0.3 * (0.5 + 0.5 * math.sin(animationValue * 2 + i));

      canvas.drawCircle(
        Offset(x, y),
        3 * breathValue,
        Paint()..color = Colors.white.withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
