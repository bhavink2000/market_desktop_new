import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/groupListModelClass.dart';
import 'package:marketdesktop/constant/index.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/brokerListModelClass.dart';
import 'package:marketdesktop/modelClass/constantModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeAllowModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/userRoleListModelClass.dart';
import 'package:marketdesktop/screens/MainTabs/UserTab/UserListScreen/userListController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/userDetailsPopUpController.dart';
import 'package:number_to_indian_words/number_to_indian_words.dart';

import '../../../BaseController/baseController.dart';

class CreateUserControllerBinding implements Bindings {
  @override
  void dependencies() {
    // Get.put(() => SignInController());
    Get.put(CreateUserController());
  }
}

class CreateUserController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  ScrollController listcontroller = ScrollController();
  Rx<userRoleListData> selectedUserType = userRoleListData().obs;
  Rx<BrokerListModelData> selectedBrokerType = BrokerListModelData().obs;
  Rx<AddMaster> selectedLeverage = AddMaster().obs;
  RxString selectedGroup = "".obs;
  RxBool isCutOffHasValue = false.obs;
  TextEditingController nameController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  TextEditingController userNameController = TextEditingController();
  FocusNode userNameFocus = FocusNode();
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordFocus = FocusNode();
  TextEditingController retypePasswordController = TextEditingController();
  FocusNode retypePasswordFocus = FocusNode();
  TextEditingController mobileNumberController = TextEditingController();
  FocusNode mobileNumberFocus = FocusNode();
  TextEditingController cutoffController = TextEditingController();
  FocusNode cutoffFocus = FocusNode();
  TextEditingController creditController = TextEditingController();

  FocusNode creditFocus = FocusNode();
  TextEditingController remarkController = TextEditingController();
  FocusNode remarkFocus = FocusNode();
  TextEditingController brokerageSharingController = TextEditingController();
  FocusNode brokerageSharingFocus = FocusNode();
  TextEditingController profitandLossController = TextEditingController();
  FocusNode profitandLossFocus = FocusNode();
  TextEditingController brkSharingMasterController = TextEditingController();
  FocusNode brkSharingMasterFocus = FocusNode();
  FocusNode leverageFocus = FocusNode(descendantsAreFocusable: true, descendantsAreTraversable: true);
  FocusNode userTypeFocus = FocusNode(descendantsAreFocusable: true, descendantsAreTraversable: true);
  FocusNode ChangePasswordOnFirstLoginFocus = FocusNode(descendantsAreFocusable: true, descendantsAreTraversable: true);

  List<String> arrGroupList = ["Client", "Master", "Admin", "Broker"];
  List<ExchangeData> arrExchange = [];
  List<groupListModelData> arrMastGroupListforOthers = [];
  List<groupListModelData> arrMastGroupListforNSE = [];
  List<groupListModelData> arrMastGroupListforMCX = [];
  List<ExchangeAllow> arrSelectedExchangeList = [];
  List<String> arrHighLowBetweenTradeSelectedList = [];
  List<String> arrSelectedGroupListIDforOthers = [];
  List<String> arrSelectedGroupListIDforNSE = [];
  List<String> arrSelectedGroupListIDforMCX = [];
  List<String> arrSelectedDropDownValueClient = [];
  bool isNSEOn = false;
  bool isAutoSquareOff = false;
  bool isModifyOrder = false;
  bool isCloseOnly = false;
  bool isSymbolWiseSL = false;
  bool isIntraday = false;
  bool? isCmpOrder;
  bool? isAdminManualOrder;
  bool? isDeleteTrade;
  bool? isExecutePendingOrder;
  bool isChangePasswordOnFirstLogin = false;
  RxBool isSelectedallExchangeinMaster = false.obs;
  bool isEyeOpenPassword = true;
  bool isEyeOpenRetypePassword = true;
  RxBool isLoadingSave = false.obs;
  GlobalKey singleDropdownKey = GlobalKey();
  final FocusNode focusNode = FocusNode();
  GlobalKey? dropdownLeveargeKey;
  final debouncer = Debouncer(milliseconds: 200);
  FocusNode saveFocus = FocusNode();
  FocusNode cancelFocus = FocusNode();
  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
    selectedLeverage.value = arrLeverageList.first;
    profitandLossController.text = userData!.profitAndLossSharingDownLine!.toString();
    brkSharingMasterController.text = userData!.brkSharingDownLine!.toString();
    dropdownLeveargeKey = GlobalKey();
    if (userData!.highLowSLLimitPercentage == true) {
      isSymbolWiseSL = true;
    }
    await callForRoleList();

    selectedUserType.value = arrUserTypeList.first;
    update();
    await getExchangeList();
    await callForBrokerList();

    profitandLossController.addListener(() {
      update();
    });
    brkSharingMasterController.addListener(() {
      update();
    });
    brokerageSharingController.addListener(() {
      update();
    });
    leverageFocus.addListener(() {
      update();
    });
  }

  //*********************************************************************** */
  // Field Validation
  //*********************************************************************** */
  String validateFieldForUser() {
    var msg = "";

    if (selectedUserType.value.name == null) {
      msg = AppString.emptyUserType;
    } else if (nameController.text.trim().isEmpty) {
      msg = AppString.emptyName;
    } else if (userNameController.text.trim().isEmpty) {
      msg = AppString.emptyUserName;
    } else if (userNameController.text.length < 4) {
      msg = AppString.rangeUserName;
    } else if (passwordController.text.trim().isEmpty) {
      msg = AppString.emptyPassword;
    } else if (passwordController.text.trim().length < 6) {
      msg = AppString.wrongPassword;
    } else if (retypePasswordController.text.trim().isEmpty) {
      msg = AppString.emptyConfirmPassword;
    } else if (retypePasswordController.text.length < 6) {
      msg = AppString.wrongRetypePassword;
    } else if (passwordController.text.trim() != retypePasswordController.text.trim()) {
      msg = AppString.passwordNotMatch;
    }
    // else if (mobileNumberController.text.trim().isEmpty) {
    //   msg = AppString.emptyMobileNumber;
    // } else if (mobileNumberController.text.trim().length < 9) {
    //   msg = AppString.mobileNumberLength;
    // }
    // else if (cutoffController.text.trim().isEmpty) {
    //   msg = AppString.emptyCutOff;
    // }
    else if ((cutoffController.text.isNotEmpty && int.parse(cutoffController.text) < 60) || (cutoffController.text.isNotEmpty && int.parse(cutoffController.text) > 100)) {
      msg = AppString.cutOffValid;
    } else if (creditController.text.trim().isEmpty) {
      msg = AppString.emptyCredit;
    } else if (arrSelectedExchangeList.isEmpty) {
      msg = AppString.emptyExchangeGroup;
    } else if (selectedBrokerType.value.addMaster != null) {
      if (brokerageSharingController.text.trim().isEmpty) {
        msg = AppString.emptyBrokerageSharing;
      } else if (int.parse(brokerageSharingController.text) > 100) {
        msg = AppString.rangeBrokerageSharing;
      }
    }
    return msg;
  }

  String validateFieldForBrocker() {
    var msg = "";

    if (selectedUserType.value.name == null) {
      msg = AppString.emptyUserType;
    } else if (nameController.text.trim().isEmpty) {
      msg = AppString.emptyName;
    } else if (userNameController.text.trim().isEmpty) {
      msg = AppString.emptyUserName;
    } else if (userNameController.text.length < 4) {
      msg = AppString.rangeUserName;
    } else if (passwordController.text.trim().isEmpty) {
      msg = AppString.emptyPassword;
    } else if (passwordController.text.trim().length < 6) {
      msg = AppString.wrongPassword;
    }
    return msg;
  }

  String validateFieldForAdmin() {
    var msg = "";

    if (selectedUserType.value.name == null) {
      msg = AppString.emptyUserType;
    } else if (nameController.text.trim().isEmpty) {
      msg = AppString.emptyName;
    } else if (userNameController.text.trim().isEmpty) {
      msg = AppString.emptyUserName;
    } else if (userNameController.text.length < 4) {
      msg = AppString.rangeUserName;
    } else if (passwordController.text.trim().isEmpty) {
      msg = AppString.emptyPassword;
    } else if (passwordController.text.length < 6) {
      msg = AppString.wrongPassword;
    } else if (retypePasswordController.text.trim().isEmpty) {
      msg = AppString.emptyConfirmPassword;
    } else if (retypePasswordController.text.length < 6) {
      msg = AppString.wrongRetypePassword;
    } else if (passwordController.text.trim() != retypePasswordController.text.trim()) {
      msg = AppString.passwordNotMatch;
    } else if (mobileNumberController.text.trim().isEmpty) {
      msg = AppString.emptyMobileNumber;
    } else if (mobileNumberController.text.trim().length < 9) {
      msg = AppString.mobileNumberLength;
    }
    return msg;
  }

  String validateFieldForMaster() {
    var msg = "";

    if (selectedUserType.value.name == null) {
      msg = AppString.emptyUserType;
    } else if (nameController.text.trim().isEmpty) {
      msg = AppString.emptyName;
    } else if (userNameController.text.trim().isEmpty) {
      msg = AppString.emptyUserName;
    } else if (userNameController.text.length < 4) {
      msg = AppString.rangeUserName;
    } else if (passwordController.text.trim().isEmpty) {
      msg = AppString.emptyPassword;
    } else if (passwordController.text.length < 6) {
      msg = AppString.wrongPassword;
    } else if (retypePasswordController.text.trim().isEmpty) {
      msg = AppString.emptyConfirmPassword;
    } else if (retypePasswordController.text.length < 6) {
      msg = AppString.wrongRetypePassword;
    } else if (passwordController.text.trim() != retypePasswordController.text.trim()) {
      msg = AppString.passwordNotMatch;
    } else if (creditController.text.trim().isEmpty) {
      msg = AppString.emptyCredit;
    } else if (arrSelectedExchangeList.isEmpty) {
      msg = AppString.emptyExchangeGroup;
    } else if (profitandLossController.text.trim().isEmpty) {
      msg = AppString.emptyProfitLossSharing;
    } else if (int.parse(profitandLossController.text) > userData!.profitAndLossSharingDownLine!) {
      msg = "Profit and Loss should be between 0 to ${userData!.profitAndLossSharingDownLine!}";
    } else if (brkSharingMasterController.text.trim().isEmpty) {
      msg = AppString.emptyBrokerageSharing;
    } else if (int.parse(brkSharingMasterController.text) > userData!.brkSharingDownLine!) {
      msg = "Brokerage sharing should be between 0 to ${userData!.brkSharingDownLine!}";
    }
    return msg;
  }

  //*********************************************************************** */
  // Api Calls
  //*********************************************************************** */
  getExchangeList() async {
    var response = await service.getExchangeListUserWiseCall(userId: userData!.userId!);
    if (response != null) {
      if (response.statusCode == 200) {
        arrExchange = response.exchangeData ?? [];
        for (var i = 0; i < arrExchange.length; i++) {
          arrExchange[i].arrGroupList = await callforGroupList(arrExchange[i].exchangeId);
        }
      }
    }
  }

  Future<List<groupListModelData>> callforGroupList(
    String? ExchangeId,
  ) async {
    update();
    var response = await service.getGroupListCall(ExchangeId);
    if (response != null) {
      if (response.statusCode == 200) {
        return response.data!;
      } else {
        showErrorToast(response.meta!.message ?? "");
        return [];
      }
    } else {
      showErrorToast(AppString.generalError);
      return [];
    }
  }

  callForCreateBrocker() async {
    var msg = validateFieldForBrocker();
    if (msg.isEmpty) {
      nameFocus.unfocus();
      userNameFocus.unfocus();
      passwordFocus.unfocus();
      isLoadingSave.value = true;
      update();
      var response = await service.createBrokerCall(
        name: nameController.text.trim(),
        userName: userNameController.text.trim(),
        password: passwordController.text.trim(),
        phone: mobileNumberController.text.trim(),
        changePassword: isChangePasswordOnFirstLogin,
        role: selectedUserType.value.roleId,
      );
      isLoadingSave.value = false;
      if (response != null) {
        if (response.statusCode == 200) {
          Get.back();
          showSuccessToast(response.meta?.message ?? "");
          nameController.text = "";
          userNameController.text = "";
          passwordController.text = "";
          retypePasswordController.text = "";
          mobileNumberController.text = "";
          cutoffController.text = "";
          creditController.text = "";
          remarkController.text = "";
          selectedLeverage.value = arrLeverageList.first;
          profitandLossController.text = "";
          brokerageSharingController.text = "";
          brkSharingMasterController.text = "";
          isAutoSquareOff = false;
          isModifyOrder = false;
          isCloseOnly = false;
          isIntraday = false;
          isChangePasswordOnFirstLogin = false;
          selectedBrokerType = BrokerListModelData().obs;
          for (var i = 0; i < arrExchange.length; i++) {
            if (arrExchange[i].isSelected == true) {
              arrExchange[i].isSelected = false;
            }
            if (arrExchange[i].isTurnOverSelected == true) {
              arrExchange[i].isTurnOverSelected = false;
            }
            if (arrExchange[i].isSymbolSelected == true) {
              arrExchange[i].isSymbolSelected = false;
            }
            if (arrExchange[i].isHighLowTradeSelected == true) {
              arrExchange[i].isHighLowTradeSelected = false;
            }
            if (arrExchange[i].isDropDownValueSelected.value != "") {
              arrExchange[i].isDropDownValueSelected.value = groupListModelData();
            }
            if (arrExchange[i].selectedItems != []) {
              arrExchange[i].selectedItems.clear();
            }
          }
          arrSelectedGroupListIDforOthers.clear();
          arrSelectedGroupListIDforNSE.clear();
          arrSelectedGroupListIDforMCX.clear();
          arrSelectedDropDownValueClient.clear();
          arrSelectedExchangeList.clear();
          arrHighLowBetweenTradeSelectedList.clear();
          isCmpOrder = null;
          isAdminManualOrder = null;
          isDeleteTrade = null;
          isExecutePendingOrder = null;
          bool isUserlistVcAvailable = Get.isRegistered<UserListController>();
          if (isUserlistVcAvailable) {
            Get.find<UserListController>().getUserList();
          }
          update();
        } else {
          showErrorToast(response.message ?? "");
          isLoadingSave.value = false;
          arrSelectedExchangeList.clear();
          arrHighLowBetweenTradeSelectedList.clear();
          arrSelectedGroupListIDforOthers.clear();
          arrSelectedGroupListIDforNSE.clear();
          arrSelectedGroupListIDforMCX.clear();
          arrSelectedDropDownValueClient.clear();
          update();
        }
      } else {
        showErrorToast(AppString.generalError);
        isLoadingSave.value = false;
        update();
      }
    } else {
      showWarningToast(msg);
    }
  }

  callForCreateAdmin() async {
    var msg = validateFieldForAdmin();
    if (msg.isEmpty) {
      nameFocus.unfocus();
      userNameFocus.unfocus();
      passwordFocus.unfocus();
      retypePasswordFocus.unfocus();
      mobileNumberFocus.unfocus();
      isLoadingSave.value = true;
      update();
      var response = await service.createAdminCall(
        name: nameController.text.trim(),
        userName: userNameController.text.trim(),
        password: passwordController.text.trim(),
        phone: mobileNumberController.text.trim(),
        executePendingOrder: isExecutePendingOrder == null || isExecutePendingOrder == false ? 0 : 1,
        deleteTrade: isDeleteTrade == null || isDeleteTrade == false ? 0 : 1,
        manualOrder: isAdminManualOrder == null || isAdminManualOrder == false ? 0 : 1,
        cmpOrder: isCmpOrder == null || isCmpOrder == false ? 0 : 1,
        role: selectedUserType.value.roleId,
      );
      isLoadingSave.value = false;
      if (response != null) {
        if (response.statusCode == 200) {
          Get.back();
          showSuccessToast(response.meta?.message ?? "");
          nameController.text = "";
          userNameController.text = "";
          passwordController.text = "";
          retypePasswordController.text = "";
          mobileNumberController.text = "";
          cutoffController.text = "";
          creditController.text = "";
          remarkController.text = "";
          selectedLeverage.value = arrLeverageList.first;
          profitandLossController.text = "";
          brokerageSharingController.text = "";
          brkSharingMasterController.text = "";
          isAutoSquareOff = false;
          isModifyOrder = false;
          isCloseOnly = false;
          isIntraday = false;
          isChangePasswordOnFirstLogin = false;
          selectedBrokerType = BrokerListModelData().obs;
          bool isUserlistVcAvailable = Get.isRegistered<UserListController>();
          if (isUserlistVcAvailable) {
            Get.find<UserListController>().getUserList();
          }
          for (var i = 0; i < arrExchange.length; i++) {
            if (arrExchange[i].isSelected == true) {
              arrExchange[i].isSelected = false;
            }
            if (arrExchange[i].isTurnOverSelected == true) {
              arrExchange[i].isTurnOverSelected = false;
            }
            if (arrExchange[i].isSymbolSelected == true) {
              arrExchange[i].isSymbolSelected = false;
            }
            if (arrExchange[i].isHighLowTradeSelected == true) {
              arrExchange[i].isHighLowTradeSelected = false;
            }
            if (arrExchange[i].isDropDownValueSelected.value != "") {
              arrExchange[i].isDropDownValueSelected.value = groupListModelData();
            }
            if (arrExchange[i].selectedItems != []) {
              arrExchange[i].selectedItems.clear();
            }
          }
          arrSelectedGroupListIDforOthers.clear();
          arrSelectedGroupListIDforNSE.clear();
          arrSelectedGroupListIDforMCX.clear();
          arrSelectedDropDownValueClient.clear();
          arrSelectedExchangeList.clear();
          arrHighLowBetweenTradeSelectedList.clear();
          isCmpOrder = null;
          isAdminManualOrder = null;
          isDeleteTrade = null;
          isExecutePendingOrder = null;
          update();
        } else {
          showErrorToast(response.message ?? "");
          isLoadingSave.value = false;
          arrSelectedExchangeList.clear();
          arrHighLowBetweenTradeSelectedList.clear();
          arrSelectedGroupListIDforOthers.clear();
          arrSelectedGroupListIDforNSE.clear();
          arrSelectedGroupListIDforMCX.clear();
          arrSelectedDropDownValueClient.clear();
          update();
        }
      } else {
        showErrorToast(AppString.generalError);
        isLoadingSave.value = false;
        update();
      }
    } else {
      showWarningToast(msg);
    }
  }

  callForCreateUser() async {
    var msg = validateFieldForUser();
    if (msg.isNotEmpty) {
      for (var i = 0; i < arrExchange.length; i++) {
        arrExchange[i].selectedItemsID.clear();
        arrExchange[i].isDropDownValueSelectedID.value = "";
      }
    }
    if (msg.isEmpty) {
      nameFocus.unfocus();
      userNameFocus.unfocus();
      passwordFocus.unfocus();
      retypePasswordFocus.unfocus();
      mobileNumberFocus.unfocus();
      cutoffFocus.unfocus();
      creditFocus.unfocus();
      remarkFocus.unfocus();
      brokerageSharingFocus.unfocus();
      isLoadingSave.value = true;
      update();
      var response = await service.createUserCall(
          name: nameController.text.trim(),
          userName: userNameController.text.trim(),
          password: passwordController.text.trim(),
          phone: mobileNumberController.text.trim(),
          role: selectedUserType.value.roleId,
          credit: int.parse(creditController.text.trim()),
          cutOff: cutoffController.text.trim().isEmpty ? 0 : int.parse(cutoffController.text.trim()),
          leverage: selectedLeverage.value.id,
          remark: remarkController.text.trim(),
          exchangeAllow: arrSelectedExchangeList,
          highLowBetweenTradeLimits: arrHighLowBetweenTradeSelectedList,
          autoSquareOff: isAutoSquareOff ? 1 : 0,
          modifyOrder: isModifyOrder ? 1 : 0,
          closeOnly: isCloseOnly,
          intraday: isIntraday ? 1 : 0,
          symbolWiseSL: isSymbolWiseSL,
          brokerId: selectedBrokerType.value.userId ?? "",
          brkSharingDownLine: int.tryParse(brokerageSharingController.text) ?? 0,
          changePassword: isChangePasswordOnFirstLogin);
      isLoadingSave.value = false;
      if (response != null) {
        if (response.statusCode == 200) {
          Get.back();
          showSuccessToast(response.meta?.message ?? "");

          showUserDetailsPopUp(userId: response.data!.userId!, userName: response.data!.userName!);
          Get.find<UserDetailsPopUpController>().selectedCurrentTab = 4;
          Get.find<UserDetailsPopUpController>().selectedMenuName = "Brk";
          Get.find<UserDetailsPopUpController>().update();
          isSymbolWiseSL = false;
          nameController.text = "";
          userNameController.text = "";
          passwordController.text = "";
          retypePasswordController.text = "";
          mobileNumberController.text = "";
          cutoffController.text = "";
          creditController.text = "";
          remarkController.text = "";
          selectedLeverage.value = arrLeverageList.first;
          profitandLossController.text = "";
          brkSharingMasterController.text = "";
          isAutoSquareOff = false;
          isModifyOrder = false;
          isCloseOnly = false;
          isIntraday = false;
          isChangePasswordOnFirstLogin = false;
          selectedBrokerType = BrokerListModelData().obs;
          bool isUserlistVcAvailable = Get.isRegistered<UserListController>();
          if (isUserlistVcAvailable) {
            Get.find<UserListController>().getUserList();
          }
          // for (var i = 0; i < arrExchange.length; i++) {
          //   if (arrExchange[i].isSelected == true) {
          //     arrExchange[i].isSelected = false;
          //   }
          //   if (arrExchange[i].isTurnOverSelected == true) {
          //     arrExchange[i].isTurnOverSelected = false;
          //   }
          //   if (arrExchange[i].isSymbolSelected == true) {
          //     arrExchange[i].isSymbolSelected = false;
          //   }
          //   if (arrExchange[i].isHighLowTradeSelected == true) {
          //     arrExchange[i].isHighLowTradeSelected = false;
          //   }
          //   if (arrExchange[i].isDropDownValueSelected.value != "") {
          //     arrExchange[i].isDropDownValueSelected.value = "";
          //   }
          //   if (arrExchange[i].selectedItems != []) {
          //     arrExchange[i].selectedItems.clear();
          //   }
          // }
          for (var i = 0; i < arrExchange.length; i++) {
            if (arrExchange[i].isSelected == true) {
              arrExchange[i].isSelected = false;
            }
            if (arrExchange[i].isTurnOverSelected == true) {
              arrExchange[i].isTurnOverSelected = false;
            }
            if (arrExchange[i].isSymbolSelected == true) {
              arrExchange[i].isSymbolSelected = false;
            }
            if (arrExchange[i].isHighLowTradeSelected == true) {
              arrExchange[i].isHighLowTradeSelected = false;
            }
            if (arrExchange[i].isDropDownValueSelected.value != "") {
              arrExchange[i].isDropDownValueSelected.value = groupListModelData();
            }
            if (arrExchange[i].selectedItems.isNotEmpty) {
              arrExchange[i].selectedItems.clear();
            }
            arrExchange[i].selectedItemsID.clear();
            arrExchange[i].isDropDownValueSelectedID.value = "";
          }
          arrSelectedGroupListIDforOthers.clear();
          arrSelectedGroupListIDforNSE.clear();
          arrSelectedGroupListIDforMCX.clear();
          arrSelectedDropDownValueClient.clear();
          arrSelectedExchangeList.clear();
          arrHighLowBetweenTradeSelectedList.clear();
          isCmpOrder = null;
          isAdminManualOrder = null;
          isDeleteTrade = null;
          isExecutePendingOrder = null;
          update();
        } else {
          showErrorToast(response.message ?? "");
          isLoadingSave.value = false;
          arrSelectedExchangeList.clear();
          arrHighLowBetweenTradeSelectedList.clear();
          arrSelectedGroupListIDforOthers.clear();
          arrSelectedGroupListIDforNSE.clear();
          arrSelectedGroupListIDforMCX.clear();
          arrSelectedDropDownValueClient.clear();
          update();
        }
      } else {
        showErrorToast(AppString.generalError);
        isLoadingSave.value = false;
        update();
      }
    } else {
      showWarningToast(msg);
    }
  }

  callForCreateMaster() async {
    var msg = validateFieldForMaster();
    if (msg.isEmpty) {
      nameFocus.unfocus();
      userNameFocus.unfocus();
      passwordFocus.unfocus();
      retypePasswordFocus.unfocus();
      mobileNumberFocus.unfocus();
      creditFocus.unfocus();
      remarkFocus.unfocus();
      profitandLossFocus.unfocus();
      brokerageSharingFocus.unfocus();
      isLoadingSave.value = true;
      update();
      var response = await service.createMasterCall(
        name: nameController.text.trim(),
        userName: userNameController.text.trim(),
        password: passwordController.text.trim(),
        phone: mobileNumberController.text.trim(),
        profitandLossSharingDownline: (userData!.profitAndLossSharingDownLine! - (num.tryParse(profitandLossController.text) ?? 0)).toInt(),
        brkSharingDownline: (userData!.brkSharingDownLine! - (num.tryParse(brkSharingMasterController.text) ?? 0)).toInt(),
        role: selectedUserType.value.roleId,
        credit: int.parse(creditController.text.trim()),
        leverage: selectedLeverage.value.id,
        remark: remarkController.text.trim(),
        symbolWiseSL: isSymbolWiseSL,
        exchangeAllow: arrSelectedExchangeList,
        highLowBetweenTradeLimits: arrHighLowBetweenTradeSelectedList,
        manualOrder: isCloseOnly ? 1 : 0,
        marketOrder: isCloseOnly ? 1 : 0,
        addMaster: isAutoSquareOff ? 1 : 0,
        modifyOrder: isModifyOrder ? 1 : 0,
        profitandLossSharing: int.parse(profitandLossController.text.trim()),
        brkSharing: int.parse(brkSharingMasterController.text.trim()),
        changePassword: isChangePasswordOnFirstLogin,
      );
      isLoadingSave.value = false;
      if (response != null) {
        if (response.statusCode == 200) {
          Get.back();
          showSuccessToast(response.meta?.message ?? "");
          isSymbolWiseSL = false;
          nameController.text = "";
          userNameController.text = "";
          passwordController.text = "";
          retypePasswordController.text = "";
          mobileNumberController.text = "";
          cutoffController.text = "";
          creditController.text = "";
          remarkController.text = "";
          selectedLeverage.value = arrLeverageList.first;
          profitandLossController.text = "";
          brokerageSharingController.text = "";
          brkSharingMasterController.text = "";
          isAutoSquareOff = false;
          isModifyOrder = false;
          isCloseOnly = false;
          isIntraday = false;
          isChangePasswordOnFirstLogin = false;
          selectedBrokerType = BrokerListModelData().obs;
          for (var i = 0; i < arrExchange.length; i++) {
            if (arrExchange[i].isSelected == true) {
              arrExchange[i].isSelected = false;
            }
            if (arrExchange[i].isTurnOverSelected == true) {
              arrExchange[i].isTurnOverSelected = false;
            }
            if (arrExchange[i].isSymbolSelected == true) {
              arrExchange[i].isSymbolSelected = false;
            }
            if (arrExchange[i].isHighLowTradeSelected == true) {
              arrExchange[i].isHighLowTradeSelected = false;
            }
            if (arrExchange[i].isDropDownValueSelected.value != "") {
              arrExchange[i].isDropDownValueSelected.value = groupListModelData();
            }
            if (arrExchange[i].selectedItems != []) {
              arrExchange[i].selectedItems.clear();
            }
          }
          arrSelectedGroupListIDforOthers.clear();
          arrSelectedGroupListIDforNSE.clear();
          arrSelectedGroupListIDforMCX.clear();
          arrSelectedDropDownValueClient.clear();
          arrSelectedExchangeList.clear();
          arrHighLowBetweenTradeSelectedList.clear();
          isCmpOrder = null;
          isAdminManualOrder = null;
          isDeleteTrade = null;
          isExecutePendingOrder = null;
          showUserDetailsPopUp(userId: response.data!.userId!, userName: response.data!.userName!);
          Get.find<UserDetailsPopUpController>().selectedCurrentTab = 4;
          Get.find<UserDetailsPopUpController>().selectedMenuName = "Brk";
          Get.find<UserDetailsPopUpController>().update();
          update();
        } else {
          showErrorToast(response.message ?? "");
          isLoadingSave.value = false;
          arrSelectedExchangeList.clear();
          arrHighLowBetweenTradeSelectedList.clear();
          arrSelectedGroupListIDforOthers.clear();
          arrSelectedGroupListIDforNSE.clear();
          arrSelectedGroupListIDforMCX.clear();
          arrSelectedDropDownValueClient.clear();
          update();
        }
      } else {
        showErrorToast(AppString.generalError);
        isLoadingSave.value = false;
        update();
      }
    } else {
      showWarningToast(msg);
    }
  }

  String numericToWord() {
    var word = "";

    word = NumToWords.convertNumberToIndianWords(int.parse(creditController.text)).toUpperCase();

    // word.replaceAll("MILLION", "LAC.");
    // word.replaceAll("BILLION", "CR.");

    return word;
  }
}
