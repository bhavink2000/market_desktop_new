import 'dart:convert';

import 'package:get/get.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/BaseController/baseController.dart';

import '../../../../constant/index.dart';
import '../../../../modelClass/getScriptFromSocket.dart';
import '../../../../modelClass/symbolWisePlListModelClass.dart';
import '../../ViewTab/MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';

class ProfitAndLossSummaryController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  Rx<UserData> selectedUser = UserData().obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  List<ExchangeData> arrExchange = [];
  List<GlobalSymbolData> arrAllScript = [];
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  List<SymbolWiseProfitLossData> arrProfitLoss = [];
  bool isApiCallRunning = false;
  bool isClearApiCallRunning = false;

  List<ListItem> arrListTitle = [
    ListItem("DESCRIPTION", true),
    ListItem("PROFIT & LOSS", true),
    ListItem("BRK", true),
    ListItem("TOTAL", true),
    ListItem("M2M P/L", true),
    ListItem("NET P/L", true),
  ];

  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
    profitLossList();
  }

  refreshView() {
    update();
  }

  profitLossList({bool isFromClear = false}) async {
    if (isFromClear) {
      isClearApiCallRunning = true;
    } else {
      isApiCallRunning = true;
    }

    update();
    var response = await service.SymbolWisePlListCall(userId: selectedUser.value.userId ?? "");

    isApiCallRunning = false;
    isClearApiCallRunning = false;
    update();
    if (response?.statusCode == 200) {
      arrProfitLoss.clear();
      arrProfitLoss.addAll(response!.data!);
      var arrTemp = [];
      arrProfitLoss.forEach((userObj) {
        for (var element in userObj.positionData!) {
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

      update();
    }
  }

  listenSymbolWiseProfitLossScriptFromSocket(GetScriptFromSocket socketData) {
    if (socketData.data != null) {
      arrProfitLoss.forEach((userObj) {
        try {
          for (var i = 0; i < userObj.positionData!.length; i++) {
            if (socketData.data!.symbol == userObj.positionData![i].symbolName) {
              userObj.positionData![i].profitLossValue = userObj.positionData![i].tradeType!.toUpperCase() == "BUY"
                  ? (double.parse(socketData.data!.bid.toString()) - userObj.positionData![i].price!) * userObj.positionData![i].quantity!
                  : (userObj.positionData![i].price! - double.parse(socketData.data!.ask.toString())) * userObj.positionData![i].quantity!;
            }
          }
          userObj.total = userObj.profitLoss! - userObj.brokerageTotal!;
          userObj.totalProfitLossValue = 0.0;
          for (var element in userObj.positionData!) {
            userObj.totalProfitLossValue += element.profitLossValue ?? 0.0;
          }
          userObj.netPL = userObj.total + userObj.totalProfitLossValue;

          // var tempShare =
          //     userObj.role == UserRollList.master ? userObj.profitAndLossSharing : userObj.profitAndLossSharingDownLine;
          // userObj.netPL = ((userObj.plWithBrk * tempShare!) / 100) + userObj.parentBrokerageTotal!;
          // if (userObj.netPL != 0.0) {
          //   userObj.netPL = userObj.netPL * -1;
          // }
        } catch (e) {
          print(e);
        }
      });
      update();
    }
  }

  double getTotal(String keyName) {
    var total = 0.0;

    arrProfitLoss.forEach((element) {
      if (keyName == "pl") {
        total = total + element.profitLoss!;
      } else if (keyName == "brk") {
        total = total + element.brokerageTotal!;
      } else if (keyName == "Total") {
        total = total + element.total;
      } else if (keyName == "m2m") {
        total = total + element.totalProfitLossValue;
      } else if (keyName == "netPL") {
        total = total + element.netPL;
      }
    });
    return total;
  }
}
