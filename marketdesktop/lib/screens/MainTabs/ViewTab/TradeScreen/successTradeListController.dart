import 'dart:convert';

import 'package:get/get.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/getScriptFromSocket.dart';
import 'package:marketdesktop/modelClass/myTradeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import '../../../../constant/index.dart';
import '../../../../constant/screenColumnData.dart';
import '../../../../constant/utilities.dart';
import '../../../../modelClass/constantModelClass.dart';

class SuccessTradeListController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

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
  bool isFromSocket = false;
  Rx<Type> selectedTradeStatus = Type().obs;
  bool isPagingApiCall = false;
  int totalCount = 0;
  FocusNode deleteTradeFocus = FocusNode();

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getColumnListFromDB(ScreenIds().trades, arrListTitle1);
    arrTradeStatus = constantValues!.tradeStatusFilter ?? [];
    Future.delayed(Duration(seconds: 1), () {
      if (isFromSocket == false) {
        getTradeList(isFromFilter: true);
      }
    });
  }

  deleteTrade(List<TradeData>? arrSymbol) async {
    List<String> arr = [];
    for (var element in arrSymbol!) {
      arr.add(element.tradeId!);
    }
    var response = await service.tradeDeleteCall(tradeId: arr);
    if (response?.statusCode == 200) {
      showSuccessToast(response!.meta!.message ?? "");
      arrTrade.clear();
      getTradeList();

      update();
    } else {
      showErrorToast(response!.message ?? "");
    }
  }

  @override
  isAllSelectedUpdate(bool change) {
    arrTrade.forEach((element) {
      element.isSelected = change;
    });
    update();
  }

  getTradeList({bool isFromClear = false, bool isFromFilter = false}) async {
    isLocalDataLoading = true;
    if (isFromClear) {
      pageNumber = 1;
      isResetCall = true;
    }
    if (isFromFilter) {
      pageNumber = 1;
      isApiCallRunning = true;
    }
    if (isPagingApiCall) {
      return;
    }
    isPagingApiCall = true;
    String strFromDate = "";
    String strToDate = "";
    update();
    if (fromDate.value != "Start Date") {
      strFromDate = fromDate.value;
    }
    if (endDate.value != "End Date") {
      strToDate = endDate.value;
    }

    var response = await service.getMyTradeListCall(
      status: "executed",
      page: pageNumber,
      text: "",
      userId: selectedUser.value.userId ?? "",
      symbolId: selectedScriptFromFilter.value.symbolId ?? "",
      exchangeId: selectedExchange.value.exchangeId ?? "",
      startDate: strFromDate,
      endDate: strToDate,
      tradeStatus: selectedTradeStatus.value.id,
    );

    if (response != null) {
      if (response.statusCode == 200) {
        totalPage = response.meta!.totalPage!;
        if (totalPage >= pageNumber) {
          pageNumber = pageNumber + 1;
        }
        totalCount = response.meta!.totalCount!;
        var arrTemp = [];
        if (isFromClear || isFromFilter) {
          arrTrade.clear();
        }

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
          if (!arrSymbolNames.contains(element.symbolName)) {
            arrTemp.insert(0, element.symbolName);
            arrSymbolNames.insert(0, element.symbolName!);
          }
        }
        isLocalDataLoading = false;
        isApiCallRunning = false;
        isResetCall = false;
        isPagingApiCall = false;
        if (arrTemp.isNotEmpty) {
          var txt = {"symbols": arrTemp};
          socket.connectScript(jsonEncode(txt));
        }
      }
    }
  }

  addSymbolInSocket(String symbolName) {
    if (!arrSymbolNames.contains(symbolName)) {
      arrSymbolNames.insert(0, symbolName);
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
