import 'package:get/get.dart';

import 'package:marketdesktop/screens/UserDetailPopups/PositionPopUp/positionPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/userDetailsPopUpController.dart';
import '../../../constant/index.dart';

import 'package:responsive_framework/responsive_framework.dart';

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
      ),
    );
  }

  Widget mainContent(BuildContext context) {
    return SingleChildScrollView(
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
                  listTitleContent(),
                ],
              ),
            ),
            Container(
              height: 2,
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
                      //         userListDropDown(controller.selectedUser, width: 200),
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
    // var scriptValue = controller.arrUserOderList[index];
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (userData!.role != UserRollList.user)
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

  Widget listTitleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (userData!.role != UserRollList.user) titleBox("Parent User"),
        titleBox("Exchange"),
        titleBox("script name", isLarge: true),
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
