import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:marketdesktop/constant/color.dart';
import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/UserDetailPopups/OpenPositionPopUpScreen/openPositionPopUpController.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constant/index.dart';

import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OpenPositionPopUpScreen extends BaseView<OpenPositionPopUpController> {
  const OpenPositionPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return Column(
      children: [
        headerViewContent(
            title: "Open Position",
            isFilterAvailable: false,
            isFromMarket: false,
            closeClick: () {
              Get.back();
              Get.delete<OpenPositionPopUpController>();
            }),
        Expanded(
          child: Row(
            children: [
              filterPanel(context, bottomMargin: 0, onCLickFilter: () {
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
    );
  }

  Widget filterContent(BuildContext context) {
    return AnimatedContainer(
      // margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(color: AppColors().whiteColor, width: 1),
      )),
      width: controller.isFilterOpen ? 380 : 0,
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
                        userListDropDown(controller.selectedUser),
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
                        exchangeTypeDropDown(controller.selectedExchange, width: 250),
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
                        allScriptListDropDown(controller.selectedScriptFromFilter),
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
                            controller.getPositionList("");
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
                          shimmerColor: AppColors().whiteColor,
                          title: "Clear",
                          textSize: 14,
                          prefixWidth: 0,
                          onPress: () {
                            controller.selectedExchange.value = ExchangeData();
                            controller.selectedScriptFromFilter.value = GlobalSymbolData();
                            controller.selectedUser.value = UserData();
                            controller.getPositionList("");
                          },
                          bgColor: AppColors().whiteColor,
                          isFilled: true,
                          borderColor: AppColors().blueColor,
                          textColor: AppColors().blueColor,
                          isTextCenter: true,
                          isLoading: false,
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
    );
  }

  Widget mainContent(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        width: 1870,
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
              child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  clipBehavior: Clip.hardEdge,
                  itemCount: controller.arrPositionScriptList.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return orderContent(context, index);
                  }),
            ),
            if (controller.selectedUserData != null)
              Container(
                height: 30,
                decoration: BoxDecoration(
                    color: AppColors().whiteColor,
                    border: Border(
                      top: BorderSide(color: AppColors().lightOnlyText, width: 1),
                    )),
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                        "PL : ${controller.selectedUserData?.profitLoss!.toStringAsFixed(2)}  | BK : ${controller.selectedUserData?.brokerageTotal!.toStringAsFixed(2)} | BAL :  ${controller.selectedUserData?.balance!.toStringAsFixed(2)} | CRD : ${controller.selectedUserData?.credit!.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
                    Spacer(),
                    Text("Total P/L : ${(controller.selectedUserData!.profitLoss! + controller.selectedUserData!.brokerageTotal!).toStringAsFixed(2)}", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
                    SizedBox(
                      width: 200,
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget orderContentold(BuildContext context, int index) {
    // var scriptValue = controller.arrUserOderList[index];
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          valueBox(controller.arrPositionScriptList[index].userName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isUnderlined: true, onClickValue: () {
            showUserDetailsPopUp(
              userId: controller.arrPositionScriptList[index].userId!,
              userName: controller.arrPositionScriptList[index].userName!,
            );
          }),
          IgnorePointer(
            child: valueBox(controller.arrPositionScriptList[index].parentUserName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
          ),
          IgnorePointer(
            child: valueBox(controller.arrPositionScriptList[index].exchangeName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
          ),
          IgnorePointer(
            child: valueBox(controller.arrPositionScriptList[index].symbolTitle ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isLarge: true),
          ),
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
              AppColors().darkText,
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
          IgnorePointer(
            child: valueBox(
                controller.getPlPer(cmp: controller.arrPositionScriptList[index].totalQuantity! < 0 ? controller.arrPositionScriptList[index].ask! : controller.arrPositionScriptList[index].bid!, netAPrice: controller.arrPositionScriptList[index].price!).toStringAsFixed(3),
                45,
                index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                controller.getPlPer(cmp: controller.arrPositionScriptList[index].totalQuantity! < 0 ? controller.arrPositionScriptList[index].ask! : controller.arrPositionScriptList[index].bid!, netAPrice: controller.arrPositionScriptList[index].price!) > 0
                    ? AppColors().blueColor
                    : AppColors().redColor,
                index),
          ),
        ],
      ),
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
      var historyValue = controller.arrPositionScriptList[index];
      return GestureDetector(
        onTap: () {
          // controller.selectedScriptIndex = index;
          // // controller.selectedScript!.value = scriptValue;
          // controller.focusNode.requestFocus();
          // controller.update();
        },
        child: Container(
          // decoration: BoxDecoration(color: Colors.transparent, border: Border.all(width: 1, color: controller.selectedScriptIndex == index ? AppColors().darkText : Colors.transparent)),
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
                        return controller.arrListTitle[indexT].isSelected ? IgnorePointer(child: dynamicValueBox(historyValue.userName ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isBig: true)) : const SizedBox();
                      }
                    case 'PARENT USER':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? IgnorePointer(child: dynamicValueBox(historyValue.parentUserName ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isBig: true))
                            : const SizedBox();
                      }
                    case 'EXCHANGE':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? IgnorePointer(
                                child: dynamicValueBox(
                                  historyValue.exchangeName ?? "",
                                  index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                                  AppColors().darkText,
                                  index,
                                  indexT,
                                  controller.arrListTitle,
                                ),
                              )
                            : const SizedBox();
                      }
                    case 'SYMBOL NAME':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? dynamicValueBox(controller.arrPositionScriptList[index].symbolTitle ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isBig: true)
                            : const SizedBox();
                      }
                    case 'TOTAL BUY A QTY':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? IgnorePointer(
                                child: dynamicValueBox(controller.arrPositionScriptList[index].buyTotalQuantity.toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().blueColor, index, indexT, controller.arrListTitle, isSmallLarge: true),
                              )
                            : const SizedBox();
                      }
                    case 'TOTAL BUY A PRICE':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? IgnorePointer(
                                child: dynamicValueBox(controller.arrPositionScriptList[index].buyPrice!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isSmallLarge: true),
                              )
                            : const SizedBox();
                      }
                    case 'BUY A PRICE':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? IgnorePointer(
                                child: dynamicValueBox(controller.arrPositionScriptList[index].buyPrice!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isSmallLarge: true),
                              )
                            : const SizedBox();
                      }
                    case 'TOTAL SELL QTY':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? IgnorePointer(
                                child: dynamicValueBox(controller.arrPositionScriptList[index].sellTotalQuantity!.toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().redColor, index, indexT, controller.arrListTitle, isSmallLarge: true),
                              )
                            : const SizedBox();
                      }
                    case 'SELL A PRICE':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? IgnorePointer(
                                child: dynamicValueBox(controller.arrPositionScriptList[index].sellPrice!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle),
                              )
                            : const SizedBox();
                      }
                    case 'NET QTY':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? IgnorePointer(
                                child: dynamicValueBox(controller.arrPositionScriptList[index].totalQuantity!.toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle),
                              )
                            : const SizedBox();
                      }
                    case 'NET LOT':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? IgnorePointer(
                                child: dynamicValueBox(controller.arrPositionScriptList[index].lotSize!.toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle),
                              )
                            : const SizedBox();
                      }
                    case 'NET A PRICE':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? IgnorePointer(
                                child: dynamicValueBox(controller.arrPositionScriptList[index].price!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle),
                              )
                            : const SizedBox();
                      }
                    case 'CMP':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? IgnorePointer(
                                child: dynamicValueBox(
                                    controller.arrPositionScriptList[index].totalQuantity! < 0 ? controller.arrPositionScriptList[index].ask!.toStringAsFixed(2).toString() : controller.arrPositionScriptList[index].bid!.toStringAsFixed(2).toString(),
                                    index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                                    controller.arrPositionScriptList[index].scriptDataFromSocket.value.close! < controller.arrPositionScriptList[index].scriptDataFromSocket.value.ltp! ? AppColors().blueColor : AppColors().redColor,
                                    index,
                                    indexT,
                                    controller.arrListTitle),
                              )
                            : const SizedBox();
                      }
                    case 'P/L':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? IgnorePointer(
                                child: dynamicValueBox(double.parse(controller.arrPositionScriptList[index].profitLossValue!.toStringAsFixed(2)).toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.getPriceColor(controller.arrPositionScriptList[index].profitLossValue!),
                                    index, indexT, controller.arrListTitle),
                              )
                            : const SizedBox();
                      }
                    case 'P/L % WISE':
                      {
                        return controller.arrListTitle[indexT].isSelected
                            ? IgnorePointer(
                                child: dynamicValueBox(
                                    controller.getPlPer(cmp: controller.arrPositionScriptList[index].totalQuantity! < 0 ? controller.arrPositionScriptList[index].ask! : controller.arrPositionScriptList[index].bid!, netAPrice: controller.arrPositionScriptList[index].price!).toStringAsFixed(3),
                                    index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                                    controller.getPlPer(cmp: controller.arrPositionScriptList[index].totalQuantity! < 0 ? controller.arrPositionScriptList[index].ask! : controller.arrPositionScriptList[index].bid!, netAPrice: controller.arrPositionScriptList[index].price!) > 0
                                        ? AppColors().blueColor
                                        : AppColors().redColor,
                                    index,
                                    indexT,
                                    controller.arrListTitle),
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
                      ? dynamicTitleBox("USERNAME", index, controller.arrListTitle, controller.isScrollEnable, isBig: true, updateCallback: controller.refreshView)
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
              case 'EXCHANGE':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("EXCHANGE", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'SYMBOL NAME':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("SYMBOL NAME", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isBig: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'TOTAL BUY A QTY':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("TOTAL BUY A QTY", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isSmallLarge: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }

              case 'TOTAL BUY A PRICE':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("TOTAL BUY A PRICE", index, controller.arrListTitle, controller.isScrollEnable, isSmallLarge: true, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'BUY A PRICE':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("TOTAL BUY A PRICE", index, controller.arrListTitle, controller.isScrollEnable, isSmallLarge: true, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'TOTAL SELL QTY':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("TOTAL SELL QTY", index, controller.arrListTitle, controller.isScrollEnable, isSmallLarge: true, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'SELL A PRICE':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("SELL A PRICE", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
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
              case 'NET LOT':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("NET LOT", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
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

              case 'P/L':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("P/L", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'P/L % WISE':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("P/L % WISE", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
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
