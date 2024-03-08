import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/rejectLogLisTModelClass.dart';
import '../../../../constant/index.dart';
import '../../../constant/screenColumnData.dart';
import 'package:excel/excel.dart' as excelLib;

import '../../../constant/utilities.dart';

class RejectionLogPopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  RxString fromDate = "".obs;
  RxString endDate = "".obs;
  List<RejectLogData> arrRejectLog = [];
  Rx<UserData> selectedUser = UserData().obs;
  RxString selectedTradeStatus = "".obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  bool isApiCallRunning = false;
  String selectedUserId = "";
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getColumnListFromDB(ScreenIds().userRejectionLog, arrListTitle1);
  }

  rejectLogList() async {
    arrRejectLog.clear();
    isApiCallRunning = true;
    update();
    var response = await service.getRejectLogListCall(page: 1, startDate: "", endDate: "", userId: selectedUserId, exchangeId: selectedExchange.value.exchangeId ?? "", symbolId: selectedScriptFromFilter.value.symbolId ?? "");

    isApiCallRunning = false;
    update();
    arrRejectLog = response!.data ?? [];
    update();
  }

  onClickExcel({bool isFromPDF = false}) {
    List<excelLib.TextCellValue?> titleList = [];
    arrListTitle1.forEach((element) {
      titleList.add(excelLib.TextCellValue(element.title!));
    });
    List<List<excelLib.TextCellValue?>> dataList = [];
    arrRejectLog.forEach((element) {
      List<excelLib.TextCellValue?> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case UserRejectionLogColumns.date:
            {
              list.add(excelLib.TextCellValue(shortFullDateTime(element.createdAt!)));
            }
          case UserRejectionLogColumns.message:
            {
              list.add(excelLib.TextCellValue(element.status ?? ""));
            }
          case UserRejectionLogColumns.username:
            {
              list.add(excelLib.TextCellValue(element.userName ?? ""));
            }
          case UserRejectionLogColumns.symbol:
            {
              list.add(excelLib.TextCellValue(element.symbolTitle ?? ""));
            }
          case UserRejectionLogColumns.type:
            {
              list.add(excelLib.TextCellValue(element.tradeTypeValue ?? ""));
            }
          case UserRejectionLogColumns.qty:
            {
              list.add(excelLib.TextCellValue(element.quantity!.toStringAsFixed(2)));
            }
          case UserRejectionLogColumns.price:
            {
              list.add(excelLib.TextCellValue(element.price!.toStringAsFixed(2)));
            }
          case UserRejectionLogColumns.ipAddress:
            {
              list.add(excelLib.TextCellValue(element.ipAddress ?? ""));
            }
          case UserRejectionLogColumns.deviceId:
            {
              list.add(excelLib.TextCellValue(element.deviceId ?? ""));
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
      return exportPDFFile("UserRejectionLog", titleList, dataList);
    }
    exportExcelFile("UserRejectionLog.xlsx", titleList, dataList);
  }

  onClickPDF() async {
    var filePath = await onClickExcel(isFromPDF: true);
    generatePdfFromExcel(filePath);
  }
}
