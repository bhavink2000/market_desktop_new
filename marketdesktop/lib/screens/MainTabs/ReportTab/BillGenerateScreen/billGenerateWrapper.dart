import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/constant/dropdownFunctions.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/modelClass/constantModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/BillGenerateScreen/billGenerateController.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../constant/index.dart';
import '../../../../main.dart';

class BillGenerateScreen extends BaseView<BillGenerateController> {
  const BillGenerateScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Row(
        children: [
          filterPanel(context, isRecordDisplay: true, onCLickFilter: () {
            controller.isFilterOpen = !controller.isFilterOpen;
            controller.update();
          }),
          filterContent(context),
          Expanded(
            // flex: 8,
            child: mainContent(context),
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
                              child: Text("Time:",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: CustomFonts.family1Regular,
                                    color: AppColors().fontColor,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            timePeriodSelectionDropDown(controller.selectStatusdropdownValue, width: 150, onChange: () {
                              controller.update();
                            }),
                            SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                      ),
                      if (controller.selectStatusdropdownValue == "Custom Period")
                        SizedBox(
                          height: 10,
                        ),
                      if (controller.selectStatusdropdownValue == "Custom Period")
                        Container(
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Spacer(),
                              Container(
                                child: Text("From:",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: CustomFonts.family1Regular,
                                      color: AppColors().fontColor,
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // selectFromDate(controller.fromDate);
                                  showCalenderPopUp(DateTime.now(), (DateTime selectedDate) {
                                    controller.fromDateValue.value = selectedDate;
                                    controller.fromDate.value = shortDateForBackend(selectedDate);
                                  }, maxDate: userData!.role != UserRollList.superAdmin ? controller.thisWeekStartDate : DateTime.now());
                                },
                                child: Obx(() {
                                  return Container(
                                    height: 35,
                                    width: 150,
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
                                          width: 5,
                                        ),
                                        Text(
                                          controller.fromDate.value,
                                          style: TextStyle(
                                            fontSize: 10,
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
                              SizedBox(
                                width: 30,
                              ),
                            ],
                          ),
                        ),
                      if (controller.selectStatusdropdownValue == "Custom Period")
                        SizedBox(
                          height: 10,
                        ),
                      if (controller.selectStatusdropdownValue == "Custom Period")
                        Container(
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SizedBox(
                              //   width: 30,
                              // ),
                              Spacer(),

                              Container(
                                child: Text("To:",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: CustomFonts.family1Regular,
                                      color: AppColors().fontColor,
                                    )),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // selectToDate(controller.endDate);
                                  showCalenderPopUp(controller.fromDateValue.value, (DateTime selectedDate) {
                                    controller.endDate.value = shortDateForBackend(selectedDate);
                                  }, maxDate: userData!.role != UserRollList.superAdmin ? controller.thisWeekStartDate : DateTime.now());
                                },
                                child: Obx(() {
                                  return Container(
                                    height: 35,
                                    width: 150,
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
                                          width: 5,
                                        ),
                                        Text(
                                          controller.endDate.value,
                                          style: TextStyle(
                                            fontSize: 10,
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
                              SizedBox(
                                width: 30,
                              ),
                            ],
                          ),
                        ),
                      if (userData!.role != UserRollList.user)
                        SizedBox(
                          height: 10,
                        ),
                      if (userData!.role != UserRollList.user)
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
                        height: 5,
                      ),
                      Container(
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Container(
                              child: Text("Bill Type:",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: CustomFonts.family1Regular,
                                    color: AppColors().fontColor,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            billTypeDropDown(controller.selectedBillType, width: 150),
                            SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
                              title: "Submit",
                              textSize: 14,
                              onPress: () {
                                controller.getBill();
                              },
                              focusKey: controller.submitFocus,
                              borderColor: Colors.transparent,
                              focusShadowColor: AppColors().blueColor,
                              bgColor: AppColors().blueColor,
                              isFilled: true,
                              textColor: AppColors().whiteColor,
                              isTextCenter: true,
                              isLoading: controller.isApiCall,
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
                                if (userData!.role != UserRollList.user) {
                                  controller.selectedUser.value = UserData();
                                }

                                controller.fromDate.value = "";
                                controller.endDate.value = "";
                                controller.selectStatusdropdownValue = "".obs;
                                controller.selectedBillType.value = AddMaster();
                                controller.pdfUrl = "";
                                controller.billHtml = "";
                                controller.update();
                              },
                              bgColor: AppColors().whiteColor,
                              isFilled: true,
                              focusKey: controller.clearFocus,
                              borderColor: Colors.transparent,
                              focusShadowColor: AppColors().blueColor,
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
        ),
      ),
    );
  }

  Widget mainContent(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      width: controller.isFilterOpen ? 65.w : 95.w,
      color: Colors.white,
      child: Column(
        children: [
          if (controller.pdfUrl.isNotEmpty)
            Container(
              height: 35,
              color: AppColors().slideGrayBG,
              child: Row(
                children: [
                  Spacer(),
                  Obx(() {
                    return controller.fileDownloading.value == 0.00
                        ? GestureDetector(
                            onTap: () {
                              controller.downloadFile();
                            },
                            child: Container(
                              width: 35,
                              child: Icon(
                                Icons.download_for_offline_rounded,
                                color: AppColors().darkText,
                              ),
                            ),
                          )
                        : Container(
                            width: 35,
                            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                            child: CircularProgressIndicator(
                              color: AppColors().darkText,
                              strokeWidth: 2,
                              value: controller.fileDownloading.value,
                            ),
                          );
                  }),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
          controller.pdfUrl.isNotEmpty
              ? Expanded(
                  child: SfPdfViewer.network(controller.pdfUrl, key: controller.pdfViewerKey, initialZoomLevel: -15, canShowScrollHead: false, scrollDirection: PdfScrollDirection.vertical),
                )
              : controller.billHtml.isNotEmpty
                  ? Expanded(
                      child: SingleChildScrollView(
                        child: HtmlWidget(
                          controller.billHtml,
                        ),
                      ),
                    )
                  : Spacer(),
          Container(
            height: 2.h,
            color: AppColors().headerBgColor,
          ),
        ],
      ),
    );
  }
}
