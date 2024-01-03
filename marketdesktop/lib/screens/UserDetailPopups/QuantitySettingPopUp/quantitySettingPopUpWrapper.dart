import 'package:get/get.dart';
import 'package:marketdesktop/constant/utilities.dart';

import 'package:marketdesktop/screens/UserDetailPopups/QuantitySettingPopUp/quantitySettingPopUpController.dart';

import 'package:responsive_framework/responsive_framework.dart';
import '../../../constant/index.dart';
import '../../../customWidgets/appButton.dart';
import '../../../customWidgets/appTextField.dart';
import '../../../modelClass/allSymbolListModelClass.dart';
import '../../../modelClass/exchangeListModelClass.dart';
import '../userDetailsPopUpController.dart';

class QuantitySettingPopUpScreen extends BaseView<QuantitySettingPopUpController> {
  const QuantitySettingPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Visibility(
        visible: Get.find<UserDetailsPopUpController>().selectedMenuName == "Quantity Settings",
        child: GestureDetector(
          onTap: () {
            // controller.focusNode.requestFocus();
          },
          child: Column(
            children: [
              UpdateQuantityContent(context),
              Expanded(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget filterContent(BuildContext context) {
    return FocusTraversalGroup(
      child: Visibility(
        visible: controller.isFilterOpen,
        child: AnimatedContainer(
          // margin: EdgeInsets.only(bottom: 2.h),
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
                              width: 45,
                              child: Text("Script:",
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: CustomFonts.family1Regular,
                                    color: AppColors().fontColor,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            searchBox(),
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
                              noNeedBorderRadius: true,
                              shimmerColor: AppColors().whiteColor,
                              title: "Apply",
                              textSize: 14,
                              focusKey: controller.applyFocus,
                              borderColor: Colors.transparent,
                              focusShadowColor: AppColors().blueColor,
                              onPress: () {
                                controller.quantitySettingList();
                              },
                              bgColor: AppColors().blueColor,
                              isFilled: true,
                              textColor: AppColors().whiteColor,
                              isTextCenter: true,
                              isLoading: controller.isFilterApiCallRunning,
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
                              noNeedBorderRadius: true,
                              shimmerColor: AppColors().blueColor,
                              title: "Clear",
                              focusKey: controller.clearFocus,
                              borderColor: Colors.transparent,
                              focusShadowColor: AppColors().blueColor,
                              textSize: 14,
                              prefixWidth: 0,
                              onPress: () {
                                controller.selectedExchange.value = ExchangeData();
                                controller.selectedScriptFromFilter.value = GlobalSymbolData();
                                controller.textEditingController.clear();
                                controller.quantitySettingList(isFromClear: true);
                              },
                              bgColor: AppColors().whiteColor,
                              isFilled: true,
                              textColor: AppColors().blueColor,
                              isTextCenter: true,
                              isLoading: controller.isClearApiCallRunning,
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

  Widget UpdateQuantityContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      decoration: BoxDecoration(
          color: AppColors().whiteColor,
          border: Border(
            bottom: BorderSide(color: AppColors().lightOnlyText, width: 1),
          )),
      child: Container(
        height: 30,
        // width: 90.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            Container(
              child: Text("Lot Max:",
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
              child: CustomTextField(
                regex: "[0-9]",
                type: '',
                keyBoardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
                isEnabled: true,
                isOptional: false,
                isNoNeededCapital: true,
                inValidMsg: AppString.emptyName,
                placeHolderMsg: "Enter Lot Max",
                labelMsg: "",
                emptyFieldMsg: AppString.emptyName,
                controller: controller.lotMaxController,
                focus: controller.lotMaxFocus,
                isSecure: false,
                keyboardButtonType: TextInputAction.next,
                maxLength: 20,
                isShowPrefix: false,
                isShowSufix: false,
                suffixIcon: null,
                prefixIcon: null,
                borderColor: AppColors().lightText,
                roundCorner: 0,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              child: Text("Qty Max:",
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
              child: CustomTextField(
                regex: "[0-9]",
                type: '',
                keyBoardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
                isEnabled: true,
                isOptional: false,
                isNoNeededCapital: true,
                inValidMsg: AppString.emptyName,
                placeHolderMsg: "Enter Qty Max",
                labelMsg: "",
                emptyFieldMsg: AppString.emptyName,
                controller: controller.qtyMaxController,
                focus: controller.qtyMaxFocus,
                isSecure: false,
                keyboardButtonType: TextInputAction.next,
                maxLength: 20,
                isShowPrefix: false,
                isShowSufix: false,
                suffixIcon: null,
                prefixIcon: null,
                borderColor: AppColors().lightText,
                roundCorner: 0,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              child: Text("Breakup Qty:",
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
              child: CustomTextField(
                regex: "[0-9]",
                type: '',
                keyBoardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
                isEnabled: true,
                isOptional: false,
                isNoNeededCapital: true,
                inValidMsg: AppString.emptyName,
                placeHolderMsg: "Enter Breakup Qty",
                labelMsg: "",
                emptyFieldMsg: AppString.emptyName,
                controller: controller.brkQtyController,
                focus: controller.brkQtyFocus,
                isSecure: false,
                keyboardButtonType: TextInputAction.next,
                maxLength: 20,
                isShowPrefix: false,
                isShowSufix: false,
                suffixIcon: null,
                prefixIcon: null,
                borderColor: AppColors().lightText,
                roundCorner: 0,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              child: Text("Breakup Lot:",
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
              child: CustomTextField(
                regex: "[0-9]",
                type: '',
                keyBoardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
                isEnabled: true,
                isOptional: false,
                isNoNeededCapital: true,
                inValidMsg: AppString.emptyName,
                placeHolderMsg: "Enter Breakup Lot",
                labelMsg: "",
                emptyFieldMsg: AppString.emptyName,
                controller: controller.brkLotController,
                focus: controller.brkLotFocus,
                isSecure: false,
                keyboardButtonType: TextInputAction.next,
                maxLength: 20,
                isShowPrefix: false,
                isShowSufix: false,
                suffixIcon: null,
                prefixIcon: null,
                borderColor: AppColors().lightText,
                roundCorner: 0,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 80,
              height: 30,
              child: CustomButton(
                isEnabled: true,
                noNeedBorderRadius: true,
                shimmerColor: AppColors().whiteColor,
                title: "Update",
                textSize: 14,
                focusKey: controller.updateFocus,
                borderColor: Colors.transparent,
                focusShadowColor: AppColors().blueColor,
                onPress: () {
                  controller.updateQuantity();
                },
                bgColor: AppColors().blueColor,
                isFilled: true,
                textColor: AppColors().whiteColor,
                isTextCenter: true,
                isLoading: controller.isApiCallRunning,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mainContent(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 1860,
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
                  itemCount: controller.arrQuantitySetting.length,
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
    var quantityValue = controller.arrQuantitySetting[index];
    return GestureDetector(
      onTap: () {
        // controller.selectedScriptIndex = index;
        controller.update();
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            valueBox("", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index, isImage: true, strImage: quantityValue.isSelected ? AppImages.checkBoxSelected : AppImages.checkBox, isSmall: true, onClickImage: () {
              controller.arrQuantitySetting[index].isSelected = !controller.arrQuantitySetting[index].isSelected;
              for (var element in controller.arrQuantitySetting) {
                if (element.isSelected) {
                  controller.isAllSelected = true;
                } else {
                  controller.isAllSelected = false;
                  break;
                }
              }
              controller.update();
            }),
            valueBox(quantityValue.symbolName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true),
            valueBox(quantityValue.lotMax.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
            valueBox(
              quantityValue.quantityMax.toString(),
              45,
              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
              AppColors().darkText,
              index,
            ),
            valueBox(
              quantityValue.breakQuantity.toString(),
              45,
              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
              AppColors().darkText,
              index,
            ),
            valueBox(
              quantityValue.breakUpLot.toString(),
              45,
              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
              AppColors().darkText,
              index,
            ),
            valueBox(quantityValue.updatedAt != null ? shortFullDateTime(quantityValue.updatedAt!) : "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true),
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
        titleBox("", isImage: true, strImage: controller.isAllSelected ? AppImages.checkBoxSelected : AppImages.checkBox, onClickImage: () {
          if (controller.isAllSelected) {
            controller.arrQuantitySetting.forEach((element) {
              element.isSelected = false;
            });
            controller.isAllSelected = false;
            controller.update();
          } else {
            controller.arrQuantitySetting.forEach((element) {
              element.isSelected = true;
            });
            controller.isAllSelected = true;
            controller.update();
          }
        }),
        titleBox("Script", isBig: true),
        titleBox("Lot Max"),
        titleBox("Qty Max"),
        titleBox("Breakup Qty"),
        titleBox("Breakup Lot"),
        titleBox("Last Updated", isBig: true),
      ],
    );
  }

  Widget searchBox() {
    return Container(
      width: 150,
      height: 35,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
      child: Autocomplete<GlobalSymbolData>(
        displayStringForOption: (GlobalSymbolData option) => option.symbolTitle!,
        fieldViewBuilder: (BuildContext context, TextEditingController control, FocusNode searchFocus, VoidCallback onFieldSubmitted) {
          return CustomTextField(
            type: 'Search',
            keyBoardType: TextInputType.text,
            isEnabled: true,
            isOptional: false,
            inValidMsg: "",
            placeHolderMsg: "Search",
            emptyFieldMsg: "",
            controller: controller.textEditingController,
            focus: searchFocus,
            isSecure: false,
            borderColor: AppColors().grayLightLine,
            keyboardButtonType: TextInputAction.search,
            maxLength: 64,
            prefixIcon: Image.asset(
              AppImages.searchIcon,
              height: 20,
              width: 20,
            ),
            onTap: () {
              searchFocus.requestFocus();
            },
            suffixIcon: Container(
              child: GestureDetector(
                onTap: () {
                  controller.textEditingController.clear();
                  controller.arrSearchedScript.clear();
                },
                child: Image.asset(
                  AppImages.crossIcon,
                  height: 20,
                  width: 20,
                ),
              ),
            ),
          );
        },
        optionsViewBuilder: (context, onSelected, options) => Align(
          alignment: Alignment.topLeft,
          child: Material(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0)),
            ),
            child: Container(
              height: 250,
              width: 13.w, // <-- Right here !
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                shrinkWrap: false,
                itemBuilder: (BuildContext context, int index) {
                  final String option = controller.arrSearchedScript.elementAt(index).symbolTitle!;
                  return InkWell(
                    onTap: () => onSelected(controller.arrSearchedScript.elementAt(index)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: CustomFonts.family1Medium,
                          color: AppColors().darkText,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        optionsMaxHeight: 30.h,
        optionsBuilder: (TextEditingValue textEditingValue) async {
          if (textEditingValue.text == '') {
            return const Iterable<GlobalSymbolData>.empty();
          }
          return await controller.getSymbolListByKeyword(textEditingValue.text);
        },
        onSelected: (GlobalSymbolData selection) {
          debugPrint('You just selected $selection');
          // controller.addSymbolToTab(selection.symbolId!);
        },
      ),
    );
  }
}
