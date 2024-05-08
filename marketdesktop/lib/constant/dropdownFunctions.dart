import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:floating_dialog/floating_dialog.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/customWidgets/appTextField.dart';
import 'package:marketdesktop/main.dart';

import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/brokerListModelClass.dart';
import 'package:marketdesktop/modelClass/constantModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/groupListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/userRoleListModelClass.dart';
import 'package:marketdesktop/service/network/allApiCallService.dart';
import '../constant/index.dart';

List<UserData> arrUserList = [];
List<String> arrSortType = ["Top", "Last"];
List<AddMaster> arrFilterType = [];

List<String> arrSortCount = ["5", "10", "15", "20"];
List<String> arrPeriodList = ["Month", "Year", "Week"];
List<String> arrPLTypeforAccount = ["All", "Only M2M", "Only Release"];
List<String> arrLogType = ["All"];
List<Type> arrTradeStatus = [];
List<String> arrTradeAttribute = ["Fully", "Close"];
List<userRoleListData> arrUserTypeList = [];
List<ExchangeData> arrExchange = [];
List<GlobalSymbolData> arrAllScript = [];
List<String> arrCustomDateSelection = CommonCustomDateSelection().arrCustomDate;

List<BrokerListModelData> arrBrokerList = [];
AllApiCallService service = AllApiCallService();
List<AddMaster> arrLeverageList = [];
List<AddMaster> arrStatuslist = [];
GlobalKey? dropdownUserTypeKey;
TextEditingController scriptEditingController = TextEditingController();
FocusNode scriptEditingFocus = FocusNode();
TextEditingController exchangeEditingController = TextEditingController();
FocusNode exchangeEditingFocus = FocusNode();
TextEditingController userEditingController = TextEditingController();
FocusNode userEditingFocus = FocusNode();
bool isSuperAdminPopUpOpen = false;
bool isCommonScreenPopUpOpen = false;
bool isChangePasswordScreenPopUpOpen = false;
bool isUpdateLeveragePopUpOpen = false;

String currentOpenedScreen = ScreenViewNames.marketWatch;
final List<Map<String, dynamic>> _roles = arrLeverageList.map((e) => e.toJson()).toList();

Widget sortTypeDropDown(RxString selectedType, {double? width}) {
  return Obx(() {
    return SizedBox(
        width: width ?? 250,
        // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),

        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<String>(
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
              dropdownStyleData: const DropdownStyleData(maxHeight: 150),
              hint: Text(
                '',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().darkText,
                ),
              ),
              items: arrSortType
                  .map((String item) => DropdownItem<String>(
                        value: item,
                        height: 40,
                        child: Text(
                          item,
                          style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().grayColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return arrSortType
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: CustomFonts.family1Medium,
                              color: AppColors().darkText,
                            ),
                          ),
                        ))
                    .toList();
              },
              value: selectedType.value.isEmpty ? null : selectedType.value,
              onChanged: (String? value) {
                selectedType.value = value!;
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 40,
                // width: 140,
              ),
              // menuItemStyleData: const MenuItemStyleData(
              //   height: 30,
              // ),
            ),
          ),
        ));
  });
}

Widget filterTypeDropDown(Rx<AddMaster> selectedFilterType, {double? width}) {
  return Obx(() {
    return SizedBox(
        width: width ?? 250,
        // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        height: 30,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<AddMaster>(
              isExpanded: true,
              decoration: commonFocusBorder,
              iconStyleData: IconStyleData(
                icon: Image.asset(
                  AppImages.arrowDown,
                  height: 20,
                  width: 20,
                  color: AppColors().fontColor,
                ),
              ),
              dropdownStyleData: const DropdownStyleData(maxHeight: 150),
              hint: Text(
                '',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().darkText,
                ),
              ),
              items: arrFilterType
                  .map((AddMaster item) => DropdownItem<AddMaster>(
                        value: item,
                        height: 30,
                        child: Text(
                          item.name ?? "",
                          style: TextStyle(fontSize: 10, fontFamily: CustomFonts.family1Regular, color: AppColors().grayColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return arrFilterType
                    .map((AddMaster item) => DropdownMenuItem<AddMaster>(
                          value: item,
                          child: Text(
                            item.name ?? "",
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: CustomFonts.family1Regular,
                              color: AppColors().darkText,
                            ),
                          ),
                        ))
                    .toList();
              },
              value: selectedFilterType.value.id != null ? selectedFilterType.value : null,
              onChanged: (AddMaster? value) {
                selectedFilterType.value = value!;
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 40,
                // width: 135,
              ),
              // menuItemStyleData: const MenuItemStyleData(
              //   height: 30,
              // ),
            ),
          ),
        ));
  });
}

Widget billTypeDropDown(Rx<AddMaster?> selectedBillType, {double? width}) {
  return Obx(() {
    return SizedBox(
        width: width ?? 250,
        // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        height: 30,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<AddMaster>(
              isExpanded: true,
              decoration: commonFocusBorder,
              iconStyleData: IconStyleData(
                icon: Image.asset(
                  AppImages.arrowDown,
                  height: 20,
                  width: 20,
                  color: AppColors().fontColor,
                ),
              ),
              dropdownStyleData: const DropdownStyleData(maxHeight: 150),
              hint: Text(
                '',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().darkText,
                ),
              ),
              items: constantValues!.billType!
                  .map((AddMaster item) => DropdownItem<AddMaster>(
                        height: 30,
                        value: item,
                        child: Text(item.name ?? "", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().grayColor)),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return constantValues!.billType!
                    .map((AddMaster item) => DropdownMenuItem<AddMaster>(
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
              value: selectedBillType.value?.name == null ? null : selectedBillType.value,
              onChanged: (AddMaster? value) {
                selectedBillType.value = value!;
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 40,
                // width: 140,
              ),
            ),
          ),
        ));
  });
}

