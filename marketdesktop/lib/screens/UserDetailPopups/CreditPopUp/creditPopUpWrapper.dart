import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:marketdesktop/constant/color.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/screens/UserDetailPopups/CreditPopUp/creditPopUpController.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../constant/index.dart';
import '../../../customWidgets/appButton.dart';
import '../../../customWidgets/commonWidgets.dart';

import '../../BaseController/baseController.dart';
import '../userDetailsPopUpController.dart';

class CreditPopUpScreen extends BaseView<CreditPopUpController> {
  const CreditPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Visibility(
        visible: Get.find<UserDetailsPopUpController>().selectedMenuName == "Credit",
        child: GestureDetector(
          onTap: () {
            // controller.focusNode.requestFocus();
          },
          child: Column(
            children: [
              // dateSelectedContent(context),
              if (controller.selectedUserData != null)
                Expanded(
                  child: Row(
                    children: [
                      if (controller.selectedUserData?.parentId == userData!.userId)
                        filterPanel(context, name: "Add Credit", bottomMargin: 0, isRecordDisplay: false, onCLickFilter: () {
                          controller.isFilterOpen = !controller.isFilterOpen;
                          controller.update();
                        }),
                      if (controller.selectedUserData!.parentId == userData!.userId) filterContent(context),
                      Expanded(
                        flex: 8,
                        child: BouncingScrollWrapper.builder(context, mainContent(context), dragWithMouse: true),
                        // child: BouncingScrollWrapper.builder(context, mainContent(context), dragWithMouse: true),
                      ),
                      Container(
                        width: 1.w,
                      )
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dateSelectedContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      decoration: BoxDecoration(
          color: AppColors().whiteColor,
          border: Border(
            bottom: BorderSide(color: AppColors().lightOnlyText, width: 1),
          )),
      child: Container(
        height: 3.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            Container(
              height: 4.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text("From Date :",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: CustomFonts.family1Regular,
                          color: AppColors().fontColor,
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      showCalenderPopUp(DateTime.now(), (DateTime selectedDate) {
                        controller.fromDate.value = shortDateForBackend(selectedDate);
                      });
                    },
                    child: Obx(() {
                      return Container(
                        height: 4.h,
                        width: 250,
                        decoration: BoxDecoration(
                            color: AppColors().whiteColor,
                            border: Border.all(
                              color: AppColors().lightOnlyText,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(3)),
                        // color: AppColors().whiteColor,
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              controller.fromDate.value,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: CustomFonts.family1Medium,
                                color: AppColors().darkText,
                              ),
                            ),
                            const Spacer(),
                            Image.asset(
                              AppImages.calendarIcon,
                              width: 20,
                              height: 20,
                              color: AppColors().fontColor,
                            )
                          ],
                        ),
                      );
                    }),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    child: Text("To Date :",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: CustomFonts.family1Regular,
                          color: AppColors().fontColor,
                        )),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      // selectToDate(controller.endDate);
                      showCalenderPopUp(DateTime.now(), (DateTime selectedDate) {
                        controller.endDate.value = shortDateForBackend(selectedDate);
                      });
                    },
                    child: Obx(() {
                      return Container(
                        height: 4.h,
                        width: 250,
                        decoration: BoxDecoration(
                            color: AppColors().whiteColor,
                            border: Border.all(
                              color: AppColors().lightOnlyText,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(3)),
                        // color: AppColors().whiteColor,
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              controller.endDate.value,
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: CustomFonts.family1Medium,
                                color: AppColors().darkText,
                              ),
                            ),
                            const Spacer(),
                            Image.asset(
                              AppImages.calendarIcon,
                              width: 20,
                              height: 20,
                              color: AppColors().fontColor,
                            )
                          ],
                        ),
                      );
                    }),
                  ),
                  SizedBox(
                    width: 0,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 6.w,
              height: 3.h,
              child: CustomButton(
                isEnabled: true,
                noNeedBorderRadius: true,
                shimmerColor: AppColors().whiteColor,
                title: "Request",
                textSize: 14,
                onPress: () {},
                bgColor: AppColors().blueColor,
                isFilled: true,
                textColor: AppColors().whiteColor,
                isTextCenter: true,
                isLoading: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mainContent(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 1860,
        // margin: EdgeInsets.only(right: 1.w),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 3.h,
              color: AppColors().whiteColor,
              child: Row(
                children: [
                  // Container(
                  //   width: 30,
                  // ),
                  listTitleContent(),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  clipBehavior: Clip.hardEdge,
                  itemCount: controller.arrCreditList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return creditContent(context, index);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget creditContent(BuildContext context, int index) {
    // var scriptValue = controller.arrUserOderList[index];
    return GestureDetector(
      onTap: () {
        // controller.selectedScriptIndex = index;
        controller.update();
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            valueBox(shortFullDateTime(controller.arrCreditList[index].createdAt!), 45,
                index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index,
                isBig: true),
            valueBox(
              controller.arrCreditList[index].transactionType ?? "",
              45,
              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
              AppColors().darkText,
              index,
            ),
            valueBox(controller.arrCreditList[index].amount!.toStringAsFixed(2), 45,
                index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
            valueBox(controller.arrCreditList[index].comment ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                AppColors().darkText, index,
                isBig: true),
          ],
        ),
      ),
    );
  }

  Widget listTitleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // titleBox("", 0),

        titleBox("Date Time", isBig: true),
        titleBox("Type"),
        titleBox("Amount"),

        titleBox("Comments", isLarge: true),
      ],
    );
  }

  Widget filterContent(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Visibility(
        visible: controller.isFilterOpen,
        child: AnimatedContainer(
          // margin: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: AppColors().whiteColor, width: 1),
          )),
          width: controller.isFilterOpen ? 330 : 0,
          duration: Duration(milliseconds: 100),
          child: Offstage(
            offstage: !controller.isFilterOpen,
            child: Column(
              children: [
                SizedBox(
                  width: 35,
                ),
                Container(
                  height: 35,
                  color: AppColors().headerBgColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Container(
                        child: Text("Add Credit",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: CustomFonts.family1SemiBold,
                              color: AppColors().darkText,
                            )),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          controller.isFilterOpen = false;
                          controller.update();
                        },
                        child: Container(
                          padding: EdgeInsets.all(9),
                          width: 30,
                          height: 30,
                          color: Colors.transparent,
                          child: Image.asset(
                            AppImages.closeIcon,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: AppColors().slideGrayBG,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 4.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Container(
                                child: Text("Amount :",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: CustomFonts.family1Regular,
                                      color: AppColors().fontColor,
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 200,
                                decoration: BoxDecoration(
                                    color: AppColors().whiteColor,
                                    border: Border.all(color: AppColors().lightOnlyText, width: 1)),
                                child: TextFormField(
                                  controller: controller.amountController,
                                  textInputAction: TextInputAction.done,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: CustomFonts.family1Medium,
                                    color: AppColors().darkText,
                                  ),
                                  onFieldSubmitted: (String value) {},
                                  validator: (String? value) {
                                    // if (!foodTags.contains(value)) {
                                    //   return 'Nothing selected.';
                                    // }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(8),
                                    // labelText: 'Food Type',
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 0, color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 0, color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 4.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Container(
                                child: Text("Comment :",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: CustomFonts.family1Regular,
                                      color: AppColors().fontColor,
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 200,
                                decoration: BoxDecoration(
                                    color: AppColors().whiteColor,
                                    border: Border.all(color: AppColors().lightOnlyText, width: 1)),
                                child: TextFormField(
                                  textInputAction: TextInputAction.done,
                                  controller: controller.commentController,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: CustomFonts.family1Medium,
                                    color: AppColors().darkText,
                                  ),
                                  onFieldSubmitted: (String value) {},
                                  validator: (String? value) {
                                    // if (!foodTags.contains(value)) {
                                    //   return 'Nothing selected.';
                                    // }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(8),
                                    // labelText: 'Food Type',
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 0, color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(width: 0, color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Spacer(),
                              Text("Trans Type :",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: CustomFonts.family1Regular,
                                    color: AppColors().fontColor,
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: 200,
                                // height: 50,
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 100,
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: const Text(
                                          'Credit',
                                        ),
                                        horizontalTitleGap: 0,
                                        dense: true,
                                        visualDensity: VisualDensity(
                                          vertical: -3,
                                        ),
                                        titleTextStyle: TextStyle(
                                          fontSize: 12,
                                          fontFamily: CustomFonts.family1Regular,
                                          color: AppColors().fontColor,
                                        ),
                                        leading: Radio<TransType>(
                                          value: TransType.Credit,
                                          activeColor: AppColors().darkText,
                                          groupValue: controller.selectedTransType!,
                                          onChanged: (TransType? value) {
                                            controller.selectedTransType = value;
                                            controller.update();
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: const Text(
                                          'Debit',
                                        ),
                                        horizontalTitleGap: 0,
                                        dense: true,
                                        visualDensity: VisualDensity(vertical: -3),
                                        titleTextStyle: TextStyle(
                                          fontSize: 12,
                                          fontFamily: CustomFonts.family1Regular,
                                          color: AppColors().fontColor,
                                        ),
                                        leading: Radio<TransType>(
                                          value: TransType.Debit,
                                          activeColor: AppColors().darkText,
                                          groupValue: controller.selectedTransType!,
                                          onChanged: (TransType? value) {
                                            controller.selectedTransType = value;
                                            controller.update();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 120,
                            ),
                            SizedBox(
                              width: 6.w,
                              height: 3.h,
                              child: CustomButton(
                                isEnabled: true,
                                noNeedBorderRadius: true,
                                shimmerColor: AppColors().whiteColor,
                                title: "Submit",
                                textSize: 14,
                                focusKey: controller.submitFocus,
                                borderColor: Colors.transparent,
                                focusShadowColor: AppColors().blueColor,
                                onPress: () {
                                  controller.callForAddAmount();
                                },
                                bgColor: AppColors().blueColor,
                                isFilled: true,
                                textColor: AppColors().whiteColor,
                                isTextCenter: true,
                                isLoading: controller.isApiCallRunning,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
