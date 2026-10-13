import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../services/auth_service.dart';
import '../home/main_bottom_nav.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await AuthService.register(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Navigate to Home screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainBottomNavigation()),
        (route) => false,
      );
    } else {
      setState(() {
        _errorMessage = result.message;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.dark,
                      size: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.dark,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Join StyleHub for exclusive fashion trends & deals',
                  style: TextStyle(fontSize: 13, color: AppColors.grey),
                ),

                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // First Name & Last Name (Row)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('First Name *'),
                          TextFormField(
                            controller: _firstNameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: _buildInputDecoration('First Name', Icons.person_outline),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) return 'Required';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFieldLabel('Last Name'),
                          TextFormField(
                            controller: _lastNameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: _buildInputDecoration('Last Name', Icons.person_outline),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Email Address
                _buildFieldLabel('Email Address *'),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildInputDecoration('example@domain.com', Icons.email_outlined),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Please enter your email';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val.trim())) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Mobile Number
                _buildFieldLabel('Mobile Number *'),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _buildInputDecoration('9876543210', Icons.phone_android_outlined),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Please enter mobile number';
                    if (val.trim().length < 10) return 'Enter a valid 10-digit number';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Password
                _buildFieldLabel('Password * (Min 8 Characters)'),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: _buildInputDecoration(
                    '••••••••',
                    Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: AppColors.grey,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Please enter password';
                    if (val.length < 8) return 'Password must be at least 8 characters';
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Confirm Password
                _buildFieldLabel('Confirm Password *'),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: _buildInputDecoration(
                    '••••••••',
                    Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: AppColors.grey,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Please confirm password';
                    if (val != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),

                const SizedBox(height: 28),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Text(
                            'CREATE ACCOUNT',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                // Already have account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: TextStyle(color: AppColors.grey, fontSize: 13.5),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.dark,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData prefixIcon, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.lightGrey, fontSize: 13.5),
      prefixIcon: Icon(prefixIcon, color: AppColors.grey, size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade300),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    );
  }
}