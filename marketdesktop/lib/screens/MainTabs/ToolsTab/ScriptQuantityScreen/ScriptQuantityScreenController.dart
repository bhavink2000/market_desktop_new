import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:excel/excel.dart' as excelLib;
import '../../../../constant/const_string.dart';
import '../../../../constant/screenColumnData.dart';
import '../../../../constant/utilities.dart';
import '../../../../main.dart';
import '../../../../modelClass/exchangeListModelClass.dart';
import '../../../../modelClass/groupListModelClass.dart';
import '../../../../modelClass/myUserListModelClass.dart';
import '../../../../modelClass/scriptQuantityModelClass.dart';
import '../../../BaseController/baseController.dart';

class ScriptQuantityControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScriptQuantityController());
  }
}

class ScriptQuantityController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  ScrollController listcontroller = ScrollController();
  Rx<ExchangeData> selectExchangeDropdownValue = ExchangeData().obs;
  Rx<groupListModelData> selectGroupDropdownValue = groupListModelData().obs;
  final TextEditingController searchScriptextEditingController = TextEditingController();
  FocusNode searchScripttextEditingFocus = FocusNode();
  Rx<UserData> selectUserdropdownValue = UserData().obs;

  bool isDarkMode = false;
  List<scriptQuantityData> arrData = [];
  int pageNumber = 1;
  int totalPage = 0;
  int totalCount = 0;
  bool isPagingApiCall = false;
  bool isLocalDataLoading = true;
  List<ExchangeData> arrExchangeList = [];
  List<groupListModelData> arrGroupList = [];
  List<UserData> arrUserDataDropDown = [];
  bool isApiCallRunning = false;
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();

  @override
  void onInit() async {
    super.onInit();
    getColumnListFromDB(ScreenIds().scriptQty, arrListTitle1);
    if (userData!.role == UserRollList.user) {
      selectUserdropdownValue.value = UserData(userId: userData!.userId);
    }
    getExchangeList();
    getUserList();
    // getQuantityList();
    update();
  }

  getExchangeList() async {
    var response = await service.getExchangeListUserWiseCall(userId: userData!.userId!);
    if (response != null) {
      if (response.statusCode == 200) {
        arrExchangeList = response.exchangeData ?? [];
        update();
      }
    }
  }

  callforGroupList(
    String? ExchangeId,
  ) async {
    update();
    var response = await service.getGroupListCall(ExchangeId);
    if (response != null) {
      if (response.statusCode == 200) {
        arrGroupList = response.data ?? [];
        if (arrGroupList.isNotEmpty) {
          selectGroupDropdownValue.value = arrGroupList.first;
        }
        update();
      } else {
        showErrorToast(response.meta!.message ?? "");
        return [];
      }
    } else {
      showErrorToast(AppString.generalError);
      return [];
    }
  }

  getUserList() async {
    var response = await service.getMyUserListCall();
    if (response != null) {
      if (response.statusCode == 200) {
        arrUserDataDropDown = response.data ?? [];
        update();
      }
    }
  }

  getQuantityList() async {
    if (selectGroupDropdownValue.value.groupId == null || selectGroupDropdownValue.value.groupId == "") {
      showWarningToast("Please select group");
      return;
    }
    if (isPagingApiCall) {
      return;
    }
    isApiCallRunning = true;
    isPagingApiCall = true;

    update();
    var response = await service.getScriptQuantityListCall(text: "", userId: selectUserdropdownValue.value.userId ?? "", groupId: selectGroupDropdownValue.value.groupId, page: pageNumber);
    if (response != null) {
      isApiCallRunning = false;
      isPagingApiCall = false;
      update();
      if (response.statusCode == 200) {
        totalPage = response.meta?.totalPage ?? 0;
        totalCount = response.meta?.totalCount ?? 0;
        arrData.addAll(response.data ?? []);
        if (totalPage >= pageNumber) {
          pageNumber = pageNumber + 1;
        }
        update();
      }
    }
  }

  onClickExcel({bool isFromPDF = false}) {
    List<excelLib.TextCellValue?> titleList = [];
    arrListTitle1.forEach((element) {
      titleList.add(excelLib.TextCellValue(element.title!));
    });
    List<List<excelLib.TextCellValue?>> dataList = [];
    arrData.forEach((element) {
      List<excelLib.TextCellValue?> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case ScriptQtyColumns.symbol:
            {
              list.add(excelLib.TextCellValue(element.symbolName ?? ""));
            }
          case ScriptQtyColumns.breakUpQty:
            {
              list.add(excelLib.TextCellValue(element.breakQuantity.toString()));
            }
          case ScriptQtyColumns.maxQty:
            {
              list.add(excelLib.TextCellValue(element.quantityMax.toString()));
            }
          case ScriptQtyColumns.breakUpLot:
            {
              list.add(excelLib.TextCellValue(element.breakUpLot.toString()));
            }
          case ScriptQtyColumns.maxLot:
            {
              list.add(excelLib.TextCellValue(element.lotMax.toString()));
            }

          default:
            {
              list.add(excelLib.TextCellValue(""));
            }
        }
      });
      dataList.add(list);
    });

    exportExcelFile("ScriptQuantity.xlsx", titleList, dataList);
  }

  onClickPDF() async {
    List<String> headers = [];

    arrListTitle1.forEach((element) {
      headers.add(element.title!);
    });
    List<List<dynamic>> dataList = [];
    arrData.forEach((element) {
      List<String> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case ScriptQtyColumns.symbol:
            {
              list.add((element.symbolName ?? ""));
            }
          case ScriptQtyColumns.breakUpQty:
            {
              list.add((element.breakQuantity.toString()));
            }
          case ScriptQtyColumns.maxQty:
            {
              list.add((element.quantityMax.toString()));
            }
          case ScriptQtyColumns.breakUpLot:
            {
              list.add((element.breakUpLot.toString()));
            }
          case ScriptQtyColumns.maxLot:
            {
              list.add((element.lotMax.toString()));
            }
          default:
            {
              list.add((""));
            }
        }
      });
      dataList.add(list);
    });
    exportPDFFile(fileName: "ScriptQuantity", title: "Script Quantity", width: globalMaxWidth, titleList: headers, dataList: dataList);
  }
}
