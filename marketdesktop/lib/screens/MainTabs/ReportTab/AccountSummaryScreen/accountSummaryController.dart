import 'package:floating_dialog/floating_dialog.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/accountSummaryModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/tradeDetailModelClass.dart';
import 'package:marketdesktop/screens/UserDetailPopups/AccountSummaryPopUp/accountSummaryPopUpController.dart';
import '../../../../constant/index.dart';
import '../../../../modelClass/constantModelClass.dart';

class AccountSummaryController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  bool isFilterOpen = false;
  RxString fromDate = "".obs;
  RxString endDate = "".obs;
  AccountSummaryType? selectedAccountSummaryType;
  Rx<UserData> selectedUser = UserData().obs;
  Type? selectedType;
  List<AccountSummaryData> arrAccountSummary = [];
  bool isApiCallRunning = false;
  bool isResetCall = false;
  num totalAmount = 0.0;
  bool isPagingApiCall = false;
  int totalPage = 0;
  int currentPage = 1;
  TradeDetailData tradeDetail = TradeDetailData();
  bool isApiCall = false;
  var tradeID = "";
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    isApiCallRunning = true;
    accountSummaryList();
  }

  accountSummaryList({bool isFromFilter = false, bool isFromClear = false}) async {
    if (isFromFilter) {
      if (isFromClear) {
        isResetCall = true;
      } else {
        isApiCallRunning = true;
      }
    }
    if (isPagingApiCall) {
      return;
    }
    isPagingApiCall = true;
    update();
    var response = await service.accountSummaryCall(search: "", startDate: fromDate.value, endDate: endDate.value, page: currentPage, userId: selectedUser.value.userId != null ? selectedUser.value.userId! : "", type: selectedType != null ? selectedType!.id : "");
    isApiCallRunning = false;
    isResetCall = false;

    update();
    arrAccountSummary.addAll(response!.data!);
    isPagingApiCall = false;
    totalPage = response.meta!.totalPage!;
    if (totalPage >= currentPage) {
      currentPage = currentPage + 1;
    }
    totalAmount = 0;
    for (var element in arrAccountSummary) {
      totalAmount = element.amount! + totalAmount;
    }
    update();
  }

  getTradeDetail() async {
    isApiCall = true;
    update();
    var response = await service.getTradeDetailCall(tradeID);
    isApiCall = false;
    update();
    if (response?.statusCode == 200) {
      tradeDetail = response!.data!;
      update();
      isUserDetailPopUpOpen = true;
      tradeDetailBottomSheet();
    }

    //print(response);
  }

  Widget headerViewContent(BuildContext context) {
    return Container(
        width: 100.w,
        height: 4.h,
        decoration: BoxDecoration(
            color: AppColors().whiteColor,
            border: Border(
              bottom: BorderSide(color: AppColors().lightOnlyText, width: 1),
            )),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Image.asset(
              AppImages.appLogo,
              width: 3.h,
              height: 3.h,
            ),
            const SizedBox(
              width: 10,
            ),
            Text("Trade Details [${tradeDetail.userName}]",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().blueColor,
                )),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: 3.h,
                height: 3.h,
                padding: EdgeInsets.all(0.5.h),
                child: Image.asset(
                  AppImages.closeIcon,
                  color: AppColors().redColor,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ));
  }

  tradeDetailBottomSheet() {
    showDialog<String>(
        context: Get.context!,
        // barrierColor: Colors.transparent,
        barrierDismissible: true,
        builder: (BuildContext context) => FloatingDialog(
              // titlePadding: EdgeInsets.zero,
              // backgroundColor: AppColors().bgColor,
              // surfaceTintColor: AppColors().bgColor,

              // contentPadding: EdgeInsets.zero,
              // insetPadding: EdgeInsets.symmetric(
              //   horizontal: 20.w,
              //   vertical: 32.h,
              // ),
              enableDragAnimation: false,
              child: Container(
                // width: 30.w,
                // height: 28.h,
                width: 25.w,
                height: 40.h,
                decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
                child: Column(
                  children: [
                    headerViewContent(Get.context!),
                    Container(
                        height: 35.5.h,
                        decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)), color: AppColors().bgColor),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView(
                                physics: const ClampingScrollPhysics(),
                                clipBehavior: Clip.hardEdge,
                                shrinkWrap: true,
                                children: [
                                  sheetList("Username", tradeDetail.userName ?? "", 0),
                                  sheetList("Order Time", tradeDetail.executionDateTime != null ? shortFullDateTime(tradeDetail.executionDateTime!) : "", 1),
                                  sheetList("Symbol", tradeDetail.symbolName ?? "", 2),
                                  sheetList("Order Type", tradeDetail.orderType ?? "", 3),
                                  sheetList("Trade Type", tradeDetail.tradeTypeValue ?? "", 4),
                                  sheetList("Quantity", tradeDetail.quantity!.toString(), 5),
                                  sheetList("Price", tradeDetail.price.toString(), 6),
                                  sheetList("Order Method", tradeDetail.orderMethod ?? "", 7),
                                  sheetList("Device Id", tradeDetail.deviceId ?? "", 8),
                                  // sheetList("Brk", "155.92", 6),
                                  // sheetList("Reference Price", "389.8", 7),

                                  // sheetList("Ipaddress", "152.58.4.124", 9),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ));
  }

  Widget sheetList(String name, String value, int index) {
    Color backgroundColor = index % 2 == 1 ? AppColors().headerBgColor : AppColors().contentBg;
    return Container(
      width: 100.w,
      height: 38,
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Row(
          children: [
            Text(name.toString(), style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Regular, color: AppColors().lightText)),
            const Spacer(),
            Text(value.toString(), style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
          ],
        ),
      ),
    );
  }
}
