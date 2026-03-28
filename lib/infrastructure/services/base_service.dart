import 'package:hadhri/infrastructure/utils/http_client.dart';

class BaseService {
  BaseService({required this.httpClient});

  final HttpClient httpClient;
}
