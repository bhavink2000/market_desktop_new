import 'package:marketdesktop/screens/BaseController/baseController.dart';
import 'package:excel/excel.dart' as excelLib;
import '../../../../constant/index.dart';
import '../../../../constant/screenColumnData.dart';
import '../../../../constant/utilities.dart';
import '../../../../main.dart';
import '../../../../modelClass/creditListModelClass.dart';

class HistoryOfCreditController extends BaseController {
//*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  bool isApiCallRunning = false;
  List<creditData> arrCreditList = [];
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getColumnListFromDB(ScreenIds().creditHistory, arrListTitle1);
    isApiCallRunning = true;
    update();

    // accountSummaryList();
    getCreditList();
  }

  getCreditList() async {
    var response = await service.getCreditListCall(userId: userData!.userId!);

    if (response?.statusCode == 200) {
      arrCreditList = response!.data ?? [];
      isApiCallRunning = false;
      for (var i = 0; i < arrCreditList.length; i++) {
        if (arrCreditList[i].transactionType == "credit") {
          if (i == 0) {
            arrCreditList[i].balance = arrCreditList[i].amount!;
          } else {
            arrCreditList[i].balance = arrCreditList[i - 1].balance + arrCreditList[i].amount!;
          }
        } else {
          if (i == 0) {
            arrCreditList[i].balance = arrCreditList[i].balance!;
          } else {
            arrCreditList[i].balance = arrCreditList[i - 1].balance - arrCreditList[i].amount!;
          }
        }
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
    arrCreditList.forEach((element) {
      List<excelLib.TextCellValue?> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case CreditHistoryColumns.username:
            {
              list.add(excelLib.TextCellValue(element.fromUserName!));
            }
          case CreditHistoryColumns.dateTime:
            {
              list.add(excelLib.TextCellValue(shortFullDateTime(element.createdAt!)));
            }
          case CreditHistoryColumns.type:
            {
              list.add(excelLib.TextCellValue(element.transactionType ?? ""));
            }
          case CreditHistoryColumns.amount:
            {
              list.add(excelLib.TextCellValue(element.amount!.toStringAsFixed(2)));
            }
          case CreditHistoryColumns.balance:
            {
              list.add(excelLib.TextCellValue(element.balance.toStringAsFixed(2)));
            }

          case CreditHistoryColumns.comments:
            {
              list.add(excelLib.TextCellValue(element.comment!));
            }

          default:
            {
              list.add(excelLib.TextCellValue(""));
            }
        }
      });
      dataList.add(list);
    });

    exportExcelFile("CreditHistory.xlsx", titleList, dataList);
  }

  onClickPDF() async {
    List<String> headers = [];

    arrListTitle1.forEach((element) {
      headers.add(element.title!);
    });
    List<List<dynamic>> dataList = [];
    arrCreditList.forEach((element) {
      List<String> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case CreditHistoryColumns.username:
            {
              list.add((element.fromUserName!));
            }
          case CreditHistoryColumns.dateTime:
            {
              list.add((shortFullDateTime(element.createdAt!)));
            }
          case CreditHistoryColumns.type:
            {
              list.add((element.transactionType ?? ""));
            }
          case CreditHistoryColumns.amount:
            {
              list.add((element.amount!.toStringAsFixed(2)));
            }
          case CreditHistoryColumns.balance:
            {
              list.add((element.balance.toStringAsFixed(2)));
            }

          case CreditHistoryColumns.comments:
            {
              list.add((element.comment!));
            }
          default:
            {
              list.add((""));
            }
        }
      });
      dataList.add(list);
    });
    exportPDFFile(fileName: "CreditHistory", title: "Credit History", width: globalMaxWidth, titleList: headers, dataList: dataList);
  }
}
