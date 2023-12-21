import 'dart:convert';

import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/getScriptFromSocket.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/weeklyAdminModelClass.dart';
import 'package:marketdesktop/screens/BaseController/baseController.dart';

import '../../../../constant/index.dart';
import '../../../../main.dart';

class WeeklyAdminController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  bool isFilterOpen = false;

  Rx<UserData> selectedUser = UserData().obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  List<ExchangeData> arrExchange = [];
  List<GlobalSymbolData> arrAllScript = [];
  List<WeeklyAdminData> arrWeeklyAdmin = [];
  String symbolId = "";
  bool isApiCallRunning = false;
  bool isApiClearCallRunning = false;
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
    getWeeklyAdminList();
  }

  getWeeklyAdminList({bool isFromSubmit = true}) async {
    if (isFromSubmit) {
      isApiCallRunning = true;
    } else {
      isApiClearCallRunning = true;
    }

    update();
    var response = await service.weeklyAdminListCall(
      text: "",
      userId: selectedUser.value.userId ?? "",
    );

    arrWeeklyAdmin = response!.data ?? [];
    isApiCallRunning = false;
    isApiClearCallRunning = false;

    update();
    var arrTemp = [];
    arrWeeklyAdmin.forEach((userObj) {
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

  listenWeeklyAdminScriptFromSocket(GetScriptFromSocket socketData) {
    if (socketData.data != null) {
      arrWeeklyAdmin.forEach((userObj) {
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
          userObj.totalPl = userObj.profitLoss! + userObj.totalProfitLossValue;
          userObj.brk = userObj.brokerageTotal! + userObj.parentBrokerageTotal!;
          userObj.netPL = userObj.profitLoss! + userObj.totalProfitLossValue + userObj.brokerageTotal! + userObj.parentBrokerageTotal!;
          userObj.adminProfit = (((userObj.totalPl * 80) / 100)) * -1;
          userObj.adminBrk = (userObj.brokerageTotal! * userObj.brkSharing!) / 100;
          userObj.totalAdminBrk = userObj.adminProfit + userObj.parentBrokerageTotal!;
        }
      });
      update();
    }
  }

  double getTotal(String keyName) {
    var total = 0.0;

    arrWeeklyAdmin.forEach((element) {
      if (keyName == "ReleasedPl") {
        total = total + element.profitLoss!;
      } else if (keyName == "M2mPL") {
        total = total + element.totalProfitLossValue;
      } else if (keyName == "TotalPL") {
        total = total + element.totalPl;
      } else if (keyName == "brk") {
        total = total + element.brk;
      } else if (keyName == "netPL") {
        total = total + element.netPL;
      } else if (keyName == "adminProfit") {
        total = total + element.adminProfit;
      } else if (keyName == "adminBrk") {
        total = total + element.parentBrokerageTotal!;
      } else if (keyName == "totalAdminBrk") {
        total = total + element.totalAdminBrk;
      }
    });
    return total;
  }

  Color getColor(double value) {
    if (value > 0) {
      return AppColors().greenColor;
    } else if (value < 0) {
      return AppColors().redColor;
    } else {
      return AppColors().darkText;
    }
  }
}
