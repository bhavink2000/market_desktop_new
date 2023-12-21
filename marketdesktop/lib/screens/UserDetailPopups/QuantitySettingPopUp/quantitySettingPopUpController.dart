import 'package:get/get.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/quantitySettingListMmodelClass.dart';
import '../../../constant/index.dart';
import '../../../modelClass/allSymbolListModelClass.dart';
import '../../BaseController/baseController.dart';
import '../userDetailsPopUpController.dart';

class QuantitySettingPopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  bool isFilterOpen = true;
  TextEditingController lotMaxController = TextEditingController();
  FocusNode lotMaxFocus = FocusNode();
  TextEditingController qtyMaxController = TextEditingController();
  FocusNode qtyMaxFocus = FocusNode();
  TextEditingController brkQtyController = TextEditingController();
  FocusNode brkQtyFocus = FocusNode();
  TextEditingController brkLotController = TextEditingController();
  FocusNode brkLotFocus = FocusNode();
  List<QuantitySettingData> arrQuantitySetting = [];
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  String selectedUserId = "";
  String selectedGroupId = "";
  bool isAllSelected = false;
  bool isApiCallRunning = false;
  bool isFilterApiCallRunning = false;
  bool isClearApiCallRunning = false;
  List<GlobalSymbolData> arrSearchedScript = [];
  List<String> arrTempSelected = [];
  TextEditingController textEditingController = TextEditingController();
  FocusNode applyFocus = FocusNode();
  FocusNode updateFocus = FocusNode();
  FocusNode clearFocus = FocusNode();

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
  }
  //*********************************************************************** */
  // Field Validation
  //*********************************************************************** */

  String validateField() {
    var msg = "";

    if (lotMaxController.text.trim().isEmpty) {
      msg = AppString.emptyLotMax;
    }
    // else if (qtyMaxController.text.trim().isEmpty) {
    //   msg = AppString.emptyqtyMax;
    // } else if (brkQtyController.text.trim().isEmpty) {
    //   msg = AppString.emptybrkQty;
    // }
    else if (brkLotController.text.trim().isEmpty) {
      msg = AppString.emptybrkLot;
    } else if (arrTempSelected.isEmpty) {
      msg = AppString.emptyScriptSelection;
    }
    return msg;
  }

  Future<List<GlobalSymbolData>> getSymbolListByKeyword(String text) async {
    arrSearchedScript.clear();
    update();
    if (text != "") {
      var response = await service.allSymbolListCall(1, text, "");
      arrSearchedScript = response!.data ?? [];

      return arrSearchedScript;
    } else {
      return [];
    }
  }

  quantitySettingList({bool isFromClear = false}) async {
    if (isFromClear) {
      isClearApiCallRunning = true;
    } else {
      isFilterApiCallRunning = true;
    }
    arrQuantitySetting.clear();

    update();
    var response = await service.quantitySettingListCall(userId: selectedUserId, page: 1, groupId: selectedGroupId, text: textEditingController.text.trim());
    isFilterApiCallRunning = false;
    isClearApiCallRunning = false;
    arrQuantitySetting = response!.data ?? [];
    Get.find<UserDetailsPopUpController>().selectedMenuName = "Quantity Settings";
    update();
  }

  updateQuantity() async {
    for (var element in arrQuantitySetting) {
      if (element.isSelected) {
        arrTempSelected.add(element.userWiseGroupDataAssociationId!);
      }
    }
    var msg = validateField();
    if (msg.isEmpty) {
      isApiCallRunning = true;
      update();

      var response = await service.updateQuantityCall(arrIDs: arrTempSelected, quantityMax: qtyMaxController.text.trim(), userId: selectedUserId, lotMax: lotMaxController.text.trim(), breakQuantity: brkQtyController.text.trim(), breakUpLot: brkLotController.text.trim());
      isApiCallRunning = false;
      update();
      if (response != null) {
        if (response.statusCode == 200) {
          showSuccessToast(response.meta!.message ?? "");
          qtyMaxController.clear();
          lotMaxController.clear();
          brkLotController.clear();
          brkQtyController.clear();
          isAllSelected = false;
          arrTempSelected.clear();
          quantitySettingList();
        } else {
          showErrorToast(response.message ?? "");
        }
      }
    } else {
      showWarningToast(msg);
    }
  }
}
