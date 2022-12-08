import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:playback/models/models.dart';
import 'package:playback/shared/shared.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';

FutureOr<dynamic> responseInterceptor(
  Request<dynamic> request,
  Response<dynamic> response,
) async {
  EasyLoading.dismiss();

  if (response.statusCode != 200) {
    handleErrorStatus(response);
    return;
  }

  return response;
}

void handleErrorStatus(Response<dynamic> response) {
  switch (response.statusCode) {
    case 400:
      final message = ErrorResponse.fromJson(response.body);
      CommonWidget.toast(message.error);
      break;
    default:
  }

  return;
}
