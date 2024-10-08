import 'dart:convert';

import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/accountSummaryNewListModelClass.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import '../../../../constant/index.dart';
import '../../../../constant/screenColumnData.dart';
import '../../../../constant/utilities.dart';
import '../../../../main.dart';
import '../../../../modelClass/constantModelClass.dart';
import '../../../../modelClass/getScriptFromSocket.dart';
import 'package:excel/excel.dart' as excelLib;

class SymbolWisePositionReportController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  RxString fromDate = "".obs;
  RxString endDate = "".obs;
  Rx<UserData> selectedUser = UserData().obs;
  Rx<String> selectedplType = "All".obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  List<AccountSummaryNewListData> arrSummaryList = [];
  // Rx<positionListData>? selectedScript;
  List<UserData> arrUserListOnlyClient = [];

  RxBool isTradeCallFinished = true.obs;
  double visibleWidth = 0.0;
  RxDouble plTotal = 0.0.obs;
  RxDouble plPerTotal = 0.0.obs;
  RxDouble brkPerTotal = 0.0.obs;
  RxDouble brkTotal = 0.0.obs;
  RxDouble netQtyPerTotal = 0.0.obs;

  Rx<Type> selectedValidity = Type().obs;
  final FocusNode focusNode = FocusNode();
  final FocusNode popUpfocusNode = FocusNode();
  List<Type> arrOrderType = [];
  final debouncer = Debouncer(milliseconds: 300);
  bool isKeyPressActive = false;

  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();

  int selectedScriptIndex = -1;
  Rx<Type> selectedProductType = Type().obs;

  bool isApiCallRunning = false;
  bool isResetCall = false;
  int totalPage = 0;
  int currentPage = 1;

  bool isPagingApiCall = false;

  FocusNode SubmitFocus = FocusNode();
  FocusNode CancelFocus = FocusNode();

  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
    getColumnListFromDB(ScreenIds().symbolWisePositionReport, arrListTitle1);
    // isApiCallRunning = true;

    // getAccountSummaryNewList("");
    getUserList();
    update();
  }

  getUserList() async {
    var response = await service.getMyUserListCall(roleId: UserRollList.user);
    arrUserListOnlyClient = response!.data ?? [];
    if (arrUserListOnlyClient.isNotEmpty) {
      // selectedUser.value = arrUserListOnlyClient.first;
    }
  }

  getAccountSummaryNewList(String text, {bool isFromfilter = false, bool isFromClear = false}) async {
    if (isFromfilter) {
      currentPage = 1;
      arrSummaryList.clear();
      if (isFromClear) {
        isResetCall = true;
      } else {
        isApiCallRunning = true;
      }
    }
    if (isPagingApiCall) {
      return;
    }
    isPagingApiCall = true;
    update();
    var response = await service.symbolWisePositionListCall(currentPage, text,
        userId: selectedUser.value.userId ?? "", startDate: fromDate.value, endDate: endDate.value, symbolId: selectedScriptFromFilter.value.symbolId ?? "", exchangeId: selectedExchange.value.exchangeId ?? "", productType: selectedProductType.value.id ?? "");
    arrSummaryList.addAll(response!.data!);
    isPagingApiCall = false;
    isResetCall = false;
    totalPage = response.meta!.totalPage!.toInt();
    if (totalPage >= currentPage) {
      currentPage = currentPage + 1;
    }
    for (var indexOfScript = 0; indexOfScript < arrSummaryList.length; indexOfScript++) {
      arrSummaryList[indexOfScript].currentPriceFromSocket = arrSummaryList[indexOfScript].totalQuantity! < 0 ? arrSummaryList[indexOfScript].ask!.toDouble() : arrSummaryList[indexOfScript].bid!.toDouble();
      arrSummaryList[indexOfScript].profitLossValue = arrSummaryList[indexOfScript].totalQuantity! < 0
          ? (double.parse(arrSummaryList[indexOfScript].ask!.toStringAsFixed(2)) - arrSummaryList[indexOfScript].avgPrice!) * arrSummaryList[indexOfScript].totalQuantity!
          : (double.parse(arrSummaryList[indexOfScript].bid!.toStringAsFixed(2)) - double.parse(arrSummaryList[indexOfScript].avgPrice!.toStringAsFixed(2))) * arrSummaryList[indexOfScript].totalQuantity!;

      arrSummaryList[indexOfScript].plPerValue = arrSummaryList[indexOfScript].totalShareQuantity! < 0
          ? (double.parse(arrSummaryList[indexOfScript].ask!.toStringAsFixed(2)) - arrSummaryList[indexOfScript].avgPrice!) * arrSummaryList[indexOfScript].totalShareQuantity!
          : (double.parse(arrSummaryList[indexOfScript].bid!.toStringAsFixed(2)) - double.parse(arrSummaryList[indexOfScript].avgPrice!.toStringAsFixed(2))) * arrSummaryList[indexOfScript].totalShareQuantity!;
    }
    plTotal = 0.0.obs;
    plPerTotal = 0.0.obs;
    brkPerTotal = 0.0.obs;
    brkTotal = 0.0.obs;
    netQtyPerTotal = 0.0.obs;
    arrSummaryList.forEach((element) {
      plTotal.value = plTotal.value + element.profitLossValue!;

      var temp = ((element.profitLossValue! * element.profitAndLossSharing!) / 100);
      plPerTotal.value = (plPerTotal.value + temp) * -1;
      brkPerTotal.value = brkPerTotal.value + element.adminBrokerageTotal!;
      netQtyPerTotal.value = netQtyPerTotal.value + element.totalShareQuantity!;
      brkTotal.value = brkTotal.value + element.brokerageTotal!;
    });
    isApiCallRunning = false;
    update();
    var arrTemp = [];
    for (var element in response.data!) {
      if (!arrSymbolNames.contains(element.symbolName)) {
        arrTemp.insert(0, element.symbolName);
        arrSymbolNames.insert(0, element.symbolName!);
      }
    }

    if (arrSymbolNames.isNotEmpty) {
      var txt = {"symbols": arrSymbolNames};
      socket.connectScript(jsonEncode(txt));
    }
  }

  double getTotal(bool isBuy) {
    var total = 0.0;
    if (isBuy) {
      for (var element in arrSummaryList[selectedScriptIndex].scriptDataFromSocket.value.depth!.buy!) {
        total = total + element.price!;
      }
    } else {
      for (var element in arrSummaryList[selectedScriptIndex].scriptDataFromSocket.value.depth!.sell!) {
        total = total + element.price!;
      }
    }
    return total;
  }

  Color getPriceColor(double value) {
    if (value == 0.0) {
      return AppColors().fontColor;
    }
    if (value > 0.0) {
      return AppColors().greenColor;
    } else if (value < 0.0) {
      return AppColors().redColor;
    } else {
      return AppColors().fontColor;
    }
  }

  num getPlPer({num? cmp, num? netAPrice}) {
    var temp1 = cmp! - netAPrice!;
    var temp2 = temp1 / netAPrice;
    var temp3 = temp2 * 100;
    return temp3;
  }

  listenSymbolWisePositionScriptFromSocket(GetScriptFromSocket socketData) {
    if (socketData.status == true) {
      var obj = arrSummaryList.firstWhereOrNull((element) => socketData.data!.symbol == element.symbolName);

      if (obj != null) {
        var indexOfScript = arrSummaryList.indexWhere((element) => element.symbolName == socketData.data?.symbol);
        if (indexOfScript != -1) {
          arrSummaryList[indexOfScript].scriptDataFromSocket = socketData.data!.obs;
          arrSummaryList[indexOfScript].bid = socketData.data!.bid!.toDouble();
          arrSummaryList[indexOfScript].ask = socketData.data!.ask!.toDouble();
          arrSummaryList[indexOfScript].ltp = socketData.data!.ltp!.toDouble();
          arrSummaryList[indexOfScript].currentPriceFromSocket = socketData.data!.ltp!.toDouble();
          if (indexOfScript == 0) {}

          if (arrSummaryList[indexOfScript].currentPriceFromSocket != 0.0) {
            arrSummaryList[indexOfScript].profitLossValue = arrSummaryList[indexOfScript].totalQuantity! < 0
                ? (double.parse(arrSummaryList[indexOfScript].ask!.toStringAsFixed(2)) - arrSummaryList[indexOfScript].avgPrice!) * arrSummaryList[indexOfScript].totalQuantity!
                : (double.parse(arrSummaryList[indexOfScript].bid!.toStringAsFixed(2)) - double.parse(arrSummaryList[indexOfScript].avgPrice!.toStringAsFixed(2))) * arrSummaryList[indexOfScript].totalQuantity!;

            arrSummaryList[indexOfScript].plPerValue = arrSummaryList[indexOfScript].totalShareQuantity! < 0
                ? (double.parse(arrSummaryList[indexOfScript].ask!.toStringAsFixed(2)) - arrSummaryList[indexOfScript].avgPrice!) * arrSummaryList[indexOfScript].totalShareQuantity!
                : (double.parse(arrSummaryList[indexOfScript].bid!.toStringAsFixed(2)) - double.parse(arrSummaryList[indexOfScript].avgPrice!.toStringAsFixed(2))) * arrSummaryList[indexOfScript].totalShareQuantity!;
          }
        }
      }
      plTotal = 0.0.obs;
      plPerTotal = 0.0.obs;
      brkPerTotal = 0.0.obs;
      brkTotal = 0.0.obs;
      netQtyPerTotal = 0.0.obs;
      arrSummaryList.forEach((element) {
        plTotal.value = plTotal.value + element.profitLossValue!;

        var temp = ((element.profitLossValue! * element.profitAndLossSharing!) / 100);
        plPerTotal.value = (plPerTotal.value + temp) * -1;
        brkPerTotal.value = brkPerTotal.value + element.adminBrokerageTotal!;
        netQtyPerTotal.value = netQtyPerTotal.value + element.totalShareQuantity!;
        brkTotal.value = brkTotal.value + element.brokerageTotal!;
      });
      update();
    }
  }

  onClickExcel({bool isFromPDF = false}) {
    List<excelLib.TextCellValue?> titleList = [];
    arrListTitle1.forEach((element) {
      titleList.add(excelLib.TextCellValue(element.title!));
    });
    List<List<excelLib.TextCellValue?>> dataList = [];
    arrSummaryList.forEach((element) {
      List<excelLib.TextCellValue?> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case SymbolWisePositionReportColumns.exchange:
            {
              list.add(excelLib.TextCellValue(element.exchangeName ?? ""));
            }
          case SymbolWisePositionReportColumns.symbol:
            {
              list.add(excelLib.TextCellValue(element.symbolTitle ?? ""));
            }
          case SymbolWisePositionReportColumns.netQty:
            {
              list.add(excelLib.TextCellValue(element.totalQuantity.toString()));
            }
          case SymbolWisePositionReportColumns.netQtyPerWise:
            {
              list.add(excelLib.TextCellValue(element.totalShareQuantity!.toStringAsFixed(2)));
            }
          case SymbolWisePositionReportColumns.netAPrice:
            {
              list.add(excelLib.TextCellValue(element.totalQuantity! != 0 ? element.avgPrice!.toStringAsFixed(2) : "0.00"));
            }
          case SymbolWisePositionReportColumns.brk:
            {
              list.add(excelLib.TextCellValue(element.brokerageTotal!.toStringAsFixed(2)));
            }
          case SymbolWisePositionReportColumns.withBrkAPrice:
            {
              list.add(excelLib.TextCellValue(element.totalQuantity! != 0
                  ? element.brokerageTotal! > 0
                      ? (element.avgPrice! + (element.brokerageTotal! / element.totalQuantity!)).toStringAsFixed(2)
                      : element.avgPrice!.toStringAsFixed(2)
                  : "0.00"));
            }
          case SymbolWisePositionReportColumns.cmp:
            {
              list.add(excelLib.TextCellValue(element.currentPriceFromSocket!.toStringAsFixed(2)));
            }
          case SymbolWisePositionReportColumns.pl:
            {
              list.add(excelLib.TextCellValue(element.profitLossValue!.toStringAsFixed(2)));
            }

          case SymbolWisePositionReportColumns.plPer:
            {
              list.add(excelLib.TextCellValue((((element.profitLossValue! * element.profitAndLossSharing!) / 100) * -1).toStringAsFixed(2)));
            }

          case SymbolWisePositionReportColumns.brkPer:
            {
              list.add(excelLib.TextCellValue(element.adminBrokerageTotal!.toStringAsFixed(2)));
            }

          default:
            {
              list.add(excelLib.TextCellValue(""));
            }
        }
      });
      dataList.add(list);
    });

    exportExcelFile("SymbolWisePositionReport.xlsx", titleList, dataList);
  }

  onClickPDF() async {
    List<String> headers = [];

    arrListTitle1.forEach((element) {
      headers.add(element.title!);
    });
    List<List<dynamic>> dataList = [];
    arrSummaryList.forEach((element) {
      List<String> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case SymbolWisePositionReportColumns.exchange:
            {
              list.add((element.exchangeName ?? ""));
            }
          case SymbolWisePositionReportColumns.symbol:
            {
              list.add((element.symbolTitle ?? ""));
            }
          case SymbolWisePositionReportColumns.netQty:
            {
              list.add((element.totalQuantity.toString()));
            }
          case SymbolWisePositionReportColumns.netQtyPerWise:
            {
              list.add((element.totalShareQuantity!.toStringAsFixed(2)));
            }
          case SymbolWisePositionReportColumns.netAPrice:
            {
              list.add((element.totalQuantity! != 0 ? element.avgPrice!.toStringAsFixed(2) : "0.00"));
            }
          case SymbolWisePositionReportColumns.brk:
            {
              list.add((element.brokerageTotal!.toStringAsFixed(2)));
            }
          case SymbolWisePositionReportColumns.withBrkAPrice:
            {
              list.add((element.totalQuantity! != 0
                  ? element.brokerageTotal! > 0
                      ? (element.avgPrice! + (element.brokerageTotal! / element.totalQuantity!)).toStringAsFixed(2)
                      : element.avgPrice!.toStringAsFixed(2)
                  : "0.00"));
            }
          case SymbolWisePositionReportColumns.cmp:
            {
              list.add((element.currentPriceFromSocket!.toStringAsFixed(2)));
            }
          case SymbolWisePositionReportColumns.pl:
            {
              list.add((element.profitLossValue!.toStringAsFixed(2)));
            }

          case SymbolWisePositionReportColumns.plPer:
            {
              list.add(((((element.profitLossValue! * element.profitAndLossSharing!) / 100) * -1).toStringAsFixed(2)));
            }

          case SymbolWisePositionReportColumns.brkPer:
            {
              list.add((element.adminBrokerageTotal!.toStringAsFixed(2)));
            }

          default:
            {
              list.add((""));
            }
        }
      });
      dataList.add(list);
    });
    exportPDFFile(fileName: "SymbolWisePositionReport", title: "Symbol Wise Position Report", width: globalMaxWidth, titleList: headers, dataList: dataList);
  }
}
