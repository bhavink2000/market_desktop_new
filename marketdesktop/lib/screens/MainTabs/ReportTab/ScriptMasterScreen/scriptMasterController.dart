import 'package:get/get.dart';
import 'package:marketdesktop/screens/UserDetailPopups/scriptMasterPopUp/scriptMasterPopUpController.dart';

import '../../../../modelClass/allSymbolListModelClass.dart';
import '../../../../modelClass/exchangeListModelClass.dart';
import '../../../../constant/index.dart';
import '../../../../modelClass/tradeMarginListModelClass.dart';

class ScriptMasterController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  bool isFilterOpen = false;
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
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    tradeMarginList(isFromFilter: true);
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
