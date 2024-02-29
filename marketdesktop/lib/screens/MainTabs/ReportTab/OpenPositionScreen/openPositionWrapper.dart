import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/customWidgets/appScrollBar.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/OpenPositionScreen/openPositionController.dart';
import 'package:paginable/paginable.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../constant/index.dart';

import 'package:responsive_framework/responsive_framework.dart';

import '../../../../constant/utilities.dart';
import '../../../../main.dart';

class OpenPositionScreen extends BaseView<OpenPositionController> {
  const OpenPositionScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                filterPanel(context, bottomMargin: 0, isRecordDisplay: true, totalRecord: controller.totalCount, onCLickFilter: () {
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
      ),
    );
  }

  Widget filterContent(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Visibility(
        visible: controller.isFilterOpen,
        child: AnimatedContainer(
          // margin: EdgeInsets.only(bottom: 2.h),
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
                                      fontFamily: CustomFonts.family2Regular,
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
                                    fontFamily: CustomFonts.family2Regular,
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
                                    fontFamily: CustomFonts.family2Regular,
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
                            width: 10,
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
                                controller.getPositionList("", isFromFilter: true);
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
                              focusKey: controller.clearFocus,
                              borderColor: Colors.transparent,
                              focusShadowColor: AppColors().blueColor,
                              onPress: () {
                                controller.selectedExchange.value = ExchangeData();
                                controller.selectedScriptFromFilter.value = GlobalSymbolData();
                                controller.selectedUser.value = UserData();
                                controller.arrPositionScriptList.clear();
                                controller.currentPage = 1;
                                controller.getPositionList("", isFromFilter: true, isFromReset: true);
                              },
                              bgColor: AppColors().whiteColor,
                              isFilled: true,
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
          duration: Duration(milliseconds: 100),
          width: controller.isFilterOpen ? 1510 : 1840,
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
                    ? dataNotFoundView("Open Position not found")
                    : CustomScrollBar(
                        bgColor: AppColors().blueColor,
                        child: PaginableListView.builder(
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
                        width: 35.w,
                      ),
                    ],
                  ),
                ),
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
   //   var historyValue = controller.arrPositionScriptList[index];
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
                  case 'SCRIPT':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(
                              controller.arrPositionScriptList[index].symbolTitle ?? "",
                              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                              AppColors().darkText,
                              index,
                              indexT,
                              controller.arrListTitle,
                              isBig: true,
                            )
                          : const SizedBox();
                    }
                  case 'TOTAL BUY QTY':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? IgnorePointer(
                              child: dynamicValueBox(controller.arrPositionScriptList[index].buyTotalQuantity.toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().blueColor, index, indexT, controller.arrListTitle, isSmallLarge: true),
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
                  case 'PROFIT/LOSS':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? IgnorePointer(
                              child: dynamicValueBox(double.parse(controller.arrPositionScriptList[index].profitLossValue!.toStringAsFixed(2)).toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, controller.getPriceColor(controller.arrPositionScriptList[index].profitLossValue!),
                                  index, indexT, controller.arrListTitle),
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
              case 'SCRIPT':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("SCRIPT", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isBig: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'TOTAL BUY QTY':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("TOTAL BUY QTY", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isSmallLarge: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'BUY A PRICE':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("BUY A PRICE", index, controller.arrListTitle, controller.isScrollEnable, isSmallLarge: true, updateCallback: controller.refreshView)
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

              case 'PROFIT/LOSS':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("PROFIT/LOSS", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
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
