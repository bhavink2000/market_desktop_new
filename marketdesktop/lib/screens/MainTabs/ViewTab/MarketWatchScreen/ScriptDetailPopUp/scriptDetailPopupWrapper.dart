import 'package:get/get.dart';
import 'package:marketdesktop/screens/BaseController/baseController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/MarketWatchScreen/marketWatchController.dart';

import '../../../../../constant/index.dart';

class ScriptDetailPopUpScreen extends BaseView<MarketWatchController> {
  const ScriptDetailPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return ScriptDetailView(context);
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
                if (controller.selectedExchangeForF5.value.isCallPut) controller.expiryTypeDropDownForF5(),
                if (controller.selectedExchangeForF5.value.isCallPut) controller.callPutTypeDropDownForF5(),
                if (controller.selectedExchangeForF5.value.isCallPut) controller.strikePriceTypeDropDownForF5(),
                Spacer(),
                Visibility(
                  visible: false,
                  child: PriceView(),
                ),
              ],
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                color: AppColors().whiteColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // margin: EdgeInsets.symmetric(
                      //   horizontal: 5.w,
                      // ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller.selectedScriptForF5.value!.depth != null)
                            Container(
                              width: 11.95.w,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2), // changes position of shadow
                                ),
                              ]),
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
                                        child: Text("Order", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().lightText)),
                                      ),
                                      Container(
                                        width: 2.9.w,
                                        child: Text("Qty", textAlign: TextAlign.right, style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().lightText)),
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
                                        Spacer(),
                                        Text(controller.getTotal(true).toStringAsFixed(2), style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().blueColor)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (controller.selectedScriptForF5.value!.depth != null)
                            SizedBox(
                              width: 10,
                            ),
                          if (controller.selectedScriptForF5.value!.depth != null)
                            Container(
                              width: 11.95.w,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5), boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2), // changes position of shadow
                                ),
                              ]),
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
                                        child: Text("Order", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().lightText)),
                                      ),
                                      Container(
                                        width: 2.9.w,
                                        child: Text("Qty", textAlign: TextAlign.right, style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().lightText)),
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
                                        Spacer(),
                                        Text(controller.getTotal(false).toStringAsFixed(2), style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().redColor)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (controller.selectedScriptForF5.value!.depth == null) Spacer(),
                          if (controller.selectedScriptForF5.value!.depth == null) Spacer(),
                          SizedBox(
                            width: 35,
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
                                sheetList("Avg. Price", "--", 3),
                                sheetList(
                                  "L. CRKT",
                                  controller.selectedScriptForF5.value!.close.toString(),
                                  4,
                                ),
                                // sheetList("Time", shortTime(controller.selectedScriptForF5.value!.lut!), 4)
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
                                sheetList("Open", controller.selectedScriptForF5.value!.open.toString().toString(), 0, width: 70),
                                sheetList("High", controller.selectedScriptForF5.value!.high!.toString(), 1, width: 70),
                                sheetList("Low", controller.selectedScriptForF5.value!.low!.toString(), 2, width: 70),
                                sheetList("Close", controller.selectedScriptForF5.value!.close.toString(), 3, width: 70),

                                sheetList("U. CRKT", controller.selectedScriptForF5.value!.close.toString(), 4, width: 70),
                                // sheetList("Time", shortTime(controller.selectedScriptForF5.value!.lut!), 4)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                )),
          ],
        ),
      );
    });
  }

  Widget sheetList(String name, String value, int index, {double width = 80}) {
    return Container(
      // width: 100.w,
      height: 35,
      // color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 1.w,
        ),
        child: Row(
          children: [
            SizedBox(width: width, child: Text(name.toString(), style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText))),
            Text(":", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
            SizedBox(
              width: 20,
            ),
            Text(value.toString(), style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1SemiBold, color: AppColors().blueColor)),
          ],
        ),
      ),
    );
  }

  Widget PriceView() {
    return Container(
      height: 45,
      width: 300,
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
          SizedBox(
            width: 2.w,
          )
        ],
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
          Container(width: 4.w, padding: EdgeInsets.only(left: 13), child: Text(order.toString(), textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: fontColors))),
          Container(width: 2.9.w, child: Text(Qty.toString(), textAlign: TextAlign.right, style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: fontColors))),
        ],
      ),
    );
  }

  Widget headerViewContentForScriptDetail(BuildContext context) {
    return Container(
        height: 35,
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          gradient: AppColors().customGradient,
          color: AppColors().redColor,
        ),
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
            Text("Market Picture (${controller.selectedScriptForF5.value?.symbol ?? ""})",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().darkText,
                )),
            Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              // width: 30,
              child: Image.asset(
                controller.selectedScriptForF5.value!.ch! < 0 ? AppImages.marketUpIcon : AppImages.marketDownIcon,
                width: 20,
                height: 20,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                controller.isScripDetailOpen = false;

                controller.update();

                Get.back();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: AppColors().customReverseGradient,
                  color: AppColors().redColor,
                ),
                width: 3.h,
                height: 3.h,
                padding: EdgeInsets.all(0.85.h),
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
