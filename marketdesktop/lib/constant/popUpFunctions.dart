import 'package:floating_dialog/floating_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/constant/index.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/MainContainerScreen/mainContainerController.dart';
import 'package:marketdesktop/screens/MainTabs/FileTab/AboutScreen/aboutUsController.dart';
import 'package:marketdesktop/screens/MainTabs/FileTab/AboutScreen/aboutUsWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/FileTab/ChangePasswordScreen/changePasswordController.dart';
import 'package:marketdesktop/screens/MainTabs/FileTab/ChangePasswordScreen/changePasswordWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ToolsTab/MarketTimingScreen/marketTimingScreenController.dart';
import 'package:marketdesktop/screens/MainTabs/ToolsTab/MarketTimingScreen/marketTimingScreenWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/UserTab/UserListScreen/LeverageUpdateScreen/leverageUpdateController.dart';
import 'package:marketdesktop/screens/MainTabs/UserTab/UserListScreen/LeverageUpdateScreen/leverageUpdateWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/MarketWatchScreen/FontChangePopUp/fontChangeController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/MarketWatchScreen/FontChangePopUp/fontChangeWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/MarketWatchScreen/ScriptDetailPopUp/scriptDetailPopupWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/MarketWatchScreen/marketWatchScriptInfoPopUpWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/tradeInfoPopUpWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/tradeListController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/AccountSummaryPopUp/accountSummaryPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/BrkPopUp/brkPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/CreditPopUp/creditPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/FilterPopup/filterPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/FilterPopup/filterPopUpWrapper.dart';
import 'package:marketdesktop/screens/UserDetailPopups/GroupSettingPopUp/groupSettingPopUpController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/MarketWatchScreen/MarketColumnPopUp/marketColumnWrapper.dart';
import 'package:marketdesktop/screens/UserDetailPopups/OpenPositionPopUpScreen/openPositionPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/OpenPositionPopUpScreen/openPositionPopUpWrapper.dart';
import 'package:marketdesktop/screens/UserDetailPopups/PositionPopUp/positionPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/ProfitAndLossSummaryPopUp/profitAndLossSummaryPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/ProfitAndLossSummaryPopUp/profitAndLossSummaryPopUpWrapper.dart';
import 'package:marketdesktop/screens/UserDetailPopups/ProfitAndLossUserWiseSummaryPopUp/profitAndLossUserWiseSummaryPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/ProfitAndLossUserWiseSummaryPopUp/profitAndLossUserWiseSummaryPopUpWrapper.dart';
import 'package:marketdesktop/screens/UserDetailPopups/QuantitySettingPopUp/quantitySettingPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/RejectionLogPopUp/rejectionLogPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/ShareDetailPopUp/shareDetailPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/ShareDetailPopUp/shareDetailPopUpWrapper.dart';
import 'package:marketdesktop/screens/UserDetailPopups/SuperAdminTradePopUp/superAdminTradePopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/SuperAdminTradePopUp/superAdminTradePopUpWrapper.dart';
import 'package:marketdesktop/screens/UserDetailPopups/TradeListPopUp/tradeListPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/UserListPopUp/userListPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/userDetailsPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/userWisePLSummaryPopUp/userWisePLSummaryPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/userWisePLSummaryPopUp/userWisePLSummaryPopUpWrapper.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../screens/UserDetailPopups/userDetailsPopUpWrapper.dart';
import 'color.dart';

