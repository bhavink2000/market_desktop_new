import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/settelementListModelClass.dart';

import '../../../constant/index.dart';

enum SettlementType { without, within }

class SettlementPopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  bool isFilterOpen = true;
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;
  SettlementType? selectedSettlementType = SettlementType.without;
  List<Profit> arrProfitList = [];
  List<Profit> arrLossList = [];
  String selectedUserId = "";
  Rx<UserData> selectedUser = UserData().obs;
  SettelementData? totalValues;
  bool isApiCallFromApple = true;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getSettelementList();
  }

  getSettelementList() async {
    var response = await service.settelementListCall(1, searchController.text.trim(), selectedUser.value.userId ?? "");
    arrProfitList = response!.data?.profit ?? [];
    arrLossList = response.data?.loss ?? [];
    totalValues = response.data!;
    for (var element in arrProfitList) {
      totalValues!.plProfitGrandTotal = totalValues!.plProfitGrandTotal + element.profitLoss!;
      totalValues!.brkProfitGrandTotal = totalValues!.brkProfitGrandTotal + element.brokerageTotal!;
    }
    totalValues!.profitGrandTotal = totalValues!.plProfitGrandTotal - totalValues!.brkProfitGrandTotal;
    for (var element in arrLossList) {
      totalValues!.plLossGrandTotal = totalValues!.plLossGrandTotal + element.profitLoss!;
      totalValues!.brkLossGrandTotal = totalValues!.brkLossGrandTotal + element.brokerageTotal!;
    }
    totalValues!.LossGrandTotal = totalValues!.plLossGrandTotal - totalValues!.brkLossGrandTotal;
    update();
  }
}
