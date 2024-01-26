import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/positionTrackListModelClass.dart';

import '../../../../modelClass/allSymbolListModelClass.dart';
import '../../../../modelClass/exchangeListModelClass.dart';
import '../../../../constant/index.dart';
import '../../ViewTab/MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';

class UserScriptPositionTrackController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;

  Rx<UserData> selectedUser = UserData().obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  ScrollController mainScroll = ScrollController();
  List<PositionTrackData> arrTracking = [];
  bool isApiCallRunning = false;
  bool isFilterApiCallRunning = false;
  bool isClearApiCallRunning = false;
  bool isPagingApiCall = false;
  int totalPage = 0;
  int currentPage = 1;
  int totalCount = 0;

  List<ListItem> arrListTitle = [
    ListItem("POSITION DATE", true),
    ListItem("USERNAME", true),
    ListItem("SYMBOL", true),
    ListItem("POSITION", true),
    ListItem("OPEN QUANTITY", true),
  ];
  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
    trackList();
  }

  refreshView() {
    update();
  }

  trackList() async {
    if (isPagingApiCall) {
      return;
    }

    isPagingApiCall = true;
    update();
    var response = await service.positionTrackingListCall(
      page: currentPage,
      userId: selectedUser.value.userId ?? "",
      symbolId: selectedScriptFromFilter.value.symbolId ?? "",
      exchangeId: selectedExchange.value.exchangeId ?? "",
      endDate: endDate.value == "End Date" ? "" : endDate.value,
    );
    arrTracking.addAll(response!.data!);
    isApiCallRunning = false;
    isPagingApiCall = false;
    isFilterApiCallRunning = false;
    isClearApiCallRunning = false;
    totalCount = response.meta!.totalCount!;
    totalPage = response.meta!.totalPage!;
    if (totalPage >= currentPage) {
      currentPage = currentPage + 1;
    }
    update();
  }
}
