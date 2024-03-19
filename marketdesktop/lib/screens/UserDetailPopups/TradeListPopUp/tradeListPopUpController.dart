import 'package:get/get.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/getScriptFromSocket.dart';
import 'package:marketdesktop/modelClass/myTradeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import '../../../../constant/index.dart';
import '../../../constant/screenColumnData.dart';
import '../../../constant/utilities.dart';
import '../../../modelClass/constantModelClass.dart';
import 'package:excel/excel.dart' as excelLib;

class TradeListPopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;
  List<TradeData> arrTrade = [];
  Rx<UserData> selectedUser = UserData().obs;
  Rx<Type> selectedTradeStatus = Type().obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  int totalSuccessRecord = 0;
  int totalPendingRecord = 0;
  bool isLocalDataLoading = true;
  int pageNumber = 1;
  int totalPage = 0;
  String selectedUserId = "";
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  bool isApiCallRunning = false;
  bool isResetCall = false;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getColumnListFromDB(ScreenIds().userTrade, arrListTitle1);
    arrTradeStatus = constantValues!.tradeStatusFilter ?? [];
    update();
  }

  getTradeList({bool isFromClear = false}) async {
    arrTrade.clear();
    pageNumber = 1;
    update();
    isLocalDataLoading = true;
    String strFromDate = "";
    String strToDate = "";
    if (fromDate.value != "Start Date") {
      strFromDate = fromDate.value;
    }
    if (endDate.value != "End Date") {
      strToDate = endDate.value;
    }
    if (isFromClear) {
      isResetCall = true;
    } else {
      isApiCallRunning = true;
    }
    update();
    var response = await service.getMyTradeListCall(
      status: "executed",
      page: pageNumber,
      text: "",
      userId: selectedUserId,
      tradeStatus: selectedTradeStatus.value.id ?? "",
      symbolId: selectedScriptFromFilter.value.symbolId ?? "",
      exchangeId: selectedExchange.value.exchangeId ?? "",
      startDate: strFromDate,
      endDate: strToDate,
    );
    isLocalDataLoading = false;
    if (response != null) {
      if (response.statusCode == 200) {
        // var arrTemp = [];
        response.data?.forEach((v) {
          arrTrade.add(v);
        });

        isResetCall = false;
        isApiCallRunning = false;
        totalPage = response.meta?.totalPage ?? 0;
        totalSuccessRecord = response.meta?.totalCount ?? 0;
        if (totalPage >= pageNumber) {
          pageNumber = pageNumber + 1;
        }
        update();
        // for (var element in response.data!) {
        //   arrTemp.insert(0, element.symbolName);
        // }

        // if (arrTemp.isNotEmpty) {
        //   var txt = {"symbols": arrTemp};
        //   socket.connectScript(jsonEncode(txt));
        // }
      }
    }
  }

  listenTradePopUpScriptFromSocket(GetScriptFromSocket socketData) {
    if (socketData.status == true) {
      var obj = arrTrade.firstWhereOrNull((element) => socketData.data!.symbol == element.symbolName);

      if (obj != null) {
        for (var i = 0; i < arrTrade.length; i++) {
          if (arrTrade[i].symbolName == socketData.data!.symbol) {
            arrTrade[i].currentPriceFromSocket = arrTrade[i].tradeType == "buy" ? double.parse(socketData.data!.bid.toString()) : double.parse(socketData.data!.ask.toString());
          }
        }
      }
      update();
    }
  }

  Color getPriceColor(String type, double currentPrice, double tradePrice) {
    switch (type) {
      case "buy":
        {
          if (currentPrice > tradePrice) {
            return AppColors().greenColor;
          } else if (currentPrice < tradePrice) {
            return AppColors().redColor;
          } else {
            return AppColors().fontColor;
          }
        }
      case "sell":
        {
          if (currentPrice < tradePrice) {
            return AppColors().greenColor;
          } else if (currentPrice > tradePrice) {
            return AppColors().redColor;
          } else {
            return AppColors().fontColor;
          }
        }

      default:
        {
          return AppColors().darkText;
        }
    }
  }

  num getNetPrice(String isFromBuy, num tradePrice, num brokerage) {
    if (isFromBuy == "buy") {
      return tradePrice + brokerage;
    } else {
      return tradePrice - brokerage;
    }
  }

  Color getProfitLossColor(String isFromBuy, num netPrice, num currentPrice) {
    if (isFromBuy == "buy") {
      if (netPrice > currentPrice) {
        return AppColors().blueColor;
      } else {
        return AppColors().redColor;
      }
    } else {
      if (netPrice > currentPrice) {
        return AppColors().redColor;
      } else {
        return AppColors().blueColor;
      }
    }
  }

  onClickExcel({bool isFromPDF = false}) {
    List<excelLib.TextCellValue?> titleList = [];
    arrListTitle1.forEach((element) {
      titleList.add(excelLib.TextCellValue(element.title!));
    });
    List<List<excelLib.TextCellValue?>> dataList = [];
    arrTrade.forEach((element) {
      List<excelLib.TextCellValue?> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case UserTradeColumns.sequence:
            {
              list.add(excelLib.TextCellValue(element.sequence.toString()));
            }
          case UserTradeColumns.username:
            {
              list.add(excelLib.TextCellValue(element.userName!));
            }
          case UserTradeColumns.parentUser:
            {
              list.add(excelLib.TextCellValue(element.parentUserName!));
            }
          case UserTradeColumns.segment:
            {
              list.add(excelLib.TextCellValue(element.exchangeName!));
            }
          case UserTradeColumns.symbol:
            {
              list.add(excelLib.TextCellValue(element.symbolTitle!));
            }
          case UserTradeColumns.bs:
            {
              list.add(excelLib.TextCellValue(element.tradeTypeValue!));
            }
          case UserTradeColumns.type:
            {
              list.add(excelLib.TextCellValue(element.productTypeValue!));
            }
          case UserTradeColumns.qty:
            {
              list.add(excelLib.TextCellValue(element.quantity.toString()));
            }
          case UserTradeColumns.lot:
            {
              list.add(excelLib.TextCellValue(element.totalQuantity.toString()));
            }
          case UserTradeColumns.totalQty:
            {
              list.add(excelLib.TextCellValue(element.totalQuantity.toString()));
            }
          case UserTradeColumns.validity:
            {
              list.add(excelLib.TextCellValue(element.productTypeValue.toString()));
            }
          case UserTradeColumns.tradePrice:
            {
              list.add(excelLib.TextCellValue(element.price!.toStringAsFixed(2)));
            }
          case UserTradeColumns.brk:
            {
              list.add(excelLib.TextCellValue(element.brokerageAmount!.toStringAsFixed(2)));
            }
          case UserTradeColumns.netPrice:
            {
              list.add(excelLib.TextCellValue(getNetPrice(element.tradeType!, element.price ?? 0, (element.brokerageAmount! / element.totalQuantity!)).toStringAsFixed(2)));
            }
          case UserTradeColumns.orderDT:
            {
              list.add(excelLib.TextCellValue(shortFullDateTime(element.createdAt!)));
            }
          case UserTradeColumns.executionDT:
            {
              list.add(excelLib.TextCellValue(shortFullDateTime(element.executionDateTime!)));
            }
          case UserTradeColumns.refPrice:
            {
              list.add(excelLib.TextCellValue(element.referencePrice!.toStringAsFixed(2)));
            }
          case UserTradeColumns.ipAddress:
            {
              list.add(excelLib.TextCellValue(element.ipAddress!));
            }
          case UserTradeColumns.device:
            {
              list.add(excelLib.TextCellValue(element.orderMethod!));
            }
          case UserTradeColumns.deviceId:
            {
              list.add(excelLib.TextCellValue(element.deviceId!));
            }

          default:
            {
              list.add(excelLib.TextCellValue(""));
            }
        }
      });
      dataList.add(list);
    });

    exportExcelFile("UserTrades.xlsx", titleList, dataList);
  }

  onClickPDF() async {
    List<String> headers = [];

    arrListTitle1.forEach((element) {
      headers.add(element.title!);
    });
    List<List<dynamic>> dataList = [];
    arrTrade.forEach((element) {
      List<String> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case UserTradeColumns.sequence:
            {
              list.add((element.sequence.toString()));
            }
          case UserTradeColumns.username:
            {
              list.add((element.userName!));
            }
          case UserTradeColumns.parentUser:
            {
              list.add((element.parentUserName!));
            }
          case UserTradeColumns.segment:
            {
              list.add((element.exchangeName!));
            }
          case UserTradeColumns.symbol:
            {
              list.add((element.symbolTitle!));
            }
          case UserTradeColumns.bs:
            {
              list.add((element.tradeTypeValue!));
            }
          case UserTradeColumns.type:
            {
              list.add((element.productTypeValue!));
            }
          case UserTradeColumns.qty:
            {
              list.add((element.quantity.toString()));
            }
          case UserTradeColumns.lot:
            {
              list.add((element.totalQuantity.toString()));
            }
          case UserTradeColumns.totalQty:
            {
              list.add((element.totalQuantity.toString()));
            }
          case UserTradeColumns.validity:
            {
              list.add((element.productTypeValue.toString()));
            }
          case UserTradeColumns.tradePrice:
            {
              list.add((element.price!.toStringAsFixed(2)));
            }
          case UserTradeColumns.brk:
            {
              list.add((element.brokerageAmount!.toStringAsFixed(2)));
            }
          case UserTradeColumns.netPrice:
            {
              list.add((getNetPrice(element.tradeType!, element.price ?? 0, (element.brokerageAmount! / element.totalQuantity!)).toStringAsFixed(2)));
            }
          case UserTradeColumns.orderDT:
            {
              list.add((shortFullDateTime(element.createdAt!)));
            }
          case UserTradeColumns.executionDT:
            {
              list.add((shortFullDateTime(element.executionDateTime!)));
            }
          case UserTradeColumns.refPrice:
            {
              list.add((element.referencePrice!.toStringAsFixed(2)));
            }
          case UserTradeColumns.ipAddress:
            {
              list.add((element.ipAddress!));
            }
          case UserTradeColumns.device:
            {
              list.add((element.orderMethod!));
            }
          case UserTradeColumns.deviceId:
            {
              list.add((element.deviceId!));
            }
          default:
            {
              list.add((""));
            }
        }
      });
      dataList.add(list);
    });
    exportPDFFile(fileName: "UserTrades", title: "Trades", width: globalMaxWidth, titleList: headers, dataList: dataList);
  }
}
