import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/loginHistoryModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/tableColumnsModelClass.dart';
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
  List<ColumnItem> arrListTitle = [];
  var dict = {
    "1": {
      "title": "Login History",
      "columns": [
        {"title": "LOGIN TIME", "columnId": 0, "width": 180.0, "defaultWidth": 180.0, "position": 1},
        {"title": "LOGOUT TIME", "columnId": 1, "width": 180.0, "defaultWidth": 180.0, "position": 0},
        {"title": "USERNAME", "columnId": 2, "width": 102.0, "defaultWidth": 102.0, "position": 2},
        {"title": "USER TYPE", "columnId": 3, "width": 102.0, "defaultWidth": 102.0, "position": 3},
        {"title": "IP ADDRESS", "columnId": 4, "width": 102.0, "defaultWidth": 102.0, "position": 4},
        {"title": "DEVICE ID", "columnId": 5, "width": 102.0, "defaultWidth": 102.0, "position": 5}
      ]
    }
  };
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    isApiCallRunning = true;
    (dict["1"]?["columns"] as List).forEach((element) {
      arrListTitle.add(ColumnItem.fromJson(element));
    });
    arrListTitle.sort((a, b) {
      return a.position!.compareTo(b.position!);
    });

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
