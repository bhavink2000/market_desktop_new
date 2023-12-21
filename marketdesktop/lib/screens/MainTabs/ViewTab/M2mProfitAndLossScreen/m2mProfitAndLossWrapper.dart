import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/constant/color.dart';
import 'package:marketdesktop/constant/popUpFunctions.dart';
import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/M2mProfitAndLossScreen/m2mProfitAndLossController.dart';

import '../../../../constant/index.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../MainContainerScreen/mainContainerController.dart';

class M2MProfitAndLossScreen extends BaseView<M2MProfitAndLossController> {
  const M2MProfitAndLossScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Visibility(
        visible: Get.find<MainContainerController>().selectedCurrentTab == "M2M Profit & Loss",
        child: GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              filterPanel(context, isRecordDisplay: true, onCLickFilter: () {
                controller.isFilterOpen = !controller.isFilterOpen;
                controller.update();
              }),
              filterContent(context),
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

  Widget filterContent(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Visibility(
        visible: controller.isFilterOpen,
        child: AnimatedContainer(
          margin: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: AppColors().whiteColor, width: 1),
          )),
          width: controller.isFilterOpen ? 380 : 0,
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Container(
                        child: Text("Filter",
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
                      Container(
                        height: 4.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Container(
                              child: Text("Username:",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: CustomFonts.family1Regular,
                                    color: AppColors().fontColor,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            userListDropDown(controller.selectedUser),
                            SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 70,
                          ),
                          SizedBox(
                            width: 6.w,
                            height: 3.h,
                            child: CustomButton(
                              isEnabled: true,
                              shimmerColor: AppColors().whiteColor,
                              title: "Apply",
                              textSize: 14,
                              onPress: () {
                                controller.selectedUserId = controller.selectedUser.value.userId!;
                                controller.getProfitLossList("");
                              },
                              bgColor: AppColors().blueColor,
                              isFilled: true,
                              textColor: AppColors().whiteColor,
                              isTextCenter: true,
                              isLoading: false,
                            ),
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          SizedBox(
                            width: 6.w,
                            height: 3.h,
                            child: CustomButton(
                              isEnabled: true,
                              shimmerColor: AppColors().whiteColor,
                              title: "Clear",
                              textSize: 14,
                              prefixWidth: 0,
                              onPress: () {
                                controller.selectedExchange.value = ExchangeData();
                                controller.selectedScriptFromFilter.value = GlobalSymbolData();
                                controller.selectedUser.value = UserData();
                                controller.selectedUserId = "";
                                controller.getProfitLossList("");
                              },
                              bgColor: AppColors().whiteColor,
                              isFilled: true,
                              borderColor: AppColors().blueColor,
                              textColor: AppColors().blueColor,
                              isTextCenter: true,
                              isLoading: false,
                            ),
                          ),
                          // SizedBox(width: 5.w,),
                        ],
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mainContent(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        width: controller.isFilterOpen ? 1555 : 1860,
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
                  itemCount: controller.arrPlList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return profitAndLossContent(context, index);
                  }),
            ),
            Container(
              height: 2.h,
              color: AppColors().headerBgColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget profitAndLossContent(BuildContext context, int index) {
    var plObj = controller.arrPlList[index];
    return GestureDetector(
      onTap: () {
        controller.update();
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            valueBox(
                plObj.userName ?? "", 33, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index,
                isBig: true, isUnderlined: true, onClickValue: () {
              showUserDetailsPopUp(userId: plObj.userId!, userName: plObj.userName!);
            }),
            valueBox(
                plObj.roleName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index,
                isBig: true),
            valueBox(
                plObj.totalProfitLossValue.toStringAsFixed(2),
                45,
                index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                plObj.totalProfitLossValue < 0
                    ? AppColors().redColor
                    : plObj.totalProfitLossValue > 0
                        ? AppColors().greenColor
                        : AppColors().darkText,
                index,
                isBig: true),
            valueBox(
                plObj.role == UserRollList.master
                    ? plObj.profitAndLossSharing.toString()
                    : plObj.profitAndLossSharingDownLine.toString(),
                45,
                index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                AppColors().darkText,
                index,
                isBig: true),
            valueBox(
                plObj.totalProfitLossValue == 0.00
                    ? "0.00"
                    : ((plObj.totalProfitLossValue *
                                (plObj.role == UserRollList.master
                                    ? plObj.profitAndLossSharing!
                                    : plObj.profitAndLossSharingDownLine!) /
                                100) *
                            -1)
                        .toStringAsFixed(2),
                45,
                index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                (plObj.totalProfitLossValue *
                            (plObj.role == UserRollList.master
                                ? plObj.profitAndLossSharing!
                                : plObj.profitAndLossSharingDownLine!) /
                            100) >
                        0
                    ? AppColors().redColor
                    : (plObj.totalProfitLossValue *
                                (plObj.role == UserRollList.master
                                    ? plObj.profitAndLossSharing!
                                    : plObj.profitAndLossSharingDownLine!) /
                                100) <
                            0
                        ? AppColors().greenColor
                        : AppColors().darkText,
                index,
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

        titleBox("Username", isBig: true),
        titleBox("User Type", isBig: true),
        titleBox("Profit & Loss", isBig: true),
        titleBox("PL Share(%)", isBig: true),
        titleBox("PL Share Amount", isBig: true),
      ],
    );
  }
}
