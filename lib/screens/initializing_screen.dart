import 'package:flutter/material.dart';
import '../constants/legal.dart';
import '../l10n/generated/app_localizations.dart';

class InitializingScreen extends StatefulWidget {
  const InitializingScreen({super.key});

  @override
  State<InitializingScreen> createState() => _InitializingScreenState();
}

class _InitializingScreenState extends State<InitializingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Configure animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [Colors.grey[900]!, Colors.black],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Spacer to push content up slightly
                  const Spacer(flex: 2),

                  // Logo with scale animation
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyan.withValues(alpha: 0.3),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/icon.png',
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // App title
                  Text(
                    AppLocalizations.of(context)!.appTitle.toUpperCase(),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.cyan.withValues(alpha: 0.5),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    AppLocalizations.of(context)!.retroGamingFrontend,
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 2,
                      color: Colors.grey[400],
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Indeterminate loading indicator
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: Column(
                      children: [
                        // Indeterminate progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            minHeight: 6,
                            backgroundColor: Colors.grey[800],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.cyan,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Status text
                        Text(
                          AppLocalizations.of(context)!.loading,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[300],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Version at the bottom
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Text(
                      'v$kAppVersion',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
