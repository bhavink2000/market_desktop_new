import 'package:get/get.dart';
import 'package:marketdesktop/customWidgets/appScrollBar.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/ClientAccountReportScreen/clientAccountReportController.dart';
import 'package:paginable/paginable.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constant/index.dart';
import '../../../../constant/screenColumnData.dart';
import '../../../../constant/utilities.dart';
import '../../../../customWidgets/appButton.dart';
import '../../../../modelClass/allSymbolListModelClass.dart';
import '../../../../modelClass/exchangeListModelClass.dart';
import '../../../../modelClass/myUserListModelClass.dart';

class ClientAccountReportScreen extends BaseView<ClientAccountReportController> {
  const ClientAccountReportScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Row(
        children: [
          filterPanel(context, bottomMargin: 0, isRecordDisplay: false, onCLickExcell: controller.onClickExcel, onCLickPDF: controller.onClickPDF, onCLickFilter: () {
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
                              userListDropDown(controller.selectedUser, width: 150, userController: (TextEditingController c) {
                                controller.searchUserController = c;
                              }),
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
                            exchangeTypeDropDown(controller.selectedExchange, onChange: () async {
                              await getScriptList(exchangeId: controller.selectedExchange.value.exchangeId!, arrSymbol: controller.arrExchangeWiseScript);
                              controller.update();
                            }, width: 150),
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
                            allScriptListDropDown(controller.selectedScriptFromFilter, arrSymbol: controller.arrExchangeWiseScript, width: 150),
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
                              child: Text("Type:",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: CustomFonts.family1Regular,
                                    color: AppColors().fontColor,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            productTypeForAccountDropDown(controller.selectedProductType, width: 150),
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
                              child: Text("P/L Type:",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: CustomFonts.family1Regular,
                                    color: AppColors().fontColor,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            plTypeForAccountDropDown(controller.selectedplType, width: 150),
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
                            height: 30,
                            child: CustomButton(
                              isEnabled: true,
                              shimmerColor: AppColors().whiteColor,
                              title: "View",
                              textSize: 14,
                              onPress: () {
                                controller.getAccountSummaryNewList("", isFromfilter: true);
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
                            height: 30,
                            child: CustomButton(
                              isEnabled: true,
                              shimmerColor: AppColors().blueColor,
                              title: "Clear",
                              textSize: 14,
                              prefixWidth: 0,
                              onPress: () async {
                                controller.selectedExchange.value = ExchangeData();
                                controller.selectedScriptFromFilter.value = GlobalSymbolData();
                                controller.searchUserController?.clear();
                                controller.selectedUser.value = UserData();
                                controller.fromDate.value = "";
                                controller.endDate.value = "";
                                controller.arrExchangeWiseScript.clear();
                                controller.isResetCall = true;
                                controller.update();
                                await getScriptList(exchangeId: "", arrSymbol: controller.arrExchangeWiseScript, isFromOrder: false);
                                controller.arrSummaryList.clear();
                                controller.isResetCall = false;
                                controller.update();
                                // await controller.getAccountSummaryNewList("", isFromClear: true);
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
    return CustomScrollBar(
      bgColor: AppColors().blueColor,
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: globalMaxWidth + 1000,
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
                    listTitleContent(controller),
                  ],
                ),
              ),
              Expanded(
                child: controller.isApiCallRunning == false && controller.isResetCall == false && controller.arrSummaryList.isEmpty
                    ? dataNotFoundView("Account Summary not found")
                    : CustomScrollBar(
                        bgColor: AppColors().blueColor,
                        child: PaginableListView.builder(
                            loadMore: () async {
                              if (controller.totalPage >= controller.currentPage) {
                                //print(controller.currentPage);
                                controller.getAccountSummaryNewList("");
                              }
                            },
                            errorIndicatorWidget: (exception, tryAgain) => dataNotFoundView("Data not found"),
                            progressIndicatorWidget: displayIndicator(),
                            physics: const ClampingScrollPhysics(),
                            clipBehavior: Clip.hardEdge,
                            itemCount: controller.isApiCallRunning || controller.isResetCall ? 50 : controller.arrSummaryList.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return tradeContent(context, index);
                            }),
                      ),
              ),
              Obx(() {
                return Container(
                  height: 3.h,
                  decoration: BoxDecoration(color: AppColors().whiteColor, border: Border(top: BorderSide(color: AppColors().lightOnlyText, width: 1))),
                  child: Center(
                      child: Row(
                    children: [
                      totalContent(value: "Total :", textColor: AppColors().darkText, width: 1600),

                      // totalContent(value: controller.outPerGrandTotal.toStringAsFixed(2), textColor: AppColors().darkText, width: 110),

                      totalContent(value: "Total : " + controller.grandTotal.value.toStringAsFixed(2), textColor: controller.grandTotal.value > 0 ? AppColors().blueColor : AppColors().redColor, width: 150),
                      totalContent(value: "Our % : " + controller.outPerGrandTotal.toStringAsFixed(2), textColor: AppColors().darkText, width: 150),
                    ],
                  )),
                );
              }),
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
      var scriptValue = controller.arrSummaryList[index];
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
                if (controller.isHiddenTitle(controller.arrListTitle1[indexT].title ?? "")) {
                  return SizedBox();
                }

                switch (controller.arrListTitle1[indexT].title) {
                  case AccountReportColumns.username:
                    {
                      return dynamicValueBox1(controller.arrSummaryList[index].userName ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1, isUnderlined: true, onClickValue: () {
                        showUserDetailsPopUp(userId: controller.arrSummaryList[index].userId!, userName: controller.arrSummaryList[index].userName ?? "");
                      });
                    }
                  case AccountReportColumns.parentUser:
                    {
                      return dynamicValueBox1(
                        controller.arrSummaryList[index].parentUserName ?? "",
                        index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                        AppColors().darkText,
                        index,
                        indexT,
                        controller.arrListTitle1,
                      );
                    }
                  case AccountReportColumns.exchange:
                    {
                      return dynamicValueBox1(scriptValue.exchangeName ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                    }
                  case AccountReportColumns.symbol:
                    {
                      return dynamicValueBox1(
                        scriptValue.symbolTitle ?? "",
                        index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                        AppColors().darkText,
                        index,
                        indexT,
                        controller.arrListTitle1,
                      );
                    }
                  case AccountReportColumns.totalBuyQty:
                    {
                      return dynamicValueBox1(
                        scriptValue.buyTotalQuantity!.toString(),
                        index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                        AppColors().darkText,
                        index,
                        indexT,
                        controller.arrListTitle1,
                      );
                    }
                  case AccountReportColumns.totalBuyAPrice:
                    {
                      return dynamicValueBox1(
                        scriptValue.buyTotalPrice!.toStringAsFixed(2),
                        index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                        AppColors().darkText,
                        index,
                        indexT,
                        controller.arrListTitle1,
                      );
                    }
                  case AccountReportColumns.totalSellQty:
                    {
                      return dynamicValueBox1(
                        scriptValue.sellTotalQuantity!.toString(),
                        index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                        AppColors().darkText,
                        index,
                        indexT,
                        controller.arrListTitle1,
                      );
                    }

                  case AccountReportColumns.totalSellAPrice:
                    {
                      return dynamicValueBox1(
                        scriptValue.sellTotalPrice!.toStringAsFixed(2),
                        index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                        AppColors().darkText,
                        index,
                        indexT,
                        controller.arrListTitle1,
                      );
                    }

                  case AccountReportColumns.netQty:
                    {
                      return dynamicValueBox1(scriptValue.totalQuantity!.toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                    }
                  case AccountReportColumns.netAPrice:
                    {
                      return dynamicValueBox1(scriptValue.avgPrice!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                    }
                  case AccountReportColumns.cmp:
                    {
                      return dynamicValueBox1(
                          scriptValue.totalQuantity! < 0 ? scriptValue.ask!.toStringAsFixed(2) : scriptValue.bid!.toStringAsFixed(2),
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          userData!.role != UserRollList.user
                              ? scriptValue.currentPriceFromSocket! > scriptValue.avgPrice!
                                  ? AppColors().redColor
                                  : AppColors().blueColor
                              : scriptValue.currentPriceFromSocket! > scriptValue.avgPrice!
                                  ? AppColors().blueColor
                                  : AppColors().redColor,
                          index,
                          indexT,
                          controller.arrListTitle1);
                    }
                  case AccountReportColumns.brk:
                    {
                      return dynamicValueBox1(scriptValue.brokerageTotal!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                    }
                  case AccountReportColumns.pAndL:
                    {
                      return dynamicValueBox1(scriptValue.profitLoss!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                    }
                  case AccountReportColumns.releasepl:
                    {
                      return dynamicValueBox1(scriptValue.profitLoss!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                    }
                  case AccountReportColumns.mtm:
                    {
                      return dynamicValueBox1(scriptValue.profitLossValue!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                    }
                  case AccountReportColumns.mtmWithBrk:
                    {
                      return dynamicValueBox1(
                        (double.parse(scriptValue.profitLossValue!.toStringAsFixed(2)) - double.parse(scriptValue.brokerageTotal!.toStringAsFixed(2))).toStringAsFixed(2),
                        index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                        AppColors().darkText,
                        index,
                        indexT,
                        controller.arrListTitle1,
                      );
                    }
                  case AccountReportColumns.total:
                    {
                      return dynamicValueBox1(scriptValue.total.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                    }
                  case AccountReportColumns.ourPer:
                    {
                      return dynamicValueBox1(scriptValue.ourPer.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                    }
                  default:
                    {
                      return SizedBox(
                        key: Key('$index'),
                      );
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
