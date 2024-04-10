import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/settelementListModelClass.dart';
import 'package:excel/excel.dart' as excelLib;
import '../../../../constant/index.dart';
import '../../../../constant/screenColumnData.dart';
import '../../../../constant/utilities.dart';
import '../../../../main.dart';

class SettlementController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;
  List<Profit> arrProfitList = [];
  List<Profit> arrLossList = [];
  String selectedUserId = "";
  Rx<UserData> selectedUser = UserData().obs;
  SettelementData? totalValues;
  bool isApiCallFromSearch = false;
  bool isApiCallFromReset = false;
  bool isApiCallFirstTime = false;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  FocusNode submitFocus = FocusNode();
  DateTime thisWeekStartDate = DateTime.now().subtract(Duration(days: DateTime.now().weekday));
  Rx<DateTime> fromDateValue = DateTime.now().obs;
  RxString selectStatusdropdownValue = "".obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getColumnListFromDB(ScreenIds().settlement, arrListTitle1);
    fromDate.value = shortDateForBackend(findFirstDateOfTheWeek(DateTime.now()));
    endDate.value = shortDateForBackend(findLastDateOfTheWeek(DateTime.now()));
    getSettelementList();
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  getSettelementList({int isFrom = 0}) async {
    if (isFrom == 0) {
      isApiCallFirstTime = true;
    } else if (isFrom == 1) {
      isApiCallFromSearch = true;
    } else {
      isApiCallFromReset = true;
    }
    if (selectStatusdropdownValue.toString().isNotEmpty) {
      if (selectStatusdropdownValue.toString() != 'Custom Period') {
        String thisWeekDateRange = "$selectStatusdropdownValue";
        List<String> dateParts = thisWeekDateRange.split(" to ");
        fromDate = dateParts[0].trim().split('Week').last.obs;
        endDate = dateParts[1].obs;
      } else {
        // fromDate = '';
        // toDate = '';
      }
    }
    update();
    var response = await service.settelementListCall(1, fromDate.value != "Start Date" ? fromDate.value : "", endDate.value != "End Date" ? endDate.value : "");
    if (isFrom == 0) {
      isApiCallFirstTime = false;
    } else if (isFrom == 1) {
      isApiCallFromSearch = false;
    } else {
      isApiCallFromReset = false;
    }
    arrProfitList = response!.data?.profit ?? [];
    arrLossList = response.data?.loss ?? [];
    totalValues = response.data!;
    for (var element in arrProfitList) {
      totalValues!.plProfitGrandTotal = totalValues!.plProfitGrandTotal + element.profitLoss!;
      totalValues!.brkProfitGrandTotal = totalValues!.brkProfitGrandTotal + element.brokerageTotal!;
      totalValues!.profitGrandTotal = totalValues!.profitGrandTotal + element.total!;
    }

    for (var element in arrLossList) {
      totalValues!.plLossGrandTotal = totalValues!.plLossGrandTotal + element.profitLoss!;
      totalValues!.brkLossGrandTotal = totalValues!.brkLossGrandTotal + element.brokerageTotal!;
      totalValues!.LossGrandTotal = totalValues!.LossGrandTotal + element.total!;
    }

    update();
  }

  onClickExcel({bool isFromPDF = false}) {
    List<excelLib.TextCellValue?> titleList = [];
    arrListTitle1.forEach((element) {
      titleList.add(excelLib.TextCellValue(element.title!));
    });
    List<List<excelLib.TextCellValue?>> dataList1 = [];
    List<List<excelLib.TextCellValue?>> dataList2 = [];
    arrProfitList.forEach((element) {
      List<excelLib.TextCellValue?> list1 = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case SettlementColumns.username:
            {
              list1.add(excelLib.TextCellValue(element.displayName ?? ""));
            }

          case SettlementColumns.pl:
            {
              list1.add(excelLib.TextCellValue(element.profitLoss!.toStringAsFixed(2)));
            }
          case SettlementColumns.brk:
            {
              list1.add(excelLib.TextCellValue(element.brokerageTotal!.toStringAsFixed(2)));
            }
          case SettlementColumns.total:
            {
              list1.add(excelLib.TextCellValue(element.total!.toStringAsFixed(2)));
            }
          default:
            {
              list1.add(excelLib.TextCellValue(""));
            }
        }
      });
      dataList1.add(list1);
    });
    arrLossList.forEach((element) {
      List<excelLib.TextCellValue?> list1 = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case SettlementColumns.username:
            {
              list1.add(excelLib.TextCellValue(element.displayName ?? ""));
            }

          case SettlementColumns.pl:
            {
              list1.add(excelLib.TextCellValue(element.profitLoss!.toStringAsFixed(2)));
            }
          case SettlementColumns.brk:
            {
              list1.add(excelLib.TextCellValue(element.brokerageTotal!.toStringAsFixed(2)));
            }
          case SettlementColumns.total:
            {
              list1.add(excelLib.TextCellValue(element.total!.toStringAsFixed(2)));
            }
          default:
            {
              list1.add(excelLib.TextCellValue(""));
            }
        }
      });
      dataList2.add(list1);
    });

    exportExcelWithTwoSheetFile("Settlement.xlsx", "Profit", "Loss", titleList, dataList1, dataList2);
  }

  onClickPDF() async {
    List<String> headers = [];

    arrListTitle1.forEach((element) {
      headers.add(element.title!);
    });
    List<List<dynamic>> dataList = [];
    arrProfitList.forEach((element) {
      List<String> list1 = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case SettlementColumns.username:
            {
              list1.add((element.displayName ?? ""));
            }

          case SettlementColumns.pl:
            {
              list1.add((element.profitLoss!.toStringAsFixed(2)));
            }
          case SettlementColumns.brk:
            {
              list1.add((element.brokerageTotal!.toStringAsFixed(2)));
            }
          case SettlementColumns.total:
            {
              list1.add((element.total!.toStringAsFixed(2)));
            }
          default:
            {
              list1.add((""));
            }
        }
      });
      dataList.add(list1);
    });

    List<List<dynamic>> dataList1 = [];
    arrLossList.forEach((element) {
      List<String> list2 = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case SettlementColumns.username:
            {
              list2.add((element.displayName ?? ""));
            }

          case SettlementColumns.pl:
            {
              list2.add((element.profitLoss!.toStringAsFixed(2)));
            }
          case SettlementColumns.brk:
            {
              list2.add((element.brokerageTotal!.toStringAsFixed(2)));
            }
          case SettlementColumns.total:
            {
              list2.add((element.total!.toStringAsFixed(2)));
            }
          default:
            {
              list2.add((""));
            }
        }
      });
      dataList1.add(list2);
    });
    exportPDFWith2DataFile(fileName: "Settlement", title: "Profit", title1: "Loss", width: globalMaxWidth, titleList: headers, dataList: dataList, dataList1: dataList1);
  }
}
