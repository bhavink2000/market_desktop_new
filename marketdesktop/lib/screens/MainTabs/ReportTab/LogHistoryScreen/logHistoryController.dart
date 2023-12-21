import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import '../../../../constant/index.dart';

class LogHistoryController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;
  bool isFilterOpen = false;
  Rx<UserData> selectedUser = UserData().obs;
  RxString selectedLogType = "".obs;
  FocusNode submitFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
  }
}
