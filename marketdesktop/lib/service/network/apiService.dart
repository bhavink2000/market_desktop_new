import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:get_storage/get_storage.dart';

import '../../constant/const_string.dart';
import '../../constant/utilities.dart';
import '../../main.dart';
import '../../navigation/routename.dart';
import 'api.dart';
import 'package:get_ip_address/get_ip_address.dart';

class ApiService {
  static BaseOptions options = BaseOptions(
    baseUrl: Api.baseUrl,
    responseType: ResponseType.json,
    connectTimeout: const Duration(seconds: 300),
    receiveTimeout: const Duration(seconds: 300),
    contentType: "application/json",
    headers: {
      'Accept': 'application/json',
      'apptype': Platform.isAndroid ? 'android' : 'ios',
      'deviceId': '123456',
      'deviceToken': "xxxxxx",
      'deviceTypeId': '1',
      'Authorization': "Bearer ${GetStorage().read(LocalStorageKeys.userToken)}",
      // 'Authorization': "Bearer 8c5ea641-bd28-4955-a966-d00119a65ad8",
      'userId': GetStorage().read(LocalStorageKeys.userId)
    },
    // ignore: missing_return

    validateStatus: (code) {
      if (code == 401) {
        // final localStorage = GetStorage();
        // localStorage.erase();
        userId = null;
        userToken = null;
        CancelToken().cancel();
        if (isAccessTokenExpired == false) {
          showWarningToast("Your access token has been expired.".tr, isFromTop: true);
          Get.offAllNamed(RouterName.signInScreen);
          isAccessTokenExpired = true;
        }

        return false;
      } else if (code == 302) {
        // Get.offAllNamed(RouterName.acceptedThankYouScreen);
        return false;
      } else {
        return true;
      }
    },
  );

  static final dio = Dio(options);

  // ..interceptors.add(PrettyDioLogger(
  //   requestHeader: isProduction,
  //   requestBody: isProduction,
  //   responseBody: isProduction,
  //   responseHeader: false,
  //   compact: false,
  // ));
}

Future<String> getMyIP() async {
  try {
    /// Initialize Ip Address
    var ipAddress = IpAddress(type: RequestType.json);

    /// Get the IpAddress based on requestType.
    dynamic data = await ipAddress.getIpAddress();
    //print(data.toString());
    return data["ip"];
  } on IpAddressException catch (exception) {
    /// Handle the exception.
    print(exception.message);
    return "0.0.0.0";
  }
}
