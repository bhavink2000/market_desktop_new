import '../../../modelClass/groupSettingListModelClass.dart';
import '../../BaseController/baseController.dart';
import '../../../constant/index.dart';
import '../../MainTabs/ViewTab/MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';

class GroupSettingPopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  List<GroupSettingData> arrGroupSetting = [];
  String selectedUserId = "";
  List<ListItem> arrListTitle = [
    ListItem("GROUP", true),
    ListItem("LAST UPDATED", true),
    ListItem("VIEW", true),
  ];
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
  }

  refreshView() {
    update();
  }

  groupSettingList() async {
    arrGroupSetting.clear();
    update();
    var response = await service.groupSettingListCall(userId: selectedUserId, page: 1);

    arrGroupSetting = response!.data ?? [];
    update();
  }
}
