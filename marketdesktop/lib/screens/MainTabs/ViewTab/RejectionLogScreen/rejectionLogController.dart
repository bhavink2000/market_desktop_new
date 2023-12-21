import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/rejectLogLisTModelClass.dart';
import '../../../../constant/index.dart';

class RejectionLogController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  bool isFilterOpen = false;
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;
  Rx<UserData> selectedUser = UserData().obs;
  RxString selectedTradeStatus = "".obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  List<ExchangeData> arrExchange = [];
  List<GlobalSymbolData> arrAllScript = [];
  List<RejectLogData> arrRejectLog = [];
  bool isApiCallRunning = false;
  bool isResetCall = false;
  String selectedUserId = "";
  int totalPage = 0;
  int currentPage = 1;
  bool isPagingApiCall = false;
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    isApiCallRunning = true;
    rejectLogList();
  }

  rejectLogList({bool isFromClear = false, bool isFromFilter = false}) async {
    if (isFromFilter) {
      if (isFromClear) {
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
    var response = await service.getRejectLogListCall(page: currentPage, startDate: "", endDate: "", userId: selectedUser.value.userId ?? "", exchangeId: selectedExchange.value.exchangeId ?? "", symbolId: selectedScriptFromFilter.value.symbolId ?? "");

    isApiCallRunning = false;
    isPagingApiCall = false;
    isResetCall = false;
    totalPage = response!.meta!.totalPage!;
    if (totalPage >= currentPage) {
      currentPage = currentPage + 1;
    }
    update();
    arrRejectLog.addAll(response.data!);
    update();
  }
}