Widget productTypeForAccountDropDown(Rx<Type?> selectedProductType, {double? width}) {
  return Obx(() {
    return SizedBox(
        width: width ?? 250,
        // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        height: 30,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<Type>(
              isExpanded: true,
              decoration: commonFocusBorder,
              iconStyleData: IconStyleData(
                icon: Image.asset(
                  AppImages.arrowDown,
                  height: 20,
                  width: 20,
                  color: AppColors().fontColor,
                ),
              ),
              dropdownStyleData: const DropdownStyleData(maxHeight: 150),
              hint: Text(
                '',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().darkText,
                ),
              ),
              items: constantValues!.productTypeForAccount!
                  .map((Type item) => DropdownItem<Type>(
                        height: 30,
                        value: item,
                        child: Text(item.name ?? "", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().grayColor)),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return constantValues!.productTypeForAccount!
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
              value: selectedProductType.value?.name == null ? null : selectedProductType.value,
              onChanged: (Type? value) {
                selectedProductType.value = value!;
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 40,
                // width: 140,
              ),
            ),
          ),
        ));
  });
}

Widget plTypeForAccountDropDown(Rx<String?> selectedPLType, {double? width}) {
  return Obx(() {
    return SizedBox(
        width: width ?? 250,
        // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        height: 30,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<String>(
              isExpanded: true,
              decoration: commonFocusBorder,
              iconStyleData: IconStyleData(
                icon: Image.asset(
                  AppImages.arrowDown,
                  height: 20,
                  width: 20,
                  color: AppColors().fontColor,
                ),
              ),
              dropdownStyleData: const DropdownStyleData(maxHeight: 150),
              hint: Text(
                '',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().darkText,
                ),
              ),
              items: arrPLTypeforAccount
                  .map((String item) => DropdownItem<String>(
                        value: item,
                        height: 30,
                        child: Text(item, style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().grayColor)),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return arrPLTypeforAccount
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: CustomFonts.family1Medium,
                              color: AppColors().darkText,
                            ),
                          ),
                        ))
                    .toList();
              },
              value: selectedPLType.value,
              onChanged: (String? value) {
                selectedPLType.value = value!;
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 40,
                // width: 140,
              ),
            ),
          ),
        ));
  });
}

Widget sortCountDropDown(RxString selectedCount, {double? width}) {
  return Obx(() {
    return SizedBox(
        width: width ?? 250,
        // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),

        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<String>(
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
              dropdownStyleData: const DropdownStyleData(maxHeight: 150),
              hint: Text(
                '',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().darkText,
                ),
              ),
              items: arrSortCount
                  .map((String item) => DropdownItem<String>(
                        value: item,
                        height: 30,
                        child: Text(item, style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().grayColor)),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return arrSortCount
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: CustomFonts.family1Medium,
                              color: AppColors().darkText,
                            ),
                          ),
                        ))
                    .toList();
              },
              value: selectedCount.value.isEmpty ? null : selectedCount.value,
              onChanged: (String? value) {
                selectedCount.value = value!;
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 40,
                // width: 140,
              ),
            ),
          ),
        ));
  });
}

