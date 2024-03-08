import 'package:get/get.dart';
import 'package:marketdesktop/customWidgets/appScrollBar.dart';

import 'package:marketdesktop/screens/UserDetailPopups/PositionPopUp/positionPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/userDetailsPopUpController.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constant/index.dart';

import 'package:responsive_framework/responsive_framework.dart';

import '../../../constant/screenColumnData.dart';
import '../../../customWidgets/appButton.dart';
import '../../../main.dart';
import '../../../modelClass/allSymbolListModelClass.dart';
import '../../../modelClass/exchangeListModelClass.dart';
import '../../../modelClass/myUserListModelClass.dart';

class PositionPopUpScreen extends BaseView<PositionPopUpController> {
  const PositionPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Visibility(
        visible: Get.find<UserDetailsPopUpController>().selectedMenuName == "Position",
        child: Row(
          children: [
            filterPanel(context, isRecordDisplay: true, totalRecord: controller.arrPositionScriptList.length, onCLickExcell: controller.onClickExcel, onCLickPDF: controller.onClickPDF, onCLickFilter: () {
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

  Widget mainContent(BuildContext context) {
    return CustomScrollBar(
      bgColor: AppColors().blueColor,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Container(
          width: 1765,
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
              Container(
                height: 2,
              ),
              Expanded(
                child: CustomScrollBar(
                  bgColor: AppColors().blueColor,
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
              ),
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
                      if (userData!.role != UserRollList.user)
                        SizedBox(
                          height: 10,
                        ),
                      // if (userData!.role != UserRollList.user)
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
                      // SizedBox(
                      //   height: 10,
                      // ),
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
                itemCount: controller.arrListTitle1.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int indexT) {
                  switch (controller.arrListTitle1[indexT].title) {
                    case UserPositionColumns.exchange:
                      {
                        return IgnorePointer(
                          child: dynamicValueBox1(
                            historyValue.exchangeName ?? "",
                            index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                            AppColors().darkText,
                            index,
                            indexT,
                            controller.arrListTitle1,
                          ),
                        );
                      }
                    case UserPositionColumns.symbolName:
                      {
                        return dynamicValueBox1(
                          controller.arrPositionScriptList[index].symbolTitle ?? "",
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          AppColors().darkText,
                          index,
                          indexT,
                          controller.arrListTitle1,
                        );
                      }
                    case UserPositionColumns.totalBuyAQty:
                      {
                        return IgnorePointer(
                          child: dynamicValueBox1(
                            controller.arrPositionScriptList[index].buyTotalQuantity.toString(),
                            index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                            AppColors().blueColor,
                            index,
                            indexT,
                            controller.arrListTitle1,
                          ),
                        );
                      }
                    case UserPositionColumns.totalBuyAPrice:
                      {
                        return IgnorePointer(
                          child: dynamicValueBox1(
                            controller.arrPositionScriptList[index].buyPrice!.toStringAsFixed(2),
                            index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                            AppColors().darkText,
                            index,
                            indexT,
                            controller.arrListTitle1,
                          ),
                        );
                      }

                    case UserPositionColumns.totalSellQty:
                      {
                        return IgnorePointer(
                          child: dynamicValueBox1(
                            controller.arrPositionScriptList[index].sellTotalQuantity!.toString(),
                            index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                            AppColors().redColor,
                            index,
                            indexT,
                            controller.arrListTitle1,
                          ),
                        );
                      }
                    case UserPositionColumns.sellAPrice:
                      {
                        return IgnorePointer(
                          child: dynamicValueBox1(controller.arrPositionScriptList[index].sellPrice!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1),
                        );
                      }
                    case UserPositionColumns.netQty:
                      {
                        return IgnorePointer(
                          child: dynamicValueBox1(controller.arrPositionScriptList[index].totalQuantity!.toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1),
                        );
                      }
                    case UserPositionColumns.netLot:
                      {
                        return IgnorePointer(
                          child: dynamicValueBox1(controller.arrPositionScriptList[index].lotSize!.toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1),
                        );
                      }
                    case UserPositionColumns.netAPrice:
                      {
                        return IgnorePointer(
                          child: dynamicValueBox1(controller.arrPositionScriptList[index].price!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1),
                        );
                      }
                    case UserPositionColumns.cmp:
                      {
                        return IgnorePointer(
                          child: dynamicValueBox1(
                              controller.arrPositionScriptList[index].totalQuantity! < 0 ? controller.arrPositionScriptList[index].ask!.toStringAsFixed(2).toString() : controller.arrPositionScriptList[index].bid!.toStringAsFixed(2).toString(),
                              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                              controller.arrPositionScriptList[index].scriptDataFromSocket.value.close! < controller.arrPositionScriptList[index].scriptDataFromSocket.value.ltp! ? AppColors().blueColor : AppColors().redColor,
                              index,
                              indexT,
                              controller.arrListTitle1),
                        );
                      }
                    case UserPositionColumns.pl:
                      {
                        return IgnorePointer(
                          child: dynamicValueBox1(double.parse(controller.arrPositionScriptList[index].profitLossValue!.toStringAsFixed(2)).toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.getPriceColor(controller.arrPositionScriptList[index].profitLossValue!), index,
                              indexT, controller.arrListTitle1),
                        );
                      }
                    case UserPositionColumns.plPerWise:
                      {
                        return IgnorePointer(
                          child: dynamicValueBox1(
                              controller.getPlPer(cmp: controller.arrPositionScriptList[index].totalQuantity! < 0 ? controller.arrPositionScriptList[index].ask! : controller.arrPositionScriptList[index].bid!, netAPrice: controller.arrPositionScriptList[index].price!).toStringAsFixed(3),
                              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                              controller.getPlPer(cmp: controller.arrPositionScriptList[index].totalQuantity! < 0 ? controller.arrPositionScriptList[index].ask! : controller.arrPositionScriptList[index].bid!, netAPrice: controller.arrPositionScriptList[index].price!) > 0
                                  ? AppColors().blueColor
                                  : AppColors().redColor,
                              index,
                              indexT,
                              controller.arrListTitle1),
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
        ),
      );
    }
  }
}
