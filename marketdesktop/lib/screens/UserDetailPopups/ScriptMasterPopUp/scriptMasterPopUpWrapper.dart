import 'dart:async';

import 'package:get/get.dart';
import '../../../constant/index.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../customWidgets/appButton.dart';
import 'scriptMasterPopUpController.dart';

class ScriptMasterPopUpScreen extends BaseView<ScriptMasterPopUpController> {
  const ScriptMasterPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return Future.value(false);
        },
        child: GestureDetector(
          onTap: () {
            // controller.focusNode.requestFocus();
          },
          child: Row(
            children: [
              filterPanel(context, bottomMargin: 0, isRecordDisplay: false, onCLickFilter: () {
                controller.isFilterOpen = !controller.isFilterOpen;
                controller.update();
              }),
              filterContent(context),
              Expanded(
                flex: 8,
                child: BouncingScrollWrapper.builder(context, mainContent(context), dragWithMouse: true),
                // child: BouncingScrollWrapper.builder(context, mainContent(context), dragWithMouse: true),
              ),
              Container(
                width: 1.w,
              )
            ],
          ),
        ));
  }

  Widget filterContent(BuildContext context) {
    return AnimatedContainer(
      // margin: EdgeInsets.only(bottom: 2.h),
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
            Container(
              height: 35,
              color: AppColors().headerBgColor,
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
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 4.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Text("Exchange:",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: CustomFonts.family1Regular,
                              color: AppColors().fontColor,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        exchangeTypeDropDown(controller.selectedExchange),
                        const SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 4.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Text("Search:",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: CustomFonts.family1Regular,
                              color: AppColors().fontColor,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 250,
                          decoration: BoxDecoration(
                              color: AppColors().whiteColor, border: Border.all(color: AppColors().lightOnlyText, width: 1)),
                          child: TextFormField(
                            textInputAction: TextInputAction.search,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: CustomFonts.family1Medium,
                              color: AppColors().darkText,
                            ),
                            onFieldSubmitted: (String value) {},
                            validator: (String? value) {
                              // if (!foodTags.contains(value)) {
                              //   return 'Nothing selected.';
                              // }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8),
                              // labelText: 'Food Type',
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 0, color: Colors.transparent),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(width: 0, color: Colors.transparent),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
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
                    children: [
                      const SizedBox(
                        width: 170,
                      ),
                      SizedBox(
                        width: 6.w,
                        height: 3.h,
                        child: CustomButton(
                          isEnabled: true,
                          shimmerColor: AppColors().whiteColor,
                          title: "View",
                          textSize: 14,
                          onPress: () {},
                          bgColor: AppColors().blueColor,
                          isFilled: true,
                          textColor: AppColors().whiteColor,
                          isTextCenter: true,
                          isLoading: false,
                        ),
                      ),
                    ],
                  ),
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
        duration: const Duration(milliseconds: 300),
        width: controller.isFilterOpen ? 1750 : 1860,
        // margin: EdgeInsets.only(right: 1.w),
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
                  itemCount: 5,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return tradeContent(context, index);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget tradeContent(BuildContext context, int index) {
    // var scriptValue = controller.arrUserOderList[index];
    return GestureDetector(
      onTap: () {
        // controller.selectedScriptIndex = index;
        controller.update();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          valueBox("", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index,
              isImage: true, strImage: AppImages.checkBox),
          valueBox("MCX", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
          valueBox("ABB", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().redColor, index, isBig: true),
          valueBox("31-Aug-2023", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().redColor, index),
          valueBox("ART 31 Aug 2023", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index,
              isBig: true),
          valueBox("Fully", 60, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().greenColor, index,
              isBig: true),
          valueBox("Yes", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
        ],
      ),
    );
  }

  Widget listTitleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // titleBox("", 0),

        titleBox("", isImage: true, strImage: AppImages.checkBox),
        titleBox("Exchange"),
        titleBox("Script", isBig: true),
        titleBox("Expiry Date"),
        titleBox("Description", isBig: true),
        titleBox("Trade Attribute", isBig: true),
        titleBox("Allow Trade"),
      ],
    );
  }
}
