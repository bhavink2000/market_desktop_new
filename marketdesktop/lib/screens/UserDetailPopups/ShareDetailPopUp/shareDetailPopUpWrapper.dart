import 'package:get/get.dart';

import 'package:marketdesktop/constant/index.dart';
import 'package:marketdesktop/customWidgets/appTextField.dart';

import 'package:marketdesktop/screens/UserDetailPopups/ShareDetailPopUp/shareDetailPopUpController.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../userDetailsPopUpController.dart';

class ShareDetailPopUpScreen extends BaseView<ShareDetailPopUpController> {
  const ShareDetailPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Visibility(
        visible: Get.find<UserDetailsPopUpController>().selectedMenuName == "Share Details",
        child: GestureDetector(
          onTap: () {
            // controller.focusNode.requestFocus();
          },
          child: Row(
            children: [
              if (controller.selectedUserData != null)
                Expanded(
                  flex: 8,
                  child: BouncingScrollWrapper.builder(context, mainContent(context), dragWithMouse: true),
                  // child: BouncingScrollWrapper.builder(context, mainContent(context), dragWithMouse: true),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
              child: Column(
                children: [
                  Container(
                    height: 3.h,
                    decoration: BoxDecoration(
                        color: AppColors().whiteColor,
                        border: Border(bottom: BorderSide(color: AppColors().lightOnlyText, width: 1))),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Text("P & L Sharing",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: CustomFonts.family1Medium,
                              color: AppColors().darkText,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: Text(
                                "Admin",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors().darkText,
                                  fontFamily: CustomFonts.family1Regular,
                                ),
                              ),
                            ),
                            Container(
                              width: 13.w,
                              height: 4.3.h,
                              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              child: CustomTextField(
                                type: 'Admin',
                                regex: '[0-9]',
                                roundCorner: 0,
                                borderColor: AppColors().lightOnlyText,
                                // fillColor: AppColors().headerBgColor,
                                keyBoardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
                                isEnabled: false,
                                isOptional: false,

                                inValidMsg: AppString.emptyPassword,
                                placeHolderMsg: "Admin",
                                prefixIcon: const SizedBox(),
                                suffixIcon: const SizedBox(),
                                emptyFieldMsg: AppString.emptyPassword,
                                controller: controller.plAdminController,
                                focus: controller.plAdminFocus,
                                isSecure: false,
                                maxLength: 6,
                                keyboardButtonType: TextInputAction.done,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: Text(
                                "Master (${controller.selectedUserData!.userName})",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors().darkText,
                                  fontFamily: CustomFonts.family1Regular,
                                ),
                              ),
                            ),
                            Container(
                              width: 13.w,
                              height: 4.3.h,
                              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              child: CustomTextField(
                                type: 'master',
                                regex: '[0-9]',
                                roundCorner: 0,
                                borderColor: AppColors().lightOnlyText,
                                // fillColor: AppColors().headerBgColor,
                                keyBoardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
                                isEnabled: false,
                                isOptional: false,
                                inValidMsg: AppString.emptyPassword,
                                placeHolderMsg: "Master",
                                prefixIcon: const SizedBox(),
                                suffixIcon: const SizedBox(),
                                emptyFieldMsg: AppString.emptyPassword,
                                controller: controller.plMasterController,
                                focus: controller.plMasterFocus,
                                isSecure: false,
                                maxLength: 6,
                                keyboardButtonType: TextInputAction.done,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 1.w,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
              child: Column(
                children: [
                  Container(
                    height: 3.h,
                    decoration: BoxDecoration(
                        color: AppColors().whiteColor,
                        border: Border(bottom: BorderSide(color: AppColors().lightOnlyText, width: 1))),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Text("Brk Sharing",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: CustomFonts.family1Medium,
                              color: AppColors().darkText,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: Text(
                                "Admin",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors().darkText,
                                  fontFamily: CustomFonts.family1Regular,
                                ),
                              ),
                            ),
                            Container(
                              width: 13.w,
                              height: 4.3.h,
                              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              child: CustomTextField(
                                type: 'Admin',
                                regex: '[0-9]',
                                roundCorner: 0,
                                borderColor: AppColors().lightOnlyText,
                                // fillColor: AppColors().headerBgColor,
                                keyBoardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
                                isEnabled: false,
                                isOptional: false,
                                inValidMsg: AppString.emptyPassword,
                                placeHolderMsg: "Admin",
                                prefixIcon: const SizedBox(),
                                suffixIcon: const SizedBox(),
                                emptyFieldMsg: AppString.emptyPassword,
                                controller: controller.brkAdminController,
                                focus: controller.brkMasterFocus,
                                isSecure: false,
                                maxLength: 6,
                                keyboardButtonType: TextInputAction.done,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                              ),
                              child: Text(
                                "Master (${controller.selectedUserData!.userName})",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors().darkText,
                                  fontFamily: CustomFonts.family1Regular,
                                ),
                              ),
                            ),
                            Container(
                              width: 13.w,
                              height: 4.3.h,
                              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              child: CustomTextField(
                                type: 'master',
                                regex: '[0-9]',
                                roundCorner: 0,
                                borderColor: AppColors().lightOnlyText,
                                // fillColor: AppColors().headerBgColor,
                                keyBoardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
                                isEnabled: false,

                                isOptional: false,
                                inValidMsg: AppString.emptyPassword,
                                placeHolderMsg: "Master",
                                prefixIcon: const SizedBox(),
                                suffixIcon: const SizedBox(),
                                emptyFieldMsg: AppString.emptyPassword,
                                controller: controller.brkMasterController,
                                focus: controller.brkMasterFocus,
                                isSecure: false,
                                maxLength: 6,
                                keyboardButtonType: TextInputAction.done,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
