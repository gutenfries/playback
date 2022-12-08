import 'package:playback/api/base_provider.dart';
import 'package:playback/models/models.dart';
import 'package:get/get.dart';

class ApiProvider extends BaseProvider {
  Future<Response<Map<String, dynamic>>> login(String path, LoginRequest data) {
    return post<Map<String, dynamic>>(path, data.toJson());
  }

  Future<Response<Map<String, dynamic>>> register(
      String path, RegisterRequest data) {
    return post<Map<String, dynamic>>(path, data.toJson());
  }

  Future<Response<Map<String, dynamic>>> getUsers(String path) {
    return get<Map<String, dynamic>>(path);
  }
}