showUserDetailsPopUp({String userId = "", String userName = "", String roll = ""}) async {
  bool isAvailable = Get.isRegistered<UserDetailsPopUpController>();
  if (isAvailable) {
    Get.back();
    await Get.find<UserDetailsPopUpController>().deleteAllController();
    await Get.delete<UserDetailsPopUpController>();

    Get.put(UserDetailsPopUpController());
  } else {
    Get.put(UserDetailsPopUpController());
  }

  isUserDetailPopUpOpen = true;
  Future.delayed(Duration(milliseconds: 200), () async {
    Get.find<PositionPopUpController>().selectedUserId = userId;
    var detailVC = Get.find<UserDetailsPopUpController>();
    detailVC.userName = userName;
    detailVC.userId = userId;
    detailVC.userRoll = roll;
    await detailVC.getUSerInfo();

    var positionVC = Get.find<PositionPopUpController>();
    positionVC.getPositionList("");

    var tradeVC = Get.find<TradeListPopUpController>();
    tradeVC.selectedUserId = userId;
    tradeVC.getTradeList();

    var creditVC = Get.find<CreditPopUpController>();
    creditVC.selectedUserId = userId;
    creditVC.getCreditList();
    creditVC.getUSerInfo();

    // var summaryVc = Get.find<AccountSummaryPopUpController>();
    // summaryVc.selectedUserId = userId;
    // summaryVc.accountSummaryList();

    var rejectionVC = Get.find<RejectionLogPopUpController>();
    rejectionVC.selectedUserId = userId;
    rejectionVC.rejectLogList();

    var groupSettingVc = Get.find<GroupSettingPopUpController>();
    groupSettingVc.selectedUserId = userId;
    groupSettingVc.groupSettingList();

    var qtySettingVC = Get.find<QuantitySettingPopUpController>();
    
    qtySettingVC.selectedUserId = userId;
    // Get.find<QuantitySettingPopUpController>().quantitySettingList();

    var brkVC = Get.find<BrkPopUpController>();
    brkVC.selectedUserId = userId;
    brkVC.getExchangeListUserWise(userId: userId);

    var userListVc = Get.find<UserListPopUpController>();
    userListVc.selectedUserId = userId;
    userListVc.getUserList();

    var shareVC = Get.find<ShareDetailPopUpController>();
    shareVC.selectedUserId = userId;
    shareVC.getUSerInfo();
  });

  showDialog<String>(
      context: Get.context!,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) => FloatingDialog(
            // titlePadding: EdgeInsets.zero,
            // backgroundColor: AppColors().bgColor,
            // surfaceTintColor: AppColors().bgColor,

            // contentPadding: EdgeInsets.zero,
            // insetPadding: EdgeInsets.symmetric(
            //   horizontal: 20.w,
            //   vertical: 32.h,
            // ),
            enableDragAnimation: false,
            child: Container(
              width: 1300,
              height: 60.h,
              decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
              child: UserDetailsPopUpScreen(),
            ),
          ));
}

showOpenPositionPopUp(String symbolId, String userId) {
  Get.put(OpenPositionPopUpController());
  Get.find<OpenPositionPopUpController>().symbolId = symbolId;
  Get.find<OpenPositionPopUpController>().selectedUserId = userId;
  Get.find<OpenPositionPopUpController>().getUSerInfo();
  Get.find<OpenPositionPopUpController>().getPositionList("");
  showDialog<String>(
      context: Get.context!,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) => FloatingDialog(
            // titlePadding: EdgeInsets.zero,
            // backgroundColor: AppColors().bgColor,
            // surfaceTintColor: AppColors().bgColor,

            // contentPadding: EdgeInsets.zero,
            // insetPadding: EdgeInsets.symmetric(
            //   horizontal: 20.w,
            //   vertical: 32.h,
            // ),
            enableDragAnimation: false,
            child: Container(
              width: 960,
              height: 60.h,
              decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
              child: OpenPositionPopUpScreen(),
            ),
          ));
}

showSuperAdminTradePopUp() {
  Get.put(SuperAdminTradePopUpController());

  showDialog<String>(
      context: Get.context!,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) => FloatingDialog(
            // titlePadding: EdgeInsets.zero,
            // backgroundColor: AppColors().bgColor,
            // surfaceTintColor: AppColors().bgColor,

            // contentPadding: EdgeInsets.zero,
            // insetPadding: EdgeInsets.symmetric(
            //   horizontal: 20.w,
            //   vertical: 32.h,
            // ),
            enableDragAnimation: false,
            child: Container(
              width: 25.w,
              height: 235,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors().lightOnlyText,
                    width: 1,
                  ),
                  color: AppColors().whiteColor),
              child: SuperAdminTradePopUpScreen(),
            ),
          ));
}

