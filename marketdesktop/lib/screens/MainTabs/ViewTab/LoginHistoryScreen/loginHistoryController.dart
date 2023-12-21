import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/loginHistoryModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import '../../../../constant/index.dart';
import '../../../BaseController/baseController.dart';

class LoginHistoryController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  bool isFilterOpen = false;
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
