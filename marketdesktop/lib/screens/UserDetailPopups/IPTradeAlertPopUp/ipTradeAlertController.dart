import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/ipTradeAlertModelClass.dart';
import '../../../modelClass/allSymbolListModelClass.dart';
import '../../../modelClass/exchangeListModelClass.dart';
import '../../../constant/index.dart';
import '../../MainTabs/ViewTab/MarketWatchScreen/marketWatchController.dart';
import '../../MainTabs/ViewTab/TradeScreen/successTradeListController.dart';
import '../../MainTabs/ViewTab/TradeScreen/successTradeListWrapper.dart';

enum AllowedTrade { NotApplication, Yes, No }

class IPTradeAlertPopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;

  RxString selectedUser = "".obs;
  RxString selectedTradeStatus = "".obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  IpTradeAlertModel? values;

  AllowedTrade? selectedAllowedTrade = AllowedTrade.NotApplication;

  redirectTradeScreen() async {
    var marketViewObj = Get.find<MarketWatchController>();
    if (marketViewObj.isBuyOpen != -1) {
      return;
    }

    isCommonScreenPopUpOpen = true;
    currentOpenedScreen = ScreenViewNames.trades;
    var tradeVC = Get.put(SuccessTradeListController());
    tradeVC.selectedExchange.value.exchangeId = values!.exchangeId!;
    tradeVC.selectedExchange.value.name = values!.exchangeName!;
    tradeVC.selectedScriptFromFilter.value.symbolId = values!.symbolId!;
    tradeVC.selectedScriptFromFilter.value.symbolName = values!.symbolName!;
    tradeVC.selectedScriptFromFilter.value.symbolTitle = values!.symbolTitle!;

    generalContainerPopup(view: SuccessTradeListScreen(), title: ScreenViewNames.trades);
  }
}
