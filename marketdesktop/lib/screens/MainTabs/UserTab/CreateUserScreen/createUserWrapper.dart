import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/groupListModelClass.dart';
import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/customWidgets/appTextField.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/brokerListModelClass.dart';
import 'package:marketdesktop/modelClass/constantModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeAllowModelClass.dart';
import 'package:marketdesktop/screens/MainContainerScreen/mainContainerController.dart';
import 'package:marketdesktop/screens/MainTabs/UserTab/CreateUserScreen/createUserController.dart';
import 'package:multiselect/multiselect.dart';
import '../../../../constant/index.dart';

class CreateUserScreen extends BaseView<CreateUserController> {
  const CreateUserScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return Future.value(false);
        },
        child: Container(
          width: 50.w,
          color: AppColors().slideGrayBG,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 32,
                color: AppColors().blueColor,
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text("Create User", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1SemiBold, color: AppColors().whiteColor)),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Get.find<MainContainerController>().isCreateUserClick = false;
                        Get.find<MainContainerController>().update();
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          AppImages.closeIcon,
                          width: 10,
                          height: 10,
                          color: AppColors().whiteColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text("Select user Type", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            userTypeDropDown(controller.selectedUserType, width: 23.7.w, height: 4.h, onChange: () {
                              controller.nameController.text = "";
                              controller.userNameController.text = "";
                              controller.passwordController.text = "";
                              controller.retypePasswordController.text = "";
                              controller.mobileNumberController.text = "";
                              controller.cutoffController.text = "";
                              controller.creditController.text = "";
                              controller.remarkController.text = "";
                              controller.selectedLeverage.value = arrLeverageList.first;
                              controller.profitandLossController.text = "";
                              controller.brokerageSharingController.text = "";
                              controller.brkSharingMasterController.text = "";
                              controller.isAutoSquareOff = false;
                              controller.isModifyOrder = false;
                              controller.isCloseOnly = false;
                              controller.isIntraday = false;
                              controller.isChangePasswordOnFirstLogin = false;
                              controller.isSelectedallExchangeinMaster.value = false;
                              controller.selectedBrokerType = BrokerListModelData().obs;
                              for (var i = 0; i < controller.arrExchange.length; i++) {
                                if (controller.arrExchange[i].isSelected == true) {
                                  controller.arrExchange[i].isSelected = false;
                                }
                                if (controller.arrExchange[i].isTurnOverSelected == true) {
                                  controller.arrExchange[i].isTurnOverSelected = false;
                                }
                                if (controller.arrExchange[i].isSymbolSelected == true) {
                                  controller.arrExchange[i].isSymbolSelected = false;
                                }
                                if (controller.arrExchange[i].isHighLowTradeSelected == true) {
                                  controller.arrExchange[i].isHighLowTradeSelected = false;
                                }
                                if (controller.arrExchange[i].isDropDownValueSelected.value.groupId != null) {
                                  controller.arrExchange[i].isDropDownValueSelected.value.groupId = null;
                                }
                                if (controller.arrExchange[i].selectedItems.isNotEmpty) {
                                  controller.arrExchange[i].selectedItems.clear();
                                }
                                controller.arrExchange[i].selectedItemsID.clear();
                                controller.arrExchange[i].isDropDownValueSelectedID.value = "";
                                if (controller.selectedUserType.value.roleId == UserRollList.user) {
                                  controller.arrExchange[i].arrGroupList.insert(0, groupListModelData(name: "Select Group"));

                                  controller.arrExchange[i].isDropDownValueSelected = controller.arrExchange[i].arrGroupList.first.obs;
                                }
                                if (controller.selectedUserType.value.roleId != UserRollList.user) {
                                  controller.arrExchange[i].arrGroupList.removeWhere((element) => element.name == "Select Group");
                                }
                              }
                              controller.arrSelectedGroupListIDforOthers.clear();
                              controller.arrSelectedGroupListIDforNSE.clear();
                              controller.arrSelectedGroupListIDforMCX.clear();
                              controller.arrSelectedDropDownValueClient.clear();
                              controller.arrSelectedExchangeList.clear();
                              controller.arrHighLowBetweenTradeSelectedList.clear();
                              controller.isCmpOrder = null;
                              controller.isAdminManualOrder = null;
                              controller.isDeleteTrade = null;
                              controller.isExecutePendingOrder = null;
                              controller.update();
                            }),
                            if (controller.selectedUserType.value.roleId == UserRollList.master) masterAddOrderCheckboxView(),
                          ],
                        ),
                        SizedBox(
                          height: 1.h,
                        ),

                        SizedBox(
                          height: 1.h,
                        ),
                        if (controller.selectedUserType.value.roleId == UserRollList.admin) adminTopView(),
                        if (controller.selectedUserType.value.roleId == UserRollList.admin)
                          SizedBox(
                            height: 3.h,
                          ),
                        Container(
                          child: Text("User Details", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text("Name*", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: 23.7.w,
                                      height: 4.h,
                                      child: CustomTextField(
                                        regex: "[a-zA-Z ]",
                                        type: '',
                                        focusBorderColor: AppColors().blueColor,
                                        keyBoardType: TextInputType.text,
                                        isEnabled: true,
                                        isOptional: false,
                                        isNoNeededCapital: true,
                                        inValidMsg: AppString.emptyName,
                                        placeHolderMsg: "Enter Name",
                                        labelMsg: "",
                                        emptyFieldMsg: AppString.emptyName,
                                        controller: controller.nameController,
                                        focus: controller.nameFocus,
                                        isSecure: false,
                                        keyboardButtonType: TextInputAction.next,
                                        maxLength: 20,
                                        isShowPrefix: false,
                                        isShowSufix: false,
                                        suffixIcon: null,
                                        prefixIcon: null,
                                        borderColor: AppColors().lightText,
                                        roundCorner: 0,
                                        onDoneClick: () {
                                          controller.userNameFocus.requestFocus();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text("UserName*", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: 23.7.w,
                                      height: 4.h,
                                      child: CustomTextField(
                                        regex: "[a-zA-Z,#@!0-9]",
                                        type: '',
                                        focusBorderColor: AppColors().blueColor,
                                        keyBoardType: TextInputType.text,
                                        isEnabled: true,
                                        isOptional: false,
                                        isNoNeededCapital: true,
                                        inValidMsg: AppString.emptyUserName,
                                        placeHolderMsg: "Enter UserName",
                                        labelMsg: "",
                                        emptyFieldMsg: AppString.emptyUserName,
                                        controller: controller.userNameController,
                                        focus: controller.userNameFocus,
                                        isSecure: false,
                                        keyboardButtonType: TextInputAction.next,
                                        maxLength: 20,
                                        isShowPrefix: false,
                                        isShowSufix: false,
                                        suffixIcon: null,
                                        prefixIcon: null,
                                        borderColor: AppColors().lightText,
                                        roundCorner: 0,
                                        onDoneClick: () {
                                          controller.passwordFocus.requestFocus();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text("Password*", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: 23.7.w,
                                      height: 4.h,
                                      // color: AppColors().darkText,
                                      child: CustomTextField(
                                        type: '',
                                        keyBoardType: TextInputType.text,
                                        isEnabled: true,
                                        isOptional: false,
                                        focusBorderColor: AppColors().blueColor,
                                        isNoNeededCapital: true,
                                        inValidMsg: AppString.emptyPassword,
                                        placeHolderMsg: "Enter Password",
                                        labelMsg: "",
                                        emptyFieldMsg: AppString.emptyPassword,
                                        controller: controller.passwordController,
                                        focus: controller.passwordFocus,
                                        isSecure: controller.isEyeOpenPassword,
                                        keyboardButtonType: TextInputAction.next,
                                        maxLength: 20,
                                        isShowPrefix: false,
                                        isShowSufix: true,
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            controller.isEyeOpenPassword = !controller.isEyeOpenPassword;
                                            controller.update();
                                          },
                                          child: Image.asset(
                                            controller.isEyeOpenPassword ? AppImages.eyeCloseIcon : AppImages.eyeOpenIcon,
                                            width: 22,
                                            height: 22,
                                          ),
                                        ),
                                        maxLine: 1,
                                        minLine: 1,
                                        // fillColor: AppColors().redColor,
                                        isMaxlineMore: false,
                                        prefixIcon: null,
                                        borderColor: AppColors().lightText,
                                        roundCorner: 0,
                                        onDoneClick: () {
                                          controller.retypePasswordFocus.requestFocus();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              if (controller.selectedUserType.value.roleId != UserRollList.broker)
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text("Retype Password*", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: 23.7.w,
                                        height: 4.h,
                                        child: CustomTextField(
                                          type: '',
                                          focusBorderColor: AppColors().blueColor,
                                          keyBoardType: TextInputType.text,
                                          isEnabled: true,
                                          isOptional: false,
                                          isNoNeededCapital: true,
                                          inValidMsg: AppString.emptyConfirmPassword,
                                          placeHolderMsg: "Retype Password",
                                          labelMsg: "",
                                          emptyFieldMsg: AppString.emptyConfirmPassword,
                                          controller: controller.retypePasswordController,
                                          focus: controller.retypePasswordFocus,
                                          isSecure: controller.isEyeOpenRetypePassword,
                                          keyboardButtonType: TextInputAction.next,
                                          maxLength: 20,
                                          isShowPrefix: false,
                                          isShowSufix: true,
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              controller.isEyeOpenRetypePassword = !controller.isEyeOpenRetypePassword;
                                              controller.update();
                                            },
                                            child: Image.asset(
                                              controller.isEyeOpenRetypePassword ? AppImages.eyeCloseIcon : AppImages.eyeOpenIcon,
                                              width: 22,
                                              height: 22,
                                            ),
                                          ),
                                          prefixIcon: null,
                                          borderColor: AppColors().lightText,
                                          roundCorner: 0,
                                          onDoneClick: () {
                                            controller.mobileNumberFocus.requestFocus();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              // if (controller.selectedUserType.value.roleId ==
                              //     UserRollList.admin)
                              //   Container(
                              //     child: Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         Container(
                              //           child: Text("Retype Password*",
                              //               style: TextStyle(
                              //                   fontSize: 12,
                              //                   fontFamily:
                              //                       CustomFonts.family1Regular,
                              //                   color: AppColors().darkText)),
                              //         ),
                              //         SizedBox(
                              //           height: 10,
                              //         ),
                              //         Container(
                              //           width: 13.3.w,
                              //           height: 4.h,
                              //           child: CustomTextField(
                              //             type: '',
                              //             keyBoardType: TextInputType.text,
                              //             isEnabled: true,
                              //             isOptional: false,
                              //             isNoNeededCapital: true,
                              //             inValidMsg:
                              //                 AppString.emptyConfirmPassword,
                              //             placeHolderMsg: "Retype Password",
                              //             labelMsg: "",
                              //             emptyFieldMsg:
                              //                 AppString.emptyConfirmPassword,
                              //             controller:
                              //                 controller.retypePasswordController,
                              //             focus: controller.retypePasswordFocus,
                              //             isSecure: false,
                              //             keyboardButtonType:
                              //                 TextInputAction.next,
                              //             maxLength: 20,
                              //             isShowPrefix: false,
                              //             isShowSufix: false,
                              //             suffixIcon: null,
                              //             prefixIcon: null,
                              //             borderColor: AppColors().lightText,
                              //             roundCorner: 0,
                              //             onDoneClick: () {
                              //               controller.mobileNumberFocus
                              //                   .requestFocus();
                              //             },
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              if (controller.selectedUserType.value.roleId != UserRollList.broker)
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text("Mobile Number", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: 23.7.w,
                                        height: 4.h,
                                        child: CustomTextField(
                                          regex: "[0-9]",
                                          type: '',
                                          focusBorderColor: AppColors().blueColor,
                                          keyBoardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
                                          isEnabled: true,
                                          isOptional: false,
                                          isNoNeededCapital: true,
                                          inValidMsg: AppString.emptyMobileNumber,
                                          placeHolderMsg: "Mobile Number",
                                          labelMsg: "",
                                          emptyFieldMsg: AppString.emptyMobileNumber,
                                          controller: controller.mobileNumberController,
                                          focus: controller.mobileNumberFocus,
                                          isSecure: false,
                                          keyboardButtonType: TextInputAction.next,
                                          maxLength: 10,
                                          isShowPrefix: false,
                                          isShowSufix: false,
                                          suffixIcon: null,
                                          prefixIcon: null,
                                          borderColor: AppColors().lightText,
                                          roundCorner: 0,
                                          onDoneClick: () {
                                            if (controller.selectedUserType.value.roleId == UserRollList.master) {
                                              controller.creditFocus.requestFocus();
                                            }
                                            controller.cutoffFocus.requestFocus();
                                          },
                                        ),
                                      ),
                                      if (controller.selectedUserType.value.roleId != UserRollList.broker && controller.selectedUserType.value.roleId == UserRollList.master)
                                        Container(
                                          width: 23.w,
                                          // color: Colors.red,
                                          child: Text(controller.creditController.text.isNotEmpty ? controller.numericToWord() : "", maxLines: 5, style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: Colors.transparent)),
                                        ),
                                    ],
                                  ),
                                ),
                              // if (controller.selectedUserType.value.roleId ==
                              //     UserRollList.admin)
                              //   Container(
                              //     child: Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         Container(
                              //           child: Text("Mobile Number",
                              //               style: TextStyle(
                              //                   fontSize: 12,
                              //                   fontFamily:
                              //                       CustomFonts.family1Regular,
                              //                   color: AppColors().darkText)),
                              //         ),
                              //         SizedBox(
                              //           height: 10,
                              //         ),
                              //         Container(
                              //           width: 13.3.w,
                              //           height: 4.h,
                              //           child: CustomTextField(
                              //             regex: "[0-9]",
                              //             type: '',
                              //             keyBoardType: TextInputType.text,
                              //             isEnabled: true,
                              //             isOptional: false,
                              //             isNoNeededCapital: true,
                              //             inValidMsg: AppString.emptyMobileNumber,
                              //             placeHolderMsg: "Mobile Number",
                              //             labelMsg: "",
                              //             emptyFieldMsg:
                              //                 AppString.emptyMobileNumber,
                              //             controller:
                              //                 controller.mobileNumberController,
                              //             focus: controller.mobileNumberFocus,
                              //             isSecure: false,
                              //             keyboardButtonType:
                              //                 TextInputAction.next,
                              //             maxLength: 10,
                              //             isShowPrefix: false,
                              //             isShowSufix: false,
                              //             suffixIcon: null,
                              //             prefixIcon: null,
                              //             borderColor: AppColors().lightText,
                              //             roundCorner: 0,
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              Spacer(),
                              if (controller.selectedUserType.value.roleId == UserRollList.user)
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text("Cut Off(%)", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: 23.7.w,
                                        height: 4.h,
                                        child: CustomTextField(
                                          regex: "[0-9]",
                                          type: '',
                                          focusBorderColor: AppColors().blueColor,
                                          keyBoardType: TextInputType.text,
                                          isEnabled: true,
                                          isOptional: false,
                                          isNoNeededCapital: true,
                                          inValidMsg: AppString.emptyCutOff,
                                          placeHolderMsg: "Cut off(%)",
                                          labelMsg: "",
                                          onChange: () {
                                            if (controller.cutoffController.text.isNotEmpty) {
                                              controller.isCutOffHasValue.value = true;
                                              controller.isAutoSquareOff = true;
                                              controller.update();
                                            } else {
                                              controller.isCutOffHasValue.value = false;
                                              controller.isAutoSquareOff = false;
                                              controller.update();
                                            }
                                          },
                                          emptyFieldMsg: AppString.emptyCutOff,
                                          controller: controller.cutoffController,
                                          focus: controller.cutoffFocus,
                                          isSecure: false,
                                          keyboardButtonType: TextInputAction.next,
                                          maxLength: 3,
                                          isShowPrefix: false,
                                          isShowSufix: false,
                                          suffixIcon: null,
                                          prefixIcon: null,
                                          borderColor: AppColors().lightText,
                                          roundCorner: 0,
                                          onDoneClick: () {
                                            controller.creditFocus.requestFocus();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (controller.selectedUserType.value.roleId == UserRollList.master)
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text("Credit*", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: 23.7.w,
                                        height: 4.h,
                                        child: CustomTextField(
                                          regex: "[0-9]",
                                          type: '',
                                          focusBorderColor: AppColors().blueColor,
                                          keyBoardType: TextInputType.text,
                                          isEnabled: true,
                                          isOptional: false,
                                          isNoNeededCapital: true,
                                          inValidMsg: AppString.emptyCredit,
                                          placeHolderMsg: "Credit",
                                          labelMsg: "",
                                          emptyFieldMsg: AppString.emptyCredit,
                                          controller: controller.creditController,
                                          focus: controller.creditFocus,
                                          isSecure: false,
                                          keyboardButtonType: TextInputAction.next,
                                          maxLength: 9,
                                          isShowPrefix: false,
                                          isShowSufix: false,
                                          suffixIcon: null,
                                          prefixIcon: null,
                                          borderColor: AppColors().lightText,
                                          roundCorner: 0,
                                          onDoneClick: () {
                                            controller.remarkFocus.requestFocus();
                                          },
                                          onChange: () {
                                            controller.update();
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: 23.w,
                                        // color: Colors.red,
                                        child: Text(controller.creditController.text.isNotEmpty ? controller.numericToWord() : "", maxLines: 5, style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              if (controller.selectedUserType.value.roleId == UserRollList.user)
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text("Credit*", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: 23.7.w,
                                        height: 4.h,
                                        child: CustomTextField(
                                          regex: "[0-9]",
                                          type: '',
                                          focusBorderColor: AppColors().blueColor,
                                          keyBoardType: TextInputType.text,
                                          isEnabled: true,
                                          isOptional: false,
                                          isNoNeededCapital: true,
                                          inValidMsg: AppString.emptyCredit,
                                          placeHolderMsg: "Credit",
                                          labelMsg: "",
                                          emptyFieldMsg: AppString.emptyCredit,
                                          controller: controller.creditController,
                                          focus: controller.creditFocus,
                                          isSecure: false,
                                          keyboardButtonType: TextInputAction.next,
                                          maxLength: 9,
                                          isShowPrefix: false,
                                          isShowSufix: false,
                                          suffixIcon: null,
                                          prefixIcon: null,
                                          borderColor: AppColors().lightText,
                                          roundCorner: 0,
                                          onChange: () {
                                            controller.update();
                                          },
                                          onDoneClick: () {
                                            controller.remarkFocus.requestFocus();
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: 23.w,
                                        // color: Colors.red,
                                        child: Text(controller.creditController.text.isNotEmpty ? controller.numericToWord() : "", maxLines: 5, style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                                      ),
                                    ],
                                  ),
                                ),
                              if (controller.selectedUserType.value.roleId == UserRollList.master)
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text("Remark", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: 23.7.w,
                                        height: 4.h,
                                        child: CustomTextField(
                                          type: '',
                                          focusBorderColor: AppColors().blueColor,
                                          keyBoardType: TextInputType.text,
                                          isEnabled: true,
                                          isOptional: false,
                                          isNoNeededCapital: true,
                                          inValidMsg: AppString.emptyRemark,
                                          placeHolderMsg: "Remark",
                                          labelMsg: "",
                                          emptyFieldMsg: AppString.emptyRemark,
                                          controller: controller.remarkController,
                                          focus: controller.remarkFocus,
                                          isSecure: false,
                                          keyboardButtonType: TextInputAction.next,
                                          maxLength: 100,
                                          isShowPrefix: false,
                                          isShowSufix: false,
                                          suffixIcon: null,
                                          prefixIcon: null,
                                          borderColor: AppColors().lightText,
                                          roundCorner: 0,
                                          onDoneClick: () {
                                            controller.dropdownLeveargeKey!.currentContext?.visitChildElements((element) {
                                              if (element.widget is Semantics) {
                                                element.visitChildElements((element) {
                                                  if (element.widget is Actions) {
                                                    element.visitChildElements((element) {
                                                      Actions.invoke(element, ActivateIntent());
                                                    });
                                                  }
                                                });
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Spacer(),
                              if (controller.selectedUserType.value.roleId == UserRollList.user)
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text("Remark", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: 23.7.w,
                                        height: 4.h,
                                        child: CustomTextField(
                                          type: '',
                                          focusBorderColor: AppColors().blueColor,
                                          keyBoardType: TextInputType.text,
                                          isEnabled: true,
                                          isOptional: false,
                                          isNoNeededCapital: true,
                                          inValidMsg: AppString.emptyRemark,
                                          placeHolderMsg: "Remark",
                                          labelMsg: "",
                                          emptyFieldMsg: AppString.emptyRemark,
                                          controller: controller.remarkController,
                                          focus: controller.remarkFocus,
                                          isSecure: false,
                                          keyboardButtonType: TextInputAction.next,
                                          maxLength: 100,
                                          isShowPrefix: false,
                                          isShowSufix: false,
                                          suffixIcon: null,
                                          prefixIcon: null,
                                          borderColor: AppColors().lightText,
                                          roundCorner: 0,
                                        ),
                                      ),
                                      Container(
                                        width: 23.w,
                                        // color: Colors.red,
                                        child: Text(controller.creditController.text.isNotEmpty ? controller.numericToWord() : "", maxLines: 5, style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: Colors.transparent)),
                                      ),
                                    ],
                                  ),
                                ),
                              if (controller.selectedUserType.value.roleId == UserRollList.master)
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Text("Leverage", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      leverageDropDown(controller.selectedLeverage, width: 23.7.w, height: 4.h, focus: controller.leverageFocus),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (controller.selectedUserType.value.roleId == UserRollList.user)
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("Leverage", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                leverageDropDown(controller.selectedLeverage, width: 23.7.w, focus: controller.leverageFocus, height: 4.h),
                              ],
                            ),
                          ),
                        if (controller.selectedUserType.value.roleId != UserRollList.broker && controller.selectedUserType.value.roleId != UserRollList.admin)
                          Container(
                            margin: EdgeInsets.only(top: 3.h),
                            child: Text("Exchange", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
                          ),
                        if (controller.selectedUserType.value.roleId != UserRollList.broker)
                          SizedBox(
                            height: 10,
                          ),
                        if (controller.selectedUserType.value.roleId == UserRollList.user) exchangeFunctionClient(),
                        if (controller.selectedUserType.value.roleId == UserRollList.master) exchangeFunctionMaster(),
                        if (controller.selectedUserType.value.roleId == UserRollList.master)
                          SizedBox(
                            height: 30,
                          ),
                        if (controller.selectedUserType.value.roleId == UserRollList.master) masterPartnershipDetailsView(),
                        if (controller.selectedUserType.value.roleId == UserRollList.master)
                          SizedBox(
                            height: 0,
                          ),
                        if (controller.selectedUserType.value.roleId == UserRollList.user)
                          SizedBox(
                            height: 30,
                          ),
                        if (controller.selectedUserType.value.roleId != UserRollList.broker && controller.selectedUserType.value.roleId != UserRollList.admin)
                          Container(
                            child: Text("High Low Between Limit", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
                          ),
                        if (controller.selectedUserType.value.roleId != UserRollList.broker && controller.selectedUserType.value.roleId != UserRollList.admin)
                          SizedBox(
                            height: 5,
                          ),
                        if (controller.selectedUserType.value.roleId != UserRollList.broker && controller.selectedUserType.value.roleId != UserRollList.admin)
                          Container(
                            // height: 3.h,
                            // width: 30.w,
                            child: GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6, childAspectRatio: 3.5),
                                physics: const AlwaysScrollableScrollPhysics(),
                                clipBehavior: Clip.hardEdge,
                                itemCount: controller.arrExchange.length,
                                controller: controller.listcontroller,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return highLowBetWeenTradeView(context, index);
                                }),
                          ),
                        if (controller.selectedUserType.value.roleId == UserRollList.user)
                          SizedBox(
                            height: 2.h,
                          ),
                        if (controller.selectedUserType.value.roleId == UserRollList.user) ordersCheckboxesView(),
                        if (controller.selectedUserType.value.roleId == UserRollList.user)
                          SizedBox(
                            height: 1.5.h,
                          ),
                        // if (controller.selectedUserType.value.roleId == UserRollList.user) brokerDropDownViewUser(),
                        if (controller.selectedUserType.value.roleId == UserRollList.master)
                          SizedBox(
                            height: 2.h,
                          ),
                        if (controller.selectedUserType.value.roleId == UserRollList.master) masterMarketOrderCheckboxView(),
                        if (controller.selectedUserType.value.roleId != UserRollList.admin) SymbolWiseSLCheckboxView(),
                        if (controller.selectedUserType.value.roleId == UserRollList.user) FreshLimitSLCheckboxView(),
                        if (controller.selectedUserType.value.roleId != UserRollList.broker && controller.selectedUserType.value.roleId != UserRollList.admin)
                          SizedBox(
                            height: 2.h,
                          ),
                        if (controller.selectedUserType.value.roleId != UserRollList.admin)
                          GestureDetector(
                            onTap: () {
                              controller.isChangePasswordOnFirstLogin = !controller.isChangePasswordOnFirstLogin;
                              controller.update();
                            },
                            child: Container(
                              child: Row(
                                children: [
                                  Container(
                                    child: Checkbox(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        activeColor: AppColors().blueColor,
                                        focusNode: controller.ChangePasswordOnFirstLoginFocus,
                                        value: controller.isChangePasswordOnFirstLogin,
                                        onChanged: (value) {
                                          controller.isChangePasswordOnFirstLogin = value!;
                                          controller.update();
                                        }),
                                    // child: Image.asset(
                                    //   controller.isChangePasswordOnFirstLogin
                                    //       ? AppImages.checkBoxSelected
                                    //       : AppImages.checkBox,
                                    //   height: 20,
                                    //   width: 20,
                                    // ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    child: Text("Change Password on First Login", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 1.5.h,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  // width: 10.w,
                                  height: 3.h,
                                  child: CustomButton(
                                    isEnabled: true,
                                    shimmerColor: AppColors().whiteColor,
                                    title: controller.selectedUserForEdit == null ? "Save" : "Update",
                                    focusKey: controller.saveFocus,
                                    borderColor: Colors.transparent,
                                    focusShadowColor: AppColors().blueColor,
                                    textSize: 12,
                                    onPress: () {
                                      controller.onSavePressed();
                                    },
                                    bgColor: AppColors().blueColor,
                                    isFilled: true,
                                    textColor: AppColors().whiteColor,
                                    isTextCenter: true,
                                    isLoading: controller.isLoadingSave.value,
                                    noNeedBorderRadius: true,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                  // width: 10.w,
                                  height: 3.h,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors().blueColor, width: 1),
                                  ),
                                  child: CustomButton(
                                    isEnabled: true,
                                    shimmerColor: AppColors().whiteColor,
                                    title: "Cancel",
                                    focusKey: controller.cancelFocus,
                                    borderColor: Colors.transparent,
                                    focusShadowColor: AppColors().blueColor,
                                    textSize: 12,
                                    onPress: () {
                                      controller.update();
                                    },
                                    bgColor: AppColors().whiteColor,
                                    isFilled: true,
                                    textColor: AppColors().blueColor,
                                    isTextCenter: true,
                                    isLoading: false,
                                    noNeedBorderRadius: true,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget adminTopView() {
    return Container(
      child: Row(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("CMP Order", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (controller.isCmpOrder == true) {
                          controller.isCmpOrder = null;
                        } else {
                          controller.isCmpOrder = true;
                        }
                        controller.update();
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              child: Image.asset(
                                controller.isCmpOrder == true ? AppImages.checkBoxSelectedRound : AppImages.checkBoxRound,
                                height: 20,
                                width: 20,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Yes", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (controller.isCmpOrder == false) {
                          controller.isCmpOrder = null;
                        } else {
                          controller.isCmpOrder = false;
                        }

                        controller.update();
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              child: Image.asset(
                                controller.isCmpOrder == false ? AppImages.checkBoxSelectedRound : AppImages.checkBoxRound,
                                height: 20,
                                width: 20,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("No", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("Manual Order", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (controller.isAdminManualOrder == true) {
                          controller.isAdminManualOrder = null;
                        } else {
                          controller.isAdminManualOrder = true;
                        }

                        controller.update();
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              child: Image.asset(
                                controller.isAdminManualOrder == true ? AppImages.checkBoxSelectedRound : AppImages.checkBoxRound,
                                height: 20,
                                width: 20,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Yes", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (controller.isAdminManualOrder == false) {
                          controller.isAdminManualOrder = null;
                        } else {
                          controller.isAdminManualOrder = false;
                        }
                        controller.update();
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              child: Image.asset(
                                controller.isAdminManualOrder == false ? AppImages.checkBoxSelectedRound : AppImages.checkBoxRound,
                                height: 20,
                                width: 20,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("No", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("Delete Trade", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (controller.isDeleteTrade == true) {
                          controller.isDeleteTrade = null;
                        } else {
                          controller.isDeleteTrade = true;
                        }
                        controller.update();
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              child: Image.asset(
                                controller.isDeleteTrade == true ? AppImages.checkBoxSelectedRound : AppImages.checkBoxRound,
                                height: 20,
                                width: 20,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Yes", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (controller.isDeleteTrade == false) {
                          controller.isDeleteTrade = null;
                        } else {
                          controller.isDeleteTrade = false;
                        }
                        controller.update();
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              child: Image.asset(
                                controller.isDeleteTrade == false ? AppImages.checkBoxSelectedRound : AppImages.checkBoxRound,
                                height: 20,
                                width: 20,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("No", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text("Execute Pending Order", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (controller.isExecutePendingOrder == true) {
                          controller.isExecutePendingOrder = null;
                        } else {
                          controller.isExecutePendingOrder = true;
                        }

                        controller.update();
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              child: Image.asset(
                                controller.isExecutePendingOrder == true ? AppImages.checkBoxSelectedRound : AppImages.checkBoxRound,
                                height: 20,
                                width: 20,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Yes", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (controller.isExecutePendingOrder == false) {
                          controller.isExecutePendingOrder = null;
                        } else {
                          controller.isExecutePendingOrder = false;
                        }
                        controller.update();
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Container(
                              child: Image.asset(
                                controller.isExecutePendingOrder == false ? AppImages.checkBoxSelectedRound : AppImages.checkBoxRound,
                                height: 20,
                                width: 20,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("No", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget brokerDropDownViewUser() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text("Select Broker", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
        ),
        if (controller.selectedUserType.value.roleId == UserRollList.user)
          SizedBox(
            height: 0.5.h,
          ),
        if (controller.selectedUserType.value.roleId == UserRollList.user)
          brokerListDropDown(controller.selectedBrokerType, width: 100.w, height: 4.h, onChange: () {
            controller.update();
          }),
        if (controller.selectedUserType.value.roleId == UserRollList.user && controller.selectedBrokerType.value.addMaster != null)
          SizedBox(
            height: 2.h,
          ),
        if (controller.selectedUserType.value.roleId == UserRollList.user && controller.selectedBrokerType.value.name != "Select Broker")
          Container(
            child: Text("Brokerage Sharing (%)", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
          ),
        if (controller.selectedUserType.value.roleId == UserRollList.user && controller.selectedBrokerType.value.addMaster != null)
          SizedBox(
            height: 10,
          ),
        if (controller.selectedUserType.value.roleId == UserRollList.user && controller.selectedBrokerType.value.addMaster != null)
          Container(
            height: 4.h,
            child: CustomTextField(
              type: "",
              keyBoardType: TextInputType.text,
              isEnabled: true,
              focusBorderColor: AppColors().blueColor,
              isOptional: false,
              isNoNeededCapital: true,
              inValidMsg: AppString.emptyBrokerageSharing,
              placeHolderMsg: "Brokerage Sharing (%)",
              labelMsg: "",
              emptyFieldMsg: AppString.emptyBrokerageSharing,
              controller: controller.brokerageSharingController,
              focus: controller.brokerageSharingFocus,
              isSecure: false,
              keyboardButtonType: TextInputAction.done,
              maxLength: 3,
              isShowPrefix: false,
              isShowSufix: false,
              suffixIcon: null,
              prefixIcon: null,
              borderColor: AppColors().lightText,
              roundCorner: 0,
            ),
          ),
        if (controller.selectedUserType.value.roleId == UserRollList.user && controller.selectedBrokerType.value.addMaster != null)
          Container(
            width: 8.w,
            child: Row(
              children: [
                Container(
                  child: Text("Our: ", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  child: Text("${num.tryParse(controller.brokerageSharingController.text) ?? 0}", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  child: Text("|", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  child: Text("Downline: ", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  child: Text("${100 - (num.tryParse(controller.brokerageSharingController.text) ?? 0)}", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget masterPartnershipDetailsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text("Partnership Share Details", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Text("P/L Sharing (%)*", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          // width: 13.3.w,
          height: 4.h,
          child: CustomTextField(
            regex: "[0-9]",
            type: "sds",
            focusBorderColor: AppColors().blueColor,
            keyBoardType: TextInputType.text,
            isEnabled: userData!.profitAndLossSharingDownLine! > 0,
            isOptional: false,
            isNoNeededCapital: true,
            inValidMsg: AppString.emptyProfitLossSharing,
            placeHolderMsg: "P/L Sharing (%)",
            labelMsg: "",
            emptyFieldMsg: AppString.emptyProfitLossSharing,
            controller: controller.profitandLossController,
            focus: controller.profitandLossFocus,
            isSecure: false,
            onDoneClick: () {
              controller.brkSharingMasterFocus.requestFocus();
            },
            keyboardButtonType: TextInputAction.done,
            maxLength: controller.profitandLossController.text.characters.length > 0
                ? controller.profitandLossController.text.characters.first == "1"
                    ? 3
                    : 2
                : 3,
            isShowPrefix: false,
            isShowSufix: false,
            suffixIcon: null,
            prefixIcon: null,
            borderColor: AppColors().lightText,
            roundCorner: 0,
          ),
        ),
        Container(
          // width: 8.w,
          child: Row(
            children: [
              Container(
                child: Text("Our: ", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                child: Text(controller.profitandLossController.text == "" ? userData!.profitAndLossSharingDownLine!.toString() : controller.profitandLossController.text, style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                child: Text("|", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                child: Text("Downline: ", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                child: Text(controller.profitandLossController.text == "" ? "0" : "${userData!.profitAndLossSharingDownLine! - (num.tryParse(controller.profitandLossController.text) ?? 0)}",
                    // controller.profitandLossController.text,
                    style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
              ),
              if (userData!.role != UserRollList.superAdmin)
                SizedBox(
                  width: 5,
                ),
              if (userData!.role != UserRollList.superAdmin)
                Container(
                  child: Text("|", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                ),
              if (userData!.role != UserRollList.superAdmin)
                SizedBox(
                  width: 5,
                ),
              if (userData!.role != UserRollList.superAdmin)
                Container(
                  child: Text("Upline: ", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                ),
              if (userData!.role != UserRollList.superAdmin)
                SizedBox(
                  width: 5,
                ),
              if (userData!.role != UserRollList.superAdmin)
                Container(
                  child: Text(userData!.profitAndLossSharing.toString(),
                      // controller.profitandLossController.text,
                      style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                ),
              Spacer(),
              if (controller.profitandLossController.text.isNotEmpty && int.parse(controller.profitandLossController.text) > userData!.profitAndLossSharingDownLine!.toInt())
                Text("Profit and Loss should be between 0 to ${userData!.profitAndLossSharingDownLine!}",
                    // controller.profitandLossController.text,
                    style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().redColor)),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          child: Text("Brokerage Sharing (%)*", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 4.h,
          child: CustomTextField(
            regex: "[0-9]",
            type: "sds",
            focusBorderColor: AppColors().blueColor,
            keyBoardType: TextInputType.text,
            isEnabled: userData!.brkSharingDownLine! > 0,
            isOptional: false,
            isNoNeededCapital: true,
            inValidMsg: AppString.emptyBrokerageSharing,
            placeHolderMsg: "Brokerage Sharing (%)",
            labelMsg: "",
            emptyFieldMsg: AppString.emptyBrokerageSharing,
            controller: controller.brkSharingMasterController,
            focus: controller.brkSharingMasterFocus,
            isSecure: false,
            keyboardButtonType: TextInputAction.done,
            maxLength: controller.brkSharingMasterController.text.characters.length > 0
                ? controller.brkSharingMasterController.text.characters.first == "1"
                    ? 3
                    : 2
                : 3,
            isShowPrefix: false,
            isShowSufix: false,
            suffixIcon: null,
            prefixIcon: null,
            borderColor: AppColors().lightText,
            roundCorner: 0,
          ),
        ),
        Container(
          // width: 10.w,
          child: Row(
            children: [
              Container(
                child: Text("Our: ", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                child: Text(controller.brkSharingMasterController.text == "" ? userData!.brkSharingDownLine!.toString() : controller.brkSharingMasterController.text, style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                child: Text("|", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                child: Text("Downline: ", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
              ),
              SizedBox(
                width: 5,
              ),
              // "${userData!.brkSharingDownLine! - (num.tryParse(controller.brkSharingMasterController.text) ?? 0)}",
              Container(
                child: Text(controller.brkSharingMasterController.text == "" ? "0" : "${userData!.brkSharingDownLine! - (num.tryParse(controller.brkSharingMasterController.text) ?? 0)}", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
              ),
              if (userData!.role != UserRollList.superAdmin)
                SizedBox(
                  width: 5,
                ),
              if (userData!.role != UserRollList.superAdmin)
                Container(
                  child: Text("Upline: ", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                ),
              if (userData!.role != UserRollList.superAdmin)
                SizedBox(
                  width: 5,
                ),
              if (userData!.role != UserRollList.superAdmin)
                Container(
                  child: Text(userData!.brkSharing.toString(),
                      // controller.profitandLossController.text,
                      style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                ),
              Spacer(),

              if (controller.brkSharingMasterController.text.isNotEmpty && int.parse(controller.brkSharingMasterController.text) > userData!.brkSharingDownLine!.toInt())
                Text("Brokerage sharing should be between 0 to ${userData!.brkSharingDownLine!}",
                    // controller.profitandLossController.text,
                    style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().redColor)),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget masterAddOrderCheckboxView() {
    return Row(
      children: [
        SizedBox(
          width: 1.w,
        ),
        GestureDetector(
          onTap: () {
            controller.isAutoSquareOff = !controller.isAutoSquareOff;
            controller.update();
          },
          child: Container(
            width: 8.w,
            child: Row(
              children: [
                // Container(
                //   child: Image.asset(
                //     controller.isAutoSquareOff
                //         ? AppImages.checkBoxSelected
                //         : AppImages.checkBox,
                //     height: 20,
                //     width: 20,
                //   ),
                // ),
                Container(
                  height: 17, //set desired REAL HEIGHT
                  width: 25,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.isAutoSquareOff ? AppColors().blueColor : AppColors().lightText,
                        width: 2.5,
                      ),
                      borderRadius: BorderRadius.circular(20)),
                  child: Transform.scale(
                    transformHitTests: false,
                    scale: .4,
                    child: CupertinoSwitch(
                      value: controller.isAutoSquareOff,
                      activeColor: AppColors().grayBg,
                      trackColor: AppColors().grayBg,
                      thumbColor: controller.isAutoSquareOff ? AppColors().blueColor : AppColors().switchColor,
                      onChanged: (bool value) async {
                        if (controller.isCutOffHasValue.value == false) {
                          controller.isAutoSquareOff = !controller.isAutoSquareOff;
                          controller.update();
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  child: Text("Add Master", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 2.w,
        ),
        GestureDetector(
          onTap: () {
            controller.isModifyOrder = !controller.isModifyOrder;
            controller.update();
          },
          child: Container(
            width: 8.w,
            child: Row(
              children: [],
            ),
          ),
        )
      ],
    );
  }

  Widget masterMarketOrderCheckboxView() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            controller.isCloseOnly = !controller.isCloseOnly;
            controller.update();
          },
          child: Container(
            width: 8.w,
            child: Row(
              children: [
                // Container(
                //   child: Image.asset(
                //     controller.isCloseOnly
                //         ? AppImages.checkBoxSelected
                //         : AppImages.checkBox,
                //     height: 20,
                //     width: 20,
                //   ),
                // ),
                if (controller.selectedUserType.value.roleId != UserRollList.user)
                  Container(
                    height: 17, //set desired REAL HEIGHT
                    width: 25,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: controller.isCloseOnly ? AppColors().blueColor : AppColors().lightText,
                          width: 2.5,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: Transform.scale(
                      transformHitTests: false,
                      scale: .4,
                      child: CupertinoSwitch(
                        value: controller.isCloseOnly,
                        activeColor: AppColors().grayBg,
                        trackColor: AppColors().grayBg,
                        thumbColor: controller.isCloseOnly ? AppColors().blueColor : AppColors().switchColor,
                        onChanged: (bool value) async {
                          controller.isCloseOnly = !controller.isCloseOnly;
                          controller.update();
                        },
                      ),
                    ),
                  ),
                SizedBox(
                  width: 10,
                ),
                if (controller.selectedUserType.value.roleId != UserRollList.user)
                  Container(
                    child: Text(controller.selectedUserType.value.roleId == UserRollList.user ? "Close Only" : "Market Order", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                  ),
              ],
            ),
          ),
        ),
        // SizedBox(
        //   width: 2.w,
        // ),
        // if (controller.selectedUserType.value.roleId == UserRollList.user)
        //   GestureDetector(
        //     onTap: () {
        //       controller.isIntraday = !controller.isIntraday;
        //       controller.update();
        //     },
        //     child: Container(
        //       width: 8.w,
        //       child: Row(
        //         children: [
        //           // Container(
        //           //   child: Image.asset(
        //           //     controller.isIntraday
        //           //         ? AppImages.checkBoxSelected
        //           //         : AppImages.checkBox,
        //           //     height: 20,
        //           //     width: 20,
        //           //   ),
        //           // ),
        //           Container(
        //             height: 17, //set desired REAL HEIGHT
        //             width: 25,
        //             decoration: BoxDecoration(
        //                 border: Border.all(
        //                   color: controller.isIntraday ? AppColors().blueColor : AppColors().lightText,
        //                   width: 2.5,
        //                 ),
        //                 borderRadius: BorderRadius.circular(20)),
        //             child: Transform.scale(
        //               transformHitTests: false,
        //               scale: .4,
        //               child: CupertinoSwitch(
        //                 value: controller.isIntraday,
        //                 activeColor: AppColors().grayBg,
        //                 trackColor: AppColors().grayBg,
        //                 thumbColor: controller.isIntraday ? AppColors().blueColor : AppColors().switchColor,
        //                 onChanged: (bool value) async {
        //                   controller.isIntraday = !controller.isIntraday;
        //                   controller.update();
        //                 },
        //               ),
        //             ),
        //           ),
        //           SizedBox(
        //             width: 10,
        //           ),
        //           Container(
        //             child: Text("Intraday",
        //                 style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
        //           ),
        //         ],
        //       ),
        //     ),
        //   )
      ],
    );
  }

  Widget SymbolWiseSLCheckboxView() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (userData!.highLowSLLimitPercentage == false) {
                controller.isSymbolWiseSL = !controller.isSymbolWiseSL;
                controller.update();
              }
            },
            child: Container(
              width: 12.w,
              child: Row(
                children: [
                  Container(
                    height: 17, //set desired REAL HEIGHT
                    width: 25,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: controller.isSymbolWiseSL ? AppColors().blueColor : AppColors().lightText,
                          width: 2.5,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: Transform.scale(
                      transformHitTests: false,
                      scale: .4,
                      child: CupertinoSwitch(
                        value: controller.isSymbolWiseSL,
                        activeColor: AppColors().grayBg,
                        trackColor: AppColors().grayBg,
                        thumbColor: controller.isSymbolWiseSL ? AppColors().blueColor : AppColors().switchColor,
                        onChanged: (bool value) async {
                          if (userData!.highLowSLLimitPercentage == true) {
                            return;
                          }
                          controller.isSymbolWiseSL = !controller.isSymbolWiseSL;
                          controller.update();
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Text("Symbol wise SL/Limit(%)", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget FreshLimitSLCheckboxView() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              controller.isFreshLimitSL.value = !controller.isFreshLimitSL.value;
            },
            child: Container(
              width: 12.w,
              child: Row(
                children: [
                  Container(
                    height: 17, //set desired REAL HEIGHT
                    width: 25,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: controller.isFreshLimitSL.value ? AppColors().blueColor : AppColors().lightText,
                          width: 2.5,
                        ),
                        borderRadius: BorderRadius.circular(20)),
                    child: Transform.scale(
                      transformHitTests: false,
                      scale: .4,
                      child: CupertinoSwitch(
                        value: controller.isFreshLimitSL.value,
                        activeColor: AppColors().grayBg,
                        trackColor: AppColors().grayBg,
                        thumbColor: controller.isFreshLimitSL.value ? AppColors().blueColor : AppColors().switchColor,
                        onChanged: (bool value) async {
                          controller.isFreshLimitSL.value = !controller.isFreshLimitSL.value;
                          controller.update();
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Text("Fresh Limit SL", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget ordersCheckboxesView() {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  controller.isAutoSquareOff = !controller.isAutoSquareOff;
                  controller.update();
                },
                child: Container(
                  width: 8.w,
                  child: Row(
                    children: [
                      // Container(
                      //   child: Image.asset(
                      //     controller.isAutoSquareOff
                      //         ? AppImages.checkBoxSelected
                      //         : AppImages.checkBox,
                      //     height: 20,
                      //     width: 20,
                      //   ),
                      // ),
                      Container(
                        height: 17, //set desired REAL HEIGHT
                        width: 25,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: controller.isAutoSquareOff ? AppColors().blueColor : AppColors().lightText,
                              width: 2.5,
                            ),
                            borderRadius: BorderRadius.circular(20)),
                        child: Transform.scale(
                          transformHitTests: false,
                          scale: .4,
                          child: CupertinoSwitch(
                            value: controller.isAutoSquareOff,
                            activeColor: AppColors().grayBg,
                            trackColor: AppColors().grayBg,
                            thumbColor: controller.isAutoSquareOff ? AppColors().blueColor : AppColors().switchColor,
                            onChanged: (bool value) async {
                              if (controller.isCutOffHasValue.value == false) {
                                controller.isAutoSquareOff = !controller.isAutoSquareOff;
                                controller.update();
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        child: Text(controller.selectedUserType.value.roleId == UserRollList.user ? "Auto Square Off" : "Add Master", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              GestureDetector(
                onTap: () {
                  controller.isModifyOrder = !controller.isModifyOrder;
                  controller.update();
                },
                child: Container(
                  width: 8.w,
                  child: Row(
                    children: [],
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  controller.isCloseOnly = !controller.isCloseOnly;
                  controller.update();
                },
                child: Container(
                  width: 8.w,
                  child: Row(
                    children: [
                      // Container(
                      //   child: Image.asset(
                      //     controller.isCloseOnly
                      //         ? AppImages.checkBoxSelected
                      //         : AppImages.checkBox,
                      //     height: 20,
                      //     width: 20,
                      //   ),
                      // ),
                      if (controller.selectedUserType.value.roleId != UserRollList.user)
                        Container(
                          height: 17, //set desired REAL HEIGHT
                          width: 25,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: controller.isCloseOnly ? AppColors().blueColor : AppColors().lightText,
                                width: 2.5,
                              ),
                              borderRadius: BorderRadius.circular(20)),
                          child: Transform.scale(
                            transformHitTests: false,
                            scale: .4,
                            child: CupertinoSwitch(
                              value: controller.isCloseOnly,
                              activeColor: AppColors().grayBg,
                              trackColor: AppColors().grayBg,
                              thumbColor: controller.isCloseOnly ? AppColors().blueColor : AppColors().switchColor,
                              onChanged: (bool value) async {
                                controller.isCloseOnly = !controller.isCloseOnly;
                                controller.update();
                              },
                            ),
                          ),
                        ),
                      SizedBox(
                        width: 10,
                      ),
                      if (controller.selectedUserType.value.roleId != UserRollList.user)
                        Container(
                          child: Text(controller.selectedUserType.value.roleId == UserRollList.user ? "Close Only" : "Market Order", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                        ),
                    ],
                  ),
                ),
              ),
              // SizedBox(
              //   width: 2.w,
              // ),
              // if (controller.selectedUserType.value.roleId == UserRollList.user)
              //   GestureDetector(
              //     onTap: () {
              //       controller.isIntraday = !controller.isIntraday;
              //       controller.update();
              //     },
              //     child: Container(
              //       width: 8.w,
              //       child: Row(
              //         children: [
              //           // Container(
              //           //   child: Image.asset(
              //           //     controller.isIntraday
              //           //         ? AppImages.checkBoxSelected
              //           //         : AppImages.checkBox,
              //           //     height: 20,
              //           //     width: 20,
              //           //   ),
              //           // ),
              //           Container(
              //             height: 17, //set desired REAL HEIGHT
              //             width: 25,
              //             decoration: BoxDecoration(
              //                 border: Border.all(
              //                   color: controller.isIntraday ? AppColors().blueColor : AppColors().lightText,
              //                   width: 2.5,
              //                 ),
              //                 borderRadius: BorderRadius.circular(20)),
              //             child: Transform.scale(
              //               transformHitTests: false,
              //               scale: .4,
              //               child: CupertinoSwitch(
              //                 value: controller.isIntraday,
              //                 activeColor: AppColors().grayBg,
              //                 trackColor: AppColors().grayBg,
              //                 thumbColor: controller.isIntraday ? AppColors().blueColor : AppColors().switchColor,
              //                 onChanged: (bool value) async {
              //                   controller.isIntraday = !controller.isIntraday;
              //                   controller.update();
              //                 },
              //               ),
              //             ),
              //           ),
              //           SizedBox(
              //             width: 10,
              //           ),
              //           Container(
              //             child: Text("Intraday",
              //                 style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
              //           ),
              //         ],
              //       ),
              //     ),
              //   )
            ],
          )
        ],
      ),
    );
  }

  Widget exchangeFunctionClient() {
    return Container(
      color: AppColors().whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // height: 12.h,
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 3.h,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 1,
                        ),
                        Checkbox(
                            activeColor: AppColors().blueColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            value: controller.isSelectedallExchangeinMaster.value,
                            onChanged: ((value) {
                              controller.isSelectedallExchangeinMaster.value = value!;

                              for (var indexs = 0; indexs < controller.arrExchange.length; indexs++) {
                                controller.arrExchange[indexs].isSelected = controller.isSelectedallExchangeinMaster.value;
                                if (controller.isSelectedallExchangeinMaster.value == true) {
                                  if (controller.arrExchange[indexs].brokarageType == "symbolwise") {
                                    controller.arrExchange[indexs].isSymbolSelected = true;
                                    controller.arrExchange[indexs].isTurnOverSelected = false;
                                  } else {
                                    controller.arrExchange[indexs].isSymbolSelected = false;
                                    controller.arrExchange[indexs].isTurnOverSelected = true;
                                  }
                                } else {
                                  controller.arrExchange[indexs].isSymbolSelected = false;
                                  controller.arrExchange[indexs].isTurnOverSelected = false;
                                }

                                if (controller.arrExchange[indexs].isSelected == false) {
                                  controller.arrExchange[indexs].selectedItems.clear();
                                  controller.arrExchange[indexs].isDropDownValueSelected.value = controller.arrExchange[indexs].arrGroupList.first;
                                }

                                if (controller.arrExchange[indexs].arrGroupList.isNotEmpty) {
                                  controller.arrExchange[indexs].isSelected = true;
                                } else {
                                  controller.arrExchange[indexs].isSelected = false;
                                  controller.arrExchange[indexs].isDropDownValueSelected.value = controller.arrExchange[indexs].arrGroupList.first;
                                }

                                if (controller.isSelectedallExchangeinMaster.value == false) {
                                  controller.arrExchange[indexs].isHighLowTradeSelected = false;
                                  controller.arrExchange[indexs].isSelected = false;
                                  controller.arrExchange[indexs].isDropDownValueSelected.value = controller.arrExchange[indexs].arrGroupList.first;
                                }
                              }
                              controller.update();
                            })),
                        SizedBox(
                          width: 1,
                        ),
                        Expanded(
                          child: Container(
                            color: AppColors().backgroundColor,
                            child: Center(
                                child: Row(
                              children: [
                                SizedBox(
                                  width: 7,
                                ),
                                Text("Exchange", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
                              ],
                            )),
                          ),
                        ),
                        SizedBox(
                          width: 1,
                        ),
                        Expanded(
                          child: Container(
                            color: AppColors().backgroundColor,
                            child: Center(
                                child: Row(
                              children: [
                                SizedBox(
                                  width: 7,
                                ),
                                Text("Turnover Brk.", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
                              ],
                            )),
                          ),
                        ),
                        SizedBox(
                          width: 1,
                        ),
                        Expanded(
                          child: Container(
                            color: AppColors().backgroundColor,
                            child: Center(
                                child: Row(
                              children: [
                                SizedBox(
                                  width: 7,
                                ),
                                Text("Symbol Brk.", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
                              ],
                            )),
                          ),
                        ),
                        SizedBox(
                          width: 1,
                        ),
                        Expanded(
                          child: Container(
                            color: AppColors().backgroundColor,
                            child: Center(
                                child: Row(
                              children: [
                                SizedBox(
                                  width: 7,
                                ),
                                Text("Group", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
                              ],
                            )),
                          ),
                        ),
                        SizedBox(
                          width: 1,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        clipBehavior: Clip.hardEdge,
                        itemCount: controller.arrExchange.length,
                        controller: controller.listcontroller,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return exchangeListViewClient(context, index);
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget exchangeFunctionMaster() {
    return Container(
      color: AppColors().whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            // height: 12.h,
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 3.h,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 1,
                        ),
                        GestureDetector(
                          onTap: () async {},
                          child: Container(
                              width: 2.2.w,
                              color: AppColors().backgroundColor,
                              child: Checkbox(
                                  activeColor: AppColors().blueColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                  value: controller.isSelectedallExchangeinMaster.value,
                                  onChanged: (value) {
                                    controller.isSelectedallExchangeinMaster.value = !controller.isSelectedallExchangeinMaster.value;
                                    for (var indexs = 0; indexs < controller.arrExchange.length; indexs++) {
                                      controller.arrExchange[indexs].isSelected = controller.isSelectedallExchangeinMaster.value;

                                      if (controller.arrExchange[indexs].isSelected == false) {
                                        controller.arrExchange[indexs].selectedItems.clear();
                                        controller.arrExchange[indexs].isDropDownValueSelected.value = groupListModelData();
                                      }

                                      if (controller.arrExchange[indexs].arrGroupList.isNotEmpty) {
                                        controller.arrExchange[indexs].isSelected = true;
                                      } else {
                                        controller.arrExchange[indexs].isSelected = false;
                                      }

                                      if (controller.isSelectedallExchangeinMaster.value == false) {
                                        controller.arrExchange[indexs].isSelected = false;
                                        controller.arrExchange[indexs].isHighLowTradeSelected = false;
                                      }
                                    }
                                    controller.update();
                                  })

                              // child: Center(
                              //   child: Image.asset(
                              //     controller.isSelectedallExchangeinMaster.value ? AppImages.checkBoxSelected : AppImages.checkBox,
                              //     height: 16,
                              //     width: 16,
                              //   ),
                              // ),
                              ),
                        ),
                        SizedBox(
                          width: 1,
                        ),
                        Expanded(
                          child: Container(
                            color: AppColors().backgroundColor,
                            child: Center(
                                child: Row(
                              children: [
                                SizedBox(
                                  width: 7,
                                ),
                                Text("Exchange", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
                              ],
                            )),
                          ),
                        ),
                        SizedBox(
                          width: 1,
                        ),
                        Expanded(
                          child: Container(
                            color: AppColors().backgroundColor,
                            child: Center(
                                child: Row(
                              children: [
                                SizedBox(
                                  width: 7,
                                ),
                                Text("Group", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
                              ],
                            )),
                          ),
                        ),
                        SizedBox(
                          width: 1,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        clipBehavior: Clip.hardEdge,
                        itemCount: controller.arrExchange.length,
                        controller: controller.listcontroller,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return exchangeListViewMaster(context, index);
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget exchangeListViewClient(BuildContext context, int index) {
    return Container(
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 1,
                ),
                Checkbox(
                    activeColor: AppColors().blueColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    value: controller.arrExchange[index].isSelected,
                    onChanged: (value) {
                      if (controller.arrExchange[index].isSelected) {
                        controller.arrExchange[index].isHighLowTradeSelected = false;
                      }
                      if (controller.arrExchange[index].arrGroupList.isNotEmpty) {
                        controller.arrExchange[index].isSelected = value!;
                        if (controller.arrExchange[index].isSelected == false) {
                          controller.arrExchange[index].isSymbolSelected = false;
                          controller.arrExchange[index].isTurnOverSelected = false;
                        } else {
                          if (controller.arrExchange[index].brokarageType == "symbolwise") {
                            controller.arrExchange[index].isSymbolSelected = true;
                            controller.arrExchange[index].isTurnOverSelected = false;
                          } else {
                            controller.arrExchange[index].isSymbolSelected = false;
                            controller.arrExchange[index].isTurnOverSelected = true;
                          }
                        }
                        //Condition
                        if (controller.arrExchange[index].isSelected == false) {
                          if (controller.isSelectedallExchangeinMaster.value == true) {
                            controller.isSelectedallExchangeinMaster.value = false;
                          }
                        }
                        if (controller.arrExchange.every((exchange) => exchange.isSelected)) {
                          controller.isSelectedallExchangeinMaster.value = true;
                        }

                        if (controller.arrExchange[index].isSelected == false) {
                          controller.arrExchange[index].selectedItems.clear();
                          controller.arrExchange[index].isDropDownValueSelected.value = controller.arrExchange[index].arrGroupList.first;
                        }

                        controller.update();
                      }
                    }),
                SizedBox(
                  width: 1,
                ),
                Expanded(
                  child: Container(
                    height: 3.h,
                    color: index % 2 == 1 ? AppColors().footerColor : AppColors().grayBg,
                    child: Center(
                        child: Row(
                      children: [
                        SizedBox(
                          width: 7,
                        ),
                        Text(controller.arrExchange[index].name ?? "", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
                      ],
                    )),
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
                Expanded(
                  child: Container(
                    height: 3.h,
                    color: index % 2 == 1 ? AppColors().footerColor : AppColors().grayBg,
                    child: Row(
                      children: [
                        IgnorePointer(
                          ignoring: controller.arrExchange[index].isSelected == false,
                          child: Checkbox(
                              activeColor: AppColors().blueColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              value: controller.arrExchange[index].isTurnOverSelected,
                              onChanged: (value) {
                                if (controller.arrExchange[index].brokarageType != "symbolwise") {
                                  controller.arrExchange[index].isTurnOverSelected = true;
                                  controller.arrExchange[index].isSymbolSelected = false;
                                  controller.update();
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
                Expanded(
                  child: Container(
                    height: 3.h,
                    color: index % 2 == 1 ? AppColors().footerColor : AppColors().grayBg,
                    child: Row(
                      children: [
                        IgnorePointer(
                          ignoring: controller.arrExchange[index].isSelected == false,
                          child: Checkbox(
                              activeColor: AppColors().blueColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              value: controller.arrExchange[index].isSymbolSelected,
                              onChanged: (value) {
                                if (controller.arrExchange[index].brokarageType == "symbolWise" || controller.arrExchange[index].brokarageType == "both") {
                                  controller.arrExchange[index].isSymbolSelected = true;
                                  controller.arrExchange[index].isTurnOverSelected = false;
                                  controller.update();
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
                Expanded(
                  child: Container(
                    height: 3.h,
                    color: index % 2 == 1 ? AppColors().footerColor : AppColors().grayBg,
                    child: Center(
                        child: Row(
                      children: [
                        if (controller.selectedUserType.value.roleId == UserRollList.user)
                          IgnorePointer(
                            ignoring: controller.arrExchange[index].isSelected == false,
                            child: dropDownGroupSingleSelection(controller.arrExchange[index].isDropDownValueSelected, controller.arrExchange[index].arrGroupList),
                          ),
                      ],
                    )),
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget exchangeListViewMaster(BuildContext context, int index) {
    return Container(
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 1,
                ),
                Container(
                    width: 2.2.w,
                    height: 3.h,
                    color: index % 2 == 1 ? AppColors().footerColor : AppColors().grayBg,
                    child: Checkbox(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        activeColor: AppColors().blueColor,
                        value: controller.arrExchange[index].isSelected,
                        onChanged: (value) {
                          if (controller.arrExchange[index].isSelected) {
                            controller.arrExchange[index].isHighLowTradeSelected = false;
                          }
                          if (controller.arrExchange[index].arrGroupList.isNotEmpty) {
                            controller.arrExchange[index].isSelected = !controller.arrExchange[index].isSelected;
                            //Condition
                            if (controller.arrExchange[index].isSelected == false) {
                              if (controller.isSelectedallExchangeinMaster.value == true) {
                                controller.isSelectedallExchangeinMaster.value = false;
                              }
                            }
                            if (controller.arrExchange.every((exchange) => exchange.isSelected)) {
                              controller.isSelectedallExchangeinMaster.value = true;
                            }
                            if (controller.arrExchange[index].isSelected == false) {
                              controller.arrExchange[index].selectedItems.clear();
                              controller.arrExchange[index].isDropDownValueSelected.value = groupListModelData();
                            }
                            controller.update();
                          }
                        })),
                SizedBox(
                  width: 1,
                ),
                Expanded(
                  child: Container(
                    height: 3.h,
                    color: index % 2 == 1 ? AppColors().footerColor : AppColors().grayBg,
                    child: Center(
                        child: Row(
                      children: [
                        SizedBox(
                          width: 7,
                        ),
                        Text(controller.arrExchange[index].name ?? "", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
                      ],
                    )),
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
                Expanded(
                  child: Container(
                    height: 3.h,
                    color: index % 2 == 1 ? AppColors().footerColor : AppColors().grayBg,
                    child: Center(
                        child: Row(
                      children: [
                        IgnorePointer(
                          ignoring: controller.arrExchange[index].isSelected == false,
                          child: dropDownMasterMultiSelection(controller.arrExchange[index].selectedItems, controller.arrExchange[index].arrGroupList),
                        ),
                      ],
                    )),
                  ),
                ),
                SizedBox(
                  width: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget dropDownGroupSingleSelection(Rx<groupListModelData?> values, List<groupListModelData> arr) {
    //print(controller.singleDropdownKey.currentContext);
    if (values.value!.name! == "") {
      values.value!.name = "Select Group";
      return SizedBox();
    }
    if (values.value!.name! == "Select Group" && arr.indexWhere((element) => element.name == "Select Group") == -1) {
      arr.insert(0, groupListModelData(name: "Select Group"));
      return SizedBox();
    }
    return Container(
      width: 11.w,
      child: Container(
        child: Obx(() {
          return Center(
            child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<groupListModelData>(
              focusNode: FocusNode(),
              padding: EdgeInsets.zero,
              key: GlobalKey(),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 5),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors().blueColor, width: 1)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
              ),
              value: values.value,
              icon: const Icon(Icons.arrow_drop_down),
              elevation: 16,
              style: TextStyle(color: AppColors().darkText),
              onChanged: (groupListModelData? value) {
                // This is called when the user selects an item.
                values.value = value!;
              },
              selectedItemBuilder: (context) {
                return arr.map<DropdownMenuItem<groupListModelData>>((groupListModelData item) {
                  return DropdownMenuItem<groupListModelData>(
                    value: item,
                    child: Text(item.name ?? ""),
                  );
                }).toList();
              },
              isExpanded: true,
              items: arr.map<DropdownMenuItem<groupListModelData>>((groupListModelData item) {
                return DropdownMenuItem<groupListModelData>(
                  value: item,
                  child: Text(item.name ?? ""),
                );
              }).toList(),
            )),
          );
        }),
      ),
    );
  }

  Widget exchangeAllowView(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        controller.arrExchange[index].isExchangeAllowed = !controller.arrExchange[index].isExchangeAllowed!;
        controller.update();
      },
      child: Row(
        children: [
          Container(
            height: 17, //set desired REAL HEIGHT
            width: 25,
            decoration: BoxDecoration(
                border: Border.all(
                  color: controller.arrExchange[index].isExchangeAllowed! ? AppColors().blueColor : AppColors().lightText,
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(20)),
            child: Transform.scale(
              transformHitTests: false,
              scale: .4,
              child: CupertinoSwitch(
                value: controller.arrExchange[index].isExchangeAllowed!,
                activeColor: AppColors().grayBg,
                trackColor: AppColors().grayBg,
                thumbColor: controller.arrExchange[index].isExchangeAllowed! ? AppColors().blueColor : AppColors().switchColor,
                onChanged: (bool value) async {
                  controller.arrExchange[index].isExchangeAllowed = !controller.arrExchange[index].isExchangeAllowed!;
                  controller.update();
                },
              ),
            ),
          ),
          SizedBox(
            width: 1.h,
          ),
          Text(controller.arrExchange[index].name ?? "", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
          if (index != controller.arrExchange.length - 1)
            SizedBox(
              width: MediaQuery.of(context).size.width / 80,
            ),
        ],
      ),
    );
  }

  Widget highLowBetWeenTradeView(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        if (controller.arrExchange[index].isSelected) {
          controller.arrExchange[index].isHighLowTradeSelected = !controller.arrExchange[index].isHighLowTradeSelected!;
          controller.update();
        }
      },
      child: Row(
        children: [
          Container(
            height: 17, //set desired REAL HEIGHT
            width: 25,
            decoration: BoxDecoration(
                border: Border.all(
                  color: controller.arrExchange[index].isHighLowTradeSelected! ? AppColors().blueColor : AppColors().lightText,
                  width: 2.5,
                ),
                borderRadius: BorderRadius.circular(20)),
            child: Transform.scale(
              transformHitTests: false,
              scale: .4,
              child: CupertinoSwitch(
                focusNode: controller.arrExchange[index].focusNode,
                value: controller.arrExchange[index].isHighLowTradeSelected!,
                activeColor: AppColors().grayBg,
                trackColor: AppColors().grayBg,
                thumbColor: controller.arrExchange[index].isHighLowTradeSelected! ? AppColors().blueColor : AppColors().switchColor,
                onChanged: (bool value) async {
                  if (controller.arrExchange[index].isSelected) {
                    controller.arrExchange[index].isHighLowTradeSelected = !controller.arrExchange[index].isHighLowTradeSelected!;
                    controller.update();
                  }
                },
              ),
            ),
          ),
          SizedBox(
            width: 1.h,
          ),
          Text(controller.arrExchange[index].name ?? "", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
          if (index != controller.arrExchange.length - 1)
            SizedBox(
              width: MediaQuery.of(context).size.width / 80,
            ),
        ],
      ),
    );
  }

  Widget dropDownMasterMultiSelection(List<groupListModelData> values, List<groupListModelData> arr) {
    return Container(
      child: Center(
        child: Container(
          width: 22.5.w,
          height: 27,
          child: DropdownButtonHideUnderline(
            child: DropDownMultiSelect<groupListModelData>(
              decoration: InputDecoration(
                // contentPadding: EdgeInsets.only(left: 5, bottom: 10),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors().blueColor, width: 1)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 1)),
              ),
              selected_values_style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText),
              onChanged: (List<groupListModelData> x) {
                //print(x);
              },
              options: arr,
              selectedValues: values,
              whenEmpty: 'Select Group',
            ),
          ),
        ),
      ),
    );
  }

  Widget leverageDropDown(Rx<AddMaster> selectedLeverage, {double? width, double? height, FocusNode? focus}) {
    return Obx(() {
      return Container(
          width: width ?? 250,
          height: height ?? 30,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(border: Border.all(color: focus!.hasFocus ? AppColors().blueColor : AppColors().lightOnlyText, width: 1), color: AppColors().whiteColor),
          child: DropdownButton<AddMaster>(
            focusNode: focus,
            key: controller.dropdownLeveargeKey,
            value: selectedLeverage.value,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 16,
            style: TextStyle(color: AppColors().darkText),
            underline: Container(
              height: 2,
              color: Colors.transparent,
            ),
            onChanged: (AddMaster? value) {
              // This is called when the user selects an item.
              selectedLeverage.value = value!;
              focus.nextFocus();
            },
            isExpanded: true,
            items: arrLeverageList.map<DropdownMenuItem<AddMaster>>((AddMaster value) {
              return DropdownMenuItem<AddMaster>(
                value: value,
                child: Text(value.name!),
              );
            }).toList(),
          ));
    });
  }
}
