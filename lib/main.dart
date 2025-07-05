import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_learning/global.dart';
import 'package:open_learning/screens/base/base_screen.dart';
import 'package:open_learning/theme/app_theme.dart';
import 'package:open_learning/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  setSystemChrome();

  await NotificationService.instance.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 11 Pro design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'أكاديمية التعليم المفتوح',
              debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: false,
          showSemanticsDebugger: false,
          locale: const Locale('ar', 'SA'),
          supportedLocales: const [Locale('ar', 'SA'), Locale('en', 'US')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          theme: AppTheme.materialTheme,
          builder: (context, child) {
            return child!;
          },

          home: const MainScreen(),
        );
      },
    );
  }
}
