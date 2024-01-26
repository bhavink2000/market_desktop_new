import 'package:get/get.dart';
import 'package:marketdesktop/screens/UserDetailPopups/scriptMasterPopUp/scriptMasterPopUpController.dart';

import '../../../../modelClass/allSymbolListModelClass.dart';
import '../../../../modelClass/exchangeListModelClass.dart';
import '../../../../constant/index.dart';
import '../../../../modelClass/tradeMarginListModelClass.dart';
import '../../ViewTab/MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';

class ScriptMasterController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;

  RxString selectedUser = "".obs;
  RxString selectedTradeStatus = "".obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  TextEditingController searchController = TextEditingController();

  AllowedTrade? selectedAllowedTrade = AllowedTrade.NotApplication;
  FocusNode viewFocus = FocusNode();
  FocusNode saveFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  bool isApiCallRunning = false;
  bool isClearApiCallRunning = false;
  bool isPagingApiCall = false;
  int totalPage = 0;
  int currentPage = 1;
  int totalCount = 0;
  List<TradeMarginData> arrTradeMargin = [];

  List<ListItem> arrListTitle = [
    ListItem("EXCHANGE", true),
    ListItem("SCRIPT", true),
    ListItem("EXPIRY DATE", true),
    ListItem("DESCRIPTION", true),
    ListItem("TRADE ATTRIBUTE", true),
    ListItem("ALLOW TRADE", true),
  ];

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    tradeMarginList(isFromFilter: true);
  }

  refreshView() {
    update();
  }

  tradeMarginList({bool isFromFilter = false, bool isFromClear = false}) async {
    if (isFromFilter) {
      arrTradeMargin.clear();
      currentPage = 1;
      if (isFromClear) {
        isClearApiCallRunning = true;
      } else {
        isApiCallRunning = true;
      }
    }
    if (isPagingApiCall) {
      return;
    }
    isPagingApiCall = true;
    update();
    var response = await service.tradeMarginListCall(page: currentPage, exchangeId: selectedExchange.value.exchangeId ?? "", text: searchController.text);
    arrTradeMargin.addAll(response!.data!);
    isApiCallRunning = false;
    isPagingApiCall = false;
    isClearApiCallRunning = false;
    totalCount = response.meta!.totalCount!;
    totalPage = response.meta!.totalPage!;
    if (totalPage >= currentPage) {
      currentPage = currentPage + 1;
    }
    update();
  }
}
