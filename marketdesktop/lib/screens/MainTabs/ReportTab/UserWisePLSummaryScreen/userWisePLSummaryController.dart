import 'dart:convert';

import 'package:get/get.dart';

import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/getScriptFromSocket.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:excel/excel.dart' as excelLib;
import '../../../../constant/index.dart';
import '../../../../constant/screenColumnData.dart';
import '../../../../constant/utilities.dart';
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
            // userObj.childUserDataPosition![i].profitLossValue = userObj.childUserDataPosition![i].tradeType!.toUpperCase() == "BUY"
            //     ? (double.parse(socketData.data!.bid.toString()) - userObj.childUserDataPosition![i].price!) * userObj.childUserDataPosition![i].quantity!
            //     : (userObj.childUserDataPosition![i].price! - double.parse(socketData.data!.ask.toString())) * userObj.childUserDataPosition![i].quantity!;

            userObj.childUserDataPosition![i].profitLossValue = userObj.childUserDataPosition![i].totalQuantity! < 0
                ? (double.parse(socketData.data!.ask.toString()) - userObj.childUserDataPosition![i].price!) * userObj.childUserDataPosition![i].totalQuantity!
                : (double.parse(socketData.data!.bid.toString()) - double.parse(userObj.childUserDataPosition![i].price!.toStringAsFixed(2))) * userObj.childUserDataPosition![i].totalQuantity!;

            var pl = userObj.role == UserRollList.user ? userObj.profitLoss! : userObj.childUserProfitLossTotal!;
            var m2m = userObj.totalProfitLossValue;
            var sharingPer = userObj.role == UserRollList.user ? userObj.profitAndLossSharingDownLine! : userObj.profitAndLossSharing!;
            var total = pl + m2m;
            var finalValue = total * sharingPer / 100;

            // finalValue = finalValue * -1;
            userObj.plSharePer = finalValue * -1;

            var sharingPLPer = userObj.role == UserRollList.user ? userObj.profitAndLossSharingDownLine! : userObj.profitAndLossSharing!;
            var totalPL = pl + m2m;
            var finalValuePL = totalPL * sharingPLPer / 100;
            finalValuePL = finalValuePL + userObj.parentBrokerageTotal!;
            userObj.netPL = finalValuePL * -1;
            // finalValuePL = finalValuePL * -1;
          }
        }
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
        var pl = userObj.role == UserRollList.user ? userObj.profitLoss! : userObj.childUserProfitLossTotal!;
        userObj.plWithBrk = userObj.totalProfitLossValue + pl - brkTotal;
      });
      totalNetPl = 0.0;
      totalPlSharePer = 0.0;
      for (var element in arrPlList) {
        totalPlSharePer = totalPlSharePer + element.plSharePer;
        totalNetPl = totalNetPl + element.netPL;
      }
      update();
    }
  }

  onClickExcel({bool isFromPDF = false}) {
    List<excelLib.TextCellValue?> titleList = [];
    arrListTitle1.forEach((element) {
      titleList.add(excelLib.TextCellValue(element.title!));
    });
    List<List<excelLib.TextCellValue?>> dataList = [];
    arrPlList.forEach((element) {
      List<excelLib.TextCellValue?> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case UserWisePLSummaryColumns.view:
            {
              list.add(excelLib.TextCellValue(""));
            }
          case UserWisePLSummaryColumns.username:
            {
              list.add(excelLib.TextCellValue(element.userName ?? ""));
            }
          case UserWisePLSummaryColumns.sharingPer:
            {
              list.add(excelLib.TextCellValue(element.role == UserRollList.user ? element.profitAndLossSharingDownLine!.toString() : element.profitAndLossSharing!.toString()));
            }
          case UserWisePLSummaryColumns.brkSharingPer:
            {
              list.add(excelLib.TextCellValue(element.role == UserRollList.user ? element.brkSharingDownLine!.toString() : element.brkSharing!.toString()));
            }
          case UserWisePLSummaryColumns.releaseClientPL:
            {
              list.add(excelLib.TextCellValue(element.role == UserRollList.user ? element.profitLoss!.toStringAsFixed(2) : element.childUserProfitLossTotal!.toStringAsFixed(2)));
            }
          case UserWisePLSummaryColumns.clientBrk:
            {
              list.add(excelLib.TextCellValue(element.role == UserRollList.master ? element.childUserBrokerageTotal!.toStringAsFixed(2) : element.brokerageTotal!.toStringAsFixed(2)));
            }
          case UserWisePLSummaryColumns.clientM2M:
            {
              list.add(excelLib.TextCellValue(element.totalProfitLossValue.toStringAsFixed(2)));
            }
          case UserWisePLSummaryColumns.PLWithBrk:
            {
              list.add(excelLib.TextCellValue(element.plWithBrk.toStringAsFixed(2)));
            }
          case UserWisePLSummaryColumns.PLSharePer:
            {
              list.add(excelLib.TextCellValue(element.plSharePer.toStringAsFixed(2)));
            }
          case UserWisePLSummaryColumns.brk:
            {
              list.add(excelLib.TextCellValue(element.parentBrokerageTotal!.toStringAsFixed(2)));
            }
          case UserWisePLSummaryColumns.netPL:
            {
              list.add(excelLib.TextCellValue(element.netPL.toStringAsFixed(2)));
            }

          default:
            {
              list.add(excelLib.TextCellValue(""));
            }
        }
      });
      dataList.add(list);
    });

    exportExcelFile("UserwisePLSummary.xlsx", titleList, dataList);
  }

  onClickPDF() async {
    List<String> headers = [];

    arrListTitle1.forEach((element) {
      headers.add(element.title!);
    });
    List<List<dynamic>> dataList = [];
    arrPlList.forEach((element) {
      List<String> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case UserWisePLSummaryColumns.view:
            {
              list.add((""));
            }
          case UserWisePLSummaryColumns.username:
            {
              list.add((element.userName ?? ""));
            }
          case UserWisePLSummaryColumns.sharingPer:
            {
              list.add((element.role == UserRollList.user ? element.profitAndLossSharingDownLine!.toString() : element.profitAndLossSharing!.toString()));
            }
          case UserWisePLSummaryColumns.brkSharingPer:
            {
              list.add((element.role == UserRollList.user ? element.brkSharingDownLine!.toString() : element.brkSharing!.toString()));
            }
          case UserWisePLSummaryColumns.releaseClientPL:
            {
              list.add((element.role == UserRollList.user ? element.profitLoss!.toStringAsFixed(2) : element.childUserProfitLossTotal!.toStringAsFixed(2)));
            }
          case UserWisePLSummaryColumns.clientBrk:
            {
              list.add((element.role == UserRollList.master ? element.childUserBrokerageTotal!.toStringAsFixed(2) : element.brokerageTotal!.toStringAsFixed(2)));
            }
          case UserWisePLSummaryColumns.clientM2M:
            {
              list.add((element.totalProfitLossValue.toStringAsFixed(2)));
            }
          case UserWisePLSummaryColumns.PLWithBrk:
            {
              list.add((element.plWithBrk.toStringAsFixed(2)));
            }
          case UserWisePLSummaryColumns.PLSharePer:
            {
              list.add((element.plSharePer.toStringAsFixed(2)));
            }
          case UserWisePLSummaryColumns.brk:
            {
              list.add((element.parentBrokerageTotal!.toStringAsFixed(2)));
            }
          case UserWisePLSummaryColumns.netPL:
            {
              list.add((element.netPL.toStringAsFixed(2)));
            }
          default:
            {
              list.add((""));
            }
        }
      });
      dataList.add(list);
    });
    exportPDFFile(fileName: "UserWisePLSummary", title: "User Wise P&L Summary", width: globalMaxWidth, titleList: headers, dataList: dataList);
  }
}
