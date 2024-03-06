import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myTradeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/tradeLogsModelClass.dart';
import '../../../../constant/index.dart';
import '../../../../constant/screenColumnData.dart';
import 'package:excel/excel.dart' as excelLib;

import '../../../../constant/utilities.dart';

class TradeLogController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;
  int selectedOrderIndex = -1;

  Rx<UserData> selectedUser = UserData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  ScrollController listcontroller = ScrollController();
  List<TradeLogData> arrTrade = [];
  TradeData? selectedTrade;
  bool isLocalDataLoading = true;
  bool isApiCallRunning = false;
  bool isResetCall = false;
  bool isSuccessSelected = true;
  int totalSuccessRecord = 0;
  int totalPendingRecord = 0;
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  int pageNumber = 1;
  int totalPage = 0;
  bool isPagingApiCall = false;
  int currentPage = 1;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getColumnListFromDB(ScreenIds().tradeLog, arrListTitle1);
    getTradeList();
  }

  getTradeList({bool isFromClear = false}) async {
    arrTrade.clear();
    pageNumber = 1;

    isLocalDataLoading = true;
    if (isFromClear) {
      isResetCall = true;
    } else {
      isApiCallRunning = true;
    }

    String strFromDate = "";
    String strToDate = "";
    update();
    if (fromDate.value != "Start Date") {
      strFromDate = fromDate.value;
    }
    if (endDate.value != "End Date") {
      strToDate = endDate.value;
    }
    if (isPagingApiCall) {
      return;
    }
    isPagingApiCall = true;
    update();
    var response = await service.tradeLogsListCall(
      pageNumber,
      search: "",
      userId: selectedUser.value.userId ?? "",
      symbolId: selectedScriptFromFilter.value.symbolId ?? "",
      exchangeId: selectedExchange.value.exchangeId ?? "",
      startDate: strFromDate,
      endDate: strToDate,
    );

    arrTrade.addAll(response!.data!);
    isApiCallRunning = false;
    isPagingApiCall = false;
    isResetCall = false;
    totalPage = response.meta!.totalPage!;
    if (totalPage >= currentPage) {
      currentPage = currentPage + 1;
    }
    update();
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
          case TradeLogsColumns.username:
            {
              list.add(excelLib.TextCellValue(element.userName ?? ""));
            }
          case TradeLogsColumns.exchange:
            {
              list.add(excelLib.TextCellValue(element.exchangeName ?? ""));
            }
          case TradeLogsColumns.symbol:
            {
              list.add(excelLib.TextCellValue(element.symbolTitle ?? ""));
            }
          case TradeLogsColumns.oldUpdateType:
            {
              list.add(excelLib.TextCellValue(element.oldOrderTypeValue ?? ""));
            }
          case TradeLogsColumns.updateType:
            {
              list.add(excelLib.TextCellValue(element.orderTypeValue ?? ""));
            }
          case TradeLogsColumns.updateTime:
            {
              list.add(excelLib.TextCellValue(shortFullDateTime(element.updatedAt!)));
            }

          case TradeLogsColumns.modifyBy:
            {
              list.add(excelLib.TextCellValue(element.userUpdatedName!));
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
      return exportPDFFile("TradeLogs", titleList, dataList);
    }
    exportExcelFile("TradeLogs.xlsx", titleList, dataList);
  }

  onClickPDF() async {
    var filePath = await onClickExcel(isFromPDF: true);
    generatePdfFromExcel(filePath);
  }
}
