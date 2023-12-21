import 'dart:async';

import 'package:get/get.dart';
import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';

import 'package:marketdesktop/screens/UserDetailPopups/userWisePLSummaryPopUp/userWisePLSummaryPopUpController.dart';

import 'package:responsive_framework/responsive_framework.dart';

import '../../../../constant/index.dart';

class UserWisePLSummaryPopUpScreen extends BaseView<UserWisePLSummaryPopUpController> {
  const UserWisePLSummaryPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return Future.value(false);
        },
        child: GestureDetector(
          onTap: () {},
          child: Column(
            children: [
              headerViewContent(context),
              Expanded(
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
            ],
          ),
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
            const SizedBox(
              width: 10,
            ),
            Image.asset(
              AppImages.appLogo,
              width: 3.h,
              height: 3.h,
            ),
            const SizedBox(
              width: 10,
            ),
            Text("User Wise Profit & Loss Summary",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().blueColor,
                )),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Get.back();
                Get.delete<UserWisePLSummaryPopUpController>();
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
            const SizedBox(
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
      duration: const Duration(milliseconds: 100),
      child: Offstage(
        offstage: !controller.isFilterOpen,
        child: Column(
          children: [
            const SizedBox(
              width: 35,
            ),
            SizedBox(
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text("Filter",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: CustomFonts.family1SemiBold,
                        color: AppColors().darkText,
                      )),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      controller.isFilterOpen = false;
                      controller.update();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      width: 30,
                      height: 30,
                      color: Colors.transparent,
                      child: Image.asset(
                        AppImages.closeIcon,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
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
                    height: 4.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Text("Username:",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: CustomFonts.family1Regular,
                              color: AppColors().fontColor,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        userListDropDown(controller.selectedUser),
                        const SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
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
    );
  }

  Widget mainContent(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          valueBox("", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index,
              isImage: true, strImage: AppImages.viewIcon, isSmall: true, onClickImage: () {
            showUserDetailsPopUp(userId: plObj.userId!, userName: plObj.userName!);
          }),
          valueBox(
              plObj.userName ?? "", 33, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index,
              isBig: true, isUnderlined: true, onClickValue: () {
            showUserDetailsPopUp(userId: plObj.userId!, userName: plObj.userName!);
          }),
          valueBox(
              plObj.childUserProfitLossTotal!.toStringAsFixed(2),
              45,
              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
              plObj.totalProfitLossValue < 0
                  ? AppColors().redColor
                  : plObj.totalProfitLossValue > 0
                      ? AppColors().greenColor
                      : AppColors().darkText,
              index,
              isBig: true),
          valueBox(plObj.childUserBrokerageTotal!.toStringAsFixed(2), 45,
              index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index,
              isBig: true),
          valueBox(
              plObj.totalProfitLossValue.toStringAsFixed(2),
              45,
              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
              plObj.totalProfitLossValue > 0
                  ? AppColors().greenColor
                  : plObj.totalProfitLossValue < 0
                      ? AppColors().redColor
                      : AppColors().darkText,
              index,
              isBig: true),
          valueBox(
              plObj.plWithBrk.toStringAsFixed(2),
              45,
              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
              plObj.plWithBrk > 0
                  ? AppColors().greenColor
                  : plObj.plWithBrk < 0
                      ? AppColors().redColor
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
          valueBox(plObj.brokerageTotal!.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
              AppColors().darkText, index,
              isBig: true),
          valueBox(
              plObj.netPL.toStringAsFixed(2),
              45,
              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
              plObj.netPL > 0
                  ? AppColors().greenColor
                  : plObj.netPL < 0.0
                      ? AppColors().redColor
                      : AppColors().darkText,
              index,
              isBig: true),
        ],
      ),
    );
  }

  Widget listTitleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        titleBox("View", isSmall: true),
        titleBox("Username", isBig: true),
        titleBox("Client P/L", isBig: true),
        titleBox("Client Brk", isBig: true),
        titleBox("Client M2M", isBig: true),
        titleBox("P/L With Brk", isBig: true),
        titleBox("P/L Share %", isBig: true),
        titleBox("Brk", isBig: true),
        titleBox("Net P/L", isBig: true),
      ],
    );
  }
}
