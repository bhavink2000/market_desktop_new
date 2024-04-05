import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/customWidgets/appScrollBar.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/settelementListModelClass.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constant/index.dart';
import 'package:marketdesktop/screens/UserDetailPopups/SettlementPopUp/settlementPopUpController.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../constant/screenColumnData.dart';
import '../../../constant/utilities.dart';
import '../../../customWidgets/appButton.dart';
import '../../MainContainerScreen/mainContainerController.dart';

class SettlementPopUpScreen extends BaseView<SettlementPopUpController> {
  const SettlementPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return Future.value(false);
        },
        child: GestureDetector(
          onTap: () {
            // controller.focusNode.requestFocus();
          },
          child: Column(
            children: [
              headerViewContent(
                  title: "Settlement",
                  isFilterAvailable: false,
                  isFromMarket: false,
                  closeClick: () {
                    Get.find<MainContainerController>().onKeyHite();
                  }),
              Expanded(
                child: Row(
                  children: [
                    filterPanel(context, bottomMargin: 0, isRecordDisplay: false, onCLickFilter: () {
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
          ),
        ));
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
          width: controller.isFilterOpen ? 270 : 0,
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
                      Container(
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Container(
                              child: Text("From:",
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
                                  height: 35,
                                  width: 150,
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
                                        width: 5,
                                      ),
                                      Text(
                                        controller.fromDate.value,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: CustomFonts.family1Medium,
                                          color: AppColors().darkText,
                                        ),
                                      ),
                                      const Spacer(),
                                      Image.asset(
                                        AppImages.calendarIcon,
                                        width: 25,
                                        height: 25,
                                        color: AppColors().fontColor,
                                      )
                                    ],
                                  ),
                                );
                              }),
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
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // SizedBox(
                            //   width: 30,
                            // ),
                            Spacer(),

                            Container(
                              child: Text("To:",
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
                                  height: 35,
                                  width: 150,
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
                                        width: 5,
                                      ),
                                      Text(
                                        controller.endDate.value,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontFamily: CustomFonts.family1Medium,
                                          color: AppColors().darkText,
                                        ),
                                      ),
                                      const Spacer(),
                                      Image.asset(
                                        AppImages.calendarIcon,
                                        width: 25,
                                        height: 25,
                                        color: AppColors().fontColor,
                                      )
                                    ],
                                  ),
                                );
                              }),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 35,
                            child: CustomButton(
                              isEnabled: true,
                              shimmerColor: AppColors().whiteColor,
                              title: "View",
                              textSize: 14,
                              onPress: () {
                                controller.getSettelementList(isFrom: 1);
                              },
                              focusKey: controller.viewFocus,
                              borderColor: Colors.transparent,
                              focusShadowColor: AppColors().blueColor,
                              bgColor: AppColors().blueColor,
                              isFilled: true,
                              textColor: AppColors().whiteColor,
                              isTextCenter: true,
                              isLoading: controller.isApiCallFromSearch,
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
                              shimmerColor: AppColors().blueColor,
                              title: "Clear",
                              textSize: 14,
                              prefixWidth: 0,
                              onPress: () {
                                controller.fromDate.value = shortDateForBackend(controller.findFirstDateOfTheWeek(DateTime.now()));
                                controller.endDate.value = shortDateForBackend(controller.findLastDateOfTheWeek(DateTime.now()));
                                controller.getSettelementList();
                                controller.getSettelementList(isFrom: 2);
                              },
                              bgColor: AppColors().whiteColor,
                              isFilled: true,
                              focusKey: controller.clearFocus,
                              borderColor: Colors.transparent,
                              focusShadowColor: AppColors().blueColor,
                              textColor: AppColors().blueColor,
                              isTextCenter: true,
                              isLoading: controller.isApiCallFromReset,
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
        // width: 70.2.w,
        // margin: EdgeInsets.only(right: 1.w),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: controller.isFilterOpen ? 35.w : 43.5.w,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
              child: Column(
                children: [
                  Container(
                    height: 3.h,
                    decoration: BoxDecoration(color: AppColors().whiteColor, border: Border(bottom: BorderSide(color: AppColors().lightOnlyText, width: 1))),
                    child: Center(
                      child: Text("Profit",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: CustomFonts.family1Medium,
                            color: AppColors().greenColor,
                          )),
                    ),
                  ),
                  Container(
                    height: 3.h,
                    color: AppColors().whiteColor,
                    child: listTitleContent(controller),
                  ),
                  Expanded(
                    child: controller.isApiCallFirstTime == false && controller.isApiCallFromReset == false && controller.isApiCallFromSearch == false && controller.arrProfitList.isEmpty
                        ? dataNotFoundView("Profit history not found")
                        : CustomScrollBar(
                            bgColor: AppColors().blueColor,
                            child: ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                clipBehavior: Clip.hardEdge,
                                itemCount: controller.isApiCallFirstTime || controller.isApiCallFromReset || controller.isApiCallFromSearch ? 50 : controller.arrProfitList.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return profitLossContent(context, index, controller.isApiCallFirstTime || controller.isApiCallFromReset || controller.isApiCallFromSearch ? Profit() : controller.arrProfitList[index]);
                                }),
                          ),
                  ),
                  if (controller.isApiCallFirstTime == false)
                    Container(
                      height: 3.h,
                      decoration: BoxDecoration(color: AppColors().whiteColor, border: Border(top: BorderSide(color: AppColors().lightOnlyText, width: 1))),
                      child: Center(
                          child: Row(
                        children: [
                          totalContent(value: "Net Profit ${controller.totalValues!.plStatus == 1 ? ": " + controller.totalValues!.myPLTotal!.toStringAsFixed(2) : ""}", textColor: AppColors().darkText, width: 230),
                          totalContent(value: controller.totalValues!.plProfitGrandTotal.toStringAsFixed(2), textColor: AppColors().darkText, width: 110),
                          totalContent(value: controller.totalValues!.brkProfitGrandTotal.toStringAsFixed(2), textColor: AppColors().darkText, width: 110),
                          totalContent(value: controller.totalValues!.profitGrandTotal.toStringAsFixed(2), textColor: AppColors().darkText, width: 110),
                        ],
                      )),
                    ),
                ],
              ),
            ),
            SizedBox(
              width: 3,
            ),
            Container(
              width: controller.isFilterOpen ? 35.w : 43.5.w,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
              child: Column(
                children: [
                  Container(
                    height: 3.h,
                    decoration: BoxDecoration(color: AppColors().whiteColor, border: Border(bottom: BorderSide(color: AppColors().lightOnlyText, width: 1))),
                    child: Center(
                      child: Text("Loss",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: CustomFonts.family1Medium,
                            color: AppColors().redColor,
                          )),
                    ),
                  ),
                  Container(
                    height: 3.h,
                    color: AppColors().whiteColor,
                    child: Row(
                      children: [
                        // Container(
                        //   width: 30,
                        // ),
                        listTitleContent(controller),
                      ],
                    ),
                  ),
                  Expanded(
                    child: controller.isApiCallFirstTime == false && controller.isApiCallFromReset == false && controller.isApiCallFromSearch == false && controller.arrLossList.isEmpty
                        ? dataNotFoundView("Loss history not found")
                        : CustomScrollBar(
                            bgColor: AppColors().blueColor,
                            child: ListView.builder(
                                physics: const ClampingScrollPhysics(),
                                clipBehavior: Clip.hardEdge,
                                itemCount: controller.isApiCallFirstTime || controller.isApiCallFromReset || controller.isApiCallFromSearch ? 50 : controller.arrLossList.length,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return profitLossContent(context, index, controller.isApiCallFirstTime || controller.isApiCallFromReset || controller.isApiCallFromSearch ? Profit() : controller.arrLossList[index]);
                                }),
                          ),
                  ),
                  if (controller.isApiCallFirstTime == false)
                    Container(
                      height: 3.h,
                      decoration: BoxDecoration(color: AppColors().whiteColor, border: Border(top: BorderSide(color: AppColors().lightOnlyText, width: 1))),
                      child: Center(
                          child: Row(
                        children: [
                          totalContent(value: "Net Loss ${controller.totalValues!.plStatus == 0 ? ": " + controller.totalValues!.myPLTotal!.toStringAsFixed(2) : ""}", textColor: AppColors().darkText, width: 300),
                          totalContent(value: controller.totalValues!.plLossGrandTotal.toStringAsFixed(2), textColor: AppColors().darkText, width: 110),
                          totalContent(value: controller.totalValues!.brkLossGrandTotal.toStringAsFixed(2), textColor: AppColors().darkText, width: 110),
                          totalContent(value: controller.totalValues!.LossGrandTotal.toStringAsFixed(2), textColor: AppColors().darkText, width: 110),
                        ],
                      )),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget totalContent({String? value, Color? textColor, double? width}) {
    return Container(
      width: width ?? 6.w,
      padding: EdgeInsets.only(left: 5),
      decoration: BoxDecoration(color: AppColors().whiteColor, border: Border(top: BorderSide(color: AppColors().lightOnlyText, width: 1), bottom: BorderSide(color: AppColors().lightOnlyText, width: 1), right: BorderSide(color: AppColors().lightOnlyText, width: 1))),
      child: Text(value ?? "",
          style: TextStyle(
            fontSize: 12,
            fontFamily: CustomFonts.family1Medium,
            color: textColor ?? AppColors().redColor,
          )),
    );
  }

  Widget profitLossContent(BuildContext context, int index, Profit value) {
    if (controller.isApiCallFirstTime || controller.isApiCallFromReset || controller.isApiCallFromSearch) {
      return Container(
        margin: EdgeInsets.only(bottom: 3.h),
        child: Shimmer.fromColors(
            child: Container(
              height: 3.h,
              color: Colors.white,
            ),
            baseColor: AppColors().whiteColor,
            highlightColor: AppColors().grayBg),
      );
    } else {
      return Container(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: controller.arrListTitle1.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int indexT) {
                switch (controller.arrListTitle1[indexT].title) {
                  case SettlementColumns.username:
                    {
                      return dynamicValueBox1(value.displayName!, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, isUnderlined: value.userId != "", controller.arrListTitle1, onClickValue: () {
                        isSettlementPopUpOpen = true;
                        showSettlemetPopUp(value.userId!, value.displayName!);
                      });
                    }
                  case SettlementColumns.pl:
                    {
                      return dynamicValueBox1(
                        value.profitLoss!.toStringAsFixed(2),
                        index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                        AppColors().darkText,
                        index,
                        indexT,
                        controller.arrListTitle1,
                      );
                    }
                  case SettlementColumns.brk:
                    {
                      return dynamicValueBox1(value.brokerageTotal! < 0 ? (value.brokerageTotal! * -1).toStringAsFixed(2) : value.brokerageTotal!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                    }
                  case SettlementColumns.total:
                    {
                      return dynamicValueBox1(
                        value.total!.toStringAsFixed(2),
                        index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                        AppColors().darkText,
                        index,
                        indexT,
                        controller.arrListTitle1,
                      );
                    }

                  default:
                    {
                      return const SizedBox();
                    }
                }
              },
            ),
          ],
        ),
      );
    }
  }
}
