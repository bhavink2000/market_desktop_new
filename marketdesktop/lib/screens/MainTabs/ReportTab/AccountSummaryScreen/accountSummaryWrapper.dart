import 'package:get/get.dart';

import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/AccountSummaryScreen/accountSummaryController.dart';
import 'package:paginable/paginable.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constant/dropdownFunctions.dart';
import '../../../../constant/index.dart';
import '../../../../constant/utilities.dart';

class AccountSummaryScreen extends BaseView<AccountSummaryController> {
  const AccountSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
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
                      if (userData!.role != UserRollList.user)
                        SizedBox(
                          height: 10,
                        ),
                      if (userData!.role != UserRollList.user)
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
                      Container(
                        // height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 55,
                            ),
                            // Container(
                            //   width: 150,
                            //   child: Column(
                            //     children: <Widget>[
                            //       ListTile(
                            //         contentPadding: EdgeInsets.zero,
                            //         title: const Text(
                            //           'P/L',
                            //         ),
                            //         horizontalTitleGap: 0,
                            //         dense: true,
                            //         visualDensity: VisualDensity(vertical: -3),
                            //         titleTextStyle: TextStyle(
                            //           fontSize: 12,
                            //           fontFamily: CustomFonts.family1Regular,
                            //           color: AppColors().fontColor,
                            //         ),
                            //         leading: Radio<AccountSummaryType>(
                            //           value: AccountSummaryType.pl,
                            //           activeColor: AppColors().darkText,
                            //           groupValue: controller.selectedAccountSummaryType ?? null,
                            //           onChanged: (AccountSummaryType? value) {
                            //             controller.selectedAccountSummaryType = value;
                            //             controller.selectedType = constantValues!.transactionType![2];
                            //             controller.update();
                            //           },
                            //         ),
                            //       ),
                            //       ListTile(
                            //         contentPadding: EdgeInsets.zero,
                            //         title: const Text(
                            //           'Brk',
                            //         ),
                            //         horizontalTitleGap: 0,
                            //         dense: true,
                            //         visualDensity: VisualDensity(vertical: -3),
                            //         titleTextStyle: TextStyle(
                            //           fontSize: 12,
                            //           fontFamily: CustomFonts.family1Regular,
                            //           color: AppColors().fontColor,
                            //         ),
                            //         leading: Radio<AccountSummaryType>(
                            //           value: AccountSummaryType.brk,
                            //           activeColor: AppColors().darkText,
                            //           groupValue: controller.selectedAccountSummaryType ?? null,
                            //           onChanged: (AccountSummaryType? value) {
                            //             controller.selectedAccountSummaryType = value;
                            //             controller.selectedType = constantValues!.transactionType![1];
                            //             controller.update();
                            //           },
                            //         ),
                            //       ),
                            //       ListTile(
                            //         contentPadding: EdgeInsets.zero,
                            //         title: const Text(
                            //           'Credit',
                            //         ),
                            //         horizontalTitleGap: 0,
                            //         dense: true,
                            //         visualDensity: VisualDensity(vertical: -3),
                            //         titleTextStyle: TextStyle(
                            //           fontSize: 12,
                            //           fontFamily: CustomFonts.family1Regular,
                            //           color: AppColors().fontColor,
                            //         ),
                            //         leading: Radio<AccountSummaryType>(
                            //           value: AccountSummaryType.credit,
                            //           activeColor: AppColors().darkText,
                            //           groupValue: controller.selectedAccountSummaryType ?? null,
                            //           onChanged: (AccountSummaryType? value) {
                            //             controller.selectedAccountSummaryType = value;
                            //             controller.selectedType = constantValues!.transactionType!.first;
                            //             controller.update();
                            //           },
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // SizedBox(
                          //   width: 70,
                          // ),
                          SizedBox(
                            width: 80,
                            height: 35,
                            child: CustomButton(
                              isEnabled: true,
                              shimmerColor: AppColors().whiteColor,
                              title: "View",
                              textSize: 14,
                              focusKey: controller.viewFocus,
                              borderColor: Colors.transparent,
                              focusShadowColor: AppColors().blueColor,
                              onPress: () {
                                controller.arrAccountSummary.clear();
                                controller.currentPage = 1;
                                controller.accountSummaryList(isFromFilter: true);
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
                              shimmerColor: AppColors().blueColor,
                              title: "Clear",
                              textSize: 14,
                              prefixWidth: 0,
                              focusKey: controller.clearFocus,
                              focusShadowColor: AppColors().blueColor,
                              onPress: () {
                                controller.selectedUser.value = UserData();
                                controller.fromDate.value = "";
                                controller.endDate.value = "";
                                controller.selectedAccountSummaryType = null;
                                controller.selectedType = null;
                                controller.update();
                                controller.arrAccountSummary.clear();
                                controller.currentPage = 1;
                                controller.accountSummaryList(isFromClear: true, isFromFilter: true);
                              },
                              bgColor: AppColors().whiteColor,
                              isFilled: true,
                              borderColor: AppColors().blueColor,
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
        duration: Duration(milliseconds: 300),
        width: 98.w,
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
              child: controller.isApiCallRunning == false && controller.isResetCall == false && controller.arrAccountSummary.isEmpty
                  ? dataNotFoundView("Account Summary not found")
                  : PaginableListView.builder(
                      loadMore: () async {
                        if (controller.totalPage >= controller.currentPage) {
                          //print(controller.currentPage);
                          controller.accountSummaryList();
                        }
                      },
                      errorIndicatorWidget: (exception, tryAgain) => dataNotFoundView("Data not found"),
                      progressIndicatorWidget: displayIndicator(),
                      physics: const ClampingScrollPhysics(),
                      clipBehavior: Clip.hardEdge,
                      itemCount: controller.isApiCallRunning || controller.isResetCall ? 50 : controller.arrAccountSummary.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return tradeContent(context, index);
                      }),
            ),
            Container(
              height: 30,
              decoration: BoxDecoration(color: AppColors().whiteColor, border: Border(top: BorderSide(color: AppColors().lightOnlyText, width: 1))),
              child: Center(
                  child: Row(
                children: [
                  totalContent(value: "Total Amount", textColor: AppColors().darkText, width: 66.7.w),
                  totalContent(value: controller.totalAmount.toStringAsFixed(2), textColor: AppColors().darkText, width: 110),
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

  Widget tradeContent(BuildContext context, int index) {
    // var scriptValue = controller.arrUserOderList[index];
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
      return GestureDetector(
        onTap: () {
          // controller.selectedScriptIndex = index;
          controller.update();
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // valueBox(shortFullDateTime(controller.arrAccountSummary[index].createdAt!), 33, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              // valueBox(controller.arrAccountSummary[index].userName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isUnderlined: true, onClickValue: () {
              //   showUserDetailsPopUp(userId: controller.arrAccountSummary[index].userId!, userName: controller.arrAccountSummary[index].userName ?? "");
              // }),
              // valueBox(controller.arrAccountSummary[index].symbolName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isLarge: true),
              // valueBox(controller.arrAccountSummary[index].quantity.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              // valueBox(controller.arrAccountSummary[index].tradeType ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              // valueBox(controller.arrAccountSummary[index].price!.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              // valueBox(controller.arrAccountSummary[index].positionDataAveragePrice!.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              // valueBox(controller.arrAccountSummary[index].type ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              // valueBox(controller.arrAccountSummary[index].transactionType ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isForDate: true),
              // valueBox(controller.arrAccountSummary[index].amount!.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, onClickValue: () {
              //   controller.tradeID = controller.arrAccountSummary[index].tradeId!;
              //   controller.getTradeDetail();
              // }),
              // valueBox(controller.arrAccountSummary[index].closing!.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              // valueBox(controller.arrAccountSummary[index].positionDataQuantity!.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),

              valueBox(shortFullDateTime(controller.arrAccountSummary[index].createdAt!), 33, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isForDate: true),
              valueBox(controller.arrAccountSummary[index].userName ?? "", 33, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              valueBox((controller.arrAccountSummary[index].amount! + controller.arrAccountSummary[index].closing!).toStringAsFixed(2), 33, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              valueBox(controller.arrAccountSummary[index].amount!.toStringAsFixed(2), 33, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              valueBox(controller.arrAccountSummary[index].closing!.toStringAsFixed(2), 33, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              valueBox(controller.arrAccountSummary[index].comment ?? "", 33, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              valueBox(controller.arrAccountSummary[index].fromUserName ?? "", 33, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
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

        // titleBox("Date Time"),
        // titleBox("Username"),
        // titleBox("Symbol Name", isLarge: true),
        // titleBox("Qty"),
        // titleBox("Trade Type"),
        // titleBox("Price"),
        // titleBox("Average Price"),

        // titleBox("Type"),
        // titleBox("Transaction Type", isForDate: true),
        // titleBox("Amount"),
        // titleBox("Closing"),
        // titleBox("Open Qty"),

        titleBox("Date Time", isForDate: true),
        titleBox("Username"),
        titleBox("Opening"),
        titleBox("Amount"),
        titleBox("Closing"),
        titleBox("Comment"),
        titleBox("Action By"),
      ],
    );
  }
}
