import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/core/result.dart';
import '../../../infrastructure/services/analytics_service.dart';
import '../../../infrastructure/services/app_version_service.dart';
import '../../../infrastructure/services/crashlytics_service.dart';
import '../../providers/providers.dart';
import '../../widgets/force_update_dialog.dart';
import '../calculator/calculator_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final _analytics = AnalyticsService();
  final _crashlytics = CrashlyticsService();
  final _appVersionService = AppVersionService();
  final _startTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// 앱 버전 체크
  Future<void> _checkAppVersion() async {
    try {
      final versionRepository = ref.read(appVersionRepositoryProvider);
      final currentVersion = await _appVersionService.getCurrentVersion();
      final platform = _appVersionService.getPlatform();

      print('🔍 [Version Check] Request:');
      print('   Platform: $platform');
      print('   Current Version: $currentVersion');

      final result = await versionRepository.checkVersion(
        platform: platform,
        currentVersion: currentVersion,
      );

      switch (result) {
        case Success(:final value):
          print('✅ [Version Check] Response Success:');
          print('   Platform: ${value.platform}');
          print('   Current Version: ${value.currentVersion}');
          print('   Minimum Version: ${value.minimumVersion}');
          print('   Force Update: ${value.forceUpdate}');
          print('   Update Message: ${value.updateMessage}');
          print('   Download URL: ${value.downloadUrl}');

          // 강제 업데이트 필요 시 다이얼로그 표시
          if (value.forceUpdate && mounted) {
            await ForceUpdateDialog.show(
              context,
              updateMessage: value.updateMessage,
            );
          }
          break;
        case Failure(:final error):
          print('❌ [Version Check] Response Failure:');
          print('   Error: $error');
          // 네트워크 오류 등으로 버전 체크 실패 시
          // 앱은 정상적으로 진행 (다음 번에 다시 체크)
          break;
      }
    } catch (e) {
      print('💥 [Version Check] Exception: $e');
      // 예외 발생 시에도 앱은 정상적으로 진행
      await _crashlytics.log('Version check failed: $e');
    }
  }

  Future<void> _initializeApp() async {
    try {
      // 이전 세션에서 크래시가 발생했는지 확인
      final didCrash = await _crashlytics.didCrashOnPreviousExecution();
      if (didCrash) {
        await _crashlytics.log('App crashed in previous session');
      }

      // 앱 버전 체크
      await _checkAppVersion();

      // 1.5초 대기
      await Future.delayed(const Duration(milliseconds: 1500));

      if (!mounted) return;

      // 스플래시 완료 이벤트 기록
      final duration = DateTime.now().difference(_startTime).inMilliseconds;
      await _analytics.logSplashCompleted(duration);

      if (!mounted) return;

      // 페이드 아웃과 함께 화면 전환
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const CalculatorScreen(),
          transitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    } catch (e, stack) {
      // 초기화 중 에러 발생 시 기록
      await _crashlytics.recordError(
        e,
        stack,
        reason: 'Splash initialization failed',
      );
      // 에러가 발생해도 앱은 계속 진행
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CalculatorScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/icons/LaunchScreen.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
