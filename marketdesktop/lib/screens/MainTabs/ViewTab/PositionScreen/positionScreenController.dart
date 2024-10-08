import 'dart:convert';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:floating_dialog/floating_dialog.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/customWidgets/appTextField.dart';
import 'package:marketdesktop/customWidgets/incrimentField.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/getScriptFromSocket.dart';
import 'package:marketdesktop/modelClass/ltpUpdateModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/modelClass/positionModelClass.dart';
import '../../../../constant/index.dart';
import '../../../../constant/screenColumnData.dart';
import '../../../../modelClass/constantModelClass.dart';
import '../../../../modelClass/squareOffPositionRequestModelClass.dart';
import 'package:excel/excel.dart' as excelLib;

import '../../../../modelClass/userRoleListModelClass.dart';

class PositionController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  Rx<UserData> selectedUser = UserData().obs;
  Rx<userRoleListData> selectedRoll = userRoleListData().obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  List<positionListData> arrPositionScriptList = [];
  // Rx<positionListData>? selectedScript;
  RxDouble totalPosition = 0.0.obs;
  List<UserData> arrUserListOnlyClient = [];
  List<Type> arrValidaty = [];
  Rx<Type> selectedOrderType = Type().obs;
  TextEditingController qtyController = TextEditingController();
  FocusNode qtyFocus = FocusNode();
  TextEditingController lotController = TextEditingController();
  FocusNode lotFocus = FocusNode();
  TextEditingController priceController = TextEditingController();
  FocusNode priceFocus = FocusNode();
  TextEditingController exchangeController = TextEditingController();
  FocusNode exchangeFocus = FocusNode();
  TextEditingController symbolController = TextEditingController();
  FocusNode symbolFocus = FocusNode();
  RxBool isTradeCallFinished = true.obs;
  double visibleWidth = 0.0;
  Rx<Type> selectedValidity = Type().obs;
  final FocusNode focusNode = FocusNode();
  final FocusNode popUpfocusNode = FocusNode();
  List<Type> arrOrderType = [];
  final debouncer = Debouncer(milliseconds: 300);
  bool isKeyPressActive = false;
  Rx<ExchangeData> selectedExchangeFromPopup = ExchangeData().obs;
  Rx<ScriptData> selectedScriptFromPopup = ScriptData().obs;

  TextEditingController rlController = TextEditingController();
  FocusNode rlFocus = FocusNode();
  FocusNode applyFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  FocusNode squareOffFocus = FocusNode();
  TextEditingController remarkController = TextEditingController();
  FocusNode remarkFocus = FocusNode();
  int selectedScriptIndex = -1;

  int isBuyOpen = -1;
  double totalPL = 0.0;
  bool isApiCallRunning = false;
  bool isResetCall = false;
  int totalPage = 0;
  int currentPage = 1;
  RxBool isValidQty = true.obs;
  bool isPagingApiCall = false;
  bool isAllSelected = false;
  bool isClientSelected = false;
  bool isUserSelected = false;

  FocusNode SubmitFocus = FocusNode();
  FocusNode CancelFocus = FocusNode();

  List<LtpUpdateModel> arrLtpUpdate = [];
  List<userRoleListData> arrUserTypeListPosition = [];

  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
    getColumnListFromDB(ScreenIds().netPosition, arrListTitle1);
    focusNode.requestFocus();
    arrValidaty = constantValues!.productType ?? [];
    // handleKeyEvents();
    arrOrderType = constantValues?.orderType ?? [];
    if (userData!.role == UserRollList.superAdmin) {
      arrOrderType.removeWhere((element) => element.id == "stopLoss");
    } else if (userData!.role == UserRollList.master) {
      arrOrderType.removeWhere((element) => element.id == "stopLoss");
      arrOrderType.removeWhere((element) => element.id == "limit");
    }
    arrOrderType.removeAt(0);
    selectedOrderType.value =
        arrOrderType.firstWhere((element) => element.id == "market");
    isApiCallRunning = true;
    callForRoleList();
    getPositionList("");

    update();

    lotController.addListener(() {
      // if (isQuantityUpdate == false) {
      if (!qtyFocus.hasFocus) {
        var temp = num.parse(lotController.text) *
            arrPositionScriptList[selectedScriptIndex]
                .scriptDataFromSocket
                .value
                .ls!;
        qtyController.text = temp.toString();
        // isValidQty = true.obs;
      }

      // }
    });
  }

  @override
  isAllSelectedUpdate(bool change) {
    for (var element in arrPositionScriptList) {
      element.isSelected = change;
    }
    update();
  }

  @override
  bool isHiddenTitle(String title) {
    if (userData!.role == UserRollList.user) {
      return false;
    } else {
      if (title == "") {
        if (isClientSelected && isUserSelected) {
          return false;
        } else {
          return true;
        }
      } else {
        return false;
      }
    }
  }

  callForRoleList() async {
    var response = await service.userRoleListCallForPosition();
    if (response != null) {
      if (response.statusCode == 200) {
        arrUserTypeListPosition = response.data!;
      }
    }
  }

  getMyUserList() async {
    var response = await service.getMyUserListCall(
        roleId: selectedRoll.value.roleId!, filterType: "0");
    arrUserListOnlyClient = response!.data ?? [];
    if (arrUserListOnlyClient.isNotEmpty) {
      // selectedUser.value = arrUserListOnlyClient.first;
    }
  }

  rollOverPosition(List<SymbolRequestData>? arrSymbol) async {
    List<String> arr = [];
    for (var element in arrSymbol!) {
      arr.add(element.symbolId!);
    }
    var response = await service.rollOverTradeCall(
        symbolId: arr,
        userId: userData!.role == UserRollList.user
            ? userData!.userId!
            : selectedUser.value.userId);
    if (response?.statusCode == 200) {
      showSuccessToast(response!.meta!.message ?? "");
      arrPositionScriptList.clear();
      currentPage = 1;
      getPositionList("", isFromClear: true);
      update();
    } else {
      showErrorToast(response!.message ?? "");
    }
  }

  getPositionList(String text,
      {bool isFromfilter = false, bool isFromClear = false}) async {
    if (isFromfilter) {
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
    var response = await service.positionListCall(currentPage, text,
        symbolId: selectedScriptFromFilter.value.symbolId ?? "",
        exchangeId: selectedExchange.value.exchangeId ?? "",
        userId: selectedUser.value.userId ?? "");
    arrPositionScriptList.addAll(response!.data!);
    isPagingApiCall = false;
    isResetCall = false;
    totalPage = response.meta!.totalPage!;
    if (totalPage >= currentPage) {
      currentPage = currentPage + 1;
    }
    // arrPositionScriptList.forEach((mainObj) {
    //   for (var i = 0; i < mainObj.AllPositionDataObj!.length; i++) {
    //     mainObj.AllPositionDataObj![i].profitLossValue = mainObj.AllPositionDataObj![i].totalQuantity! < 0
    //         ? (double.parse(mainObj.ask!.toStringAsFixed(2)) - mainObj.AllPositionDataObj![i].price!) * mainObj.AllPositionDataObj![i].totalQuantity!
    //         : (double.parse(mainObj.bid!.toStringAsFixed(2)) - double.parse(mainObj.AllPositionDataObj![i].price!.toStringAsFixed(2))) * mainObj.AllPositionDataObj![i].totalQuantity!;

    //     mainObj.AllPositionDataObj![i].profitLossValue = mainObj.AllPositionDataObj![i].profitLossValue! * -1;

    //     mainObj.AllPositionDataObj![i].profitLossValue = mainObj.AllPositionDataObj![i].profitLossValue! * mainObj.AllPositionDataObj![i].profitAndLossSharing! / 100;
    //     mainObj.plPerTotal = mainObj.plPerTotal + mainObj.AllPositionDataObj![i].profitLossValue!;
    //   }
    // });
    for (var indexOfScript = 0;
        indexOfScript < arrPositionScriptList.length;
        indexOfScript++) {
      arrPositionScriptList[indexOfScript].profitLossValue =
          arrPositionScriptList[indexOfScript].totalQuantity! < 0
              ? (double.parse(arrPositionScriptList[indexOfScript]
                          .ask!
                          .toStringAsFixed(2)) -
                      arrPositionScriptList[indexOfScript].price!) *
                  arrPositionScriptList[indexOfScript].totalQuantity!
              : (double.parse(arrPositionScriptList[indexOfScript]
                          .bid!
                          .toStringAsFixed(2)) -
                      double.parse(arrPositionScriptList[indexOfScript]
                          .price!
                          .toStringAsFixed(2))) *
                  arrPositionScriptList[indexOfScript].totalQuantity!;
      totalPL = 0.0;

      // if (userData!.role == UserRollList.user) {
      //   for (var element in arrPositionScriptList) {
      //     totalPL = totalPL + element.profitLossValue!;
      //   }
      // } else {
      //   for (var i = 0; i < arrPositionScriptList.length; i++) {
      //     totalPL = totalPL + arrPositionScriptList[i].plPerTotal;
      //   }
      // }
      for (var element in arrPositionScriptList) {
        totalPL = totalPL + element.profitLossValue!;
      }

      totalPosition.value = 0.0;
      for (var element in arrPositionScriptList) {
        totalPosition.value += element.profitLossValue ?? 0.0;
      }
    }
    isApiCallRunning = false;
    update();
    var arrTemp = [];
    for (var element in response.data!) {
      if (!arrSymbolNames.contains(element.symbolName)) {
        arrTemp.insert(0, element.symbolName);
        arrSymbolNames.insert(0, element.symbolName!);
      }
    }

    if (arrSymbolNames.isNotEmpty) {
      var txt = {"symbols": arrSymbolNames};
      socket.connectScript(jsonEncode(txt));
    }
  }

  squareOffPosition(List<SymbolRequestData>? arrSymbol) async {
    var response = await service.squareOffPositionCall(
        arrSymbol: arrSymbol,
        userId: userData!.role == UserRollList.user
            ? userData!.userId!
            : selectedUser.value.userId);
    if (response?.statusCode == 200) {
      showSuccessToast(response!.meta!.message ?? "");
      arrPositionScriptList.clear();
      update();
      currentPage = 1;
      isApiCallRunning = true;
      getPositionList("", isFromClear: true);
      update();
    } else {
      showErrorToast(response!.message ?? "");
    }
  }

  double getTotal(bool isBuy) {
    var total = 0.0;
    if (isBuy) {
      for (var element in arrPositionScriptList[selectedScriptIndex]
          .scriptDataFromSocket
          .value
          .depth!
          .buy!) {
        total = total + element.price!;
      }
    } else {
      for (var element in arrPositionScriptList[selectedScriptIndex]
          .scriptDataFromSocket
          .value
          .depth!
          .sell!) {
        total = total + element.price!;
      }
    }
    return total;
  }

  Color getPriceColor(double value) {
    if (value == 0.0) {
      return AppColors().fontColor;
    }
    if (value > 0.0) {
      return AppColors().greenColor;
    } else if (value < 0.0) {
      return AppColors().redColor;
    } else {
      return AppColors().fontColor;
    }
  }

  num getPlPer({num? percentage, num? pl}) {
    var temp1 = pl! * percentage!;
    var temp2 = temp1 / 100;

    return temp2;
  }

  listenPositionScriptFromSocket(GetScriptFromSocket socketData) {
    if (socketData.status == true) {
      var obj = arrPositionScriptList.firstWhereOrNull(
          (element) => socketData.data!.symbol == element.symbolName);
      var ltpObj = LtpUpdateModel(
          symbolId: "",
          ltp: socketData.data!.ltp!,
          symbolTitle: socketData.data!.symbol,
          dateTime: DateTime.now());
      var isAvailableObj = arrLtpUpdate.firstWhereOrNull(
          (element) => socketData.data!.symbol == element.symbolTitle);
      if (isAvailableObj == null) {
        arrLtpUpdate.add(ltpObj);
      } else {
        if (isAvailableObj.ltp != ltpObj.ltp) {
          var index = arrLtpUpdate.indexWhere(
              (element) => element.symbolTitle == ltpObj.symbolTitle);
          arrLtpUpdate[index] = ltpObj;
          // print(ltpObj.symbolTitle);
          // print(ltpObj.ltp);
        }
      }
      if (obj != null) {
        if (obj.symbolName == "") {}
        var indexOfScript = arrPositionScriptList.indexWhere(
            (element) => element.symbolName == socketData.data?.symbol);
        if (indexOfScript != -1) {
          arrPositionScriptList[indexOfScript].scriptDataFromSocket =
              socketData.data!.obs;
          arrPositionScriptList[indexOfScript].bid = socketData.data!.bid;
          arrPositionScriptList[indexOfScript].ask = socketData.data!.ask;
          arrPositionScriptList[indexOfScript].ltp = socketData.data!.ltp;
          if (indexOfScript == 0) {}

          arrPositionScriptList[indexOfScript].plPerTotal = 0.0;
          // for (var i = 0; i < arrPositionScriptList[indexOfScript].AllPositionDataObj!.length; i++) {
          //   arrPositionScriptList[indexOfScript].AllPositionDataObj![i].profitLossValue = arrPositionScriptList[indexOfScript].AllPositionDataObj![i].totalQuantity! < 0
          //       ? (double.parse(arrPositionScriptList[indexOfScript].ask!.toStringAsFixed(2)) - arrPositionScriptList[indexOfScript].AllPositionDataObj![i].price!) * arrPositionScriptList[indexOfScript].AllPositionDataObj![i].totalQuantity!
          //       : (double.parse(arrPositionScriptList[indexOfScript].bid!.toStringAsFixed(2)) - double.parse(arrPositionScriptList[indexOfScript].AllPositionDataObj![i].price!.toStringAsFixed(2))) * arrPositionScriptList[indexOfScript].AllPositionDataObj![i].totalQuantity!;

          //   arrPositionScriptList[indexOfScript].AllPositionDataObj![i].profitLossValue = arrPositionScriptList[indexOfScript].AllPositionDataObj![i].profitLossValue! * -1;

          //   arrPositionScriptList[indexOfScript].AllPositionDataObj![i].profitLossValue = arrPositionScriptList[indexOfScript].AllPositionDataObj![i].profitLossValue! * arrPositionScriptList[indexOfScript].AllPositionDataObj![i].profitAndLossSharing! / 100;

          //   arrPositionScriptList[indexOfScript].plPerTotal = arrPositionScriptList[indexOfScript].plPerTotal + arrPositionScriptList[indexOfScript].AllPositionDataObj![i].profitLossValue!;
          // }

          if (arrPositionScriptList[indexOfScript].currentPriceFromSocket !=
              0.0) {
            arrPositionScriptList[indexOfScript].profitLossValue =
                arrPositionScriptList[indexOfScript].totalQuantity! < 0
                    ? (double.parse(arrPositionScriptList[indexOfScript]
                                .ask!
                                .toStringAsFixed(2)) -
                            arrPositionScriptList[indexOfScript].price!) *
                        arrPositionScriptList[indexOfScript].totalQuantity!
                    : (double.parse(arrPositionScriptList[indexOfScript]
                                .bid!
                                .toStringAsFixed(2)) -
                            double.parse(arrPositionScriptList[indexOfScript]
                                .price!
                                .toStringAsFixed(2))) *
                        arrPositionScriptList[indexOfScript].totalQuantity!;
          }
        }
        totalPL = 0.0;

        // if (userData!.role == UserRollList.user) {
        //   for (var element in arrPositionScriptList) {
        //     totalPL = totalPL + element.profitLossValue!;
        //   }
        // } else {
        //   for (var i = 0; i < arrPositionScriptList.length; i++) {
        //     // var total = getPlPer(percentage: arrPositionScriptList[i].profitAndLossSharing!, pl: arrPositionScriptList[i].profitLossValue!);
        //     // total = total * -1;
        //     totalPL = totalPL + arrPositionScriptList[i].plPerTotal;
        //   }
        // }
        for (var element in arrPositionScriptList) {
          totalPL = totalPL + element.profitLossValue!;
        }
        // totalPL = totalPL + userData!.profitLoss!.toDouble();
        // var mainVc = Get.find<MainContainerController>();
        // mainVc.pl = totalPL.obs;
        // mainVc.update();
        totalPosition.value = 0.0;
        for (var element in arrPositionScriptList) {
          totalPosition.value += element.profitLossValue ?? 0.0;
        }
      }

      if (selectedScriptIndex != -1) {
        if (socketData.data?.symbol ==
            arrPositionScriptList[selectedScriptIndex].symbolName) {
          if (selectedOrderType.value.name == "Market") {
            if (arrPositionScriptList[selectedScriptIndex].tradeType == "buy") {
              priceController.text = socketData.data!.ask.toString();
            } else {
              priceController.text = socketData.data!.bid.toString();
            }
          }
        }
      }

      update();
    }
  }

  String validateForm() {
    var msg = "";
    if (selectedOrderType.value.id != "limit") {
      if (arrPositionScriptList[selectedScriptIndex].tradeSecond != 0) {
        var ltpObj = arrLtpUpdate.firstWhereOrNull((element) =>
            element.symbolTitle ==
            arrPositionScriptList[selectedScriptIndex].symbolName);
        if (ltpObj == null) {
          return "INVALID SERVER TIME";
        } else {
          var difference = DateTime.now().difference(ltpObj.dateTime!);
          var differenceInSeconds = difference.inSeconds;
          if (differenceInSeconds >=
              arrPositionScriptList[selectedScriptIndex].tradeSecond!) {
            return "INVALID SERVER TIME";
          }
        }
      }
    }

    if (userData!.role == UserRollList.user) {
      if (selectedOrderType.value.id == "market") {
        if (qtyController.text.isEmpty) {
          msg = AppString.emptyQty;
        } else if (isValidQty == false) {
          msg = AppString.inValidQty;
        } else if (priceController.text.isEmpty) {
          msg = AppString.emptyPrice;
        }
      } else {
        if (qtyController.text.isEmpty) {
          msg = AppString.emptyQty;
        } else if (isValidQty == false) {
          msg = AppString.inValidQty;
        } else if (priceController.text.isEmpty) {
          msg = AppString.emptyPrice;
        }
      }
    } else {
      if (selectedOrderType.value.id == "market") {
        if (selectedUser.value.userId == null) {
          msg = AppString.notSelectedUserName;
        }
        if (qtyController.text.isEmpty) {
          msg = AppString.emptyQty;
        } else if (isValidQty == false) {
          msg = AppString.inValidQty;
        } else if (priceController.text.isEmpty) {
          msg = AppString.emptyPrice;
        }
      } else {
        if (qtyController.text.isEmpty) {
          msg = AppString.emptyQty;
        } else if (isValidQty == false) {
          msg = AppString.inValidQty;
        } else if (priceController.text.isEmpty) {
          msg = AppString.emptyPrice;
        }
      }
    }

    return msg;
  }

  initiateTrade(bool isFromBuy) async {
    var msg = validateForm();

    isTradeCallFinished.value = true;
    if (msg.isEmpty) {
      Get.back();
      isBuyOpen = -1;
      isTradeCallFinished.value = false;

      var response = await service.tradeCall(
        symbolId: arrPositionScriptList[selectedScriptIndex].symbolId,
        quantity: double.parse(lotController.text),
        totalQuantity: double.parse(qtyController.text),
        price: double.parse(priceController.text),
        isFromStopLoss: selectedOrderType.value.id == "stopLoss",
        marketPrice: selectedOrderType.value.id == "stopLoss"
            ? arrPositionScriptList[selectedScriptIndex]
                .scriptDataFromSocket
                .value
                .ltp!
                .toDouble()
            : isFromBuy
                ? arrPositionScriptList[selectedScriptIndex]
                    .scriptDataFromSocket
                    .value
                    .ask!
                    .toDouble()
                : arrPositionScriptList[selectedScriptIndex]
                    .scriptDataFromSocket
                    .value
                    .bid!
                    .toDouble(),
        lotSize: arrPositionScriptList[selectedScriptIndex].lotSize!.toInt(),
        orderType: selectedOrderType.value.id,
        tradeType: isFromBuy ? "buy" : "sell",
        exchangeId: arrPositionScriptList[selectedScriptIndex].exchangeId,
        productType: "longTerm",
        refPrice: isFromBuy
            ? arrPositionScriptList[selectedScriptIndex]
                .scriptDataFromSocket
                .value
                .ask!
                .toDouble()
            : arrPositionScriptList[selectedScriptIndex]
                .scriptDataFromSocket
                .value
                .bid!
                .toDouble(),
      );

      //longterm
      isTradeCallFinished.value = false;
      update();
      if (response != null) {
        // Get.back();
        if (response.statusCode == 200) {
          // bool isPositionAvailable = Get.isRegistered<PositionController>();
          // bool isTradeAvailable = Get.isRegistered<TradeListController>();
          // bool isSuccessTradeAvailable = Get.isRegistered<SuccessTradeListController>();
          // if (isPositionAvailable) {
          //   var positionVC = Get.find<PositionController>();
          //   arrPositionScriptList.clear();
          //   currentPage = 1;
          //   positionVC.getPositionList("", isFromClear: true, isFromfilter: true);
          // }
          // if (isTradeAvailable) {
          //   var tradeVC = Get.find<TradeListController>();
          //   tradeVC.getTradeList();
          // }
          // if (isSuccessTradeAvailable) {
          //   var tradeVC = Get.find<SuccessTradeListController>();
          //   tradeVC.getTradeList();
          // }

          showSuccessToast(response.meta!.message!);
          isTradeCallFinished.value = true;
          update();
        } else {
          isTradeCallFinished.value = true;
          showErrorToast(response.message!);
          update();
        }

        qtyController.text = "";
        priceController.text = "";
      }
    } else {
      // stateSetter(() {});
      showWarningToast(msg);
      Future.delayed(const Duration(milliseconds: 100), () {
        isTradeCallFinished.value = true;
      });
    }
  }

  initiateManualTrade(bool isFromBuy) async {
    var msg = validateForm();
    isBuyOpen = -1;
    isTradeCallFinished.value = true;
    if (msg.isEmpty) {
      Get.back();
      isTradeCallFinished.value = false;

      var response = await service.manualTradeCall(
        symbolId: arrPositionScriptList[selectedScriptIndex].symbolId,
        quantity: double.parse(lotController.text),
        totalQuantity: double.parse(qtyController.text),
        price: double.parse(priceController.text),
        lotSize: arrPositionScriptList[selectedScriptIndex]
            .scriptDataFromSocket
            .value
            .ls!
            .toInt(),
        orderType: selectedOrderType.value.id,
        tradeType: isFromBuy ? "buy" : "sell",
        exchangeId: arrPositionScriptList[selectedScriptIndex].exchangeId,
        userId: selectedUser.value.userId!,
        refPrice: isFromBuy
            ? arrPositionScriptList[selectedScriptIndex]
                .scriptDataFromSocket
                .value
                .ask!
                .toDouble()
            : arrPositionScriptList[selectedScriptIndex]
                .scriptDataFromSocket
                .value
                .bid!
                .toDouble(),
      );

      //longterm
      isTradeCallFinished.value = false;
      update();
      if (response != null) {
        // Get.back();
        selectedOrderType.value =
            arrOrderType.firstWhere((element) => element.id == "market");
        if (response.statusCode == 200) {
          // bool isTradeAvailable = Get.isRegistered<TradeListController>();
          // bool isSuccessTradeAvailable = Get.isRegistered<SuccessTradeListController>();
          // if (isSuccessTradeAvailable) {
          //   Get.find<SuccessTradeListController>().getTradeList();
          // }
          // if (isTradeAvailable) {
          //   Get.find<TradeListController>().getTradeList();
          // }

          // arrPositionScriptList.clear();
          // currentPage = 1;
          // getPositionList("", isFromClear: true, isFromfilter: true);

          showSuccessToast(response.meta!.message!);
          isTradeCallFinished.value = true;
          update();
        } else {
          isTradeCallFinished.value = true;
          showErrorToast(response.message!);
          update();
        }

        qtyController.text = "";
        priceController.text = "";
      }
    } else {
      // stateSetter(() {});
      showWarningToast(msg);
      Future.delayed(const Duration(milliseconds: 100), () {
        isTradeCallFinished.value = true;
      });
    }
  }

  buySellPopupDialog(
      {bool isFromBuy = true, Function? CancelClick, Function? DeleteClick}) {
    showDialog<String>(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) => FloatingDialog(
              // titlePadding: EdgeInsets.zero,
              // backgroundColor: AppColors().bgColor,
              // surfaceTintColor: AppColors().bgColor,
              // insetPadding: EdgeInsets.symmetric(
              //   horizontal: 20.w,
              //   vertical: 32.h,
              // ),
              enableDragAnimation: false,
              child: StatefulBuilder(builder: (context, setState) {
                return Container(
                  width: 890,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  clipBehavior: Clip.hardEdge,
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // width: 55.w,
                          color: AppColors().bgColor,
                          height: 41,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                AppImages.appLogo,
                                width: 22,
                                height: 22,
                                color: isFromBuy
                                    ? AppColors().blueColor
                                    : AppColors().redColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                isFromBuy ? "Buy Order" : "Sell Order",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isFromBuy
                                      ? AppColors().blueColor
                                      : AppColors().redColor,
                                  fontFamily: CustomFonts.family1Medium,
                                ),
                              ),

                              Spacer(),
                              // SizedBox(
                              //   width: 4.3.w,
                              // ),
                              GestureDetector(
                                onTap: () {
                                  isBuyOpen = -1;
                                  //  focusNode.requestFocus();
                                  update();
                                  Get.back();
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  padding: EdgeInsets.all(10),
                                  child: Image.asset(
                                    AppImages.closeIcon,
                                    color: AppColors().redColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: isFromBuy
                                ? AppColors().blueColor
                                : AppColors().redColor,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Exchange",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors().whiteColor,
                                            fontFamily:
                                                CustomFonts.family1Regular,
                                          ),
                                        ),
                                        Container(
                                          width: 210,
                                          height: 40,
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: CustomTextField(
                                            type: 'Exchange',
                                            // regex: '[0-9]',
                                            roundCorner: 0,
                                            borderColor: Colors.transparent,
                                            // fillColor: AppColors().headerBgColor,

                                            keyBoardType: const TextInputType
                                                .numberWithOptions(
                                                signed: true, decimal: false),

                                            isShowPrefix: false,
                                            isShowSufix: false,
                                            isEnabled: false,
                                            isOptional: false,
                                            inValidMsg: AppString.emptyPassword,
                                            placeHolderMsg: "Exchange",

                                            emptyFieldMsg:
                                                AppString.emptyPassword,
                                            controller: exchangeController,
                                            focus: exchangeFocus,
                                            isSecure: false,
                                            maxLength: 50,
                                            keyboardButtonType:
                                                TextInputAction.done,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            "Order Type",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors().whiteColor,
                                              fontFamily:
                                                  CustomFonts.family1Regular,
                                            ),
                                          ),
                                        ),
                                        orderTypeListDropDown()
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Obx(() {
                                          print(isValidQty.value);
                                          return Text(
                                            isValidQty.value
                                                ? "Quantity"
                                                : "Invalid Quantity",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isValidQty.value
                                                  ? AppColors().whiteColor
                                                  : isFromBuy
                                                      ? AppColors().redColor
                                                      : AppColors().blueColor,
                                              fontFamily:
                                                  CustomFonts.family1Regular,
                                            ),
                                          );
                                        }),
                                        Container(
                                          width: 100,
                                          height: 40,
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: CustomTextField(
                                            regex: "[0-9]",
                                            type: '',
                                            focusBorderColor:
                                                AppColors().redColor,
                                            keyBoardType: TextInputType.none,
                                            isEnabled: true,
                                            isOptional: false,
                                            isNoNeededCapital: true,
                                            inValidMsg:
                                                AppString.emptyMobileNumber,
                                            placeHolderMsg: "",
                                            labelMsg: "",
                                            emptyFieldMsg:
                                                AppString.emptyMobileNumber,
                                            controller: qtyController,
                                            focus: qtyFocus,
                                            isSecure: false,
                                            keyboardButtonType:
                                                TextInputAction.next,
                                            onChange: () {
                                              if (qtyController
                                                  .text.isNotEmpty) {
                                                print(arrPositionScriptList[
                                                        selectedScriptIndex]
                                                    .oddLotTrade);
                                                print(arrPositionScriptList[
                                                        selectedScriptIndex]
                                                    .lotSize);
                                                if (arrPositionScriptList[
                                                            selectedScriptIndex]
                                                        .oddLotTrade ==
                                                    1) {
                                                  var temp = (num.parse(
                                                          qtyController.text) /
                                                      arrPositionScriptList[
                                                              selectedScriptIndex]
                                                          .lotSize!);
                                                  lotController.text =
                                                      temp.toStringAsFixed(2);
                                                  print(temp);
                                                  isValidQty.value = true;
                                                } else {
                                                  var temp = (num.parse(
                                                          qtyController.text) /
                                                      arrPositionScriptList[
                                                              selectedScriptIndex]
                                                          .lotSize!);

                                                  print(temp);
                                                  if ((num.parse(qtyController
                                                              .text) %
                                                          arrPositionScriptList[
                                                                  selectedScriptIndex]
                                                              .lotSize!) ==
                                                      0) {
                                                    lotController.text =
                                                        temp.toStringAsFixed(0);
                                                    isValidQty.value = true;
                                                  } else {
                                                    isValidQty.value = false;
                                                  }
                                                }

                                                setState(() {});
                                              }
                                            },
                                            maxLength: 10,
                                            isShowPrefix: false,
                                            isShowSufix: false,
                                            suffixIcon: null,
                                            prefixIcon: null,
                                            borderColor: AppColors().lightText,
                                            roundCorner: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            "Lot",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors().whiteColor,
                                              fontFamily:
                                                  CustomFonts.family1Regular,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          height: 40,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 10),
                                          child:
                                              NumberInputWithIncrementDecrementOwn(
                                            incIconSize: 18,
                                            decIconSize: 18,
                                            validator: (value) {
                                              return null;
                                            },
                                            onIncrement: (newValue) {
                                              isValidQty = true.obs;
                                              setState(() {});
                                            },
                                            onDecrement: (newValue) {
                                              isValidQty = true.obs;
                                              setState(() {});
                                            },
                                            onChanged: (newValue) {},
                                            autovalidateMode:
                                                AutovalidateMode.disabled,
                                            fractionDigits: 2,
                                            textAlign: TextAlign.left,

                                            initialValue: 1,
                                            incDecFactor: 1,
                                            isInt: true,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily:
                                                  CustomFonts.family1Regular,
                                              color: AppColors().darkText,
                                            ),
                                            numberFieldDecoration:
                                                InputDecoration(
                                                    border: InputBorder.none,
                                                    fillColor:
                                                        AppColors().whiteColor,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            bottom: 8,
                                                            left: 20)),

                                            widgetContainerDecoration:
                                                BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                              color: AppColors().whiteColor,
                                            ),
                                            controller: lotController,
                                            min: 1,
                                            // max: 1000000000000,
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 0,
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Price",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors().whiteColor,
                                                fontFamily:
                                                    CustomFonts.family1Regular,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Obx(() {
                                          return Container(
                                            width: 210,
                                            height: 40,
                                            margin: EdgeInsets.symmetric(
                                              vertical: 5,
                                            ),
                                            child:
                                                NumberInputWithIncrementDecrementOwn(
                                              incIconSize: 18,
                                              decIconSize: 18,
                                              validator: (value) {
                                                return null;
                                              },
                                              fractionDigits: 2,
                                              textAlign: TextAlign.left,
                                              enabled: selectedOrderType
                                                      .value.name !=
                                                  "Market",
                                              initialValue: double.tryParse(
                                                      priceController.text) ??
                                                  0.0,
                                              incDecFactor: 0.05,
                                              isInt: false,

                                              numberFieldDecoration:
                                                  InputDecoration(
                                                      border: InputBorder.none,
                                                      fillColor: AppColors()
                                                          .whiteColor,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              bottom: 8,
                                                              left: 20)),

                                              widgetContainerDecoration:
                                                  BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(0),
                                                color: AppColors().whiteColor,
                                              ),
                                              controller: priceController,
                                              // min: 1,
                                              // max: 1000000000000,
                                            ),
                                          );
                                        }),
                                      ],
                                    )
                                  ],
                                ),
                                Obx(() {
                                  return Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Symbol",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors().whiteColor,
                                              fontFamily:
                                                  CustomFonts.family1Regular,
                                            ),
                                          ),
                                          Container(
                                            width: 210,
                                            height: 40,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: CustomTextField(
                                              type: 'Symbol',
                                              // regex: '[0-9]',
                                              roundCorner: 0,
                                              borderColor: Colors.transparent,
                                              // fillColor: AppColors().headerBgColor,
                                              keyBoardType: const TextInputType
                                                  .numberWithOptions(
                                                  signed: true, decimal: false),
                                              prefixIcon: SizedBox(),
                                              suffixIcon: SizedBox(),

                                              isEnabled: false,
                                              isOptional: false,
                                              inValidMsg:
                                                  AppString.emptyPassword,
                                              placeHolderMsg: "Symbol",

                                              emptyFieldMsg:
                                                  AppString.emptyPassword,
                                              controller: symbolController,
                                              focus: symbolFocus,
                                              isSecure: false,
                                              maxLength: 50,
                                              keyboardButtonType:
                                                  TextInputAction.done,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (selectedOrderType.value.name ==
                                          "Market")
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [validityListDropDown()],
                                        ),
                                      // Column(
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   children: [
                                      //     Padding(
                                      //       padding: const EdgeInsets.only(
                                      //         left: 0,
                                      //       ),
                                      //       child: Padding(
                                      //         padding: const EdgeInsets.only(left: 10),
                                      //         child: Text(
                                      //           "Lot Size",
                                      //           textAlign: TextAlign.center,
                                      //           style: TextStyle(
                                      //             fontSize: 12,
                                      //             color: AppColors().whiteColor,
                                      //             fontFamily: CustomFonts.family1Regular,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     Container(
                                      //       width: 210,
                                      //       height: 40,
                                      //       color: AppColors().whiteColor,
                                      //       margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      //       child: NumberInputWithIncrementDecrementOwn(
                                      //         enabled: false,
                                      //         incIconSize: 0,
                                      //         decIconSize: 0,
                                      //         // onIncrement: (newValue) {
                                      //         //   var finalNew = newValue + 1;
                                      //         //   var change =  finalNew - selectedScript.value!.ls!;
                                      //         //   qtyController.text = (change * selectedScript.value!.ls!).toString();
                                      //         //   update();
                                      //         // },
                                      //         // onDecrement: (newValue) {
                                      //         //   var finalNew = newValue + 1;
                                      //         //   var change =  finalNew - selectedScript.value!.ls!;
                                      //         //   qtyController.text = (change * selectedScript.value!.ls!).toString();
                                      //         //   update();
                                      //         // },
                                      //         initialValue:
                                      //             arrPositionScriptList[selectedScriptIndex].scriptDataFromSocket.value.ls!,
                                      //         textAlign: TextAlign.start,
                                      //         style: TextStyle(
                                      //           fontSize: 14,
                                      //           fontFamily: CustomFonts.family1Regular,
                                      //           color: AppColors().darkText,
                                      //         ),
                                      //         numberFieldDecoration: InputDecoration(
                                      //             contentPadding: EdgeInsets.only(bottom: 5, left: 20),
                                      //             border: InputBorder.none,
                                      //             fillColor: AppColors().whiteColor),
                                      //         widgetContainerDecoration: BoxDecoration(
                                      //           borderRadius: BorderRadius.circular(0),
                                      //           color: AppColors().whiteColor,
                                      //         ),
                                      //         controller: TextEditingController(),
                                      //         min: arrPositionScriptList[selectedScriptIndex].lotSize!,
                                      //         max: 1000000,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      // Column(
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   children: [
                                      //     Padding(
                                      //       padding: const EdgeInsets.only(
                                      //         left: 0,
                                      //       ),
                                      //       child: Padding(
                                      //         padding: const EdgeInsets.only(left: 10),
                                      //         child: Text(
                                      //           "User Remarks",
                                      //           textAlign: TextAlign.center,
                                      //           style: TextStyle(
                                      //             fontSize: 12,
                                      //             color: AppColors().whiteColor,
                                      //             fontFamily: CustomFonts.family1Regular,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     Container(
                                      //       width: 210,
                                      //       height: 40,
                                      //       margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                      //       child: CustomTextField(
                                      //         type: 'Remark',
                                      //         // regex: '[0-9]',
                                      //         roundCorner: 0,
                                      //         borderColor: Colors.transparent,
                                      //         // fillColor: AppColors().headerBgColor,
                                      //         keyBoardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
                                      //         prefixIcon: null,
                                      //         suffixIcon: SizedBox(),
                                      //         isShowSufix: false,
                                      //         isShowPrefix: false,

                                      //         isEnabled: true,
                                      //         isOptional: false,
                                      //         inValidMsg: AppString.emptyPassword,
                                      //         placeHolderMsg: "Remark",

                                      //         emptyFieldMsg: AppString.emptyPassword,
                                      //         controller: remarkController,
                                      //         focus: remarkFocus,
                                      //         isSecure: false,
                                      //         maxLength: 50,
                                      //         keyboardButtonType: TextInputAction.done,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // )
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: selectedOrderType
                                                            .value.name! ==
                                                        "Market"
                                                    ? 0
                                                    : 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 210,
                                                  height: 42,
                                                  child: CustomButton(
                                                    isEnabled: true,
                                                    shimmerColor:
                                                        AppColors().whiteColor,
                                                    title: "Submit",
                                                    textSize: 16,
                                                    focusKey: SubmitFocus,
                                                    onPress: () {
                                                      initiateTrade(isFromBuy);
                                                    },
                                                    bgColor: AppColors()
                                                        .grayLightLine,
                                                    focusShadowColor:
                                                        AppColors().whiteColor,
                                                    borderColor: isFromBuy
                                                        ? AppColors().redColor
                                                        : AppColors().blueColor,
                                                    isFilled: true,
                                                    textColor:
                                                        AppColors().darkText,
                                                    isTextCenter: true,
                                                    isLoading: false,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                  width: 210,
                                                  height: 42,
                                                  child: CustomButton(
                                                    isEnabled: true,
                                                    shimmerColor:
                                                        AppColors().whiteColor,
                                                    title: "Cancel",
                                                    textSize: 16,
                                                    focusShadowColor:
                                                        AppColors().whiteColor,
                                                    borderColor: isFromBuy
                                                        ? AppColors().redColor
                                                        : AppColors().blueColor,
                                                    focusKey: CancelFocus,
                                                    onPress: () {
                                                      selectedExchangeFromPopup
                                                              .value =
                                                          ExchangeData();

                                                      selectedScriptFromPopup
                                                          .value = ScriptData();
                                                      qtyController.text = "";
                                                      priceController.text = "";

                                                      remarkController.text =
                                                          "";
                                                      isBuyOpen = -1;
                                                      Get.back();
                                                    },
                                                    bgColor:
                                                        AppColors().whiteColor,
                                                    isFilled: true,
                                                    textColor:
                                                        AppColors().darkText,
                                                    isTextCenter: true,
                                                    isLoading: false,
                                                  ),
                                                ),
                                                // SizedBox(width: 5.w,),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
            ));
  }

  Widget orderTypeListDropDown({bool isFromAdmin = false}) {
    return Obx(() {
      return IgnorePointer(
        ignoring: isFromAdmin,
        child: Container(
            width: 210,
            height: 40,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                border: Border.all(color: AppColors().lightOnlyText, width: 1),
                color: AppColors().whiteColor),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<Type>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isBuyOpen == 1
                                  ? AppColors().redColor
                                  : AppColors().blueColor,
                              width: 2)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.transparent, width: 0)),
                    ),
                    hint: Text(
                      isFromAdmin ? "Market" : 'Order Type',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: CustomFonts.family1Medium,
                        color: AppColors().darkText,
                      ),
                    ),

                    items: arrOrderType
                        .map((Type item) => DropdownMenuItem<Type>(
                              value: item,
                              child: Text(item.name ?? "",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: CustomFonts.family1Medium,
                                      color: AppColors().grayColor)),
                            ))
                        .toList(),
                    selectedItemBuilder: (context) {
                      return arrOrderType
                          .map((Type item) => DropdownMenuItem<Type>(
                                value: item,
                                child: Text(
                                  item.name ?? "",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: CustomFonts.family1Medium,
                                    color: AppColors().darkText,
                                  ),
                                ),
                              ))
                          .toList();
                    },
                    value: selectedOrderType.value.id == null
                        ? null
                        : selectedOrderType.value,
                    onChanged: (Type? value) {
                      selectedOrderType.value = value!;

                      // focusNode.requestFocus();
                    },
                    // buttonStyleData: const ButtonStyleData(
                    //   padding: EdgeInsets.symmetric(horizontal: 0),
                    //   height: 40,
                    //   // width: 140,
                    // ),
                    // menuItemStyleData: const MenuItemStyleData(
                    //   height: 40,
                    // ),
                  ),
                ),
              ),
            )),
      );
    });
  }

  Widget validityListDropDown() {
    return Obx(() {
      return selectedOrderType.value.name != "Market"
          ? SizedBox()
          : Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Validity",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors().whiteColor,
                      fontFamily: CustomFonts.family1Regular,
                    ),
                  ),
                  Container(
                      width: 210,
                      height: 40,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors().lightOnlyText, width: 1),
                          color: AppColors().whiteColor),
                      child: Center(
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButtonFormField<Type>(
                              isExpanded: true,
                              hint: Text(
                                'Validity',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: CustomFonts.family1Medium,
                                  color: AppColors().darkText,
                                ),
                              ),
                              items: arrValidaty
                                  .map((Type item) => DropdownMenuItem<Type>(
                                        value: item,
                                        child: Text(item.name ?? "",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily:
                                                    CustomFonts.family1Medium,
                                                color: AppColors().grayColor)),
                                      ))
                                  .toList(),
                              selectedItemBuilder: (context) {
                                return arrValidaty
                                    .map((Type item) => DropdownMenuItem<Type>(
                                          value: item,
                                          child: Text(
                                            item.name ?? "",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily:
                                                  CustomFonts.family1Medium,
                                              color: AppColors().darkText,
                                            ),
                                          ),
                                        ))
                                    .toList();
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 15),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: isBuyOpen == 1
                                            ? AppColors().redColor
                                            : AppColors().blueColor,
                                        width: 2)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 0)),
                              ),
                              value: selectedValidity.value.id == null
                                  ? null
                                  : selectedValidity.value,
                              onChanged: (Type? value) {
                                selectedValidity.value = value!;

                                // focusNode.requestFocus();
                              },
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            );
    });
  }

  Widget userListDropDown(Rx<UserData> selectedUser, {double? width}) {
    return Obx(() {
      return SizedBox(
          width: width ?? 250,
          // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          height: 30,
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField2<UserData>(
                isExpanded: true,
                decoration: commonFocusBorder,
                iconStyleData: IconStyleData(
                  icon: Image.asset(
                    AppImages.arrowDown,
                    height: 20,
                    width: 20,
                    color: AppColors().fontColor,
                  ),
                ),
                dropdownSearchData: DropdownSearchData(
                  searchController: userEditingController,
                  searchBarWidgetHeight: 50,
                  searchBarWidget: SizedBox(
                    height: 30,
                    // padding: EdgeInsets.only(top: 2.w, right: 2.w, left: 2.w),
                    child: CustomTextField(
                      type: '',
                      keyBoardType: TextInputType.text,
                      isEnabled: true,
                      isOptional: false,
                      inValidMsg: "",
                      placeHolderMsg: "Search",
                      emptyFieldMsg: "",
                      controller: userEditingController,
                      focus: userEditingFocus,
                      isSecure: false,
                      borderColor: AppColors().grayLightLine,
                      keyboardButtonType: TextInputAction.done,
                      maxLength: 64,
                      isShowPrefix: false,
                      fontStyle: TextStyle(
                          fontSize: 10,
                          fontFamily: CustomFonts.family1Medium,
                          color: AppColors().fontColor),
                      suffixIcon: Container(
                        child: GestureDetector(
                          onTap: () {
                            userEditingController.clear();
                          },
                          child: Image.asset(
                            AppImages.crossIcon,
                            height: 20,
                            width: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  searchMatchFn: (item, searchValue) {
                    return item.value!.userName
                        .toString()
                        .toLowerCase()
                        .startsWith(searchValue.toLowerCase());
                  },
                ),
                hint: Text(
                  'Select User',
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: CustomFonts.family2Regular,
                    color: AppColors().darkText,
                  ),
                ),
                items: arrUserListOnlyClient
                    .map((UserData item) => DropdownItem<UserData>(
                          value: item,
                          height: 30,
                          child: Text(item.userName ?? "",
                              style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: CustomFonts.family2Regular,
                                  color: AppColors().grayColor)),
                        ))
                    .toList(),
                selectedItemBuilder: (context) {
                  return arrUserListOnlyClient
                      .map((UserData item) => DropdownMenuItem<UserData>(
                            value: item,
                            child: Text(
                              item.userName ?? "",
                              style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: CustomFonts.family2Regular,
                                  color: AppColors().darkText,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ))
                      .toList();
                },
                value: selectedUser.value.userId == null
                    ? null
                    : selectedUser.value,
                onChanged: (UserData? value) {
                  selectedUser.value = value!;
                },
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  height: 30,
                ),
                dropdownStyleData: const DropdownStyleData(maxHeight: 250),
              ),
            ),
          ));
    });
  }

  Widget userTypeDropDown(Rx<userRoleListData> selectUserdropdownValue,
      {double? width, double? height, Function? onChange, FocusNode? focus}) {
    dropdownUserTypeKey = GlobalKey();

    return Obx(() {
      return Container(
          width: width ?? 250,
          height: height ?? 30,
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField2<userRoleListData>(
                isExpanded: true,
                decoration: commonFocusBorder,
                iconStyleData: IconStyleData(
                  icon: Image.asset(
                    AppImages.arrowDown,
                    height: 20,
                    width: 20,
                    color: AppColors().fontColor,
                  ),
                ),
                dropdownStyleData: const DropdownStyleData(maxHeight: 150),
                hint: Text(
                  '',
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: CustomFonts.family1Medium,
                    color: AppColors().darkText,
                  ),
                ),
                items: arrUserTypeListPosition
                    .map((userRoleListData item) =>
                        DropdownItem<userRoleListData>(
                          value: item,
                          height: 30,
                          child: Text(item.name ?? "",
                              style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: CustomFonts.family1Regular,
                                  color: AppColors().darkText)),
                        ))
                    .toList(),
                selectedItemBuilder: (context) {
                  return arrUserTypeListPosition
                      .map((userRoleListData item) =>
                          DropdownMenuItem<userRoleListData>(
                            value: item,
                            child: Text(
                              item.name ?? "",
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: CustomFonts.family1Regular,
                                color: AppColors().darkText,
                              ),
                            ),
                          ))
                      .toList();
                },
                value: selectUserdropdownValue.value.roleId != null
                    ? selectUserdropdownValue.value
                    : null,
                onChanged: (userRoleListData? value) {
                  selectUserdropdownValue.value = value!;
                  if (onChange != null) {
                    onChange();
                  }
                },
                buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 0), height: 40),
              ),
            ),
          ));
    });
  }

  onClickExcel({bool isFromPDF = false}) {
    List<excelLib.TextCellValue?> titleList = [];
    arrListTitle1.forEach((element) {
      titleList.add(excelLib.TextCellValue(element.title!));
    });
    List<List<excelLib.TextCellValue?>> dataList = [];
    arrPositionScriptList.forEach((element) {
      List<excelLib.TextCellValue?> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case NetPositionColumns.checkBox:
            {
              list.add(excelLib.TextCellValue(""));
            }
          case NetPositionColumns.view:
            {
              list.add(excelLib.TextCellValue(""));
            }
          case NetPositionColumns.parentUser:
            {
              list.add(excelLib.TextCellValue(element.parentUserName!));
            }
          case NetPositionColumns.exchange:
            {
              list.add(excelLib.TextCellValue(element.exchangeName!));
            }
          case NetPositionColumns.symbolName:
            {
              list.add(excelLib.TextCellValue(element.symbolTitle!));
            }
          case NetPositionColumns.totalBuyAQty:
            {
              list.add(
                  excelLib.TextCellValue(element.buyTotalQuantity!.toString()));
            }
          case NetPositionColumns.totalBuyAPrice:
            {
              list.add(
                  excelLib.TextCellValue(element.buyPrice!.toStringAsFixed(2)));
            }
          case NetPositionColumns.totalSellQty:
            {
              list.add(excelLib.TextCellValue(
                  element.sellTotalQuantity!.toString()));
            }
          case NetPositionColumns.sellAPrice:
            {
              list.add(excelLib.TextCellValue(
                  element.sellPrice!.toStringAsFixed(2)));
            }
          case NetPositionColumns.netQty:
            {
              list.add(excelLib.TextCellValue(
                  element.totalQuantity!.toStringAsFixed(2)));
            }
          case NetPositionColumns.netLot:
            {
              list.add(excelLib.TextCellValue(element.quantity!.toString()));
            }
          case NetPositionColumns.netAPrice:
            {
              list.add(
                  excelLib.TextCellValue(element.price!.toStringAsFixed(2)));
            }
          case NetPositionColumns.cmp:
            {
              list.add(excelLib.TextCellValue(element.totalQuantity! < 0
                  ? element.ask!.toStringAsFixed(2).toString()
                  : element.bid!.toStringAsFixed(2).toString()));
            }
          case NetPositionColumns.pl:
            {
              list.add(excelLib.TextCellValue(
                  element.profitLossValue!.toStringAsFixed(2)));
            }
          case NetPositionColumns.plPerWise:
            {
              list.add(excelLib.TextCellValue((getPlPer(
                          percentage: element.profitAndLossSharing!,
                          pl: element.profitLossValue!) *
                      -1)
                  .toStringAsFixed(3)));
            }
          default:
            {
              list.add(excelLib.TextCellValue(""));
            }
        }
      });
      dataList.add(list);
    });

    exportExcelFile("Position.xlsx", titleList, dataList);
  }

  onClickPDF() async {
    List<String> headers = [];

    arrListTitle1.forEach((element) {
      headers.add(element.title!);
    });
    List<List<dynamic>> dataList = [];
    arrPositionScriptList.forEach((element) {
      List<String> list = [];
      arrListTitle1.forEach((titleObj) {
        switch (titleObj.title) {
          case NetPositionColumns.checkBox:
            {
              list.add((""));
            }
          case NetPositionColumns.view:
            {
              list.add((""));
            }
          case NetPositionColumns.parentUser:
            {
              list.add((element.parentUserName!));
            }
          case NetPositionColumns.exchange:
            {
              list.add((element.exchangeName!));
            }
          case NetPositionColumns.symbolName:
            {
              list.add((element.symbolTitle!));
            }
          case NetPositionColumns.totalBuyAQty:
            {
              list.add((element.buyTotalQuantity!.toString()));
            }
          case NetPositionColumns.totalBuyAPrice:
            {
              list.add((element.buyPrice!.toStringAsFixed(2)));
            }
          case NetPositionColumns.totalSellQty:
            {
              list.add((element.sellTotalQuantity!.toString()));
            }
          case NetPositionColumns.sellAPrice:
            {
              list.add((element.sellPrice!.toStringAsFixed(2)));
            }
          case NetPositionColumns.netQty:
            {
              list.add((element.totalQuantity!.toStringAsFixed(2)));
            }
          case NetPositionColumns.netLot:
            {
              list.add((element.quantity!.toString()));
            }
          case NetPositionColumns.netAPrice:
            {
              list.add((element.price!.toStringAsFixed(2)));
            }
          case NetPositionColumns.cmp:
            {
              list.add((element.totalQuantity! < 0
                  ? element.ask!.toStringAsFixed(2).toString()
                  : element.bid!.toStringAsFixed(2).toString()));
            }
          case NetPositionColumns.pl:
            {
              list.add((element.profitLossValue!.toStringAsFixed(2)));
            }
          case NetPositionColumns.plPerWise:
            {
              list.add(((getPlPer(
                          percentage: element.profitAndLossSharing!,
                          pl: element.profitLossValue!) *
                      -1)
                  .toStringAsFixed(3)));
            }
          default:
            {
              list.add((""));
            }
        }
      });
      dataList.add(list);
    });
    exportPDFFile(
        fileName: "NetPositionList",
        title: "Net Position",
        width: globalMaxWidth,
        titleList: headers,
        dataList: dataList);
  }
}
