import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/constantModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/userRoleListModelClass.dart';
import '../../../../constant/index.dart';

class UserListController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;

  List<UserData> arrUserListData = [];
  int selectedUserIndex = -1;
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
  bool isPagingApiCall = false;
  int totalPage = 0;
  int totalRecord = 0;
  int currentPage = 1;
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  double totalPL = 0.0;
  double totalPLPercentage = 0.0;
  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();

    callForRoleList();
    isLoadingData = true;
    getUserList();
  }

  num getPlPer({num? percentage, num? pl}) {
    var temp1 = pl! * percentage!;
    var temp2 = temp1 / 100;

    return temp2;
  }

  getUserList({bool isFromClear = false, bool isFromButtons = false}) async {
    if (isPagingApiCall) {
      return;
    }
    isPagingApiCall = true;
    if (isFromButtons) {
      if (isFromClear) {
        isResetData = true;
      } else {
        isLoadingData = true;
      }
    }

    update();
    var response = await service.getMyUserListCall(
      text: textController.text.trim(),
      page: currentPage,
      status: selectUserStatusdropdownValue.value.id?.toString() ?? "",
      roleId: selectedUserType.value.roleId ?? "",
      filterType: selectedFilterType.value.id?.toString() ?? "",
    );
    if (isFromClear) {
      isResetData = false;
    } else {
      isLoadingData = false;
    }
    if (response != null) {
      if (response.statusCode == 200) {
        arrUserListData.addAll(response.data!);
        isPagingApiCall = false;
        totalPage = response.meta!.totalPage!;
        totalRecord = response.meta!.totalCount!;
        totalPL = 0.0;
        totalPLPercentage = 0.0;
        for (var element in arrUserListData) {
          totalPL = totalPL + element.profitLoss!;
          var temp = element.profitLoss! / 100;
          totalPLPercentage = totalPLPercentage + temp;
        }
        if (totalPage >= currentPage) {
          currentPage = currentPage + 1;
        }
        update();
      } else {
        update();
      }
    }
  }
}