Widget userListDropDown(Rx<UserData> selectedUser, {double? width, String? rollType, Function? userController}) {
  return Container(
      // height: 40.h,
      width: width ?? 250,
      // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: 40,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.transparent),
      child: Container(
        width: 200,
        // height: 4.h,

        decoration: BoxDecoration(border: Border.all(color: Colors.transparent, width: 1), borderRadius: BorderRadius.circular(0)),
        child: Autocomplete<UserData>(
          displayStringForOption: (UserData option) => option.userName!,
          fieldViewBuilder: (BuildContext context, TextEditingController searchEditingController, FocusNode searchFocus, VoidCallback onFieldSubmitted) {
            if (userController != null) {
              userController(searchEditingController);
            }

            return CustomTextField(
              type: 'Search User',
              keyBoardType: TextInputType.text,
              isEnabled: true,
              isOptional: false,
              inValidMsg: "",
              placeHolderMsg: "Search User",
              emptyFieldMsg: "",
              fontStyle: TextStyle(
                fontSize: 10,
                fontFamily: CustomFonts.family1Medium,
                color: AppColors().darkText,
              ),
              controller: searchEditingController,
              focus: searchFocus,
              // focusBorderColor: AppColors().blueColor,
              isSecure: false,
              borderColor: AppColors().fontTextColor,
              keyboardButtonType: TextInputAction.search,
              maxLength: 64,
              focusBorderColor: AppColors().blueColor,
              isShowPrefix: false,
              isShowSufix: false,
              onTap: () {
                searchFocus.requestFocus();
              },
            );
          },
          optionsViewBuilder: (context, onSelected, options) => Align(
            alignment: Alignment.topLeft,
            child: Material(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(4.0)),
              ),
              child: Container(
                height: 150,
                width: (width ?? 250) - 3, // <-- Right here !
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  shrinkWrap: false,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = arrUserList.elementAt(index).userName!;
                    return InkWell(
                      onTap: () => onSelected(arrUserList.elementAt(index)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
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
          optionsMaxHeight: 150,
          optionsBuilder: (TextEditingValue textEditingValue) async {
            if (textEditingValue.text == '') {
              return const Iterable<UserData>.empty();
            }
            if (textEditingValue.text.length > 2) {
              return await getUserListByKeyWord(textEditingValue.text, rollType: rollType);
            } else {
              return const Iterable<UserData>.empty();
            }
          },
          onSelected: (UserData selection) {
            debugPrint('You just selected $selection');
            selectedUser.value = selection;
            // controller.addSymbolToTab(selection.symbolId!);
          },
        ),
      ));
}

Widget userListDropDownFinal(Rx<UserData> selectedUser, {double? width}) {
  return Obx(() {
    return SizedBox(
        width: width ?? 250,
        // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        height: 30,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<UserData>(
              isExpanded: true,
              decoration: commonFocusBorder,
              iconStyleData: IconStyleData(
                icon: Image.asset(
                  AppImages.arrowDown,
                  height: 20,
                  width: 20,
                  color: AppColors().fontColor,
                ),
              ),
              dropdownSearchData: DropdownSearchData(
                searchController: userEditingController,
                searchBarWidgetHeight: 50,
                searchBarWidget: SizedBox(
                  height: 30,
                  // padding: EdgeInsets.only(top: 2.w, right: 2.w, left: 2.w),
                  child: CustomTextField(
                    type: '',
                    keyBoardType: TextInputType.text,
                    isEnabled: true,
                    isOptional: false,
                    inValidMsg: "",
                    placeHolderMsg: "Search",
                    emptyFieldMsg: "",
                    controller: userEditingController,
                    focus: userEditingFocus,
                    isSecure: false,
                    borderColor: AppColors().grayLightLine,
                    keyboardButtonType: TextInputAction.done,
                    maxLength: 64,
                    isShowPrefix: false,
                    fontStyle: TextStyle(fontSize: 10, fontFamily: CustomFonts.family1Medium, color: AppColors().fontColor),
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
                  return item.value!.userName.toString().toLowerCase().startsWith(searchValue.toLowerCase());
                },
              ),
              hint: Text(
                'Select User',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: CustomFonts.family2Regular,
                  color: AppColors().darkText,
                ),
              ),
              items: arrUserList
                  .map((UserData item) => DropdownItem<UserData>(
                        value: item,
                        height: 30,
                        child: Text(item.userName ?? "", style: TextStyle(fontSize: 10, fontFamily: CustomFonts.family2Regular, color: AppColors().grayColor)),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return arrUserList
                    .map((UserData item) => DropdownMenuItem<UserData>(
                          value: item,
                          child: Text(
                            item.userName ?? "",
                            style: TextStyle(fontSize: 10, fontFamily: CustomFonts.family2Regular, color: AppColors().darkText, overflow: TextOverflow.ellipsis),
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
                height: 30,
              ),
              dropdownStyleData: const DropdownStyleData(maxHeight: 250),
            ),
          ),
        ));
  });
}

Widget timePeriodDropDown(RxString selectedPeriod, {double? width}) {
  return Obx(() {
    return SizedBox(
        width: width ?? 150,
        // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        height: 25,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<String>(
              isExpanded: true,
              decoration: commonFocusBorder,
              iconStyleData: IconStyleData(
                icon: Image.asset(
                  AppImages.arrowDown,
                  height: 20,
                  width: 20,
                  color: AppColors().fontColor,
                ),
              ),
              dropdownStyleData: const DropdownStyleData(maxHeight: 150),
              hint: Text(
                '',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().darkText,
                ),
              ),
              items: arrPeriodList
                  .map((String item) => DropdownItem<String>(
                        value: item,
                        height: 30,
                        child: Text(item, style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().grayColor)),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return arrPeriodList
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: CustomFonts.family1Medium,
                              color: AppColors().darkText,
                            ),
                          ),
                        ))
                    .toList();
              },
              value: selectedPeriod.value.isEmpty ? null : selectedPeriod.value,
              onChanged: (String? value) {
                selectedPeriod.value = value!;
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 40,
                // width: 140,
              ),
            ),
          ),
        ));
  });
}

