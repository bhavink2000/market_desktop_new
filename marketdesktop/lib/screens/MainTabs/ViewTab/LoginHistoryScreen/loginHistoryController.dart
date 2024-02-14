import 'package:get/get.dart';
import 'package:marketdesktop/constant/screenColumnData.dart';
import 'package:marketdesktop/modelClass/loginHistoryModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/tableColumnsModelClass.dart';
import 'package:marketdesktop/service/database/dbService.dart';
import '../../../../constant/index.dart';
import '../../../BaseController/baseController.dart';
import '../MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';

class LoginHistoryController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;
  List<LoginHistoryData> arrLoginHistory = [];
  Rx<UserData> selectedUser = UserData().obs;
  bool isApiCallRunning = false;
  bool isPagingApiCall = false;
  int totalPage = 0;
  int currentPage = 1;
  ScrollController mainScroll = ScrollController();

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    isApiCallRunning = true;
    getColumnListFromDB(ScreenIds().loginHistory, arrListTitle1);
    update();
    loginHistoryList();
  }

  loginHistoryList() async {
    if (isPagingApiCall) {
      return;
    }
    isPagingApiCall = true;
    update();
    var response = await service.loginHistoryListCall(currentPage);
    arrLoginHistory.addAll(response!.data!);
    isApiCallRunning = false;
    isPagingApiCall = false;
    totalPage = response.meta!.totalPage!;
    if (totalPage >= currentPage) {
      currentPage = currentPage + 1;
    }
    update();
  }
}
