import 'package:get/get.dart';
import '../../../modelClass/allSymbolListModelClass.dart';
import '../../../modelClass/exchangeListModelClass.dart';
import '../../../constant/index.dart';
import '../../../modelClass/superAdminTradePopUpModelClass.dart';
import '../../MainTabs/ViewTab/MarketWatchScreen/marketWatchController.dart';
import '../../MainTabs/ViewTab/TradeScreen/successTradeListController.dart';
import '../../MainTabs/ViewTab/TradeScreen/successTradeListWrapper.dart';

enum AllowedTrade { NotApplication, Yes, No }

class SuperAdminTradePopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  bool isFilterOpen = true;
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;

  RxString selectedUser = "".obs;
  RxString selectedTradeStatus = "".obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  SuperAdminPopUpModel? values;

  AllowedTrade? selectedAllowedTrade = AllowedTrade.NotApplication;

  redirectTradeScreen() async {
    var marketViewObj = Get.find<MarketWatchController>();
    if (marketViewObj.isBuyOpen != -1) {
      return;
    }

    isCommonScreenPopUpOpen = true;
    currentOpenedScreen = ScreenViewNames.trades;
    Get.put(SuccessTradeListController());
    generalContainerPopup(view: SuccessTradeListScreen(), title: ScreenViewNames.trades);
  }
}