Widget allScriptListDropDown(Rx<GlobalSymbolData> selectedScriptFromFilter, {List<GlobalSymbolData>? arrSymbol, double? width}) {
  return Obx(() {
    if (arrSymbol != null && arrSymbol.isNotEmpty) {
      return SizedBox(
          width: width ?? 250,
          height: 30,
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField2<GlobalSymbolData>(
                isExpanded: true,
                decoration: commonFocusBorder,
                iconStyleData: IconStyleData(
                  icon: Image.asset(
                    AppImages.arrowDown,
                    height: 20,
                    width: 20,
                    color: AppColors().fontColor,
                  ),
                ),
                dropdownSearchData: DropdownSearchData(
                  searchController: scriptEditingController,
                  searchBarWidgetHeight: 50,
                  searchBarWidget: Container(
                    height: 30,
                    // padding: EdgeInsets.only(top: 2.w, right: 2.w, left: 2.w),
                    child: CustomTextField(
                      type: '',
                      keyBoardType: TextInputType.text,
                      isEnabled: true,
                      isOptional: false,
                      inValidMsg: "",
                      placeHolderMsg: "Search",
                      emptyFieldMsg: "",
                      controller: scriptEditingController,
                      focus: scriptEditingFocus,
                      isSecure: false,
                      borderColor: AppColors().grayLightLine,
                      keyboardButtonType: TextInputAction.done,
                      maxLength: 64,
                      isShowPrefix: false,
                      fontStyle: TextStyle(fontSize: 10, fontFamily: CustomFonts.family1Medium, color: AppColors().fontColor),
                      suffixIcon: Container(
                        child: GestureDetector(
                          onTap: () {
                            scriptEditingController.clear();
                          },
                          child: Image.asset(
                            AppImages.crossIcon,
                            height: 15,
                            width: 15,
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
                  style: TextStyle(fontSize: 10, fontFamily: CustomFonts.family2Regular, color: AppColors().darkText, overflow: TextOverflow.ellipsis),
                ),
                items: arrSymbol
                    .map((GlobalSymbolData item) => DropdownItem<GlobalSymbolData>(
                          value: item,
                          height: 30,
                          child: Text(item.symbolTitle ?? "", style: TextStyle(fontSize: 10, fontFamily: CustomFonts.family2Regular, color: AppColors().darkText, overflow: TextOverflow.ellipsis)),
                        ))
                    .toList(),
                selectedItemBuilder: (context) {
                  return arrSymbol
                      .map((GlobalSymbolData item) => DropdownMenuItem<String>(
                            value: item.symbolTitle,
                            child: Text(
                              item.symbolTitle ?? "",
                              style: TextStyle(fontSize: 10, fontFamily: CustomFonts.family2Regular, color: AppColors().darkText, overflow: TextOverflow.ellipsis),
                            ),
                          ))
                      .toList();
                },
                value: selectedScriptFromFilter.value.exchangeId != null ? selectedScriptFromFilter.value : null,
                onChanged: (GlobalSymbolData? value) {
                  // // setState(() {
                  // controller.selectedScriptFromAll = value;
                  // controller.update();
                  // // });

                  selectedScriptFromFilter.value = value!;
                },
                buttonStyleData: const ButtonStyleData(padding: EdgeInsets.symmetric(horizontal: 0), height: 30),
              ),
            ),
          ));
    } else {
      return Container(
          width: width ?? 250,
          height: 30,
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField2<GlobalSymbolData>(
                isExpanded: true,
                decoration: commonFocusBorder,
                iconStyleData: IconStyleData(
                  icon: Image.asset(
                    AppImages.arrowDown,
                    height: 20,
                    width: 20,
                    color: AppColors().fontColor,
                  ),
                ),
                dropdownSearchData: DropdownSearchData(
                  searchController: scriptEditingController,
                  searchBarWidgetHeight: 50,
                  searchBarWidget: Container(
                    height: 30,
                    // padding: EdgeInsets.only(top: 2.w, right: 2.w, left: 2.w),
                    child: CustomTextField(
                      type: '',
                      keyBoardType: TextInputType.text,
                      isEnabled: true,
                      isOptional: false,
                      inValidMsg: "",
                      placeHolderMsg: "Search",
                      emptyFieldMsg: "",
                      controller: scriptEditingController,
                      focus: scriptEditingFocus,
                      isSecure: false,
                      borderColor: AppColors().grayLightLine,
                      keyboardButtonType: TextInputAction.done,
                      maxLength: 64,
                      isShowPrefix: false,
                      fontStyle: TextStyle(fontSize: 10, fontFamily: CustomFonts.family1Medium, color: AppColors().fontColor),
                      suffixIcon: Container(
                        child: GestureDetector(
                          onTap: () {
                            scriptEditingController.clear();
                          },
                          child: Image.asset(
                            AppImages.crossIcon,
                            height: 15,
                            width: 15,
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
                  style: TextStyle(fontSize: 10, fontFamily: CustomFonts.family2Regular, color: AppColors().darkText, overflow: TextOverflow.ellipsis),
                ),
                items: arrAllScript
                    .map((GlobalSymbolData item) => DropdownItem<GlobalSymbolData>(
                          value: item,
                          height: 30,
                          child: Text(item.symbolTitle ?? "", style: TextStyle(fontSize: 10, fontFamily: CustomFonts.family2Regular, color: AppColors().darkText, overflow: TextOverflow.ellipsis)),
                        ))
                    .toList(),
                selectedItemBuilder: (context) {
                  return arrAllScript
                      .map((GlobalSymbolData item) => DropdownMenuItem<String>(
                            value: item.symbolTitle,
                            child: Text(
                              item.symbolTitle ?? "",
                              style: TextStyle(fontSize: 10, fontFamily: CustomFonts.family2Regular, color: AppColors().darkText, overflow: TextOverflow.ellipsis),
                            ),
                          ))
                      .toList();
                },
                value: selectedScriptFromFilter.value.exchangeId != null ? selectedScriptFromFilter.value : null,
                onChanged: (GlobalSymbolData? value) {
                  // // setState(() {
                  // controller.selectedScriptFromAll = value;
                  // controller.update();
                  // // });

                  selectedScriptFromFilter.value = value!;
                },
                buttonStyleData: const ButtonStyleData(padding: EdgeInsets.symmetric(horizontal: 0), height: 30),
              ),
            ),
          ));
    }
  });
}

Widget groupListDropDown(Rx<groupListModelData> selectedGroup, {List<groupListModelData>? arrGroup, double? width}) {
  return Obx(() {
    return SizedBox(
        width: width ?? 250,
        height: 30,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<groupListModelData>(
              isExpanded: true,
              decoration: commonFocusBorder,
              iconStyleData: IconStyleData(
                icon: Image.asset(
                  AppImages.arrowDown,
                  height: 20,
                  width: 20,
                  color: AppColors().fontColor,
                ),
              ),
              dropdownStyleData: const DropdownStyleData(maxHeight: 250),
              hint: Text(
                '',
                style: TextStyle(fontSize: 10, fontFamily: CustomFonts.family2Regular, color: AppColors().darkText, overflow: TextOverflow.ellipsis),
              ),
              items: arrGroup!
                  .map((groupListModelData item) => DropdownItem<groupListModelData>(
                        value: item,
                        height: 30,
                        child: Text(item.name ?? "", style: TextStyle(fontSize: 10, fontFamily: CustomFonts.family2Regular, color: AppColors().darkText, overflow: TextOverflow.ellipsis)),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return arrGroup
                    .map((groupListModelData item) => DropdownMenuItem<groupListModelData>(
                          value: item,
                          child: Text(
                            item.name ?? "",
                            style: TextStyle(fontSize: 10, fontFamily: CustomFonts.family2Regular, color: AppColors().darkText, overflow: TextOverflow.ellipsis),
                          ),
                        ))
                    .toList();
              },
              value: selectedGroup.value.groupId != "" ? selectedGroup.value : null,
              onChanged: (groupListModelData? value) {
                // // setState(() {
                // controller.selectedScriptFromAll = value;
                // controller.update();
                // // });

                selectedGroup.value = value!;
              },
              buttonStyleData: const ButtonStyleData(padding: EdgeInsets.symmetric(horizontal: 0), height: 30),
            ),
          ),
        ));
  });
}

Widget exchangeTypeDropDown(Rx<ExchangeData> selectedExchange, {Function? onChange, double width = 210}) {
  return Container(
    width: width,
    height: 30,
    child: Obx(() {
      return Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField2<ExchangeData>(
            isExpanded: true,
            decoration: commonFocusBorder,
            iconStyleData: IconStyleData(
              icon: Image.asset(
                AppImages.arrowDown,
                height: 20,
                width: 20,
                color: AppColors().fontColor,
              ),
            ),
            dropdownSearchData: DropdownSearchData(
              searchController: exchangeEditingController,
              searchBarWidgetHeight: 50,
              searchBarWidget: Container(
                height: 30,
                // padding: EdgeInsets.only(top: 2.w, right: 2.w, left: 2.w),
                child: CustomTextField(
                  type: '',
                  keyBoardType: TextInputType.text,
                  isEnabled: true,
                  isOptional: false,
                  inValidMsg: "",
                  placeHolderMsg: "Search",
                  emptyFieldMsg: "",
                  controller: exchangeEditingController,
                  focus: exchangeEditingFocus,
                  isSecure: false,
                  borderColor: AppColors().grayLightLine,
                  keyboardButtonType: TextInputAction.done,
                  maxLength: 64,
                  isShowPrefix: false,
                  fontStyle: TextStyle(fontSize: 10, fontFamily: CustomFonts.family1Medium, color: AppColors().fontColor),
                  suffixIcon: Container(
                    child: GestureDetector(
                      onTap: () {
                        exchangeEditingController.clear();
                      },
                      child: Image.asset(
                        AppImages.crossIcon,
                        height: 15,
                        width: 15,
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
                fontSize: 10,
                fontFamily: CustomFonts.family2Regular,
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
                          fontSize: 10,
                          fontFamily: CustomFonts.family2Regular,
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
                            fontSize: 10,
                            fontFamily: CustomFonts.family2Regular,
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
              // width: 135,
            ),
          ),
        ),
      );
    }),
  );
}

Widget tradeStatusListDropDown(Rx<Type?> selectedTradeStatus, {double? width}) {
  return Obx(() {
    return Container(
        width: width ?? 250,
        height: 30,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<Type>(
              isExpanded: true,
              decoration: commonFocusBorder,
              iconStyleData: IconStyleData(
                icon: Image.asset(
                  AppImages.arrowDown,
                  height: 20,
                  width: 20,
                  color: AppColors().fontColor,
                ),
              ),
              dropdownStyleData: const DropdownStyleData(maxHeight: 150),
              hint: Text(
                '',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().darkText,
                ),
              ),
              items: arrTradeStatus
                  .map((Type item) => DropdownItem<Type>(
                        value: item,
                        height: 30,
                        child: Text(item.name ?? "", style: TextStyle(fontSize: 10, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return arrTradeStatus
                    .map((Type item) => DropdownMenuItem<Type>(
                          value: item,
                          child: Text(
                            item.name ?? "",
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: CustomFonts.family1Regular,
                              color: AppColors().darkText,
                            ),
                          ),
                        ))
                    .toList();
              },
              value: selectedTradeStatus.value?.name == null ? null : selectedTradeStatus.value,
              onChanged: (Type? value) {
                selectedTradeStatus.value = value!;
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                // height: 25,
                // width: 135,
              ),
            ),
          ),
        ));
  });
}

Widget tradeTypeListDropDown(Rx<Type?> selectedTradeStatus, {double? width}) {
  return Obx(() {
    return Container(
        width: width ?? 250,
        height: 30,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<Type>(
              isExpanded: true,
              decoration: commonFocusBorder,
              iconStyleData: IconStyleData(
                icon: Image.asset(
                  AppImages.arrowDown,
                  height: 20,
                  width: 20,
                  color: AppColors().fontColor,
                ),
              ),
              dropdownStyleData: const DropdownStyleData(maxHeight: 150),
              hint: Text(
                '',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().darkText,
                ),
              ),
              items: constantValues!.tradeTypeFilter!
                  .map((Type item) => DropdownItem<Type>(
                        value: item,
                        height: 30,
                        child: Text(item.name ?? "", style: TextStyle(fontSize: 10, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return constantValues!.tradeTypeFilter!
                    .map((Type item) => DropdownMenuItem<Type>(
                          value: item,
                          child: Text(
                            item.name ?? "",
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: CustomFonts.family1Regular,
                              color: AppColors().darkText,
                            ),
                          ),
                        ))
                    .toList();
              },
              value: selectedTradeStatus.value?.name == null ? null : selectedTradeStatus.value,
              onChanged: (Type? value) {
                selectedTradeStatus.value = value!;
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                // height: 25,
                // width: 135,
              ),
            ),
          ),
        ));
  });
}

Widget tradeAttributeDropDown(RxString selectedTradeStatus, {double? width}) {
  return Obx(() {
    return Container(
        width: width ?? 250,
        // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),

        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<String>(
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
              dropdownStyleData: const DropdownStyleData(maxHeight: 150),
              hint: Text(
                '',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().darkText,
                ),
              ),
              items: arrTradeAttribute
                  .map((String item) => DropdownItem<String>(
                        value: item,
                        height: 30,
                        child: Text(item, style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().grayColor)),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return arrTradeAttribute
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: CustomFonts.family1Medium,
                              color: AppColors().darkText,
                            ),
                          ),
                        ))
                    .toList();
              },
              value: selectedTradeStatus.value.isEmpty ? null : selectedTradeStatus.value,
              onChanged: (String? value) {
                selectedTradeStatus.value = value!;
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 40,
                // width: 140,
              ),
            ),
          ),
        ));
  });
}

