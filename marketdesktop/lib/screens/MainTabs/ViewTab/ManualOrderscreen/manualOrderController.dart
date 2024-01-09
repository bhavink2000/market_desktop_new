import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../../constant/utilities.dart';
import '../../../../../../modelClass/profileInfoModelClass.dart';
import '../../../../constant/index.dart';
import '../../../../customWidgets/appTextField.dart';
import '../../../../modelClass/allSymbolListModelClass.dart';
import '../../../../modelClass/exchangeListModelClass.dart';
import '../../../../modelClass/myUserListModelClass.dart';
import '../../../BaseController/baseController.dart';
import '../../../../modelClass/constantModelClass.dart';

class manualOrderControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => manualOrderController());
  }
}

class manualOrderController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  ScrollController listcontroller = ScrollController();
  TextEditingController searchTextController = TextEditingController();
  FocusNode searchTextFocus = FocusNode();
  TextEditingController nameController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  TextEditingController rateBoxOneController = TextEditingController();
  FocusNode rateBoxOneFocus = FocusNode();
  TextEditingController rateBoxTwoController = TextEditingController();
  FocusNode rateBoxTwoFocus = FocusNode();
  TextEditingController exchangeSearchController = TextEditingController();
  FocusNode exchangeSearchFocus = FocusNode();
  TextEditingController userSearchController = TextEditingController();
  FocusNode userSearchFocus = FocusNode();
  TextEditingController scriptSearchController = TextEditingController();
  FocusNode scriptSearchFocus = FocusNode();

  Rx<GlobalSymbolData> selectedScriptDropDownValue = GlobalSymbolData().obs;
  Rx<Type> selectedManualType = Type().obs;
  Rx<ExchangeData> selectExchangedropdownValue = ExchangeData().obs;
  RxString typedropdownValue = "".obs;
  RxString orderTypedropdownValue = "".obs;
  RxString rateaBydropdownValue = "".obs;
  bool isDarkMode = false;
  ProfileInfoData? userDetailsObj;
  RxBool isBuy = true.obs;
  RxList<GlobalSymbolData> arrMainScript = RxList<GlobalSymbolData>();
  bool isApicall = false;
  bool isSellApicall = false;
  List<UserData> arrUserListOnlyClient = [];
  Rx<UserData> selectedUser = UserData().obs;
  FocusNode buyFocus = FocusNode();
  FocusNode sellFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  RxBool isValidQty = true.obs;
  TextEditingController qtyController = TextEditingController();
  FocusNode qtyFocus = FocusNode();
  TextEditingController lotController = TextEditingController();
  FocusNode lotFocus = FocusNode();
  Rx<DateTime?> fromDate = DateTime.now().obs;
  @override
  void onInit() async {
    super.onInit();
    lotController.addListener(() {
      // if (isQuantityUpdate == false) {
      if (!qtyFocus.hasFocus) {
        if (selectedScriptDropDownValue.value.symbolId != null || selectedScriptDropDownValue.value.symbolId != "") {
          var temp = num.parse(lotController.text) * selectedScriptDropDownValue.value.ls!;
          qtyController.text = temp.toString();
        }

        // isValidQty = true.obs;
      }

      // }
    });
    getUserList();
    await getScriptList();
    update();
  }

  getScriptList() async {
    var response = await service.allSymbolListCall(1, "", selectExchangedropdownValue.value.exchangeId ?? "");
    arrMainScript.value = response!.data ?? [];
  }

  getUserList() async {
    var response = await service.getMyUserListCall(roleId: UserRollList.user);
    arrUserListOnlyClient = response!.data ?? [];
    update();
    // if (arrUserListOnlyClient.isNotEmpty) {
    //   selectedUser.value = arrUserListOnlyClient.first;
    // }
  }

  String validateForm() {
    var msg = "";
    if (selectedUser.value.userId == null) {
      msg = AppString.emptyUserName;
    } else if (selectExchangedropdownValue.value.exchangeId == null) {
      msg = AppString.emptyExchange;
    } else if (selectedScriptDropDownValue.value.symbolId == null) {
      msg = AppString.emptyScript;
    } else if (rateBoxOneController.text.trim().isEmpty) {
      msg = AppString.emptyPrice;
    } else if (qtyController.text.trim().isEmpty) {
      msg = AppString.emptyQty;
    } else if (isValidQty == false) {
      msg = AppString.inValidQty;
    } else if (lotController.text.trim().isEmpty) {
      msg = AppString.inValidLot;
    } else if (selectedManualType.value.id == null) {
      msg = AppString.emptyTradeDisplayFor;
    }

    return msg;
  }

  initiateManualTrade() async {
    var msg = validateForm();

    if (msg.isEmpty) {
      var msg = "Are you sure you want to trade for following details? \n";
      msg = msg + "Username : " + selectedUser.value.userName! + "\n";
      msg = msg + "Exchange : " + selectExchangedropdownValue.value.name! + "\n";
      msg = msg + "Script : " + selectedScriptDropDownValue.value.symbolTitle! + "\n";
      msg = msg + "Rate : " + rateBoxOneController.text + "\n";
      msg = msg + "Qty : " + qtyController.text + "\n";
      msg = msg + "Lot : " + lotController.text + "\n";
      msg = msg + "Execution Time : " + shortFullDateTime(fromDate.value!) + "\n";
      msg = msg + "Trade Display For : " + selectedManualType.value.name! + "\n";
      showPermissionDialog(
          message: msg,
          acceptButtonTitle: "Yes",
          rejectButtonTitle: "No",
          yesClick: () async {
            Get.back();
            if (isBuy.value) {
              isApicall = true;
            } else {
              isSellApicall = true;
            }
            var qty = double.parse(qtyController.text) / selectedScriptDropDownValue.value.lotSize!;
            update();
            var response = await service.manualTradeCall(
                executionTime: serverFormatDateTime(fromDate.value!),
                symbolId: selectedScriptDropDownValue.value.symbolId,
                totalQuantity: double.parse(qtyController.text),
                quantity: qty,
                price: double.parse(rateBoxOneController.text),
                lotSize: selectedScriptDropDownValue.value.lotSize!.toInt(),
                orderType: "market",
                tradeType: isBuy.value ? "buy" : "sell",
                exchangeId: selectExchangedropdownValue.value.exchangeId,
                userId: selectedUser.value.userId!,
                manuallyTradeAddedFor: selectedManualType.value.id,
                refPrice: isBuy.value ? selectedScriptDropDownValue.value.ask!.toDouble() : selectedScriptDropDownValue.value.bid!.toDouble());

            //longterm
            isApicall = false;
            isSellApicall = false;
            update();
            if (response != null) {
              // Get.back();
              if (response.statusCode == 200) {
                selectExchangedropdownValue = ExchangeData().obs;
                selectedScriptDropDownValue = GlobalSymbolData().obs;
                rateBoxOneController.clear();
                qtyController.clear();
                if (isBuy.value) {
                  showSuccessToast(response.meta!.message!);
                } else {
                  showSuccessToast(response.meta!.message!, bgColor: AppColors().redColor);
                }
              } else {
                isApicall = false;
                showErrorToast(response.message!);
                update();
              }
            }
          },
          noclick: () {
            Get.back();
          });
    } else {
      // stateSetter(() {});
      showWarningToast(msg);
      Future.delayed(const Duration(milliseconds: 100), () {});
    }
  }

  Widget userListDropDown(Rx<UserData> selectedUser, {double? width}) {
    return Obx(() {
      return Container(

          // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),

          child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField2<UserData>(
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
              searchController: userSearchController,
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
                  placeHolderMsg: "Search User",
                  emptyFieldMsg: "",
                  controller: userSearchController,
                  focus: userSearchFocus,
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
              'Select User',
              style: TextStyle(
                fontSize: 12,
                fontFamily: CustomFonts.family1Medium,
                color: AppColors().darkText,
              ),
            ),
            items: arrUserListOnlyClient
                .map((UserData item) => DropdownItem<UserData>(
                      value: item,
                      height: 30,
                      child: Text(item.userName ?? "", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().grayColor)),
                    ))
                .toList(),
            selectedItemBuilder: (context) {
              return arrUserListOnlyClient
                  .map((UserData item) => DropdownMenuItem<UserData>(
                        value: item,
                        child: Text(
                          item.userName ?? "",
                          style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText, overflow: TextOverflow.ellipsis),
                        ),
                      ))
                  .toList();
            },
            value: selectedUser.value.userId == null ? null : selectedUser.value,
            onChanged: (UserData? value) {
              selectedUser.value = value!;
            },
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 0),
              height: 40,
              // width: 140,
            ),
            dropdownStyleData: const DropdownStyleData(maxHeight: 250),
          ),
        ),
      ));
    });
  }
}
