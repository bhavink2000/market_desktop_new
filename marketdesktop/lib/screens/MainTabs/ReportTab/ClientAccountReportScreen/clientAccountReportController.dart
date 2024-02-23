import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/accountSummaryNewListModelClass.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/getScriptFromSocket.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/MainContainerScreen/mainContainerController.dart';
import '../../../../constant/index.dart';
import '../../../../modelClass/constantModelClass.dart';
import '../../ViewTab/MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';

class ClientAccountReportController extends BaseController {
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
  RxDouble grandTotal = 0.0.obs;
  RxDouble outPerGrandTotal = 0.0.obs;

  FocusNode SubmitFocus = FocusNode();
  FocusNode CancelFocus = FocusNode();
  List<ListItem> arrListTitle = [];

  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
    updateTitleList();
    if (userData!.role == UserRollList.user) {
      isApiCallRunning = true;

      if (Get.find<MainContainerController>().isInitCallRequired) {
        getAccountSummaryNewList("");
      }
    }

    getUserList();
    update();
  }

  updateTitleList() {
    arrListTitle = [
      // ListItem("", true),

      if (userData!.role != UserRollList.user) ListItem("USERNAME", true),
      if (userData!.role != UserRollList.user) ListItem("PARENT USER", true),
      ListItem("EXCHANGE", true),
      ListItem("SYMBOL", true),
      ListItem("TOTAL BUY QTY", true),
      ListItem("TOTAL BUY A PRICE", true),
      ListItem("TOTAL SELL QTY", true),
      ListItem("TOTAL SELL A PRICE", true),
      ListItem("NET QTY", true),
      ListItem("NET A PRICE", true),
      ListItem("CMP", true),
      ListItem("BROKERAGE", true),
      ListItem("P/L", true),
      if (selectedplType.value == "All" || selectedplType.value == "Only Release") ListItem("RELEASE P/L", true),
      if (selectedplType.value != "Only Release") ListItem("MTM", true),
      if (selectedplType.value != "Only Release") ListItem("MTM WITH BROKERAGE", true),
      if (selectedplType.value == "All" && selectedplType.value != "Only Release") ListItem("TOTAL", true),
      if (userData!.role != UserRollList.user) ListItem("OUR %", true),
    ];
    update();
  }

  refreshView() {
    update();
  }

  getUserList() async {
    var response = await service.getMyUserListCall(roleId: UserRollList.user);
    arrUserListOnlyClient = response!.data ?? [];
    update();
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
    var response = await service.accountSummaryNewListCall(currentPage, text,
        userId: selectedUser.value.userId ?? "", startDate: fromDate.value, endDate: endDate.value, symbolId: selectedScriptFromFilter.value.symbolId ?? "", exchangeId: selectedExchange.value.exchangeId ?? "", productType: selectedProductType.value.id ?? "");
    arrSummaryList.addAll(response!.data!);
    isPagingApiCall = false;
    isResetCall = false;
    totalPage = response.meta!.totalPage!.toInt();
    if (totalPage >= currentPage) {
      currentPage = currentPage + 1;
    }
    for (var indexOfScript = 0; indexOfScript < arrSummaryList.length; indexOfScript++) {
      arrSummaryList[indexOfScript].profitLossValue = arrSummaryList[indexOfScript].totalQuantity! < 0
          ? (double.parse(arrSummaryList[indexOfScript].ask!.toStringAsFixed(2)) - arrSummaryList[indexOfScript].avgPrice!) * arrSummaryList[indexOfScript].totalQuantity!
          : (double.parse(arrSummaryList[indexOfScript].bid!.toStringAsFixed(2)) - double.parse(arrSummaryList[indexOfScript].avgPrice!.toStringAsFixed(2))) * arrSummaryList[indexOfScript].totalQuantity!;

      arrSummaryList[indexOfScript].total = (double.parse(arrSummaryList[indexOfScript].profitLoss!.toStringAsFixed(2)) + double.parse(arrSummaryList[indexOfScript].profitLossValue!.toStringAsFixed(2))) - double.parse(arrSummaryList[indexOfScript].brokerageTotal!.toStringAsFixed(2));
      arrSummaryList[indexOfScript].ourPer = (((arrSummaryList[indexOfScript].profitLossValue! + arrSummaryList[indexOfScript].profitLoss!) * arrSummaryList[indexOfScript].profitAndLossSharing!) / 100);
      // if (arrSummaryList[indexOfScript].total < 0) {
      arrSummaryList[indexOfScript].ourPer = arrSummaryList[indexOfScript].ourPer * -1;
      // }
      arrSummaryList[indexOfScript].ourPer = arrSummaryList[indexOfScript].ourPer + arrSummaryList[indexOfScript].adminBrokerageTotal!;
    }
    grandTotal.value = 0.0;
    outPerGrandTotal.value = 0.0;
    arrSummaryList.forEach((element) {
      grandTotal.value = element.total + grandTotal.value;

      outPerGrandTotal.value = outPerGrandTotal.value + element.ourPer;
    });

    isApiCallRunning = false;
    updateTitleList();
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

  listenClientAccountScriptFromSocket(GetScriptFromSocket socketData) {
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

            arrSummaryList[indexOfScript].total = (double.parse(arrSummaryList[indexOfScript].profitLoss!.toStringAsFixed(2)) + double.parse(arrSummaryList[indexOfScript].profitLossValue!.toStringAsFixed(2))) - double.parse(arrSummaryList[indexOfScript].brokerageTotal!.toStringAsFixed(2));
            arrSummaryList[indexOfScript].ourPer = (((arrSummaryList[indexOfScript].profitLossValue! + arrSummaryList[indexOfScript].profitLoss!) * arrSummaryList[indexOfScript].profitAndLossSharing!) / 100);
            // if (arrSummaryList[indexOfScript].total < 0) {
            arrSummaryList[indexOfScript].ourPer = arrSummaryList[indexOfScript].ourPer * -1;
            // }
            arrSummaryList[indexOfScript].ourPer = arrSummaryList[indexOfScript].ourPer + arrSummaryList[indexOfScript].adminBrokerageTotal!;
          }
        }
      }

      update();
      grandTotal.value = 0.0;
      outPerGrandTotal.value = 0.0;
      arrSummaryList.forEach((element) {
        grandTotal.value = grandTotal.value + element.total;

        outPerGrandTotal.value = outPerGrandTotal.value + element.ourPer;
      });
    }
  }
}