Widget logTypeListDropDown(Rx<Type> selectedLogType, {double? width}) {
  return Obx(() {
    return Container(
        width: width ?? 250,
        // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        height: 30,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<Type>(
              isExpanded: true,
              decoration: commonFocusBorder,
              iconStyleData: IconStyleData(
                icon: Image.asset(
                  AppImages.arrowDown,
                  height: 20,
                  width: 20,
                  color: AppColors().fontColor,
                ),
              ),
              dropdownStyleData: const DropdownStyleData(maxHeight: 150),
              hint: Text(
                '',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().darkText,
                ),
              ),
              items: constantValues!.userLogFilter!
                  .map((Type item) => DropdownItem<Type>(
                        value: item,
                        height: 30,
                        child: Text(item.name!, style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().grayColor)),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return constantValues!.userLogFilter!
                    .map((Type item) => DropdownMenuItem<Type>(
                          value: item,
                          child: Text(
                            item.name!,
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: CustomFonts.family1Medium,
                              color: AppColors().darkText,
                            ),
                          ),
                        ))
                    .toList();
              },
              value: selectedLogType.value.id == null ? null : selectedLogType.value,
              onChanged: (Type? value) {
                selectedLogType.value = value!;
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 30,
              ),
            ),
          ),
        ));
  });
}

