import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class AnimatedLogo extends StatefulWidget {
  final double size;
  final bool isAnimating;
  final bool showShadow;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onAnimationComplete;

  const AnimatedLogo({
    Key? key,
    this.size = 120.0,
    this.isAnimating = true,
    this.showShadow = true,
    this.backgroundColor = Colors.white,
    this.textColor = AppTheme.primaryColor,
    this.onAnimationComplete,
  }) : super(key: key);

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );
    
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.7, curve: Curves.elasticInOut),
      ),
    );
    
    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.elasticOut),
      ),
    );
    
    if (widget.isAnimating) {
      _controller.forward().then((_) {
        if (widget.onAnimationComplete != null) {
          widget.onAnimationComplete!();
        }
      });
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: Transform.translate(
              offset: Offset(0, -5 * _bounceAnimation.value * (1 - _bounceAnimation.value) * 4),
              child: FadeTransition(
                opacity: _fadeInAnimation,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(widget.size / 6),
                    boxShadow: widget.showShadow
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: widget.size * 0.7,
                      height: widget.size * 0.7,
                      errorBuilder: (context, error, stackTrace) => Text(
                        'SLYMON',
                        style: TextStyle(
                          color: widget.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: widget.size * 0.15,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}