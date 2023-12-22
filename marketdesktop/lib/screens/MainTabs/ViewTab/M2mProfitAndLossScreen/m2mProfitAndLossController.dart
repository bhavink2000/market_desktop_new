import 'dart:convert';

import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/getScriptFromSocket.dart';
import 'package:marketdesktop/modelClass/m2mProfitLossModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';

import '../../../../constant/index.dart';
import '../../../../main.dart';

class M2MProfitAndLossController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;

  Rx<UserData> selectedUser = UserData().obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  List<m2mProfitLossData> arrPlList = [];
  String selectedUserId = "";

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getProfitLossList("");
  }

  getProfitLossList(String text) async {
    var response = await service.m2mProfitLossListCall(1, text, selectedUserId);
    arrPlList = response!.data ?? [];
    update();
    var arrTemp = [];
    arrPlList.forEach((userObj) {
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
  }

  listenM2MProfitLossScriptFromSocket(GetScriptFromSocket socketData) {
    if (socketData.data != null) {
      arrPlList.forEach((userObj) {
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
      });
      update();
    }
  }
}
