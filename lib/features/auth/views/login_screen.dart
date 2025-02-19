import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stanford_binet/core/helpers/app_router.dart';

import '../../../generated/l10n.dart';
import '../viewmodels/auth_view_model.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await ref.read(authViewModelProvider.notifier).signIn(
              _emailController.text,
              _passwordController.text,
            );
      } catch (e) {
        if (!mounted) return;

        String errorMessage = S.of(context).loginErrorTitle;

        if (e.toString().contains('user-not-found')) {
          errorMessage = S.of(context).userNotFoundError;
        } else if (e.toString().contains('wrong-password')) {
          errorMessage = S.of(context).wrongPasswordError;
        } else if (e.toString().contains('invalid-email')) {
          errorMessage = S.of(context).invalidEmailError;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(errorMessage),
                ),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: S.of(context).dismissButton,
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> _handleResetPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).enterEmailMessage),
        ),
      );
      return;
    }
    await ref.read(authViewModelProvider.notifier).resetPassword(
          _emailController.text,
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).passwordResetSentMessage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.psychology,
                        size: 64,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        S.of(context).loginTitle,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        S.of(context).loginSubtitle,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: S.of(context).emailLabel,
                          prefixIcon: Icon(Icons.email_outlined,
                              color: Colors.blue.shade300),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).emailValidationMessage;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: S.of(context).passwordLabel,
                          prefixIcon: Icon(Icons.lock_outline,
                              color: Colors.blue.shade300),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.blue.shade300,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: authState.isLoading
                                  ? null
                                  : _handleResetPassword,
                              child: const Text('Reset Password'),
                            ),
                          ),
                        ],
                      ),
                      FilledButton(
                        onPressed: authState.isLoading ? null : _handleLogin,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          disabledBackgroundColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: authState.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 3,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            child: Text('OR'),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 3,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () => Navigator.pushNamed(
                            context, AppRoutes.childHomeView),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.blue),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Continue as Child',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