Widget timePeriodSelectionDropDown(Rx<String> selectedPeriod, {double? width, Function? onChange}) {
  arrCustomDateSelection.clear();
  arrCustomDateSelection.addAll(CommonCustomDateSelection().arrCustomDate);
  return Obx(() {
    return Container(
        width: width ?? 250,
        // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        height: 30,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<String>(
              isExpanded: true,
              decoration: commonFocusBorder,
              iconStyleData: IconStyleData(
                icon: Image.asset(
                  AppImages.arrowDown,
                  height: 20,
                  width: 20,
                  color: AppColors().fontColor,
                ),
              ),
              hint: Text(
                'Select Period',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: CustomFonts.family2Regular,
                  color: AppColors().darkText,
                ),
              ),
              items: arrCustomDateSelection
                  .map((String item) => DropdownItem<String>(
                        value: item,
                        height: 30,
                        child: Text(item, style: TextStyle(fontSize: 8, fontFamily: CustomFonts.family2Regular, color: AppColors().grayColor)),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return arrCustomDateSelection
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(fontSize: 8, fontFamily: CustomFonts.family2Regular, color: AppColors().darkText, overflow: TextOverflow.ellipsis),
                          ),
                        ))
                    .toList();
              },
              value: selectedPeriod.value.isEmpty ? null : selectedPeriod.value,
              onChanged: (String? value) {
                selectedPeriod.value = value!;
                if (onChange != null) {
                  onChange();
                }
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 40,
              ),
              dropdownStyleData: const DropdownStyleData(maxHeight: 250),
            ),
          ),
        ));
  });
}

Widget userTypeDropDown(Rx<userRoleListData> selectUserdropdownValue, {double? width, double? height, Function? onChange, FocusNode? focus}) {
  dropdownUserTypeKey = GlobalKey();

  return Obx(() {
    return Container(
        width: width ?? 250,
        height: height ?? 30,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<userRoleListData>(
              isExpanded: true,
              decoration: commonFocusBorder,
              iconStyleData: IconStyleData(
                icon: Image.asset(
                  AppImages.arrowDown,
                  height: 20,
                  width: 20,
                  color: AppColors().fontColor,
                ),
              ),
              dropdownStyleData: const DropdownStyleData(maxHeight: 150),
              hint: Text(
                '',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().darkText,
                ),
              ),
              items: arrUserTypeList
                  .map((userRoleListData item) => DropdownItem<userRoleListData>(
                        value: item,
                        height: 30,
                        child: Text(item.name ?? "", style: TextStyle(fontSize: 10, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return arrUserTypeList
                    .map((userRoleListData item) => DropdownMenuItem<userRoleListData>(
                          value: item,
                          child: Text(
                            item.name ?? "",
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: CustomFonts.family1Regular,
                              color: AppColors().darkText,
                            ),
                          ),
                        ))
                    .toList();
              },
              value: selectUserdropdownValue.value.roleId != null ? selectUserdropdownValue.value : null,
              onChanged: (userRoleListData? value) {
                selectUserdropdownValue.value = value!;
                if (onChange != null) {
                  onChange();
                }
              },
              buttonStyleData: const ButtonStyleData(padding: EdgeInsets.symmetric(horizontal: 0), height: 40),
            ),
          ),
        ));
  });
}

