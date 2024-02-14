import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/constant/dropdownFunctions.dart';
import 'package:window_manager/window_manager.dart';

import '../../../constant/const_string.dart';
import '../../../constant/index.dart';
import '../../../constant/utilities.dart';
import '../../../customWidgets/appTextField.dart';
import '../../../customWidgets/commonWidgets.dart';
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
  List<String> arrServerName = [];
  RxString selectedServerName = "".obs;
  bool isEyeOpen = true;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await windowManager.setTitle("TESLA");
    // serverController.text = "bazaar";
    // userNameController.text = "prem";
    // passwordController.text = "123456";
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
      arrServerName.add(response?.data?.serverName ?? "");
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
      var response = await service.signInCall(userName: userNameController.text.trim(), password: passwordController.text.trim(), serverName: serverController.text.trim());

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
              arrSymbolNames.clear();
              await socket.connectSocket();
              socketIO.init();
            } catch (e) {
              print(e);
            }

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

  Widget serverListDropDown(RxString selectedServer, {double? width}) {
    return Obx(() {
      return SizedBox(
          width: width ?? 250,
          // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: 40,
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField2<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.only(left: 0),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors().blueColor, width: 1)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors().grayLightLine, width: 1)),
                ),
                iconStyleData: IconStyleData(
                  icon: Container(
                    width: 35,
                    child: Row(
                      children: [
                        Container(
                          width: 2,
                          height: 25,
                          color: AppColors().grayBorderColor,
                          margin: EdgeInsets.only(right: 10),
                        ),
                        Image.asset(
                          AppImages.earthIcon,
                          width: 22,
                          height: 22,
                          color: AppColors().iconsColor,
                        ),
                      ],
                    ),
                  ),
                ),
                dropdownSearchData: DropdownSearchData(
                  searchController: userEditingController,
                  searchBarWidgetHeight: 50,
                  searchBarWidget: SizedBox(
                    height: 30,
                    // padding: EdgeInsets.only(top: 2.w, right: 2.w, left: 2.w),
                    child: CustomTextField(
                      type: '',
                      keyBoardType: TextInputType.text,
                      isEnabled: true,
                      isOptional: false,
                      inValidMsg: "",
                      placeHolderMsg: "Search",
                      emptyFieldMsg: "",
                      controller: userEditingController,
                      focus: userEditingFocus,
                      isSecure: false,
                      borderColor: AppColors().grayLightLine,
                      keyboardButtonType: TextInputAction.done,
                      maxLength: 64,
                      isShowPrefix: false,
                      fontStyle: TextStyle(fontSize: 10, fontFamily: CustomFonts.family1Medium, color: AppColors().fontColor),
                      suffixIcon: Container(
                        child: GestureDetector(
                          onTap: () {
                            userEditingController.clear();
                          },
                          child: Image.asset(
                            AppImages.crossIcon,
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value!.toString().toLowerCase().startsWith(searchValue.toLowerCase());
                  },
                ),
                hint: Text(
                  'Select Server',
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: CustomFonts.family2Regular,
                    color: AppColors().darkText,
                  ),
                ),
                items: arrServerName
                    .map((String item) => DropdownItem<String>(
                          value: item,
                          height: 30,
                          child: Text(item, style: TextStyle(fontSize: 10, fontFamily: CustomFonts.family2Regular, color: AppColors().grayColor)),
                        ))
                    .toList(),
                selectedItemBuilder: (context) {
                  return arrServerName
                      .map((String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(
                                fontFamily: CustomFonts.family1Medium,
                                fontSize: 14,
                                color: AppColors().darkText,
                              ),
                            ),
                          ))
                      .toList();
                },
                value: selectedServerName.value == "" ? null : selectedServerName.value,
                onChanged: (String? value) {
                  serverController.text = value!;
                },
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.only(left: 7, right: -6),
                  height: 30,
                ),
                dropdownStyleData: const DropdownStyleData(maxHeight: 250),
              ),
            ),
          ));
    });
  }
}
