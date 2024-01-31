import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/rejectLogLisTModelClass.dart';
import '../../../../constant/index.dart';
import '../../MainTabs/ViewTab/MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';

class RejectionLogPopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  RxString fromDate = "".obs;
  RxString endDate = "".obs;
  List<RejectLogData> arrRejectLog = [];
  Rx<UserData> selectedUser = UserData().obs;
  RxString selectedTradeStatus = "".obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  bool isApiCallRunning = false;
  String selectedUserId = "";
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  List<ListItem> arrListTitle = [
    ListItem("DATE", true),
    ListItem("MESSAGE", true),
    ListItem("USERNAME", true),
    ListItem("SYMBOL", true),
    ListItem("TYPE", true),
    ListItem("QUANTITY", true),
    ListItem("PRICE", true),
    ListItem("IP ADDRESS", true),
    ListItem("DEVICE ID", true),

  ];
   
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
  }

  refreshView() {
    update();
  }

  rejectLogList() async {
    arrRejectLog.clear();
    isApiCallRunning = true;
    update();
    var response = await service.getRejectLogListCall(page: 1, startDate: "", endDate: "", userId: selectedUserId, exchangeId: selectedExchange.value.exchangeId ?? "", symbolId: selectedScriptFromFilter.value.symbolId ?? "");

    isApiCallRunning = false;
    update();
    arrRejectLog = response!.data ?? [];
    update();
  }
}
