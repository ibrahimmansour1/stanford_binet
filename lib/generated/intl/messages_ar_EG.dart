// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar_EG locale. All the
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
  String get localeName => 'ar_EG';

  static String m0(years, months, days) =>
      "${years} سنة، ${months} شهر، ${days} يوم";

  static String m1(answer) => "الإجابة الصحيحة هي: ${answer}";

  static String m2(error) => "خطأ في تحميل الأسئلة: ${error}";

  static String m3(error) => "خطأ: ${error}";

  static String m4(error) => "خطأ في حفظ الدرجة: ${error}";

  static String m5(grade) => "إجابة ${grade}";

  static String m6(max) => "الدرجة (من ${max})";

  static String m7(number) => "السؤال ${number}";

  static String m8(current, total) => "السؤال ${current}/${total}";

  static String m9(answer) => "إجابة الطالب: ${answer}";

  static String m10(code) => "تم إنشاء الجلسة بنجاح! رمز الجلسة: ${code}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "ageFormat": m0,
        "appTitle": MessageLookupByLibrary.simpleMessage("ستانفورد بينيه"),
        "childTestCode":
            MessageLookupByLibrary.simpleMessage("رمز اختبار الطفل"),
        "correct": MessageLookupByLibrary.simpleMessage("صحيح"),
        "correctAnswer":
            MessageLookupByLibrary.simpleMessage("الإجابة الصحيحة"),
        "correctAnswerIs": m1,
        "dateRequired":
            MessageLookupByLibrary.simpleMessage("تاريخ الميلاد مطلوب"),
        "dismissButton": MessageLookupByLibrary.simpleMessage("إغلاق"),
        "emailLabel": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
        "emailValidationMessage": MessageLookupByLibrary.simpleMessage(
            "الرجاء إدخال البريد الإلكتروني"),
        "enterEmailMessage": MessageLookupByLibrary.simpleMessage(
            "الرجاء إدخال عنوان بريدك الإلكتروني"),
        "enterSessionCode":
            MessageLookupByLibrary.simpleMessage("أدخل رمز الجلسة"),
        "errorLoadingQuestions": m2,
        "errorMessage": m3,
        "errorSavingGrade": m4,
        "errorValidatingSessionCode": MessageLookupByLibrary.simpleMessage(
            "خطأ في التحقق من رمز الجلسة. الرجاء المحاولة مرة أخرى."),
        "forgotPasswordText":
            MessageLookupByLibrary.simpleMessage("نسيت كلمة المرور؟"),
        "fullNameHelper": MessageLookupByLibrary.simpleMessage(
            "أدخل الاسم الأول والثاني والثالث واسم العائلة"),
        "fullNameLabel":
            MessageLookupByLibrary.simpleMessage("الاسم الكامل (4 أجزاء)"),
        "futureDateError": MessageLookupByLibrary.simpleMessage(
            "لا يمكن أن يكون التاريخ في المستقبل"),
        "grade": MessageLookupByLibrary.simpleMessage("الدرجة"),
        "gradeFeedback": m5,
        "gradeOutOfMax": m6,
        "gradeSaved":
            MessageLookupByLibrary.simpleMessage("تم حفظ الدرجة بنجاح"),
        "invalidEmailError": MessageLookupByLibrary.simpleMessage(
            "صيغة البريد الإلكتروني غير صحيحة"),
        "invalidSessionCode": MessageLookupByLibrary.simpleMessage(
            "رمز الجلسة غير صالح. الرجاء المحاولة مرة أخرى."),
        "loadingExamData": MessageLookupByLibrary.simpleMessage(
            "جاري تحميل بيانات الاختبار..."),
        "loginButtonText": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
        "loginErrorTitle":
            MessageLookupByLibrary.simpleMessage("حدث خطأ أثناء تسجيل الدخول"),
        "loginSubtitle":
            MessageLookupByLibrary.simpleMessage("وصول سهل للمتخصصين"),
        "loginTitle": MessageLookupByLibrary.simpleMessage(
            "اختبار ستانفورد-بينيه للذكاء"),
        "monitorExam": MessageLookupByLibrary.simpleMessage("مراقبة الاختبار"),
        "nameLettersOnly": MessageLookupByLibrary.simpleMessage(
            "يجب أن يحتوي كل جزء من الاسم على أحرف فقط"),
        "namePartsValidation": MessageLookupByLibrary.simpleMessage(
            "الرجاء إدخال الاسم الكامل (4 أجزاء)"),
        "nameRequired": MessageLookupByLibrary.simpleMessage("الاسم مطلوب"),
        "next": MessageLookupByLibrary.simpleMessage("التالي"),
        "nextQuestion": MessageLookupByLibrary.simpleMessage("السؤال التالي"),
        "notAnsweredYet":
            MessageLookupByLibrary.simpleMessage("لم تتم الإجابة بعد"),
        "ok": MessageLookupByLibrary.simpleMessage("موافق"),
        "optionsLabel": MessageLookupByLibrary.simpleMessage("الخيارات:"),
        "partial": MessageLookupByLibrary.simpleMessage("جزئي"),
        "passwordLabel": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
        "passwordResetSentMessage": MessageLookupByLibrary.simpleMessage(
            "تم إرسال رابط إعادة تعيين كلمة المرور. يرجى التحقق من بريدك الوارد."),
        "passwordValidationMessage":
            MessageLookupByLibrary.simpleMessage("الرجاء إدخال كلمة المرور"),
        "personalInformation":
            MessageLookupByLibrary.simpleMessage("المعلومات الشخصية"),
        "pleaseEnterValidSessionCode": MessageLookupByLibrary.simpleMessage(
            "الرجاء إدخال رمز جلسة صحيح مكون من 6 أرقام."),
        "previous": MessageLookupByLibrary.simpleMessage("السابق"),
        "previousQuestion":
            MessageLookupByLibrary.simpleMessage("السؤال السابق"),
        "questionLabel": MessageLookupByLibrary.simpleMessage("السؤال:"),
        "questionNumber": m7,
        "questionNumberOf": m8,
        "registerData": MessageLookupByLibrary.simpleMessage("تسجيل البيانات"),
        "reports": MessageLookupByLibrary.simpleMessage("التقارير"),
        "saveGrade": MessageLookupByLibrary.simpleMessage("حفظ الدرجة"),
        "sessionCode": MessageLookupByLibrary.simpleMessage("رمز الجلسة"),
        "sessionTestData":
            MessageLookupByLibrary.simpleMessage("بيانات جلسة الاختبار"),
        "specialistHomeView":
            MessageLookupByLibrary.simpleMessage("الصفحة الرئيسية للمتخصص"),
        "studentAnswer": m9,
        "studentAnswerLabel":
            MessageLookupByLibrary.simpleMessage("إجابة الطالب"),
        "successMessage": m10,
        "userNotFoundError": MessageLookupByLibrary.simpleMessage(
            "لم يتم العثور على مستخدم بهذا البريد الإلكتروني"),
        "validationError": MessageLookupByLibrary.simpleMessage(
            "يرجى ملء جميع الحقول المطلوبة"),
        "wrong": MessageLookupByLibrary.simpleMessage("خطأ"),
        "wrongPasswordError":
            MessageLookupByLibrary.simpleMessage("كلمة المرور غير صحيحة")
      };
}
