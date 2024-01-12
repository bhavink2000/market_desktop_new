import 'package:get/get.dart';
import 'package:marketdesktop/constant/index.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/screens/MainTabs/UserTab/UserListScreen/userListController.dart';

import '../../../../../modelClass/constantModelClass.dart';
import '../../../../../modelClass/myUserListModelClass.dart';
import '../../../../BaseController/baseController.dart';

class LeverageUpdateControllerBinding implements Bindings {
  @override
  void dependencies() {
    // Get.put(() => SignInController());
    Get.put(LeverageUpdateController());
  }
}

class LeverageUpdateController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  bool isApiCallRunning = false;
  UserData selectedUser = UserData();
  GlobalKey? dropdownLeveargeKey;
  Rx<AddMaster> selectedLeverage = AddMaster().obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    update();
    isUpdateLeveragePopUpOpen = true;
    Future.delayed(Duration(milliseconds: 300), () {
      var obj = arrLeverageList.firstWhereOrNull((element) => element.name == selectedUser.leverage);
      if (obj != null) {
        selectedLeverage.value = obj;
        update();
      }
    });
  }

//*********************************************************************** */
  // Api Calls
  //*********************************************************************** */

  callForUpdateLeverage() async {
    isApiCallRunning = true;
    update();

    var response = await service.updateLeverageCall(selectedLeverage.value.id!, userId: selectedUser.userId!);
    if (response != null) {
      isApiCallRunning = false;
      if (response.statusCode == 200) {
        Get.back();
        await Get.delete<LeverageUpdateController>();
        isUpdateLeveragePopUpOpen = false;
        Get.find<UserListController>().getUserList(isFromClear: true);
        showSuccessToast(response.meta?.message ?? "");
        update();
      } else {
        showErrorToast(response.message ?? "");
        update();
      }
    } else {
      showErrorToast(AppString.generalError);
      update();
    }
  }
}
