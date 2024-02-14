import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/positionModelClass.dart';
import 'package:marketdesktop/modelClass/profileInfoModelClass.dart';

import '../../../main.dart';
import '../../../modelClass/allSymbolListModelClass.dart';
import '../../../modelClass/exchangeListModelClass.dart';

import '../../../constant/index.dart';
import '../../../modelClass/getScriptFromSocket.dart';
import '../../MainTabs/ViewTab/MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';

class OpenPositionPopUpController extends BaseController {
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
  String selectedUserId = "";
  double totalPL = 0.0;
  RxDouble totalPosition = 0.0.obs;
  List<ListItem> arrListTitle = [
    // ListItem("", true),
    ListItem("USERNAME", true),
    // if (userData!.role != UserRollList.user) ListItem("PARENT USER", true),
    ListItem("EXCHANGE", true),
    ListItem("SYMBOL NAME", true),
    ListItem("TOTAL BUY A QTY", true),
    ListItem("TOTAL BUY A PRICE", true),
    ListItem("TOTAL SELL QTY", true),
    ListItem("SELL A PRICE", true),
    ListItem("NET QTY", true),
    ListItem("NET LOT", true),
    ListItem("NET A PRICE", true),
    ListItem("CMP", true),
    ListItem("P/L", true),
    if (userData!.role != UserRollList.user) ListItem("P/L % WISE", true),
  ];
  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
  }

  refreshView() {
    update();
  }

  getPositionList(String text) async {
    isApiCallRunning = true;
    update();
    var response = await service.openPositionListCall(1, symbolId: symbolId, exchangeId: selectedExchange.value.exchangeId ?? "", userId: selectedUser.value.userId ?? "", search: "");
    arrPositionScriptList = response!.data ?? [];
    isApiCallRunning = false;

    update();
    // var arrTemp = [];
    // for (var element in response.data!) {
    //   arrTemp.insert(0, element.symbolName);
    // }

    // if (arrTemp.isNotEmpty) {
    //   var txt = {"symbols": arrTemp};
    //   socket.connectScript(jsonEncode(txt));
    // }
  }

  num getPlPer({num? cmp, num? netAPrice}) {
    var temp1 = cmp! - netAPrice!;
    var temp2 = temp1 / netAPrice;
    var temp3 = temp2 * 100;
    return temp3;
  }

  listenPositionScriptFromSocket(GetScriptFromSocket socketData) {
    if (socketData.status == true) {
      var obj = arrPositionScriptList.firstWhereOrNull((element) => socketData.data!.symbol == element.symbolName);

      if (obj != null) {
        var indexOfScript = arrPositionScriptList.indexWhere((element) => element.symbolName == socketData.data?.symbol);
        if (indexOfScript != -1) {
          arrPositionScriptList[indexOfScript].scriptDataFromSocket = socketData.data!.obs;
          arrPositionScriptList[indexOfScript].bid = socketData.data!.bid;
          arrPositionScriptList[indexOfScript].ask = socketData.data!.ask;
          arrPositionScriptList[indexOfScript].ltp = socketData.data!.ltp;
          if (indexOfScript == 0) {}

          if (arrPositionScriptList[indexOfScript].currentPriceFromSocket != 0.0) {
            arrPositionScriptList[indexOfScript].profitLossValue = arrPositionScriptList[indexOfScript].totalQuantity! < 0
                ? (double.parse(arrPositionScriptList[indexOfScript].bid.toString()) - arrPositionScriptList[indexOfScript].price!) * arrPositionScriptList[indexOfScript].totalQuantity!
                : (arrPositionScriptList[indexOfScript].ask! - double.parse(arrPositionScriptList[indexOfScript].price.toString())) * arrPositionScriptList[indexOfScript].totalQuantity!;
          }
        }
        totalPL = 0.0;

        for (var element in arrPositionScriptList) {
          totalPL = totalPL + element.profitLossValue!;
        }
        // totalPL = totalPL + userData!.profitLoss!.toDouble();
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

  getUSerInfo() async {
    isProfileApiCallRunning = true;
    update();
    var userResponse = await service.profileInfoByUserIdCall(selectedUserId);
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
}
