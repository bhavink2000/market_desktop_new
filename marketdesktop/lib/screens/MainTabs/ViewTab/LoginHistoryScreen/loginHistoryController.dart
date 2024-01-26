import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/loginHistoryModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
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
  List<ListItem> arrListTitle = [
    ListItem("LOGIN TIME", true),
    ListItem("LOGOUT TIME", true),
    ListItem("USERNAME", true),
    ListItem("USER TYPE", true),
    ListItem("IP ADDRESS", true),
    ListItem("DEVICEID", true),
  ];
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    isApiCallRunning = true;
    loginHistoryList();
  }

  refreshView() {
    update();
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
