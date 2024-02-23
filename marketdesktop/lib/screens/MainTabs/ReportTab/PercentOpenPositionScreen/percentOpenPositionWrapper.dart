import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/customWidgets/appScrollBar.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/PercentOpenPositionScreen/percentOpenPositionController.dart';

import '../../../../constant/index.dart';

import 'package:responsive_framework/responsive_framework.dart';

class PercentOpenPositionScreen extends BaseView<PercentOpenPositionController> {
  const PercentOpenPositionScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              filterPanel(context, bottomMargin: 0, isRecordDisplay: true, onCLickFilter: () {
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
                    height: 4.h,
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
                    height: 4.h,
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
                  Container(
                    height: 4.h,
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
                        allScriptListDropDown(controller.selectedScriptFromFilter, arrSymbol: controller.arrExchangeWiseScript),
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
                        width: 6.w,
                        height: 3.h,
                        child: CustomButton(
                          isEnabled: true,
                          shimmerColor: AppColors().whiteColor,
                          title: "Apply",
                          textSize: 14,
                          onPress: () {},
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
    return CustomScrollBar(
      bgColor: AppColors().blueColor,
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          width: controller.isFilterOpen ? 88.w : 96.w,
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
                      itemCount: 5,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return orderContent(context, index);
                      }),
                ),
              ),
              Container(
                height: 2.h,
                decoration: BoxDecoration(
                    color: AppColors().whiteColor,
                    border: Border(
                      top: BorderSide(color: AppColors().lightOnlyText, width: 1),
                    )),
                child: Row(
                  children: [
                    Spacer(),
                    Text("Total P/L : 24 960.00", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
                    SizedBox(
                      width: 10,
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
    // var scriptValue = controller.arrUserOderList[index];
    return GestureDetector(
      onTap: () {
        controller.update();
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            valueBox("", 0, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index, isImage: true, strImage: AppImages.viewIcon),
            valueBox("MCX", 33, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
            valueBox("MCX GOLD Oct 05", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().redColor, index, isBig: true),
            valueBox("24.00", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true),
            valueBox("0.00", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
            valueBox("58906.00", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true),
            valueBox("10.00", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true),
            valueBox("0.00", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
            valueBox("58906.00", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true),
            valueBox("14.00", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
            valueBox("0.00", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
            valueBox("-463,300.00", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().redColor, index, isBig: true),
            valueBox("0.00", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().blueColor, index, isBig: true),
          ],
        ),
      ),
    );
  }

  Widget listTitleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        titleBox("View", isSmall: true),
        titleBox("Exchange"),
        titleBox("Symbol", isBig: true),
        titleBox("Total Buy Qty", isBig: true),
        titleBox("%Buy Qty"),
        titleBox("Buy Avg Price", isBig: true),
        titleBox("Total Sell Qty", isBig: true),
        titleBox("%Sell Qty"),
        titleBox("Sell Avg Price", isBig: true),
        titleBox("Net Qty"),
        titleBox("%Net Qty"),
        titleBox("Profit_Loss", isBig: true),
        titleBox("%Profit_Loss", isBig: true),
      ],
    );
  }
}
