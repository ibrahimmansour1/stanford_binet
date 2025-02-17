import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  String _userName = 'Specialist';

  @override
  void initState() {
    super.initState();
    _loadFirebaseUserName();
  }

  Future<void> _loadFirebaseUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String? name = user.displayName;
        name ??= user.email?.split('@').first;
        log('User name: $name');

        if (name != null && name.isNotEmpty) {
          setState(() {
            _userName = name![0].toUpperCase() + name.substring(1);
          });
        }
      }
    } catch (e) {
      log('Error loading user name: $e');
    }
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
