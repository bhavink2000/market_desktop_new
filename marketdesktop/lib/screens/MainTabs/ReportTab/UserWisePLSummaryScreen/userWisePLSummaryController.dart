import 'dart:convert';

import 'package:get/get.dart';

import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/getScriptFromSocket.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';

import '../../../../constant/index.dart';
import '../../../../constant/screenColumnData.dart';
import '../../../../main.dart';
import '../../../../modelClass/userWiseProfitLossSummaryModelClass.dart';

class UserWisePLSummaryController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;

  bool isApiCallRunning = false;
  bool isResetCall = false;
  Rx<UserData> selectedUser = UserData().obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  List<UserWiseProfitLossData> arrPlList = [];
  String selectedUserId = "";
  FocusNode applyFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  double totalPlSharePer = 0.0;
  double totalNetPl = 0.0;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getColumnListFromDB(ScreenIds().userWisePLSummary, arrListTitle1);
    getProfitLossList("");
  }

  getProfitLossList(String text, {bool isFromClear = false}) async {
    if (isFromClear) {
      isResetCall = true;
    } else {
      isApiCallRunning = true;
    }

    update();
    var response = await service.userWiseProfitLossListCall(1, text, selectedUser.value.userId ?? "");
    arrPlList = response!.data ?? [];
    for (var element in arrPlList) {
      var pl = element.role == UserRollList.user ? element.profitLoss! : element.childUserProfitLossTotal!;
      var m2m = element.totalProfitLossValue;
      var sharingPer = element.role == UserRollList.user ? element.profitAndLossSharingDownLine! : element.profitAndLossSharing!;
      var total = pl + m2m;
      var finalValue = total * sharingPer / 100;

      finalValue = finalValue * -1;
      totalPlSharePer = totalPlSharePer + finalValue;

      var sharingPLPer = element.role == UserRollList.user ? element.profitAndLossSharingDownLine! : element.profitAndLossSharing!;
      var totalPL = pl + m2m;
      var finalValuePL = totalPL * sharingPLPer / 100;

      finalValuePL = finalValuePL * -1;

      finalValuePL = finalValuePL + element.parentBrokerageTotal!;
      totalNetPl = totalNetPl + finalValuePL;
    }
    isApiCallRunning = false;
    isResetCall = false;
    update();
    var arrTemp = [];
    arrPlList.forEach((userObj) {
      for (var element in userObj.childUserDataPosition!) {
        if (!arrTemp.contains(element.symbolName)) {
          if (!arrSymbolNames.contains(element.symbolName)) {
            arrTemp.insert(0, element.symbolName);
            arrSymbolNames.insert(0, element.symbolName!);
          }
        }
      }
    });

    if (arrTemp.isNotEmpty) {
      var txt = {"symbols": arrTemp};
      socket.connectScript(jsonEncode(txt));
    }
  }

  listenUserWiseProfitLossScriptFromSocket(GetScriptFromSocket socketData) {
    if (socketData.data != null) {
      arrPlList.forEach((userObj) {
        for (var i = 0; i < userObj.childUserDataPosition!.length; i++) {
          if (socketData.data!.symbol == userObj.childUserDataPosition![i].symbolName) {
            userObj.childUserDataPosition![i].profitLossValue = userObj.childUserDataPosition![i].tradeType!.toUpperCase() == "BUY"
                ? (double.parse(socketData.data!.bid.toString()) - userObj.childUserDataPosition![i].price!) * userObj.childUserDataPosition![i].quantity!
                : (userObj.childUserDataPosition![i].price! - double.parse(socketData.data!.ask.toString())) * userObj.childUserDataPosition![i].quantity!;

            var pl = userObj.role == UserRollList.user ? userObj.profitLoss! : userObj.childUserProfitLossTotal!;
            var m2m = userObj.totalProfitLossValue;
            var sharingPer = userObj.role == UserRollList.user ? userObj.profitAndLossSharingDownLine! : userObj.profitAndLossSharing!;
            var total = pl + m2m;
            var finalValue = total * sharingPer / 100;

            finalValue = finalValue * -1;
            totalPlSharePer = totalPlSharePer + finalValue;

            var sharingPLPer = userObj.role == UserRollList.user ? userObj.profitAndLossSharingDownLine! : userObj.profitAndLossSharing!;
            var totalPL = pl + m2m;
            var finalValuePL = totalPL * sharingPLPer / 100;

            finalValuePL = finalValuePL * -1;

            finalValuePL = finalValuePL + userObj.parentBrokerageTotal!;
            totalNetPl = totalNetPl + finalValuePL;
          }
        }
        userObj.totalProfitLossValue = 0.0;
        for (var element in userObj.childUserDataPosition!) {
          userObj.totalProfitLossValue += element.profitLossValue ?? 0.0;
        }
        userObj.plWithBrk = userObj.totalProfitLossValue + userObj.childUserProfitLossTotal! - userObj.childUserBrokerageTotal!;
      });
      update();
    }
  }
}
