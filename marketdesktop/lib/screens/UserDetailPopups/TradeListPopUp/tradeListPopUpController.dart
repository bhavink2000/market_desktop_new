import 'package:get/get.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/getScriptFromSocket.dart';
import 'package:marketdesktop/modelClass/myTradeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import '../../../../constant/index.dart';
import '../../../modelClass/constantModelClass.dart';

class TradeListPopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;
  List<TradeData> arrTrade = [];
  Rx<UserData> selectedUser = UserData().obs;
  Rx<Type> selectedTradeStatus = Type().obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  int totalSuccessRecord = 0;
  int totalPendingRecord = 0;
  bool isLocalDataLoading = true;
  int pageNumber = 1;
  int totalPage = 0;
  String selectedUserId = "";
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  bool isApiCallRunning = false;
  bool isResetCall = false;
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    arrTradeStatus = constantValues!.tradeStatusFilter ?? [];
    update();
  }

  getTradeList({bool isFromClear = false}) async {
    arrTrade.clear();
    pageNumber = 1;
    update();
    isLocalDataLoading = true;
    String strFromDate = "";
    String strToDate = "";
    if (fromDate.value != "Start Date") {
      strFromDate = fromDate.value;
    }
    if (endDate.value != "End Date") {
      strToDate = endDate.value;
    }
    if (isFromClear) {
      isResetCall = true;
    } else {
      isApiCallRunning = true;
    }
    update();
    var response = await service.getMyTradeListCall(
      status: "executed",
      page: pageNumber,
      text: "",
      userId: selectedUserId,
      tradeStatus: selectedTradeStatus.value.id ?? "",
      symbolId: selectedScriptFromFilter.value.symbolId ?? "",
      exchangeId: selectedExchange.value.exchangeId ?? "",
      startDate: strFromDate,
      endDate: strToDate,
    );
    isLocalDataLoading = false;
    if (response != null) {
      if (response.statusCode == 200) {
        // var arrTemp = [];
        response.data?.forEach((v) {
          arrTrade.add(v);
        });

        isResetCall = false;
        isApiCallRunning = false;
        totalPage = response.meta?.totalPage ?? 0;
        totalSuccessRecord = response.meta?.totalCount ?? 0;
        if (totalPage >= pageNumber) {
          pageNumber = pageNumber + 1;
        }
        update();
        // for (var element in response.data!) {
        //   arrTemp.insert(0, element.symbolName);
        // }

        // if (arrTemp.isNotEmpty) {
        //   var txt = {"symbols": arrTemp};
        //   socket.connectScript(jsonEncode(txt));
        // }
      }
    }
  }

  listenTradePopUpScriptFromSocket(GetScriptFromSocket socketData) {
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
