import 'package:get/get.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';

import '../../../modelClass/accountSummaryModelClass.dart';
import '../../BaseController/baseController.dart';
import '../../../constant/index.dart';
import '../../../modelClass/constantModelClass.dart';
import '../../MainTabs/ViewTab/MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';

enum AccountSummaryType { pl, brk, credit }

class AccountSummaryPopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  RxString fromDate = "".obs;
  RxString endDate = "".obs;
  AccountSummaryType? selectedAccountSummaryType = AccountSummaryType.pl;

  Type selectedType = constantValues!.transactionType!.first;
  List<AccountSummaryData> arrAccountSummary = [];
  Rx<UserData> selectedUser = UserData().obs;
  String selectedUserId = "";
  List<ListItem> arrListTitle = [
    ListItem("DATE TIME", true),
    ListItem("USERNAME", true),
    ListItem("SYMBOL NAME", true),
    ListItem("TYPE", true),
    ListItem("TRANSACTION TYPE", true),
    ListItem("AMOUNT", true),
  ];

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
  }

  refreshView() {
    update();
  }

  accountSummaryList() async {
    arrAccountSummary.clear();
    update();

    var response = await service.accountSummaryCall(search: "", startDate: "", endDate: "", userId: selectedUserId, type: "");

    arrAccountSummary = response!.data ?? [];
    update();
  }
}
