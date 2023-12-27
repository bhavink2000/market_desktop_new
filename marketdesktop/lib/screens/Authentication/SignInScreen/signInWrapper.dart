import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/constant/const_string.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:window_manager/window_manager.dart';

import '../../../constant/assets.dart';
import '../../../constant/color.dart';
import '../../../constant/font_family.dart';
import '../../../customWidgets/appButton.dart';
import '../../../customWidgets/appTextField.dart';

import '../../BaseController/baseController.dart';
import 'signInController.dart';

class SignInScreen extends BaseView<SignInController> {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    //print(MediaQuery.of(context).size.width);
    //print(MediaQuery.of(context).size.height);
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return Future.value(false);
        },
        child: Scaffold(
            backgroundColor: AppColors().bgColor,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              // Container(
                              //   child: Image.asset(
                              //     AppImages.appLogo,
                              //     width: 22,
                              //     height: 22,
                              //   ),
                              // ),
                              // SizedBox(
                              //   width: 2.w,
                              // ),
                              // Text("Login",
                              //     style: TextStyle(
                              //         fontSize: 16, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  // windowManager.destroy();
                                  exit(0);
                                },
                                child: Image.asset(
                                  AppImages.closeIcon,
                                  width: 15,
                                  height: 15,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 75),
                              child: Image.asset(
                                AppImages.appLoginLogo,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          // Center(
                          //   child: Text("BAZAAR 2.0",
                          //       style: TextStyle(
                          //           fontSize: 40, fontFamily: CustomFonts.family1ExtraBold, color: AppColors().blueColor)),
                          // ),
                          SizedBox(
                            height: 3.h,
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          CustomTextField(
                            type: 'ServerName',
                            keyBoardType: TextInputType.text,
                            isEnabled: true,
                            isOptional: false,
                            inValidMsg: AppString.emptyServer,
                            placeHolderMsg: "Server name",
                            labelMsg: "Server Name",
                            emptyFieldMsg: AppString.emptyServer,
                            controller: controller.serverController,
                            focus: controller.serverFocus,
                            isSecure: false,
                            focusBorderColor: AppColors().blueColor,
                            onDoneClick: () {
                              controller.callForSignIn(context);
                            },
                            keyboardButtonType: TextInputAction.next,
                            maxLength: 64,
                            isLogin: true,
                            suffixIcon: SizedBox(
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
                          SizedBox(
                            height: 2.h,
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          CustomTextField(
                            type: 'UserName',
                            keyBoardType: TextInputType.text,
                            isEnabled: true,
                            isOptional: false,
                            isNoNeededCapital: true,
                            focusBorderColor: AppColors().blueColor,
                            inValidMsg: AppString.emptyUserName,
                            placeHolderMsg: "Enter your user name",
                            labelMsg: "User Name",
                            emptyFieldMsg: AppString.emptyUserName,
                            controller: controller.userNameController,
                            focus: controller.userNameFocus,
                            isSecure: false,
                            keyboardButtonType: TextInputAction.next,
                            maxLength: 64,
                            isLogin: true,
                            onDoneClick: () {
                              controller.callForSignIn(context);
                            },
                            suffixIcon: SizedBox(
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
                                    AppImages.userIcon,
                                    width: 22,
                                    height: 22,
                                    color: AppColors().iconsColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          CustomTextField(
                            type: 'Password',
                            keyBoardType: TextInputType.text,
                            isEnabled: true,
                            isOptional: false,
                            focusBorderColor: AppColors().blueColor,
                            inValidMsg: AppString.emptyPassword,
                            placeHolderMsg: "Enter your password",
                            labelMsg: "Password",
                            emptyFieldMsg: AppString.emptyPassword,
                            controller: controller.passwordController,
                            focus: controller.passwordFocus,
                            isSecure: controller.isEyeOpen,
                            maxLength: 20,
                            isLogin: true,
                            keyboardButtonType: TextInputAction.done,
                            onDoneClick: () {
                              controller.callForSignIn(context);
                            },
                            suffixIcon: GestureDetector(
                              onTap: () {
                                controller.isEyeOpen = !controller.isEyeOpen;
                                controller.update();
                              },
                              child: SizedBox(
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
                                      controller.isEyeOpen ? AppImages.eyeCloseIcon : AppImages.eyeOpenIcon,
                                      width: 22,
                                      height: 22,
                                      color: AppColors().iconsColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Obx(() {
                            return CustomButton(
                              isEnabled: true,
                              shimmerColor: AppColors().whiteColor,
                              title: "Log In",
                              textSize: 16,
                              // fontFamily: CustomFonts.family1Medium,
                              onPress: () async {
                                controller.callForSignIn(context);
                              },
                              buttonHeight: 10.5.h,
                              bgColor: AppColors().blueColor,
                              isFilled: true,
                              textColor: AppColors().whiteColor,
                              isTextCenter: true,
                              isLoading: controller.isLoadingSignIn.value,
                            );
                          }),
                          SizedBox(
                            height: 2.h,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                  ],
                ),
              ),
            )));
  }
}
