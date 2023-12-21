import 'dart:async';
import 'package:get/get.dart';
import 'package:marketdesktop/screens/BaseController/baseController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/MarketWatchScreen/marketWatchController.dart';

import '../../../../../constant/index.dart';

class ScriptDetailPopUpScreen extends BaseView<MarketWatchController> {
  const ScriptDetailPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return Future.value(false);
        },
        child: ScriptDetailView(context));
  }

  Widget ScriptDetailView(BuildContext context) {
    return Obx(() {
      return Container(
        // height: controller.arrScript[controller.selectedScriptIndex].depth != null ? 500 : 100,
        color: AppColors().whiteColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            headerViewContentForScriptDetail(context),
            Row(
              children: [
                controller.exchangeTypeDropDownForF5(controller.selectedExchangeForF5),
                controller.allScriptListDropDownForF5(),
              ],
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 1.w),
                color: AppColors().whiteColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 45,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 0,
                                child: Text(controller.arrScript[0].symbol!),
                              ),
                              Text(controller.selectedScriptForF5.value?.symbol ?? "", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                              Row(
                                children: [
                                  Text(controller.selectedScriptForF5.value!.bid.toString(), style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().blueColor)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(controller.selectedScriptForF5.value!.ask.toString(), style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().redColor)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text("${controller.selectedScriptForF5.value!.ch ?? ""}(${controller.selectedScriptForF5.value!.chp ?? ""}%)", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                                ],
                              ),
                            ],
                          ),
                          Spacer(),
                          Container(
                            // width: 23.5.w,
                            // color: AppColors().redColor,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 3.4.w,
                                ),
                                Column(
                                  children: [
                                    Text("Open", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().lightText)),
                                    Text(controller.selectedScriptForF5.value!.open.toString(), style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                                  ],
                                ),
                                SizedBox(
                                  width: 2.5.w,
                                ),
                                Column(
                                  children: [
                                    Text("High", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().lightText)),
                                    Text(controller.selectedScriptForF5.value!.high.toString(), style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                                  ],
                                ),
                                SizedBox(
                                  width: 2.4.w,
                                ),
                                Column(
                                  children: [
                                    Text("Low", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().lightText)),
                                    Text(controller.selectedScriptForF5.value!.low.toString(), style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                                  ],
                                ),
                                SizedBox(
                                  width: 2.4.w,
                                ),
                                Column(
                                  children: [
                                    Text("Prev. close", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().lightText)),
                                    Text(controller.selectedScriptForF5.value!.close.toString(), style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 2.w,
                          )
                        ],
                      ),
                    ),
                    if (controller.selectedScriptForF5.value!.depth != null)
                      Container(
                        // margin: EdgeInsets.symmetric(
                        //   horizontal: 5.w,
                        // ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 12.w,
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 4.w,
                                        child: Text("Bid", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().lightText)),
                                      ),
                                      Container(
                                        width: 4.w,
                                        child: Text("Order", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().lightText)),
                                      ),
                                      Container(
                                        width: 4.w,
                                        child: Text("Qty", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().lightText)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      clipBehavior: Clip.hardEdge,
                                      shrinkWrap: true,
                                      itemCount: controller.selectedScriptForF5.value!.depth!.buy!.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return bottomSheetList((controller.selectedScriptForF5.value!.depth!.buy![index].price ?? 0).toString(), (controller.selectedScriptForF5.value!.depth!.buy![index].orders ?? 0).toString(),
                                            (controller.selectedScriptForF5.value!.depth!.buy![index].quantity ?? 0).toString(), AppColors().blueColor, 0);
                                      },
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Text("Total", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().blueColor)),
                                        SizedBox(
                                          width: 5.5.w,
                                        ),
                                        Text(controller.getTotal(true).toStringAsFixed(2), style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().blueColor)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 12.w,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 4.w,
                                        child: Text("Offer", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().lightText)),
                                      ),
                                      Container(
                                        width: 4.w,
                                        child: Text("Order", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().lightText)),
                                      ),
                                      Container(
                                        width: 4.w,
                                        child: Text("Qty", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().lightText)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      clipBehavior: Clip.hardEdge,
                                      shrinkWrap: true,
                                      controller: controller.sheetController,
                                      itemCount: controller.selectedScriptForF5.value!.depth!.sell!.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return bottomSheetList((controller.selectedScriptForF5.value!.depth!.sell![index].price ?? 0).toString(), (controller.selectedScriptForF5.value!.depth!.sell![index].orders ?? 0).toString(),
                                            (controller.selectedScriptForF5.value!.depth!.sell![index].quantity ?? 0).toString(), AppColors().redColor, 0);
                                      },
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Text("Total", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().redColor)),
                                        SizedBox(
                                          width: 5.5.w,
                                        ),
                                        Text(controller.getTotal(false).toStringAsFixed(2), style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().redColor)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              // width: 30.w,
                              child: ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                clipBehavior: Clip.hardEdge,
                                shrinkWrap: true,
                                controller: controller.sheetController,
                                children: [
                                  sheetList("Lot Size", controller.selectedScriptForF5.value!.ls!.toString(), 0),
                                  sheetList("LTP", controller.selectedScriptForF5.value!.ltp!.toString(), 1),
                                  sheetList("Volume", controller.selectedScriptForF5.value!.volume!.toString(), 2),
                                  sheetList("Avg. Price", "Key Not found", 3),
                                  // sheetList("Time", shortTime(controller.selectedScriptForF5.value!.lut!), 4)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                  ],
                )),
          ],
        ),
      );
    });
  }

  Widget sheetList(String name, String value, int index) {
    Color backgroundColor = index % 2 == 0 ? AppColors().headerBgColor : AppColors().contentBg;
    return Container(
      width: 100.w,
      height: 35,
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 2.w,
        ),
        child: Row(
          children: [
            Text(name.toString(), style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
            const Spacer(),
            Text(value.toString(), style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1SemiBold, color: AppColors().blueColor)),
          ],
        ),
      ),
    );
  }

  Widget bottomSheetList(String bid, String order, String Qty, Color fontColors, int index) {
    return Container(
      height: 25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(width: 4.w, child: Text(bid.toString(), style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: fontColors))),
          Container(width: 4.w, padding: EdgeInsets.only(left: 13), child: Text(order.toString(), style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: fontColors))),
          Container(width: 4.w, child: Text(Qty.toString(), style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: fontColors))),
        ],
      ),
    );
  }

  Widget headerViewContentForScriptDetail(BuildContext context) {
    return Container(
        height: 40,
        decoration: BoxDecoration(
            color: AppColors().whiteColor,
            border: Border(
              bottom: BorderSide(color: AppColors().lightOnlyText, width: 1),
            )),
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Image.asset(
              AppImages.appLogo,
              width: 3.h,
              height: 3.h,
            ),
            SizedBox(
              width: 10,
            ),
            Text("Market Picture",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().blueColor,
                )),
            Spacer(),
            GestureDetector(
              onTap: () {
                controller.isScripDetailOpen = false;

                controller.update();

                Get.back();
              },
              child: Container(
                width: 3.h,
                height: 3.h,
                padding: EdgeInsets.all(0.5.h),
                child: Image.asset(
                  AppImages.closeIcon,
                  color: AppColors().redColor,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ));
  }
}
