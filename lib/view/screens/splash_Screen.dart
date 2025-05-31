import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/shared_preferences.dart';
import 'dashboard_screen.dart';
import 'login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500), // Animation duration
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut, // Fun bounce effect
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.7,
          curve: Curves.easeIn,
        ), // Fade in during the first 70% of animation
      ),
    );

    _controller.forward(); // Start the animation

    _navigateToNextScreen();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() async {
    // Wait for animation duration + a little extra delay
    await Future.delayed(const Duration(milliseconds: 2500));

    bool isLoggedIn = await SharedPrefsUtil.getLoginStatus();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) =>
                  isLoggedIn ? const DashboardScreen() : const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Fade transition to the next screen
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).primaryColor, // Or a custom splash background color
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // You can replace FlutterLogo with your actual app logo
                FlutterLogo(size: 100.h, textColor: Colors.white),
                SizedBox(height: 20.h),
                Text(
                  'Product Live App', // Replace with your app name
                  style: GoogleFonts.lato(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
