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

  /// `An error occurred during login`
  String get loginErrorTitle {
    return Intl.message(
      'An error occurred during login',
      name: 'loginErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `No user found with this email`
  String get userNotFoundError {
    return Intl.message(
      'No user found with this email',
      name: 'userNotFoundError',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect password`
  String get wrongPasswordError {
    return Intl.message(
      'Incorrect password',
      name: 'wrongPasswordError',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email format`
  String get invalidEmailError {
    return Intl.message(
      'Invalid email format',
      name: 'invalidEmailError',
      desc: '',
      args: [],
    );
  }

  /// `Dismiss`
  String get dismissButton {
    return Intl.message(
      'Dismiss',
      name: 'dismissButton',
      desc: '',
      args: [],
    );
  }

  /// `Session Test Data`
  String get sessionTestData {
    return Intl.message(
      'Session Test Data',
      name: 'sessionTestData',
      desc: '',
      args: [],
    );
  }

  /// `Specialist Home View`
  String get specialistHomeView {
    return Intl.message(
      'Specialist Home View',
      name: 'specialistHomeView',
      desc: '',
      args: [],
    );
  }

  /// `Personal Information`
  String get personalInformation {
    return Intl.message(
      'Personal Information',
      name: 'personalInformation',
      desc: '',
      args: [],
    );
  }

  /// `Full Name (4 parts)`
  String get fullNameLabel {
    return Intl.message(
      'Full Name (4 parts)',
      name: 'fullNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Enter first, second, third and family name`
  String get fullNameHelper {
    return Intl.message(
      'Enter first, second, third and family name',
      name: 'fullNameHelper',
      desc: '',
      args: [],
    );
  }

  /// `Name is required`
  String get nameRequired {
    return Intl.message(
      'Name is required',
      name: 'nameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please enter full name (4 parts)`
  String get namePartsValidation {
    return Intl.message(
      'Please enter full name (4 parts)',
      name: 'namePartsValidation',
      desc: '',
      args: [],
    );
  }

  /// `Each name part should contain only letters`
  String get nameLettersOnly {
    return Intl.message(
      'Each name part should contain only letters',
      name: 'nameLettersOnly',
      desc: '',
      args: [],
    );
  }

  /// `Date of birth is required`
  String get dateRequired {
    return Intl.message(
      'Date of birth is required',
      name: 'dateRequired',
      desc: '',
      args: [],
    );
  }

  /// `Date cannot be in the future`
  String get futureDateError {
    return Intl.message(
      'Date cannot be in the future',
      name: 'futureDateError',
      desc: '',
      args: [],
    );
  }

  /// `{years} years, {months} months, {days} days`
  String ageFormat(int years, int months, int days) {
    return Intl.message(
      '$years years, $months months, $days days',
      name: 'ageFormat',
      desc: '',
      args: [years, months, days],
    );
  }

  /// `Please fill in all required fields`
  String get validationError {
    return Intl.message(
      'Please fill in all required fields',
      name: 'validationError',
      desc: '',
      args: [],
    );
  }

  /// `Session created successfully! Session code: {code}`
  String successMessage(String code) {
    return Intl.message(
      'Session created successfully! Session code: $code',
      name: 'successMessage',
      desc: '',
      args: [code],
    );
  }

  /// `Session Code`
  String get sessionCode {
    return Intl.message(
      'Session Code',
      name: 'sessionCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter Session Code`
  String get enterSessionCode {
    return Intl.message(
      'Enter Session Code',
      name: 'enterSessionCode',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid 6-digit session code.`
  String get pleaseEnterValidSessionCode {
    return Intl.message(
      'Please enter a valid 6-digit session code.',
      name: 'pleaseEnterValidSessionCode',
      desc: '',
      args: [],
    );
  }

  /// `Invalid session code. Please try again.`
  String get invalidSessionCode {
    return Intl.message(
      'Invalid session code. Please try again.',
      name: 'invalidSessionCode',
      desc: '',
      args: [],
    );
  }

  /// `Error validating session code. Please try again.`
  String get errorValidatingSessionCode {
    return Intl.message(
      'Error validating session code. Please try again.',
      name: 'errorValidatingSessionCode',
      desc: '',
      args: [],
    );
  }

  /// `Error loading questions: {error}`
  String errorLoadingQuestions(String error) {
    return Intl.message(
      'Error loading questions: $error',
      name: 'errorLoadingQuestions',
      desc: '',
      args: [error],
    );
  }

  /// `Next Question`
  String get nextQuestion {
    return Intl.message(
      'Next Question',
      name: 'nextQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Previous Question`
  String get previousQuestion {
    return Intl.message(
      'Previous Question',
      name: 'previousQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Question {number}`
  String questionNumber(int number) {
    return Intl.message(
      'Question $number',
      name: 'questionNumber',
      desc: '',
      args: [number],
    );
  }

  /// `Student Answer: {answer}`
  String studentAnswer(String answer) {
    return Intl.message(
      'Student Answer: $answer',
      name: 'studentAnswer',
      desc: '',
      args: [answer],
    );
  }

  /// `Student Answer`
  String get studentAnswerLabel {
    return Intl.message(
      'Student Answer',
      name: 'studentAnswerLabel',
      desc: '',
      args: [],
    );
  }

  /// `Grade`
  String get grade {
    return Intl.message(
      'Grade',
      name: 'grade',
      desc: '',
      args: [],
    );
  }

  /// `Save Grade`
  String get saveGrade {
    return Intl.message(
      'Save Grade',
      name: 'saveGrade',
      desc: '',
      args: [],
    );
  }

  /// `Grade (out of {max})`
  String gradeOutOfMax(int max) {
    return Intl.message(
      'Grade (out of $max)',
      name: 'gradeOutOfMax',
      desc: '',
      args: [max],
    );
  }

  /// `Grade saved successfully`
  String get gradeSaved {
    return Intl.message(
      'Grade saved successfully',
      name: 'gradeSaved',
      desc: '',
      args: [],
    );
  }

  /// `Error saving grade: {error}`
  String errorSavingGrade(String error) {
    return Intl.message(
      'Error saving grade: $error',
      name: 'errorSavingGrade',
      desc: '',
      args: [error],
    );
  }

  /// `Monitor Exam`
  String get monitorExam {
    return Intl.message(
      'Monitor Exam',
      name: 'monitorExam',
      desc: '',
      args: [],
    );
  }

  /// `Loading exam data...`
  String get loadingExamData {
    return Intl.message(
      'Loading exam data...',
      name: 'loadingExamData',
      desc: '',
      args: [],
    );
  }

  /// `Question {current}/{total}`
  String questionNumberOf(int current, int total) {
    return Intl.message(
      'Question $current/$total',
      name: 'questionNumberOf',
      desc: '',
      args: [current, total],
    );
  }

  /// `Question:`
  String get questionLabel {
    return Intl.message(
      'Question:',
      name: 'questionLabel',
      desc: '',
      args: [],
    );
  }

  /// `Not answered yet`
  String get notAnsweredYet {
    return Intl.message(
      'Not answered yet',
      name: 'notAnsweredYet',
      desc: '',
      args: [],
    );
  }

  /// `Options:`
  String get optionsLabel {
    return Intl.message(
      'Options:',
      name: 'optionsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get previous {
    return Intl.message(
      'Previous',
      name: 'previous',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `{grade} answer`
  String gradeFeedback(String grade) {
    return Intl.message(
      '$grade answer',
      name: 'gradeFeedback',
      desc: '',
      args: [grade],
    );
  }

  /// `Correct Answer`
  String get correctAnswer {
    return Intl.message(
      'Correct Answer',
      name: 'correctAnswer',
      desc: '',
      args: [],
    );
  }

  /// `The correct answer is: {answer}`
  String correctAnswerIs(String answer) {
    return Intl.message(
      'The correct answer is: $answer',
      name: 'correctAnswerIs',
      desc: '',
      args: [answer],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Wrong`
  String get wrong {
    return Intl.message(
      'Wrong',
      name: 'wrong',
      desc: '',
      args: [],
    );
  }

  /// `Partial`
  String get partial {
    return Intl.message(
      'Partial',
      name: 'partial',
      desc: '',
      args: [],
    );
  }

  /// `Correct`
  String get correct {
    return Intl.message(
      'Correct',
      name: 'correct',
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
