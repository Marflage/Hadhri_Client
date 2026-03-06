import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // TODO: Analyze if this should be injected instead of being newed up here.
  final _storage = FlutterSecureStorage();

  Future<String?> read(String key) async {
    if (key.isEmpty) {
      throw Exception('Key is invalid');
    }

    String? value = await _storage.read(key: key);

    return value;
  }

  Future<void> write(String key, String value) async {
    if (key.isEmpty) {
      throw Exception('Key is invalid');
    }

    if (value.isEmpty) {
      throw Exception('Value is invalid');
    }

    await _storage.write(key: key, value: value);
  }

  Future<void> delete(String key) async {
    if (key.isEmpty) {
      throw Exception('Key is invalid');
    }

    await _storage.delete(key: key);
  }
}
