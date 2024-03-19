import 'package:get/get.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/modelClass/creditListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/profileInfoModelClass.dart';
import 'package:marketdesktop/screens/MainContainerScreen/mainContainerController.dart';
import 'package:marketdesktop/screens/MainTabs/UserTab/UserListScreen/userListController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/userDetailsPopUpController.dart';
import 'package:number_to_indian_words/number_to_indian_words.dart';
import '../../../constant/index.dart';
import '../../../constant/screenColumnData.dart';
import '../../../main.dart';
import '../../BaseController/baseController.dart';
import 'package:excel/excel.dart' as excelLib;

enum TransType { Credit, Debit }

class CreditPopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  Rx<ExchangeData> selectedExchange = ExchangeData().obs;

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
    getColumnListFromDB(ScreenIds().userCredit, arrListTitle1);
    amountController.addListener(() {
      update();
    });
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

  String numericToWord() {
    var word = "";

    word = NumToWords.convertNumberToIndianWords(int.parse(amountController.text)).toUpperCase();

    // word.replaceAll("MILLION", "LAC.");
    // word.replaceAll("BILLION", "CR.");

    return word;
  }

  getCreditList() async {
    var response = await service.getCreditListCall(userId: selectedUserId);
    if (response?.statusCode == 200) {
      arrCreditList = response!.data ?? [];
      for (var i = 0; i < arrCreditList.length; i++) {
        if (arrCreditList[i].transactionType == "credit") {
          if (i == 0) {
            arrCreditList[i].balance = arrCreditList[i].amount!;
          } else {
            arrCreditList[i].balance = arrCreditList[i - 1].balance + arrCreditList[i].amount!;
          }
        } else {
          arrCreditList[i].balance = arrCreditList[i - 1].balance - arrCreditList[i].amount!;
        }
      }
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
          Get.find<UserListController>().isPagingApiCall = false;
          Get.find<UserListController>().currentPage = 1;
          Get.find<UserListController>().getUserList(isFromClear: true);
          showSuccessToast(response.meta?.message ?? "");
        }
        getCreditList();
      }
    } else {
      showWarningToast(msg);
    }
  }

  onClickExcel({bool isFromPDF = false}) {
    List<excelLib.TextCellValue?> titleList = [];
    arrListTitle1.forEach((element) {
      titleList.add(excelLib.TextCellValue(element.title!));
    });
    List<List<excelLib.TextCellValue?>> dataList = [];
    arrCreditList.forEach((element) {
      List<excelLib.TextCellValue?> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case UserCreditColumns.dateTime:
            {
              list.add(excelLib.TextCellValue(shortFullDateTime(element.createdAt!)));
            }
          case UserCreditColumns.type:
            {
              list.add(excelLib.TextCellValue(element.transactionType ?? ""));
            }
          case UserCreditColumns.amount:
            {
              list.add(excelLib.TextCellValue(element.amount!.toStringAsFixed(2)));
            }
          case UserCreditColumns.balance:
            {
              list.add(excelLib.TextCellValue(element.balance.toStringAsFixed(2)));
            }

          case UserCreditColumns.comments:
            {
              list.add(excelLib.TextCellValue(element.comment!));
            }

          default:
            {
              list.add(excelLib.TextCellValue(""));
            }
        }
      });
      dataList.add(list);
    });

    exportExcelFile("UserCredit.xlsx", titleList, dataList);
  }

  onClickPDF() async {
    List<String> headers = [];

    arrListTitle1.forEach((element) {
      headers.add(element.title!);
    });
    List<List<dynamic>> dataList = [];
    arrCreditList.forEach((element) {
      List<String> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case UserCreditColumns.dateTime:
            {
              list.add((shortFullDateTime(element.createdAt!)));
            }
          case UserCreditColumns.type:
            {
              list.add((element.transactionType ?? ""));
            }
          case UserCreditColumns.amount:
            {
              list.add((element.amount!.toStringAsFixed(2)));
            }
          case UserCreditColumns.balance:
            {
              list.add((element.balance.toStringAsFixed(2)));
            }

          case UserCreditColumns.comments:
            {
              list.add((element.comment!));
            }
          default:
            {
              list.add((""));
            }
        }
      });
      dataList.add(list);
    });
    exportPDFFile(fileName: "UserCredit", title: "Credit", width: globalMaxWidth, titleList: headers, dataList: dataList);
  }
}