Widget brokerListDropDown(Rx<BrokerListModelData> selectedBrokerType, {double? width, double? height, Function? onChange}) {
  return Obx(() {
    return Container(
        width: width ?? 250,
        height: height ?? 30,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<BrokerListModelData>(
                focusNode: FocusNode(),
                padding: EdgeInsets.zero,
                key: new GlobalKey(),
                menuMaxHeight: 250,
                decoration: commonFocusBorder,
                value: selectedBrokerType.value,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: TextStyle(color: AppColors().darkText),
                onChanged: (BrokerListModelData? value) {
                  // This is called when the user selects an item.
                  selectedBrokerType.value = value!;
                  onChange!();
                },
                selectedItemBuilder: (context) {
                  return arrBrokerList.map<DropdownMenuItem<BrokerListModelData>>((BrokerListModelData item) {
                    return DropdownMenuItem<BrokerListModelData>(
                      value: item,
                      child: Text(item.name ?? ""),
                    );
                  }).toList();
                },
                isExpanded: true,
                items: arrBrokerList.map<DropdownMenuItem<BrokerListModelData>>((BrokerListModelData item) {
                  return DropdownMenuItem<BrokerListModelData>(
                    value: item,
                    child: Text(item.name ?? ""),
                  );
                }).toList(),
              ),
            ),
            // child: DropdownButtonFormField2<BrokerListModelData>(
            //   isExpanded: true,
            //   iconStyleData: IconStyleData(
            //     icon: Padding(
            //       padding: const EdgeInsets.only(right: 10),
            //       child: Image.asset(
            //         AppImages.arrowDown,
            //         height: 20,
            //         width: 20,
            //         color: AppColors().fontColor,
            //       ),
            //     ),
            //   ),
            //   dropdownStyleData: DropdownStyleData(maxHeight: 150),
            //   hint: Text(
            //     '',
            //     style: TextStyle(
            //       fontSize: 12,
            //       fontFamily: CustomFonts.family1Medium,
            //       color: AppColors().darkText,
            //     ),
            //   ),
            //   items: arrBrokerList
            //       .map((BrokerListModelData item) => DropdownMenuItem<BrokerListModelData>(
            //             value: item,
            //             child: Text(item.name ?? "",
            //                 style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
            //           ))
            //       .toList(),
            //   selectedItemBuilder: (context) {
            //     return arrBrokerList
            //         .map((BrokerListModelData item) => DropdownMenuItem<BrokerListModelData>(
            //               value: item,
            //               child: Text(
            //                 item.name ?? "",
            //                 style: TextStyle(
            //                   fontSize: 12,
            //                   fontFamily: CustomFonts.family1Regular,
            //                   color: AppColors().darkText,
            //                 ),
            //               ),
            //             ))
            //         .toList();
            //   },
            //   value: selectedBrokerType.value.userId != null ? selectedBrokerType.value : null,
            //   onChanged: (BrokerListModelData? value) {
            //     selectedBrokerType.value = value!;
            //     if (onChange != null) {
            //       onChange();
            //     }
            //   },
            //   buttonStyleData: const ButtonStyleData(
            //     padding: EdgeInsets.symmetric(horizontal: 0),
            //     height: 40,
            //     // width: 140,
            //   ),
            //   menuItemStyleData: const MenuItemStyleData(
            //     height: 40,
            //   ),
            // ),
          ),
        ));
  });
}

// List<AddMaster> selectStatuslist = [];
Widget statusListDropDown(Rx<AddMaster> selectedStatus, {double? width, double? height, Function? onChange}) {
  return Obx(() {
    return Container(
        width: width ?? 250,
        height: height ?? 30,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<AddMaster>(
              isExpanded: true,
              decoration: commonFocusBorder,
              iconStyleData: IconStyleData(
                icon: Image.asset(
                  AppImages.arrowDown,
                  height: 20,
                  width: 20,
                  color: AppColors().fontColor,
                ),
              ),
              dropdownStyleData: const DropdownStyleData(maxHeight: 150),
              hint: Text(
                '',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().darkText,
                ),
              ),
              items: arrStatuslist
                  .map((AddMaster item) => DropdownItem<AddMaster>(
                        value: item,
                        height: 30,
                        child: Text(item.name ?? "", style: TextStyle(fontSize: 10, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return arrStatuslist
                    .map((AddMaster item) => DropdownMenuItem<AddMaster>(
                          value: item,
                          child: Text(
                            item.name ?? "",
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: CustomFonts.family1Regular,
                              color: AppColors().darkText,
                            ),
                          ),
                        ))
                    .toList();
              },
              value: selectedStatus.value.id != null ? selectedStatus.value : null,
              onChanged: (AddMaster? value) {
                selectedStatus.value = value!;
                if (onChange != null) {
                  onChange();
                }
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 40,
              ),
            ),
          ),
        ));
  });
}

Widget rejectedstatusListDropDown(Rx<Type> selectedStatus, {double? width, double? height, Function? onChange}) {
  return Obx(() {
    return Container(
        width: width ?? 250,
        height: height ?? 30,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<Type>(
              isExpanded: true,
              decoration: commonFocusBorder,
              iconStyleData: IconStyleData(
                icon: Image.asset(
                  AppImages.arrowDown,
                  height: 20,
                  width: 20,
                  color: AppColors().fontColor,
                ),
              ),
              dropdownStyleData: const DropdownStyleData(maxHeight: 150),
              hint: Text(
                '',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().darkText,
                ),
              ),
              items: constantValues!.rejectedTradeStatusFilter!
                  .map((Type item) => DropdownItem<Type>(
                        value: item,
                        height: 30,
                        child: Text(item.name ?? "", style: TextStyle(fontSize: 10, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return constantValues!.rejectedTradeStatusFilter!
                    .map((Type item) => DropdownMenuItem<Type>(
                          value: item,
                          child: Text(
                            item.name ?? "",
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: CustomFonts.family1Regular,
                              color: AppColors().darkText,
                            ),
                          ),
                        ))
                    .toList();
              },
              value: selectedStatus.value.id != null ? selectedStatus.value : null,
              onChanged: (Type? value) {
                selectedStatus.value = value!;
                if (onChange != null) {
                  onChange();
                }
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 40,
              ),
            ),
          ),
        ));
  });
}

