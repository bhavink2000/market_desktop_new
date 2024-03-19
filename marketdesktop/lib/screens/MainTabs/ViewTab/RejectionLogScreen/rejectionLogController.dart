import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/constantModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/rejectLogLisTModelClass.dart';
import '../../../../constant/index.dart';
import '../../../../constant/screenColumnData.dart';
import 'package:excel/excel.dart' as excelLib;
import '../../../../constant/utilities.dart';
import '../../../../main.dart';

class RejectionLogController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;
  Rx<UserData> selectedUser = UserData().obs;
  RxString selectedTradeStatus = "".obs;
  Rx<Type> selectedStatus = Type().obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  List<ExchangeData> arrExchange = [];
  List<GlobalSymbolData> arrAllScript = [];
  List<RejectLogData> arrRejectLog = [];
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
    getColumnListFromDB(ScreenIds().rejectionLog, arrListTitle1);
    isApiCallRunning = true;
    rejectLogList();
  }

  rejectLogList({bool isFromClear = false, bool isFromFilter = false}) async {
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
    var response = await service.getRejectLogListCall(page: currentPage, startDate: "", endDate: "", userId: selectedUser.value.userId ?? "", exchangeId: selectedExchange.value.exchangeId ?? "", symbolId: selectedScriptFromFilter.value.symbolId ?? "", status: selectedStatus.value.id ?? "");

    isApiCallRunning = false;
    isPagingApiCall = false;
    isResetCall = false;
    totalPage = response!.meta!.totalPage!;
    if (totalPage >= currentPage) {
      currentPage = currentPage + 1;
    }
    update();
    arrRejectLog.addAll(response.data!);
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
          case RejectionLogColumns.date:
            {
              list.add(excelLib.TextCellValue(shortFullDateTime(element.createdAt!)));
            }
          case RejectionLogColumns.status:
            {
              list.add(excelLib.TextCellValue(element.status ?? ""));
            }
          case RejectionLogColumns.username:
            {
              list.add(excelLib.TextCellValue(element.userName ?? ""));
            }
          case RejectionLogColumns.symbol:
            {
              list.add(excelLib.TextCellValue(element.symbolTitle ?? ""));
            }
          case RejectionLogColumns.type:
            {
              list.add(excelLib.TextCellValue(element.tradeTypeValue ?? ""));
            }
          case RejectionLogColumns.qty:
            {
              list.add(excelLib.TextCellValue(element.quantity!.toStringAsFixed(2)));
            }
          case RejectionLogColumns.price:
            {
              list.add(excelLib.TextCellValue(element.price!.toStringAsFixed(2)));
            }
          case RejectionLogColumns.ipAddress:
            {
              list.add(excelLib.TextCellValue(element.ipAddress ?? ""));
            }
          case RejectionLogColumns.deviceId:
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

    exportExcelFile("RejectionLog.xlsx", titleList, dataList);
  }

  onClickPDF() async {
    List<String> headers = [];

    arrListTitle1.forEach((element) {
      headers.add(element.title!);
    });
    List<List<dynamic>> dataList = [];
    arrRejectLog.forEach((element) {
      List<String> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case RejectionLogColumns.date:
            {
              list.add((shortFullDateTime(element.createdAt!)));
            }
          case RejectionLogColumns.status:
            {
              list.add((element.status ?? ""));
            }
          case RejectionLogColumns.username:
            {
              list.add((element.userName ?? ""));
            }
          case RejectionLogColumns.symbol:
            {
              list.add((element.symbolTitle ?? ""));
            }
          case RejectionLogColumns.type:
            {
              list.add((element.tradeTypeValue ?? ""));
            }
          case RejectionLogColumns.qty:
            {
              list.add((element.quantity!.toStringAsFixed(2)));
            }
          case RejectionLogColumns.price:
            {
              list.add((element.price!.toStringAsFixed(2)));
            }
          case RejectionLogColumns.ipAddress:
            {
              list.add((element.ipAddress ?? ""));
            }
          case RejectionLogColumns.deviceId:
            {
              list.add((element.deviceId ?? ""));
            }
          default:
            {
              list.add((""));
            }
        }
      });
      dataList.add(list);
    });
    exportPDFFile(fileName: "RejectionLog", title: "Rejection Log", width: globalMaxWidth - 5.w, titleList: headers, dataList: dataList);
  }
}
