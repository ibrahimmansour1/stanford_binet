import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stanford_binet/core/widgets/custom_loader.dart';

import 'core/helpers/app_router.dart';
import 'features/auth/viewmodels/auth_view_model.dart';
import 'features/auth/views/login_screen.dart';
import 'features/home/views/home_screen.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);

    return ScreenUtilInit(
        designSize: const Size(440, 956),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            title: "Stanford Benit",
            theme: ThemeData(
              colorScheme: ColorScheme(
                brightness: Brightness.light,
                primary: Colors.blue,
                onPrimary: Colors.white,
                secondary: Colors.blueAccent,
                onSecondary: Colors.white,
                error: Colors.red,
                onError: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              useMaterial3: true,
            ),
            onGenerateRoute: onGenerateRoute,
            initialRoute: AppRoutes.initial,
            debugShowCheckedModeBanner: false,
            home: authState.when(
              data: (user) =>
                  user != null ? const HomeScreen() : const LoginScreen(),
              loading: () => const Scaffold(
                body: CustomLoader(),
              ),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          );
        });
  }
}
