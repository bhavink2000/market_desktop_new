import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:marketdesktop/constant/color.dart';
import 'package:marketdesktop/constant/const_string.dart';
import 'package:marketdesktop/customWidgets/appScrollBar.dart';
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

import '../../../main.dart';
import '../../BaseController/baseController.dart';
import '../../MainTabs/ViewTab/MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';
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
            if (selectedUserForUserDetailPopupParentID == userData!.userId! || userData!.role == UserRollList.admin) Container(height: 40, child: UpdateBrkContent(context)),
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
        controller.arrListTitle = [
          if (selectedUserForUserDetailPopupParentID == userData!.userId!) ListItem("", true),
          ListItem("EXCHANGE", true),
          ListItem("SCRIPT", true),
          if (controller.selectedCurrentTab == 0) ListItem("TURNOVER WISE BRK(RS. PER 1/CR))", true),
          if (controller.selectedCurrentTab == 1) ListItem("Brk(Rs.)", true),
        ];

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
    return CustomScrollBar(
      bgColor: AppColors().blueColor,
      child: SingleChildScrollView(
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
                    // if (controller.selectedCurrentTab == 0) turnOverWiseTitleContent(),
                    // if (controller.selectedCurrentTab == 1) symbolWiseTitleContent()
                    listTitleContent()
                  ],
                ),
              ),
              Expanded(
                child: CustomScrollBar(
                  bgColor: AppColors().blueColor,
                  child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      clipBehavior: Clip.hardEdge,
                      itemCount: controller.arrBrokerage.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return groupContent(context, index);
                      }),
                ),
              ),
            ],
          ),
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

  Widget groupContent(BuildContext context, int index) {
    var brkValue = controller.arrBrokerage[index];
    return GestureDetector(
      onTap: () {
        // controller.selectedScriptIndex = index;
        // // controller.selectedScript!.value = scriptValue;
        // controller.focusNode.requestFocus();
        // controller.update();
      },
      child: Container(
        // decoration: BoxDecoration(color: Colors.transparent, border: Border.all(width: 1, color: controller.selectedScriptIndex == index ? AppColors().darkText : Colors.transparent)),
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: controller.arrListTitle.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int indexT) {
                switch (controller.arrListTitle[indexT].title) {
                  case '':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox("", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index, indexT, controller.arrListTitle, isImage: true, strImage: brkValue.isSelected ? AppImages.checkBoxSelected : AppImages.checkBox, isSmall: true, onClickImage: () {
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
                            })
                          : const SizedBox();
                    }
                  case 'EXCHANGE':
                    {
                      return controller.arrListTitle[indexT].isSelected ? IgnorePointer(child: dynamicValueBox(brkValue.exchangeName ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle)) : const SizedBox();
                    }
                  case 'SCRIPT':
                    {
                      return controller.arrListTitle[indexT].isSelected ? IgnorePointer(child: dynamicValueBox(brkValue.symbolName ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle)) : const SizedBox();
                    }
                  case 'TURNOVER WISE BRK(RS. PER 1/CR))':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? IgnorePointer(child: dynamicValueBox(brkValue.brokeragePrice!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isExtraLarge: true))
                          : const SizedBox();
                    }
                  case 'Brk(Rs.)':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? IgnorePointer(child: dynamicValueBox(brkValue.brokeragePrice!.toStringAsFixed(2), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isBig: true))
                          : const SizedBox();
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
      ),
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

  Widget listTitleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ReorderableListView.builder(
          scrollDirection: Axis.horizontal,
          buildDefaultDragHandles: false,
          padding: EdgeInsets.zero,
          itemCount: controller.arrListTitle.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            switch (controller.arrListTitle[index].title) {
              case '':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("", index, controller.arrListTitle, controller.isScrollEnable, isBig: true, updateCallback: controller.refreshView, isImage: true, strImage: controller.isAllSelected ? AppImages.checkBoxSelected : AppImages.checkBox, isSmall: true, onClickImage: () {
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
                        })
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'EXCHANGE':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("EXCHANGE", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'SCRIPT':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("SCRIPT", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'TURNOVER WISE BRK(RS. PER 1/CR))':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("TURNOVER WISE BRK(RS. PER 1/CR))", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isExtraLarge: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'Brk(Rs.)':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("Brk(Rs.)", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isBig: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              default:
                {
                  return SizedBox(
                    key: Key('$index'),
                  );
                }
            }
          },
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            var temp = controller.arrListTitle.removeAt(oldIndex);
            if (newIndex > controller.arrListTitle.length) {
              newIndex = controller.arrListTitle.length;
            }
            controller.arrListTitle.insert(newIndex, temp);
            controller.update();
          },
        ),
      ],
    );
  }
}
