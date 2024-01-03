import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/TradeAccountScreen/tradeAccountController.dart';
import '../../../../constant/index.dart';
import 'package:responsive_framework/responsive_framework.dart';

class TradeAccountScreen extends BaseView<TradeAccountController> {
  const TradeAccountScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                filterPanel(context, bottomMargin: 0, isRecordDisplay: true, onCLickFilter: () {
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
                              decoration: BoxDecoration(color: AppColors().whiteColor, border: Border.all(color: AppColors().lightOnlyText, width: 1)),
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
                              focusKey: controller.viewFocus,
                              borderColor: Colors.transparent,
                              focusShadowColor: AppColors().blueColor,
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
                            width: 80,
                            height: 35,
                            child: CustomButton(
                              isEnabled: true,
                              shimmerColor: AppColors().whiteColor,
                              title: "Clear",
                              textSize: 14,
                              prefixWidth: 0,
                              onPress: () {
                                controller.selectedExchange.value = ExchangeData();
                                controller.selectedScriptFromFilter.value = GlobalSymbolData();
                                controller.selectedUser.value = UserData();
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
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        width: 96.w,
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
                    return orderContent(context, index);
                  }),
            ),
            Container(
              height: 30,
              child: Center(
                  child: Row(
                children: [
                  totalContent(value: "Total", textColor: AppColors().darkText),
                  totalContent(value: "10 40 215.40", textColor: AppColors().darkText, width: 150),
                  totalContent(value: "1 44 841.43", textColor: AppColors().darkText, width: 150),
                  totalContent(value: "8 95 373.97", textColor: AppColors().darkText, width: 150),
                  totalContent(value: "56 67 457.25", textColor: AppColors().darkText, width: 150),
                  totalContent(value: "86 67 457.25", textColor: AppColors().darkText, width: 150),
                  totalContent(value: "47 78 457.25", textColor: AppColors().darkText, width: 150),
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
    );
  }

  Widget totalContent({String? value, Color? textColor, double? width}) {
    return Container(
      width: width ?? 6.w,
      padding: EdgeInsets.only(left: 5),
      decoration: BoxDecoration(color: AppColors().headerBgColor, border: Border(top: BorderSide(color: AppColors().lightOnlyText, width: 1), bottom: BorderSide(color: AppColors().lightOnlyText, width: 1), right: BorderSide(color: AppColors().lightOnlyText, width: 1))),
      child: Text(value ?? "",
          style: TextStyle(
            fontSize: 12,
            fontFamily: CustomFonts.family1Medium,
            color: textColor ?? AppColors().redColor,
          )),
    );
  }

  Widget orderContent(BuildContext context, int index) {
    // var scriptValue = controller.arrUserOderList[index];
    return GestureDetector(
      onTap: () {
        controller.update();
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            valueBox("MAN07", 30, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isUnderlined: true, onClickValue: () {
              showUserDetailsPopUp();
            }),
            valueBox("58 906.00", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().redColor, index, isBig: false),
            valueBox("58 906.00", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: false),
            valueBox("58 906.00", 60, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().blueColor, index, isBig: false),
            valueBox("58 906.00", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().redColor, index, isBig: false),
            valueBox("58 906.00", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: false),
            valueBox("58 906.00", 60, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().blueColor, index, isBig: false),
          ],
        ),
      ),
    );
  }

  Widget listTitleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // titleBox("", 0),
        titleBox("Username"),
        titleBox("PL", isBig: false),
        titleBox("Brk", isBig: false),
        titleBox("Balance", isBig: false),
        titleBox("Credit", isBig: false),
        titleBox("Net P/L", isBig: false),
        titleBox("M2M P/L", isBig: false),
      ],
    );
  }
}
