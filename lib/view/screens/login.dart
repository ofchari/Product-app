import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/constants.dart';
import '../../utils/shared_preferences.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final username = _usernameController.text;
      final password = _passwordController.text;

      // Simulate network delay (optional)
      await Future.delayed(const Duration(seconds: 1));

      if (username == AppConstants.correctUsername &&
          password == AppConstants.correctPassword) {
        // Save login status
        await SharedPrefsUtil.saveLoginStatus(true);

        // Navigate to Dashboard and remove login screen from stack
        if (mounted) {
          // Check if the widget is still in the tree
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        }
      } else {
        if (mounted) {
          // Check if the widget is still in the tree
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Invalid username or password.',
                style: GoogleFonts.lato(),
              ),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }

      if (mounted) {
        // Check if the widget is still in the tree
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // App Logo or Title (Optional)
                  FlutterLogo(size: 80.h),
                  SizedBox(height: 40.h),
                  Text(
                    'Welcome Back!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Login to continue',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // Username Field
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_outline, size: 20.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15.h,
                        horizontal: 15.w,
                      ),
                    ),
                    style: GoogleFonts.lato(fontSize: 16.sp),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline, size: 20.sp),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 20.sp,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15.h,
                        horizontal: 15.w,
                      ),
                    ),
                    style: GoogleFonts.lato(fontSize: 16.sp),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Login Button
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          'Login',
                          style: GoogleFonts.lato(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  SizedBox(height: 20.h),
                  // Optional: Forgot Password or Sign Up links
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
