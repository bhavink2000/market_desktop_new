import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/constant/color.dart';
import 'package:marketdesktop/constant/popUpFunctions.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/PositionScreen/positionScreenController.dart';
import 'package:paginable/paginable.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constant/index.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../../main.dart';
import '../../../../modelClass/squareOffPositionRequestModelClass.dart';
import '../../../MainContainerScreen/mainContainerController.dart';
import '../ProfitAndLossScreen/profitAndLossController.dart';
import '../TradeScreen/successTradeListController.dart';
import '../TradeScreen/successTradeListWrapper.dart';

class PositionScreen extends BaseView<PositionController> {
  const PositionScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Row(
        children: [
          filterPanel(context, isRecordDisplay: true, totalRecord: controller.arrPositionScriptList.length, onCLickFilter: () {
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
                            }, width: 200),
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
                            allScriptListDropDown(controller.selectedScriptFromFilter, arrSymbol: controller.arrExchangeWiseScript, width: 200),
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
                              title: "Apply",
                              textSize: 14,
                              onPress: () {
                                controller.arrPositionScriptList.clear();
                                controller.currentPage = 1;
                                controller.getPositionList("", isFromfilter: true);
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
                              shimmerColor: AppColors().blueColor,
                              title: "Clear",
                              textSize: 14,
                              prefixWidth: 0,
                              onPress: () {
                                controller.selectedExchange.value = ExchangeData();
                                controller.selectedScriptFromFilter.value = GlobalSymbolData();
                                controller.selectedUser.value = UserData();
                                controller.arrPositionScriptList.clear();
                                controller.currentPage = 1;
                                controller.getPositionList("", isFromfilter: true, isFromClear: true);
                              },
                              focusKey: controller.clearFocus,
                              borderColor: Colors.transparent,
                              focusShadowColor: AppColors().blueColor,
                              bgColor: AppColors().whiteColor,
                              isFilled: true,
                              textColor: AppColors().blueColor,
                              isTextCenter: true,
                              isLoading: controller.isResetCall,
                            ),
                          ),
                          // SizedBox(width: 5.w,),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
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
        width: 2000,
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
              child: controller.isApiCallRunning == false && controller.isResetCall == false && controller.arrPositionScriptList.isEmpty
                  ? dataNotFoundView("Positions not found")
                  : PaginableListView.builder(
                      loadMore: () async {
                        if (controller.totalPage >= controller.currentPage) {
                          //print(controller.currentPage);
                          controller.getPositionList("");
                        }
                      },
                      errorIndicatorWidget: (exception, tryAgain) => dataNotFoundView("Data not found"),
                      progressIndicatorWidget: displayIndicator(),
                      physics: const ClampingScrollPhysics(),
                      clipBehavior: Clip.hardEdge,
                      itemCount: controller.isApiCallRunning || controller.isResetCall ? 50 : controller.arrPositionScriptList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return orderContent(context, index);
                      }),
            ),
            Container(
              height: 30,
              decoration: BoxDecoration(color: AppColors().whiteColor, border: Border(top: BorderSide(color: AppColors().lightOnlyText, width: 1))),
              child: Center(
                  child: Row(
                children: [
                  totalContent(value: "Total PL", textColor: AppColors().darkText, width: 1350),
                  totalContent(value: controller.totalPL.toStringAsFixed(2), textColor: controller.totalPL < 0 ? AppColors().redColor : AppColors().blueColor, width: 110),
                ],
              )),
            ),
            userDetailContent(),
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

  Widget userDetailContent() {
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: 5,
          ),
          // if (userData!.role == UserRollList.user)
          Container(
            margin: EdgeInsets.only(left: 5, right: 20, bottom: 5),
            width: 180,
            height: 35,
            child: CustomButton(
              isEnabled: true,
              shimmerColor: AppColors().whiteColor,
              title: "Square Off",
              textSize: 14,
              onPress: () {
                showPermissionDialog(
                    message: "Are you sure you want to Square off position?",
                    acceptButtonTitle: "Yes",
                    rejectButtonTitle: "No",
                    yesClick: () {
                      Get.back();
                      List<SymbolRequestData> arrSquare = [];
                      for (var element in controller.arrPositionScriptList) {
                        if (element.isSelected) {
                          var price = element.totalQuantity! < 0 ? element.bid!.toStringAsFixed(2).toString() : element.ask!.toStringAsFixed(2).toString();
                          var temp = SymbolRequestData(exchangeId: element.exchangeId!, symbolId: element.symbolId!, price: price);
                          arrSquare.add(temp);
                        }
                      }
                      if (arrSquare.length > 0) {
                        controller.squareOffPosition(arrSquare);
                      } else {
                        showWarningToast("Please select position");
                      }
                    },
                    noclick: () {
                      Get.back();
                    });
              },
              focusKey: controller.squareOffFocus,
              borderColor: Colors.transparent,
              focusShadowColor: AppColors().blueColor,
              bgColor: AppColors().blueColor,
              isFilled: true,
              textColor: AppColors().whiteColor,
              isTextCenter: true,
              isLoading: controller.isApiCallRunning,
            ),
          ),
          // if (userData!.role == UserRollList.user)
          Container(
            margin: EdgeInsets.only(left: 5, right: 20, bottom: 5),
            width: 180,
            height: 35,
            child: CustomButton(
              isEnabled: true,
              shimmerColor: AppColors().whiteColor,
              title: "Roll Over",
              textSize: 14,
              onPress: () {
                showPermissionDialog(
                    message: "Are you sure you want to Roll over position?",
                    acceptButtonTitle: "Yes",
                    rejectButtonTitle: "No",
                    yesClick: () {
                      Get.back();
                      List<SymbolRequestData> arrSquare = [];
                      for (var element in controller.arrPositionScriptList) {
                        if (element.isSelected) {
                          var price = element.totalQuantity! < 0 ? element.ask!.toStringAsFixed(2).toString() : element.bid!.toStringAsFixed(2).toString();
                          var temp = SymbolRequestData(exchangeId: element.exchangeId!, symbolId: element.symbolId!, price: price);
                          arrSquare.add(temp);
                        }
                      }
                      if (arrSquare.length > 0) {
                        controller.rollOverPosition(arrSquare);
                      } else {
                        showWarningToast("Please select position");
                      }
                    },
                    noclick: () {
                      Get.back();
                    });
              },
              focusKey: controller.squareOffFocus,
              borderColor: Colors.transparent,
              focusShadowColor: AppColors().blueColor,
              bgColor: AppColors().blueColor,
              isFilled: true,
              textColor: AppColors().whiteColor,
              isTextCenter: true,
              isLoading: controller.isApiCallRunning,
            ),
          ),
          Text("Realised P&L : ",
              style: TextStyle(
                fontSize: 12,
                fontFamily: CustomFonts.family1Medium,
                color: AppColors().darkText,
              )),
          Text(userData!.profitLoss!.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 12,
                fontFamily: CustomFonts.family1Medium,
                color: AppColors().darkText,
              )),
          SizedBox(
            width: 50,
          ),
          Text("Credit : ",
              style: TextStyle(
                fontSize: 12,
                fontFamily: CustomFonts.family1Medium,
                color: AppColors().darkText,
              )),
          Text(userData!.credit!.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 12,
                fontFamily: CustomFonts.family1Medium,
                color: AppColors().darkText,
              )),
          SizedBox(
            width: 50,
          ),
          Text("Margin Used : ",
              style: TextStyle(
                fontSize: 12,
                fontFamily: CustomFonts.family1Medium,
                color: AppColors().darkText,
              )),
          Text((userData!.marginBalance! - userData!.tradeMarginBalance!).toStringAsFixed(2),
              style: TextStyle(
                fontSize: 12,
                fontFamily: CustomFonts.family1Medium,
                color: AppColors().darkText,
              )),
          SizedBox(
            width: 50,
          ),
          Text("Free Margin : ",
              style: TextStyle(
                fontSize: 12,
                fontFamily: CustomFonts.family1Medium,
                color: AppColors().darkText,
              )),
          Text(userData!.tradeMarginBalance!.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 12,
                fontFamily: CustomFonts.family1Medium,
                color: AppColors().darkText,
              ))
        ],
      ),
    );
  }

  Widget orderContent(BuildContext context, int index) {
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
      var scriptValue = controller.arrPositionScriptList[index];
      return GestureDetector(
        onTap: () {
          controller.selectedScriptIndex = index;
          // controller.selectedScript!.value = scriptValue;
          controller.focusNode.requestFocus();
          controller.update();
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.transparent, border: Border.all(width: 1, color: controller.selectedScriptIndex == index ? AppColors().darkText : Colors.transparent)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // if (userData!.role == UserRollList.user)
              valueBox("", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index, isImage: true, strImage: scriptValue.isSelected ? AppImages.checkBoxSelected : AppImages.checkBox, isSmall: true, onClickImage: () {
                controller.arrPositionScriptList[index].isSelected = !controller.arrPositionScriptList[index].isSelected;
                for (var element in controller.arrPositionScriptList) {
                  if (element.isSelected) {
                    controller.isAllSelected = true;
                  } else {
                    controller.isAllSelected = false;
                    break;
                  }
                }
                controller.update();
              }),
              if (userData!.role != UserRollList.user)
                valueBox("", 0, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index, isImage: true, strImage: AppImages.viewIcon, isSmall: true, onClickImage: () {
                  isUserViewPopUpOpen = true;
                  showOpenPositionPopUp(controller.arrPositionScriptList[index].symbolId!, controller.arrPositionScriptList[index].userId!);
                }),
              if (userData!.role != UserRollList.user)
                IgnorePointer(
                  child: valueBox(controller.arrPositionScriptList[index].parentUserName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
                ),
              IgnorePointer(
                child: valueBox(controller.arrPositionScriptList[index].exchangeName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              ),
              valueBox(controller.arrPositionScriptList[index].symbolTitle ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isLarge: true, isUnderlined: true, onClickValue: () {
                isCommonScreenPopUpOpen = true;
                currentOpenedScreen = ScreenViewNames.trades;
                var tradeVC = Get.put(SuccessTradeListController());
                tradeVC.selectedExchange.value = ExchangeData(exchangeId: controller.arrPositionScriptList[index].exchangeId, name: controller.arrPositionScriptList[index].exchangeName);
                tradeVC.selectedScriptFromFilter.value = GlobalSymbolData(symbolId: controller.arrPositionScriptList[index].symbolId, symbolName: controller.arrPositionScriptList[index].symbolName, symbolTitle: controller.arrPositionScriptList[index].symbolTitle);
                // tradeVC.update();
                // tradeVC.getTradeList();
                Get.delete<ProfitAndLossController>();
                Get.back();
                generalContainerPopup(view: SuccessTradeListScreen(), title: ScreenViewNames.trades);
              }),
              IgnorePointer(
                child: valueBox(controller.arrPositionScriptList[index].buyTotalQuantity.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().blueColor, index, isBig: true),
              ),
              IgnorePointer(
                child: valueBox(controller.arrPositionScriptList[index].buyPrice!.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true),
              ),
              IgnorePointer(
                child: valueBox(controller.arrPositionScriptList[index].sellTotalQuantity!.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().redColor, index, isBig: true),
              ),
              IgnorePointer(
                child: valueBox(controller.arrPositionScriptList[index].sellPrice!.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true),
              ),
              IgnorePointer(
                child: valueBox(
                  controller.arrPositionScriptList[index].totalQuantity!.toString(),
                  45,
                  index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                  AppColors().darkText,
                  index,
                ),
              ),
              IgnorePointer(
                child: valueBox(
                  controller.arrPositionScriptList[index].quantity.toString(),
                  45,
                  index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                  AppColors().darkText,
                  index,
                ),
              ),
              IgnorePointer(
                child: valueBox(
                  controller.arrPositionScriptList[index].price!.toStringAsFixed(2),
                  45,
                  index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                  AppColors().darkText,
                  index,
                ),
              ),
              IgnorePointer(
                child: valueBox(
                  controller.arrPositionScriptList[index].totalQuantity! < 0 ? controller.arrPositionScriptList[index].ask!.toStringAsFixed(2).toString() : controller.arrPositionScriptList[index].bid!.toStringAsFixed(2).toString(),
                  45,
                  index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                  controller.arrPositionScriptList[index].scriptDataFromSocket.value.close! < controller.arrPositionScriptList[index].scriptDataFromSocket.value.ltp! ? AppColors().blueColor : AppColors().redColor,
                  index,
                ),
              ),
              IgnorePointer(
                child: valueBox(
                  double.parse(controller.arrPositionScriptList[index].profitLossValue!.toStringAsFixed(2)).toString(),
                  60,
                  index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                  controller.getPriceColor(controller.arrPositionScriptList[index].profitLossValue!),
                  index,
                ),
              ),
              if (userData!.role != UserRollList.user)
                IgnorePointer(
                  child: valueBox((controller.getPlPer(percentage: controller.arrPositionScriptList[index].profitAndLossSharing!, pl: controller.arrPositionScriptList[index].profitLossValue!) * -1).toStringAsFixed(3), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                      controller.getPlPer(percentage: controller.arrPositionScriptList[index].profitAndLossSharing!, pl: controller.arrPositionScriptList[index].profitLossValue!) > 0 ? AppColors().redColor : AppColors().blueColor, index),
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
        // titleBox("", 0),
        // if (userData!.role == UserRollList.user)
        titleBox("", isImage: true, strImage: controller.isAllSelected ? AppImages.checkBoxSelected : AppImages.checkBox, isSmall: true, onClickImage: () {
          if (controller.isAllSelected) {
            controller.arrPositionScriptList.forEach((element) {
              element.isSelected = false;
            });
            controller.isAllSelected = false;
            controller.update();
          } else {
            controller.arrPositionScriptList.forEach((element) {
              element.isSelected = true;
            });
            controller.isAllSelected = true;
            controller.update();
          }
        }),
        if (userData!.role != UserRollList.user) titleBox("View", isSmall: true),
        if (userData!.role != UserRollList.user) titleBox("Parent User"),
        titleBox("Exchange"),

        titleBox("symbol name", isLarge: true),
        titleBox("Total Buy Qty", isBig: true),
        titleBox(userData!.role != UserRollList.user ? "Total Buy A Price" : "Buy A Price", isBig: true),
        titleBox("Total Sell Qty", isBig: true),
        titleBox("Sell A Price", isBig: true),
        titleBox("Net Qty"),
        titleBox("Net Lot"),
        titleBox("Net A Price"),
        titleBox("CMP"),
        titleBox("P/L"),
        if (userData!.role != UserRollList.user) titleBox("P/L % Wise"),
      ],
    );
  }
}
