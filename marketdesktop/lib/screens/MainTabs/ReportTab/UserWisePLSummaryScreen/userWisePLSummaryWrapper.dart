import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/UserWisePLSummaryScreen/userWisePLSummaryController.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constant/index.dart';
import '../../../../constant/utilities.dart';

class UserWisePLSummaryScreen extends BaseView<UserWisePLSummaryController> {
  const UserWisePLSummaryScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Row(
        children: [
          filterPanel(context, isRecordDisplay: true, totalRecord: controller.arrPlList.length, onCLickFilter: () {
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
                              title: "Apply",
                              textSize: 14,
                              onPress: () {
                                // controller.selectedUserId = controller.selectedUser.value.userId!;
                                controller.getProfitLossList("");
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
                              shimmerColor: AppColors().whiteColor,
                              title: "Clear",
                              textSize: 14,
                              prefixWidth: 0,
                              onPress: () {
                                controller.selectedExchange.value = ExchangeData();
                                controller.selectedScriptFromFilter.value = GlobalSymbolData();
                                controller.selectedUser.value = UserData();
                                controller.selectedUserId = "";
                                controller.getProfitLossList("", isFromClear: true);
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
              child: controller.isApiCallRunning == false && controller.isResetCall == false && controller.arrPlList.isEmpty
                  ? dataNotFoundView("PL Summary not found")
                  : ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      clipBehavior: Clip.hardEdge,
                      itemCount: controller.isApiCallRunning || controller.isResetCall ? 50 : controller.arrPlList.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return profitAndLossContent(context, index);
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

  Widget profitAndLossContent(BuildContext context, int index) {
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
      var plObj = controller.arrPlList[index];
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
                  case 'VIEW':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox("", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isImage: true, strImage: AppImages.viewIcon, isSmall: true, onClickImage: () {
                              isUserViewPopUpOpen = true;
                              showUserWisePLSummaryPopUp(userId: plObj.userId!, userName: plObj.userName!);
                            })
                          : const SizedBox();
                    }
                  case 'USERNAME':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(plObj.userName ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isBig: true, isUnderlined: true, onClickValue: () {
                              showUserDetailsPopUp(userId: plObj.userId!, userName: plObj.userName!);
                            })
                          : const SizedBox();
                    }
                  case 'CLIENT P/L':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(
                              plObj.childUserProfitLossTotal!.toStringAsFixed(2),
                              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                              plObj.totalProfitLossValue < 0
                                  ? AppColors().redColor
                                  : plObj.totalProfitLossValue > 0
                                      ? AppColors().greenColor
                                      : AppColors().darkText,
                              index,
                              indexT,
                              controller.arrListTitle,
                              isBig: false)
                          : const SizedBox();
                    }
                  case 'CLIENT BRK':
                    {
                      return controller.arrListTitle[indexT].isSelected ? valueBox(plObj.childUserBrokerageTotal!.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: false) : const SizedBox();
                    }
                  case 'CLIENT M2M':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(
                              plObj.totalProfitLossValue.toStringAsFixed(2),
                              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                              plObj.totalProfitLossValue > 0
                                  ? AppColors().greenColor
                                  : plObj.totalProfitLossValue < 0
                                      ? AppColors().redColor
                                      : AppColors().darkText,
                              index,
                              indexT,
                              controller.arrListTitle,
                              isBig: false)
                          : const SizedBox();
                    }
                  case 'P/L WITH BRK':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(
                              plObj.plWithBrk.toStringAsFixed(2),
                              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                              plObj.plWithBrk > 0
                                  ? AppColors().greenColor
                                  : plObj.plWithBrk < 0
                                      ? AppColors().redColor
                                      : AppColors().darkText,
                              index,
                              indexT,
                              controller.arrListTitle,
                              isBig: true)
                          : const SizedBox();
                    }
                  case 'P/L SHARE %':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(
                              plObj.brkSharing!.toStringAsFixed(2),
                              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                              plObj.plWithBrk > 0
                                  ? AppColors().greenColor
                                  : plObj.plWithBrk < 0
                                      ? AppColors().redColor
                                      : AppColors().darkText,
                              index,
                              indexT,
                              controller.arrListTitle,
                            )
                          : const SizedBox();
                    }
                  case 'BRK':
                    {
                      return controller.arrListTitle[indexT].isSelected ? dynamicValueBox(plObj.parentBrokerageTotal!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle) : const SizedBox();
                    }
                  case 'NET P/L':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox(
                              plObj.netPL.toStringAsFixed(2),
                              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                              plObj.netPL > 0
                                  ? AppColors().greenColor
                                  : plObj.netPL < 0.0
                                      ? AppColors().redColor
                                      : AppColors().darkText,
                              index,
                              indexT,
                              controller.arrListTitle,
                              isBig: false)
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
              case 'VIEW':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("VIEW", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isSmall: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'USERNAME':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("USERNAME", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isBig: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'CLIENT P/L':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("CLIENT P/L", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'CLIENT BRK':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("CLIENT BRK", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'CLIENT M2M':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("CLIENT M2M", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'P/L WITH BRK':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("P/L WITH BRK", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isBig: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'P/L SHARE %':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("P/L SHARE %", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
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
// view
// username
// client P/L  - childUserProfitLossTotal
// client Brk-childUserBrokerageTotal
// client m2m - childUserDataPosition
// P/L with Brk (client P/L + client Brk + client m2m)
// admin %
// Brk - parentBrokerageTotal (popup -> brokerageTotal)
// Net P/L (Brk + client P/L with Brk calculation with admin % )