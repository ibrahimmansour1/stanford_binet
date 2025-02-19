import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../generated/l10n.dart';
import 'teacher_monitoring_screen.dart';

class TeacherSessionCodeEntryScreen extends StatefulWidget {
  const TeacherSessionCodeEntryScreen({super.key});

  @override
  _TeacherSessionCodeEntryScreenState createState() =>
      _TeacherSessionCodeEntryScreenState();
}

class _TeacherSessionCodeEntryScreenState
    extends State<TeacherSessionCodeEntryScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _sessionCodeController = TextEditingController();
  late AnimationController _shakeController;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _sessionCodeController.dispose();
    super.dispose();
  }

  Future<void> _validateSessionCode(BuildContext context) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final sessionCode = _sessionCodeController.text.trim();
    if (sessionCode.isEmpty || sessionCode.length != 6) {
      _showError(S.of(context).pleaseEnterValidSessionCode);
      return;
    }

    try {
      final sessionSnapshot = await FirebaseFirestore.instance
          .collection('sessions')
          .where('session_code', isEqualTo: sessionCode)
          .limit(1)
          .get();

      if (sessionSnapshot.docs.isEmpty) {
        _showError(S.of(context).invalidSessionCode);
        return;
      }

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TeacherMonitoringScreen(sessionCode: sessionCode),
          ),
        );
      }
    } catch (e) {
      _showError(S.of(context).errorValidatingSessionCode);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });
    _shakeController.forward(from: 0.0);
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).enterSessionCode,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final sineValue = sin(4 * pi * _shakeController.value);
                  return Transform.translate(
                    offset: Offset(sineValue * 10, 0),
                    child: child,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryShadow.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      Icon(
                        Icons.key_rounded,
                        size: 48.w,
                        color: AppColors.primary,
                      ),
                      SizedBox(height: 24.h),
                      TextField(
                        controller: _sessionCodeController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall,
                        decoration: InputDecoration(
                          labelText: S.of(context).sessionCode,
                          errorText: _errorMessage,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              FilledButton(
                onPressed:
                    _isLoading ? null : () => _validateSessionCode(context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : Text(S.of(context).monitorExam),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
