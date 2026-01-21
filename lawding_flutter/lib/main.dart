import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'infrastructure/services/analytics_service.dart';
import 'infrastructure/services/crashlytics_service.dart';
import 'presentation/core/app_colors.dart';
import 'presentation/screens/splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env 파일 로드
  await dotenv.load(fileName: '.env');

  // Firebase 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Crashlytics 초기화
  await CrashlyticsService().initialize();

  // 앱 시작 이벤트 기록
  await AnalyticsService().logAppLaunched();

  runApp(
    // Riverpod ProviderScope로 앱 전체 감싸기
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lawding',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryTextColor,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.brandColor,
        fontFamily: 'Pretendard',
      ),
      navigatorObservers: [AnalyticsService().getAnalyticsObserver()],
      home: const SplashScreen(),
    );
  }
}
