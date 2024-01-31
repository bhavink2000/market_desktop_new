import 'package:get/get.dart';
import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/UserDetailPopups/TradeListPopUp/tradeListPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/userDetailsPopUpController.dart';
import 'package:paginable/paginable.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constant/index.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../constant/utilities.dart';
import '../../../main.dart';

class TradeListPopUpScreen extends BaseView<TradeListPopUpController> {
  const TradeListPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Visibility(
        visible: Get.find<UserDetailsPopUpController>().selectedMenuName == "Trades",
        child: GestureDetector(
          onTap: () {
            // controller.focusNode.requestFocus();
          },
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
              Container(
                width: 1.w,
              )
            ],
          ),
        ),
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
                      // if (controller.selectedUserId != UserRollList.user)
                      //   SizedBox(
                      //     height: 10,
                      //   ),
                      // if (controller.selectedUserId != UserRollList.user)
                      //   Container(
                      //     height: 35,
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Spacer(),
                      //         Container(
                      //           child: Text("Username:",
                      //               style: TextStyle(
                      //                 fontSize: 12,
                      //                 fontFamily: CustomFonts.family1Regular,
                      //                 color: AppColors().fontColor,
                      //               )),
                      //         ),
                      //         SizedBox(
                      //           width: 10,
                      //         ),
                      //         userListDropDown(controller.selectedUser, width: 150),
                      //         SizedBox(
                      //           width: 30,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
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
                              child: Text("Status:",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: CustomFonts.family1Regular,
                                    color: AppColors().fontColor,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            tradeStatusListDropDown(controller.selectedTradeStatus, width: 150),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 70,
                          ),
                          SizedBox(
                            width: 80,
                            height: 30,
                            child: CustomButton(
                              isEnabled: true,
                              shimmerColor: AppColors().whiteColor,
                              title: "View",
                              textSize: 14,
                              onPress: () {
                                controller.getTradeList();
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
                                controller.pageNumber = 1;
                                controller.getTradeList(isFromClear: true);
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
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 2250,
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
              child: controller.isApiCallRunning == false && controller.isResetCall == false && controller.arrTrade.isEmpty
                  ? dataNotFoundView("Trade Logs not found")
                  : PaginableListView.builder(
                      loadMore: () async {
                        if (controller.totalPage >= controller.pageNumber) {
                          //print(controller.currentPage);
                          controller.getTradeList();
                        }
                      },
                      errorIndicatorWidget: (exception, tryAgain) => dataNotFoundView("Data not found"),
                      progressIndicatorWidget: displayIndicator(),
                      physics: const ClampingScrollPhysics(),
                      clipBehavior: Clip.hardEdge,
                      itemCount: controller.isApiCallRunning ? 50 : controller.arrTrade.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return tradeContent(context, index);
                      }),
            ),
          ],
        ),
      ),
    );
  }

  Widget tradeContentOld(BuildContext context, int index) {
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
          // controller.selectedOrderIndex = index;
          controller.update();
        },
        child: Container(
          // decoration: BoxDecoration(color: Colors.transparent, border: Border.all(width: 1, color: controller.selectedOrderIndex == index ? AppColors().darkText : Colors.transparent)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              valueBox(controller.arrTrade[index].userName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isUnderlined: true, onClickValue: () {
                showUserDetailsPopUp(userId: controller.arrTrade[index].userId!, userName: controller.arrTrade[index].userName!);
              }),
              if (userData!.role != UserRollList.user) valueBox(controller.arrTrade[index].parentUserName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),

              valueBox(controller.arrTrade[index].exchangeName ?? "0", 60, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              valueBox(controller.arrTrade[index].symbolName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.arrTrade[index].tradeType == "buy" ? AppColors().blueColor : AppColors().redColor, index, isLarge: true),
              if (userData!.role != UserRollList.user) valueBox(controller.arrTrade[index].tradeTypeValue!.toUpperCase(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.arrTrade[index].tradeType == "buy" ? AppColors().blueColor : AppColors().redColor, index, isSmall: true),
              if (userData!.role == UserRollList.user) valueBox(controller.arrTrade[index].tradeTypeValue!.toUpperCase(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.arrTrade[index].tradeType == "buy" ? AppColors().blueColor : AppColors().redColor, index),

              valueBox(controller.arrTrade[index].quantity.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isSmall: true),
              valueBox(controller.arrTrade[index].quantity.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isSmall: true),
              valueBox(controller.arrTrade[index].totalQuantity.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              valueBox(controller.arrTrade[index].productTypeValue.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              valueBox(controller.arrTrade[index].price!.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.arrTrade[index].tradeType == "buy" ? AppColors().blueColor : AppColors().redColor, index),
              // valueBox(
              //   ((controller.arrTrade[index].quantity! * controller.arrTrade[index].brokerageAmount!) / 100).toStringAsFixed(2),
              //   60,
              //   index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
              //   AppColors().darkText,
              //   index,
              // ),
              valueBox(
                controller.arrTrade[index].brokerageAmount!.toStringAsFixed(2),
                60,
                index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                AppColors().darkText,
                index,
              ),
              // valueBox(
              //     controller
              //         .getNetPrice(controller.arrTrade[index].tradeType!, controller.arrTrade[index].price ?? 0,
              //             ((controller.arrTrade[index].quantity! * controller.arrTrade[index].brokerageAmount!) / 100))
              //         .toStringAsFixed(2),
              //     60,
              //     index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
              //     controller.getProfitLossColor(
              //         controller.arrTrade[index].tradeType!,
              //         controller.getNetPrice(controller.arrTrade[index].tradeType!, controller.arrTrade[index].price ?? 0,
              //             controller.arrTrade[index].brokerageAmount ?? 0),
              //         controller.arrTrade[index].currentPriceFromSocket),
              //     index),
              valueBox(controller.getNetPrice(controller.arrTrade[index].tradeType!, controller.arrTrade[index].price ?? 0, (controller.arrTrade[index].brokerageAmount! / controller.arrTrade[index].totalQuantity!)).toStringAsFixed(2), 60, index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                  controller.getProfitLossColor(controller.arrTrade[index].tradeType!, controller.getNetPrice(controller.arrTrade[index].tradeType!, controller.arrTrade[index].price ?? 0, controller.arrTrade[index].brokerageAmount ?? 0), controller.arrTrade[index].currentPriceFromSocket), index),

              valueBox(shortFullDateTime(controller.arrTrade[index].createdAt!), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isForDate: true),
              valueBox(controller.arrTrade[index].executionDateTime == null ? "" : shortFullDateTime(controller.arrTrade[index].executionDateTime!), 33, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isLarge: true),
              valueBox("", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true),
              valueBox(controller.arrTrade[index].ipAddress ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              valueBox(controller.arrTrade[index].orderMethod ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              valueBox(controller.arrTrade[index].deviceId ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
            ],
          ),
        ),
      );
    }
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
      var historyValue = controller.arrTrade[index];
      return GestureDetector(
        onTap: () {
          // controller.selectedScriptIndex = index;
          controller.update();
        },
        child: Container(
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
                        return controller.arrListTitle[indexT].isSelected ? dynamicValueBox(controller.arrTrade[index].userName ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle) : const SizedBox();
                      }
                    case 'PARENT USER':
                      {
                        return controller.arrListTitle[indexT].isSelected ? dynamicValueBox(historyValue.parentUserName ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isBig: true) : const SizedBox();
                      }
                    case 'SEGMENT':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? dynamicValueBox(
                                historyValue.exchangeName ?? "",
                                index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                                AppColors().darkText,
                                index,
                                indexT,
                                controller.arrListTitle,
                              )
                            : const SizedBox();
                      }
                    case 'SYMBOL':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? dynamicValueBox(
                                historyValue.symbolTitle ?? "",
                                index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                                AppColors().darkText,
                                index,
                                indexT,
                                controller.arrListTitle,
                              )
                            : const SizedBox();
                      }
                    case 'B/S':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? dynamicValueBox(controller.arrTrade[index].tradeTypeValue!.toUpperCase(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.arrTrade[index].tradeType == "buy" ? AppColors().blueColor : AppColors().redColor, index, indexT, controller.arrListTitle,
                                isSmall: true)
                            : const SizedBox();
                      }
                    case 'QTY':
                      {
                        return controller.arrListTitle[indexT].isSelected ? dynamicValueBox(controller.arrTrade[index].quantity.toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isSmall: true) : const SizedBox();
                      }
                    case 'LOT':
                      {
                        return controller.arrListTitle[indexT].isSelected ? dynamicValueBox(controller.arrTrade[index].totalQuantity.toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isSmall: true) : const SizedBox();
                      }
                    case 'TOTAL QTY':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? dynamicValueBox(
                                controller.arrTrade[index].totalQuantity.toString(),
                                index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                                AppColors().darkText,
                                index,
                                indexT,
                                controller.arrListTitle,
                              )
                            : const SizedBox();
                      }
                    case 'VALIDITY':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? dynamicValueBox(
                                controller.arrTrade[index].productTypeValue.toString(),
                                index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                                AppColors().darkText,
                                index,
                                indexT,
                                controller.arrListTitle,
                              )
                            : const SizedBox();
                      }
                    case 'TRADE PRICE':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? dynamicValueBox(
                                controller.arrTrade[index].price!.toStringAsFixed(2),
                                index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                                controller.arrTrade[index].tradeType == "buy" ? AppColors().blueColor : AppColors().redColor,
                                index,
                                indexT,
                                controller.arrListTitle,
                              )
                            : const SizedBox();
                      }
                    case 'BROKERAGE':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? dynamicValueBox(
                                controller.arrTrade[index].brokerageAmount!.toStringAsFixed(2),
                                index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                                controller.arrTrade[index].tradeType == "buy" ? AppColors().blueColor : AppColors().redColor,
                                index,
                                indexT,
                                controller.arrListTitle,
                              )
                            : const SizedBox();
                      }
                    case 'NET PRICE':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? dynamicValueBox(
                                controller.getNetPrice(controller.arrTrade[index].tradeType!, controller.arrTrade[index].price ?? 0, (controller.arrTrade[index].brokerageAmount! / controller.arrTrade[index].totalQuantity!)).toStringAsFixed(2),
                                index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                                controller.getProfitLossColor(
                                    controller.arrTrade[index].tradeType!, controller.getNetPrice(controller.arrTrade[index].tradeType!, controller.arrTrade[index].price ?? 0, controller.arrTrade[index].brokerageAmount ?? 0), controller.arrTrade[index].currentPriceFromSocket),
                                index,
                                indexT,
                                controller.arrListTitle)
                            : const SizedBox();
                      }
                    case 'ORDER D/T':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? dynamicValueBox(shortFullDateTime(controller.arrTrade[index].createdAt!), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.arrTrade[index].tradeType == "buy" ? AppColors().blueColor : AppColors().redColor, index, indexT, controller.arrListTitle,
                                isForDate: true)
                            : const SizedBox();
                      }
                    case 'EXECUTION D/T':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? dynamicValueBox(
                                shortFullDateTime(controller.arrTrade[index].executionDateTime!), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.arrTrade[index].tradeType == "buy" ? AppColors().blueColor : AppColors().redColor, index, indexT, controller.arrListTitle,
                                isForDate: true)
                            : const SizedBox();
                      }
                    case 'REFERENCE PRICE':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? dynamicValueBox(controller.arrTrade[index].referencePrice!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.arrTrade[index].tradeType == "buy" ? AppColors().blueColor : AppColors().redColor, index, indexT, controller.arrListTitle,
                                isSmallLarge: true)
                            : const SizedBox();
                      }
                    case 'IP ADDRESS':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? dynamicValueBox(
                                historyValue.ipAddress ?? "",
                                index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                                AppColors().darkText,
                                index,
                                indexT,
                                controller.arrListTitle,
                              )
                            : const SizedBox();
                      }
                    case 'DEVICE':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? dynamicValueBox(
                                historyValue.orderMethod ?? "",
                                index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                                AppColors().darkText,
                                index,
                                indexT,
                                controller.arrListTitle,
                              )
                            : const SizedBox();
                      }
                    case 'DEVICE ID':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? dynamicValueBox(
                                historyValue.deviceId ?? "",
                                index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                                AppColors().darkText,
                                index,
                                indexT,
                                controller.arrListTitle,
                              )
                            : const SizedBox();
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
                      ? dynamicTitleBox("USERNAME", index, hasFilterIcon: true, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'PARENT USER':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("PARENT USER", index, controller.arrListTitle, controller.isScrollEnable, isBig: true, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'SEGMENT':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("SEGMENT", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'SYMBOL':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("SYMBOL", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'B/S':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("B/S", index, controller.arrListTitle, controller.isScrollEnable, isSmall: true, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'QTY':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("QTY", index, controller.arrListTitle, controller.isScrollEnable, isSmall: true, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'LOT':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("LOT", index, controller.arrListTitle, controller.isScrollEnable, isSmall: true, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'TOTAL QTY':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("TOTAL QTY", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'VALIDITY':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("VALIDITY", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'TRADE PRICE':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("TRADE PRICE", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }

              case 'PRICE':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("PRICE", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
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
              case 'NET PRICE':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("NET PRICE", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'ORDER D/T':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("ORDER D/T", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isForDate: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }

              case 'EXECUTION D/T':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("EXECUTION D/T", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isForDate: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'REFERENCE PRICE':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("REFERENCE PRICE", index, controller.arrListTitle, controller.isScrollEnable, isSmallLarge: true, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }

              case 'IP ADDRESS':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("IP ADDRESS", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'DEVICE':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("DEVICE", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'DEVICE ID':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("DEVICE ID", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
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
