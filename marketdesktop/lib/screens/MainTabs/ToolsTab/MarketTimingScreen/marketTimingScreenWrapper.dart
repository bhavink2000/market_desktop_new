import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marketdesktop/constant/index.dart';
import 'package:marketdesktop/screens/MainTabs/ToolsTab/MarketTimingScreen/marketTimingScreenController.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../constant/color.dart';
import '../../../../constant/assets.dart';
import '../../../../constant/utilities.dart';
import '../../../../customWidgets/appButton.dart';
import '../../../../modelClass/exchangeListModelClass.dart';
import '../../../BaseController/baseController.dart';

class MarketTimingScreen extends BaseView<MarketTimingController> {
  const MarketTimingScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: AppColors().bgColor,
          body: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: AppColors().bgColor,
            ),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    headerViewContent(
                        title: "Market Timing",
                        isFilterAvailable: false,
                        isFromMarket: false,
                        closeClick: () {
                          Get.back();
                          Get.delete<MarketTimingController>();
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        exchangeDropDownView(),
                        searchBtnView(),
                      ],
                    ),
                    if (controller.arrTiming.isEmpty &&
                        controller.selectedExchangedropdownValue!.value!
                                .exchangeId ==
                            null)
                      Container(
                        // height: 580,
                        child: Center(child: Text("Please select exchange.")),
                      ),
                    if (controller.arrTiming.isEmpty &&
                        controller.selectedExchangedropdownValue!.value!
                                .exchangeId !=
                            null)
                      Container(
                        // height: 580,
                        child: Center(child: Text("No data found")),
                      ),
                    if (controller.arrTiming.isNotEmpty) customCalender(),
                    if (controller.isDateSelected == true)
                      Expanded(
                        child: ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            clipBehavior: Clip.hardEdge,
                            itemCount: controller.arrTiming.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return dateTimingView(context, index);
                            }),
                      ),
                  ],
                ))
              ],
            ),
          ),
        ));
  }

  Widget exchangeDropDownView() {
    return Container(
      width: 220,
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.only(right: 15),
      child: Obx(() {
        return Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<ExchangeData>(
              isExpanded: true,
              decoration: commonFocusBorder,
              dropdownStyleData: DropdownStyleData(
                maxHeight: 300,
                decoration: BoxDecoration(
                  color: AppColors().grayBg,
                ),
              ),
              iconStyleData: IconStyleData(
                  icon: Image.asset(
                    AppImages.arrowDown,
                    height: 20,
                    width: 20,
                    color: AppColors().fontColor,
                  ),
                  openMenuIcon: AnimatedRotation(
                    turns: 0.5,
                    duration: const Duration(milliseconds: 400),
                    child: Image.asset(
                      AppImages.arrowDown,
                      width: 20,
                      height: 20,
                      color: AppColors().fontColor,
                    ),
                  )),
              hint: Text(
                'Select Exchange',
                maxLines: 1,
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: CustomFonts.family1Medium,
                    color: AppColors().lightText,
                    overflow: TextOverflow.ellipsis),
              ),
              items: controller.arrExchangeList
                  .map((ExchangeData item) => DropdownItem<ExchangeData>(
                        value: item,
                        height: 30,
                        child: Text(
                          item.name ?? "",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: CustomFonts.family1Medium,
                            color: AppColors().darkText,
                          ),
                        ),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return controller.arrExchangeList
                    .map((ExchangeData item) => DropdownMenuItem<ExchangeData>(
                          value: item,
                          child: Text(
                            item.name ?? "",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: CustomFonts.family1Medium,
                              color: AppColors().darkText,
                            ),
                          ),
                        ))
                    .toList();
              },
              value:
                  controller.selectedExchangedropdownValue!.value!.exchangeId !=
                          null
                      ? controller.selectedExchangedropdownValue!.value
                      : null,
              onChanged: (ExchangeData? value) {
                // setState(() {
                controller.selectedExchangedropdownValue!.value = value!;
                controller.getHolidayList();
                controller.update();
                // });
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 54,
                // width: 140,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget searchBtnView() {
    return Center(
      child: SizedBox(
        width: 110,
        height: 40,
        child: CustomButton(
          isEnabled: true,
          shimmerColor: AppColors().whiteColor,
          title: "Search",
          textSize: 16,
          focusKey: controller.viewFocus,
          borderColor: Colors.transparent,
          focusShadowColor: AppColors().blueColor,
          onPress: () {
            if (controller.selectedExchangedropdownValue!.value!.exchangeId !=
                null) {
              // controller.isSearchPressed = true.obs;
              controller.getTiming();
            } else {
              showWarningToast("Please Select Exchange");
            }
          },
          bgColor: AppColors().blueColor,
          isFilled: true,
          textColor: AppColors().whiteColor,
          isTextCenter: true,
          isLoading: controller.isApiCallRunning,
        ),
      ),
    );
  }

  Widget customCalenderHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            controller.currentMonth,
            style: TextStyle(
              fontSize: 16,
              fontFamily: CustomFonts.family1SemiBold,
              color: AppColors().darkText,
            ),
          )),
          GestureDetector(
            onTap: () {
              controller.targetDateTime = DateTime(
                  controller.targetDateTime.year,
                  controller.targetDateTime.month - 1);
              controller.currentMonth =
                  DateFormat.yMMM().format(controller.targetDateTime);
              controller.update();
            },
            child: Image.asset(
              AppImages.calenderarrowleft,
              height: 16,
              width: 10,
              // color: AppColors().blueColor,
            ),
          ),
          SizedBox(
            width: 30,
          ),
          GestureDetector(
            onTap: () {
              controller.targetDateTime = DateTime(
                  controller.targetDateTime.year,
                  controller.targetDateTime.month + 1);
              controller.currentMonth =
                  DateFormat.yMMM().format(controller.targetDateTime);
              controller.update();
            },
            child: Image.asset(
              AppImages.calenderarrowright,
              height: 16,
              width: 10,
              // color: AppColors().blueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget customCalender() {
    var valueObj = controller.arrTiming.first;
    return Column(
      children: [
        Container(
          height: controller.screenSize!.width > 1280 ? 360 : 350,
          width: 400,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors().footerColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors().fontColor.withOpacity(0),
                  offset: Offset.zero,
                  spreadRadius: 5,
                  blurRadius: 10,
                ),
              ]),
          margin: EdgeInsets.only(top: 10, left: 5, right: 5),
          child: Column(
            children: [
              customCalenderHeader(),
              CalendarCarousel<Event>(
                onDayPressed: (date, events) {
                  // if (valueObj.weekOff!.contains(date.weekday)) {
                  controller.currentDate2 = date;
                  events.forEach((event) => print(event.title));
                  controller.isDateSelected = true.obs;
                  controller.update();
                  // } else {
                  //   controller.isDateSelected = false.obs;
                  //   controller.currentDate2 = date;
                  //   controller.update();
                  // }
                },
                showOnlyCurrentMonthDate: false,
                height: 307,
                selectedDateTime: controller.currentDate2,
                targetDateTime: controller.targetDateTime,
                customGridViewPhysics: NeverScrollableScrollPhysics(),
                showHeader: false,
                selectedDayButtonColor: AppColors().blueColor,
                todayButtonColor: AppColors().lightOnlyText,
                customDayBuilder: (isSelectable,
                    index,
                    isSelectedDay,
                    isToday,
                    isPrevMonthDay,
                    textStyle,
                    isNextMonthDay,
                    isThisMonthDay,
                    day) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: CustomFonts.family1SemiBold,
                          color: isPrevMonthDay || isNextMonthDay
                              ? AppColors().lightOnlyText
                              : isSelectedDay || isToday
                                  ? AppColors().whiteColor
                                  : valueObj.weekOff!.contains(day.weekday)
                                      ? controller.arrHoliday.indexWhere(
                                                  (element) =>
                                                      element.startDate!.day ==
                                                          day.day &&
                                                      element.startDate!
                                                              .month ==
                                                          day.month &&
                                                      element.startDate!.year ==
                                                          day.year) ==
                                              -1
                                          ? Colors.green
                                          : AppColors().redColor
                                      : AppColors().redColor,
                        ),
                      ),
                    ),
                  );
                },
                customWeekDayBuilder: (weekday, weekdayName) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    weekdayName.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: CustomFonts.family1SemiBold,
                      color: AppColors().lightText,
                    ),
                  ),
                ),
                minSelectedDate:
                    controller.currentDate.subtract(Duration(days: 360)),
                maxSelectedDate:
                    controller.currentDate.add(Duration(days: 360)),
                onCalendarChanged: (DateTime date) {
                  controller.targetDateTime = date;
                  controller.currentMonth =
                      DateFormat.yMMM().format(controller.targetDateTime);
                  controller.update();
                  // dateTimingView();
                },
              ),
            ],
          ),
        ),
        if (controller.isDateSelected == false)
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              '  No Selected Date',
              maxLines: 1,
              style: TextStyle(
                  fontSize: 12,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().lightText,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
      ],
    );
  }

  Widget dateTimingView(BuildContext context, int index) {
    var valueObj = controller.arrTiming[index];
    var valueObj1 = controller.arrTiming.first;
    var isWeekEnd =
        !valueObj1.weekOff!.contains(controller.currentDate2.weekday);
    print(controller.currentDate2);
    var isHoliday = false;
    var holiday = "";

    for (var element in controller.arrHoliday) {
      print(element.startDate);
      if (element.startDate == controller.currentDate2) {
        print("Match");
        isHoliday = true;
        holiday = element.text ?? "";
      }
    }
    if (isHoliday == false && isWeekEnd) {
      isHoliday = true;
      holiday = "WEEKEND";
    }
    return Container(
      // height: 6.h,

      margin: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: controller.arrTiming.length == 1 ||
                  controller.arrTiming.length == 2
              ? 5
              : 0),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                DateFormat('EEE').format(controller.currentDate2).toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: CustomFonts.family1Medium,
                  color:
                      isHoliday ? AppColors().redColor : AppColors().blueColor,
                ),
              ),
              Container(
                width: 48,
                decoration: BoxDecoration(
                    color: isHoliday
                        ? AppColors().redColor
                        : AppColors().blueColor,
                    borderRadius: BorderRadius.circular(13.5)),
                child: Center(
                  child: Text(
                    controller.currentDate2.day.toString(),
                    style: TextStyle(
                      fontSize: controller.arrTiming.length == 1 ||
                              controller.arrTiming.length == 2
                          ? 18
                          : 14,
                      fontFamily: CustomFonts.family1Medium,
                      color: AppColors().whiteColor,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Container(
              height: controller.arrTiming.length == 1 ||
                      controller.arrTiming.length == 2
                  ? 5.6.h
                  : 3.h,
              decoration: BoxDecoration(
                  color:
                      isHoliday ? AppColors().redColor : AppColors().blueColor,
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text(
                  isHoliday
                      ? holiday
                      : valueObj.startTime! + " - " + valueObj.endTime!,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: CustomFonts.family1Medium,
                    color: AppColors().whiteColor,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
