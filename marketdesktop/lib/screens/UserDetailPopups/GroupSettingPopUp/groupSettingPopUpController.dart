import '../../../modelClass/groupSettingListModelClass.dart';
import '../../BaseController/baseController.dart';
import '../../../constant/index.dart';

class GroupSettingPopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  List<GroupSettingData> arrGroupSetting = [];
  String selectedUserId = "";
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
  }

  groupSettingList() async {
    arrGroupSetting.clear();
    update();
    var response =
        await service.groupSettingListCall(userId: selectedUserId, page: 1);

    arrGroupSetting = response!.data ?? [];
    update();
  }
}
