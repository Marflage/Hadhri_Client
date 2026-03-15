import 'package:hadhri/infrastructure/services/account_service.dart';
import 'package:hadhri/infrastructure/services/attendance_service.dart';
import 'package:hadhri/infrastructure/services/auth_service.dart';
import 'package:hadhri/infrastructure/services/course_plan_service.dart';
import 'package:hadhri/infrastructure/services/secure_storage_service.dart';
import 'package:hadhri/infrastructure/utils/api_client.dart';

class DiContainer {
  static late final SecureStorageService storageService;
  static late final AuthService authService;
  static late final ApiClient apiClient;

  static late final AttendanceService attendanceService;
  static late final CoursePlanService coursePlanService;
  static late final AccountService accountService;

  static void init() {
    storageService = SecureStorageService();
    authService = AuthService(storageService: storageService);
    apiClient = ApiClient(authService: authService);

    attendanceService = AttendanceService(apiClient: apiClient);
    coursePlanService = CoursePlanService();
    accountService = AccountService(apiClient: apiClient, authService: authService);
  }
}
