import 'dart:async';

import 'package:playback/models/models.dart';
import 'package:playback/models/response/users_response.dart';

import 'api.dart';

class ApiRepository {
  ApiRepository({required this.apiProvider});

  final ApiProvider apiProvider;

  Future<LoginResponse?> login(LoginRequest data) async {
    final res = await apiProvider.login(data);
    if (res.statusCode == 200) {
      return LoginResponse.fromJson(res.body!);
    }
    return null;
  }

  Future<RegisterResponse?> register(RegisterRequest data) async {
    final res = await apiProvider.register(data);
    if (res.statusCode == 200) {
      return RegisterResponse.fromJson(res.body!);
    }
    return null;
  }

  Future<UsersResponse?> getUsers() async {
    final res = await apiProvider.getUsers();
    if (res.statusCode == 200) {
      return UsersResponse.fromJson(res.body!);
    }
    return null;
  }
}
