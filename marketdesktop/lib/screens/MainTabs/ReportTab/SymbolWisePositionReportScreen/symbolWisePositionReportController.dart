import 'dart:convert';

import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/accountSummaryNewListModelClass.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import '../../../../constant/index.dart';
import '../../../../constant/screenColumnData.dart';
import '../../../../constant/utilities.dart';
import '../../../../main.dart';
import '../../../../modelClass/constantModelClass.dart';
import '../../../../modelClass/getScriptFromSocket.dart';


class SymbolWisePositionReportController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  RxString fromDate = "".obs;
  RxString endDate = "".obs;
  Rx<UserData> selectedUser = UserData().obs;
  Rx<String> selectedplType = "All".obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  List<AccountSummaryNewListData> arrSummaryList = [];
  // Rx<positionListData>? selectedScript;
  List<UserData> arrUserListOnlyClient = [];

  RxBool isTradeCallFinished = true.obs;
  double visibleWidth = 0.0;
  RxDouble plTotal = 0.0.obs;
  RxDouble plPerTotal = 0.0.obs;
  RxDouble brkTotal = 0.0.obs;
  Rx<Type> selectedValidity = Type().obs;
  final FocusNode focusNode = FocusNode();
  final FocusNode popUpfocusNode = FocusNode();
  List<Type> arrOrderType = [];
  final debouncer = Debouncer(milliseconds: 300);
  bool isKeyPressActive = false;

  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();

  int selectedScriptIndex = -1;
  Rx<Type> selectedProductType = Type().obs;

  bool isApiCallRunning = false;
  bool isResetCall = false;
  int totalPage = 0;
  int currentPage = 1;

  bool isPagingApiCall = false;

  FocusNode SubmitFocus = FocusNode();
  FocusNode CancelFocus = FocusNode();

  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
    getColumnListFromDB(ScreenIds().symbolWisePositionReport, arrListTitle1);
    // isApiCallRunning = true;

    // getAccountSummaryNewList("");
    getUserList();
    update();
  }

  getUserList() async {
    var response = await service.getMyUserListCall(roleId: UserRollList.user);
    arrUserListOnlyClient = response!.data ?? [];
    if (arrUserListOnlyClient.isNotEmpty) {
      // selectedUser.value = arrUserListOnlyClient.first;
    }
  }

  getAccountSummaryNewList(String text, {bool isFromfilter = false, bool isFromClear = false}) async {
    if (isFromfilter) {
      currentPage = 1;
      arrSummaryList.clear();
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
    var response = await service.symbolWisePositionListCall(currentPage, text,
        userId: selectedUser.value.userId ?? "", startDate: fromDate.value, endDate: endDate.value, symbolId: selectedScriptFromFilter.value.symbolId ?? "", exchangeId: selectedExchange.value.exchangeId ?? "", productType: selectedProductType.value.id ?? "");
    arrSummaryList.addAll(response!.data!);
    isPagingApiCall = false;
    isResetCall = false;
    totalPage = response.meta!.totalPage!.toInt();
    if (totalPage >= currentPage) {
      currentPage = currentPage + 1;
    }
    for (var indexOfScript = 0; indexOfScript < arrSummaryList.length; indexOfScript++) {
      arrSummaryList[indexOfScript].currentPriceFromSocket = arrSummaryList[indexOfScript].totalQuantity! < 0 ? arrSummaryList[indexOfScript].ask!.toDouble() : arrSummaryList[indexOfScript].bid!.toDouble();
      arrSummaryList[indexOfScript].profitLossValue = arrSummaryList[indexOfScript].totalQuantity! < 0
          ? (double.parse(arrSummaryList[indexOfScript].ask!.toStringAsFixed(2)) - arrSummaryList[indexOfScript].avgPrice!) * arrSummaryList[indexOfScript].totalQuantity!
          : (double.parse(arrSummaryList[indexOfScript].bid!.toStringAsFixed(2)) - double.parse(arrSummaryList[indexOfScript].avgPrice!.toStringAsFixed(2))) * arrSummaryList[indexOfScript].totalQuantity!;
    }
    plTotal = 0.0.obs;
    plPerTotal = 0.0.obs;
    brkTotal = 0.0.obs;
    arrSummaryList.forEach((element) {
      plTotal.value = plTotal.value + element.profitLossValue!;

      var temp = ((element.profitLossValue! * element.profitAndLossSharing!) / 100);
      plPerTotal.value = (plPerTotal.value + temp) * -1;
      brkTotal.value = brkTotal.value + element.adminBrokerageTotal!;
    });
    isApiCallRunning = false;
    update();
    var arrTemp = [];
    for (var element in response.data!) {
      if (!arrSymbolNames.contains(element.symbolName)) {
        arrTemp.insert(0, element.symbolName);
        arrSymbolNames.insert(0, element.symbolName!);
      }
    }

    if (arrTemp.isNotEmpty) {
      var txt = {"symbols": arrTemp};
      socket.connectScript(jsonEncode(txt));
    }
  }

  double getTotal(bool isBuy) {
    var total = 0.0;
    if (isBuy) {
      for (var element in arrSummaryList[selectedScriptIndex].scriptDataFromSocket.value.depth!.buy!) {
        total = total + element.price!;
      }
    } else {
      for (var element in arrSummaryList[selectedScriptIndex].scriptDataFromSocket.value.depth!.sell!) {
        total = total + element.price!;
      }
    }
    return total;
  }

  Color getPriceColor(double value) {
    if (value == 0.0) {
      return AppColors().fontColor;
    }
    if (value > 0.0) {
      return AppColors().greenColor;
    } else if (value < 0.0) {
      return AppColors().redColor;
    } else {
      return AppColors().fontColor;
    }
  }

  num getPlPer({num? cmp, num? netAPrice}) {
    var temp1 = cmp! - netAPrice!;
    var temp2 = temp1 / netAPrice;
    var temp3 = temp2 * 100;
    return temp3;
  }

  listenSymbolWisePositionScriptFromSocket(GetScriptFromSocket socketData) {
    if (socketData.status == true) {
      var obj = arrSummaryList.firstWhereOrNull((element) => socketData.data!.symbol == element.symbolName);

      if (obj != null) {
        var indexOfScript = arrSummaryList.indexWhere((element) => element.symbolName == socketData.data?.symbol);
        if (indexOfScript != -1) {
          arrSummaryList[indexOfScript].scriptDataFromSocket = socketData.data!.obs;
          arrSummaryList[indexOfScript].bid = socketData.data!.bid!.toDouble();
          arrSummaryList[indexOfScript].ask = socketData.data!.ask!.toDouble();
          arrSummaryList[indexOfScript].ltp = socketData.data!.ltp!.toDouble();
          arrSummaryList[indexOfScript].currentPriceFromSocket = socketData.data!.ltp!.toDouble();
          if (indexOfScript == 0) {}

          if (arrSummaryList[indexOfScript].currentPriceFromSocket != 0.0) {
            arrSummaryList[indexOfScript].profitLossValue = arrSummaryList[indexOfScript].totalQuantity! < 0
                ? (double.parse(arrSummaryList[indexOfScript].ask!.toStringAsFixed(2)) - arrSummaryList[indexOfScript].avgPrice!) * arrSummaryList[indexOfScript].totalQuantity!
                : (double.parse(arrSummaryList[indexOfScript].bid!.toStringAsFixed(2)) - double.parse(arrSummaryList[indexOfScript].avgPrice!.toStringAsFixed(2))) * arrSummaryList[indexOfScript].totalQuantity!;
          }
        }
      }
      plTotal = 0.0.obs;
      plPerTotal = 0.0.obs;
      brkTotal = 0.0.obs;
      arrSummaryList.forEach((element) {
        plTotal.value = plTotal.value + element.profitLossValue!;

        var temp = ((element.profitLossValue! * element.profitAndLossSharing!) / 100);
        plPerTotal.value = (plPerTotal.value + temp) * -1;
        brkTotal.value = brkTotal.value + element.adminBrokerageTotal!;
      });
      update();
    }
  }
}
