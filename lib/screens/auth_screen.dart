import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../models/auth_model.dart';
import '../screens/home_screens.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();

  // Sign In Controllers
  final _signInController = TextEditingController();
  final _signInPasswordController = TextEditingController();

  // Sign Up Controllers
  final _signUpNameController = TextEditingController();
  final _signUpNisController = TextEditingController();
  final _signUpKelasController = TextEditingController();
  final _signUpEmailController = TextEditingController();
  final _signUpPasswordController = TextEditingController();
  final _signUpConfirmPasswordController = TextEditingController();

  bool _isSignInLoading = false;
  bool _isSignUpLoading = false;
  bool _isSignInPasswordVisible = false;
  bool _isSignUpPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    _signInController.dispose();
    _signInPasswordController.dispose();
    _signUpNameController.dispose();
    _signUpNisController.dispose();
    _signUpKelasController.dispose();
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _signUpConfirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        elevation: 8,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    if (_signInFormKey.currentState!.validate()) {
      setState(() => _isSignInLoading = true);
      try {
        final response = await AuthService.signIn(
          _signInController.text,
          _signInPasswordController.text,
        );
        if (response['success'] == true && mounted) {
          _showSnackBar('Selamat datang kembali!');
          await Future.delayed(const Duration(milliseconds: 500));
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const HomeScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 300),
            ),
          );
        } else if (mounted) {
          _showSnackBar(response['message'] ?? 'Login gagal.', isError: true);
        }
      } catch (e) {
        _showSnackBar('Terjadi kesalahan: $e', isError: true);
      } finally {
        if (mounted) setState(() => _isSignInLoading = false);
      }
    }
  }

  Future<void> _handleSignUp() async {
    if (_signUpFormKey.currentState!.validate()) {
      setState(() => _isSignUpLoading = true);
      try {
        final response = await AuthService.signUp(
          fullName: _signUpNameController.text,
          email: _signUpEmailController.text,
          password: _signUpPasswordController.text,
          nis: _signUpNisController.text,
          kelas: _signUpKelasController.text,
        );
        if (response['success'] == true && mounted) {
          _showSnackBar('Akun berhasil dibuat! Silakan masuk.');
          _tabController.animateTo(0);
          // Clear sign up form
          _signUpNameController.clear();
          _signUpNisController.clear();
          _signUpKelasController.clear();
          _signUpEmailController.clear();
          _signUpPasswordController.clear();
          _signUpConfirmPasswordController.clear();
        } else if (mounted) {
          _showSnackBar(response['message'] ?? 'Gagal membuat akun.',
              isError: true);
        }
      } catch (e) {
        _showSnackBar('Terjadi kesalahan: $e', isError: true);
      } finally {
        if (mounted) setState(() => _isSignUpLoading = false);
      }
    }
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    bool obscureText = false,
    bool hasVisibilityToggle = false,
    bool isPasswordVisible = false,
    VoidCallback? onVisibilityToggle,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText && !isPasswordVisible,
            keyboardType: keyboardType,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Color(0xFF2D3748),
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    const BorderSide(color: Color(0xFF1565C0), width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              prefixIcon: Container(
                margin: const EdgeInsets.only(left: 16, right: 12),
                child:
                    Icon(prefixIcon, color: const Color(0xFF1565C0), size: 22),
              ),
              suffixIcon: hasVisibilityToggle
                  ? Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                          color: Colors.grey[600],
                          size: 22,
                        ),
                        onPressed: onVisibilityToggle,
                      ),
                    )
                  : null,
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback? onPressed,
    required bool isLoading,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: onPressed != null
              ? [const Color(0xFF1565C0), const Color(0xFF1976D2)]
              : [Colors.grey[400]!, Colors.grey[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: const Color(0xFF1565C0).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7ED6A8), // Background hijau
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan logo
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'BacainSebelas',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // Container putih untuk form
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Custom Tab Bar
                    TabBar(
                      controller: _tabController,
                      indicatorColor: const Color(0xFF7ED6A8),
                      labelColor: const Color(0xFF1565C0),
                      unselectedLabelColor: Colors.grey[600],
                      labelStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: const [
                        Tab(text: 'Masuk'),
                        Tab(text: 'Daftar'),
                      ],
                    ),

                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildSignInTab(),
                          _buildSignUpTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignInTab() {
    return Form(
      key: _signInFormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selamat Datang Kembali! 👋',
              style: TextStyle(
                fontFamily: 'Merriweather',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Masuk untuk melanjutkan perjalanan belajar Anda',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 40),
            _buildCustomTextField(
              controller: _signInController,
              label: 'NIS',
              hint: 'Masukkan NIS Anda',
              prefixIcon: Icons.person_outline_rounded,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIS tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            _buildCustomTextField(
              controller: _signInPasswordController,
              label: 'Password',
              hint: 'Masukkan password Anda',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: true,
              hasVisibilityToggle: true,
              isPasswordVisible: _isSignInPasswordVisible,
              onVisibilityToggle: () => setState(
                  () => _isSignInPasswordVisible = !_isSignInPasswordVisible),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Handle forgot password
                },
                child: const Text(
                  'Lupa Password?',
                  style: TextStyle(
                    color: Color(0xFF1565C0),
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildGradientButton(
              text: 'Masuk',
              onPressed: _isSignInLoading ? null : _handleSignIn,
              isLoading: _isSignInLoading,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSignUpTab() {
    return Form(
      key: _signUpFormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Buat Akun Baru ✨',
              style: TextStyle(
                fontFamily: 'Merriweather',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Bergabunglah dengan komunitas belajar kami',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 32),
            _buildCustomTextField(
              controller: _signUpNameController,
              label: 'Nama Lengkap',
              hint: 'Masukkan nama lengkap Anda',
              prefixIcon: Icons.person_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildCustomTextField(
              controller: _signUpNisController,
              label: 'NIS',
              hint: 'Masukkan NIS Anda',
              prefixIcon: Icons.badge_rounded,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'NIS tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildCustomTextField(
              controller: _signUpKelasController,
              label: 'Kelas',
              hint: 'Contoh: XI IPA 1',
              prefixIcon: Icons.class_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Kelas tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildCustomTextField(
              controller: _signUpEmailController,
              label: 'Email/No. Telepon',
              hint: 'Masukkan email atau nomor telepon',
              prefixIcon: Icons.email_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email/No. Telepon tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildCustomTextField(
              controller: _signUpPasswordController,
              label: 'Password',
              hint: 'Masukkan password',
              prefixIcon: Icons.lock_rounded,
              obscureText: true,
              hasVisibilityToggle: true,
              isPasswordVisible: _isSignUpPasswordVisible,
              onVisibilityToggle: () => setState(
                  () => _isSignUpPasswordVisible = !_isSignUpPasswordVisible),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password tidak boleh kosong';
                }
                if (value.length < 6) {
                  return 'Password minimal 6 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildCustomTextField(
              controller: _signUpConfirmPasswordController,
              label: 'Konfirmasi Password',
              hint: 'Ulangi password Anda',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: true,
              hasVisibilityToggle: true,
              isPasswordVisible: _isConfirmPasswordVisible,
              onVisibilityToggle: () => setState(
                  () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Konfirmasi password tidak boleh kosong';
                }
                if (value != _signUpPasswordController.text) {
                  return 'Password tidak cocok';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            _buildGradientButton(
              text: 'Daftar',
              onPressed: _isSignUpLoading ? null : _handleSignUp,
              isLoading: _isSignUpLoading,
            ),
          ],
        ),
      ),
    );
  }
}
