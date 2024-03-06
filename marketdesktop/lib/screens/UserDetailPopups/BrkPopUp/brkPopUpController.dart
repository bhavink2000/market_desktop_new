import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/modelClass/userwiseBrokerageListModelClass.dart';

import '../../../customWidgets/appTextField.dart';
import '../../../main.dart';
import '../../../modelClass/allSymbolListModelClass.dart';
import '../../../modelClass/exchangeListModelClass.dart';
import '../../BaseController/baseController.dart';
import '../../../constant/index.dart';
import '../../MainTabs/ViewTab/MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';

class BrkPopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;

  RxString selectedUser = "".obs;
  List<userWiseBrokerageData> arrBrokerage = [];
  RxString selectedTradeStatus = "".obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  bool isApiCallRunning = false;
  bool isClearApiCallRunning = false;
  bool isupdateCallRunning = false;
  TextEditingController amountController = TextEditingController();
  FocusNode amountFocus = FocusNode();
  TextEditingController textEditingController = TextEditingController();
  FocusNode textEditingFocus = FocusNode();
  String selectedUserId = "";
  bool isAllSelected = false;
  List<String> arrTempSelected = [];
  List<GlobalSymbolData> arrSearchedScript = [];
  List<ExchangeData> arrExchange = [];
  List<String> arrMenuList = [
    "TURNOVER WISE SETTING",
    "SYMBOL WISE SETTING",
  ];
  int selectedCurrentTab = 0;
  FocusNode applyFocus = FocusNode();
  FocusNode updateFocus = FocusNode();
  FocusNode clearFocus = FocusNode();

  List<ListItem> arrListTitle = [];

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    arrListTitle = [
      if (selectedUserForUserDetailPopupParentID == userData!.userId! || userData!.role == UserRollList.admin) ListItem("", true),
      ListItem("EXCHANGE", true),
      ListItem("SCRIPT", true),
      if (selectedCurrentTab == 0) ListItem("TURNOVER WISE BRK(RS. PER 1/CR))", true),
      if (selectedCurrentTab == 1) ListItem("Brk(Rs.)", true),
    ];

    update();
  }

  refreshView() {
    update();
  }

  Future<List<GlobalSymbolData>> getSymbolListByKeyword(String text) async {
    arrSearchedScript.clear();
    update();
    if (text != "") {
      var response = await service.allSymbolListCall(1, text, selectedExchange.value.exchangeId ?? "");
      arrSearchedScript = response!.data ?? [];

      return arrSearchedScript;
    } else {
      return [];
    }
  }

  getExchangeListUserWise({String userId = ""}) async {
    var response = await service.getExchangeListUserWiseCall(userId: userId, brokerageType: selectedCurrentTab == 0 ? "turnoverwise" : "symbolwise");
    if (response != null) {
      if (response.statusCode == 200) {
        arrExchange = response.exchangeData ?? [];
        update();
      }
    }
  }

  userWiseBrkList({bool isFromClear = false, bool isFromApply = false}) async {
    arrBrokerage.clear();
    if (isFromClear) {
      isClearApiCallRunning = true;
    } else if (isFromApply) {
      isApiCallRunning = true;
    }
    update();
    var response = await service.userWiseBrokerageListCall(userId: selectedUserId, search: textEditingController.text.trim(), exchangeId: selectedExchange.value.exchangeId ?? "", type: selectedCurrentTab == 0 ? "turnoverwise" : "symbolwise");
    isApiCallRunning = false;
    isupdateCallRunning = false;
    isClearApiCallRunning = false;
    update();
    arrBrokerage = response!.data ?? [];
    update();
  }
  //*********************************************************************** */
  // Field Validation
  //*********************************************************************** */

  String validateField() {
    var msg = "";

    if (amountController.text.trim().isEmpty) {
      msg = AppString.emptyPrice;
    } else if (arrTempSelected.isEmpty) {
      msg = AppString.emptyScriptSelection;
    }
    return msg;
  }

  updateBrk() async {
    for (var element in arrBrokerage) {
      if (element.isSelected) {
        arrTempSelected.add(element.userWiseBrokerageId!);
      }
    }
    var msg = validateField();
    if (msg.isEmpty) {
      isupdateCallRunning = true;
      update();

      var response = await service.updateBrkCall(
        arrIDs: arrTempSelected,
        brokeragePrice: amountController.text.trim(),
        brokerageType: selectedCurrentTab == 0 ? "turnoverwise" : "symbolwise",
        userId: selectedUserId,
      );
      isApiCallRunning = false;
      isupdateCallRunning = false;
      update();
      arrTempSelected.clear();
      isAllSelected = false;
      if (response != null) {
        if (response.statusCode == 200) {
          showSuccessToast(response.meta!.message ?? "");
          amountController.clear();

          userWiseBrkList();
        } else {
          showErrorToast(response.message ?? "");
        }
      }
    } else {
      showWarningToast(msg);
    }
  }

  Widget userWiseExchangeTypeDropDown(Rx<ExchangeData> selectedExchange, {Function? onChange}) {
    return Container(
      width: 250,
      decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1), color: AppColors().whiteColor),
      child: Obx(() {
        return Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<ExchangeData>(
              isExpanded: true,
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
                searchController: exchangeEditingController,
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
                    controller: exchangeEditingController,
                    focus: exchangeEditingFocus,
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
                          exchangeEditingController.clear();
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
              dropdownStyleData: const DropdownStyleData(maxHeight: 250),
              hint: Text(
                '',
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
                return arrExchange
                    .map((ExchangeData item) => DropdownMenuItem<String>(
                          value: item.name,
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
              value: selectedExchange.value.name != null ? selectedExchange.value : null,
              onChanged: (ExchangeData? newSelectedValue) {
                // setState(() {
                selectedExchange.value = newSelectedValue!;

                if (onChange != null) {
                  onChange();
                }

                // });
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
    );
  }
}
