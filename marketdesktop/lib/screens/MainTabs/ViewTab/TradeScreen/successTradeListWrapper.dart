import 'package:get/get.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/successTradeListController.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constant/index.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../../modelClass/constantModelClass.dart';
import '../../../../modelClass/myTradeListModelClass.dart';

class SuccessTradeListScreen extends BaseView<SuccessTradeListController> {
  const SuccessTradeListScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
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
                                controller.selectedTradeStatus = Type().obs;
                                controller.endDate.value = "";
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
                  ? dataNotFoundView("Trades not found")
                  : ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      clipBehavior: Clip.hardEdge,
                      itemCount: controller.isApiCallRunning || controller.isResetCall ? 50 : controller.arrTrade.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return tradeContent(context, index);
                      }),
            ),
            if (userData!.role == UserRollList.superAdmin)
              Container(
                height: 40,
                decoration: BoxDecoration(color: AppColors().whiteColor, border: Border(top: BorderSide(color: AppColors().lightOnlyText, width: 1))),
                child: Center(
                    child: Row(
                  children: [deleteTradeBtn()],
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
          controller.selectedOrderIndex = index;
          controller.update();
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.transparent, border: Border.all(width: 1, color: controller.selectedOrderIndex == index ? AppColors().darkText : Colors.transparent)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (userData!.role == UserRollList.superAdmin)
                valueBox("", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index, isImage: true, strImage: controller.arrTrade[index].isSelected ? AppImages.checkBoxSelected : AppImages.checkBox, isSmall: true, onClickImage: () {
                  controller.arrTrade[index].isSelected = !controller.arrTrade[index].isSelected;
                  for (var element in controller.arrTrade) {
                    if (element.isSelected) {
                      controller.isAllSelected = true;
                    } else {
                      controller.isAllSelected = false;
                      break;
                    }
                  }
                  controller.update();
                }),
              if (userData!.role != UserRollList.user) valueBox(controller.arrTrade[index].userName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              if (userData!.role != UserRollList.user) valueBox(controller.arrTrade[index].parentUserName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),

              valueBox(controller.arrTrade[index].exchangeName ?? "0", 60, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              valueBox(controller.arrTrade[index].symbolName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.arrTrade[index].tradeType == "buy" ? AppColors().blueColor : AppColors().redColor, index, isLarge: true),
              valueBox(controller.arrTrade[index].tradeTypeValue!.toUpperCase(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.arrTrade[index].tradeType == "buy" ? AppColors().blueColor : AppColors().redColor, index, isSmall: true),

              valueBox(controller.arrTrade[index].totalQuantity.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isSmall: true),
              valueBox(controller.arrTrade[index].quantity.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isSmall: true),
              // if (userData!.role != UserRollList.user) valueBox(controller.arrTrade[index].totalQuantity.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
              valueBox(controller.arrTrade[index].productTypeValue.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true),
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
              valueBox(controller.arrTrade[index].executionDateTime == null ? "" : shortFullDateTime(controller.arrTrade[index].executionDateTime!), 33, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isForDate: true),
              valueBox(controller.arrTrade[index].referencePrice!.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true),
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
        if (userData!.role == UserRollList.superAdmin)
          titleBox("", isImage: true, strImage: controller.isAllSelected ? AppImages.checkBoxSelected : AppImages.checkBox, isSmall: true, onClickImage: () {
            if (controller.isAllSelected) {
              controller.arrTrade.forEach((element) {
                element.isSelected = false;
              });
              controller.isAllSelected = false;
              controller.update();
            } else {
              controller.arrTrade.forEach((element) {
                element.isSelected = true;
              });
              controller.isAllSelected = true;
              controller.update();
            }
          }),
        if (userData!.role != UserRollList.user) titleBox("User Name"),
        if (userData!.role != UserRollList.user) titleBox("Parent User"),

        titleBox(userData!.role != UserRollList.user ? "segment" : "seqment"),
        titleBox("Symbole", isLarge: true),
        titleBox("B/S", isSmall: true),

        titleBox("qty", isSmall: true),
        // titleBox("Validity"),
        titleBox("Lot", isSmall: true),
        // if (userData!.role != UserRollList.user) titleBox("Total Qty"),
        titleBox("type", isBig: true),
        titleBox("trade price"),
        titleBox("Brokerage"),
        titleBox("Price(B)"),
        titleBox(userData!.role != UserRollList.user ? "Order Time" : "Order D/T", isForDate: true),
        titleBox(userData!.role != UserRollList.user ? "Execution Time" : "Execution D/T", isForDate: true),
        titleBox("REFERENCE PRICE", isBig: true),
        titleBox("IPAddress"),
        titleBox("Device"),
        titleBox("DeviceId"),
      ],
    );
  }

  Widget deleteTradeBtn() {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 20, bottom: 5, top: 5),
      width: 180,
      height: 35,
      child: CustomButton(
        isEnabled: true,
        shimmerColor: AppColors().whiteColor,
        title: "Delete Trade",
        textSize: 14,
        onPress: () {
          List<TradeData> arrSquare = [];
          for (var element in controller.arrTrade) {
            if (element.isSelected) {
              arrSquare.add(element);
            }
          }
          if (arrSquare.length > 0) {
            showPermissionDialog(
                message: "Are you sure you want to delete trade?",
                acceptButtonTitle: "Yes",
                rejectButtonTitle: "No",
                yesClick: () {
                  Get.back();
                  controller.deleteTrade(arrSquare);
                },
                noclick: () {
                  Get.back();
                });
          } else {
            showWarningToast("Please select Trade");
          }
        },
        focusKey: controller.deleteTradeFocus,
        borderColor: Colors.transparent,
        focusShadowColor: AppColors().blueColor,
        bgColor: AppColors().blueColor,
        isFilled: true,
        textColor: AppColors().whiteColor,
        isTextCenter: true,
        isLoading: controller.isApiCallRunning,
      ),
    );
  }
}
