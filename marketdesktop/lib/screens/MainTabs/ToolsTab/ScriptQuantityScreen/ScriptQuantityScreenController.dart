import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../constant/const_string.dart';
import '../../../../constant/utilities.dart';
import '../../../../main.dart';
import '../../../../modelClass/exchangeListModelClass.dart';
import '../../../../modelClass/groupListModelClass.dart';
import '../../../../modelClass/myUserListModelClass.dart';
import '../../../../modelClass/scriptQuantityModelClass.dart';
import '../../../BaseController/baseController.dart';
import '../../ViewTab/MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';

class ScriptQuantityControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScriptQuantityController());
  }
}

class ScriptQuantityController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  ScrollController listcontroller = ScrollController();
  Rx<ExchangeData> selectExchangeDropdownValue = ExchangeData().obs;
  Rx<groupListModelData> selectGroupDropdownValue = groupListModelData().obs;
  final TextEditingController searchScriptextEditingController = TextEditingController();
  FocusNode searchScripttextEditingFocus = FocusNode();
  Rx<UserData> selectUserdropdownValue = UserData().obs;

  bool isDarkMode = false;
  List<scriptQuantityData> arrData = [];
  int pageNumber = 1;
  int totalPage = 0;

  bool isLocalDataLoading = true;
  List<ExchangeData> arrExchangeList = [];
  List<groupListModelData> arrGroupList = [];
  List<UserData> arrUserDataDropDown = [];
  bool isApiCallRunning = false;
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  List<ListItem> arrListTitle = [
    ListItem("SYMBOL", true),
    ListItem("BREAKUP QTY", true),
    ListItem("MAX QTY", true),
    ListItem("BREAKUP LOT", true),
    ListItem("MAX LOT", true),
  ];

  @override
  void onInit() async {
    super.onInit();
    if (userData!.role == UserRollList.user) {
      selectUserdropdownValue.value = UserData(userId: userData!.userId);
    }
    getExchangeList();
    getUserList();
    // getQuantityList();
    update();

    listcontroller.addListener(() async {
      if ((listcontroller.position.pixels > listcontroller.position.maxScrollExtent / 2.5 && totalPage > 1 && pageNumber < totalPage && !isLocalDataLoading)) {
        isLocalDataLoading = true;
        pageNumber++;
        update();
        var response = await service.getScriptQuantityListCall(text: "", userId: selectUserdropdownValue.value.userId ?? "", groupId: "", page: pageNumber);
        if (response != null) {
          if (response.statusCode == 200) {
            totalPage = response.meta?.totalPage ?? 0;

            for (var v in response.data!) {
              arrData.add(v);
            }
            isLocalDataLoading = false;
            update();
          }
        }
      }
    });
  }

  refreshView() {
    update();
  }

  getExchangeList() async {
    var response = await service.getExchangeListUserWiseCall(userId: userData!.userId!);
    if (response != null) {
      if (response.statusCode == 200) {
        arrExchangeList = response.exchangeData ?? [];
        update();
      }
    }
  }

  callforGroupList(
    String? ExchangeId,
  ) async {
    update();
    var response = await service.getGroupListCall(ExchangeId);
    if (response != null) {
      if (response.statusCode == 200) {
        arrGroupList = response.data ?? [];
        update();
      } else {
        showErrorToast(response.meta!.message ?? "");
        return [];
      }
    } else {
      showErrorToast(AppString.generalError);
      return [];
    }
  }

  getUserList() async {
    var response = await service.getMyUserListCall();
    if (response != null) {
      if (response.statusCode == 200) {
        arrUserDataDropDown = response.data ?? [];
        update();
      }
    }
  }

  getQuantityList() async {
    if (selectGroupDropdownValue.value.groupId == null) {
      showWarningToast("Please select group");
      return;
    }
    pageNumber = 1;
    arrData.clear();

    isLocalDataLoading = true;
    isApiCallRunning = true;
    update();
    var response = await service.getScriptQuantityListCall(text: "", userId: selectUserdropdownValue.value.userId ?? "", groupId: selectGroupDropdownValue.value.groupId, page: pageNumber);
    if (response != null) {
      isLocalDataLoading = false;
      isApiCallRunning = false;
      update();
      if (response.statusCode == 200) {
        totalPage = response.meta?.totalCount ?? 0;
        arrData.addAll(response.data ?? []);
        update();
      }
    }
  }
}