showUserWisePLSummaryPopUp({String userId = "", String userName = ""}) {
  Get.put(UserWisePLSummaryPopUpController());

  Get.find<UserWisePLSummaryPopUpController>().selectedUserId = userId;
  Get.find<UserWisePLSummaryPopUpController>().selectedUserName = userName;

  Get.find<UserWisePLSummaryPopUpController>().getProfitLossList("");
  showDialog<String>(
      context: Get.context!,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) => FloatingDialog(
            // titlePadding: EdgeInsets.zero,
            // backgroundColor: AppColors().bgColor,
            // surfaceTintColor: AppColors().bgColor,

            // contentPadding: EdgeInsets.zero,
            // insetPadding: EdgeInsets.symmetric(
            //   horizontal: 20.w,
            //   vertical: 32.h,
            // ),
            enableDragAnimation: false,
            child: Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
              child: UserWisePLSummaryPopUpScreen(),
            ),
          ));
}

showProfitAndLossSummaryPopUp() {
  Get.put(ProfitAndLossSummaryPopUpController());
  showDialog<String>(
      context: Get.context!,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) => FloatingDialog(
            // titlePadding: EdgeInsets.zero,
            // backgroundColor: AppColors().bgColor,
            // surfaceTintColor: AppColors().bgColor,

            // contentPadding: EdgeInsets.zero,
            // insetPadding: EdgeInsets.symmetric(
            //   horizontal: 20.w,
            //   vertical: 32.h,
            // ),
            enableDragAnimation: false,
            child: Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
              child: ProfitAndLossSummaryPopUpScreen(),
            ),
          ));
}

showProfitAndLossUserWiseSummaryPopUp() {
  Get.put(ProfitAndLossUserWiseSummaryPopUpController());
  showDialog<String>(
      context: Get.context!,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) => FloatingDialog(
            // titlePadding: EdgeInsets.zero,
            // backgroundColor: AppColors().bgColor,
            // surfaceTintColor: AppColors().bgColor,

            // contentPadding: EdgeInsets.zero,
            // insetPadding: EdgeInsets.symmetric(
            //   horizontal: 20.w,
            //   vertical: 32.h,
            // ),
            enableDragAnimation: false,
            child: Container(
              width: 60.w,
              height: 60.h,
              decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
              child: ProfitAndLossUserWiseSummaryPopUpScreen(),
            ),
          ));
}

showLeverageUpdatePopUp({UserData? selectedUser}) {
  var cpVC = Get.put(LeverageUpdateController());
  cpVC.selectedUser = selectedUser!;
  showDialog<String>(
      context: Get.context!,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) => FloatingDialog(
            // titlePadding: EdgeInsets.zero,
            // backgroundColor: AppColors().bgColor,
            // surfaceTintColor: AppColors().bgColor,

            // contentPadding: EdgeInsets.zero,
            // insetPadding: EdgeInsets.symmetric(
            //   horizontal: 20.w,
            //   vertical: 32.h,
            // ),
            enableDragAnimation: false,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 420,
                height: 210,
                color: Colors.transparent,
                child: LeverageUpdateScreen(),
              ),
            ),
          ));
}

showChangePasswordPopUp({String selectedUserId = ""}) {
  var cpVC = Get.put(ChangePasswordController());
  cpVC.selectedUserID = selectedUserId;
  showDialog<String>(
      context: Get.context!,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) => FloatingDialog(
            // titlePadding: EdgeInsets.zero,
            // backgroundColor: AppColors().bgColor,
            // surfaceTintColor: AppColors().bgColor,

            // contentPadding: EdgeInsets.zero,
            // insetPadding: EdgeInsets.symmetric(
            //   horizontal: 20.w,
            //   vertical: 32.h,
            // ),
            enableDragAnimation: false,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 420,
                height: selectedUserId == "" ? 270 : 210,
                color: Colors.transparent,
                child: ChangePasswordScreen(),
              ),
            ),
          ));
}

showMarketColumnPopUp() {
  Get.put(MarketColumnController());
  showDialog<String>(
      context: Get.context!,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) => FloatingDialog(
            // titlePadding: EdgeInsets.zero,
            // backgroundColor: AppColors().bgColor,
            // surfaceTintColor: AppColors().bgColor,

            // contentPadding: EdgeInsets.zero,
            // insetPadding: EdgeInsets.symmetric(
            //   horizontal: 20.w,
            //   vertical: 32.h,
            // ),
            enableDragAnimation: false,
            child: Container(
              width: 20.w,
              height: 40.h,
              decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
              child: marketColumnScreen(),
            ),
          ));
}

