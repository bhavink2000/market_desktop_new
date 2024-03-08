import 'package:flutter/src/widgets/framework.dart';
import 'package:marketdesktop/customWidgets/appScrollBar.dart';
import 'package:marketdesktop/screens/BaseController/baseController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/historyOfCreditScreen/historyOfCreditController.dart';
import 'package:paginable/paginable.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:shimmer/shimmer.dart';

import '../../../../constant/index.dart';
import '../../../../constant/screenColumnData.dart';
import '../../../../constant/utilities.dart';
import '../../../../main.dart';

class HistoryOfCreditScreen extends BaseView<HistoryOfCreditController> {
  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: BouncingScrollWrapper.builder(context, mainContent(context), dragWithMouse: true),
            // child: BouncingScrollWrapper.builder(context, mainContent(context), dragWithMouse: true),
          ),
        ],
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
          duration: Duration(milliseconds: 300),
          width: globalMaxWidth,
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
                    listTitleContent(controller),
                  ],
                ),
              ),
              Expanded(
                child: controller.isApiCallRunning == false && controller.arrCreditList.isEmpty
                    ? dataNotFoundView("Credit history not found")
                    : CustomScrollBar(
                        bgColor: AppColors().blueColor,
                        child: PaginableListView.builder(
                            loadMore: () async {},
                            errorIndicatorWidget: (exception, tryAgain) => dataNotFoundView("Data not found"),
                            progressIndicatorWidget: displayIndicator(),
                            physics: const ClampingScrollPhysics(),
                            clipBehavior: Clip.hardEdge,
                            itemCount: controller.isApiCallRunning ? 50 : controller.arrCreditList.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return tradeContent(context, index);
                            }),
                      ),
              ),
              Container(
                height: 30,
                decoration: BoxDecoration(color: AppColors().whiteColor, border: Border(top: BorderSide(color: AppColors().lightOnlyText, width: 1))),
                child: Center(
                    child: Row(
                  children: [
                    totalContent(value: "Total Amount", textColor: AppColors().darkText, width: 22.w),
                    totalContent(value: controller.arrCreditList.isNotEmpty ? controller.arrCreditList.last.balance.toStringAsFixed(2) : "0", textColor: AppColors().darkText, width: 110),
                  ],
                )),
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

  Widget totalContent({String? value, Color? textColor, double? width}) {
    return Container(
      width: width ?? 6.w,
      padding: EdgeInsets.only(left: 5),
      decoration: BoxDecoration(color: AppColors().whiteColor, border: Border(top: BorderSide(color: AppColors().lightOnlyText, width: 1), bottom: BorderSide(color: AppColors().lightOnlyText, width: 1), right: BorderSide(color: AppColors().lightOnlyText, width: 1))),
      child: Text(value ?? "",
          style: TextStyle(
            fontSize: 12,
            fontFamily: CustomFonts.family1Medium,
            color: textColor ?? AppColors().redColor,
          )),
    );
  }

  Widget tradeContent(BuildContext context, int index) {
    if (controller.isApiCallRunning) {
      return Container(
        margin: EdgeInsets.only(bottom: 3.h),
        child: Shimmer.fromColors(
            child: Container(
              height: 3.h,
              color: Colors.white,
            ),
            baseColor: AppColors().whiteColor,
            highlightColor: AppColors().grayBg),
      );
    } else {
      //   var historyValue = controller.arrAccountSummary[index];
      return Container(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: controller.arrListTitle1.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int indexT) {
                switch (controller.arrListTitle1[indexT].title) {
                  case CreditHistoryColumns.username:
                    {
                      return IgnorePointer(
                        child: dynamicValueBox1(controller.arrCreditList[index].fromUserName ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1),
                      );
                    }
                  case CreditHistoryColumns.dateTime:
                    {
                      return dynamicValueBox1(
                        shortFullDateTime(controller.arrCreditList[index].createdAt!),
                        index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                        AppColors().darkText,
                        index,
                        indexT,
                        controller.arrListTitle1,
                      );
                    }
                  case CreditHistoryColumns.type:
                    {
                      return IgnorePointer(
                        child: dynamicValueBox1(controller.arrCreditList[index].transactionType ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1),
                      );
                    }
                  case CreditHistoryColumns.amount:
                    {
                      return IgnorePointer(
                        child: dynamicValueBox1(
                          controller.arrCreditList[index].amount!.toStringAsFixed(2),
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          AppColors().darkText,
                          index,
                          indexT,
                          controller.arrListTitle1,
                        ),
                      );
                    }
                  case CreditHistoryColumns.balance:
                    {
                      return IgnorePointer(
                        child: dynamicValueBox1(
                          controller.arrCreditList[index].balance.toStringAsFixed(2),
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          AppColors().darkText,
                          index,
                          indexT,
                          controller.arrListTitle1,
                        ),
                      );
                    }
                  case CreditHistoryColumns.comments:
                    {
                      return IgnorePointer(
                        child: dynamicValueBox1(
                          controller.arrCreditList[index].comment ?? "",
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          AppColors().darkText,
                          index,
                          indexT,
                          controller.arrListTitle1,
                        ),
                      );
                    }

                  default:
                    {
                      return const SizedBox();
                    }
                }
              },
            ),
          ],
        ),
      );
    }
  }
}
