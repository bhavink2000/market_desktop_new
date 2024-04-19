import 'package:get/get.dart';
import 'package:marketdesktop/constant/index.dart';
import 'package:marketdesktop/screens/MainTabs/UserTab/UserListScreen/userListController.dart';

import '../../../../../modelClass/constantModelClass.dart';
import '../../../../../modelClass/myUserListModelClass.dart';
import '../../../../BaseController/baseController.dart';

class UserAccessUpdatePopUpControllerBinding implements Bindings {
  @override
  void dependencies() {
    // Get.put(() => SignInController());
    Get.put(UserAccessUpdatePopUpController());
  }
}

class UserAccessUpdatePopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  bool isApiCallRunning = false;
  Rx<UserData> selectedUser = UserData().obs;
  GlobalKey? dropdownLeveargeKey;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    update();
    isUpdateLeveragePopUpOpen = true;
  }

//*********************************************************************** */
  // Api Calls
  //*********************************************************************** */

  updateUserStatus(Map<String, Object?>? payload) async {
    await service.userChangeStatusCall(payload: payload);
    var index = Get.find<UserListController>().arrUserListData.indexWhere((element) => element.userId == selectedUser.value.userId);

    if (index != -1) {
      Get.find<UserListController>().arrUserListData[index] = selectedUser.value;
      Get.find<UserListController>().update();
    }
  }
}
