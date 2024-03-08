import 'dart:convert';

import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/getScriptFromSocket.dart';
import 'package:marketdesktop/modelClass/positionModelClass.dart';
import '../../../../constant/index.dart';
import '../../../constant/screenColumnData.dart';
import '../../../constant/utilities.dart';
import '../../../main.dart';
import '../../../modelClass/myUserListModelClass.dart';
import 'package:excel/excel.dart' as excelLib;

class PositionPopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  Rx<UserData> selectedUser = UserData().obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  List<positionListData> arrPositionScriptList = [];
  String selectedUserId = "";
  bool isApiCallRunning = false;
  bool isProfileApiCallRunning = false;

  double totalPL = 0.0;
  RxDouble totalPosition = 0.0.obs;
  FocusNode applyFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  int isBuyOpen = -1;

  bool isResetCall = false;
  int totalPage = 0;
  int currentPage = 1;
  RxBool isValidQty = true.obs;
  bool isPagingApiCall = false;
  bool isAllSelected = false;

  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
    getColumnListFromDB(ScreenIds().userPosition, arrListTitle1);
  }

  num getPlPer({num? cmp, num? netAPrice}) {
    var temp1 = cmp! - netAPrice!;
    var temp2 = temp1 / netAPrice;
    var temp3 = temp2 * 100;
    return temp3;
  }

  getPositionList(String text, {bool isFromfilter = false, bool isFromClear = false}) async {
    arrPositionScriptList.clear();
    update();
    if (isFromfilter) {
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
    var response = await service.positionListCall(currentPage, text, symbolId: selectedScriptFromFilter.value.symbolId ?? "", exchangeId: selectedExchange.value.exchangeId ?? "", userId: selectedUserId);
    arrPositionScriptList = response!.data ?? [];
    isPagingApiCall = false;
    isApiCallRunning = false;
    isResetCall = false;
    update();
    var arrTemp = [];
    for (var element in response.data!) {
      if (!arrSymbolNames.contains(element.symbolName)) {
        arrTemp.insert(0, element.symbolName);
        arrSymbolNames.insert(0, element.symbolName!);
      }
    }

    if (arrTemp.isNotEmpty) {
      var txt = {"symbols": arrTemp};
      socket.connectScript(jsonEncode(txt));
    }
  }

  listenPositionPopUpScriptFromSocket(GetScriptFromSocket socketData) {
    if (socketData.status == true) {
      var obj = arrPositionScriptList.firstWhereOrNull((element) => socketData.data!.symbol == element.symbolName);

      if (obj != null) {
        var indexOfScript = arrPositionScriptList.indexWhere((element) => element.symbolName == socketData.data?.symbol);
        if (indexOfScript != -1) {
          arrPositionScriptList[indexOfScript].scriptDataFromSocket = socketData.data!.obs;
          arrPositionScriptList[indexOfScript].bid = socketData.data!.bid;
          arrPositionScriptList[indexOfScript].ask = socketData.data!.ask;
          arrPositionScriptList[indexOfScript].ltp = socketData.data!.ltp;
          if (indexOfScript == 0) {}

          if (arrPositionScriptList[indexOfScript].currentPriceFromSocket != 0.0) {
            arrPositionScriptList[indexOfScript].profitLossValue = arrPositionScriptList[indexOfScript].tradeTypeValue!.toUpperCase() == "BUY"
                ? (double.parse(socketData.data!.bid.toString()) - arrPositionScriptList[indexOfScript].price!) * arrPositionScriptList[indexOfScript].quantity!
                : (arrPositionScriptList[indexOfScript].price! - double.parse(socketData.data!.ask.toString())) * arrPositionScriptList[indexOfScript].quantity!;
          }
        }
        totalPL = 0.0;

        for (var element in arrPositionScriptList) {
          totalPL = totalPL + element.profitLossValue!;
        }
        totalPL = totalPL + userData!.profitLoss!.toDouble();
        // var mainVc = Get.find<MainContainerController>();
        // mainVc.pl = totalPL.obs;
        // mainVc.update();
        totalPosition.value = 0.0;
        for (var element in arrPositionScriptList) {
          totalPosition.value += element.profitLossValue ?? 0.0;
        }
      }

      update();
    }
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

  onClickExcel({bool isFromPDF = false}) {
    List<excelLib.TextCellValue?> titleList = [];
    arrListTitle1.forEach((element) {
      titleList.add(excelLib.TextCellValue(element.title!));
    });
    List<List<excelLib.TextCellValue?>> dataList = [];
    arrPositionScriptList.forEach((element) {
      List<excelLib.TextCellValue?> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case UserPositionColumns.exchange:
            {
              list.add(excelLib.TextCellValue(element.exchangeName!));
            }
          case UserPositionColumns.symbolName:
            {
              list.add(excelLib.TextCellValue(element.symbolTitle!));
            }
          case UserPositionColumns.totalBuyAQty:
            {
              list.add(excelLib.TextCellValue(element.buyTotalQuantity!.toString()));
            }
          case UserPositionColumns.totalBuyAPrice:
            {
              list.add(excelLib.TextCellValue(element.buyPrice!.toStringAsFixed(2)));
            }
          case UserPositionColumns.totalSellQty:
            {
              list.add(excelLib.TextCellValue(element.sellTotalQuantity!.toString()));
            }
          case UserPositionColumns.sellAPrice:
            {
              list.add(excelLib.TextCellValue(element.sellPrice!.toStringAsFixed(2)));
            }
          case UserPositionColumns.netQty:
            {
              list.add(excelLib.TextCellValue(element.totalQuantity!.toStringAsFixed(2)));
            }
          case UserPositionColumns.netLot:
            {
              list.add(excelLib.TextCellValue(element.quantity!.toString()));
            }
          case UserPositionColumns.netAPrice:
            {
              list.add(excelLib.TextCellValue(element.price!.toStringAsFixed(2)));
            }
          case UserPositionColumns.cmp:
            {
              list.add(excelLib.TextCellValue(element.totalQuantity! < 0 ? element.ask!.toStringAsFixed(2).toString() : element.bid!.toStringAsFixed(2).toString()));
            }
          case UserPositionColumns.pl:
            {
              list.add(excelLib.TextCellValue(element.profitLossValue!.toStringAsFixed(2)));
            }
          case UserPositionColumns.plPerWise:
            {
              list.add(excelLib.TextCellValue(getPlPer(cmp: element.totalQuantity! < 0 ? element.ask! : element.bid!, netAPrice: element.price!).toStringAsFixed(3)));
            }
          default:
            {
              list.add(excelLib.TextCellValue(""));
            }
        }
      });
      dataList.add(list);
    });
    if (isFromPDF) {
      return exportPDFFile("UserPosition", titleList, dataList);
    }
    exportExcelFile("UserPosition.xlsx", titleList, dataList);
  }

  onClickPDF() async {
    var filePath = await onClickExcel(isFromPDF: true);
    generatePdfFromExcel(filePath);
  }
}
