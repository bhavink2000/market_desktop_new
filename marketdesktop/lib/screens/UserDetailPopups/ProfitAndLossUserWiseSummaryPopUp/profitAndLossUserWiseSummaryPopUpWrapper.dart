import 'dart:async';

import 'package:get/get.dart';
import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/customWidgets/appScrollBar.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/UserDetailPopups/ProfitAndLossSummaryPopUp/profitAndLossSummaryPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/ProfitAndLossUserWiseSummaryPopUp/profitAndLossUserWiseSummaryPopUpController.dart';

import '../../../../constant/index.dart';

import 'package:responsive_framework/responsive_framework.dart';

import '../../../constant/utilities.dart';

class ProfitAndLossUserWiseSummaryPopUpScreen extends BaseView<ProfitAndLossUserWiseSummaryPopUpController> {
  const ProfitAndLossUserWiseSummaryPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return Future.value(false);
        },
        child: Column(
          children: [
            headerViewContent(context),
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

  Widget headerViewContent(BuildContext context) {
    return Container(
        width: 100.w,
        height: 4.h,
        decoration: BoxDecoration(
            color: AppColors().whiteColor,
            border: Border(
              bottom: BorderSide(color: AppColors().lightOnlyText, width: 1),
            )),
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Image.asset(
              AppImages.appLogo,
              width: 3.h,
              height: 3.h,
            ),
            SizedBox(
              width: 10,
            ),
            Text("Client Wise Profit & Loss Summary",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().blueColor,
                )),
            Spacer(),
            GestureDetector(
              onTap: () {
                Get.back();
                Get.delete<ProfitAndLossSummaryPopUpController>();
              },
              child: Container(
                width: 3.h,
                height: 3.h,
                padding: EdgeInsets.all(0.5.h),
                child: Image.asset(
                  AppImages.closeIcon,
                  color: AppColors().redColor,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ));
  }

  Widget filterContent(BuildContext context) {
    return AnimatedContainer(
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
                    height: 4.h,
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
                  Container(
                    height: 4.h,
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
                        exchangeTypeDropDown(controller.selectedExchange),
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
                        width: 6.w,
                        height: 3.h,
                        child: CustomButton(
                          isEnabled: true,
                          shimmerColor: AppColors().whiteColor,
                          title: "View",
                          textSize: 14,
                          onPress: () {},
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
                            controller.fromDate.value = "";
                            controller.endDate.value = "";
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
    return CustomScrollBar(
      bgColor: AppColors().blueColor,
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          width: 1120,
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
                child: CustomScrollBar(
                  bgColor: AppColors().blueColor,
                  child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      clipBehavior: Clip.hardEdge,
                      itemCount: 5,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return orderContent(context, index);
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget orderContent(BuildContext context, int index) {
    // var scriptValue = controller.arrUserOderList[index];
    return GestureDetector(
      onTap: () {
        controller.update();
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            valueBox("MAN07", 30, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index,
                isUnderlined: true, isBig: true, onClickValue: () {
              showUserDetailsPopUp();
            }),
            valueBox(
                "MCX GOLD Oct 05", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().blueColor, index,
                isBig: true),
            valueBox("Sell Limit", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().redColor, index),
            valueBox("5", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().redColor, index),
            valueBox("59074.00", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().redColor, index),
            valueBox("1000.00", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
            valueBox("0", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
            valueBox("Pending", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
            valueBox(
                "11-08-2023 17:53:42", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index,
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
        titleBox("Name", isBig: true),
        titleBox("Symbol", isBig: true),
        titleBox("Type"),
        titleBox("Quantity"),
        titleBox("Price"),
        titleBox("Brk"),
        titleBox("Deal"),
        titleBox("Status"),
        titleBox("Order Time", isBig: true),
      ],
    );
  }
}
