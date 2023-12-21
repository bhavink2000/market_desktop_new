import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/settelementListModelClass.dart';

import '../../../../constant/index.dart';

class SettlementController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  bool isFilterOpen = false;
  List<Profit> arrProfitList = [];
  List<Profit> arrLossList = [];
  String selectedUserId = "";
  Rx<UserData> selectedUser = UserData().obs;
  SettelementData? totalValues;
  bool isApiCallFromSearch = false;
  bool isApiCallFromReset = false;
  bool isApiCallFirstTime = false;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getSettelementList();
  }

  getSettelementList({int isFrom = 0}) async {
    if (isFrom == 0) {
      isApiCallFirstTime = true;
    } else if (isFrom == 1) {
      isApiCallFromSearch = true;
    } else {
      isApiCallFromReset = true;
    }
    update();
    var response = await service.settelementListCall(1, searchController.text.trim(), selectedUser.value.userId ?? "");
    if (isFrom == 0) {
      isApiCallFirstTime = false;
    } else if (isFrom == 1) {
      isApiCallFromSearch = false;
    } else {
      isApiCallFromReset = false;
    }
    arrProfitList = response!.data?.profit ?? [];
    arrLossList = response.data?.loss ?? [];
    totalValues = response.data!;
    for (var element in arrProfitList) {
      totalValues!.plProfitGrandTotal = totalValues!.plProfitGrandTotal + element.profitLoss!;
      totalValues!.brkProfitGrandTotal = totalValues!.brkProfitGrandTotal + element.brokerageTotal!;
    }
    totalValues!.profitGrandTotal = totalValues!.plProfitGrandTotal - totalValues!.brkProfitGrandTotal;
    for (var element in arrLossList) {
      totalValues!.plLossGrandTotal = totalValues!.plLossGrandTotal + element.profitLoss!;
      totalValues!.brkLossGrandTotal = totalValues!.brkLossGrandTotal + element.brokerageTotal!;
    }
    totalValues!.LossGrandTotal = totalValues!.plLossGrandTotal - totalValues!.brkLossGrandTotal;
    update();
  }

  String getRoll(String rollName) {
    var roll = "";
    if (rollName == UserRollList.admin) {
      roll = "A";
    } else if (rollName == UserRollList.superAdmin) {
      roll = "S";
    } else if (rollName == UserRollList.master) {
      roll = "M";
    } else if (rollName == UserRollList.user) {
      roll = "C";
    } else {
      roll = "B";
    }

    return roll;
  }
}
