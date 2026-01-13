import '../core/result.dart';
import '../models/app_version_info.dart';
import '../../data/network/network_error.dart';

abstract class AppVersionRepository {
  Future<Result<AppVersionInfo, NetworkError>> checkVersion({
    required String platform,
    required String currentVersion,
  });
}
