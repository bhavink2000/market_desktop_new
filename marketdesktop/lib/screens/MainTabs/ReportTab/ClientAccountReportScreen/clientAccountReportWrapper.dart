import 'package:get/get.dart';
import 'package:marketdesktop/customWidgets/appScrollBar.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/ClientAccountReportScreen/clientAccountReportController.dart';
import 'package:paginable/paginable.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constant/index.dart';
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
                    listTitleContent(),
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
                      totalContent(value: controller.grandTotal.value.toStringAsFixed(2), textColor: controller.grandTotal.value > 0 ? AppColors().blueColor : AppColors().redColor, width: 110),
                      // totalContent(value: controller.totalValues!.profitGrandTotal.toStringAsFixed(2), textColor: AppColors().darkText, width: 110),
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
              itemCount: controller.arrListTitle.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int indexT) {
                switch (controller.arrListTitle[indexT].title) {
                  case 'USERNAME':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(controller.arrSummaryList[index].userName ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isBig: true, isUnderlined: true, onClickValue: () {
                              showUserDetailsPopUp(userId: controller.arrSummaryList[index].userId!, userName: controller.arrSummaryList[index].userName ?? "");
                            })
                          : SizedBox(
                              key: Key('$index'),
                            );
                    }
                  case 'PARENT USER':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(controller.arrSummaryList[index].parentUserName ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isBig: true)
                          : SizedBox(
                              key: Key('$index'),
                            );
                    }
                  case 'EXCHANGE':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(scriptValue.exchangeName ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle)
                          : SizedBox(
                              key: Key('$index'),
                            );
                    }
                  case 'SYMBOL':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(scriptValue.symbolTitle ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isBig: true)
                          : SizedBox(
                              key: Key('$index'),
                            );
                    }
                  case 'TOTAL BUY QTY':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(scriptValue.buyTotalQuantity!.toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isBig: true)
                          : SizedBox(
                              key: Key('$index'),
                            );
                    }
                  case 'TOTAL BUY A PRICE':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(scriptValue.buyTotalPrice!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isSmallLarge: true)
                          : SizedBox(
                              key: Key('$index'),
                            );
                    }
                  case 'TOTAL SELL QTY':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(scriptValue.sellTotalQuantity!.toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isSmallLarge: true)
                          : SizedBox(
                              key: Key('$index'),
                            );
                    }

                  case 'TOTAL SELL A PRICE':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(scriptValue.sellTotalPrice!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isSmallLarge: true)
                          : SizedBox(
                              key: Key('$index'),
                            );
                    }

                  case 'NET QTY':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(scriptValue.totalQuantity!.toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle)
                          : SizedBox(
                              key: Key('$index'),
                            );
                    }
                  case 'NET A PRICE':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(scriptValue.avgPrice!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle)
                          : SizedBox(
                              key: Key('$index'),
                            );
                    }
                  case 'CMP':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(scriptValue.totalQuantity! < 0 ? scriptValue.ask!.toStringAsFixed(2) : scriptValue.bid!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                              scriptValue.currentPriceFromSocket! > scriptValue.avgPrice! ? AppColors().redColor : AppColors().blueColor, index, indexT, controller.arrListTitle)
                          : SizedBox(
                              key: Key('$index'),
                            );
                    }
                  case 'BROKERAGE':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(scriptValue.brokerageTotal!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle)
                          : SizedBox(
                              key: Key('$index'),
                            );
                    }
                  case 'P/L':
                    {
                      return controller.arrListTitle[index].isSelected
                          ? dynamicValueBox(scriptValue.profitLossValue!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle)
                          : SizedBox(
                              key: Key('$index'),
                            );
                    }
                  case 'RELEASE P/L':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(scriptValue.profitLoss!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle)
                          : SizedBox(
                              key: Key('$index'),
                            );
                    }
                  case 'MTM':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(scriptValue.profitLossValue!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle)
                          : SizedBox(
                              key: Key('$index'),
                            );
                    }
                  case 'MTM WITH BROKERAGE':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(
                              (double.parse(scriptValue.profitLossValue!.toStringAsFixed(2)) - double.parse(scriptValue.brokerageTotal!.toStringAsFixed(2))).toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle,
                              isForDate: true)
                          : SizedBox(
                              key: Key('$index'),
                            );
                    }
                  case 'TOTAL':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(scriptValue.total.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle)
                          : SizedBox(
                              key: Key('$index'),
                            );
                    }
                  case 'OUR %':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(scriptValue.ourPer.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle)
                          : SizedBox(
                              key: Key('$index'),
                            );
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

  Widget listTitleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ReorderableListView.builder(
          scrollDirection: Axis.horizontal,
          buildDefaultDragHandles: false,
          padding: EdgeInsets.zero,
          itemCount: controller.arrListTitle.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            switch (controller.arrListTitle[index].title) {
              case 'USERNAME':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("USERNAME", index, controller.arrListTitle, controller.isScrollEnable, isBig: true, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'PARENT USER':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("PARENT USER", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isBig: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'EXCHANGE':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("EXCHANGE", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'SYMBOL':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("SYMBOL", index, controller.arrListTitle, controller.isScrollEnable, isBig: true, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'TOTAL BUY QTY':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("TOTAL BUY QTY", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isBig: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'TOTAL BUY A PRICE':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("TOTAL BUY A PRICE", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isSmallLarge: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }

              case 'TOTAL SELL QTY':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("TOTAL SELL QTY", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isSmallLarge: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }

              case 'TOTAL SELL A PRICE':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("TOTAL SELL A PRICE", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isSmallLarge: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }

              case 'NET QTY':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("NET QTY", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'NET A PRICE':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("NET A PRICE", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'CMP':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("CMP", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'BROKERAGE':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("BROKERAGE", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'P/L':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("P/L", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }

              case 'RELEASE P/L':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("RELEASE P/L", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'MTM':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("MTM", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'MTM WITH BROKERAGE':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("MTM WITH BROKERAGE", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isForDate: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'TOTAL':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("TOTAL", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'OUR %':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("OUR %", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              default:
                {
                  return SizedBox(
                    key: Key('$index'),
                  );
                }
            }
          },
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            var temp = controller.arrListTitle.removeAt(oldIndex);
            if (newIndex > controller.arrListTitle.length) {
              newIndex = controller.arrListTitle.length;
            }
            controller.arrListTitle.insert(newIndex, temp);
            controller.update();
          },
        ),
      ],
    );
  }
}
