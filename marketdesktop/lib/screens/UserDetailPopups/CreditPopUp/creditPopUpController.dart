import 'package:get/get.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/modelClass/creditListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/profileInfoModelClass.dart';
import 'package:marketdesktop/screens/MainContainerScreen/mainContainerController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/userDetailsPopUpController.dart';
import '../../../constant/index.dart';
import '../../BaseController/baseController.dart';

enum TransType { Credit, Debit }

class CreditPopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  bool isFilterOpen = true;
  RxString fromDate = "Start Date".obs;
  RxString selectedOperation = "".obs;
  RxString endDate = "End Date".obs;
  TextEditingController commentController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  List<creditData> arrCreditList = [];
  TransType? selectedTransType = TransType.Credit;
  String selectedUserId = "";
  ProfileInfoData? selectedUserData;
  bool isApiCallRunning = false;
  FocusNode submitFocus = FocusNode();
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
  }
  //*********************************************************************** */
  // Field Validation
  //*********************************************************************** */

  String validateField() {
    var msg = "";

    if (amountController.text.trim().isEmpty) {
      msg = AppString.emptyAmount;
    }
    return msg;
  }

  getCreditList() async {
    var response = await service.getCreditListCall(userId: selectedUserId);
    if (response?.statusCode == 200) {
      arrCreditList = response!.data ?? [];
      update();
    }

    // var arrTemp = [];
    // for (var element in response.data!) {
    //   arrTemp.insert(0, element.symbolName);
    // }

    // if (arrTemp.isNotEmpty) {
    //   var txt = {"symbols": arrTemp};
    //   socket.connectScript(jsonEncode(txt));
    // }
  }

  getUSerInfo() async {
    update();
    var userResponse = await service.profileInfoByUserIdCall(selectedUserId);
    if (userResponse != null) {
      if (userResponse.statusCode == 200) {
        selectedUserData = userResponse.data;

        update();
      }
    }
  }

  callForAddAmount() async {
    var msg = validateField();
    if (msg.isEmpty) {
      isApiCallRunning = true;
      update();
      var response = await service.addCreditCall(userId: selectedUserId, comment: commentController.text.trim(), amount: amountController.text.trim(), type: "credit", transactionType: selectedTransType == TransType.Credit ? "credit" : "debit");
      isApiCallRunning = false;
      update();
      if (response != null) {
        if (response.statusCode == 200) {
          amountController.clear();
          commentController.clear();
          Get.find<MainContainerController>().getOwnProfile();
          Get.find<UserDetailsPopUpController>().getUSerInfo();
          showSuccessToast(response.meta?.message ?? "");
        }
        getCreditList();
      }
    } else {
      showWarningToast(msg);
    }
  }
}
