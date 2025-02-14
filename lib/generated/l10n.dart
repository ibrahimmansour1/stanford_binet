// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Stanford Binet`
  String get appTitle {
    return Intl.message(
      'Stanford Binet',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `Stanford-Binet IQ Test`
  String get loginTitle {
    return Intl.message(
      'Stanford-Binet IQ Test',
      name: 'loginTitle',
      desc: '',
      args: [],
    );
  }

  /// `Easy Access for Professionals`
  String get loginSubtitle {
    return Intl.message(
      'Easy Access for Professionals',
      name: 'loginSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get emailLabel {
    return Intl.message(
      'Email',
      name: 'emailLabel',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordLabel {
    return Intl.message(
      'Password',
      name: 'passwordLabel',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get emailValidationMessage {
    return Intl.message(
      'Please enter your email',
      name: 'emailValidationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get passwordValidationMessage {
    return Intl.message(
      'Please enter your password',
      name: 'passwordValidationMessage',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginButtonText {
    return Intl.message(
      'Login',
      name: 'loginButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPasswordText {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPasswordText',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email address`
  String get enterEmailMessage {
    return Intl.message(
      'Please enter your email address',
      name: 'enterEmailMessage',
      desc: '',
      args: [],
    );
  }

  /// `Password reset email sent. Please check your inbox.`
  String get passwordResetSentMessage {
    return Intl.message(
      'Password reset email sent. Please check your inbox.',
      name: 'passwordResetSentMessage',
      desc: '',
      args: [],
    );
  }

  /// `Error: {error}`
  String errorMessage(String error) {
    return Intl.message(
      'Error: $error',
      name: 'errorMessage',
      desc: '',
      args: [error],
    );
  }

  /// `Register Data`
  String get registerData {
    return Intl.message(
      'Register Data',
      name: 'registerData',
      desc: '',
      args: [],
    );
  }

  /// `Child Test Code`
  String get childTestCode {
    return Intl.message(
      'Child Test Code',
      name: 'childTestCode',
      desc: '',
      args: [],
    );
  }

  /// `Reports`
  String get reports {
    return Intl.message(
      'Reports',
      name: 'reports',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar', countryCode: 'EG'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
