import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/groupListModelClass.dart';
import 'package:marketdesktop/constant/index.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/brokerListModelClass.dart';
import 'package:marketdesktop/modelClass/constantModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeAllowModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
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
  List<ExchangeAllowforMaster> arrSelectedExchangeListforMaster = [];
  List<ExchangeAllow> arrSelectedExchangeListforClient = [];
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
  RxBool isFreshLimitSL = false.obs;
  bool isEyeOpenPassword = true;
  bool isEyeOpenRetypePassword = true;
  RxBool isLoadingSave = false.obs;
  GlobalKey singleDropdownKey = GlobalKey();
  final FocusNode focusNode = FocusNode();
  GlobalKey? dropdownLeveargeKey;
  final debouncer = Debouncer(milliseconds: 200);
  FocusNode saveFocus = FocusNode();
  FocusNode cancelFocus = FocusNode();
  UserData? selectedUserForEdit;

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
  // Edit User Functions
  //*********************************************************************** */

  fillUserDataForEdit() async {
    reseData();
    if (selectedUserForEdit != null) {
      if (selectedUserForEdit!.role == UserRollList.master) {
        nameController.text = selectedUserForEdit!.name!;
        userNameController.text = selectedUserForEdit!.userName!;
        mobileNumberController.text = selectedUserForEdit!.phone!.toString();
        creditController.text = selectedUserForEdit!.credit.toString().replaceAll(RegExp(r'\.0$'), '');
        remarkController.text = selectedUserForEdit!.remark!;
        isAutoSquareOff = selectedUserForEdit!.addMaster == 1 ? true : false;
        isChangePasswordOnFirstLogin = selectedUserForEdit!.changePasswordOnFirstLogin!;
        selectedUserType.value.roleId = selectedUserForEdit!.role;
        isCloseOnly = selectedUserForEdit!.marketOrder == 1 ? true : false;
        profitandLossController.text = selectedUserForEdit!.profitAndLossSharing.toString();
        isFreshLimitSL.value = selectedUserForEdit?.freshLimitSL ?? false;
        brkSharingMasterController.text = selectedUserForEdit!.brkSharing.toString();
        if (selectedUserForEdit!.highLowBetweenTradeLimit != null) {
          for (var element in selectedUserForEdit!.highLowBetweenTradeLimit!) {
            for (var i = 0; i < arrExchange.length; i++) {
              if (arrExchange[i].exchangeId == element) {
                arrExchange[i].isHighLowTradeSelected = true;
              }
            }
          }
        }
        if (selectedUserForEdit!.exchangeAllow != null) {
          for (var i = 0; i < selectedUserForEdit!.exchangeAllow!.length; i++) {
            for (var j = 0; j < arrExchange.length; j++) {
              if (arrExchange[j].exchangeId == selectedUserForEdit!.exchangeAllow![i].exchangeId) {
                arrExchange[j].isSelected = true;
                for (var l = 0; l < arrExchange[j].arrGroupList.length; l++) {
                  for (var k = 0; k < selectedUserForEdit!.exchangeAllow![i].groupId!.length; k++) {
                    if (arrExchange[j].arrGroupList[l].groupId == selectedUserForEdit!.exchangeAllow![i].groupId![k]) {
                      arrExchange[j].selectedItems.add(arrExchange[j].arrGroupList[l]);
                    }
                  }
                }
              }
            }
          }
        }
        if (arrExchange.every((exchange) => exchange.isSelected)) {
          isSelectedallExchangeinMaster.value = true;
        }
        if (userData!.highLowSLLimitPercentage == true) {
          isSymbolWiseSL = true;
        }
        update();
      } else if (selectedUserForEdit!.role == UserRollList.user) {
        selectedUserType.value.roleId = selectedUserForEdit!.role;
        nameController.text = selectedUserForEdit!.name!;
        userNameController.text = selectedUserForEdit!.userName!;
        mobileNumberController.text = selectedUserForEdit!.phone!.toString();
        creditController.text = selectedUserForEdit!.credit.toString().replaceAll(RegExp(r'\.0$'), '');
        remarkController.text = selectedUserForEdit!.remark!;
        isAutoSquareOff = selectedUserForEdit!.autoSquareOff == 1 ? true : false;
        cutoffController.text = selectedUserForEdit!.cutOff.toString();
        isChangePasswordOnFirstLogin = selectedUserForEdit!.changePasswordOnFirstLogin!;
        if (selectedUserForEdit!.highLowBetweenTradeLimit != null) {
          for (var element in selectedUserForEdit!.highLowBetweenTradeLimit!) {
            for (var i = 0; i < arrExchange.length; i++) {
              if (arrExchange[i].exchangeId == element) {
                arrExchange[i].isHighLowTradeSelected = true;
              }
            }
          }
        }
        if (selectedUserForEdit != null && selectedUserForEdit!.exchangeAllow != null) {
          for (var i = 0; i < selectedUserForEdit!.exchangeAllow!.length; i++) {
            var currentExchangeId = selectedUserForEdit!.exchangeAllow![i].exchangeId;
            var groupId = selectedUserForEdit!.exchangeAllow![i].groupId?[0];
            for (var j = 0; j < arrExchange.length; j++) {
              if (arrExchange[j].exchangeId == currentExchangeId) {
                arrExchange[j].isSelected = true;
                arrExchange[j].isTurnOverSelected = selectedUserForEdit!.exchangeAllow![i].isTurnoverWise;
                arrExchange[j].isSymbolSelected = selectedUserForEdit!.exchangeAllow![i].isSymbolWise;
                var groupData = await callforGroupList(currentExchangeId);

                arrExchange[j].arrGroupList.clear();
                arrExchange[j].arrGroupList.addAll(groupData);
                if (groupId != null) {
                  int index = arrExchange[j].arrGroupList.indexWhere((item) => item.groupId == groupId);
                  if (index != -1) {
                    arrExchange[j].isDropDownValueSelected.value = arrExchange[j].arrGroupList[index];
                  } else {
                    arrExchange[i].isDropDownValueSelected = arrExchange[i].arrGroupList.first.obs;
                  }
                } else {
                  arrExchange[i].isDropDownValueSelected = arrExchange[i].arrGroupList.first.obs;
                }
              }
            }
          }
        }

        if (arrExchange.every((exchange) => exchange.isSelected)) {
          isSelectedallExchangeinMaster.value = true;
        }
        if (userData!.highLowSLLimitPercentage == true) {
          isSymbolWiseSL = true;
        }

        var selectedLeverageIndex = arrLeverageList.indexWhere((element) => element.name == selectedUserForEdit!.leverage!);
        if (selectedLeverageIndex != -1) {
          selectedLeverage.value = arrLeverageList[selectedLeverageIndex];
        }
        update();
      }
    }
    update();
  }

  reseData() {
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
    isSelectedallExchangeinMaster.value = false;
    selectedBrokerType = BrokerListModelData().obs;
    // selectedUserType.value = arrUserTypeList.first;
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
      if (arrExchange[i].isDropDownValueSelected.value.groupId != null) {
        arrExchange[i].isDropDownValueSelected.value.groupId = null;
      }
      if (arrExchange[i].selectedItems.isNotEmpty) {
        arrExchange[i].selectedItems.clear();
      }
      arrExchange[i].selectedItemsID.clear();
      arrExchange[i].isDropDownValueSelectedID.value = "";
      if (selectedUserType.value.roleId == UserRollList.user) {
        if (!arrExchange[i].arrGroupList.any((group) => group.name == "Select Group")) {
          arrExchange[i].arrGroupList.insert(0, groupListModelData(name: "Select Group"));
        }

        arrExchange[i].isDropDownValueSelected = arrExchange[i].arrGroupList.first.obs;
      }
      if (selectedUserType.value.roleId != UserRollList.user) {
        arrExchange[i].arrGroupList.removeWhere((element) => element.name == "Select Group");
      }
    }
    arrSelectedGroupListIDforOthers.clear();
    arrSelectedGroupListIDforNSE.clear();
    arrSelectedGroupListIDforMCX.clear();
    arrSelectedDropDownValueClient.clear();
    arrSelectedExchangeListforMaster.clear();
    arrSelectedExchangeListforClient.clear();
    arrHighLowBetweenTradeSelectedList.clear();
    isCmpOrder = null;
    isAdminManualOrder = null;
    isDeleteTrade = null;
    isExecutePendingOrder = null;
    update();
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
    } else if (selectedUserForEdit == null) {
      if (passwordController.text.trim().isEmpty) {
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
    }
    // else if (mobileNumberController.text.trim().isEmpty) {
    //   msg = AppString.emptyMobileNumber;
    // } else if (mobileNumberController.text.trim().length < 9) {
    //   msg = AppString.mobileNumberLength;
    // }
    // else if (cutoffController.text.trim().isEmpty) {
    //   msg = AppString.emptyCutOff;
    // }
    else if ((cutoffController.text.isNotEmpty && int.parse(cutoffController.text) < 60) ||
        (cutoffController.text.isNotEmpty && int.parse(cutoffController.text) > 100)) {
      msg = AppString.cutOffValid;
    } else if (creditController.text.trim().isEmpty) {
      msg = AppString.emptyCredit;
    } else if (arrSelectedExchangeListforClient.isEmpty) {
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
    } else if (selectedUserForEdit == null) {
      if (passwordController.text.trim().isEmpty) {
        msg = AppString.emptyPassword;
      } else if (passwordController.text.trim().length < 6) {
        msg = AppString.wrongPassword;
      }
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
    } else if (selectedUserForEdit == null) {
      if (passwordController.text.trim().isEmpty) {
        msg = AppString.emptyPassword;
      } else if (passwordController.text.length < 6) {
        msg = AppString.wrongPassword;
      } else if (retypePasswordController.text.trim().isEmpty) {
        msg = AppString.emptyConfirmPassword;
      } else if (retypePasswordController.text.length < 6) {
        msg = AppString.wrongRetypePassword;
      } else if (passwordController.text.trim() != retypePasswordController.text.trim()) {
        msg = AppString.passwordNotMatch;
      }
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
    } else if (selectedUserForEdit == null) {
      if (passwordController.text.trim().isEmpty) {
        msg = AppString.emptyPassword;
      } else if (passwordController.text.length < 6) {
        msg = AppString.wrongPassword;
      } else if (retypePasswordController.text.trim().isEmpty) {
        msg = AppString.emptyConfirmPassword;
      } else if (retypePasswordController.text.length < 6) {
        msg = AppString.wrongRetypePassword;
      } else if (passwordController.text.trim() != retypePasswordController.text.trim()) {
        msg = AppString.passwordNotMatch;
      }
    } else if (creditController.text.trim().isEmpty) {
      msg = AppString.emptyCredit;
    } else if (arrSelectedExchangeListforMaster.isEmpty) {
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

  onSavePressed() {
    try {
      arrSelectedExchangeListforMaster.clear();
      arrSelectedExchangeListforClient.clear();
      for (var i = 0; i < arrExchange.length; i++) {
        arrExchange[i].selectedItemsID.clear();
        for (var k = 0; k < arrExchange[i].arrGroupList.length; k++) {
          for (var l = 0; l < arrExchange[i].selectedItems.length; l++) {
            if (arrExchange[i].arrGroupList[k].name == arrExchange[i].selectedItems[l].name && arrExchange[i].arrGroupList[k].groupId != null) {
              arrExchange[i].selectedItemsID.add(arrExchange[i].arrGroupList[k].groupId!);
            }
          }
          if (arrExchange[i].arrGroupList[k].name == arrExchange[i].isDropDownValueSelected.value.name &&
              arrExchange[i].isDropDownValueSelected.value.exchangeId!.isNotEmpty) {
            arrExchange[i].selectedItemsID.add(arrExchange[i].arrGroupList[k].groupId!);
          }
        }

        if (arrExchange[i].isSelected == true) {
          if (selectedUserType.value.roleId == UserRollList.master) {
            ExchangeAllowforMaster arrexchangeAllow = ExchangeAllowforMaster(
              exchangeId: arrExchange[i].exchangeId,
              groupId: arrExchange[i].selectedItemsID,
            );
            arrSelectedExchangeListforMaster.add(arrexchangeAllow);
          } else {
            ExchangeAllow arrexchangeAllow = ExchangeAllow(
              exchangeId: arrExchange[i].exchangeId,
              isTurnoverWise: arrExchange[i].isTurnOverSelected ?? false,
              isSymbolWise: arrExchange[i].isHighLowTradeSelected ?? false,
              groupId: arrExchange[i].selectedItemsID,
            );
            arrSelectedExchangeListforClient.add(arrexchangeAllow);
          }
        }
      }
      for (var i = 0; i < arrExchange.length; i++) {
        if (arrExchange[i].isHighLowTradeSelected! == true) {
          arrHighLowBetweenTradeSelectedList.add(arrExchange[i].exchangeId ?? "");
        }
      }
      update();
      if (Get.arguments != null) {
        // callForEditUser();
      } else {
        if (selectedUserForEdit == null) {
          if (selectedUserType.value.roleId == UserRollList.broker) {
            callForCreateBrocker();
          } else if (selectedUserType.value.roleId == UserRollList.master) {
            callForCreateMaster();
          } else if (selectedUserType.value.roleId == UserRollList.user) {
            callForCreateUser();
          } else if (selectedUserType.value.roleId == UserRollList.admin) {
            callForCreateAdmin();
          }
        } else {
          if (selectedUserForEdit!.role == UserRollList.broker) {
            callForEditBrocker();
          } else if (selectedUserForEdit!.role == UserRollList.master) {
            callForEditMaster();
          } else if (selectedUserForEdit!.role == UserRollList.user) {
            callForEditUser();
          } else if (selectedUserForEdit!.role == UserRollList.admin) {
            callForCreateAdmin();
          }
        }
      }

      update();
    } catch (e) {
      print(e);
      update();
    }
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
          update();
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
        response.data!.insert(0, groupListModelData(name: "Select Group"));
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
          arrSelectedExchangeListforClient.clear();
          arrSelectedExchangeListforMaster.clear();
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
          arrSelectedExchangeListforClient.clear();
          arrSelectedExchangeListforMaster.clear();
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

  callForEditBrocker() async {
    var msg = validateFieldForBrocker();
    if (msg.isEmpty) {
      nameFocus.unfocus();
      userNameFocus.unfocus();
      passwordFocus.unfocus();
      isLoadingSave.value = true;
      update();
      var response = await service.editBrokerCall(
        name: nameController.text.trim(),
        userName: userNameController.text.trim(),
        phone: mobileNumberController.text.trim(),
        changePassword: isChangePasswordOnFirstLogin,
        role: selectedUserType.value.roleId,
      );
      isLoadingSave.value = false;
      if (response != null) {
        if (response.statusCode == 200) {
          Get.back();
          Get.find<UserListController>().updateUser();
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
          arrSelectedExchangeListforClient.clear();
          arrSelectedExchangeListforMaster.clear();
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
          arrSelectedExchangeListforClient.clear();
          arrSelectedExchangeListforMaster.clear();
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
          arrSelectedExchangeListforMaster.clear();
          arrSelectedExchangeListforClient.clear();
          arrHighLowBetweenTradeSelectedList.clear();
          isCmpOrder = null;
          isAdminManualOrder = null;
          isDeleteTrade = null;
          isExecutePendingOrder = null;
          update();
        } else {
          showErrorToast(response.message ?? "");
          isLoadingSave.value = false;
          arrSelectedExchangeListforMaster.clear();
          arrSelectedExchangeListforClient.clear();
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

  callForEditAdmin() async {
    var msg = validateFieldForAdmin();
    if (msg.isEmpty) {
      nameFocus.unfocus();
      userNameFocus.unfocus();
      passwordFocus.unfocus();
      retypePasswordFocus.unfocus();
      mobileNumberFocus.unfocus();
      isLoadingSave.value = true;
      update();
      var response = await service.editAdminCall(
        name: nameController.text.trim(),
        userName: userNameController.text.trim(),
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
          Get.find<UserListController>().updateUser();
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
          arrSelectedExchangeListforMaster.clear();
          arrSelectedExchangeListforClient.clear();
          arrHighLowBetweenTradeSelectedList.clear();
          isCmpOrder = null;
          isAdminManualOrder = null;
          isDeleteTrade = null;
          isExecutePendingOrder = null;
          update();
        } else {
          showErrorToast(response.message ?? "");
          isLoadingSave.value = false;
          arrSelectedExchangeListforMaster.clear();
          arrSelectedExchangeListforClient.clear();
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
          exchangeAllow: arrSelectedExchangeListforClient,
          highLowBetweenTradeLimits: arrHighLowBetweenTradeSelectedList,
          autoSquareOff: isAutoSquareOff ? 1 : 0,
          modifyOrder: isModifyOrder ? 1 : 0,
          closeOnly: isCloseOnly,
          intraday: isIntraday ? 1 : 0,
          symbolWiseSL: isSymbolWiseSL,
          brokerId: selectedBrokerType.value.userId ?? "",
          brkSharingDownLine: int.tryParse(brokerageSharingController.text) ?? 0,
          changePassword: isChangePasswordOnFirstLogin,
          freshLimitSL: isFreshLimitSL.value);
      isLoadingSave.value = false;
      if (response != null) {
        if (response.statusCode == 200) {
          Get.back();
          showSuccessToast(response.meta?.message ?? "");

          showUserDetailsPopUp(userId: response.data!.userId!, userName: response.data!.userName!);
          Get.find<UserDetailsPopUpController>().selectedCurrentTab = 4;
          Get.find<UserDetailsPopUpController>().selectedMenuName = "Brk";
          Get.find<UserDetailsPopUpController>().update();
          if (userData!.highLowSLLimitPercentage == true) {
            isSymbolWiseSL = true;
          }
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
          arrSelectedExchangeListforMaster.clear();
          arrSelectedExchangeListforClient.clear();
          arrHighLowBetweenTradeSelectedList.clear();
          isCmpOrder = null;
          isAdminManualOrder = null;
          isDeleteTrade = null;
          isExecutePendingOrder = null;
          update();
        } else {
          showErrorToast(response.message ?? "");
          isLoadingSave.value = false;
          arrSelectedExchangeListforMaster.clear();
          arrSelectedExchangeListforClient.clear();
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

  callForEditUser() async {
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
      var response = await service.editUserCall(
          userId: selectedUserForEdit!.userId,
          name: nameController.text.trim(),
          userName: userNameController.text.trim(),
          // password: passwordController.text.trim(),
          phone: mobileNumberController.text.trim(),
          role: selectedUserType.value.roleId,
          credit: int.parse(creditController.text.trim()),
          cutOff: cutoffController.text.trim().isEmpty ? 0 : int.parse(cutoffController.text.trim()),
          leverage: selectedLeverage.value.id,
          remark: remarkController.text.trim(),
          exchangeAllow: arrSelectedExchangeListforClient,
          highLowBetweenTradeLimits: arrHighLowBetweenTradeSelectedList,
          autoSquareOff: isAutoSquareOff ? 1 : 0,
          modifyOrder: isModifyOrder ? 1 : 0,
          closeOnly: isCloseOnly,
          intraday: isIntraday ? 1 : 0,
          symbolWiseSL: isSymbolWiseSL,
          brokerId: selectedBrokerType.value.userId ?? "",
          brkSharingDownLine: int.tryParse(brokerageSharingController.text) ?? 0,
          changePassword: isChangePasswordOnFirstLogin,
          freshLimitSL: isFreshLimitSL.value);
      isLoadingSave.value = false;
      if (response != null) {
        if (response.statusCode == 200) {
          Get.back();
          showSuccessToast(response.meta?.message ?? "");
          // selectedUserForEdit = null;
          Get.find<UserListController>().updateUser();
          showUserDetailsPopUp(userId: response.data!.userId!, userName: response.data!.userName!);
          Get.find<UserDetailsPopUpController>().selectedCurrentTab = 4;
          Get.find<UserDetailsPopUpController>().selectedMenuName = "Brk";
          Get.find<UserDetailsPopUpController>().update();
          if (userData!.highLowSLLimitPercentage == true) {
            isSymbolWiseSL = true;
          }
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
          arrSelectedExchangeListforMaster.clear();
          arrSelectedExchangeListforClient.clear();
          arrHighLowBetweenTradeSelectedList.clear();
          isCmpOrder = null;
          isAdminManualOrder = null;
          isDeleteTrade = null;
          isExecutePendingOrder = null;
          var userListVC = Get.find<UserListController>();
          userListVC.getUserList();
          userListVC.update();
          update();
        } else {
          showErrorToast(response.message ?? "");
          isLoadingSave.value = false;
          arrSelectedExchangeListforMaster.clear();
          arrSelectedExchangeListforClient.clear();
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
        exchangeAllow: arrSelectedExchangeListforMaster,
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
          if (userData!.highLowSLLimitPercentage == true) {
            isSymbolWiseSL = true;
          }
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
          arrSelectedExchangeListforMaster.clear();
          arrSelectedExchangeListforClient.clear();
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
          arrSelectedExchangeListforMaster.clear();
          arrSelectedExchangeListforClient.clear();
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

  callForEditMaster() async {
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
      var response = await service.editMasterCall(
        userId: selectedUserForEdit!.userId,
        name: nameController.text.trim(),
        userName: userNameController.text.trim(),
        // password: passwordController.text.trim(),
        phone: mobileNumberController.text.trim(),
        profitandLossSharingDownline: (userData!.profitAndLossSharingDownLine! - (num.tryParse(profitandLossController.text) ?? 0)).toInt(),
        brkSharingDownline: (userData!.brkSharingDownLine! - (num.tryParse(brkSharingMasterController.text) ?? 0)).toInt(),
        role: selectedUserType.value.roleId,
        credit: int.parse(creditController.text.trim()),
        leverage: selectedLeverage.value.id,
        remark: remarkController.text.trim(),
        symbolWiseSL: isSymbolWiseSL,
        exchangeAllow: arrSelectedExchangeListforMaster,
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
          // selectedUserForEdit = null;
          Get.find<UserListController>().updateUser();
          if (userData!.highLowSLLimitPercentage == true) {
            isSymbolWiseSL = true;
          }
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
          arrSelectedExchangeListforMaster.clear();
          arrSelectedExchangeListforClient.clear();
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
          arrSelectedExchangeListforMaster.clear();
          arrSelectedExchangeListforClient.clear();
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
