import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({super.key, required this.url, required this.title});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        // 1. leadingWidth를 늘려야 아이콘과 텍스트가 한 줄에 다 나옵니다.
        leadingWidth: 90,
        // 2. IconButton 대신 GestureDetector를 사용하여 아이콘+텍스트 전체를 클릭 가능하게 만듭니다.
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          behavior: HitTestBehavior.opaque, // 빈 공간 클릭도 인식
          child: Row(
            children: [
              const SizedBox(width: 20), // 왼쪽 끝 여백
              const Icon(
                Icons.arrow_back_ios,
                size: 18, // 텍스트와 균형을 맞추기 위해 약간 조절
                color: AppColors.brandColor,
              ),
              const SizedBox(width: 3), // 아이콘과 텍스트 사이 간격
              Text(
                '뒤로',
                style: pretendard(
                  weight: 700,
                  size: 20,
                  color: AppColors.brandColor,
                ),
              ),
            ],
          ),
        ),
        title: Text(
          widget.title,
          style: pretendard(
            weight: 700,
            size: 20, // 일반적인 앱바 타이틀 크기로 조정
            color: AppColors.brandColor, // 타이틀은 보통 기본 텍스트색을 사용합니다.
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.brandColor),
            ),
        ],
      ),
    );
  }
}