Widget orderTypeDropDown(Rx<Type> selectedOrderType, {double? width, double? height, Function? onChange}) {
  return Obx(() {
    return Container(
        width: width ?? 250,
        height: height ?? 30,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<Type>(
              isExpanded: true,
              decoration: commonFocusBorder,
              iconStyleData: IconStyleData(
                icon: Image.asset(
                  AppImages.arrowDown,
                  height: 20,
                  width: 20,
                  color: AppColors().fontColor,
                ),
              ),
              dropdownStyleData: const DropdownStyleData(maxHeight: 150),
              hint: Text(
                '',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().darkText,
                ),
              ),
              items: constantValues!.orderTypeFilter!
                  .map((Type item) => DropdownItem<Type>(
                        value: item,
                        height: 30,
                        child: Text(item.name ?? "", style: TextStyle(fontSize: 10, fontFamily: CustomFonts.family1Regular, color: AppColors().darkText)),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return constantValues!.orderTypeFilter!
                    .map((Type item) => DropdownMenuItem<Type>(
                          value: item,
                          child: Text(
                            item.name ?? "",
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: CustomFonts.family1Regular,
                              color: AppColors().darkText,
                            ),
                          ),
                        ))
                    .toList();
              },
              value: selectedOrderType.value.id != null ? selectedOrderType.value : null,
              onChanged: (Type? value) {
                selectedOrderType.value = value!;
                if (onChange != null) {
                  onChange();
                }
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 40,
                // width: 135,
              ),
            ),
          ),
        ));
  });
}

showCalenderPopUp(DateTime fromDate, Function onDateSelection, {DateTime? maxDate}) {
  showDialog<String>(
      context: Get.context!,
      // barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (BuildContext context) => FloatingDialog(
            // titlePadding: EdgeInsets.zero,
            // backgroundColor: AppColors().bgColor,
            // surfaceTintColor: AppColors().bgColor,

            // contentPadding: EdgeInsets.zero,
            // insetPadding: EdgeInsets.symmetric(
            //   horizontal: 20.w,
            //   vertical: 32.h,
            // ),
            enableDragAnimation: false,
            child: Container(
              // width: 30.w,
              // height: 28.h,
              width: 450,
              height: 450,
              decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),

              child: CalendarCarousel<Event>(
                onDayPressed: (DateTime date, List<Event> events) {
                  onDateSelection(date);
                  Get.back();
                },
                maxSelectedDate: maxDate != null ? maxDate : DateTime.now(),
                weekendTextStyle: TextStyle(
                  color: Colors.red,
                ),
                thisMonthDayBorderColor: Colors.transparent,
                weekFormat: false,

                height: 420.0,
                selectedDateTime: fromDate,
                daysHaveCircularBorder: false,

                /// null for not rendering any border, true for circular border, false for rectangular border
              ),
            ),
          ));
}

Future<void> selectFromDate(RxString fromDate) async {
  final DateTime? picked = await showDatePicker(
    context: Get.context!,
    initialDate: DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime.now(),
    helpText: 'Select From Date',
    cancelText: 'Cancel',
    confirmText: 'Done',

    // locale: Locale('en', 'US'),
  );

  if (picked != null) {
    // Format the DateTime to display only the date portion
    String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
    //print(formattedDate);

    fromDate.value = formattedDate;

    // _selectToDate(context);
  }
}

Future<void> selectToDate(RxString endDate) async {
  final DateTime? picked = await showDatePicker(
    context: Get.context!,
    initialDate: DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime.now(),
    helpText: 'Select To Date',
    cancelText: 'Cancel',
    confirmText: 'Done',
    // locale: Locale('en', 'US'),
  );

  if (picked != null) {
    // Format the DateTime to display only the date portion
    String formattedDate = DateFormat('yyyy-MM-dd').format(picked);
    //print(formattedDate);
    endDate.value = formattedDate;

    // _selectToDate(context);
  }
}

getExchangeList() async {
  var response = await service.getExchangeListCall();
  if (response != null) {
    if (response.statusCode == 200) {
      arrExchange = response.exchangeData ?? [];
      arrExchange.insert(0, ExchangeData(exchangeId: "", name: "ALL"));
    }
  }
}

getScriptList({String exchangeId = "", List<GlobalSymbolData>? arrSymbol, isFromOrder = false}) async {
  var response = await service.allSymbolListCall(1, "", exchangeId);
  if (arrSymbol != null) {
    arrSymbol.clear();

    arrSymbol.addAll(response!.data ?? []);
    if (isFromOrder == false) {
      arrSymbol.insert(0, GlobalSymbolData(symbolId: "", symbolName: "ALL", symbolTitle: "ALL"));
    }
  } else {
    arrAllScript = response!.data ?? [];
  }
}

getUserList() async {
  var response = await service.getMyUserListCall();
  arrUserList = response?.data ?? [];
  arrUserList.insert(
      0,
      UserData(
        userId: "",
        userName: "ALL",
      ));
}

getUserListByKeyWord(String keyWord, {String? rollType}) async {
  var response = await service.getMyUserListByKeywordCall(text: keyWord, roleId: rollType ?? "");
  if (response != null) {
    if (response.statusCode == 200) {
      arrUserList = response.data ?? [];
      return arrUserList;
    } else {
      return [];
    }
  } else {
    return [];
  }
}

callForBrokerList() async {
  var response = await service.brokerListCall();
  if (response != null) {
    if (response.statusCode == 200) {
      arrBrokerList = response.data!;
      arrBrokerList.insert(0, BrokerListModelData(name: "Select Broker"));
      //print("Brocker List");
    } else {
      showErrorToast(response.meta!.message ?? "");
    }
  } else {
    showErrorToast(AppString.generalError);
  }
}

callForRoleList() async {
  var response = await service.userRoleListCall();
  if (response != null) {
    if (response.statusCode == 200) {
      arrUserTypeList = response.data!;
    }
  }
}
