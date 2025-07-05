import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:open_learning/theme/app_colors.dart';
import 'package:open_learning/widgets/islamic_patterns.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  // Animation Controllers
  late AnimationController _appBarController;
  late AnimationController _patternController;
  late AnimationController _breathController;
  late AnimationController _glowController;

  // Animations
  late Animation<double> _appBarAnimation;
  late Animation<double> _patternAnimation;
  late Animation<double> _breathAnimation;
  late Animation<double> _glowAnimation;

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
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

    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
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

    _glowAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  void _startAnimations() {
    _appBarController.forward();
    _patternController.repeat();
    _breathController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _appBarController.dispose();
    _patternController.dispose();
    _breathController.dispose();
    _glowController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Pattern
          _buildBackgroundPattern(),

          // Main Content
          Column(
            children: [
              // Custom App Bar
              _buildCustomAppBar(),

              // Tab Content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _selectedIndex = index);
                  },
                  children: [
                    _buildSettingsScreen(),
                    _buildExploreScreen(),
                    _buildAllContentScreen(), // FAB screen - index 2
                    _buildLibraryScreen(),
                    _buildMyContentScreen(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: _buildAnimatedBottomNavigation(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: Listenable.merge([_patternAnimation, _breathAnimation]),
        builder: (context, child) {
          return CustomPaint(
            painter: IslamicGeometricPatternPainter(
              _patternAnimation.value,
              _breathAnimation.value,
              0.0,
            ),
          );
        },
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
                        // Logo Section
                        AnimatedBuilder(
                          animation: _breathAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _breathAnimation.value,
                              child: Container(
                                width: 50.w,
                                height: 50.w,
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
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.r),
                                  child: Image.asset(
                                    'assets/images/app-logo.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        Gap(16.w),

                        // Title Section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'أكاديمية التعلم المفتوح',
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
                                'العلم نور والجهل ظلام',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Action Buttons
                        AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _glowAnimation.value,
                              child: Container(
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
                                child: Icon(
                                  LucideIcons.bell,
                                  color: Colors.white,
                                  size: 18.r,
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
            )
          ),
        );
      },
    );
  }

  Widget _buildAnimatedBottomNavigation() {
    // Define icon list for the 4 tabs (Settings, Explore, Library, My Content)
    final iconList = [
      LucideIcons.settings,
      LucideIcons.compass,
      LucideIcons.bookOpen,
      LucideIcons.bookmark,
    ];

    final tabLabels = ['الإعدادات', 'استكشف', 'المكتبة', 'محتواي'];

    return AnimatedBottomNavigationBar.builder(
      itemCount: iconList.length,
      tabBuilder: (int index, bool isActive) {
        final color = isActive ? Colors.white : Colors.white.withOpacity(0.7);
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconList[index], size: isActive ? 24.r : 20.r, color: color),
            Gap(4.h),
            Text(
              tabLabels[index],
              style: TextStyle(
                fontSize: isActive ? 14.sp : 12.sp,
                color: color,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        );
      },
      backgroundColor: AppColors.primary,
      activeIndex: _getActiveIndex(),
      splashColor: Colors.white.withOpacity(0.1),
      splashSpeedInMilliseconds: 300,
      notchSmoothness: NotchSmoothness.smoothEdge,
      gapLocation: GapLocation.center,
      leftCornerRadius: 25.r,
      rightCornerRadius: 25.r,
      onTap: (index) => _onTabTapped(_getTabIndex(index)),
      height: 75.h,
      elevation: 20,
      shadow: BoxShadow(
        color: AppColors.primary.withOpacity(0.15),
        blurRadius: 25,
        offset: const Offset(0, -5),
        spreadRadius: 0,
      ),
    );
  }

  int _getActiveIndex() {
    switch (_selectedIndex) {
      case 0:
        return 0; // Settings
      case 1:
        return 1; // Explore
      case 2:
        return -1; // FAB (All Content) - not highlighted in bottom nav
      case 3:
        return 2; // Library
      case 4:
        return 3; // My Content
      default:
        return -1;
    }
  }

  int _getTabIndex(int bottomNavIndex) {
    switch (bottomNavIndex) {
      case 0:
        return 0; // Settings
      case 1:
        return 1; // Explore
      case 2:
        return 3; // Library
      case 3:
        return 4; // My Content
      default:
        return 0;
    }
  }

  Widget _buildFloatingActionButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 1000,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: FloatingActionButton(
        backgroundColor: AppColors.accent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        elevation: 0,
        onPressed: () => _onTabTapped(2), // Navigate to "All" content (index 2)
        child: AnimatedBuilder(
          animation: _breathAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _breathAnimation.value,
              child: Icon(LucideIcons.grid3x3, color: Colors.white, size: 22.r),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSettingsScreen() {
    return Container(
      color: Colors.transparent,
      child: CustomScrollView(
        slivers: [
          // Profile Header Section
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(20.w),
              child: _buildProfileHeader(),
            ),
          ),

          // Settings Categories
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('الحساب والملف الشخصي'),
                  Gap(12.h),
                  _buildSettingsCategory([
                    _buildSettingsItem(
                      icon: LucideIcons.user,
                      title: 'الملف الشخصي',
                      subtitle: 'إدارة بياناتك الشخصية',
                      onTap: () {
                        // Navigate to profile screen
                        print('Navigate to Profile');
                      },
                    ),
                    _buildSettingsItem(
                      icon: LucideIcons.award,
                      title: 'شهاداتي',
                      subtitle: 'عرض الشهادات المحصلة',
                      onTap: () {
                        print('Navigate to Certificates');
                      },
                    ),
                    _buildSettingsItem(
                      icon: LucideIcons.trendingUp,
                      title: 'درجاتي',
                      subtitle: 'متابعة الدرجات والتقييمات',
                      onTap: () {
                        print('Navigate to Grades');
                      },
                    ),
                    _buildSettingsItem(
                      icon: LucideIcons.fileText,
                      title: 'سجلاتي',
                      subtitle: 'سجل الأنشطة والمشاركات',
                      onTap: () {
                        print('Navigate to Records');
                      },
                    ),
                  ]),

                  Gap(24.h),

                  _buildSectionTitle('الإشعارات والخصوصية'),
                  Gap(12.h),
                  _buildSettingsCategory([
                    _buildSettingsItem(
                      icon: LucideIcons.bell,
                      title: 'الإشعارات',
                      subtitle: 'إعدادات التنبيهات',
                      onTap: () {
                        print('Navigate to Notifications');
                      },
                    ),
                    _buildSettingsItem(
                      icon: LucideIcons.shield,
                      title: 'الخصوصية',
                      subtitle: 'إدارة إعدادات الخصوصية',
                      onTap: () {
                        print('Navigate to Privacy');
                      },
                    ),
                  ]),

                  Gap(24.h),

                  _buildSectionTitle('عن التطبيق'),
                  Gap(12.h),
                  _buildSettingsCategory([
                    _buildSettingsItem(
                      icon: LucideIcons.fileCheck,
                      title: 'الشروط والأحكام',
                      subtitle: 'اتفاقية الاستخدام',
                      onTap: () {
                        print('Navigate to Terms');
                      },
                    ),
                    _buildSettingsItem(
                      icon: LucideIcons.info,
                      title: 'معلومات التطبيق',
                      subtitle: 'الإصدار 1.0.0',
                      onTap: () {
                        print('Navigate to App Info');
                      },
                    ),
                  ]),

                  Gap(24.h),

                  // Logout Button
                  _buildLogoutButton(),

                  Gap(40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return AnimatedBuilder(
      animation: _breathAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _breathAnimation.value,
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.9),
                  AppColors.accent.withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(25.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Background Pattern
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.r),
                    child: CustomPaint(
                      painter: IslamicCardPatternPainter(
                        _patternAnimation.value,
                        _breathAnimation.value,
                      ),
                    ),
                  ),
                ),

                // Profile Content
                Row(
                  children: [
                    // Profile Avatar
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.white, Colors.white.withOpacity(0.9)],
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
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
                        size: 32.r,
                        color: AppColors.primary,
                      ),
                    ),

                    Gap(20.w),

                    // Profile Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'مرحباً بك',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Gap(4.h),
                          Text(
                            'المستخدم الكريم',
                            style: TextStyle(
                              fontSize: 22.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          Gap(4.h),
                          Text(
                            'طالب متميز',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildSettingsCategory(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(children: items),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.all(20.w),
          child: Row(
            children: [
              // Icon Container
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.accent.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Icon(icon, size: 20.r, color: AppColors.primary),
              ),

              Gap(16.w),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              Icon(
                LucideIcons.chevronRight,
                size: 16.r,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _glowAnimation.value,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.shade400,
                  Colors.red.shade500,
                  Colors.red.shade600,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Show logout confirmation dialog
                  _showLogoutDialog();
                },
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.logOut, size: 20.r, color: Colors.white),
                      Gap(12.w),
                      Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Row(
            children: [
              Icon(LucideIcons.logOut, color: Colors.red, size: 20.r),
              Gap(12.w),
              Text(
                'تسجيل الخروج',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          content: Text(
            'هل أنت متأكد من أنك تريد تسجيل الخروج؟',
            style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle logout logic here
                print('User logged out');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'تسجيل الخروج',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  // Placeholder Screens
  Widget _buildAllContentScreen() {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.accent.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.grid3x3,
                    size: 48.r,
                    color: AppColors.primary,
                  ),
                  Gap(16.h),
                  Text(
                    'جميع المحتوى',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Gap(8.h),
                  Text(
                    'هنا سيتم عرض جميع المحتويات التعليمية',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyContentScreen() {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accent.withOpacity(0.1),
                  AppColors.primary.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.accent.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.bookmark,
                    size: 60.r,
                    color: AppColors.accent,
                  ),
                  Gap(16.h),
                  Text(
                    'محتواي',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Gap(8.h),
                  Text(
                    'هنا سيتم عرض المحتويات المحفوظة والمفضلة',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExploreScreen() {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accent.withOpacity(0.1),
                  AppColors.primary.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.accent.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.compass,
                    size: 48.r,
                    color: AppColors.accent,
                  ),
                  Gap(16.h),
                  Text(
                    'استكشف',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Gap(8.h),
                  Text(
                    'اكتشف المحتوى الجديد والمثير',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLibraryScreen() {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryDark.withOpacity(0.1),
                  AppColors.primary.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.primaryDark.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.bookOpen,
                    size: 60.r,
                    color: AppColors.primaryDark,
                  ),
                  Gap(16.h),
                  Text(
                    'المكتبة',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Gap(8.h),
                  Text(
                    'مجموعة كاملة من الكتب والمراجع',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painters for Islamic Patterns

class IslamicBackgroundPatternPainter extends CustomPainter {
  final double animationValue;
  final double breathValue;

  IslamicBackgroundPatternPainter(this.animationValue, this.breathValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.primary.withOpacity(0.02)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    // Draw subtle background pattern
    const gridSize = 80.0;
    final offsetX = (animationValue * gridSize * 0.1) % gridSize;
    final offsetY = (animationValue * gridSize * 0.1) % gridSize;

    for (double x = -offsetX; x < size.width + gridSize; x += gridSize) {
      for (double y = -offsetY; y < size.height + gridSize; y += gridSize) {
        final centerX = x + gridSize / 2;
        final centerY = y + gridSize / 2;

        _drawSubtleDiamond(
          canvas,
          Offset(centerX, centerY),
          15 * breathValue,
          paint,
        );
      }
    }
  }

  void _drawSubtleDiamond(
    Canvas canvas,
    Offset center,
    double size,
    Paint paint,
  ) {
    final path = Path();
    final halfSize = size / 2;

    path.moveTo(center.dx, center.dy - halfSize);
    path.lineTo(center.dx + halfSize, center.dy);
    path.lineTo(center.dx, center.dy + halfSize);
    path.lineTo(center.dx - halfSize, center.dy);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
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

class IslamicNavPatternPainter extends CustomPainter {
  final double animationValue;
  final int selectedIndex;

  IslamicNavPatternPainter(this.animationValue, this.selectedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.primary.withOpacity(0.05)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    // Draw subtle wave pattern
    final path = Path();
    for (double x = 0; x <= size.width; x += 6) {
      final y = size.height / 2 + 8 * math.sin((x / 30) + animationValue * 3);

      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw selection indicator glow
    final selectedX = (selectedIndex + 0.5) * (size.width / 3);
    canvas.drawCircle(
      Offset(selectedX, size.height / 2),
      25,
      Paint()
        ..color = AppColors.primary.withOpacity(0.1)
        ..style = PaintingStyle.fill,
    );
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
          ..color = AppColors.accent.withOpacity(0.3)
          ..style = PaintingStyle.fill;

    // Draw concentric circles
    for (double r = 10; r < size.width / 2; r += 10) {
      canvas.drawCircle(
        size.center(Offset.zero),
        r + animationValue * 5,
        paint,
      );
    }

    // Draw decorative lines
    paint
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (double i = 0; i < size.width; i += 15) {
      canvas.drawLine(Offset(i, 0), Offset(size.width - i, size.height), paint);
      canvas.drawLine(Offset(i, size.height), Offset(size.width - i, 0), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
