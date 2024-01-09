import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/constantModelClass.dart';
import 'package:marketdesktop/modelClass/userLogListModelClass.dart';
import '../../../../constant/index.dart';

class LogHistoryController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;
  int pageNumber = 1;
  int totalPage = 0;
  bool isPagingApiCall = false;
  int currentPage = 1;
  ScrollController listcontroller = ScrollController();
  List<UserLogData> arrLog = [];
  bool isLocalDataLoading = true;
  bool isApiCallRunning = false;
  bool isResetCall = false;
  bool isSuccessSelected = true;

  Rx<UserData> selectedUser = UserData().obs;
  Rx<Type> selectedLogType = Type().obs;
  FocusNode submitFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
    // getUserLogList();
  }

  getUserLogList({bool isFromClear = false}) async {
    pageNumber = 1;
    arrLog.clear();
    isLocalDataLoading = true;
    if (isFromClear) {
      isResetCall = true;
    } else {
      isApiCallRunning = true;
    }

    String strFromDate = "";
    String strToDate = "";
    update();
    if (fromDate.value != "Start Date") {
      strFromDate = fromDate.value;
    }
    if (endDate.value != "End Date") {
      strToDate = endDate.value;
    }
    if (isPagingApiCall) {
      return;
    }
    isPagingApiCall = true;
    update();
    var response = await service.userLogsListCall(
      pageNumber,
      logStatus: selectedLogType.value.id ?? "",
      userId: selectedUser.value.userId ?? "",
      startDate: strFromDate,
      endDate: strToDate,
    );

    arrLog.addAll(response!.data!);
    isApiCallRunning = false;
    isPagingApiCall = false;
    isResetCall = false;
    totalPage = response.meta!.totalPage!;
    if (totalPage >= currentPage) {
      currentPage = currentPage + 1;
    }
    update();
  }

  String getnewValue({int index = -1, bool isOld = false}) {
    var isOn = "";
    if (selectedLogType.value.id == "view_only") {
      if (isOld) {
        isOn = arrLog[index].oldViewOnlyValue!;
      } else {
        isOn = arrLog[index].viewOnlyValue!;
      }
    } else if (selectedLogType.value.id == "bet") {
      if (isOld) {
        isOn = arrLog[index].oldBetValue!;
      } else {
        isOn = arrLog[index].betValue!;
      }
    } else if (selectedLogType.value.id == "close_only") {
      if (isOld) {
        isOn = arrLog[index].oldCloseOnlyValue!;
      } else {
        isOn = arrLog[index].closeOnlyValue!;
      }
    } else if (selectedLogType.value.id == "margin_square_off") {
      if (isOld) {
        isOn = arrLog[index].oldAutoSquareOffValue!;
      } else {
        isOn = arrLog[index].autoSquareOffValue!;
      }
    } else if (selectedLogType.value.id == "status") {
      if (isOld) {
        isOn = arrLog[index].oldStatusValue!;
      } else {
        isOn = arrLog[index].statusValue!;
      }
    }

    return isOn;
  }
}