showSharingDetailPopup() {
  Get.put(ShareDetailPopUpController());
  showDialog<String>(
      context: Get.context!,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) => FloatingDialog(
            // titlePadding: EdgeInsets.zero,
            // backgroundColor: AppColors().bgColor,
            // surfaceTintColor: AppColors().bgColor,

            // contentPadding: EdgeInsets.zero,
            // insetPadding: EdgeInsets.symmetric(
            //   horizontal: 20.w,
            //   vertical: 32.h,
            // ),
            enableDragAnimation: false,
            child: Container(
              // width: 30.w,
              // height: 28.h,
              width: 50.w,
              height: 40.h,
              decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
              child: ShareDetailPopUpScreen(),
            ),
          ));
}

showFontChangePopup() {
  Get.put(FontChangeController());
  showDialog<String>(
      context: Get.context!,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) => FloatingDialog(
            // titlePadding: EdgeInsets.zero,
            // backgroundColor: AppColors().bgColor,
            // surfaceTintColor: AppColors().bgColor,

            // contentPadding: EdgeInsets.zero,
            // insetPadding: EdgeInsets.symmetric(
            //   horizontal: 20.w,
            //   vertical: 32.h,
            // ),
            enableDragAnimation: false,
            child: Container(
              // width: 30.w,
              // height: 28.h,
              width: 535,
              height: 400,
              decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
              child: FontChangeScreen(),
            ),
          ));
}

showFilterPopup() {
  Get.put(FilterPopUpController());
  showDialog<String>(
      context: Get.context!,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) => FloatingDialog(
            // titlePadding: EdgeInsets.zero,
            // backgroundColor: AppColors().bgColor,
            // surfaceTintColor: AppColors().bgColor,

            // contentPadding: EdgeInsets.zero,
            // insetPadding: EdgeInsets.symmetric(
            //   horizontal: 20.w,
            //   vertical: 32.h,
            // ),
            enableDragAnimation: false,
            child: Container(
              // width: 30.w,
              // height: 28.h,
              width: 50.w,
              height: 40.h,
              decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
              child: FilterPopUpScreen(),
            ),
          ));
}

showScriptDetailPopUp() {
  showDialog<String>(
      context: Get.context!,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) => FloatingDialog(
            // titlePadding: EdgeInsets.zero,
            // backgroundColor: AppColors().bgColor,
            // surfaceTintColor: AppColors().bgColor,

            // contentPadding: EdgeInsets.zero,
            // insetPadding: EdgeInsets.symmetric(
            //   horizontal: 20.w,
            //   vertical: 32.h,
            // ),
            enableDragAnimation: false,
            child: StatefulBuilder(builder: (context, setState) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 50.w,
                  child: ScriptDetailPopUpScreen(),
                ),
              );
            }),
          ));
}

showAboutUsPopup() {
  Get.put(AboutUsPopUpController());
  showDialog<String>(
      context: Get.context!,
      // barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (BuildContext context) => FloatingDialog(
            // titlePadding: EdgeInsets.zero,
            // backgroundColor: AppColors().bgColor,
            // surfaceTintColor: AppColors().bgColor,

            // contentPadding: EdgeInsets.zero,
            // insetPadding: EdgeInsets.symmetric(
            //   horizontal: 20.w,
            //   vertical: 32.h,
            // ),
            enableDragAnimation: false,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 950,
                height: 300,
                decoration: BoxDecoration(color: AppColors().whiteColor, border: Border.all(color: Colors.transparent, width: 1)),
                child: AboutUsPopUpScreen(),
              ),
            ),
          ));
}

showMarketTimingPopup() {
  Get.put(MarketTimingController());
  showDialog<String>(
      context: Get.context!,
      // barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (BuildContext context) => FloatingDialog(
            // titlePadding: EdgeInsets.zero,
            // backgroundColor: AppColors().bgColor,
            // surfaceTintColor: AppColors().bgColor,

            // contentPadding: EdgeInsets.zero,
            // insetPadding: EdgeInsets.symmetric(
            //   horizontal: 20.w,
            //   vertical: 32.h,
            // ),
            enableDragAnimation: false,
            child: Container(
              // width: 30.w,
              // height: 28.h,
              width: 400,
              height: 600,
              decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
              child: MarketTimingScreen(),
            ),
          ));
}

