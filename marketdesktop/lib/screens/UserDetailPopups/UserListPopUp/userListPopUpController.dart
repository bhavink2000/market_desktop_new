import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/constantModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/userRoleListModelClass.dart';
import '../../../../constant/index.dart';

class UserListPopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;
  bool isFilterOpen = false;
  List<UserData> arrUserListData = [];

  Rx<AddMaster> selectedFilterType = AddMaster().obs;
  Rx<userRoleListData> selectedUserType = userRoleListData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  Rx<AddMaster> selectUserStatusdropdownValue = AddMaster().obs;
  TextEditingController textController = TextEditingController();
  Rx<AddMaster> selectStatusdropdownValue = AddMaster().obs;
  Rx<userRoleListData> selectUserdropdownValue = userRoleListData().obs;
  Rx<AddMaster> userdropdownValue = AddMaster().obs;
  bool isLoadingData = false;
  bool isResetData = false;
  String selectedUserId = "";

  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();

    callForRoleList();
  }

  getUserList({bool isFromClear = false}) async {
    arrUserListData.clear();
    if (isFromClear) {
      isResetData = true;
    } else {
      isLoadingData = true;
    }

    update();
    var response = await service.getMyUserListCall(
      text: textController.text.trim(),
      status: selectUserStatusdropdownValue.value.id?.toString() ?? "",
      roleId: selectedUserType.value.roleId ?? "",
      userId: selectedUserId,
      filterType: selectedFilterType.value.id?.toString() ?? "",
    );
    if (isFromClear) {
      isResetData = false;
    } else {
      isLoadingData = false;
    }
    if (response != null) {
      if (response.statusCode == 200) {
        arrUserListData = response.data ?? [];

        update();
      }
    }
  }
}
