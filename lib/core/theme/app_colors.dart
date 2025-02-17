import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Colors.blue;
  static const Color onPrimary = Colors.white;
  static const Color surface = Colors.white;
  static const Color onSurface = Colors.black87;
  static const Color error = Colors.red;

  // Opacity Colors
  static Color primaryWithOpacity(double opacity) =>
      primary.withOpacity(opacity);
  static Color onSurfaceWithOpacity(double opacity) =>
      onSurface.withOpacity(opacity);

  // Gradients
  static List<Color> cardGradient(BuildContext context) => [
        surface,
        surface.mix(primary, 0.05),
      ];

  // Shadow Colors
  static Color primaryShadow = primary.withOpacity(0.2);
}

extension ColorExtension on Color {
  Color mix(Color other, double amount) {
    return Color.lerp(this, other, amount)!;
  }
}
