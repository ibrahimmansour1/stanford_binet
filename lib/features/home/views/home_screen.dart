import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stanford_binet/core/helpers/app_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../generated/l10n.dart';
import '../../auth/viewmodels/auth_view_model.dart';
import '../widgets/animated_menu_card.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/user_info.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _randomDelays =
      List.generate(3, (index) => math.Random().nextDouble() * 0.5);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.surface,
        title: Row(
          children: const [
            ProfileAvatar(),
            SizedBox(width: 16),
            UserInfo(),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: AppColors.primary),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: AppColors.error),
            onPressed: () {
              ref.read(authViewModelProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 1,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5,
                children: [
                  AnimatedMenuCard(
                    title: S.of(context).registerData,
                    imagePath: 'assets/images/register.png',
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.registerDataView),
                    animation: _controller,
                    delay: _randomDelays[0],
                  ),
                  AnimatedMenuCard(
                    title: S.of(context).childTestCode,
                    imagePath: 'assets/images/exam.png',
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.teacherSessionCodeEntryScreen),
                    animation: _controller,
                    delay: _randomDelays[1],
                  ),
                  AnimatedMenuCard(
                    title: S.of(context).reports,
                    imagePath: 'assets/images/reports.png',
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.reportsView),
                    animation: _controller,
                    delay: _randomDelays[2],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
