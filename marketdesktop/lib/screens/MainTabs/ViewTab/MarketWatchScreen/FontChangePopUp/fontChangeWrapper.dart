import 'dart:async';

import 'package:get/get.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/MarketWatchScreen/FontChangePopUp/fontChangeController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/MarketWatchScreen/marketWatchController.dart';
import '../../../../../constant/index.dart';
import '../../../../../customWidgets/appButton.dart';

class FontChangeScreen extends BaseView<FontChangeController> {
  const FontChangeScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return Future.value(false);
        },
        child: Scaffold(
            backgroundColor: AppColors().bgColor,
            body: Column(
              children: [
                headerViewContent(isFilterAvailable: false, isFromMarket: false, title: "Font"),
                mainContent(context),
              ],
            )));
  }

  Widget mainContent(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 530,
        // margin: EdgeInsets.only(right: 1.w),
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              color: AppColors().whiteColor,
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 200,
                        height: 270,
                        decoration: BoxDecoration(border: Border.all(color: AppColors().grayLightLine, width: 1)),
                        child: Column(
                          children: [
                            Container(
                                width: 100.w,
                                height: 4.h,
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
                                    Text("Font Family",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: CustomFonts.family1SemiBold,
                                          color: AppColors().darkText,
                                        )),
                                  ],
                                )),
                            Expanded(
                              child: ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  clipBehavior: Clip.hardEdge,
                                  itemCount: controller.arrFont.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return fontFamilyContent(context, index);
                                  }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 150,
                        height: 270,
                        decoration: BoxDecoration(border: Border.all(color: AppColors().grayLightLine, width: 1)),
                        child: Column(
                          children: [
                            Container(
                                width: 100.w,
                                height: 4.h,
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
                                    Text("Font Style",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: CustomFonts.family1SemiBold,
                                          color: AppColors().darkText,
                                        )),
                                  ],
                                )),
                            Expanded(
                              child: ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  clipBehavior: Clip.hardEdge,
                                  itemCount: controller.arrFont[controller.selectedFamilyIndex]["family"].length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return fontStyleContent(context, index);
                                  }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 100,
                        height: 270,
                        decoration: BoxDecoration(border: Border.all(color: AppColors().grayLightLine, width: 1)),
                        child: Column(
                          children: [
                            Container(
                                width: 100.w,
                                height: 4.h,
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
                                    Text("Font Size",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: CustomFonts.family1SemiBold,
                                          color: AppColors().darkText,
                                        )),
                                  ],
                                )),
                            Expanded(
                              child: ListView.builder(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  clipBehavior: Clip.hardEdge,
                                  itemCount: controller.arrSize.length,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return fontSizeContent(context, index);
                                  }),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   width: 20,
                      // ),
                      // Container(
                      //   height: 270,
                      //   width: 340,
                      //   decoration: BoxDecoration(border: Border.all(color: AppColors().grayLightLine, width: 1)),
                      //   child: Column(
                      //     children: [
                      //       Container(
                      //           width: 100.w,
                      //           height: 4.h,
                      //           decoration: BoxDecoration(
                      //               color: AppColors().whiteColor,
                      //               border: Border(
                      //                 bottom: BorderSide(color: AppColors().lightOnlyText, width: 1),
                      //               )),
                      //           child: Row(
                      //             children: [
                      //               SizedBox(
                      //                 width: 10,
                      //               ),
                      //               Text("Preview",
                      //                   style: TextStyle(
                      //                     fontSize: 16,
                      //                     fontFamily: CustomFonts.family1SemiBold,
                      //                     color: AppColors().darkText,
                      //                   )),
                      //             ],
                      //           )),
                      //       SizedBox(
                      //         height: 100,
                      //       ),
                      //       Text("Bazaar 2.0",
                      //           style: TextStyle(
                      //             fontSize: controller.arrSize[controller.selectedSizeIndex].toDouble(),
                      //             fontFamily: controller.arrFont[controller.selectedFamilyIndex] +
                      //                 "-" +
                      //                 controller.arrStyle[controller.selectedStyleIndex],
                      //             color: AppColors().darkText,
                      //           )),
                      //       Spacer(),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     SizedBox(
                      //       width: 120,
                      //       height: 40,
                      //       child: CustomButton(
                      //         isEnabled: true,
                      //         shimmerColor: AppColors().whiteColor,
                      //         title: "Apply",
                      //         textSize: 14,
                      //         onPress: () {
                      //           var watchVc = Get.find<MarketWatchController>();
                      //           watchVc.selectedFontFamily = controller.arrFont[controller.selectedFamilyIndex] +
                      //               "-" +
                      //               controller.arrStyle[controller.selectedStyleIndex];
                      //           watchVc.selectedFontSize = controller.arrSize[controller.selectedSizeIndex].toDouble();
                      //           watchVc.update();
                      //           Get.back();
                      //         },
                      //         bgColor: AppColors().blueColor,
                      //         isFilled: true,
                      //         textColor: AppColors().whiteColor,
                      //         isTextCenter: true,
                      //         isLoading: false,
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 1.w,
                      //     ),
                      //     SizedBox(
                      //       width: 120,
                      //       height: 40,
                      //       child: CustomButton(
                      //         isEnabled: true,
                      //         shimmerColor: AppColors().whiteColor,
                      //         title: "Cancel",
                      //         textSize: 14,
                      //         prefixWidth: 0,
                      //         onPress: () {
                      //           Get.back();
                      //         },
                      //         bgColor: AppColors().whiteColor,
                      //         isFilled: true,
                      //         borderColor: AppColors().blueColor,
                      //         textColor: AppColors().blueColor,
                      //         isTextCenter: true,
                      //         isLoading: false,
                      //       ),
                      //     ),
                      //     // SizedBox(width: 5.w,),
                      //   ],
                      // ),
                      //       SizedBox(
                      //         height: 20,
                      //       )
                      //     ],
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 40,
                    child: CustomButton(
                      isEnabled: true,
                      shimmerColor: AppColors().whiteColor,
                      title: "Apply",
                      textSize: 14,
                      onPress: () {
                        var watchVc = Get.find<MarketWatchController>();
                        if (controller.arrFont[controller.selectedFamilyIndex]["name"] == "Arial") {
                          watchVc.selectedFontFamily = controller.setArialStyles(controller.selectedStyleIndex);
                        } else {
                          watchVc.selectedFontFamily = controller.arrFont[controller.selectedFamilyIndex]["name"].toString() + "-" + controller.arrFont[controller.selectedFamilyIndex]["family"][controller.selectedStyleIndex].toString();
                        }

                        watchVc.selectedFontSize = controller.arrSize[controller.selectedSizeIndex].toDouble();
                        watchVc.update();
                        Get.back();
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
                    width: 120,
                    height: 40,
                    child: CustomButton(
                      isEnabled: true,
                      shimmerColor: AppColors().whiteColor,
                      title: "Cancel",
                      textSize: 14,
                      prefixWidth: 0,
                      onPress: () {
                        Get.back();
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fontSizeContent(BuildContext context, int index) {
    return GestureDetector(
        onTap: () {
          controller.selectedSizeIndex = index;

          controller.update();
        },
        child: Container(
          height: 30,
          color: controller.selectedSizeIndex == index ? AppColors().blueColor : AppColors().whiteColor,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Text(controller.arrSize[index].toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: CustomFonts.family1Medium,
                    color: controller.selectedSizeIndex == index ? AppColors().whiteColor : AppColors().fontColor,
                  )),
            ],
          ),
        ));
  }

  Widget fontFamilyContent(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        controller.selectedFamilyIndex = index;
        controller.selectedStyleIndex = 0;

        controller.update();
      },
      child: Container(
        height: 30,
        color: controller.selectedFamilyIndex == index ? AppColors().blueColor : AppColors().whiteColor,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Text(controller.arrFont[index]["name"],
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: controller.arrFont[index]["name"] + "-Bold",
                  color: controller.selectedFamilyIndex == index ? AppColors().whiteColor : AppColors().fontColor,
                )),
          ],
        ),
      ),
    );
  }

  Widget fontStyleContent(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        controller.selectedStyleIndex = index;

        controller.update();
      },
      child: Container(
        height: 30,
        color: controller.selectedStyleIndex == index ? AppColors().blueColor : AppColors().whiteColor,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Text(controller.arrFont[controller.selectedFamilyIndex]["family"][index],
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: controller.arrFont[controller.selectedFamilyIndex]["name"] == "Arial" ? controller.setArialStyles(index) : controller.arrFont[controller.selectedFamilyIndex]["name"] + "-" + controller.arrFont[controller.selectedFamilyIndex]["family"][index],
                  color: controller.selectedStyleIndex == index ? AppColors().whiteColor : AppColors().fontColor,
                )),
          ],
        ),
      ),
    );
  }
}
