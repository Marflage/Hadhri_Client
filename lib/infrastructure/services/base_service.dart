import 'package:hadhri/infrastructure/utils/api_client.dart';

class BaseService {
  BaseService({required this.apiClient});

  final ApiClient apiClient;
}
