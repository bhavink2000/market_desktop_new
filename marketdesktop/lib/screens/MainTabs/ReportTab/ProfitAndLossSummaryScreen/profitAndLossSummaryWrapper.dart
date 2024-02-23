import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/customWidgets/appScrollBar.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/ProfitAndLossSummaryScreen/profitAndLossSummaryController.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../constant/index.dart';

import 'package:responsive_framework/responsive_framework.dart';

import '../../../../main.dart';

class ProfitAndLossSummaryScreen extends BaseView<ProfitAndLossSummaryController> {
  const ProfitAndLossSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                if (userData!.role != UserRollList.user)
                  filterPanel(context, bottomMargin: 0, isRecordDisplay: true, onCLickFilter: () {
                    controller.isFilterOpen = !controller.isFilterOpen;
                    controller.update();
                  }),
                if (userData!.role != UserRollList.user) filterContent(context),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 35,
                            child: CustomButton(
                              isEnabled: true,
                              shimmerColor: AppColors().whiteColor,
                              title: "View",
                              textSize: 14,
                              focusKey: controller.viewFocus,
                              borderColor: Colors.transparent,
                              focusShadowColor: AppColors().blueColor,
                              onPress: () {
                                controller.profitLossList();
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
                              shimmerColor: AppColors().blueColor,
                              title: "Clear",
                              textSize: 14,
                              focusKey: controller.clearFocus,
                              borderColor: Colors.transparent,
                              focusShadowColor: AppColors().blueColor,
                              prefixWidth: 0,
                              onPress: () {
                                controller.selectedUser.value = UserData();
                                controller.profitLossList(isFromClear: true);
                              },
                              bgColor: AppColors().whiteColor,
                              isFilled: true,
                              textColor: AppColors().blueColor,
                              isTextCenter: true,
                              isLoading: controller.isClearApiCallRunning,
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
          width: globalMaxWidth,
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
                child: CustomScrollBar(
                  bgColor: AppColors().blueColor,
                  child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      clipBehavior: Clip.hardEdge,
                      itemCount: controller.arrProfitLoss.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return orderContent(context, index);
                      }),
                ),
              ),
              Container(
                height: 2.h,
                child: Center(
                    child: Row(
                  children: [
                    totalContent(value: "Total", textColor: AppColors().darkText, width: 280),
                    totalContent(value: controller.getTotal("pl").toStringAsFixed(2), textColor: controller.getTotal("pl") >= 0 ? AppColors().blueColor : AppColors().redColor, width: 150),
                    totalContent(value: controller.getTotal("brk").toStringAsFixed(2), textColor: controller.getTotal("brk") >= 0 ? AppColors().blueColor : AppColors().redColor, width: 110),
                    totalContent(value: controller.getTotal("Total").toStringAsFixed(2), textColor: controller.getTotal("Total") >= 0 ? AppColors().blueColor : AppColors().redColor, width: 110),
                    totalContent(value: controller.getTotal("m2m").toStringAsFixed(2), textColor: controller.getTotal("m2m") >= 0 ? AppColors().blueColor : AppColors().redColor, width: 110),
                    totalContent(value: controller.getTotal("netPL").toStringAsFixed(2), textColor: controller.getTotal("netPL") >= 0 ? AppColors().blueColor : AppColors().redColor, width: 110),
                  ],
                )),
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

  Widget totalContent({String? value, Color? textColor, double? width}) {
    return Container(
      width: width ?? 6.w,
      padding: EdgeInsets.only(left: 5),
      decoration: BoxDecoration(color: AppColors().headerBgColor, border: Border(top: BorderSide(color: AppColors().lightOnlyText, width: 1), bottom: BorderSide(color: AppColors().lightOnlyText, width: 1), right: BorderSide(color: AppColors().lightOnlyText, width: 1))),
      child: Text(value ?? "",
          style: TextStyle(
            fontSize: 12,
            fontFamily: CustomFonts.family1Medium,
            color: textColor ?? AppColors().redColor,
          )),
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
      var scriptValue = controller.arrProfitLoss[index];
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
                  case 'DESCRIPTION':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(scriptValue.symbolTitle ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isBig: true, onClickValue: () {
                              showProfitAndLossSummaryPopUp();
                            })
                          : const SizedBox();
                    }
                  case 'PROFIT & LOSS':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(scriptValue.profitLoss!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, scriptValue.profitLoss! >= 0 ? AppColors().blueColor : AppColors().redColor, index, indexT, controller.arrListTitle, isBig: true)
                          : const SizedBox();
                    }
                  case 'BRK':
                    {
                      return controller.arrListTitle[indexT].isSelected ? dynamicValueBox(scriptValue.brokerageTotal!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().blueColor, index, indexT, controller.arrListTitle) : const SizedBox();
                    }
                  case 'TOTAL':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(scriptValue.total.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, (scriptValue.profitLoss! - scriptValue.brokerageTotal!) >= 0 ? AppColors().blueColor : AppColors().redColor, index, indexT, controller.arrListTitle)
                          : const SizedBox();
                    }
                  case 'M2M P/L':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(scriptValue.totalProfitLossValue.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, scriptValue.totalProfitLossValue >= 0 ? AppColors().blueColor : AppColors().redColor, index, indexT, controller.arrListTitle)
                          : const SizedBox();
                    }
                  case 'NET P/L':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(scriptValue.netPL.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, scriptValue.netPL >= 0 ? AppColors().blueColor : AppColors().redColor, index, indexT, controller.arrListTitle)
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
              case 'DESCRIPTION':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("DESCRIPTION", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isBig: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'PROFIT & LOSS':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("PROFIT & LOSS", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isBig: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'BRK':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("BRK", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
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
              case 'M2M P/L':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("M2M P/L", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'NET P/L':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("NET P/L", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
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
