import 'dart:async';
import 'package:get/get.dart';
import 'package:marketdesktop/customWidgets/appScrollBar.dart';
import 'package:marketdesktop/modelClass/settelementListModelClass.dart';
import '../../../constant/index.dart';
import 'package:marketdesktop/screens/UserDetailPopups/SettlementPopUp/settlementPopUpController.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../constant/utilities.dart';
import '../../../customWidgets/appButton.dart';

class SettlementPopUpScreen extends BaseView<SettlementPopUpController> {
  const SettlementPopUpScreen({Key? key}) : super(key: key);

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
                        Text("From:",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: CustomFonts.family1Regular,
                              color: AppColors().fontColor,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            showCalenderPopUp(DateTime.now(), (DateTime selectedDate) {
                              controller.fromDate.value = shortDateForBackend(selectedDate);
                            });
                          },
                          child: Obx(() {
                            return Container(
                              height: 4.h,
                              width: 250,
                              decoration: BoxDecoration(
                                  color: AppColors().whiteColor,
                                  border: Border.all(
                                    color: AppColors().lightOnlyText,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(3)),
                              // color: AppColors().whiteColor,
                              padding: const EdgeInsets.only(right: 10),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    controller.fromDate.value,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: CustomFonts.family1Medium,
                                      color: AppColors().darkText,
                                    ),
                                  ),
                                  const Spacer(),
                                  Image.asset(
                                    AppImages.calendarIcon,
                                    width: 25,
                                    height: 25,
                                    color: AppColors().fontColor,
                                  )
                                ],
                              ),
                            );
                          }),
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
                  SizedBox(
                    height: 4.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // SizedBox(
                        //   width: 30,
                        // ),
                        const Spacer(),

                        Text("To:",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: CustomFonts.family1Regular,
                              color: AppColors().fontColor,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            // selectToDate(controller.endDate);
                            showCalenderPopUp(DateTime.now(), (DateTime selectedDate) {
                              controller.endDate.value = shortDateForBackend(selectedDate);
                            });
                          },
                          child: Obx(() {
                            return Container(
                              height: 4.h,
                              width: 250,
                              decoration: BoxDecoration(
                                  color: AppColors().whiteColor,
                                  border: Border.all(
                                    color: AppColors().lightOnlyText,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(3)),
                              // color: AppColors().whiteColor,
                              padding: const EdgeInsets.only(right: 10),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    controller.endDate.value,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: CustomFonts.family1Medium,
                                      color: AppColors().darkText,
                                    ),
                                  ),
                                  const Spacer(),
                                  Image.asset(
                                    AppImages.calendarIcon,
                                    width: 25,
                                    height: 25,
                                    color: AppColors().fontColor,
                                  )
                                ],
                              ),
                            );
                          }),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Text("Opening ?:",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: CustomFonts.family1Regular,
                            color: AppColors().fontColor,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 280,
                        // height: 50,
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 100,
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text(
                                  'Without',
                                ),
                                horizontalTitleGap: 0,
                                dense: true,
                                visualDensity: const VisualDensity(
                                  vertical: -3,
                                ),
                                titleTextStyle: TextStyle(
                                  fontSize: 12,
                                  fontFamily: CustomFonts.family1Regular,
                                  color: AppColors().fontColor,
                                ),
                                leading: Radio<SettlementType>(
                                  value: SettlementType.without,
                                  activeColor: AppColors().darkText,
                                  groupValue: controller.selectedSettlementType!,
                                  onChanged: (SettlementType? value) {
                                    controller.selectedSettlementType = value;
                                    controller.update();
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text(
                                  'With',
                                ),
                                horizontalTitleGap: 0,
                                dense: true,
                                visualDensity: const VisualDensity(vertical: -3),
                                titleTextStyle: TextStyle(
                                  fontSize: 12,
                                  fontFamily: CustomFonts.family1Regular,
                                  color: AppColors().fontColor,
                                ),
                                leading: Radio<SettlementType>(
                                  value: SettlementType.within,
                                  activeColor: AppColors().darkText,
                                  groupValue: controller.selectedSettlementType!,
                                  onChanged: (SettlementType? value) {
                                    controller.selectedSettlementType = value;
                                    controller.update();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
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
                            controller.fromDate.value = "";
                            controller.endDate.value = "";
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
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: controller.isFilterOpen ? 920 : 1300,
          // margin: EdgeInsets.only(right: 1.w),
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
                  child: Column(
                    children: [
                      Container(
                        height: 3.h,
                        decoration: BoxDecoration(
                            color: AppColors().whiteColor,
                            border: Border(bottom: BorderSide(color: AppColors().lightOnlyText, width: 1))),
                        child: Center(
                          child: Text("Profit",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: CustomFonts.family1Medium,
                                color: AppColors().greenColor,
                              )),
                        ),
                      ),
                      Container(
                        height: 3.h,
                        color: AppColors().whiteColor,
                        child: listTitleContent(),
                      ),
                      Expanded(
                        child: CustomScrollBar(
                          bgColor: AppColors().blueColor,
                          child: ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              clipBehavior: Clip.hardEdge,
                              itemCount: controller.arrProfitList.length,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return profitLossContent(context, index, controller.arrProfitList[index]);
                              }),
                        ),
                      ),
                      Container(
                        height: 3.h,
                        decoration: BoxDecoration(
                            color: AppColors().whiteColor,
                            border: Border(top: BorderSide(color: AppColors().lightOnlyText, width: 1))),
                        child: Center(
                            child: Row(
                          children: [
                            totalContent(value: "Net Profit", textColor: AppColors().darkText, width: 110),
                            totalContent(
                                value: controller.totalValues!.plProfitGrandTotal.toStringAsFixed(2),
                                textColor: AppColors().darkText,
                                width: 110),
                            totalContent(
                                value: controller.totalValues!.brkProfitGrandTotal.toStringAsFixed(2),
                                textColor: AppColors().darkText,
                                width: 110),
                            totalContent(
                                value: controller.totalValues!.profitGrandTotal.toStringAsFixed(2),
                                textColor: AppColors().darkText,
                                width: 110),
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 3,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
                  child: Column(
                    children: [
                      Container(
                        height: 3.h,
                        decoration: BoxDecoration(
                            color: AppColors().whiteColor,
                            border: Border(bottom: BorderSide(color: AppColors().lightOnlyText, width: 1))),
                        child: Center(
                          child: Text("Loss",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: CustomFonts.family1Medium,
                                color: AppColors().redColor,
                              )),
                        ),
                      ),
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
                            itemCount: controller.arrLossList.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return profitLossContent(context, index, controller.arrLossList[index]);
                            }),
                      ),
                      Container(
                        height: 3.h,
                        decoration: BoxDecoration(
                            color: AppColors().whiteColor,
                            border: Border(top: BorderSide(color: AppColors().lightOnlyText, width: 1))),
                        child: Center(
                            child: Row(
                          children: [
                            totalContent(value: "Net Loss", textColor: AppColors().darkText, width: 110),
                            totalContent(
                                value: controller.totalValues!.plLossGrandTotal.toStringAsFixed(2),
                                textColor: AppColors().darkText,
                                width: 110),
                            totalContent(
                                value: controller.totalValues!.brkLossGrandTotal.toStringAsFixed(2),
                                textColor: AppColors().darkText,
                                width: 110),
                            totalContent(
                                value: controller.totalValues!.LossGrandTotal.toStringAsFixed(2),
                                textColor: AppColors().darkText,
                                width: 110),
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
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
      padding: const EdgeInsets.only(left: 5),
      decoration: BoxDecoration(
          color: AppColors().whiteColor,
          border: Border(
              top: BorderSide(color: AppColors().lightOnlyText, width: 1),
              bottom: BorderSide(color: AppColors().lightOnlyText, width: 1),
              right: BorderSide(color: AppColors().lightOnlyText, width: 1))),
      child: Text(value ?? "",
          style: TextStyle(
            fontSize: 12,
            fontFamily: CustomFonts.family1Medium,
            color: textColor ?? AppColors().redColor,
          )),
    );
  }

  Widget profitLossContent(BuildContext context, int index, Profit value) {
    // var scriptValue = controller.arrUserOderList[index];
    return GestureDetector(
      onTap: () {
        // controller.selectedScriptIndex = index;
        controller.update();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          valueBox(
              value.userName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index,
              isUnderlined: true, onClickValue: () {
            showUserDetailsPopUp(userId: value.userId!, userName: value.userName!);
          }),
          valueBox(value.profitLoss!.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
              AppColors().darkText, index),
          valueBox(value.brokerageTotal!.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
              AppColors().darkText, index),
          valueBox((value.profitLoss! - value.brokerageTotal!).toStringAsFixed(2), 45,
              index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
        ],
      ),
    );
  }

  Widget listTitleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // titleBox("", 0),

        titleBox("Username"),
        titleBox("P/L"),
        titleBox("Brk"),
        titleBox("Total"),
      ],
    );
  }
}
