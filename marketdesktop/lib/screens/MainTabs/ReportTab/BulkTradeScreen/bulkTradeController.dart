import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/bulkTradeModelClass.dart';
import 'package:marketdesktop/modelClass/constantModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import '../../../../constant/index.dart';
import '../../../../constant/screenColumnData.dart';
import 'package:excel/excel.dart' as excelLib;

import '../../../../constant/utilities.dart';
import '../../../../main.dart';
import '../../ViewTab/MarketWatchScreen/marketWatchController.dart';
import '../../ViewTab/TradeScreen/successTradeListController.dart';
import '../../ViewTab/TradeScreen/successTradeListWrapper.dart';

class BulkTradeController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  Rx<UserData> selectedUser = UserData().obs;
  RxString selectedTradeStatus = "".obs;
  Rx<Type> selectedStatus = Type().obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  List<ExchangeData> arrExchange = [];
  List<GlobalSymbolData> arrAllScript = [];
  List<BulkTradeData> arrBulkTrade = [];
  bool isApiCallRunning = false;
  bool isResetCall = false;
  String selectedUserId = "";
  int totalPage = 0;
  int currentPage = 1;
  bool isPagingApiCall = false;
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getColumnListFromDB(ScreenIds().bulkTrade, arrListTitle1);
    isApiCallRunning = true;
    bulkTradeList();
  }

  bulkTradeList({bool isFromClear = false, bool isFromFilter = false}) async {
    if (isFromFilter) {
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
    var response = await service.bulkTradeListCall(currentPage, selectedExchange.value.exchangeId ?? "", selectedScriptFromFilter.value.symbolId ?? "", selectedUser.value.userId ?? "");

    isApiCallRunning = false;
    isPagingApiCall = false;
    isResetCall = false;
    totalPage = response!.meta!.totalPage!;
    if (totalPage >= currentPage) {
      currentPage = currentPage + 1;
    }
    update();
    arrBulkTrade.addAll(response.data!);
    update();
  }

  redirectTradeScreen(BulkTradeData values) async {
    var marketViewObj = Get.find<MarketWatchController>();
    if (marketViewObj.isBuyOpen != -1) {
      return;
    }

    isCommonScreenPopUpOpen = true;
    currentOpenedScreen = ScreenViewNames.trades;
    var tradeVC = Get.put(SuccessTradeListController());
    tradeVC.selectedExchange.value.exchangeId = values.exchangeId!;
    tradeVC.selectedExchange.value.name = values.exchangeName!;
    tradeVC.selectedScriptFromFilter.value.symbolId = values.symbolId!;
    tradeVC.selectedScriptFromFilter.value.symbolName = values.symbolName!;
    tradeVC.selectedScriptFromFilter.value.symbolTitle = values.symbolTitle!;

    generalContainerPopup(view: SuccessTradeListScreen(), title: ScreenViewNames.trades);
  }

  onClickExcel({bool isFromPDF = false}) {
    List<excelLib.TextCellValue?> titleList = [];
    arrListTitle1.forEach((element) {
      titleList.add(excelLib.TextCellValue(element.title!));
    });
    List<List<excelLib.TextCellValue?>> dataList = [];
    arrBulkTrade.forEach((element) {
      List<excelLib.TextCellValue?> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case BulkTradeColumns.exchange:
            {
              list.add(excelLib.TextCellValue(element.exchangeName!));
            }
          case BulkTradeColumns.symbol:
            {
              list.add(excelLib.TextCellValue(element.symbolTitle!));
            }
          case BulkTradeColumns.buyTotalQty:
            {
              list.add(excelLib.TextCellValue(element.buyTotalQuantity.toString()));
            }
          case BulkTradeColumns.sellTotalQty:
            {
              list.add(excelLib.TextCellValue(element.sellTotalQuantity.toString()));
            }
          case BulkTradeColumns.totalQty:
            {
              list.add(excelLib.TextCellValue(element.totalQuantity.toString()));
            }
          case BulkTradeColumns.dateTime:
            {
              list.add(excelLib.TextCellValue(shortFullDateTime(element.endDate!)));
            }
          default:
            {
              list.add(excelLib.TextCellValue(""));
            }
        }
      });
      dataList.add(list);
    });

    exportExcelFile("BulkTrade.xlsx", titleList, dataList);
  }

  onClickPDF() async {
    List<String> headers = [];

    arrListTitle1.forEach((element) {
      headers.add(element.title!);
    });
    List<List<dynamic>> dataList = [];
    arrBulkTrade.forEach((element) {
      List<String> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
           case BulkTradeColumns.exchange:
            {
              list.add((element.exchangeName!));
            }
          case BulkTradeColumns.symbol:
            {
              list.add((element.symbolTitle!));
            }
          case BulkTradeColumns.buyTotalQty:
            {
              list.add((element.buyTotalQuantity.toString()));
            }
          case BulkTradeColumns.sellTotalQty:
            {
              list.add((element.sellTotalQuantity.toString()));
            }
          case BulkTradeColumns.totalQty:
            {
              list.add((element.totalQuantity.toString()));
            }
          case BulkTradeColumns.dateTime:
            {
              list.add((shortFullDateTime(element.endDate!)));
            }
          default:
            {
              list.add((""));
            }
        }
      });
      dataList.add(list);
    });
    exportPDFFile(fileName: "BulkTrades", title: "Bulk Trades", width: globalMaxWidth, titleList: headers, dataList: dataList);
  }
}