showPendingTradeInfoPopup() {
  Get.put(TradeListController());
  showDialog<String>(
      context: Get.context!,
      // barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (BuildContext context) => FloatingDialog(
            // titlePadding: EdgeInsets.zero,
            // backgroundColor: AppColors().bgColor,
            // surfaceTintColor: AppColors().bgColor,

            // contentPadding: EdgeInsets.zero,
            // insetPadding: EdgeInsets.symmetric(
            //   horizontal: 20.w,
            //   vertical: 32.h,
            // ),
            enableDragAnimation: false,
            child: Container(
              // width: 30.w,
              // height: 28.h,
              color: AppColors().whiteColor,
              width: 500,
              height: 71.h,

              child: TradeInfoPopUpScreen(),
            ),
          ));
}

showScriptInfoPopup() {
  showDialog<String>(
      context: Get.context!,
      // barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (BuildContext context) => FloatingDialog(
            // titlePadding: EdgeInsets.zero,
            // backgroundColor: AppColors().bgColor,
            // surfaceTintColor: AppColors().bgColor,

            // contentPadding: EdgeInsets.zero,
            // insetPadding: EdgeInsets.symmetric(
            //   horizontal: 20.w,
            //   vertical: 32.h,
            // ),
            enableDragAnimation: false,
            child: Container(
              // width: 30.w,
              // height: 28.h,
              color: AppColors().whiteColor,
              width: 500,
              height: 480,

              child: MArketWatchScriptInfoPopUpScreen(),
            ),
          ));
}

generalContainerPopup({Widget? view, String title = "", bool showTrailingIcons = false, bool isFilterAvailable = false, Function? filterClick, Function? pdfClick, Function? excelClick}) {
  showDialog<String>(
      context: Get.context!,
      // barrierColor: Colors.transparent,
      barrierDismissible: false,
      builder: (BuildContext context) => FloatingDialog(
            enableDragAnimation: false,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: AppColors().whiteColor,
                width: 95.w,
                height: 80.h,
                child: Column(
                  children: [
                    headerViewContent(title: title, isFilterAvailable: isFilterAvailable, pdfClick: pdfClick, excelClick: excelClick, filterClick: filterClick),
                    Expanded(child: view!),
                  ],
                ),
              ),
            ),
          ));
}

Widget headerViewContent({String title = "", bool isFromMarket = false, bool isFilterAvailable = false, Function? filterClick, Function? pdfClick, Function? excelClick, Function? closeClick}) {
  return Container(
      width: 100.w,
      height: 35,
      decoration: BoxDecoration(
        gradient: AppColors().customGradient,
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Image.asset(
            AppImages.logoMain,
            width: 3.h,
            height: 3.h,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(title,
              style: TextStyle(
                fontSize: 16,
                fontFamily: CustomFonts.family1Medium,
                color: AppColors().darkText,
              )),
          const Spacer(),
          if (isFilterAvailable)
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (pdfClick != null) {
                      pdfClick();
                    }
                  },
                  child: Image.asset(
                    AppImages.pdfIcon,
                    width: 30,
                    height: 30,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    if (excelClick != null) {
                      excelClick();
                    }
                  },
                  child: Image.asset(
                    AppImages.excelIcon,
                    width: 25,
                    height: 25,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    if (filterClick != null) {
                      filterClick();
                    }
                  },
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Icon(
                      Icons.tune,
                      size: 25,
                      color: AppColors().blueColor,
                    ),
                  ),
                  // child: Text("Filter",
                  //     style: TextStyle(
                  //       fontSize: 14,
                  //       fontFamily: CustomFonts.family1Medium,
                  //       color: AppColors().fontColor,
                  //     )),
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
          if (isFromMarket == false)
            GestureDetector(
              onTap: () {
                if (closeClick != null) {
                  closeClick();
                } else {
                  isCommonScreenPopUpOpen = false;

                  Get.find<MainContainerController>().onKeyHite();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: AppColors().customReverseGradient,
                  color: AppColors().redColor,
                ),
                width: 3.h,
                height: 3.h,
                padding: EdgeInsets.all(0.85.h),
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
