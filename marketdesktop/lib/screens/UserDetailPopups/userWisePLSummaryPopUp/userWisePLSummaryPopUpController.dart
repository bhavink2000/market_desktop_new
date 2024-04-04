import 'dart:convert';

import 'package:get/get.dart';

import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/getScriptFromSocket.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';

import '../../../../constant/index.dart';
import '../../../../main.dart';
import '../../../../modelClass/userWiseProfitLossSummaryModelClass.dart';
import '../../MainTabs/ViewTab/MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';

class UserWisePLSummaryPopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;
  RxDouble totalPlSharePer = 0.0.obs;
  RxDouble totalNetPl = 0.0.obs;
  Rx<UserData> selectedUser = UserData().obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  List<UserWiseProfitLossData> arrPlList = [];
  String selectedUserId = "";
  String selectedUserName = "";
  List<ListItem> arrListTitle = [
    ListItem("VIEW", true),
    ListItem("USERNAME", true),
    ListItem("SHARING %", true),
    ListItem("BRK SHARING %", true),
    ListItem("RELEASE CLIENT P/L", true),
    ListItem("CLIENT BRK", true),
    ListItem("CLIENT M2M", true),
    ListItem("P/L WITH BRK", true),
    ListItem("P/L SHARE %", true),
    ListItem("BRK", true),
    ListItem("NET P/L", true),
  ];
  refreshView() {
    update();
  }

  getProfitLossList(String text) async {
    var response = await service.userWiseProfitLossListCall(1, text, selectedUserId);
    arrPlList = response!.data ?? [];

    for (var element in arrPlList) {
      for (var i = 0; i < element.childUserDataPosition!.length; i++) {
        if (element.arrSymbol != null) {
          var symbolObj = element.arrSymbol!.firstWhere((obj) => element.childUserDataPosition![i].symbolId == obj.id);

          element.childUserDataPosition![i].profitLossValue = element.childUserDataPosition![i].totalQuantity! < 0
              ? (double.parse(symbolObj.ask.toString()) - element.childUserDataPosition![i].price!) * element.childUserDataPosition![i].totalQuantity!
              : (double.parse(symbolObj.bid.toString()) - double.parse(element.childUserDataPosition![i].price!.toStringAsFixed(2))) * element.childUserDataPosition![i].totalQuantity!;
        }
      }

      var pl = element.role == UserRollList.user ? element.profitLoss! : element.childUserProfitLossTotal!;

      element.totalProfitLossValue = 0.0;
      for (var value in element.childUserDataPosition!) {
        element.totalProfitLossValue += value.profitLossValue ?? 0.0;
      }
      var brkTotal = 0.0;
      if (element.role == UserRollList.master) {
        brkTotal = double.parse(element.childUserBrokerageTotal!.toString());
      } else {
        brkTotal = double.parse(element.brokerageTotal!.toString());
      }

      element.plWithBrk = element.totalProfitLossValue + pl - brkTotal;

      var m2m = element.totalProfitLossValue;
      var sharingPer = element.role == UserRollList.user ? element.profitAndLossSharingDownLine! : element.profitAndLossSharing!;
      var total = pl + m2m;
      var finalValue = total * sharingPer / 100;

      finalValue = finalValue * -1;
      totalPlSharePer.value = totalPlSharePer.value + finalValue;

      element.plSharePer = finalValue;

      finalValue = finalValue + element.parentBrokerageTotal!;
      element.netPL = finalValue;

      finalValue = finalValue + element.parentBrokerageTotal!;
      totalNetPl.value = totalNetPl.value + finalValue;
    }

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

    if (arrSymbolNames.isNotEmpty) {
      var txt = {"symbols": arrSymbolNames};
      socket.connectScript(jsonEncode(txt));
    }
  }

  listenUserWiseProfitLossScriptFromSocket(GetScriptFromSocket socketData) {
    if (socketData.data != null) {
      arrPlList.forEach((userObj) {
        for (var i = 0; i < userObj.childUserDataPosition!.length; i++) {
          if (socketData.data!.symbol == userObj.childUserDataPosition![i].symbolName) {
            // userObj.childUserDataPosition![i].profitLossValue = userObj.childUserDataPosition![i].tradeType!.toUpperCase() == "BUY"
            //     ? (double.parse(socketData.data!.bid.toString()) - userObj.childUserDataPosition![i].price!) * userObj.childUserDataPosition![i].quantity!
            //     : (userObj.childUserDataPosition![i].price! - double.parse(socketData.data!.ask.toString())) * userObj.childUserDataPosition![i].quantity!;

            userObj.childUserDataPosition![i].profitLossValue = userObj.childUserDataPosition![i].totalQuantity! < 0
                ? (double.parse(socketData.data!.ask.toString()) - userObj.childUserDataPosition![i].price!) * userObj.childUserDataPosition![i].totalQuantity!
                : (double.parse(socketData.data!.bid.toString()) - double.parse(userObj.childUserDataPosition![i].price!.toStringAsFixed(2))) * userObj.childUserDataPosition![i].totalQuantity!;

            var pl = userObj.role == UserRollList.user ? userObj.profitLoss! : userObj.childUserProfitLossTotal!;
            userObj.totalProfitLossValue = 0.0;
            for (var element in userObj.childUserDataPosition!) {
              userObj.totalProfitLossValue += element.profitLossValue ?? 0.0;
            }
            var brkTotal = 0.0;
            if (userObj.role == UserRollList.master) {
              brkTotal = double.parse(userObj.childUserBrokerageTotal!.toString());
            } else {
              brkTotal = double.parse(userObj.brokerageTotal!.toString());
            }

            userObj.plWithBrk = userObj.totalProfitLossValue + pl - brkTotal;

            var m2m = userObj.totalProfitLossValue;
            var sharingPer = userObj.role == UserRollList.user ? userObj.profitAndLossSharingDownLine! : userObj.profitAndLossSharing!;
            var total = pl + m2m;
            var finalValue = total * sharingPer / 100;

            // finalValue = finalValue * -1;
            userObj.plSharePer = finalValue * -1;

            var sharingPLPer = userObj.role == UserRollList.user ? userObj.profitAndLossSharingDownLine! : userObj.profitAndLossSharing!;
            var totalPL = pl + m2m;
            var finalValuePL = (totalPL * sharingPLPer) / 100;
            finalValuePL = finalValuePL * -1;
            finalValuePL = finalValuePL + userObj.parentBrokerageTotal!;
            userObj.netPL = finalValuePL;
          }
        }
      });
      totalNetPl.value = 0.0;
      totalPlSharePer.value = 0.0;
      for (var element in arrPlList) {
        totalPlSharePer.value = totalPlSharePer.value + element.plSharePer;
        totalNetPl.value = totalNetPl.value + element.netPL;
      }
      update();
    }
  }
}
