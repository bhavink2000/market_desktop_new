import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/tradeMarginListModelClass.dart';
import 'package:excel/excel.dart' as excelLib;
import '../../../../constant/index.dart';
import '../../../../constant/screenColumnData.dart';
import '../../../../constant/utilities.dart';
import '../../../UserDetailPopups/ScriptMasterPopUp/scriptMasterPopUpController.dart';

class TradeMarginController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;

  RxString selectedUser = "".obs;
  RxString selectedTradeStatus = "".obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  TextEditingController searchController = TextEditingController();

  AllowedTrade? selectedAllowedTrade = AllowedTrade.NotApplication;
  FocusNode viewFocus = FocusNode();
  FocusNode saveFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  bool isApiCallRunning = false;
  bool isClearApiCallRunning = false;
  bool isPagingApiCall = false;
  int totalPage = 0;
  int currentPage = 1;
  int totalCount = 0;
  List<TradeMarginData> arrTradeMargin = [];

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getColumnListFromDB(ScreenIds().tradeMargin, arrListTitle1);
    // tradeMarginList(isFromFilter: true);
  }

  tradeMarginList({bool isFromFilter = false, bool isFromClear = false}) async {
    if (isFromFilter) {
      arrTradeMargin.clear();
      currentPage = 1;
      if (isFromClear) {
        isClearApiCallRunning = true;
      } else {
        isApiCallRunning = true;
      }
    }
    if (isPagingApiCall) {
      return;
    }
    isPagingApiCall = true;
    update();
    var response = await service.tradeMarginListCall(page: currentPage, exchangeId: selectedExchange.value.exchangeId ?? "", text: searchController.text);
    arrTradeMargin.addAll(response!.data!);
    isApiCallRunning = false;
    isPagingApiCall = false;
    isClearApiCallRunning = false;
    totalCount = response.meta!.totalCount!;
    totalPage = response.meta!.totalPage!;
    if (totalPage >= currentPage) {
      currentPage = currentPage + 1;
    }
    update();
  }

  onClickExcel({bool isFromPDF = false}) {
    List<excelLib.TextCellValue?> titleList = [];
    arrListTitle1.forEach((element) {
      titleList.add(excelLib.TextCellValue(element.title!));
    });
    List<List<excelLib.TextCellValue?>> dataList = [];
    arrTradeMargin.forEach((element) {
      List<excelLib.TextCellValue?> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case TradeMarginColumns.exchange:
            {
              list.add(excelLib.TextCellValue(element.exchangeName ?? ""));
            }
          case TradeMarginColumns.script:
            {
              list.add(excelLib.TextCellValue(element.symbolTitle ?? ""));
            }
          case TradeMarginColumns.expiryDate:
            {
              list.add(excelLib.TextCellValue(shortFullDateTime(element.expiryDate!)));
            }
          case TradeMarginColumns.marginPer:
            {
              list.add(excelLib.TextCellValue(element.tradeMargin.toString()));
            }
          case TradeMarginColumns.marginAmount:
            {
              list.add(excelLib.TextCellValue(element.tradeMarginAmount.toString()));
            }
          case TradeMarginColumns.description:
            {
              list.add(excelLib.TextCellValue(element.symbolName.toString()));
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
      return exportPDFFile("TradeMargin", titleList, dataList);
    }
    exportExcelFile("TradeMargin.xlsx", titleList, dataList);
  }

  onClickPDF() async {
    var filePath = await onClickExcel(isFromPDF: true);
    generatePdfFromExcel(filePath);
  }
}
