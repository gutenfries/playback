import 'package:playback/api/base_provider.dart';
import 'package:playback/models/models.dart';
import 'package:get/get.dart';

class ApiProvider extends BaseProvider {
  Future<Response<Map<String, dynamic>>> login(LoginRequest data) {
    return post<Map<String, dynamic>>('/api/login', data.toJson());
    // {"email": "eve.holt@reqres.in", "password": "cityslicka"}
  }

  Future<Response<Map<String, dynamic>>> register(RegisterRequest data) {
    return post<Map<String, dynamic>>('/api/register', data.toJson());
  }

  Future<Response<Map<String, dynamic>>> getUsers() {
    return get<Map<String, dynamic>>('/api/users?page=1&per_page=12');
  }
}
