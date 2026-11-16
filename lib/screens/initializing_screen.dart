import 'package:flutter/material.dart';
import '../constants/legal.dart';
import '../l10n/generated/app_localizations.dart';
import '../utils/app_theme.dart';

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
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(
      begin: 0.92,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C10),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.15),
            radius: 1.1,
            colors: [Color(0xFF181C26), Color(0xFF0B0C10)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Logo with subtle Apple TV-style halo
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.04),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.darkPrimary.withValues(alpha: 0.22),
                            blurRadius: 40,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/icon.png',
                        width: 104,
                        height: 104,
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // App title
                  Text(
                    l10n.appTitle.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4.5,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    l10n.retroGamingFrontend,
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 1.2,
                      color: Colors.white.withValues(alpha: 0.58),
                    ),
                  ),

                  const SizedBox(height: 44),

                  // Compact indeterminate loading indicator
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            minHeight: 4,
                            backgroundColor: Colors.white.withValues(alpha: 0.12),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.darkPrimary,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          l10n.loading,
                          style: TextStyle(
                            fontSize: 13,
                            letterSpacing: 0.4,
                            color: Colors.white.withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Version at the bottom
                  Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: Text(
                      'v$kAppVersion',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
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
