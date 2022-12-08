import 'dart:async';

import 'package:get/get_connect/http/src/request/request.dart';

FutureOr<Request<dynamic>> authInterceptor(dynamic request) async {
  // final token = StorageService.box.pull(StorageItems.accessToken);

  // request.headers['X-Requested-With'] = 'XMLHttpRequest';
  // request.headers['Authorization'] = 'Bearer $token';

  return request;
}
