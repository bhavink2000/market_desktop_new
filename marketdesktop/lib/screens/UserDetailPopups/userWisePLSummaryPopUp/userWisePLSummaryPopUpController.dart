import 'dart:convert';

import 'package:get/get.dart';

import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/getScriptFromSocket.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';

import '../../../../constant/index.dart';
import '../../../../main.dart';
import '../../../../modelClass/userWiseProfitLossSummaryModelClass.dart';

class UserWisePLSummaryPopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;

  Rx<UserData> selectedUser = UserData().obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  List<UserWiseProfitLossData> arrPlList = [];
  String selectedUserId = "";
  String selectedUserName = "";

  getProfitLossList(String text) async {
    var response = await service.userWiseProfitLossListCall(1, text, selectedUserId);
    arrPlList = response!.data ?? [];
    update();
    var arrTemp = [];
    for (var userObj in arrPlList) {
      for (var element in userObj.childUserDataPosition!) {
        if (!arrTemp.contains(element.symbolName)) {
          if (!arrSymbolNames.contains(element.symbolName)) {
            arrTemp.insert(0, element.symbolName);
            arrSymbolNames.insert(0, element.symbolName!);
          }
        }
      }
    }

    if (arrTemp.isNotEmpty) {
      var txt = {"symbols": arrTemp};
      socket.connectScript(jsonEncode(txt));
    }
  }

  listenUserWiseProfitLossScriptFromSocket(GetScriptFromSocket socketData) {
    if (socketData.data != null) {
      for (var userObj in arrPlList) {
        for (var i = 0; i < userObj.childUserDataPosition!.length; i++) {
          if (socketData.data!.symbol == userObj.childUserDataPosition![i].symbolName) {
            userObj.childUserDataPosition![i].profitLossValue = userObj.childUserDataPosition![i].tradeType!.toUpperCase() == "BUY"
                ? (double.parse(socketData.data!.bid.toString()) - userObj.childUserDataPosition![i].price!) * userObj.childUserDataPosition![i].quantity!
                : (userObj.childUserDataPosition![i].price! - double.parse(socketData.data!.ask.toString())) * userObj.childUserDataPosition![i].quantity!;
          }
        }
        userObj.totalProfitLossValue = 0.0;
        for (var element in userObj.childUserDataPosition!) {
          userObj.totalProfitLossValue += element.profitLossValue ?? 0.0;
        }
        userObj.plWithBrk = userObj.totalProfitLossValue + userObj.childUserProfitLossTotal! - userObj.childUserBrokerageTotal!;

        var tempShare = userObj.role == UserRollList.master ? userObj.profitAndLossSharing : userObj.profitAndLossSharingDownLine;
        userObj.netPL = ((userObj.plWithBrk * tempShare!) / 100) + userObj.brokerageTotal!;
        if (userObj.netPL != 0.0) {
          userObj.netPL = userObj.netPL * -1;
        }
      }
      update();
    }
  }
}
