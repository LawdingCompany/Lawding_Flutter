/// 서버에서 받아올 앱 버전 정보
class AppVersionInfo {
  final String platform; // 플랫폼 (ios, android)
  final String currentVersion; // 현재 버전
  final String minimumVersion; // 최소 지원 버전
  final bool forceUpdate; // 강제 업데이트 여부
  final String updateMessage; // 업데이트 메시지
  final String downloadUrl; // 다운로드 URL

  AppVersionInfo({
    required this.platform,
    required this.currentVersion,
    required this.minimumVersion,
    required this.forceUpdate,
    required this.updateMessage,
    required this.downloadUrl,
  });

  factory AppVersionInfo.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return AppVersionInfo(
      platform: data['platform'] as String,
      currentVersion: data['currentVersion'] as String,
      minimumVersion: data['minimumVersion'] as String,
      forceUpdate: data['forceUpdate'] as bool,
      updateMessage: data['updateMessage'] as String,
      downloadUrl: data['downloadUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'currentVersion': currentVersion,
      'minimumVersion': minimumVersion,
      'forceUpdate': forceUpdate,
      'updateMessage': updateMessage,
      'downloadUrl': downloadUrl,
    };
  }
}
