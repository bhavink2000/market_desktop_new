import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/customWidgets/appScrollBar.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/WeeklyAdminScreen/weeklyAdminController.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constant/index.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../../constant/utilities.dart';

class WeeklyAdminScreen extends BaseView<WeeklyAdminController> {
  const WeeklyAdminScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                filterPanel(context, bottomMargin: 0, isRecordDisplay: true, onCLickFilter: () {
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
                            userListDropDown(controller.selectedUser, width: 200),
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
                              title: "View",
                              textSize: 14,
                              onPress: () {
                                controller.getWeeklyAdminList(isFromSubmit: true);
                              },
                              focusKey: controller.viewFocus,
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
                              shimmerColor: AppColors().blueColor,
                              title: "Clear",
                              textSize: 14,
                              prefixWidth: 0,
                              onPress: () {
                                controller.selectedUser.value = UserData();
                                controller.getWeeklyAdminList(isFromSubmit: false);
                              },
                              bgColor: AppColors().whiteColor,
                              isFilled: true,
                              focusKey: controller.clearFocus,
                              borderColor: Colors.transparent,
                              focusShadowColor: AppColors().blueColor,
                              textColor: AppColors().blueColor,
                              isTextCenter: true,
                              isLoading: controller.isApiClearCallRunning,
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
    return CustomScrollBar(
      bgColor: AppColors().blueColor,
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          width: controller.isFilterOpen ? 76.5.w : 96.w,
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
                child: controller.isApiCallRunning == false && controller.arrWeeklyAdmin.isEmpty
                    ? dataNotFoundView("Weekly Admin not found")
                    : CustomScrollBar(
                        bgColor: AppColors().blueColor,
                        child: ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            clipBehavior: Clip.hardEdge,
                            itemCount: controller.isApiCallRunning ? 50 : controller.arrWeeklyAdmin.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return orderContent(context, index);
                            }),
                      ),
              ),
              if (controller.arrWeeklyAdmin.isNotEmpty)
                Container(
                  height: 2.h,
                  child: Center(
                      child: Row(
                    children: [
                      totalContent(value: "Total", textColor: AppColors().darkText, width: 480),
                      totalContent(value: controller.getTotal("ReleasedPl").toStringAsFixed(2), textColor: controller.getColor(controller.getTotal("ReleasedPl")), width: 110),
                      totalContent(value: controller.getTotal("M2mPL").toStringAsFixed(2), textColor: controller.getColor(controller.getTotal("M2mPL")), width: 110),
                      totalContent(value: controller.getTotal("TotalPL").toStringAsFixed(2), textColor: controller.getColor(controller.getTotal("TotalPL")), width: 110),
                      totalContent(value: controller.getTotal("brk").toStringAsFixed(2), textColor: controller.getColor(controller.getTotal("brk")), width: 110),
                      totalContent(value: controller.getTotal("netPL").toStringAsFixed(2), textColor: controller.getColor(controller.getTotal("netPL")), width: 110),
                      totalContent(value: controller.getTotal("adminProfit").toStringAsFixed(2), textColor: controller.getColor(controller.getTotal("adminProfit")), width: 110),
                      totalContent(value: controller.getTotal("adminBrk").toStringAsFixed(2), textColor: controller.getColor(controller.getTotal("adminBrk")), width: 110),
                      totalContent(value: controller.getTotal("totalAdminBrk").toStringAsFixed(2), textColor: controller.getColor(controller.getTotal("totalAdminBrk")), width: 150),
                    ],
                  )),
                ),
              Container(
                height: 2.h,
                color: AppColors().headerBgColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget totalContent({String? value, Color? textColor, double? width}) {
    return Container(
      width: width ?? 6.w,
      padding: EdgeInsets.only(left: 5),
      decoration: BoxDecoration(color: AppColors().headerBgColor, border: Border(top: BorderSide(color: AppColors().lightOnlyText, width: 1), bottom: BorderSide(color: AppColors().lightOnlyText, width: 1), right: BorderSide(color: AppColors().lightOnlyText, width: 1))),
      child: Text(value ?? "",
          style: TextStyle(
            fontSize: 12,
            fontFamily: CustomFonts.family1Medium,
            color: textColor ?? AppColors().redColor,
          )),
    );
  }

  Widget orderContent(BuildContext context, int index) {
    if (controller.isApiCallRunning) {
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
      var adminValue = controller.arrWeeklyAdmin[index];
      return GestureDetector(
        onTap: () {
          controller.update();
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              valueBox(adminValue.userName ?? "", 30, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isUnderlined: true, onClickValue: () {
                showUserDetailsPopUp(userId: adminValue.userId!, userName: adminValue.userName ?? "");
              }),
              valueBox(adminValue.name ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true),
              valueBox(adminValue.profitAndLossSharing!.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              valueBox(adminValue.brkSharing.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              valueBox(adminValue.profitLoss!.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.getColor(adminValue.profitLoss!.toDouble()), index),
              valueBox(adminValue.totalProfitLossValue.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.getColor(adminValue.totalProfitLossValue), index),
              valueBox(adminValue.totalPl.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.getColor(adminValue.totalPl.toDouble()), index),
              valueBox(adminValue.brk.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.getColor(adminValue.brokerageTotal!.toDouble()), index),
              valueBox(adminValue.netPL.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.getColor(adminValue.netPL.toDouble()), index),
              valueBox(adminValue.adminProfit.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.getColor(adminValue.adminProfit.toDouble()), index, isBig: true),
              valueBox(adminValue.parentBrokerageTotal!.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.getColor(adminValue.parentBrokerageTotal!.toDouble()), index),
              valueBox(adminValue.totalAdminBrk.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.getColor(adminValue.totalAdminBrk.toDouble()), index, isBig: true),
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
        // titleBox("", 0),
        titleBox("Username"),
        titleBox("Name", isBig: true),
        titleBox("Admin %"),
        titleBox("Admin Brk %"),
        titleBox("Realised P/L"),
        titleBox("M2M P/L"),
        titleBox("Total P/L"),
        titleBox("Brk"),
        titleBox("Net P/L"),
        titleBox("Admin Profit", isBig: true),
        titleBox("Admin Brk"),
        titleBox("Total Admin", isBig: true),
      ],
    );
  }
}
