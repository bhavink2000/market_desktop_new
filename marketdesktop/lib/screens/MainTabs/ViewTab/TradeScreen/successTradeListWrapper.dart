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
    print(globalMaxWidth);
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: globalMaxWidth + 100,
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
                    case '':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? dynamicValueBox("", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index, indexT, controller.arrListTitle, isImage: true, strImage: controller.arrTrade[index].isSelected ? AppImages.checkBoxSelected : AppImages.checkBox, isSmall: true,
                                onClickImage: () {
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
                              })
                            : const SizedBox();
                      }
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
                        return controller.arrListTitle[indexT].isSelected ? dynamicValueBox(controller.arrTrade[index].totalQuantity.toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isSmall: true) : const SizedBox();
                      }
                    case 'LOT':
                      {
                        return controller.arrListTitle[indexT].isSelected ? dynamicValueBox(controller.arrTrade[index].quantity.toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isSmall: true) : const SizedBox();
                      }
                    case 'TYPE':
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
                    case 'PRICE(B)':
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
              case '':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("", index, controller.arrListTitle, controller.isScrollEnable, isImage: true, strImage: controller.isAllSelected ? AppImages.checkBoxSelected : AppImages.checkBox, isSmall: true, onClickImage: () {
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
                        })
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
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
              case 'TYPE':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("TYPE", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
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
              case 'BROKERAGE':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("BROKERAGE", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'PRICE(B)':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("PRICE(B)", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
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
