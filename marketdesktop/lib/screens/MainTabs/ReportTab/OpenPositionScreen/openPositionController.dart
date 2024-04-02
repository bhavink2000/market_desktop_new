import 'dart:convert';

import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/getScriptFromSocket.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/positionModelClass.dart';
import 'package:marketdesktop/modelClass/profileInfoModelClass.dart';
import 'package:marketdesktop/screens/BaseController/baseController.dart';

import '../../../../constant/index.dart';
import '../../../../main.dart';
import '../../ViewTab/MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';

class OpenPositionController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  Rx<UserData> selectedUser = UserData().obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  List<positionListData> arrPositionScriptList = [];
  String symbolId = "";
  bool isApiCallRunning = false;
  bool isProfileApiCallRunning = false;
  ProfileInfoData? selectedUserData;
  double totalPL = 0.0;
  RxDouble totalPosition = 0.0.obs;
  bool isPagingApiCall = false;
  int totalPage = 0;
  int currentPage = 1;
  Size? screenSize;
  int totalCount = 0;
  bool isResetCall = false;
  FocusNode applyFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  List<ListItem> arrListTitle = [
    ListItem("SCRIPT", true),
    ListItem("TOTAL BUY QTY", true),
    ListItem("BUY A PRICE", true),
    ListItem("TOTAL SELL QTY", true),
    ListItem("SELL A PRICE", true),
    ListItem("NET QTY", true),
    ListItem("NET A PRICE", true),
    ListItem("CMP", true),
    ListItem("PROFIT/LOSS", true),
  ];
  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
    screenSize = WidgetsBinding.instance.platformDispatcher.displays.first.size;
    isApiCallRunning = true;
    getPositionList("");
    getUSerInfo();
  }

  refreshView() {
    update();
  }

  getPositionList(String text, {bool isFromFilter = false, bool isFromReset = false}) async {
    if (isFromFilter) {
      if (isFromReset) {
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
    var response = await service.positionListCall(
      currentPage,
      "",
      symbolId: selectedScriptFromFilter.value.symbolId ?? "",
      exchangeId: selectedExchange.value.exchangeId ?? "",
      userId: selectedUser.value.userId ?? "",
    );
    arrPositionScriptList.addAll(response!.data!);
    isApiCallRunning = false;
    isPagingApiCall = false;
    isResetCall = false;
    totalPage = response.meta!.totalPage!;
    totalCount = response.meta!.totalCount!;
    if (totalPage >= currentPage) {
      currentPage = currentPage + 1;
    }
    update();
    var arrTemp = [];
    for (var element in response.data!) {
      if (!arrSymbolNames.contains(element.symbolName)) {
        arrTemp.insert(0, element.symbolName);
        arrSymbolNames.insert(0, element.symbolName!);
      }
    }

    if (arrSymbolNames.isNotEmpty) {
      var txt = {"symbols": arrSymbolNames};
      socket.connectScript(jsonEncode(txt));
    }
  }

  getUSerInfo() async {
    isProfileApiCallRunning = true;
    update();
    var userResponse = await service.profileInfoByUserIdCall(selectedUserData?.userId ?? "");
    if (userResponse != null) {
      if (userResponse.statusCode == 200) {
        selectedUserData = userResponse.data;

        isProfileApiCallRunning = false;

        update();
      }
    }
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

  listenOpenPositionScriptFromSocket(GetScriptFromSocket socketData) {
    if (socketData.status == true) {
      var obj = arrPositionScriptList.firstWhereOrNull((element) => socketData.data!.symbol == element.symbolName);

      if (obj != null) {
        var indexOfScript = arrPositionScriptList.indexWhere((element) => element.symbolName == socketData.data?.symbol);
        if (indexOfScript != -1) {
          arrPositionScriptList[indexOfScript].scriptDataFromSocket = socketData.data!.obs;
          if (indexOfScript == 0) {}

          if (arrPositionScriptList[indexOfScript].currentPriceFromSocket != 0.0) {
            arrPositionScriptList[indexOfScript].profitLossValue = arrPositionScriptList[indexOfScript].tradeTypeValue!.toUpperCase() == "BUY"
                ? (double.parse(socketData.data!.bid.toString()) - arrPositionScriptList[indexOfScript].price!) * arrPositionScriptList[indexOfScript].quantity!
                : (arrPositionScriptList[indexOfScript].price! - double.parse(socketData.data!.ask.toString())) * arrPositionScriptList[indexOfScript].quantity!;
          }
        }
        totalPL = 0.0;

        for (var element in arrPositionScriptList) {
          totalPL = totalPL + element.profitLossValue!;
        }
        totalPL = totalPL + userData!.profitLoss!.toDouble();
        // var mainVc = Get.find<MainContainerController>();
        // mainVc.pl = totalPL.obs;
        // mainVc.update();
        totalPosition.value = 0.0;
        for (var element in arrPositionScriptList) {
          totalPosition.value += element.profitLossValue ?? 0.0;
        }
      }

      update();
    }
  }
}
