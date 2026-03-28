import 'package:hadhri/infrastructure/services/account_service.dart';
import 'package:hadhri/infrastructure/services/attendance_service.dart';
import 'package:hadhri/infrastructure/services/auth_service.dart';
import 'package:hadhri/infrastructure/services/course_plan_service.dart';
import 'package:hadhri/infrastructure/services/secure_storage_service.dart';
import 'package:hadhri/infrastructure/services/token_service.dart';
import 'package:hadhri/infrastructure/utils/api_client.dart';

class DiContainer {
  static late final SecureStorageService storageService;
  static late final AuthService authService;
  static late final ApiClient apiClient;
  static late final TokenService tokenService;

  static late final AttendanceService attendanceService;
  static late final CoursePlanService coursePlanService;
  static late final AccountService accountService;

  static void init() {
    storageService = SecureStorageService();
    tokenService = TokenService(storageService: storageService);
    authService = AuthService(
      tokenService: tokenService,
      storageService: storageService,
      apiClient: apiClient,
    );
    apiClient = ApiClient(tokenService: tokenService);

    attendanceService = AttendanceService(apiClient: apiClient);
    coursePlanService = CoursePlanService();
    accountService = AccountService(apiClient: apiClient);
  }
}
