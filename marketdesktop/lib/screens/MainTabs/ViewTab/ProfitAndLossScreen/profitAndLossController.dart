import 'dart:convert';

import 'package:get/get.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import '../../../../constant/index.dart';
import '../../../../modelClass/getScriptFromSocket.dart';
import '../../../../modelClass/profitLossListModelClass.dart';

class ProfitAndLossController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;
  bool isFilterOpen = true;
  bool isApiCallRunning = false;
  Rx<UserData> selectedUser = UserData().obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  List<ProfitLossData> arrProfitLoss = [];

  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
    profitLossList();
  }

  profitLossList() async {
    isApiCallRunning = true;

    update();
    var response = await service.profitLossListCall(userId: selectedUser.value.userId ?? "");

    isApiCallRunning = false;

    update();
    if (response?.statusCode == 200) {
      arrProfitLoss.clear();
      arrProfitLoss.addAll(response!.data!);
      var arrTemp = [];
      arrProfitLoss.forEach((userObj) {
        for (var element in userObj.childUserDataPosition!) {
          if (!arrTemp.contains(element.symbolName)) {
            if (!socket.arrSymbolNames.contains(element.symbolName)) {
              arrTemp.insert(0, element.symbolName);
              socket.arrSymbolNames.insert(0, element.symbolName!);
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

  listenUserWiseProfitLossScriptFromSocket(GetScriptFromSocket socketData) {
    if (socketData.data != null) {
      arrProfitLoss.forEach((userObj) {
        try {
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
          userObj.plWithBrk = userObj.totalProfitLossValue + userObj.childUserProfitLossTotal - userObj.childUserBrokerageTotal;

          var tempShare = userObj.role == UserRollList.master ? userObj.profitAndLossSharing : userObj.profitAndLossSharingDownLine;
          userObj.netPL = ((userObj.plWithBrk * tempShare!) / 100) + userObj.parentBrokerageTotal;
          if (userObj.netPL != 0.0) {
            userObj.netPL = userObj.netPL * -1;
          }
        } catch (e) {
          print(e);
        }
      });
      update();
    }
  }
}
