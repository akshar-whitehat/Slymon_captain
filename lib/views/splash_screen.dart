import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_theme.dart';
import '../services/auth_service.dart';
import '../widgets/animated_logo.dart';
import 'auth/login_screen.dart';
import 'main_app_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _textAnimationController;
  late Animation<double> _fadeTextAnimation;
  late Animation<double> _slideTextAnimation;
  bool _animationComplete = false;

  @override
  void initState() {
    super.initState();
    
    // Initialize text animation controller
    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    // Create fade animation for text
    _fadeTextAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
      ),
    );
    
    // Create slide animation for text
    _slideTextAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );
    
    // Start text animation after logo animation completes
    Timer(const Duration(milliseconds: 1500), () {
      _textAnimationController.forward();
    });
    
    // Navigate to next screen after delay
    Timer(const Duration(milliseconds: 4000), () {
      _navigateToNextScreen();
    });
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    // For demo purposes, always navigate to login screen
    // In a real app, you would check if the user is authenticated
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
    
    // Uncomment this for a real implementation
    /*
    if (authService.currentUser != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainAppScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            AnimatedLogo(
              size: 140,
              onAnimationComplete: () {
                setState(() {
                  _animationComplete = true;
                });
              },
            ),
            const SizedBox(height: 40),
            // App name with animation
            AnimatedBuilder(
              animation: _textAnimationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideTextAnimation.value),
                  child: Opacity(
                    opacity: _fadeTextAnimation.value,
                    child: Column(
                      children: [
                        // App name
                        const Text(
                          'Slymon Captain',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SF Pro Display',
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Tagline
                        const Text(
                          'Drive. Earn. Succeed.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontFamily: 'Inter',
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Demo mode indicator
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'DEMO MODE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        const SizedBox(height: 48),
                        // Loading indicator
                        const SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}