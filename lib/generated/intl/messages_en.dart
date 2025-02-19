// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(years, months, days) =>
      "${years} years, ${months} months, ${days} days";

  static String m1(answer) => "The correct answer is: ${answer}";

  static String m2(error) => "Error loading questions: ${error}";

  static String m3(error) => "Error: ${error}";

  static String m4(error) => "Error saving grade: ${error}";

  static String m5(grade) => "${grade} answer";

  static String m6(max) => "Grade (out of ${max})";

  static String m7(number) => "Question ${number}";

  static String m8(current, total) => "Question ${current}/${total}";

  static String m9(answer) => "Student Answer: ${answer}";

  static String m10(code) =>
      "Session created successfully! Session code: ${code}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "ageFormat": m0,
        "appTitle": MessageLookupByLibrary.simpleMessage("Stanford Binet"),
        "childTestCode":
            MessageLookupByLibrary.simpleMessage("Child Test Code"),
        "correct": MessageLookupByLibrary.simpleMessage("Correct"),
        "correctAnswer": MessageLookupByLibrary.simpleMessage("Correct Answer"),
        "correctAnswerIs": m1,
        "dateRequired":
            MessageLookupByLibrary.simpleMessage("Date of birth is required"),
        "dismissButton": MessageLookupByLibrary.simpleMessage("Dismiss"),
        "emailLabel": MessageLookupByLibrary.simpleMessage("Email"),
        "emailValidationMessage":
            MessageLookupByLibrary.simpleMessage("Please enter your email"),
        "enterEmailMessage": MessageLookupByLibrary.simpleMessage(
            "Please enter your email address"),
        "enterSessionCode":
            MessageLookupByLibrary.simpleMessage("Enter Session Code"),
        "errorLoadingQuestions": m2,
        "errorMessage": m3,
        "errorSavingGrade": m4,
        "errorValidatingSessionCode": MessageLookupByLibrary.simpleMessage(
            "Error validating session code. Please try again."),
        "forgotPasswordText":
            MessageLookupByLibrary.simpleMessage("Forgot Password?"),
        "fullNameHelper": MessageLookupByLibrary.simpleMessage(
            "Enter first, second, third and family name"),
        "fullNameLabel":
            MessageLookupByLibrary.simpleMessage("Full Name (4 parts)"),
        "futureDateError": MessageLookupByLibrary.simpleMessage(
            "Date cannot be in the future"),
        "grade": MessageLookupByLibrary.simpleMessage("Grade"),
        "gradeFeedback": m5,
        "gradeOutOfMax": m6,
        "gradeSaved":
            MessageLookupByLibrary.simpleMessage("Grade saved successfully"),
        "invalidEmailError":
            MessageLookupByLibrary.simpleMessage("Invalid email format"),
        "invalidSessionCode": MessageLookupByLibrary.simpleMessage(
            "Invalid session code. Please try again."),
        "loadingExamData":
            MessageLookupByLibrary.simpleMessage("Loading exam data..."),
        "loginButtonText": MessageLookupByLibrary.simpleMessage("Login"),
        "loginErrorTitle": MessageLookupByLibrary.simpleMessage(
            "An error occurred during login"),
        "loginSubtitle": MessageLookupByLibrary.simpleMessage(
            "Easy Access for Professionals"),
        "loginTitle":
            MessageLookupByLibrary.simpleMessage("Stanford-Binet IQ Test"),
        "monitorExam": MessageLookupByLibrary.simpleMessage("Monitor Exam"),
        "nameLettersOnly": MessageLookupByLibrary.simpleMessage(
            "Each name part should contain only letters"),
        "namePartsValidation": MessageLookupByLibrary.simpleMessage(
            "Please enter full name (4 parts)"),
        "nameRequired":
            MessageLookupByLibrary.simpleMessage("Name is required"),
        "next": MessageLookupByLibrary.simpleMessage("Next"),
        "nextQuestion": MessageLookupByLibrary.simpleMessage("Next Question"),
        "notAnsweredYet":
            MessageLookupByLibrary.simpleMessage("Not answered yet"),
        "ok": MessageLookupByLibrary.simpleMessage("OK"),
        "optionsLabel": MessageLookupByLibrary.simpleMessage("Options:"),
        "partial": MessageLookupByLibrary.simpleMessage("Partial"),
        "passwordLabel": MessageLookupByLibrary.simpleMessage("Password"),
        "passwordResetSentMessage": MessageLookupByLibrary.simpleMessage(
            "Password reset email sent. Please check your inbox."),
        "passwordValidationMessage":
            MessageLookupByLibrary.simpleMessage("Please enter your password"),
        "personalInformation":
            MessageLookupByLibrary.simpleMessage("Personal Information"),
        "pleaseEnterValidSessionCode": MessageLookupByLibrary.simpleMessage(
            "Please enter a valid 6-digit session code."),
        "previous": MessageLookupByLibrary.simpleMessage("Previous"),
        "previousQuestion":
            MessageLookupByLibrary.simpleMessage("Previous Question"),
        "questionLabel": MessageLookupByLibrary.simpleMessage("Question:"),
        "questionNumber": m7,
        "questionNumberOf": m8,
        "registerData": MessageLookupByLibrary.simpleMessage("Register Data"),
        "reports": MessageLookupByLibrary.simpleMessage("Reports"),
        "saveGrade": MessageLookupByLibrary.simpleMessage("Save Grade"),
        "sessionCode": MessageLookupByLibrary.simpleMessage("Session Code"),
        "sessionTestData":
            MessageLookupByLibrary.simpleMessage("Session Test Data"),
        "specialistHomeView":
            MessageLookupByLibrary.simpleMessage("Specialist Home View"),
        "studentAnswer": m9,
        "studentAnswerLabel":
            MessageLookupByLibrary.simpleMessage("Student Answer"),
        "successMessage": m10,
        "userNotFoundError": MessageLookupByLibrary.simpleMessage(
            "No user found with this email"),
        "validationError": MessageLookupByLibrary.simpleMessage(
            "Please fill in all required fields"),
        "wrong": MessageLookupByLibrary.simpleMessage("Wrong"),
        "wrongPasswordError":
            MessageLookupByLibrary.simpleMessage("Incorrect password")
      };
}
