import 'dart:async';
import 'package:flutter/material.dart';
import '../calculator/calculator_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // TODO: 여기에 초기화 메서드들을 추가하세요
    // 예: await _loadUserData();
    // 예: await _checkAppVersion();

    // 3초 대기
    await Future.delayed(const Duration(milliseconds: 3000));

    if (mounted) {
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
