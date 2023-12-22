import 'package:get/get.dart';
import 'package:marketdesktop/constant/utilities.dart';

import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/tradeListController.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constant/index.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:marketdesktop/modelClass/constantModelClass.dart';
import '../../../../customWidgets/contextMenueBuilder.dart';
import '../../../../main.dart';

class TradeListScreen extends BaseView<TradeListController> {
  const TradeListScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: GestureDetector(
        onTap: () {
          ContextMenuController.removeAny();
        },
        child: Row(
          children: [
            filterPanel(context, isRecordDisplay: true, totalRecord: controller.arrTrade.length, onCLickFilter: () {
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
                                  width: 200,
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
                                        width: 15,
                                      ),
                                      Text(
                                        controller.fromDate.value,
                                        style: TextStyle(
                                          fontSize: 14,
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
                                  width: 200,
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
                                        width: 15,
                                      ),
                                      Text(
                                        controller.endDate.value,
                                        style: TextStyle(
                                          fontSize: 14,
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
                      Container(
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Container(
                              child: Text("Order Type:",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: CustomFonts.family1Regular,
                                    color: AppColors().fontColor,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            orderTypeDropDown(controller.selectedOrderType, width: 200, height: 35, onChange: () {
                              print(controller.selectedOrderType.value.id);
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
                                controller.arrTrade.clear();
                                controller.pageNumber = 1;
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
                                controller.selectedOrderType.value = Type();
                                controller.fromDate.value = "";
                                controller.endDate.value = "";
                                controller.arrTrade.clear();
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
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 2000,
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
                  ? dataNotFoundView("Orders not found")
                  : ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      clipBehavior: Clip.hardEdge,
                      itemCount: controller.isApiCallRunning || controller.isResetCall ? 50 : controller.arrTrade.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (controller.isApiCallRunning || controller.isResetCall) {
                          return tradeContent(context, index);
                        }
                        return ContextMenuRegion(
                          contextMenuBuilder: (BuildContext context, Offset offset) {
                            // The custom context menu will look like the default context menu
                            // on the current platform with a single 'Print' button.
                            return AdaptiveTextSelectionToolbar.buttonItems(
                              anchors: TextSelectionToolbarAnchors(
                                primaryAnchor: offset,
                              ),
                              buttonItems: <ContextMenuButtonItem>[
                                ContextMenuButtonItem(
                                  onPressed: () {
                                    ContextMenuController.removeAny();
                                    if (controller.selectedOrderIndex == -1) {
                                      showWarningToast("Please select order to modify.");
                                      return;
                                    }
                                    showPendingTradeInfoPopup();
                                    controller.openPopUpCount++;
                                  },
                                  label: 'Modify Order',
                                ),
                                if (userData!.role != UserRollList.admin || (userData!.role == UserRollList.admin && userData!.deleteTrade == 1))
                                  ContextMenuButtonItem(
                                    onPressed: () {
                                      ContextMenuController.removeAny();
                                      if (controller.selectedOrderIndex == -1) {
                                        showWarningToast("Please select order to cancel.");
                                        return;
                                      }
                                      showPermissionDialog(
                                          message: "Are you sure you want to cancel order?",
                                          acceptButtonTitle: "Yes",
                                          rejectButtonTitle: "No",
                                          yesClick: () {
                                            Get.back();
                                            controller.cancelTrade();
                                          },
                                          noclick: () {
                                            Get.back();
                                          });
                                    },
                                    label: 'Cancel Order',
                                  ),
                                if (userData!.role != UserRollList.admin || (userData!.role == UserRollList.admin && userData!.deleteTrade == 1))
                                  ContextMenuButtonItem(
                                    onPressed: () {
                                      ContextMenuController.removeAny();
                                      showPermissionDialog(
                                          message: "Are you sure you want to cancel all order?",
                                          acceptButtonTitle: "Yes",
                                          rejectButtonTitle: "No",
                                          yesClick: () {
                                            Get.back();
                                            controller.cancelAllTrade();
                                          },
                                          noclick: () {
                                            Get.back();
                                          });
                                    },
                                    label: 'Cancel All Order',
                                  ),
                              ],
                            );
                          },
                          child: Row(
                            children: <Widget>[
                              Container(height: 30, color: Colors.transparent, child: tradeContent(context, index)),
                            ],
                          ),
                        );
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
          ContextMenuController.removeAny();
          controller.selectedOrderIndex = index;
          controller.update();
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.transparent, border: Border.all(width: 1, color: controller.selectedOrderIndex == index ? AppColors().darkText : Colors.transparent)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (userData!.role != UserRollList.user) valueBox(controller.arrTrade[index].userName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true),
              if (userData!.role != UserRollList.user) valueBox(controller.arrTrade[index].parentUserName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              // valueBox(controller.arrTrade[index].executionDateTime == null ? "" : shortFullDateTime(controller.arrTrade[index].executionDateTime!), 33, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isForDate: true),
              valueBox(controller.arrTrade[index].exchangeName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              valueBox(controller.arrTrade[index].symbolTitle ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.getPriceColor(controller.arrTrade[index].tradeType!, controller.arrTrade[index].currentPriceFromSocket, controller.arrTrade[index].price!.toDouble()), index,
                  isLarge: true),
              if (userData!.role != UserRollList.user) valueBox(controller.arrTrade[index].tradeTypeValue!.toUpperCase(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.arrTrade[index].tradeType == "buy" ? AppColors().blueColor : AppColors().redColor, index, isSmall: true),
              if (userData!.role == UserRollList.user) valueBox(controller.arrTrade[index].tradeTypeValue!.toUpperCase(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.arrTrade[index].tradeType == "buy" ? AppColors().blueColor : AppColors().redColor, index, isSmall: true),
              valueBox(controller.arrTrade[index].totalQuantity.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isSmall: true),
              valueBox(controller.arrTrade[index].quantity.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isSmall: true),

              valueBox(controller.arrTrade[index].price.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.getPriceColor(controller.arrTrade[index].tradeType!, controller.arrTrade[index].currentPriceFromSocket, controller.arrTrade[index].price!.toDouble()), index),
              valueBox(shortFullDateTime(controller.arrTrade[index].createdAt!), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isForDate: true),
              if (userData!.role != UserRollList.user) valueBox(controller.arrTrade[index].orderTypeValue!.toString(), 60, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              valueBox(controller.arrTrade[index].currentPriceFromSocket.toString(), 60, index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                  controller.arrTrade[index].scriptDataFromSocket.value.close! < controller.arrTrade[index].currentPriceFromSocket ? AppColors().blueColor : AppColors().redColor, index),

              valueBox(controller.arrTrade[index].referencePrice!.toStringAsFixed(2), 60, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true),
              valueBox(controller.arrTrade[index].ipAddress ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              valueBox(controller.arrTrade[index].orderMethod ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              valueBox(controller.arrTrade[index].deviceId ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
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
        if (userData!.role != UserRollList.user) titleBox("User Name", isBig: true),
        if (userData!.role != UserRollList.user) titleBox("Parent User"),
        // titleBox("Execution Time", isForDate: true),
        titleBox(userData!.role != UserRollList.user ? "segment" : "seqment"),
        titleBox("Symbole", isLarge: true),
        titleBox("B/S", isSmall: true),

        titleBox("qty", isSmall: true),
        titleBox("Lot", isSmall: true),
        // if (userData!.role != UserRollList.user) titleBox("Total Qty"),
        titleBox(userData!.role != UserRollList.user ? "order Price" : "price"),
        titleBox(userData!.role != UserRollList.user ? "Order Time" : "Order Time/date", isForDate: true),
        if (userData!.role != UserRollList.user) titleBox("Type"),
        titleBox("cmp"),
        // titleBox("Seg."),

        titleBox("REFERENCE PRICE", isBig: true),
        titleBox("IPAddress"),
        titleBox("Device"),
        titleBox("DEVICE ID"),
      ],
    );
  }
}
