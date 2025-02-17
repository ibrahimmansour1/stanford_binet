import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  String? _userName;
  void _loadFirebaseUserName() {
    _userName = FirebaseAuth.instance.currentUser?.displayName;
    _userName ??= FirebaseAuth.instance.currentUser?.email!.split('@').first;
    if (_userName != null && _userName!.isNotEmpty) {
      _userName = _userName![0].toUpperCase() + _userName!.substring(1);
    }

    return;
  }

  @override
  void initState() {
    _loadFirebaseUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Dr. $_userName',
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
