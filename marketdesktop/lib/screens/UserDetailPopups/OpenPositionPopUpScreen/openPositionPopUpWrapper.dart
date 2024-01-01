import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:marketdesktop/constant/color.dart';
import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/UserDetailPopups/OpenPositionPopUpScreen/openPositionPopUpController.dart';
import '../../../constant/index.dart';

import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OpenPositionPopUpScreen extends BaseView<OpenPositionPopUpController> {
  const OpenPositionPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return Future.value(false);
        },
        child: Column(
          children: [
            headerViewContent(
                title: "Open Position",
                isFilterAvailable: false,
                isFromMarket: false,
                closeClick: () {
                  Get.back();
                  Get.delete<OpenPositionPopUpController>();
                }),
            Expanded(
              child: Row(
                children: [
                  filterPanel(context, bottomMargin: 0, onCLickFilter: () {
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
          ],
        ));
  }

  Widget filterContent(BuildContext context) {
    return AnimatedContainer(
      // margin: EdgeInsets.only(bottom: 2.h),
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
              color: AppColors().headerBgColor,
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
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 35,
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
                  Container(
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Container(
                          child: Text("Exchange:",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: CustomFonts.family1Regular,
                                color: AppColors().fontColor,
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        exchangeTypeDropDown(controller.selectedExchange, width: 250),
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
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Container(
                          child: Text("Symbols:",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: CustomFonts.family1Regular,
                                color: AppColors().fontColor,
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        allScriptListDropDown(controller.selectedScriptFromFilter),
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
                        width: 80,
                        height: 35,
                        child: CustomButton(
                          isEnabled: true,
                          shimmerColor: AppColors().whiteColor,
                          title: "Apply",
                          textSize: 14,
                          onPress: () {
                            controller.getPositionList("");
                          },
                          bgColor: AppColors().blueColor,
                          isFilled: true,
                          textColor: AppColors().whiteColor,
                          isTextCenter: true,
                          isLoading: controller.isApiCallRunning,
                        ),
                      ),
                      SizedBox(
                        width: 1.w,
                      ),
                      SizedBox(
                        width: 80,
                        height: 35,
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
                            controller.getPositionList("");
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
    );
  }

  Widget mainContent(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        width: 1870,
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
                  itemCount: controller.arrPositionScriptList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return orderContent(context, index);
                  }),
            ),
            if (controller.selectedUserData != null)
              Container(
                height: 30,
                decoration: BoxDecoration(
                    color: AppColors().whiteColor,
                    border: Border(
                      top: BorderSide(color: AppColors().lightOnlyText, width: 1),
                    )),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        "PL : ${controller.selectedUserData?.profitLoss!.toStringAsFixed(2)}  | BK : ${controller.selectedUserData?.brokerageTotal!.toStringAsFixed(2)} | BAL :  ${controller.selectedUserData?.balance!.toStringAsFixed(2)} | CRD : ${controller.selectedUserData?.credit!.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
                    Spacer(),
                    Text("Total P/L : ${(controller.selectedUserData!.profitLoss! + controller.selectedUserData!.brokerageTotal!).toStringAsFixed(2)}", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
                    SizedBox(
                      width: 200,
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget orderContent(BuildContext context, int index) {
    // var scriptValue = controller.arrUserOderList[index];
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          valueBox(controller.arrPositionScriptList[index].userName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isUnderlined: true, onClickValue: () {
            showUserDetailsPopUp(
              userId: controller.arrPositionScriptList[index].userId!,
              userName: controller.arrPositionScriptList[index].userName!,
            );
          }),
          IgnorePointer(
            child: valueBox(controller.arrPositionScriptList[index].parentUserName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
          ),
          IgnorePointer(
            child: valueBox(controller.arrPositionScriptList[index].exchangeName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
          ),
          IgnorePointer(
            child: valueBox(controller.arrPositionScriptList[index].symbolTitle ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isLarge: true),
          ),
          IgnorePointer(
            child: valueBox(controller.arrPositionScriptList[index].buyTotalQuantity.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().blueColor, index, isBig: true),
          ),
          IgnorePointer(
            child: valueBox(controller.arrPositionScriptList[index].buyPrice!.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true),
          ),
          IgnorePointer(
            child: valueBox(controller.arrPositionScriptList[index].sellTotalQuantity!.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().redColor, index, isBig: true),
          ),
          IgnorePointer(
            child: valueBox(controller.arrPositionScriptList[index].sellPrice!.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true),
          ),
          IgnorePointer(
            child: valueBox(
              controller.arrPositionScriptList[index].totalQuantity!.toString(),
              45,
              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
              AppColors().darkText,
              index,
            ),
          ),
          IgnorePointer(
            child: valueBox(
              controller.arrPositionScriptList[index].quantity.toString(),
              45,
              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
              AppColors().darkText,
              index,
            ),
          ),
          IgnorePointer(
            child: valueBox(
              controller.arrPositionScriptList[index].price!.toStringAsFixed(2),
              45,
              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
              AppColors().darkText,
              index,
            ),
          ),
          IgnorePointer(
            child: valueBox(
              controller.arrPositionScriptList[index].totalQuantity! < 0 ? controller.arrPositionScriptList[index].ask!.toStringAsFixed(2).toString() : controller.arrPositionScriptList[index].bid!.toStringAsFixed(2).toString(),
              45,
              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
              AppColors().darkText,
              index,
            ),
          ),
          IgnorePointer(
            child: valueBox(
              double.parse(controller.arrPositionScriptList[index].profitLossValue!.toStringAsFixed(2)).toString(),
              60,
              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
              controller.getPriceColor(controller.arrPositionScriptList[index].profitLossValue!),
              index,
            ),
          ),
          IgnorePointer(
            child: valueBox(
                controller.getPlPer(cmp: controller.arrPositionScriptList[index].totalQuantity! < 0 ? controller.arrPositionScriptList[index].ask! : controller.arrPositionScriptList[index].bid!, netAPrice: controller.arrPositionScriptList[index].price!).toStringAsFixed(3),
                45,
                index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                controller.getPlPer(cmp: controller.arrPositionScriptList[index].totalQuantity! < 0 ? controller.arrPositionScriptList[index].ask! : controller.arrPositionScriptList[index].bid!, netAPrice: controller.arrPositionScriptList[index].price!) > 0
                    ? AppColors().blueColor
                    : AppColors().redColor,
                index),
          ),
        ],
      ),
    );
  }

  Widget listTitleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        titleBox("Username"),
        titleBox("Parent User"),
        titleBox("Exchange"),
        titleBox("Symbol", isLarge: true),
        titleBox("Total Buy Qty", isBig: true),
        titleBox("Total Buy A Price", isBig: true),
        titleBox("Total Sell Qty", isBig: true),
        titleBox("Sell A Price", isBig: true),
        titleBox("Net Qty"),
        titleBox("Net Lot"),
        titleBox("Net A Price"),
        titleBox("CMP"),
        titleBox("P/L"),
        titleBox("P/L % Wise"),
      ],
    );
  }
}
