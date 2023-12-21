import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:marketdesktop/constant/color.dart';
import 'package:marketdesktop/constant/const_string.dart';
import 'package:marketdesktop/customWidgets/appTextField.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/screens/UserDetailPopups/BrkPopUp/brkPopUpController.dart';

import 'package:responsive_framework/responsive_framework.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../constant/assets.dart';
import '../../../constant/font_family.dart';
import '../../../customWidgets/appButton.dart';
import '../../../customWidgets/commonWidgets.dart';

import '../../BaseController/baseController.dart';
import '../userDetailsPopUpController.dart';

class BrkPopUpScreen extends BaseView<BrkPopUpController> {
  const BrkPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Visibility(
        visible: Get.find<UserDetailsPopUpController>().selectedMenuName == "Brk",
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 2,
            ),
            Container(
              height: 35,
              child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  clipBehavior: Clip.hardEdge,
                  itemCount: controller.arrMenuList.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return menuContent(context, index);
                  }),
            ),
            SizedBox(
              height: 2,
            ),
            Container(height: 40, child: UpdateBrkContent(context)),
            SizedBox(
              height: 2,
            ),
            Expanded(
              child: Row(
                children: [
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
    );
  }

  Widget menuContent(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        controller.selectedCurrentTab = index;
        controller.getExchangeListUserWise(userId: controller.selectedUserId);
        controller.arrBrokerage.clear();
        controller.selectedExchange.value = ExchangeData();

        controller.update();
      },
      child: Container(
        // width: 170,
        color: controller.selectedCurrentTab == index ? AppColors().blueColor : AppColors().grayBg,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: 30,
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Center(
            child: Text(controller.arrMenuList[index],
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: CustomFonts.family1Medium,
                  color: controller.selectedCurrentTab == index ? AppColors().whiteColor : AppColors().darkText,
                )),
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
        duration: Duration(milliseconds: 300),
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
                  if (controller.selectedCurrentTab == 0) turnOverWiseTitleContent(),
                  if (controller.selectedCurrentTab == 1) symbolWiseTitleContent()
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  clipBehavior: Clip.hardEdge,
                  itemCount: controller.arrBrokerage.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return controller.selectedCurrentTab == 0
                        ? turnOverWiseContent(context, index)
                        : symbolWiseContent(context, index);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget UpdateBrkContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      decoration: BoxDecoration(
          color: AppColors().whiteColor,
          border: Border(
            bottom: BorderSide(color: AppColors().lightOnlyText, width: 1),
          )),
      child: Container(
        height: 4.h,
        // width: 90.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            controller.userWiseExchangeTypeDropDown(controller.selectedExchange, onChange: () {
              controller.userWiseBrkList();
            }),
            searchBox(),
            SizedBox(
              width: 80,
              height: 35,
              child: CustomButton(
                isEnabled: true,
                noNeedBorderRadius: true,
                shimmerColor: AppColors().whiteColor,
                title: "Apply",
                focusKey: controller.applyFocus,
                borderColor: Colors.transparent,
                focusShadowColor: AppColors().blueColor,
                textSize: 14,
                onPress: () {
                  controller.userWiseBrkList(isFromApply: true);
                },
                bgColor: AppColors().blueColor,
                isFilled: true,
                textColor: AppColors().whiteColor,
                isTextCenter: true,
                isLoading: controller.isApiCallRunning,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 80,
              height: 35,
              child: CustomButton(
                isEnabled: true,
                noNeedBorderRadius: true,
                shimmerColor: AppColors().blueColor,
                title: "Clear",
                textSize: 14,
                focusKey: controller.clearFocus,
                // borderColor: Colors.transparent,
                focusShadowColor: AppColors().blueColor,
                prefixWidth: 0,
                onPress: () {
                  controller.selectedExchange.value = ExchangeData();
                  controller.selectedScriptFromFilter.value = GlobalSymbolData();
                  controller.textEditingController.clear();
                  controller.arrBrokerage.clear();
                  controller.update();
                  // controller.userWiseBrkList(isFromClear: true);
                },
                bgColor: AppColors().whiteColor,
                isFilled: true,
                borderColor: AppColors().blueColor,
                textColor: AppColors().blueColor,
                isTextCenter: true,
                isLoading: controller.isClearApiCallRunning,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              child: Text("Brokerage Price",
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
              width: 225,
              child: CustomTextField(
                regex: "[0-9]",
                type: '',
                keyBoardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
                isEnabled: true,
                isOptional: false,
                isNoNeededCapital: true,
                inValidMsg: AppString.emptyName,
                placeHolderMsg: "Enter Brokerage PRice",
                labelMsg: "",
                emptyFieldMsg: AppString.emptyName,
                controller: controller.amountController,
                focus: controller.amountFocus,
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
              height: 35,
              child: CustomButton(
                isEnabled: true,
                noNeedBorderRadius: true,
                shimmerColor: AppColors().whiteColor,
                title: "Update",
                focusKey: controller.updateFocus,
                borderColor: Colors.transparent,
                focusShadowColor: AppColors().blueColor,
                textSize: 14,
                onPress: () {
                  controller.updateBrk();
                },
                bgColor: AppColors().blueColor,
                isFilled: true,
                textColor: AppColors().whiteColor,
                isTextCenter: true,
                isLoading: controller.isupdateCallRunning,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget turnOverWiseContent(BuildContext context, int index) {
    var brkValue = controller.arrBrokerage[index];
    return GestureDetector(
      onTap: () {
        // controller.selectedScriptIndex = index;

        controller.update();
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            valueBox("", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index,
                isImage: true,
                strImage: brkValue.isSelected ? AppImages.checkBoxSelected : AppImages.checkBox,
                isSmall: true, onClickImage: () {
              controller.arrBrokerage[index].isSelected = !controller.arrBrokerage[index].isSelected;
              for (var element in controller.arrBrokerage) {
                if (element.isSelected) {
                  controller.isAllSelected = true;
                } else {
                  controller.isAllSelected = false;
                  break;
                }
              }
              controller.update();
            }),
            valueBox(brkValue.exchangeName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                AppColors().darkText, index),
            valueBox(brkValue.symbolName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                AppColors().darkText, index,
                isLarge: true),
            valueBox(brkValue.brokeragePrice!.toStringAsFixed(2), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                AppColors().darkText, index,
                isLarge: true),
          ],
        ),
      ),
    );
  }

  Widget symbolWiseContent(BuildContext context, int index) {
    var brkValue = controller.arrBrokerage[index];
    return GestureDetector(
      onTap: () {
        // controller.selectedScriptIndex = index;
        controller.update();
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            valueBox("", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index,
                isImage: true,
                strImage: brkValue.isSelected ? AppImages.checkBoxSelected : AppImages.checkBox,
                isSmall: true, onClickImage: () {
              controller.arrBrokerage[index].isSelected = !controller.arrBrokerage[index].isSelected;
              for (var element in controller.arrBrokerage) {
                if (element.isSelected) {
                  controller.isAllSelected = true;
                } else {
                  controller.isAllSelected = false;
                  break;
                }
              }
              controller.update();
            }),
            valueBox(brkValue.exchangeName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                AppColors().darkText, index),
            valueBox(brkValue.symbolName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                AppColors().darkText, index,
                isLarge: true),
            valueBox(
              brkValue.brokeragePrice!.toStringAsFixed(2),
              45,
              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
              AppColors().darkText,
              index,
            ),
          ],
        ),
      ),
    );
  }

  Widget turnOverWiseTitleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // titleBox("", 0),

        titleBox("",
            isImage: true,
            strImage: controller.isAllSelected ? AppImages.checkBoxSelected : AppImages.checkBox,
            isSmall: true, onClickImage: () {
          if (controller.isAllSelected) {
            controller.arrBrokerage.forEach((element) {
              element.isSelected = false;
            });
            controller.isAllSelected = false;
            controller.update();
          } else {
            controller.arrBrokerage.forEach((element) {
              element.isSelected = true;
            });
            controller.isAllSelected = true;
            controller.update();
          }
        }),
        titleBox("Exchange"),
        titleBox("Script", isLarge: true),
        titleBox("Turnover Wise Brk(Rs. per 1/CR)", isLarge: true),
      ],
    );
  }

  Widget symbolWiseTitleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // titleBox("", 0),

        titleBox("",
            isImage: true,
            strImage: controller.isAllSelected ? AppImages.checkBoxSelected : AppImages.checkBox,
            isSmall: true, onClickImage: () {
          if (controller.isAllSelected) {
            controller.arrBrokerage.forEach((element) {
              element.isSelected = false;
            });
            controller.isAllSelected = false;
            controller.update();
          } else {
            controller.arrBrokerage.forEach((element) {
              element.isSelected = true;
            });
            controller.isAllSelected = true;
            controller.update();
          }
        }),
        titleBox("Exchange"),
        titleBox("Script", isLarge: true),

        titleBox("Brk(Rs.)"),
      ],
    );
  }

  Widget searchBox() {
    return Container(
      width: 270,
      height: 35,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
      child: Autocomplete<GlobalSymbolData>(
        displayStringForOption: (GlobalSymbolData option) => option.symbolTitle!,
        fieldViewBuilder:
            (BuildContext context, TextEditingController control, FocusNode searchFocus, VoidCallback onFieldSubmitted) {
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
