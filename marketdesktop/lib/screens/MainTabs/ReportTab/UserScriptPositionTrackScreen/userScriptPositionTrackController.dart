import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/positionTrackListModelClass.dart';

import '../../../../constant/screenColumnData.dart';
import '../../../../constant/utilities.dart';
import '../../../../modelClass/allSymbolListModelClass.dart';
import '../../../../modelClass/exchangeListModelClass.dart';
import '../../../../constant/index.dart';
import 'package:excel/excel.dart' as excelLib;

class UserScriptPositionTrackController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;

  Rx<UserData> selectedUser = UserData().obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  ScrollController mainScroll = ScrollController();
  List<PositionTrackData> arrTracking = [];
  bool isApiCallRunning = false;
  bool isFilterApiCallRunning = false;
  bool isClearApiCallRunning = false;
  bool isPagingApiCall = false;
  int totalPage = 0;
  int currentPage = 1;
  int totalCount = 0;

  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
    getColumnListFromDB(ScreenIds().userScriptPositionTracking, arrListTitle1);
    trackList();
  }

  trackList() async {
    if (isPagingApiCall) {
      return;
    }

    isPagingApiCall = true;
    update();
    var response = await service.positionTrackingListCall(
      page: currentPage,
      userId: selectedUser.value.userId ?? "",
      symbolId: selectedScriptFromFilter.value.symbolId ?? "",
      exchangeId: selectedExchange.value.exchangeId ?? "",
      endDate: endDate.value == "End Date" ? "" : endDate.value,
    );
    arrTracking.addAll(response!.data!);
    isApiCallRunning = false;
    isPagingApiCall = false;
    isFilterApiCallRunning = false;
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
    arrTracking.forEach((element) {
      List<excelLib.TextCellValue?> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case UserScriptPositionTrackingColumns.positionDate:
            {
              list.add(excelLib.TextCellValue(shortFullDateTime(element.createdAt!)));
            }
          case UserScriptPositionTrackingColumns.username:
            {
              list.add(excelLib.TextCellValue(element.userName ?? ""));
            }
          case UserScriptPositionTrackingColumns.symbol:
            {
              list.add(excelLib.TextCellValue(element.symbolTitle ?? ""));
            }
          case UserScriptPositionTrackingColumns.position:
            {
              list.add(excelLib.TextCellValue(element.orderType!.toUpperCase()));
            }
          case UserScriptPositionTrackingColumns.openAPrice:
            {
              list.add(excelLib.TextCellValue(element.price!.toString()));
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
      return exportPDFFile("UserScriptPositionTracking", titleList, dataList);
    }
    exportExcelFile("UserScriptPositionTracking.xlsx", titleList, dataList);
  }

  onClickPDF() async {
    var filePath = await onClickExcel(isFromPDF: true);
    generatePdfFromExcel(filePath);
  }
}
