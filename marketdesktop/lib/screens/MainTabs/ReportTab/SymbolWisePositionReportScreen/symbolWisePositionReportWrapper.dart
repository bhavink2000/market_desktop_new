import 'package:get/get.dart';
import 'package:marketdesktop/constant/utilities.dart';

import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/customWidgets/appScrollBar.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/MainContainerScreen/mainContainerController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/ClientAccountReportScreen/clientAccountReportController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/ClientAccountReportScreen/clientAccountReportWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/SymbolWisePositionReportScreen/symbolWisePositionReportController.dart';
import 'package:paginable/paginable.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constant/index.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../constant/screenColumnData.dart';

class SymbolWisePositionReportScreen extends BaseView<SymbolWisePositionReportController> {
  const SymbolWisePositionReportScreen({Key? key}) : super(key: key);

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
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Container(
                      //   height: 35,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Spacer(),
                      //       Container(
                      //         child: Text("From:",
                      //             style: TextStyle(
                      //               fontSize: 12,
                      //               fontFamily: CustomFonts.family1Regular,
                      //               color: AppColors().fontColor,
                      //             )),
                      //       ),
                      //       SizedBox(
                      //         width: 10,
                      //       ),
                      //       GestureDetector(
                      //         onTap: () {
                      //           showCalenderPopUp(DateTime.now(), (DateTime selectedDate) {
                      //             controller.fromDate.value = shortDateForBackend(selectedDate);
                      //           });
                      //         },
                      //         child: Obx(() {
                      //           return Container(
                      //             height: 35,
                      //             width: 150,
                      //             decoration: BoxDecoration(
                      //                 color: AppColors().whiteColor,
                      //                 border: Border.all(
                      //                   color: AppColors().lightOnlyText,
                      //                   width: 1.5,
                      //                 ),
                      //                 borderRadius: BorderRadius.circular(3)),
                      //             // color: AppColors().whiteColor,
                      //             padding: const EdgeInsets.only(right: 10),
                      //             child: Row(
                      //               children: [
                      //                 const SizedBox(
                      //                   width: 5,
                      //                 ),
                      //                 Text(
                      //                   controller.fromDate.value,
                      //                   style: TextStyle(
                      //                     fontSize: 10,
                      //                     fontFamily: CustomFonts.family1Medium,
                      //                     color: AppColors().darkText,
                      //                   ),
                      //                 ),
                      //                 const Spacer(),
                      //                 Image.asset(
                      //                   AppImages.calendarIcon,
                      //                   width: 25,
                      //                   height: 25,
                      //                   color: AppColors().fontColor,
                      //                 )
                      //               ],
                      //             ),
                      //           );
                      //         }),
                      //       ),
                      //       SizedBox(
                      //         width: 30,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Container(
                      //   height: 35,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       // SizedBox(
                      //       //   width: 30,
                      //       // ),
                      //       Spacer(),

                      //       Container(
                      //         child: Text("To:",
                      //             style: TextStyle(
                      //               fontSize: 12,
                      //               fontFamily: CustomFonts.family1Regular,
                      //               color: AppColors().fontColor,
                      //             )),
                      //       ),
                      //       SizedBox(
                      //         width: 10,
                      //       ),
                      //       GestureDetector(
                      //         onTap: () {
                      //           // selectToDate(controller.endDate);
                      //           showCalenderPopUp(DateTime.now(), (DateTime selectedDate) {
                      //             controller.endDate.value = shortDateForBackend(selectedDate);
                      //           });
                      //         },
                      //         child: Obx(() {
                      //           return Container(
                      //             height: 35,
                      //             width: 150,
                      //             decoration: BoxDecoration(
                      //                 color: AppColors().whiteColor,
                      //                 border: Border.all(
                      //                   color: AppColors().lightOnlyText,
                      //                   width: 1.5,
                      //                 ),
                      //                 borderRadius: BorderRadius.circular(3)),
                      //             // color: AppColors().whiteColor,
                      //             padding: const EdgeInsets.only(right: 10),
                      //             child: Row(
                      //               children: [
                      //                 const SizedBox(
                      //                   width: 5,
                      //                 ),
                      //                 Text(
                      //                   controller.endDate.value,
                      //                   style: TextStyle(
                      //                     fontSize: 12,
                      //                     fontFamily: CustomFonts.family1Medium,
                      //                     color: AppColors().darkText,
                      //                   ),
                      //                 ),
                      //                 const Spacer(),
                      //                 Image.asset(
                      //                   AppImages.calendarIcon,
                      //                   width: 25,
                      //                   height: 25,
                      //                   color: AppColors().fontColor,
                      //                 )
                      //               ],
                      //             ),
                      //           );
                      //         }),
                      //       ),
                      //       SizedBox(
                      //         width: 30,
                      //       ),
                      //     ],
                      //   ),
                      // ),
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
                              onPress: () {
                                controller.selectedExchange.value = ExchangeData();
                                controller.selectedScriptFromFilter.value = GlobalSymbolData();
                                controller.selectedUser.value = UserData();
                                controller.fromDate.value = "";
                                controller.endDate.value = "";
                                controller.getAccountSummaryNewList("", isFromClear: true);
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
          width: 2450,
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
                    ? dataNotFoundView("Symbol wise position not found")
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
                      totalContent(value: "Total :", textColor: AppColors().darkText, width: 1300),
                      totalContent(value: controller.plTotal.value.toStringAsFixed(2), textColor: AppColors().darkText, width: 110),
                      totalContent(value: controller.plPerTotal.toStringAsFixed(2), textColor: AppColors().darkText, width: 110),
                      totalContent(value: controller.brkTotal.toStringAsFixed(2), textColor: AppColors().darkText, width: 110),
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

  Widget tradeContent(BuildContext context, int index) {
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
                switch (controller.arrListTitle1[indexT].title) {
                  case SymbolWisePositionReportColumns.exchange:
                    {
                      return dynamicValueBox1(scriptValue.exchangeName ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                    }
                  case SymbolWisePositionReportColumns.symbol:
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
                  case SymbolWisePositionReportColumns.netQty:
                    {
                      return dynamicValueBox1(scriptValue.totalQuantity!.toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1, isUnderlined: true, onClickValue: () {
                        isCommonScreenPopUpOpen = true;
                        Get.find<MainContainerController>().isInitCallRequired = false;
                        currentOpenedScreen = ScreenViewNames.clientAccountReport;
                        var tradeVC = Get.put(ClientAccountReportController());
                        tradeVC.selectedExchange.value = ExchangeData(exchangeId: controller.arrSummaryList[index].exchangeId, name: controller.arrSummaryList[index].exchangeName);
                        tradeVC.selectedScriptFromFilter.value = GlobalSymbolData(symbolId: controller.arrSummaryList[index].symbolId, symbolName: controller.arrSummaryList[index].symbolName, symbolTitle: controller.arrSummaryList[index].symbolTitle);
                        // tradeVC.update();
                        // tradeVC.getTradeList();

                        tradeVC.isPagingApiCall = false;
                        tradeVC.getAccountSummaryNewList("");
                        tradeVC.isPagingApiCall = true;
                        Get.find<MainContainerController>().isInitCallRequired = true;
                        Get.delete<SymbolWisePositionReportController>();
                        Get.back();

                        generalContainerPopup(view: ClientAccountReportScreen(), title: ScreenViewNames.clientAccountReport);
                      });
                    }
                  case SymbolWisePositionReportColumns.netQtyPerWise:
                    {
                      return dynamicValueBox1(
                        scriptValue.totalShareQuantity!.toStringAsFixed(2),
                        index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                        AppColors().darkText,
                        index,
                        indexT,
                        controller.arrListTitle1,
                      );
                    }
                  case SymbolWisePositionReportColumns.netAPrice:
                    {
                      return dynamicValueBox1(scriptValue.totalQuantity! != 0 ? scriptValue.avgPrice!.toStringAsFixed(2) : "0.00", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                    }
                  case SymbolWisePositionReportColumns.brk:
                    {
                      return dynamicValueBox1(scriptValue.brokerageTotal!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                    }
                  case SymbolWisePositionReportColumns.withBrkAPrice:
                    {
                      return dynamicValueBox1(
                        scriptValue.totalQuantity! != 0
                            ? scriptValue.brokerageTotal! > 0
                                ? (scriptValue.avgPrice! + (scriptValue.brokerageTotal! / scriptValue.totalQuantity!)).toStringAsFixed(2)
                                : scriptValue.avgPrice!.toStringAsFixed(2)
                            : "0.00",
                        index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                        AppColors().darkText,
                        index,
                        indexT,
                        controller.arrListTitle1,
                      );
                    }
                  case SymbolWisePositionReportColumns.cmp:
                    {
                      return dynamicValueBox1(scriptValue.currentPriceFromSocket!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                    }
                  case SymbolWisePositionReportColumns.pl:
                    {
                      return dynamicValueBox1(scriptValue.profitLossValue!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                    }

                  case SymbolWisePositionReportColumns.plPer:
                    {
                      return dynamicValueBox1((((scriptValue.profitLossValue! * scriptValue.profitAndLossSharing!) / 100) * -1).toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                    }

                  case SymbolWisePositionReportColumns.brkPer:
                    {
                      return dynamicValueBox1(
                        scriptValue.adminBrokerageTotal!.toStringAsFixed(2),
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
}
