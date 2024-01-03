import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/UserWisePLSummaryScreen/userWisePLSummaryController.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constant/index.dart';
import '../../../../constant/utilities.dart';

class UserWisePLSummaryScreen extends BaseView<UserWisePLSummaryController> {
  const UserWisePLSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Row(
        children: [
          filterPanel(context, isRecordDisplay: true, totalRecord: controller.arrPlList.length, onCLickFilter: () {
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
                            userListDropDown(controller.selectedUser, width: 150),
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
                              title: "Apply",
                              textSize: 14,
                              onPress: () {
                                // controller.selectedUserId = controller.selectedUser.value.userId!;
                                controller.getProfitLossList("");
                              },
                              focusKey: controller.applyFocus,
                              borderColor: Colors.transparent,
                              focusShadowColor: AppColors().blueColor,
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
                                controller.selectedUserId = "";
                                controller.getProfitLossList("", isFromClear: true);
                              },
                              bgColor: AppColors().whiteColor,
                              isFilled: true,
                              focusKey: controller.clearFocus,
                              borderColor: Colors.transparent,
                              focusShadowColor: AppColors().blueColor,
                              textColor: AppColors().blueColor,
                              isTextCenter: true,
                              isLoading: controller.isResetCall,
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
              child: controller.isApiCallRunning == false && controller.isResetCall == false && controller.arrPlList.isEmpty
                  ? dataNotFoundView("PL Summary not found")
                  : ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      clipBehavior: Clip.hardEdge,
                      itemCount: controller.isApiCallRunning || controller.isResetCall ? 50 : controller.arrPlList.length,
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
    if (controller.isApiCallRunning || controller.isResetCall) {
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
      var plObj = controller.arrPlList[index];
      return GestureDetector(
        onTap: () {
          controller.update();
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              valueBox("", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isImage: true, strImage: AppImages.viewIcon, isSmall: true, onClickImage: () {
                isUserViewPopUpOpen = true;
                showUserWisePLSummaryPopUp(userId: plObj.userId!, userName: plObj.userName!);
              }),
              valueBox(plObj.userName ?? "", 33, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true, isUnderlined: true, onClickValue: () {
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
                  isBig: false),
              valueBox(plObj.childUserBrokerageTotal!.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: false),
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
                  isBig: false),
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
              valueBox(plObj.role == UserRollList.master ? plObj.profitAndLossSharing.toString() : plObj.profitAndLossSharingDownLine.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true),
              valueBox(plObj.parentBrokerageTotal!.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: false),
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
                  isBig: false),
            ],
          ),
        ),
      );
    }
  }

  Widget listTitleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        titleBox("View", isSmall: true),
        titleBox("Username", isBig: true),
        titleBox("Client P/L", isBig: false),
        titleBox("Client Brk", isBig: false),
        titleBox("Client M2M", isBig: false),
        titleBox("P/L With Brk", isBig: true),
        titleBox("P/L Share %", isBig: true),
        titleBox("Brk", isBig: false),
        titleBox("Net P/L", isBig: false),
      ],
    );
  }
}
// view
// username
// client P/L  - childUserProfitLossTotal
// client Brk-childUserBrokerageTotal
// client m2m - childUserDataPosition
// P/L with Brk (client P/L + client Brk + client m2m)
// admin %
// Brk - parentBrokerageTotal (popup -> brokerageTotal)
// Net P/L (Brk + client P/L with Brk calculation with admin % )