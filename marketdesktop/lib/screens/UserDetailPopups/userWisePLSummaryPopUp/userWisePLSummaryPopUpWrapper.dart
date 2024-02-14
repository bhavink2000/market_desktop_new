import 'dart:async';

import 'package:get/get.dart';
import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';

import 'package:marketdesktop/screens/UserDetailPopups/userWisePLSummaryPopUp/userWisePLSummaryPopUpController.dart';

import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../constant/index.dart';
import '../../../main.dart';

class UserWisePLSummaryPopUpScreen extends BaseView<UserWisePLSummaryPopUpController> {
  const UserWisePLSummaryPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return Future.value(false);
        },
        child: GestureDetector(
          onTap: () {},
          child: Column(
            children: [
              headerViewContent(
                  title: "User Wise Profit & Loss Summary",
                  isFilterAvailable: false,
                  isFromMarket: false,
                  closeClick: () {
                    Get.back();
                    Get.delete<UserWisePLSummaryPopUpController>();
                  }),
              Expanded(
                child: Row(
                  children: [
                    filterPanel(context, isRecordDisplay: true, onCLickFilter: () {
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
        ));
  }

  Widget filterContent(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(color: AppColors().whiteColor, width: 1),
      )),
      width: controller.isFilterOpen ? 380 : 0,
      duration: const Duration(milliseconds: 100),
      child: Offstage(
        offstage: !controller.isFilterOpen,
        child: Column(
          children: [
            const SizedBox(
              width: 35,
            ),
            SizedBox(
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text("Filter",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: CustomFonts.family1SemiBold,
                        color: AppColors().darkText,
                      )),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      controller.isFilterOpen = false;
                      controller.update();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      width: 30,
                      height: 30,
                      color: Colors.transparent,
                      child: Image.asset(
                        AppImages.closeIcon,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
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
                    height: 4.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Text("Username:",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: CustomFonts.family1Regular,
                              color: AppColors().fontColor,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        userListDropDown(controller.selectedUser),
                        const SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 70,
                      ),
                      SizedBox(
                        width: 6.w,
                        height: 3.h,
                        child: CustomButton(
                          isEnabled: true,
                          shimmerColor: AppColors().whiteColor,
                          title: "Apply",
                          textSize: 14,
                          onPress: () {
                            controller.selectedUserId = controller.selectedUser.value.userId!;
                            controller.getProfitLossList("");
                          },
                          bgColor: AppColors().blueColor,
                          isFilled: true,
                          textColor: AppColors().whiteColor,
                          isTextCenter: true,
                          isLoading: false,
                        ),
                      ),
                      SizedBox(
                        width: 1.w,
                      ),
                      SizedBox(
                        width: 6.w,
                        height: 3.h,
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
                            controller.getProfitLossList("");
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
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: controller.isFilterOpen ? 1555 : 1860,
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
                  itemCount: controller.arrPlList.length,
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
                case 'SHARING %':
                  {
                    return controller.arrListTitle[indexT].isSelected
                        ? dynamicValueBox(
                            plObj.role == UserRollList.user ? plObj.profitAndLossSharingDownLine!.toString() : plObj.profitAndLossSharing!.toString(),
                            index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                            AppColors().darkText,
                            index,
                            indexT,
                            controller.arrListTitle,
                            isBig: true,
                          )
                        : const SizedBox();
                  }
                case 'BRK SHARING %':
                  {
                    return controller.arrListTitle[indexT].isSelected
                        ? dynamicValueBox(
                            plObj.role == UserRollList.user ? plObj.brkSharingDownLine!.toString() : plObj.brkSharing!.toString(),
                            index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                            AppColors().darkText,
                            index,
                            indexT,
                            controller.arrListTitle,
                            isSmallLarge: true,
                          )
                        : const SizedBox();
                  }
                case 'RELEASE CLIENT P/L':
                  {
                    return controller.arrListTitle[indexT].isSelected
                        ? dynamicValueBox(
                            plObj.role == UserRollList.user ? plObj.profitLoss!.toStringAsFixed(2) : plObj.childUserProfitLossTotal!.toStringAsFixed(2),
                            index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                            plObj.totalProfitLossValue < 0
                                ? AppColors().redColor
                                : plObj.totalProfitLossValue > 0
                                    ? AppColors().greenColor
                                    : AppColors().darkText,
                            index,
                            indexT,
                            controller.arrListTitle,
                            isSmallLarge: true)
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
                    var pl = plObj.role == UserRollList.user ? plObj.profitLoss! : plObj.childUserProfitLossTotal!;
                    var m2m = plObj.totalProfitLossValue;
                    var sharingPer = plObj.role == UserRollList.user ? plObj.profitAndLossSharingDownLine! : plObj.profitAndLossSharing!;
                    var total = pl + m2m;
                    var finalValue = total * sharingPer / 100;

                    finalValue = finalValue * -1;

                    return controller.arrListTitle[indexT].isSelected
                        ? dynamicValueBox(
                            finalValue.toStringAsFixed(2),
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
                    var pl = plObj.role == UserRollList.user ? plObj.profitLoss! : plObj.childUserProfitLossTotal!;
                    var m2m = plObj.totalProfitLossValue;
                    var sharingPer = plObj.role == UserRollList.user ? plObj.profitAndLossSharingDownLine! : plObj.profitAndLossSharing!;
                    var total = pl + m2m;
                    var finalValue = total * sharingPer / 100;

                    finalValue = finalValue * -1;

                    finalValue = finalValue + plObj.parentBrokerageTotal!;
                    return controller.arrListTitle[indexT].isSelected
                        ? dynamicValueBox(
                            finalValue.toStringAsFixed(2),
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
              case 'SHARING %':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("SHARING %", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isBig: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'BRK SHARING %':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("BRK SHARING %", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isSmallLarge: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'RELEASE CLIENT P/L':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("RELEASE CLIENT P/L", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isSmallLarge: true)
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
