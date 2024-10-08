import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/customWidgets/appScrollBar.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/TradeMarginScreen/tradeMarginListController.dart';
import 'package:paginable/paginable.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constant/index.dart';
import 'package:responsive_framework/responsive_framework.dart';
import '../../../../constant/screenColumnData.dart';
import '../../../../constant/utilities.dart';

class TradeMarginScreen extends BaseView<TradeMarginController> {
  const TradeMarginScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Row(
        children: [
          filterPanel(
            context,
            bottomMargin: 0,
            isRecordDisplay: true,
            totalRecord: controller.totalCount,
            onCLickFilter: () {
              controller.isFilterOpen = !controller.isFilterOpen;
              controller.update();
            },
            onCLickExcell: controller.onClickExcel,
            onCLickPDF: controller.onClickPDF,
          ),
          filterContent(context),
          Expanded(
            flex: 8,
            child: BouncingScrollWrapper.builder(context, mainContent(context), dragWithMouse: true),
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
                      Container(
                        height: 35,
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
                            exchangeTypeDropDown(controller.selectedExchange, width: 150),
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
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Container(
                              child: Text("Search:",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: CustomFonts.family1Regular,
                                    color: AppColors().fontColor,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 150,
                              decoration: BoxDecoration(color: AppColors().whiteColor, border: Border.all(color: AppColors().lightOnlyText, width: 1), borderRadius: BorderRadius.circular(5)),
                              child: TextFormField(
                                textInputAction: TextInputAction.search,
                                controller: controller.searchController,
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
                            width: 80,
                            height: 35,
                            child: CustomButton(
                              isEnabled: true,
                              shimmerColor: AppColors().whiteColor,
                              title: "View",
                              textSize: 14,
                              onPress: () {
                                controller.tradeMarginList(isFromFilter: true);
                              },
                              focusKey: controller.viewFocus,
                              borderColor: Colors.transparent,
                              focusShadowColor: AppColors().blueColor,
                              bgColor: AppColors().blueColor,
                              isFilled: true,
                              textColor: AppColors().whiteColor,
                              isTextCenter: true,
                              isLoading: controller.isApiCallRunning,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: 80,
                            height: 35,
                            child: CustomButton(
                              isEnabled: true,
                              shimmerColor: AppColors().blueColor,
                              title: "Clear",
                              textSize: 14,
                              onPress: () {
                                controller.selectedExchange.value = ExchangeData();
                                controller.searchController.clear();
                                controller.arrTradeMargin.clear();
                                controller.update();
                                // controller.tradeMarginList(isFromFilter: true, isFromClear: true);
                              },
                              focusKey: controller.clearFocus,
                              borderColor: AppColors().blueColor,
                              focusShadowColor: AppColors().blueColor,
                              bgColor: AppColors().whiteColor,
                              isFilled: true,
                              textColor: AppColors().blueColor,
                              isTextCenter: true,
                              isLoading: controller.isClearApiCallRunning,
                            ),
                          ),
                        ],
                      ),
                      // Container(
                      //   margin: EdgeInsets.all(20),
                      //   height: 1,
                      //   color: AppColors().lightOnlyText,
                      // ),
                      // Text("Trade Attribute Settings",
                      //     style: TextStyle(
                      //         fontSize: 12,
                      //         fontFamily: CustomFonts.family1Regular,
                      //         color: AppColors().fontColor,
                      //         decoration: TextDecoration.underline)),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // Container(
                      //   height: 35,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Spacer(),
                      //       Container(
                      //         width: 55,
                      //         child: Text("Trade Attribute:",
                      //             maxLines: 2,
                      //             style: TextStyle(
                      //               fontSize: 12,
                      //               fontFamily: CustomFonts.family1Regular,
                      //               color: AppColors().fontColor,
                      //             )),
                      //       ),
                      //       SizedBox(
                      //         width: 10,
                      //       ),
                      //       tradeAttributeDropDown(controller.selectedTradeStatus, width: 150),
                      //       SizedBox(
                      //         width: 30,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Container(
                      //   // height: 35,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Spacer(),
                      //       Container(
                      //         width: 55,
                      //         child: Text("Allow Trade? :",
                      //             maxLines: 2,
                      //             style: TextStyle(
                      //               fontSize: 12,
                      //               fontFamily: CustomFonts.family1Regular,
                      //               color: AppColors().fontColor,
                      //             )),
                      //       ),
                      //       SizedBox(
                      //         width: 35,
                      //       ),
                      //       Container(
                      //         width: 150,
                      //         child: Column(
                      //           children: <Widget>[
                      //             ListTile(
                      //               contentPadding: EdgeInsets.zero,
                      //               title: const Text(
                      //                 'Not Applicable',
                      //               ),
                      //               horizontalTitleGap: 0,
                      //               dense: true,
                      //               visualDensity: VisualDensity(vertical: -3),
                      //               titleTextStyle: TextStyle(
                      //                 fontSize: 12,
                      //                 fontFamily: CustomFonts.family1Regular,
                      //                 color: AppColors().fontColor,
                      //               ),
                      //               leading: Radio<AllowedTrade>(
                      //                 value: AllowedTrade.NotApplication,
                      //                 activeColor: AppColors().darkText,
                      //                 groupValue: controller.selectedAllowedTrade!,
                      //                 onChanged: (AllowedTrade? value) {
                      //                   controller.selectedAllowedTrade = value;
                      //                   controller.update();
                      //                 },
                      //               ),
                      //             ),
                      //             ListTile(
                      //               horizontalTitleGap: 0,
                      //               contentPadding: EdgeInsets.zero,
                      //               dense: true,
                      //               visualDensity: VisualDensity(vertical: -3),
                      //               title: const Text('Yes'),
                      //               titleTextStyle: TextStyle(
                      //                 fontSize: 12,
                      //                 fontFamily: CustomFonts.family1Regular,
                      //                 color: AppColors().fontColor,
                      //               ),
                      //               leading: Radio<AllowedTrade>(
                      //                 value: AllowedTrade.Yes,
                      //                 activeColor: AppColors().darkText,
                      //                 groupValue: controller.selectedAllowedTrade!,
                      //                 onChanged: (AllowedTrade? value) {
                      //                   controller.selectedAllowedTrade = value;
                      //                   controller.update();
                      //                 },
                      //               ),
                      //             ),
                      //             ListTile(
                      //               horizontalTitleGap: 0,
                      //               contentPadding: EdgeInsets.zero,
                      //               title: const Text('No'),
                      //               dense: true,
                      //               visualDensity: VisualDensity(vertical: -3),
                      //               titleTextStyle: TextStyle(
                      //                 fontSize: 12,
                      //                 fontFamily: CustomFonts.family1Regular,
                      //                 color: AppColors().fontColor,
                      //               ),
                      //               leading: Radio<AllowedTrade>(
                      //                 value: AllowedTrade.No,
                      //                 activeColor: AppColors().darkText,
                      //                 groupValue: controller.selectedAllowedTrade!,
                      //                 onChanged: (AllowedTrade? value) {
                      //                   controller.selectedAllowedTrade = value;
                      //                   controller.update();
                      //                 },
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   children: [
                      //     SizedBox(
                      //       width: 120,
                      //     ),
                      //     SizedBox(
                      //       width: 80,
                      //       height: 35,
                      //       child: CustomButton(
                      //         isEnabled: true,
                      //         shimmerColor: AppColors().whiteColor,
                      //         title: "Save",
                      //         textSize: 14,
                      //         onPress: () {},
                      //         focusKey: controller.saveFocus,
                      //         borderColor: Colors.transparent,
                      //         focusShadowColor: AppColors().blueColor,
                      //         bgColor: AppColors().blueColor,
                      //         isFilled: true,
                      //         textColor: AppColors().whiteColor,
                      //         isTextCenter: true,
                      //         isLoading: false,
                      //       ),
                      //     ),
                      //   ],
                      // ),
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
    return CustomScrollBar(
      bgColor: AppColors().blueColor,
      child: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
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
                child: controller.isApiCallRunning == false && controller.isClearApiCallRunning == false && controller.arrTradeMargin.isEmpty
                    ? dataNotFoundView("Trade margin not found")
                    : CustomScrollBar(
                        bgColor: AppColors().blueColor,
                        child: PaginableListView.builder(
                            loadMore: () async {
                              if (controller.totalPage >= controller.currentPage) {
                                //print(controller.currentPage);
                                controller.tradeMarginList();
                              }
                            },
                            errorIndicatorWidget: (exception, tryAgain) => dataNotFoundView("Data not found"),
                            progressIndicatorWidget: displayIndicator(),
                            physics: const ClampingScrollPhysics(),
                            clipBehavior: Clip.hardEdge,
                            itemCount: controller.isApiCallRunning || controller.isClearApiCallRunning ? 50 : controller.arrTradeMargin.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return tradeContent(context, index);
                            }),
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
      var tradeValue = controller.arrTradeMargin[index];
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
                  case TradeMarginColumns.exchange:
                    {
                      return dynamicValueBox1(tradeValue.exchangeName ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                    }
                  case TradeMarginColumns.script:
                    {
                      return IgnorePointer(child: dynamicValueBox1(tradeValue.symbolTitle ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1));
                    }
                  case TradeMarginColumns.expiryDate:
                    {
                      return dynamicValueBox1(shortFullDateTime(tradeValue.expiryDate!), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                    }
                  case TradeMarginColumns.marginPer:
                    {
                      return dynamicValueBox1(tradeValue.tradeMargin!.toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                    }
                  case TradeMarginColumns.marginAmount:
                    {
                      return dynamicValueBox1(tradeValue.tradeMarginAmount!.toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                    }
                  case TradeMarginColumns.description:
                    {
                      return dynamicValueBox1(tradeValue.symbolName ?? "--", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
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
