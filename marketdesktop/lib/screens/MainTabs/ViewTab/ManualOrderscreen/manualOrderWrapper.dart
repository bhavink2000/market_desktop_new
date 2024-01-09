import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../constant/index.dart';
import '../../../../constant/utilities.dart';
import '../../../../customWidgets/appButton.dart';
import '../../../../customWidgets/appTextField.dart';
import '../../../../customWidgets/incrimentField.dart';
import '../../../../main.dart';
import '../../../../modelClass/allSymbolListModelClass.dart';
import '../../../../modelClass/exchangeListModelClass.dart';
import '../../../../modelClass/myUserListModelClass.dart';
import '../../../BaseController/baseController.dart';
import 'manualOrderController.dart';
import '../../../../modelClass/constantModelClass.dart';

class ManualOrderScreen extends BaseView<manualOrderController> {
  const ManualOrderScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors().whiteColor,
      body: Container(
        height: 100.h,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: AppColors().bgColor,
        ),
        child: Center(
          child: Container(
            width: 30.w,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  userDetailsView(),
                  // buySellRadioView(),
                  exchangeDetailView(),
                  scriptDetailView(),
                  rateDetailsView(),
                  // typeDetailView(),
                  // orderTypeDetailView(),

                  LotDetailsView(),
                  QuantityDetailsView(),
                  SizedBox(
                    height: 15,
                  ),
                  timePickerView(),
                  typeDetailView(),
                  Row(
                    children: [
                      buyBtnView(),
                      sellBtnView(),
                    ],
                  ),
                  clearBtnView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buySellRadioView() {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Text("Order Type : ", style: TextStyle(fontSize: 16, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
            Spacer(),
            GestureDetector(
              onTap: () {
                if (controller.isBuy.value == true) {
                  controller.isBuy.value = false;
                } else {
                  controller.isBuy.value = true;
                }
                controller.update();
              },
              child: Container(
                child: Row(
                  children: [
                    Container(
                      child: Image.asset(
                        controller.isBuy.value == true ? AppImages.checkBoxSelectedRound : AppImages.checkBoxRound,
                        height: 20,
                        width: 20,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Buy", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                if (controller.isBuy.value == false) {
                  controller.isBuy.value = true;
                } else {
                  controller.isBuy.value = false;
                }

                controller.update();
              },
              child: Container(
                child: Row(
                  children: [
                    Container(
                      child: Image.asset(
                        controller.isBuy.value == false ? AppImages.checkBoxSelectedRound : AppImages.checkBoxRound,
                        height: 20,
                        width: 20,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text("Sell", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                  ],
                ),
              ),
            ),
            Spacer(),
          ],
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }

  Widget userDetailsView() {
    return Container(
      width: 30.w,
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.h),
      child: Row(
        children: [
          Text("User : ", style: TextStyle(fontSize: 16, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
          Spacer(),
          Container(
            height: 5.6.h,
            width: 20.w,
            child: controller.userListDropDown(controller.selectedUser),
          ),
        ],
      ),
    );
  }

  Widget exchangeDetailView() {
    return Container(
      // height: 10.h,
      width: 30.w,
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: Row(
        children: [
          Text("Exchange : ", style: TextStyle(fontSize: 16, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
          Spacer(),
          Container(
            height: 5.6.h,
            width: 20.w,
            child: Obx(() {
              return Center(
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField2<ExchangeData>(
                    isExpanded: true,
                    decoration: commonFocusBorder,
                    iconStyleData: IconStyleData(
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Image.asset(
                          AppImages.arrowDown,
                          height: 20,
                          width: 20,
                          color: AppColors().fontColor,
                        ),
                      ),
                    ),
                    dropdownSearchData: DropdownSearchData(
                      searchController: controller.exchangeSearchController,
                      searchBarWidgetHeight: 50,
                      searchBarWidget: Container(
                        height: 40,
                        // padding: EdgeInsets.only(top: 2.w, right: 2.w, left: 2.w),
                        child: CustomTextField(
                          type: '',
                          keyBoardType: TextInputType.text,
                          isEnabled: true,
                          isOptional: false,
                          inValidMsg: "",
                          placeHolderMsg: "Search Exchange",
                          emptyFieldMsg: "",
                          controller: controller.exchangeSearchController,
                          focus: controller.exchangeSearchFocus,
                          isSecure: false,
                          borderColor: AppColors().grayLightLine,
                          keyboardButtonType: TextInputAction.done,
                          maxLength: 64,
                          prefixIcon: Image.asset(
                            AppImages.searchIcon,
                            height: 20,
                            width: 20,
                          ),
                          suffixIcon: Container(
                            child: GestureDetector(
                              onTap: () {
                                userEditingController.clear();
                              },
                              child: Image.asset(
                                AppImages.crossIcon,
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return item.value!.name.toString().toLowerCase().startsWith(searchValue.toLowerCase());
                      },
                    ),
                    hint: Text(
                      'Select Exchange',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: CustomFonts.family1Medium,
                        color: AppColors().darkText,
                      ),
                    ),
                    items: arrExchange
                        .map((ExchangeData item) => DropdownItem<ExchangeData>(
                              value: item,
                              height: 30,
                              child: Text(item.name ?? "", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().grayColor)),
                            ))
                        .toList(),
                    selectedItemBuilder: (context) {
                      return arrExchange
                          .map((ExchangeData item) => DropdownMenuItem<ExchangeData>(
                                value: item,
                                child: Text(
                                  item.name ?? "",
                                  style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText, overflow: TextOverflow.ellipsis),
                                ),
                              ))
                          .toList();
                    },
                    value: controller.selectExchangedropdownValue.value.exchangeId == null ? null : controller.selectExchangedropdownValue.value,
                    onChanged: (ExchangeData? value) {
                      controller.selectExchangedropdownValue.value = value!;
                      controller.selectedScriptDropDownValue.value = GlobalSymbolData();
                      controller.arrMainScript.clear();
                      controller.update();
                      controller.getScriptList();
                    },
                    buttonStyleData: const ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      height: 40,
                      // width: 140,
                    ),
                    dropdownStyleData: const DropdownStyleData(maxHeight: 250),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget scriptDetailView() {
    return Container(
      // height: 10.h,
      width: 30.w,

      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.h),
      child: Row(
        children: [
          Text("Script : ", style: TextStyle(fontSize: 16, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
          Spacer(),
          Container(
            height: 5.6.h,
            width: 20.w,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Center(
              child: Obx(() {
                return Center(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField2<GlobalSymbolData>(
                      isExpanded: true,
                      decoration: commonFocusBorder,
                      iconStyleData: IconStyleData(
                        icon: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Image.asset(
                            AppImages.arrowDown,
                            height: 20,
                            width: 20,
                            color: AppColors().fontColor,
                          ),
                        ),
                      ),
                      dropdownSearchData: DropdownSearchData(
                        searchController: controller.scriptSearchController,
                        searchBarWidgetHeight: 50,
                        searchBarWidget: Container(
                          height: 40,
                          // padding: EdgeInsets.only(top: 2.w, right: 2.w, left: 2.w),
                          child: CustomTextField(
                            type: '',
                            keyBoardType: TextInputType.text,
                            isEnabled: true,
                            isOptional: false,
                            inValidMsg: "",
                            placeHolderMsg: "Search Script",
                            emptyFieldMsg: "",
                            controller: controller.scriptSearchController,
                            focus: controller.scriptSearchFocus,
                            isSecure: false,
                            borderColor: AppColors().grayLightLine,
                            keyboardButtonType: TextInputAction.done,
                            maxLength: 64,
                            prefixIcon: Image.asset(
                              AppImages.searchIcon,
                              height: 20,
                              width: 20,
                            ),
                            suffixIcon: Container(
                              child: GestureDetector(
                                onTap: () {
                                  controller.scriptSearchController.clear();
                                },
                                child: Image.asset(
                                  AppImages.crossIcon,
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return item.value!.symbolTitle.toString().toLowerCase().startsWith(searchValue.toLowerCase());
                        },
                      ),
                      dropdownStyleData: const DropdownStyleData(maxHeight: 250),
                      hint: Text(
                        '',
                        style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText, overflow: TextOverflow.ellipsis),
                      ),
                      items: controller.arrMainScript
                          .map((GlobalSymbolData item) => DropdownItem<GlobalSymbolData>(
                                value: item,
                                height: 30,
                                child: Text(item.symbolTitle ?? "", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText, overflow: TextOverflow.ellipsis)),
                              ))
                          .toList(),
                      selectedItemBuilder: (context) {
                        return controller.arrMainScript
                            .map((GlobalSymbolData item) => DropdownMenuItem<String>(
                                  value: item.symbolTitle,
                                  child: Text(
                                    item.symbolTitle ?? "",
                                    style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText, overflow: TextOverflow.ellipsis),
                                  ),
                                ))
                            .toList();
                      },
                      value: controller.selectedScriptDropDownValue.value.exchangeId != null ? controller.selectedScriptDropDownValue.value : null,
                      onChanged: (GlobalSymbolData? value) {
                        // // setState(() {
                        // controller.selectedScriptFromAll = value;
                        // controller.update();
                        // // });

                        controller.selectedScriptDropDownValue.value = value!;
                        var temp = num.parse(controller.lotController.text) * controller.selectedScriptDropDownValue.value.ls!;
                        controller.qtyController.text = temp.toString();
                      },
                      buttonStyleData: const ButtonStyleData(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        height: 40,
                        // width: 140,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget typeDetailView() {
    return Container(
      // height: 10.h,
      width: 30.w,
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.h),
      child: Row(
        children: [
          Text("Trade display for : ", style: TextStyle(fontSize: 16, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
          Spacer(),
          Container(
            height: 5.6.h,
            width: 20.w,
            // decoration: BoxDecoration(
            //     border: Border.all(
            //       color: AppColors().grayLightLine,
            //       width: 1.5,
            //     ),
            //     borderRadius: BorderRadius.circular(3)),
            // padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Obx(() {
                return Center(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField2<Type>(
                        isExpanded: false,

                        // alignment: Alignment.topCenter,
                        decoration: commonFocusBorder,
                        dropdownStyleData: const DropdownStyleData(maxHeight: 250),
                        hint: Text(
                          'Select Trade display for',
                          style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().lightText, overflow: TextOverflow.ellipsis),
                        ),

                        items: constantValues!.manuallyTradeAddedFor!
                            .map((Type item) => DropdownItem<Type>(
                                  value: item,
                                  height: 30,
                                  child: Text(item.name ?? "", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText, overflow: TextOverflow.ellipsis)),
                                ))
                            .toList(),
                        selectedItemBuilder: (context) {
                          return constantValues!.manuallyTradeAddedFor!
                              .map((Type item) => DropdownMenuItem<Type>(
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
                        value: controller.selectedManualType.value.name != null ? controller.selectedManualType.value : null,
                        onChanged: (Type? value) {
                          // setState(() {
                          controller.selectedManualType.value = value!;

                          // controller.update();
                          // });
                        },
                        // buttonStyleData: const ButtonStyleData(
                        //   padding: EdgeInsets.symmetric(horizontal: 0),
                        //   height: 40,
                        //   // width: 140,
                        // ),
                        // menuItemStyleData: const MenuItemStyleData(
                        //   height: 40,
                        // ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget rateDetailsView() {
    return Container(
      width: 30.w,
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: Row(
        children: [
          Text("Rate : ", style: TextStyle(fontSize: 16, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
          Spacer(),
          SizedBox(
            height: 5.6.h,
            width: 20.w,
            child: CustomTextField(
              type: 'User Name',
              regex: "[0-9.]",
              keyBoardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
              isEnabled: true,
              isOptional: false,
              borderColor: AppColors().lightOnlyText,
              inValidMsg: AppString.emptyServer,
              placeHolderMsg: "00.00",
              emptyFieldMsg: AppString.emptyServer,
              controller: controller.rateBoxOneController,
              focus: controller.rateBoxOneFocus,
              isSecure: false,
              keyboardButtonType: TextInputAction.next,
              maxLength: 10,
              isShowPrefix: false,
              isShowSufix: false,
              suffixIcon: null,
              prefixIcon: null,
            ),
          ),
        ],
      ),
    );
  }

  Widget QuantityDetailsView() {
    return Container(
      width: 30.w,
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: Row(
        children: [
          Text("Qty : ", style: TextStyle(fontSize: 16, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                return Text(
                  controller.isValidQty.value ? "" : "Invalid Quantity",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: controller.isValidQty.value ? AppColors().darkText : AppColors().redColor,
                    fontFamily: CustomFonts.family1Regular,
                  ),
                );
              }),
              Container(
                width: 20.w,
                height: 5.6.h,

                // margin: EdgeInsets.symmetric(vertical: 5),
                child: CustomTextField(
                  regex: "[0-9]",
                  type: '',
                  focusBorderColor: AppColors().blueColor,
                  keyBoardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
                  isEnabled: true,
                  isOptional: false,
                  isNoNeededCapital: true,
                  inValidMsg: AppString.emptyMobileNumber,
                  placeHolderMsg: "",
                  labelMsg: "",
                  emptyFieldMsg: AppString.emptyMobileNumber,
                  controller: controller.qtyController,
                  focus: controller.qtyFocus,
                  isSecure: false,
                  keyboardButtonType: TextInputAction.next,
                  onChange: () {
                    if (controller.qtyController.text.isNotEmpty) {
                      if (controller.selectedScriptDropDownValue.value.oddLotTrade == 1) {
                        var temp = (num.parse(controller.qtyController.text) / controller.selectedScriptDropDownValue.value.ls!);
                        controller.lotController.text = temp.toStringAsFixed(2);
                        controller.isValidQty.value = true;
                      } else {
                        var temp = (num.parse(controller.qtyController.text) / controller.selectedScriptDropDownValue.value.ls!);

                        print(temp);
                        if ((num.parse(controller.qtyController.text) % controller.selectedScriptDropDownValue.value.ls!) == 0) {
                          controller.lotController.text = temp.toStringAsFixed(0);
                          controller.isValidQty.value = true;
                        } else {
                          controller.isValidQty.value = false;
                        }
                      }

                      controller.update();
                    }
                  },
                  maxLength: 10,
                  isShowPrefix: false,
                  isShowSufix: false,
                  suffixIcon: null,
                  prefixIcon: null,
                  borderColor: AppColors().lightOnlyText,
                  roundCorner: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.only(left: 10),
    //       child: Text(
    //         "Lot",
    //         textAlign: TextAlign.center,
    //         style: TextStyle(
    //           fontSize: 12,
    //           color: AppColors().darkText,
    //           fontFamily: CustomFonts.family1Regular,
    //         ),
    //       ),
    //     ),
    //     Container(
    //       width: 14.w,
    //       height: 5.6.h,
    //       margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    //       child: NumberInputWithIncrementDecrementOwn(
    //         incIconSize: 18,
    //         decIconSize: 18,
    //         validator: (value) {
    //           return null;
    //         },
    //         onDecrement: (newValue) {
    //           controller.isValidQty = true.obs;
    //           controller.update();
    //         },
    //         onIncrement: (newValue) {
    //           controller.isValidQty = true.obs;
    //           controller.update();
    //         },
    //         onChanged: (newValue) {},
    //         autovalidateMode: AutovalidateMode.disabled,
    //         fractionDigits: 2,
    //         textAlign: TextAlign.left,

    //         initialValue: 1,
    //         incDecFactor: 1,
    //         isInt: true,
    //         style: TextStyle(
    //           fontSize: 12,
    //           fontFamily: CustomFonts.family1Regular,
    //           color: AppColors().darkText,
    //         ),
    //         numberFieldDecoration: InputDecoration(border: InputBorder.none, fillColor: AppColors().whiteColor, contentPadding: EdgeInsets.only(bottom: 8, left: 20)),

    //         widgetContainerDecoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(0),
    //           color: AppColors().whiteColor,
    //         ),
    //         controller: controller.lotController,
    //         min: 1,
    //         // max: 1000000000000,
    //       ),
    //     )
    //   ],
    // ),
    // return Container(
    //   // height: 10.h,
    //   width: 30.w,
    //   padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.h),
    //   child: Row(
    //     children: [
    //       Text("Qty : ", style: TextStyle(fontSize: 16, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
    //       Spacer(),
    //       Container(
    //         height: 5.6.h,
    //         width: 20.w,
    //         child: CustomTextField(
    //           type: 'Quantity',
    //           regex: "[0-9]",
    //           keyBoardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
    //           isEnabled: true,
    //           isOptional: false,
    //           inValidMsg: AppString.emptyServer,
    //           placeHolderMsg: "",
    //           labelMsg: "",
    //           emptyFieldMsg: AppString.emptyServer,
    //           controller: controller.quantityController,
    //           focus: controller.quantityFocus,
    //           isSecure: false,
    //           keyboardButtonType: TextInputAction.done,
    //           maxLength: 10,
    //           isShowPrefix: false,
    //           isShowSufix: false,
    //           suffixIcon: null,
    //           prefixIcon: null,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget LotDetailsView() {
    return Container(
      width: 30.w,
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: Row(
        children: [
          Text("Lot : ", style: TextStyle(fontSize: 16, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
          Spacer(),
          Container(
            width: 20.w,
            height: 5.6.h,
            margin: EdgeInsets.only(top: 15),
            child: NumberInputWithIncrementDecrementOwn(
              incIconSize: 25,
              decIconSize: 25,
              validator: (value) {
                return null;
              },
              onDecrement: (newValue) {
                controller.isValidQty = true.obs;
                controller.update();
              },
              onIncrement: (newValue) {
                controller.isValidQty = true.obs;
                controller.update();
              },
              onChanged: (newValue) {},
              autovalidateMode: AutovalidateMode.disabled,
              fractionDigits: 2,
              textAlign: TextAlign.left,

              initialValue: 1,
              incDecFactor: 1,
              isInt: true,
              style: TextStyle(
                fontSize: 12,
                fontFamily: CustomFonts.family1Regular,
                color: AppColors().darkText,
              ),
              numberFieldDecoration: InputDecoration(
                border: InputBorder.none,
                fillColor: AppColors().whiteColor,
                contentPadding: EdgeInsets.only(bottom: 8, left: 20),
              ),

              widgetContainerDecoration: BoxDecoration(borderRadius: BorderRadius.circular(0), color: AppColors().whiteColor, border: Border.all(color: AppColors().lightOnlyText, width: 1)),
              controller: controller.lotController,
              min: 1,
              // max: 1000000000000,
            ),
          ),
        ],
      ),
    );

    // return Container(
    //   // height: 10.h,
    //   width: 30.w,
    //   padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.h),
    //   child: Row(
    //     children: [
    //       Text("Qty : ", style: TextStyle(fontSize: 16, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
    //       Spacer(),
    //       Container(
    //         height: 5.6.h,
    //         width: 20.w,
    //         child: CustomTextField(
    //           type: 'Quantity',
    //           regex: "[0-9]",
    //           keyBoardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
    //           isEnabled: true,
    //           isOptional: false,
    //           inValidMsg: AppString.emptyServer,
    //           placeHolderMsg: "",
    //           labelMsg: "",
    //           emptyFieldMsg: AppString.emptyServer,
    //           controller: controller.quantityController,
    //           focus: controller.quantityFocus,
    //           isSecure: false,
    //           keyboardButtonType: TextInputAction.done,
    //           maxLength: 10,
    //           isShowPrefix: false,
    //           isShowSufix: false,
    //           suffixIcon: null,
    //           prefixIcon: null,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget timePickerView() {
    return Container(
      width: 30.w,
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text("Execution Time :", style: TextStyle(fontSize: 16, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              showTimeSelectionPopUp();
            },
            child: Obx(() {
              return Container(
                height: 5.6.h,
                width: 20.w,
                decoration: BoxDecoration(
                    color: AppColors().whiteColor,
                    border: Border.all(
                      color: AppColors().lightOnlyText,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(3)),
                // color: AppColors().whiteColor,
                padding: const EdgeInsets.only(right: 15, left: 15),
                child: Row(
                  children: [
                    Text(
                      shortFullDateTime(controller.fromDate.value!),
                      style: TextStyle(
                        fontSize: 12,
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
        ],
      ),
    );
  }

  showTimeSelectionPopUp() async {
    // showDialog(
    //   context: Get.context!,
    //   builder: (context) {
    //     var now = DateTime.now();
    //     return Dialog(
    //       insetPadding: EdgeInsets.symmetric(horizontal: 35.w),
    //       child: SpinnerDateTimePicker(
    //         initialDateTime: now,
    //         maximumDate: now,
    //         minimumDate: now.subtract(Duration(days: 100)),
    //         mode: CupertinoDatePickerMode.dateAndTime,
    //         use24hFormat: false,
    //         didSetTime: (value) {
    //           controller.fromDate.value = value;
    //         },
    //       ),
    //     );
    //   },
    // );
    controller.fromDate.value = await showOmniDateTimePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now(),
      is24HourMode: false,
      isShowSeconds: false,
      minutesInterval: 1,
      secondsInterval: 1,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      selectableDayPredicate: (dateTime) {
        // Disable 25th Feb 2023
        // controller.fromDate.value = shortFullDateTime(dateTime);
        if (dateTime == DateTime(2023, 2, 25)) {
          return false;
        } else {
          return true;
        }
      },
    );
    // showDialog<String>(
    //     context: Get.context!,
    //     // barrierColor: Colors.transparent,
    //     barrierDismissible: true,
    //     builder: (BuildContext context) => FloatingDialog(
    //           // titlePadding: EdgeInsets.zero,
    //           // backgroundColor: AppColors().bgColor,
    //           // surfaceTintColor: AppColors().bgColor,

    //           // contentPadding: EdgeInsets.zero,
    //           // insetPadding: EdgeInsets.symmetric(
    //           //   horizontal: 20.w,
    //           //   vertical: 32.h,
    //           // ),
    //           enableDragAnimation: false,
    //           child: Container(
    //             // width: 30.w,
    //             // height: 28.h,
    //             width: 450,
    //             height: 450,
    //             decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
    //             child: CalendarCarousel<Event>(
    //               onDayPressed: (DateTime date, List<Event> events) {
    //                 onDateSelection(date);
    //                 Get.back();
    //               },
    //               weekendTextStyle: TextStyle(
    //                 color: Colors.red,
    //               ),
    //               thisMonthDayBorderColor: Colors.transparent,
    //               weekFormat: false,

    //               height: 420.0,
    //               selectedDateTime: fromDate,
    //               daysHaveCircularBorder: false,

    //               /// null for not rendering any border, true for circular border, false for rectangular border
    //             ),
    //           ),
    //         ));
  }

  Widget buyBtnView() {
    return Container(
      width: 15.w,
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.h),
      child: CustomButton(
        isEnabled: true,
        shimmerColor: AppColors().whiteColor,
        title: "Buy",
        textSize: 16,
        focusKey: controller.buyFocus,
        borderColor: Colors.transparent,
        focusShadowColor: AppColors().blueColor,
        buttonHeight: 6.5.h,
        onPress: () {
          controller.isBuy.value = true;

          controller.initiateManualTrade();
        },
        bgColor: AppColors().blueColor,
        isFilled: true,
        textColor: AppColors().whiteColor,
        isTextCenter: true,
        isLoading: controller.isApicall,
      ),
    );
  }

  Widget sellBtnView() {
    return Container(
      width: 15.w,
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.h),
      child: CustomButton(
        isEnabled: true,
        shimmerColor: AppColors().whiteColor,
        title: "Sell",
        textSize: 16,
        focusKey: controller.sellFocus,
        borderColor: Colors.transparent,
        focusShadowColor: AppColors().blueColor,
        buttonHeight: 6.5.h,
        onPress: () {
          controller.isBuy.value = false;
          controller.initiateManualTrade();
        },
        bgColor: AppColors().redColor,
        isFilled: true,
        textColor: AppColors().whiteColor,
        isTextCenter: true,
        isLoading: controller.isSellApicall,
      ),
    );
  }

  Widget clearBtnView() {
    return Container(
      width: 30.w,
      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0),
      child: CustomButton(
        isEnabled: true,
        shimmerColor: AppColors().blueColor,
        title: "Clear",
        textSize: 16,
        focusKey: controller.clearFocus,
        borderColor: Colors.transparent,
        focusShadowColor: AppColors().blueColor,
        buttonHeight: 6.5.h,
        onPress: () {
          controller.nameController.text = "";
          controller.rateBoxOneController.text = "";
          controller.rateBoxTwoController.text = "";
          controller.qtyController.text = "";
          controller.selectedUser = UserData().obs;
          controller.selectExchangedropdownValue = ExchangeData().obs;
          controller.selectedScriptDropDownValue = GlobalSymbolData().obs;
          controller.typedropdownValue.value = "";
          controller.orderTypedropdownValue.value = "";
          controller.rateaBydropdownValue.value = "";
          controller.update();
        },
        bgColor: AppColors().grayLightLine,
        isFilled: true,
        textColor: AppColors().blueColor,
        isTextCenter: true,
        isLoading: false,
      ),
    );
  }
}
