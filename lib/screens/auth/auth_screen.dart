import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_learning/theme/app_theme.dart';
import 'package:open_learning/theme/app_colors.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  final PageController _pageController = PageController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isLogin = true;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;
  int _currentPage = 0;

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();

  String? _emailError;
  String? _passwordError;
  String? _nameError;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.bounceOut),
    );

    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _pageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _validateEmail(String email) {
    setState(() {
      if (email.isEmpty) {
        _emailError = 'البريد الإلكتروني مطلوب';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        _emailError = 'البريد الإلكتروني غير صحيح';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword(String password) {
    setState(() {
      if (password.isEmpty) {
        _passwordError = 'كلمة المرور مطلوبة';
      } else if (password.length < 8) {
        _passwordError = 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
      } else {
        _passwordError = null;
      }
    });
  }

  void _validateName(String name) {
    setState(() {
      if (name.isEmpty) {
        _nameError = 'الاسم مطلوب';
      } else if (name.length < 2) {
        _nameError = 'الاسم يجب أن يكون حرفين على الأقل';
      } else {
        _nameError = null;
      }
    });
  }

  bool _isFormValid() {
    if (_isLogin) {
      return _emailError == null &&
          _passwordError == null &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    } else {
      return _emailError == null &&
          _passwordError == null &&
          _nameError == null &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _nameController.text.isNotEmpty &&
          _passwordController.text == _confirmPasswordController.text;
    }
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _clearErrors();
    });

    HapticFeedback.lightImpact();

    _pageController.animateToPage(
      _isLogin ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _clearErrors() {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _nameError = null;
    });
  }

  Future<void> _handleAuth() async {
    if (!_isFormValid()) return;

    setState(() {
      _isLoading = true;
    });

    HapticFeedback.mediumImpact();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Show success message
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    showCupertinoDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: Text(
              _isLogin ? 'تم تسجيل الدخول بنجاح' : 'تم إنشاء الحساب بنجاح',
            ),
            content: Text(
              _isLogin
                  ? 'مرحباً بك في أكاديمية التعليم المفتوح'
                  : 'تم إنشاء حسابك بنجاح. مرحباً بك!',
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('حسناً'),
              ),
            ],
          ),
    );
  }

  void _handleSocialLogin(String provider) {
    HapticFeedback.lightImpact();

    showCupertinoDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: Text('تسجيل الدخول عبر $provider'),
            content: const Text('سيتم تطبيق هذه الميزة قريباً'),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('حسناً'),
              ),
            ],
          ),
    );
  }

  void _handleForgotPassword() {
    HapticFeedback.lightImpact();

    showCupertinoDialog(
      context: context,
      builder:
          (context) => CupertinoAlertDialog(
            title: const Text('نسيت كلمة المرور؟'),
            content: const Text(
              'سيتم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني',
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إلغاء'),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Handle forgot password logic
                },
                child: const Text('إرسال'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      child: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [_buildHeader(), _buildMainContent(), _buildFooter()],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4FC3F7).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  CupertinoIcons.book_fill,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'أكاديمية التعليم المفتوح',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1D1F),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _isLogin ? 'مرحباً بعودتك' : 'انضم إلينا اليوم',
              style: const TextStyle(fontSize: 16, color: Color(0xFF86868B)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildModeToggle(),
          SizedBox(
            height: _isLogin ? 400 : 500,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                  _isLogin = index == 0;
                });
              },
              children: [_buildLoginForm(), _buildSignupForm()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeToggle() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!_isLogin) _toggleMode();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isLogin ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow:
                      _isLogin
                          ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : null,
                ),
                child: Center(
                  child: Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          _isLogin
                              ? const Color(0xFF4FC3F7)
                              : const Color(0xFF86868B),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (_isLogin) _toggleMode();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isLogin ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow:
                      !_isLogin
                          ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : null,
                ),
                child: Center(
                  child: Text(
                    'إنشاء حساب',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          !_isLogin
                              ? const Color(0xFF4FC3F7)
                              : const Color(0xFF86868B),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          const SizedBox(height: 16),
          _buildRememberMeRow(),
          const SizedBox(height: 24),
          _buildAuthButton(),
          const SizedBox(height: 20),
          _buildSocialLoginSection(),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildNameField(),
          const SizedBox(height: 16),
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          const SizedBox(height: 16),
          _buildConfirmPasswordField(),
          const SizedBox(height: 24),
          _buildAuthButton(),
          const SizedBox(height: 20),
          _buildSocialLoginSection(),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('الاسم الكامل', style: AppTheme.headline),
        const SizedBox(height: 8),
        CupertinoTextField(
          controller: _nameController,
          focusNode: _nameFocusNode,
          placeholder: 'أدخل اسمك الكامل',
          style: GoogleFonts.cairo(fontSize: 16, color: AppColors.textPrimary),
          placeholderStyle: GoogleFonts.cairo(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  _nameError != null
                      ? AppColors.textOrange
                      : Colors.transparent,
            ),
          ),
          onChanged: _validateName,
          onSubmitted: (_) => _passwordFocusNode.requestFocus(),
        ),
        if (_nameError != null) ...[
          const SizedBox(height: 4),
          Text(
            _nameError!,
            style: GoogleFonts.cairo(color: AppColors.textOrange, fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('البريد الإلكتروني', style: AppTheme.headline),
        const SizedBox(height: 8),
        CupertinoTextField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          placeholder: 'أدخل بريدك الإلكتروني',
          keyboardType: TextInputType.emailAddress,
          style: GoogleFonts.cairo(fontSize: 16, color: AppColors.textPrimary),
          placeholderStyle: GoogleFonts.cairo(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  _emailError != null
                      ? AppColors.textOrange
                      : Colors.transparent,
            ),
          ),
          onChanged: _validateEmail,
          onSubmitted: (_) => _passwordFocusNode.requestFocus(),
        ),
        if (_emailError != null) ...[
          const SizedBox(height: 4),
          Text(
            _emailError!,
            style: const TextStyle(
              color: CupertinoColors.destructiveRed,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('كلمة المرور', style: AppTheme.headline),
        const SizedBox(height: 8),
        CupertinoTextField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          placeholder: 'أدخل كلمة المرور',
          obscureText: !_isPasswordVisible,
          style: GoogleFonts.cairo(fontSize: 16, color: AppColors.textPrimary),
          placeholderStyle: GoogleFonts.cairo(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  _passwordError != null
                      ? AppColors.textOrange
                      : Colors.transparent,
            ),
          ),
          suffix: GestureDetector(
            onTap: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
              HapticFeedback.lightImpact();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                _isPasswordVisible
                    ? CupertinoIcons.eye_slash
                    : CupertinoIcons.eye,
                color: const Color(0xFF86868B),
              ),
            ),
          ),
          onChanged: _validatePassword,
          onSubmitted: (_) {
            if (_isLogin) {
              _handleAuth();
            } else {
              _confirmPasswordFocusNode.requestFocus();
            }
          },
        ),
        if (_passwordError != null) ...[
          const SizedBox(height: 4),
          Text(
            _passwordError!,
            style: const TextStyle(
              color: CupertinoColors.destructiveRed,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('تأكيد كلمة المرور', style: AppTheme.headline),
        const SizedBox(height: 8),
        CupertinoTextField(
          controller: _confirmPasswordController,
          focusNode: _confirmPasswordFocusNode,
          placeholder: 'أعد إدخال كلمة المرور',
          obscureText: !_isConfirmPasswordVisible,
          style: GoogleFonts.cairo(fontSize: 16, color: AppColors.textPrimary),
          placeholderStyle: GoogleFonts.cairo(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  _passwordController.text != _confirmPasswordController.text &&
                          _confirmPasswordController.text.isNotEmpty
                      ? AppColors.textOrange
                      : Colors.transparent,
            ),
          ),
          suffix: GestureDetector(
            onTap: () {
              setState(() {
                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
              });
              HapticFeedback.lightImpact();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                _isConfirmPasswordVisible
                    ? CupertinoIcons.eye_slash
                    : CupertinoIcons.eye,
                color: const Color(0xFF86868B),
              ),
            ),
          ),
          onSubmitted: (_) => _handleAuth(),
        ),
        if (_passwordController.text != _confirmPasswordController.text &&
            _confirmPasswordController.text.isNotEmpty) ...[
          const SizedBox(height: 4),
          const Text(
            'كلمة المرور غير متطابقة',
            style: TextStyle(
              color: CupertinoColors.destructiveRed,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRememberMeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _rememberMe = !_rememberMe;
                });
                HapticFeedback.lightImpact();
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color:
                      _rememberMe
                          ? const Color(0xFF4FC3F7)
                          : Colors.transparent,
                  border: Border.all(
                    color:
                        _rememberMe
                            ? const Color(0xFF4FC3F7)
                            : const Color(0xFF86868B),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child:
                    _rememberMe
                        ? const Icon(
                          CupertinoIcons.checkmark,
                          size: 14,
                          color: Colors.white,
                        )
                        : null,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'تذكرني',
              style: TextStyle(fontSize: 14, color: Color(0xFF86868B)),
            ),
          ],
        ),
        GestureDetector(
          onTap: _handleForgotPassword,
          child: const Text(
            'نسيت كلمة المرور؟',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF4FC3F7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthButton() {
    return GestureDetector(
      onTap: _isFormValid() && !_isLoading ? _handleAuth : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 56,
        decoration: BoxDecoration(
          gradient:
              _isFormValid() && !_isLoading
                  ? const LinearGradient(
                    colors: [Color(0xFF4FC3F7), Color(0xFF29B6F6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color: _isFormValid() && !_isLoading ? null : const Color(0xFFE5E5EA),
          borderRadius: BorderRadius.circular(12),
          boxShadow:
              _isFormValid() && !_isLoading
                  ? [
                    BoxShadow(
                      color: const Color(0xFF4FC3F7).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                  : null,
        ),
        child: Center(
          child:
              _isLoading
                  ? const CupertinoActivityIndicator(color: Colors.white)
                  : Text(
                    _isLogin ? 'تسجيل الدخول' : 'إنشاء حساب',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color:
                          _isFormValid()
                              ? Colors.white
                              : const Color(0xFF86868B),
                    ),
                  ),
        ),
      ),
    );
  }

  Widget _buildSocialLoginSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[300])),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'أو',
                style: TextStyle(color: Color(0xFF86868B), fontSize: 14),
              ),
            ),
            Expanded(child: Divider(color: Colors.grey[300])),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSocialButton(
              'Google',
              CupertinoIcons.globe,
              const Color(0xFF4285F4),
            ),
            _buildSocialButton(
              'Apple',
              CupertinoIcons.device_phone_portrait,
              const Color(0xFF000000),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(String provider, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => _handleSocialLogin(provider),
      child: Container(
        width: 120,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E5EA)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              provider,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1D1D1F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'بالمتابعة، أنت توافق على شروط الخدمة وسياسة الخصوصية',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          const Text(
            '© 2024 أكاديمية التعليم المفتوح | جميع الحقوق محفوظة',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Color(0xFF86868B)),
          ),
        ],
      ),
    );
  }
}
