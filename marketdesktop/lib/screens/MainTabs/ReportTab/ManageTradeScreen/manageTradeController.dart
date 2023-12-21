import 'dart:convert';

import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';

import '../../../../constant/index.dart';
import '../../../../main.dart';
import '../../../../modelClass/getScriptFromSocket.dart';
import '../../../../modelClass/myTradeListModelClass.dart';

class ManageTradeController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  bool isFilterOpen = false;
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;
  int selectedOrderIndex = -1;

  Rx<UserData> selectedUser = UserData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  ScrollController listcontroller = ScrollController();
  List<TradeData> arrTrade = [];
  TradeData? selectedTrade;
  bool isLocalDataLoading = true;
  bool isApiCallRunning = false;
  bool isResetCall = false;
  bool isSuccessSelected = true;
  int totalSuccessRecord = 0;
  int totalPendingRecord = 0;
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  int pageNumber = 1;
  int totalPage = 0;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getTradeList();
    listcontroller.addListener(() async {
      if ((listcontroller.position.pixels > listcontroller.position.maxScrollExtent / 2.5 && totalPage > 1 && pageNumber < totalPage && !isLocalDataLoading)) {
        isLocalDataLoading = true;
        pageNumber++;
        String strFromDate = "";
        String strToDate = "";
        if (fromDate.value != "Start Date") {
          strFromDate = fromDate.value;
        }
        if (endDate.value != "End Date") {
          strToDate = endDate.value;
        }
        update();
        var response = await service.getManageTradeListCall(
          page: pageNumber,
          text: "",
          userId: selectedUser.value.userId ?? "",
          symbolId: selectedScriptFromFilter.value.symbolId ?? "",
          exchangeId: selectedExchange.value.exchangeId ?? "",
          startDate: strFromDate,
          endDate: strToDate,
        );
        if (response != null) {
          if (response.statusCode == 200) {
            totalPage = response.meta?.totalPage ?? 0;
            if (isSuccessSelected) {
              totalSuccessRecord = response.meta?.totalCount ?? 0;
            } else {
              totalPendingRecord = response.meta?.totalCount ?? 0;
            }

            for (var v in response.data!) {
              arrTrade.add(v);
            }
            isLocalDataLoading = false;
            update();
            var arrTemp = [];
            for (var element in response.data!) {
              if (!socket.arrSymbolNames.contains(element.symbolName)) {
                arrTemp.insert(0, element.symbolName);
                socket.arrSymbolNames.insert(0, element.symbolName!);
              }
            }

            if (arrTemp.isNotEmpty) {
              var txt = {"symbols": arrTemp};
              socket.connectScript(jsonEncode(txt));
            }
          }
        }
      }
    });
  }

  getTradeList({bool isFromClear = false}) async {
    arrTrade.clear();
    pageNumber = 1;

    isLocalDataLoading = true;
    if (isFromClear) {
      isResetCall = true;
    } else {
      isApiCallRunning = true;
    }

    String strFromDate = "";
    String strToDate = "";
    update();
    if (fromDate.value != "Start Date") {
      strFromDate = fromDate.value;
    }
    if (endDate.value != "End Date") {
      strToDate = endDate.value;
    }

    var response = await service.getManageTradeListCall(
      page: pageNumber,
      text: "",
      userId: selectedUser.value.userId ?? "",
      symbolId: selectedScriptFromFilter.value.symbolId ?? "",
      exchangeId: selectedExchange.value.exchangeId ?? "",
      startDate: strFromDate,
      endDate: strToDate,
    );
    isLocalDataLoading = false;
    isApiCallRunning = false;
    isResetCall = false;
    if (response != null) {
      if (response.statusCode == 200) {
        var arrTemp = [];
        response.data?.forEach((v) {
          arrTrade.add(v);
        });
        update();
        totalPage = response.meta?.totalPage ?? 0;
        if (isSuccessSelected) {
          totalSuccessRecord = response.meta?.totalCount ?? 0;
        } else {
          totalPendingRecord = response.meta?.totalCount ?? 0;
        }
        for (var element in response.data!) {
          if (!socket.arrSymbolNames.contains(element.symbolName)) {
            arrTemp.insert(0, element.symbolName);
            socket.arrSymbolNames.insert(0, element.symbolName!);
          }
        }

        if (arrTemp.isNotEmpty) {
          var txt = {"symbols": arrTemp};
          socket.connectScript(jsonEncode(txt));
        }
      }
    }
  }

  addSymbolInSocket(String symbolName) {
    if (!socket.arrSymbolNames.contains(symbolName)) {
      socket.arrSymbolNames.insert(0, symbolName);
      var txt = {
        "symbols": [symbolName]
      };
      socket.connectScript(jsonEncode(txt));
    }
  }

  listenSuccessTradeScriptFromSocket(GetScriptFromSocket socketData) {
    if (socketData.status == true) {
      var obj = arrTrade.firstWhereOrNull((element) => socketData.data!.symbol == element.symbolName);

      if (obj != null) {
        for (var i = 0; i < arrTrade.length; i++) {
          if (arrTrade[i].symbolName == socketData.data!.symbol) {
            arrTrade[i].currentPriceFromSocket = arrTrade[i].tradeType == "buy" ? double.parse(socketData.data!.bid.toString()) : double.parse(socketData.data!.ask.toString());
          }
        }
      }
      update();
    }
  }

  Color getPriceColor(String type, double currentPrice, double tradePrice) {
    switch (type) {
      case "buy":
        {
          if (currentPrice > tradePrice) {
            return AppColors().greenColor;
          } else if (currentPrice < tradePrice) {
            return AppColors().redColor;
          } else {
            return AppColors().fontColor;
          }
        }
      case "sell":
        {
          if (currentPrice < tradePrice) {
            return AppColors().greenColor;
          } else if (currentPrice > tradePrice) {
            return AppColors().redColor;
          } else {
            return AppColors().fontColor;
          }
        }

      default:
        {
          return AppColors().darkText;
        }
    }
  }

  num getNetPrice(String isFromBuy, num tradePrice, num brokerage) {
    if (isFromBuy == "buy") {
      return tradePrice + brokerage;
    } else {
      return tradePrice - brokerage;
    }
  }

  Color getProfitLossColor(String isFromBuy, num netPrice, num currentPrice) {
    if (isFromBuy == "buy") {
      if (netPrice > currentPrice) {
        return AppColors().blueColor;
      } else {
        return AppColors().redColor;
      }
    } else {
      if (netPrice > currentPrice) {
        return AppColors().redColor;
      } else {
        return AppColors().blueColor;
      }
    }
  }
}
