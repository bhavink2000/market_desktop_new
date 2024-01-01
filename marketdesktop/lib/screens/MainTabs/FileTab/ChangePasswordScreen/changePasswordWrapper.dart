import 'package:get/get.dart';
import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/customWidgets/appTextField.dart';
import 'package:marketdesktop/screens/MainTabs/FileTab/ChangePasswordScreen/changePasswordController.dart';
import '../../../../constant/index.dart';

class ChangePasswordScreen extends BaseView<ChangePasswordController> {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    //print(MediaQuery.of(context).size.width);
    //print(MediaQuery.of(context).size.height);
    return Scaffold(
        backgroundColor: AppColors().slideGrayBG,
        body: SafeArea(
            child: Column(
          children: [
            headerViewContent(title: "Change Password", isFilterAvailable: false, isFromMarket: false),

            // if (controller.selectedUserID == "")
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              child: Row(
                children: [
                  Spacer(),
                  Text("Current Password :",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: CustomFonts.family1Regular,
                        color: AppColors().fontColor,
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 200,
                    height: 40,
                    child: CustomTextField(
                      type: 'password',
                      keyBoardType: TextInputType.text,
                      isEnabled: true,
                      isOptional: false,
                      isNoNeededCapital: true,
                      inValidMsg: AppString.emptyUserName,
                      placeHolderMsg: "Enter your current password",
                      labelMsg: "",
                      emptyFieldMsg: AppString.emptyUserName,
                      controller: controller.currentPasswordController,
                      focus: controller.currentPasswordFocus,
                      isSecure: true,
                      keyboardButtonType: TextInputAction.next,
                      maxLength: 20,
                      isShowPrefix: false,
                      isShowSufix: false,
                      suffixIcon: null,
                      prefixIcon: null,
                      borderColor: AppColors().lightText,
                      roundCorner: 0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              child: Row(
                children: [
                  Spacer(),
                  Text("New Password :",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: CustomFonts.family1Regular,
                        color: AppColors().fontColor,
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 200,
                    height: 40,
                    child: CustomTextField(
                      type: 'New Password :',
                      keyBoardType: TextInputType.text,
                      isEnabled: true,
                      isOptional: false,
                      isNoNeededCapital: true,
                      inValidMsg: AppString.emptyUserName,
                      placeHolderMsg: "Enter your new password",
                      labelMsg: "",
                      emptyFieldMsg: AppString.emptyUserName,
                      controller: controller.passwordController,
                      focus: controller.passwordFocus,
                      isSecure: true,
                      keyboardButtonType: TextInputAction.next,
                      maxLength: 20,
                      isShowPrefix: false,
                      isShowSufix: false,
                      suffixIcon: null,
                      prefixIcon: null,
                      borderColor: AppColors().lightText,
                      roundCorner: 0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              child: Row(
                children: [
                  Spacer(),
                  Text("Confirm Password :",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: CustomFonts.family1Regular,
                        color: AppColors().fontColor,
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: 200,
                    height: 40,
                    child: CustomTextField(
                      type: 'Confirm',
                      keyBoardType: TextInputType.text,
                      isEnabled: true,
                      isOptional: false,
                      isNoNeededCapital: true,
                      inValidMsg: AppString.emptyUserName,
                      placeHolderMsg: "Confirm your password",
                      labelMsg: "",
                      emptyFieldMsg: AppString.emptyUserName,
                      controller: controller.confirmController,
                      focus: controller.confirmFocus,
                      isSecure: true,
                      keyboardButtonType: TextInputAction.next,
                      maxLength: 20,
                      isShowPrefix: false,
                      isShowSufix: false,
                      suffixIcon: null,
                      prefixIcon: null,
                      borderColor: AppColors().lightText,
                      roundCorner: 0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 120,
              height: 40,
              child: CustomButton(
                isEnabled: true,
                shimmerColor: AppColors().whiteColor,
                title: "Save",
                textSize: 14,
                onPress: () {
                  controller.callForChangePassword();
                },
                bgColor: AppColors().blueColor,
                isFilled: true,
                textColor: AppColors().whiteColor,
                isTextCenter: true,
                isLoading: controller.isApiCallRunning,
              ),
            ),
          ],
        )));
  }
}
