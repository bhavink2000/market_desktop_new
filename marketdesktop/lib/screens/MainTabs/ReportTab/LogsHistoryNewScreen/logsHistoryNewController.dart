import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';

import '../../../../constant/index.dart';

class LogsHistoryNewController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;

  List<String> arrLogFor = ["Self", "Include Child User"];
  List<String> arrLogType = ["Bet", "Close Only", "Margin Square off", "User Status", "% Cash Margin", "Fresh Stop Loss", "Group Qty Settings"];
  Rx<UserData> selectedUser = UserData().obs;
  RxString selectedLogType = "Bet".obs;
  RxString selectedLogFor = "".obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  List<ExchangeData> arrExchange = [];
  List<GlobalSymbolData> arrAllScript = [];
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
  }

  Widget logTypeListDropDown() {
    return Obx(() {
      return Container(
          width: 200,
          // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1), color: AppColors().whiteColor),
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
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
                hint: Text(
                  '',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: CustomFonts.family1Medium,
                    color: AppColors().darkText,
                  ),
                ),
                items: arrLogType
                    .map((String item) => DropdownItem<String>(
                          value: item,
                          height: 30,
                          child: Text(item, style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().grayColor)),
                        ))
                    .toList(),
                selectedItemBuilder: (context) {
                  return arrLogType
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
                value: selectedLogType.value.isEmpty ? null : selectedLogType.value,
                onChanged: (String? value) {
                  selectedLogType.value = value!;
                  update();
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

  Widget logForListDropDown() {
    return Obx(() {
      return Container(
          width: 200,
          // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1), color: AppColors().whiteColor),
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
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
                hint: Text(
                  '',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: CustomFonts.family1Medium,
                    color: AppColors().darkText,
                  ),
                ),
                items: arrLogFor
                    .map((String item) => DropdownItem<String>(
                          value: item,
                          height: 30,
                          child: Text(item, style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().grayColor)),
                        ))
                    .toList(),
                selectedItemBuilder: (context) {
                  return arrLogFor
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
                value: selectedLogFor.value.isEmpty ? null : selectedLogFor.value,
                onChanged: (String? value) {
                  selectedLogFor.value = value!;
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
}
