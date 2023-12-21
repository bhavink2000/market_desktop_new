import 'package:get/get.dart';
import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/screens/MainTabs/DashboardTab/dashboardController.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../constant/index.dart';
import '../../../constant/utilities.dart';
import '../../MainContainerScreen/mainContainerController.dart';

class DashboardScreen extends BaseView<DashboardController> {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Visibility(
        visible: Get.find<MainContainerController>().selectedCurrentTab == "Dashboard",
        child: mainContent(context),
      ),
    );
  }

  Widget mainContent(BuildContext context) {
    return Container(
      width: 100.w,
      height: 100.h,
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors().lightText,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      filterContentBarChart(context),
                      Expanded(
                        child: Row(
                          children: [
                            exchangeSidePanel(context),
                            Expanded(
                                flex: 8,
                                child: Container(
                                  color: AppColors().whiteColor,
                                  child: Column(
                                    children: [
                                      chartTabSelectionContent(context),
                                      if (controller.isChartViewSelected) barChart(context),
                                      if (!controller.isChartViewSelected) barChartTableMainContent(context)
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                )),
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors().lightText,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      filterContentPieChart(context),
                      Expanded(
                        child: Row(
                          children: [
                            exchangeSidePanel(context),
                            Expanded(
                                flex: 8,
                                child: Container(
                                  color: AppColors().whiteColor,
                                  child: Column(
                                    children: [
                                      pieTabSelectionContent(context),
                                      if (controller.isPieViewSelected) pieChart(context),
                                      if (!controller.isPieViewSelected) pieChartTableMainContent(context)
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                )),
              ],
            ),
          ),
          // Spacer(),
          Container(
            height: 2.h,
            color: AppColors().headerBgColor,
          ),
        ],
      ),
    );
  }

  barChartTableMainContent(BuildContext context) {
    return Expanded(
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
                barListTitleContent(),
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
                  return barOrderContent(context, index);
                }),
          ),
          Container(
            height: 2.h,
            color: AppColors().headerBgColor,
          ),
        ],
      ),
    );
  }

  pieChartTableMainContent(BuildContext context) {
    return Expanded(
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
                pieListTitleContent(),
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
                  return pieOrderContent(context, index);
                }),
          ),
          Container(
            height: 2.h,
            color: AppColors().headerBgColor,
          ),
        ],
      ),
    );
  }

  Widget barOrderContent(BuildContext context, int index) {
    // var scriptValue = controller.arrUserOderList[index];
    return GestureDetector(
      onTap: () {
        controller.update();
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            valueBox("21-Aug-2023", 60, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
            valueBox("26", 60, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
            valueBox("7", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
            valueBox("0", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
          ],
        ),
      ),
    );
  }

  Widget pieOrderContent(BuildContext context, int index) {
    // var scriptValue = controller.arrUserOderList[index];
    return GestureDetector(
      onTap: () {
        controller.update();
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            valueBox("GOLD", 60, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
            valueBox("26", 60, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
            valueBox("27", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
            valueBox("52", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
          ],
        ),
      ),
    );
  }

  Widget barListTitleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // titleBox("", 0),

        titleBox("Trade Date"),
        titleBox("Success"),
        titleBox("Canceled"),
        titleBox("Deleted"),
      ],
    );
  }

  Widget pieListTitleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // titleBox("", 0),

        titleBox("Script"),
        titleBox("Buy"),
        titleBox("Sell"),
        titleBox("Total Trades"),
      ],
    );
  }

  exchangeSidePanel(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Container(
          color: AppColors().slideGrayBG,
          child: Column(
            children: [
              Container(
                height: 35,
                decoration: BoxDecoration(
                    color: AppColors().headerBgColor,
                    border: Border(bottom: BorderSide(color: AppColors().lightOnlyText, width: 1))),
                child: Center(
                  child: Text("Exchange",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: CustomFonts.family1Medium,
                        color: AppColors().darkText,
                      )),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    clipBehavior: Clip.hardEdge,
                    itemCount: arrExchange.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return exchangeContent(context, index);
                    }),
              ),
            ],
          ),
        ));
  }

  pieChart(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SfCircularChart(
              tooltipBehavior: controller.tooltip,
              legend: Legend(position: LegendPosition.right, alignment: ChartAlignment.center, isVisible: true),
              series: <CircularSeries>[
                // Render pie chart

                PieSeries<PieChartData, String>(
                    dataSource: controller.chartData,
                    enableTooltip: true,
                    pointColorMapper: (PieChartData data, _) => data.color,
                    xValueMapper: (PieChartData data, _) => data.x,
                    yValueMapper: (PieChartData data, _) => data.y)
              ])),
    );
  }

  barChart(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SfCartesianChart(
          enableAxisAnimation: true,
          legend: Legend(isVisible: true, alignment: ChartAlignment.center, position: LegendPosition.top),
          tooltipBehavior: controller.tooltipBar,
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries<ChartData, dynamic>>[
            // Renders column chart

            ColumnSeries<ChartData, dynamic>(
                enableTooltip: true,
                isVisibleInLegend: true,
                name: "Deleted",
                legendItemText: "Deleted",
                color: AppColors().redColor,
                dataSource: controller.data,
                xValueMapper: (ChartData data, _) => data.x,
                pointColorMapper: (datum, index) {
                  return AppColors().redColor;
                },
                yValueMapper: (ChartData data, _) => data.y),
            ColumnSeries<ChartData, dynamic>(
                name: "Canceled",
                legendItemText: "Canceled",
                isVisibleInLegend: true,
                enableTooltip: true,
                color: AppColors().darkText,
                dataSource: controller.data,
                xValueMapper: (ChartData data, _) => data.x,
                pointColorMapper: (datum, index) {
                  return AppColors().darkText;
                },
                yValueMapper: (ChartData data, _) => data.y1),
            ColumnSeries<ChartData, dynamic>(
                name: "Success",
                legendItemText: "Success",
                isVisibleInLegend: true,
                color: AppColors().blueColor,
                enableTooltip: true,
                dataSource: controller.data,
                xValueMapper: (ChartData data, _) => data.x,
                pointColorMapper: (datum, index) {
                  return AppColors().blueColor;
                },
                yValueMapper: (ChartData data, _) => data.y2),
          ]),
    ));
  }

  chartTabSelectionContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors().headerBgColor, border: Border(bottom: BorderSide(color: AppColors().lightOnlyText, width: 1))),
      height: 35,
      child: Row(
        children: [
          SizedBox(
            width: 6.w,
            height: 3.h,
            child: CustomButton(
              isEnabled: true,
              shimmerColor: AppColors().whiteColor,
              title: "Chart View",
              textSize: 14,
              onPress: () {
                controller.isChartViewSelected = true;
                controller.update();
              },
              bgColor: controller.isChartViewSelected ? AppColors().blueColor : AppColors().headerBgColor,
              isFilled: true,
              textColor: controller.isChartViewSelected ? AppColors().whiteColor : AppColors().darkText,
              isTextCenter: true,
              isLoading: false,
              noNeedBorderRadius: true,
            ),
          ),
          SizedBox(
            width: 6.w,
            height: 3.h,
            child: CustomButton(
              isEnabled: true,
              shimmerColor: AppColors().whiteColor,
              title: "Table View",
              textSize: 14,
              onPress: () {
                controller.isChartViewSelected = false;
                controller.update();
              },
              bgColor: controller.isChartViewSelected == false ? AppColors().blueColor : AppColors().headerBgColor,
              isFilled: true,
              textColor: controller.isChartViewSelected ? AppColors().darkText : AppColors().whiteColor,
              isTextCenter: true,
              isLoading: false,
              noNeedBorderRadius: true,
            ),
          ),
        ],
      ),
    );
  }

  pieTabSelectionContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors().headerBgColor, border: Border(bottom: BorderSide(color: AppColors().lightOnlyText, width: 1))),
      height: 35,
      child: Row(
        children: [
          SizedBox(
            width: 6.w,
            height: 3.h,
            child: CustomButton(
              isEnabled: true,
              shimmerColor: AppColors().whiteColor,
              title: "Chart View",
              textSize: 14,
              onPress: () {
                controller.isPieViewSelected = true;
                controller.update();
              },
              bgColor: controller.isPieViewSelected ? AppColors().blueColor : AppColors().headerBgColor,
              isFilled: true,
              textColor: controller.isPieViewSelected ? AppColors().whiteColor : AppColors().darkText,
              isTextCenter: true,
              isLoading: false,
              noNeedBorderRadius: true,
            ),
          ),
          SizedBox(
            width: 6.w,
            height: 3.h,
            child: CustomButton(
              isEnabled: true,
              shimmerColor: AppColors().whiteColor,
              title: "Table View",
              textSize: 14,
              onPress: () {
                controller.isPieViewSelected = false;
                controller.update();
              },
              bgColor: controller.isPieViewSelected == false ? AppColors().blueColor : AppColors().headerBgColor,
              isFilled: true,
              textColor: controller.isPieViewSelected ? AppColors().darkText : AppColors().whiteColor,
              isTextCenter: true,
              isLoading: false,
              noNeedBorderRadius: true,
            ),
          ),
        ],
      ),
    );
  }

  exchangeContent(BuildContext context, int index) {
    return Container(
      height: 40,
      child: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.check_box_outline_blank,
            color: AppColors().darkText,
          ),
          SizedBox(
            width: 10,
          ),
          Text(arrExchange[index].name ?? "",
              style: TextStyle(
                fontSize: 14,
                fontFamily: CustomFonts.family1Regular,
                color: AppColors().darkText,
              )),
        ],
      ),
    );
  }

  filterContentBarChart(BuildContext context) {
    return Container(
      height: 4.h,
      decoration: BoxDecoration(
          color: AppColors().headerBgColor, border: Border(bottom: BorderSide(color: AppColors().lightOnlyText, width: 1))),
      child: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Text("Filter :",
              style: TextStyle(
                fontSize: 14,
                fontFamily: CustomFonts.family1SemiBold,
                color: AppColors().darkText,
              )),
          Container(
            height: 3.h,
            width: 18.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Container(
                  child: Text("User :",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: CustomFonts.family1Regular,
                        color: AppColors().fontColor,
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                userListDropDown(controller.selectedUserChart),
              ],
            ),
          ),
          Container(
            height: 3.h,
            width: 18.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Spacer(),
                Container(
                  child: Text("Show :",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: CustomFonts.family1Regular,
                        color: AppColors().fontColor,
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                timePeriodDropDown(controller.selectedPeriod),
              ],
            ),
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
              noNeedBorderRadius: true,
            ),
          ),
        ],
      ),
    );
  }

  filterContentPieChart(BuildContext context) {
    return Container(
      height: 4.h,
      decoration: BoxDecoration(
          color: AppColors().headerBgColor, border: Border(bottom: BorderSide(color: AppColors().lightOnlyText, width: 1))),
      child: Row(
        children: [
          SizedBox(
            width: 5,
          ),
          Container(
            height: 3.h,
            // width: 11.2.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text("From:",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: CustomFonts.family1Regular,
                        color: AppColors().fontColor,
                      )),
                ),
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    // selectFromDate(controller.fromDate);
                    showCalenderPopUp(DateTime.now(), (DateTime selectedDate) {
                      controller.fromDate.value = shortDateForBackend(selectedDate);
                    });
                  },
                  child: Obx(() {
                    return Container(
                      height: 4.h,
                      width: 140,
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
                            width: 20,
                            height: 20,
                            color: AppColors().fontColor,
                          )
                        ],
                      ),
                    );
                  }),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
          Container(
            height: 3.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text("To:",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: CustomFonts.family1Regular,
                        color: AppColors().fontColor,
                      )),
                ),
                SizedBox(
                  width: 5,
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
                      height: 3.h,
                      width: 140,
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
                            width: 20,
                            height: 20,
                            color: AppColors().fontColor,
                          )
                        ],
                      ),
                    );
                  }),
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
          Container(
            height: 3.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text("User :",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: CustomFonts.family1Regular,
                        color: AppColors().fontColor,
                      )),
                ),
                SizedBox(
                  width: 5,
                ),
                userListDropDown(controller.selectedUserPie, width: 150),
              ],
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            height: 3.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text("Type :",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: CustomFonts.family1Regular,
                        color: AppColors().fontColor,
                      )),
                ),
                SizedBox(
                  width: 5,
                ),
                sortTypeDropDown(controller.selectedSortType, width: 120),
              ],
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            height: 3.h,
            child: sortCountDropDown(controller.selectedCount, width: 80),
          ),
          SizedBox(
            width: 5,
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
              noNeedBorderRadius: true,
            ),
          ),
        ],
      ),
    );
  }
}
