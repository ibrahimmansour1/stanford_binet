import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Dr. Name',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Specialist',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.onSurfaceWithOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
