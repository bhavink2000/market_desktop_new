import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/settelementListModelClass.dart';

import '../../../../constant/index.dart';
import '../../../../constant/utilities.dart';
import '../../ViewTab/MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';

class SettlementController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;
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
  List<ListItem> arrListTitle = [
    ListItem("USERNAME", true),
    ListItem("P/L", true),
    ListItem("BRK", true),
    ListItem("TOTAL", true),
  ];
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    fromDate.value = shortDateForBackend(findFirstDateOfTheWeek(DateTime.now()));
    endDate.value = shortDateForBackend(findLastDateOfTheWeek(DateTime.now()));
    getSettelementList();
  }

  refreshView() {
    update();
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
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
    var response = await service.settelementListCall(1, fromDate.value != "Start Date" ? fromDate.value : "", endDate.value != "End Date" ? endDate.value : "");
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
      totalValues!.profitGrandTotal = totalValues!.profitGrandTotal + element.total!;
    }

    // var temp3 = totalValues!.plProfitGrandTotal;
    // var temp4 = totalValues!.brkProfitGrandTotal;
    // if (totalValues!.plProfitGrandTotal < 0) {
    //   temp3 = totalValues!.plProfitGrandTotal * -1;
    // }
    // if (totalValues!.brkProfitGrandTotal < 0) {
    //   temp3 = totalValues!.brkProfitGrandTotal * -1;
    // }
    // totalValues!.profitGrandTotal = temp3 + temp4;
    // if (totalValues!.plStatus == 1) {
    //   totalValues!.profitGrandTotal = totalValues!.profitGrandTotal + totalValues!.myPLTotal!;
    // }

    for (var element in arrLossList) {
      totalValues!.plLossGrandTotal = totalValues!.plLossGrandTotal + element.profitLoss!;
      totalValues!.brkLossGrandTotal = totalValues!.brkLossGrandTotal + element.brokerageTotal!;
      totalValues!.LossGrandTotal = totalValues!.LossGrandTotal + element.total!;
    }
    // var temp1 = totalValues!.plLossGrandTotal;
    // var temp2 = totalValues!.brkLossGrandTotal;
    // if (totalValues!.plLossGrandTotal < 0) {
    //   temp1 = totalValues!.plLossGrandTotal * -1;
    // }
    // if (totalValues!.LossGrandTotal < 0) {
    //   temp2 = totalValues!.brkLossGrandTotal * -1;
    // }
    // totalValues!.LossGrandTotal = temp1 + temp2;
    // if (totalValues!.plStatus == 0) {
    //   totalValues!.LossGrandTotal = totalValues!.LossGrandTotal + totalValues!.myPLTotal!;
    // }

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
