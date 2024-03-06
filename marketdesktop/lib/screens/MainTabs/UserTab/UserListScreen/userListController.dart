import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/constantModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/userRoleListModelClass.dart';
import '../../../../constant/index.dart';
import '../../../../constant/screenColumnData.dart';
import 'package:excel/excel.dart' as excelLib;

import '../../../../constant/utilities.dart';

class UserListController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;

  List<UserData> arrUserListData = [];
  int selectedUserIndex = -1;
  Rx<AddMaster> selectedFilterType = AddMaster().obs;
  Rx<userRoleListData> selectedUserType = userRoleListData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  Rx<AddMaster> selectUserStatusdropdownValue = AddMaster().obs;
  TextEditingController textController = TextEditingController();
  Rx<AddMaster> selectStatusdropdownValue = AddMaster().obs;
  Rx<userRoleListData> selectUserdropdownValue = userRoleListData().obs;
  Rx<AddMaster> userdropdownValue = AddMaster().obs;
  bool isLoadingData = false;
  bool isResetData = false;
  bool isPagingApiCall = false;

  int totalPage = 0;
  int totalRecord = 0;
  int currentPage = 1;
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  double totalPL = 0.0;
  double totalPLPercentage = 0.0;

  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
    getColumnListFromDB(ScreenIds().userList, arrListTitle1);
    update();
    callForRoleList();
    isLoadingData = true;
    getUserList();
  }

  num getPlPer({num? percentage, num? pl}) {
    var temp1 = pl! * percentage!;
    var temp2 = temp1 / 100;
    if (pl != 0) {
      temp2 = temp2 * -1;
    }

    return temp2;
  }

  updateUserStatus(Map<String, Object?>? payload) async {
    await service.userChangeStatusCall(payload: payload);
  }

  getUserList({bool isFromClear = false, bool isFromButtons = false}) async {
    if (isPagingApiCall) {
      return;
    }
    isPagingApiCall = true;
    if (isFromButtons) {
      if (isFromClear) {
        isResetData = true;
      } else {
        isLoadingData = true;
      }
    }

    update();
    var response = await service.getChildUserListCall(
      text: textController.text.trim(),
      page: currentPage,
      status: selectUserStatusdropdownValue.value.id?.toString() ?? "",
      roleId: selectedUserType.value.roleId ?? "",
      filterType: selectedFilterType.value.id?.toString() ?? "",
    );
    if (isFromClear) {
      isResetData = false;
    } else {
      isLoadingData = false;
    }
    if (response != null) {
      if (response.statusCode == 200) {
        arrUserListData.addAll(response.data!);
        isPagingApiCall = false;
        totalPage = response.meta!.totalPage!;
        totalRecord = response.meta!.totalCount!;
        totalPL = 0.0;
        totalPLPercentage = 0.0;
        for (var element in arrUserListData) {
          totalPL = totalPL + element.profitLoss!;
          var temp = element.profitLoss! / 100;
          totalPLPercentage = totalPLPercentage + temp;
        }
        if (totalPage >= currentPage) {
          currentPage = currentPage + 1;
        }
        update();
      } else {
        update();
      }
    }
  }

  updateUser() async {
    arrUserListData.clear();
    currentPage = 1;
    isResetData = true;
    update();
    getUserList(isFromClear: true);
  }

  onClickExcel({bool isFromPDF = false}) {
    List<excelLib.TextCellValue?> titleList = [];
    arrListTitle1.forEach((element) {
      titleList.add(excelLib.TextCellValue(element.title!));
    });
    List<List<excelLib.TextCellValue?>> dataList = [];
    arrUserListData.forEach((element) {
      List<excelLib.TextCellValue?> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case 'EDIT':
            {
              list.add(excelLib.TextCellValue(""));
            }
          case '...':
            {
              list.add(excelLib.TextCellValue(""));
            }
          case 'USERNAME':
            {
              list.add(excelLib.TextCellValue(element.userName ?? ""));
            }
          case 'PARENT USER':
            {
              list.add(excelLib.TextCellValue(element.parentUser ?? ""));
            }
          case 'TYPE':
            {
              list.add(excelLib.TextCellValue(element.roleName ?? ""));
            }
          case 'NAME':
            {
              list.add(excelLib.TextCellValue(element.name ?? ""));
            }
          case 'OUR %':
            {
              list.add(excelLib.TextCellValue(element.ourProfitAndLossSharing.toString()));
            }
          case 'BRK SHARING':
            {
              list.add(excelLib.TextCellValue(element.ourBrkSharing.toString()));
            }
          case 'LEVERAGE':
            {
              list.add(excelLib.TextCellValue(element.leverage.toString()));
            }
          case 'CREDIT':
            {
              list.add(excelLib.TextCellValue(element.credit.toString()));
            }
          case 'P/L':
            {
              list.add(excelLib.TextCellValue(element.role == UserRollList.user ? (element.profitLoss! - element.brokerageTotal!).toStringAsFixed(2) : (element.profitLoss! + element.brokerageTotal!).toStringAsFixed(2)));
            }
          case 'EQUITY':
            {
              list.add(excelLib.TextCellValue(element.balance!.toStringAsFixed(2)));
            }
          case 'TOTAL MARGIN':
            {
              list.add(excelLib.TextCellValue(element.marginBalance!.toStringAsFixed(2)));
            }
          case 'USED MARGIN':
            {
              list.add(excelLib.TextCellValue(element.role == UserRollList.user ? (element.marginBalance! - element.tradeMarginBalance!).toStringAsFixed(2) : "0"));
            }
          case 'FREE MARGIN':
            {
              list.add(excelLib.TextCellValue(element.tradeMarginBalance!.toStringAsFixed(2)));
            }
          case 'BET':
            {
              list.add(excelLib.TextCellValue(element.bet!.toString()));
            }
          case 'CLOSE ONLY':
            {
              list.add(excelLib.TextCellValue(element.closeOnly!.toString()));
            }
          case 'AUTO SQROFF':
            {
              list.add(excelLib.TextCellValue(element.autoSquareOffValue!.toString()));
            }
          case 'VIEW ONLY':
            {
              list.add(excelLib.TextCellValue(element.viewOnly!.toString()));
            }
          case 'STATUS':
            {
              list.add(excelLib.TextCellValue(element.status!.toString()));
            }
          case 'CREATED DATE':
            {
              list.add(excelLib.TextCellValue(shortFullDateTime(element.createdAt!)));
            }
          case 'LAST LOGIN DATE/TIME':
            {
              list.add(excelLib.TextCellValue(shortFullDateTime(element.createdAt!)));
            }
          case 'DEVICE':
            {
              list.add(excelLib.TextCellValue(element.deviceType ?? ""));
            }
          case 'DEVICE ID':
            {
              list.add(excelLib.TextCellValue(element.deviceId ?? ""));
            }
          case 'IP ADDRESS':
            {
              list.add(excelLib.TextCellValue(element.ipAddress ?? ""));
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
      return exportPDFFile("UserList", titleList, dataList);
    }
    exportExcelFile("UserList.xlsx", titleList, dataList);
  }

  onClickPDF() async {
    var filePath = await onClickExcel(isFromPDF: true);
    generatePdfFromExcel(filePath);
  }
}
