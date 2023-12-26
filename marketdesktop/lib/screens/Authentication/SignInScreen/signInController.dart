import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/constant/dropdownFunctions.dart';
import 'package:window_manager/window_manager.dart';

import '../../../constant/const_string.dart';
import '../../../constant/utilities.dart';
import '../../../main.dart';
import '../../../navigation/routename.dart';
import '../../BaseController/baseController.dart';

class SignInControllerBinding implements Bindings {
  @override
  void dependencies() {
    // Get.put(() => SignInController());
    Get.put(SignInController());
  }
}

class SignInController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  TextEditingController serverController = TextEditingController();
  FocusNode serverFocus = FocusNode();
  TextEditingController userNameController = TextEditingController();
  FocusNode userNameFocus = FocusNode();
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordFocus = FocusNode();
  RxBool isLoadingSignIn = false.obs;

  bool isEyeOpen = true;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await windowManager.setTitle("BAZAAR 2.0");
    serverController.text = "bazaar";
    userNameController.text = "prem";
    passwordController.text = "123456";
    await windowManager.setMinimumSize(Size(400, 490));
    await windowManager.setSize(Size(400, 490), animate: false);
    await windowManager.setResizable(false);
    await windowManager.setMaximizable(false);

    Future.delayed(Duration(milliseconds: 100), () async {
      windowManager.center(animate: true);
      await windowManager.setMovable(false);
    });

    CancelToken().cancel();
    var response = await service.getServerNameCall();
    if (response?.statusCode == 200) {
      serverName = response?.data?.serverName ?? "";
    }
    update();
    Future.delayed(const Duration(milliseconds: 100), () {
      update();
    });
    serverFocus.addListener(() {
      update();
    });
    userNameFocus.addListener(() {
      update();
    });
    passwordFocus.addListener(() {
      update();
    });
  }

//*********************************************************************** */
  // Field Validation
  //*********************************************************************** */

  String validateField() {
    var msg = "";

    if (userNameController.text.trim().isEmpty) {
      msg = AppString.emptyUserName;
    } else if (passwordController.text.trim().isEmpty) {
      msg = AppString.emptyPassword;
    } else if (serverController.text.trim().isEmpty) {
      msg = AppString.emptyServer;
    } else if (serverController.text.trim().toLowerCase() != serverName.toLowerCase()) {
      msg = AppString.invalidServer;
    }
    return msg;
  }

  //*********************************************************************** */
  // Api Calls
  //*********************************************************************** */

  callForSignIn(BuildContext context) async {
    var msg = validateField();
    if (msg.isEmpty) {
      serverFocus.unfocus();
      userNameFocus.unfocus();
      passwordFocus.unfocus();
      isLoadingSignIn.value = true;
      update();
      var response = await service.signInCall(
          userName: userNameController.text.trim(), password: passwordController.text.trim(), serverName: serverController.text.trim());

      if (response != null) {
        if (response.statusCode == 200) {
          print(response.message);
          update();
          if (response.statusCode == 200) {
            await localStorage.write(LocalStorageKeys.userToken, response.meta?.token);
            await localStorage.write(LocalStorageKeys.userId, response.data?.userId);
            await localStorage.write(LocalStorageKeys.userData, response.data!.toJson());
            userId = response.data!.userId!;
            try {
              socket.arrSymbolNames.clear();
              await socket.connectSocket();
              socketIO.init();
            } catch (e) {
              print(e);
            }
            await socket.connectSocket();
            var userResponse = await service.profileInfoCall();
            if (userResponse != null) {
              if (userResponse.statusCode == 200) {
                userData = userResponse.data;
              }
            }

            if (userId != null) {
              var response = await service.getConstantCall();
              if (response != null) {
                constantValues = response.data;
                arrStatuslist = constantValues?.status ?? [];
                arrFilterType = constantValues?.userFilterType ?? [];
                getExchangeList();
                getScriptList();
                getUserList();
                isLoadingSignIn.value = false;
                update();
                arrLeverageList = constantValues?.leverageList ?? [];
                Get.offAllNamed(RouterName.dashbaordScreen);
              }
            }

            // Get.toNamed(RouterName.mainTab);
          } else {
            showSuccessToast(response.meta?.message ?? "", isFromTop: true);
          }

          // }

          // var model = signupData.fromJson(localStorage.read(LocalStorageKeys.userData));
        } else {
          isLoadingSignIn.value = false;
          update();
          showErrorToast(response.message ?? "", isFromTop: true);
        }
      } else {
        showErrorToast(AppString.generalError, isFromTop: true);
        isLoadingSignIn.value = false;
        update();
      }
    } else {
      showWarningToast(msg, isFromTop: true);
    }
  }
}
