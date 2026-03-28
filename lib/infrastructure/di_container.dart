import 'package:hadhri/infrastructure/interceptors/request_interceptor.dart';
import 'package:hadhri/infrastructure/interceptors/response_interceptor.dart';
import 'package:hadhri/infrastructure/services/account_service.dart';
import 'package:hadhri/infrastructure/services/attendance_service.dart';
import 'package:hadhri/infrastructure/services/auth_service.dart';
import 'package:hadhri/infrastructure/services/course_plan_service.dart';
import 'package:hadhri/infrastructure/services/secure_storage_service.dart';
import 'package:hadhri/infrastructure/services/token_service.dart';
import 'package:hadhri/infrastructure/utils/http_client.dart';

class DiContainer {
  static late final SecureStorageService storageService;
  static late final AuthService authService;
  static late final HttpClient httpClient;
  static late final TokenService tokenService;
  static late final RequestInterceptor _requestInterceptor;
  static late final ResponseInterceptor _responseInterceptor;

  static late final AttendanceService attendanceService;
  static late final CoursePlanService coursePlanService;
  static late final AccountService accountService;

  static void init() {
    storageService = SecureStorageService();
    tokenService = TokenService(storageService: storageService);

    _requestInterceptor = RequestInterceptor(tokenService: tokenService);
    _responseInterceptor = ResponseInterceptor(
      tokenService: tokenService,
      storageService: storageService,
    );

    httpClient = HttpClient(
      requestInterceptor: _requestInterceptor,
      responseInterceptor: _responseInterceptor,
    );
    
    authService = AuthService(
      tokenService: tokenService,
      storageService: storageService,
      httpClient: httpClient,
    );

    attendanceService = AttendanceService(httpClient: httpClient);
    coursePlanService = CoursePlanService();
    accountService = AccountService(httpClient: httpClient);
  }
}
