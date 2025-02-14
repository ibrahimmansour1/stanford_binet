import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AnimatedMenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Animation<double> animation;
  final double delay;

  const AnimatedMenuCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.animation,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final progress = ((animation.value - delay) / (1 - delay)).clamp(0.0, 1.0);
        final opacity = Curves.easeOut.transform(progress).clamp(0.0, 1.0);
        final slide = Curves.easeOutBack.transform(progress);

        return Transform.translate(
          offset: Offset(0, 32 * (1 - slide)),
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 8,
        shadowColor: AppColors.primaryShadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppColors.cardGradient(context),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryWithOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
