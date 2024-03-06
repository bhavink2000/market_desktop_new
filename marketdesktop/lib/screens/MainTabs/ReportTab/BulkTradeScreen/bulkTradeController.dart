import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/bulkTradeModelClass.dart';
import 'package:marketdesktop/modelClass/constantModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/rejectLogLisTModelClass.dart';
import '../../../../constant/index.dart';
import '../../../../constant/screenColumnData.dart';
import 'package:excel/excel.dart' as excelLib;

import '../../../../constant/utilities.dart';

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

          default:
            {
              list.add(excelLib.TextCellValue(""));
            }
        }
      });
      dataList.add(list);
    });
    if (isFromPDF) {
      return exportPDFFile("BulkTrade", titleList, dataList);
    }
    exportExcelFile("BulkTrade.xlsx", titleList, dataList);
  }

  onClickPDF() async {
    var filePath = await onClickExcel(isFromPDF: true);
    generatePdfFromExcel(filePath);
  }
}
