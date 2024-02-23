import 'dart:convert';
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
import '../MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';

class PositionController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  Rx<UserData> selectedUser = UserData().obs;
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

  FocusNode SubmitFocus = FocusNode();
  FocusNode CancelFocus = FocusNode();

  List<LtpUpdateModel> arrLtpUpdate = [];

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
    selectedOrderType.value = arrOrderType.firstWhere((element) => element.id == "market");
    isApiCallRunning = true;

    getPositionList("");
    getUserList();
    update();

    lotController.addListener(() {
      // if (isQuantityUpdate == false) {
      if (!qtyFocus.hasFocus) {
        var temp = num.parse(lotController.text) * arrPositionScriptList[selectedScriptIndex].scriptDataFromSocket.value.ls!;
        qtyController.text = temp.toString();
        // isValidQty = true.obs;
      }

      // }
    });
  }

  getUserList() async {
    var response = await service.getMyUserListCall(roleId: UserRollList.user);
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
    var response = await service.rollOverTradeCall(symbolId: arr, userId: userData!.userId!);
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

  getPositionList(String text, {bool isFromfilter = false, bool isFromClear = false}) async {
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
    var response = await service.positionListCall(currentPage, text, symbolId: selectedScriptFromFilter.value.symbolId ?? "", exchangeId: selectedExchange.value.exchangeId ?? "", userId: selectedUser.value.userId ?? "");
    arrPositionScriptList.addAll(response!.data!);
    isPagingApiCall = false;
    isResetCall = false;
    totalPage = response.meta!.totalPage!;
    if (totalPage >= currentPage) {
      currentPage = currentPage + 1;
    }
    for (var indexOfScript = 0; indexOfScript < arrPositionScriptList.length; indexOfScript++) {
      arrPositionScriptList[indexOfScript].profitLossValue = arrPositionScriptList[indexOfScript].totalQuantity! < 0
          ? (double.parse(arrPositionScriptList[indexOfScript].ask!.toStringAsFixed(2)) - arrPositionScriptList[indexOfScript].price!) * arrPositionScriptList[indexOfScript].totalQuantity!
          : (double.parse(arrPositionScriptList[indexOfScript].bid!.toStringAsFixed(2)) - double.parse(arrPositionScriptList[indexOfScript].price!.toStringAsFixed(2))) * arrPositionScriptList[indexOfScript].totalQuantity!;
      totalPL = 0.0;

      if (userData!.role == UserRollList.user) {
        for (var element in arrPositionScriptList) {
          totalPL = totalPL + element.profitLossValue!;
        }
      } else {
        for (var i = 0; i < arrPositionScriptList.length; i++) {
          var total = getPlPer(percentage: arrPositionScriptList[i].profitAndLossSharing!, pl: arrPositionScriptList[i].profitLossValue!);
          total = total * -1;
          totalPL = totalPL + total;
        }
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

    if (arrTemp.isNotEmpty) {
      var txt = {"symbols": arrTemp};
      socket.connectScript(jsonEncode(txt));
    }
  }

  squareOffPosition(List<SymbolRequestData>? arrSymbol) async {
    var response = await service.squareOffPositionCall(arrSymbol: arrSymbol);
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
      for (var element in arrPositionScriptList[selectedScriptIndex].scriptDataFromSocket.value.depth!.buy!) {
        total = total + element.price!;
      }
    } else {
      for (var element in arrPositionScriptList[selectedScriptIndex].scriptDataFromSocket.value.depth!.sell!) {
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
      var obj = arrPositionScriptList.firstWhereOrNull((element) => socketData.data!.symbol == element.symbolName);
      var ltpObj = LtpUpdateModel(symbolId: "", ltp: socketData.data!.ltp!, symbolTitle: socketData.data!.symbol, dateTime: DateTime.now());
      var isAvailableObj = arrLtpUpdate.firstWhereOrNull((element) => socketData.data!.symbol == element.symbolTitle);
      if (isAvailableObj == null) {
        arrLtpUpdate.add(ltpObj);
      } else {
        if (isAvailableObj.ltp != ltpObj.ltp) {
          var index = arrLtpUpdate.indexWhere((element) => element.symbolTitle == ltpObj.symbolTitle);
          arrLtpUpdate[index] = ltpObj;
          // print(ltpObj.symbolTitle);
          // print(ltpObj.ltp);
        }
      }
      if (obj != null) {
        var indexOfScript = arrPositionScriptList.indexWhere((element) => element.symbolName == socketData.data?.symbol);
        if (indexOfScript != -1) {
          arrPositionScriptList[indexOfScript].scriptDataFromSocket = socketData.data!.obs;
          arrPositionScriptList[indexOfScript].bid = socketData.data!.bid;
          arrPositionScriptList[indexOfScript].ask = socketData.data!.ask;
          arrPositionScriptList[indexOfScript].ltp = socketData.data!.ltp;
          if (indexOfScript == 0) {}

          if (arrPositionScriptList[indexOfScript].currentPriceFromSocket != 0.0) {
            arrPositionScriptList[indexOfScript].profitLossValue = arrPositionScriptList[indexOfScript].totalQuantity! < 0
                ? (double.parse(arrPositionScriptList[indexOfScript].ask!.toStringAsFixed(2)) - arrPositionScriptList[indexOfScript].price!) * arrPositionScriptList[indexOfScript].totalQuantity!
                : (double.parse(arrPositionScriptList[indexOfScript].bid!.toStringAsFixed(2)) - double.parse(arrPositionScriptList[indexOfScript].price!.toStringAsFixed(2))) * arrPositionScriptList[indexOfScript].totalQuantity!;
          }
        }
        totalPL = 0.0;

        if (userData!.role == UserRollList.user) {
          for (var element in arrPositionScriptList) {
            totalPL = totalPL + element.profitLossValue!;
          }
        } else {
          for (var i = 0; i < arrPositionScriptList.length; i++) {
            var total = getPlPer(percentage: arrPositionScriptList[i].profitAndLossSharing!, pl: arrPositionScriptList[i].profitLossValue!);
            total = total * -1;
            totalPL = totalPL + total;
          }
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
        if (socketData.data?.symbol == arrPositionScriptList[selectedScriptIndex].symbolName) {
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
      var ltpObj = arrLtpUpdate.firstWhereOrNull((element) => element.symbolTitle == arrPositionScriptList[selectedScriptIndex].symbolName);
      if (ltpObj == null) {
        return "Something went wrong in trade price.";
      } else {
        var difference = DateTime.now().difference(ltpObj.dateTime!);
        var differenceInSeconds = difference.inSeconds;
        if (differenceInSeconds >= 40) {
          return "Something went wrong in trade price.";
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
        totalQuantity: int.parse(qtyController.text),
        price: double.parse(priceController.text),
        isFromStopLoss: selectedOrderType.value.id == "stopLoss",
        marketPrice: selectedOrderType.value.id == "stopLoss"
            ? arrPositionScriptList[selectedScriptIndex].scriptDataFromSocket.value.ltp!.toDouble()
            : isFromBuy
                ? arrPositionScriptList[selectedScriptIndex].scriptDataFromSocket.value.ask!.toDouble()
                : arrPositionScriptList[selectedScriptIndex].scriptDataFromSocket.value.bid!.toDouble(),
        lotSize: arrPositionScriptList[selectedScriptIndex].lotSize!.toInt(),
        orderType: selectedOrderType.value.id,
        tradeType: isFromBuy ? "buy" : "sell",
        exchangeId: arrPositionScriptList[selectedScriptIndex].exchangeId,
        productType: "longTerm",
        refPrice: isFromBuy ? arrPositionScriptList[selectedScriptIndex].scriptDataFromSocket.value.ask!.toDouble() : arrPositionScriptList[selectedScriptIndex].scriptDataFromSocket.value.bid!.toDouble(),
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
        lotSize: arrPositionScriptList[selectedScriptIndex].scriptDataFromSocket.value.ls!.toInt(),
        orderType: selectedOrderType.value.id,
        tradeType: isFromBuy ? "buy" : "sell",
        exchangeId: arrPositionScriptList[selectedScriptIndex].exchangeId,
        userId: selectedUser.value.userId!,
        refPrice: isFromBuy ? arrPositionScriptList[selectedScriptIndex].scriptDataFromSocket.value.ask!.toDouble() : arrPositionScriptList[selectedScriptIndex].scriptDataFromSocket.value.bid!.toDouble(),
      );

      //longterm
      isTradeCallFinished.value = false;
      update();
      if (response != null) {
        // Get.back();
        selectedOrderType.value = arrOrderType.firstWhere((element) => element.id == "market");
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

  buySellPopupDialog({bool isFromBuy = true, Function? CancelClick, Function? DeleteClick}) {
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
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
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
                                color: isFromBuy ? AppColors().blueColor : AppColors().redColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                isFromBuy ? "Buy Order" : "Sell Order",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isFromBuy ? AppColors().blueColor : AppColors().redColor,
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
                            color: isFromBuy ? AppColors().blueColor : AppColors().redColor,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Exchange",
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
                                          child: CustomTextField(
                                            type: 'Exchange',
                                            // regex: '[0-9]',
                                            roundCorner: 0,
                                            borderColor: Colors.transparent,
                                            // fillColor: AppColors().headerBgColor,

                                            keyBoardType: const TextInputType.numberWithOptions(signed: true, decimal: false),

                                            isShowPrefix: false,
                                            isShowSufix: false,
                                            isEnabled: false,
                                            isOptional: false,
                                            inValidMsg: AppString.emptyPassword,
                                            placeHolderMsg: "Exchange",

                                            emptyFieldMsg: AppString.emptyPassword,
                                            controller: exchangeController,
                                            focus: exchangeFocus,
                                            isSecure: false,
                                            maxLength: 50,
                                            keyboardButtonType: TextInputAction.done,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Text(
                                            "Order Type",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors().whiteColor,
                                              fontFamily: CustomFonts.family1Regular,
                                            ),
                                          ),
                                        ),
                                        orderTypeListDropDown()
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Obx(() {
                                          print(isValidQty.value);
                                          return Text(
                                            isValidQty.value ? "Quantity" : "Invalid Quantity",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isValidQty.value
                                                  ? AppColors().whiteColor
                                                  : isFromBuy
                                                      ? AppColors().redColor
                                                      : AppColors().blueColor,
                                              fontFamily: CustomFonts.family1Regular,
                                            ),
                                          );
                                        }),
                                        Container(
                                          width: 100,
                                          height: 40,
                                          margin: EdgeInsets.symmetric(vertical: 5),
                                          child: CustomTextField(
                                            regex: "[0-9]",
                                            type: '',
                                            focusBorderColor: AppColors().redColor,
                                            keyBoardType: TextInputType.none,
                                            isEnabled: true,
                                            isOptional: false,
                                            isNoNeededCapital: true,
                                            inValidMsg: AppString.emptyMobileNumber,
                                            placeHolderMsg: "",
                                            labelMsg: "",
                                            emptyFieldMsg: AppString.emptyMobileNumber,
                                            controller: qtyController,
                                            focus: qtyFocus,
                                            isSecure: false,
                                            keyboardButtonType: TextInputAction.next,
                                            onChange: () {
                                              if (qtyController.text.isNotEmpty) {
                                                print(arrPositionScriptList[selectedScriptIndex].oddLotTrade);
                                                print(arrPositionScriptList[selectedScriptIndex].lotSize);
                                                if (arrPositionScriptList[selectedScriptIndex].oddLotTrade == 1) {
                                                  var temp = (num.parse(qtyController.text) / arrPositionScriptList[selectedScriptIndex].lotSize!);
                                                  lotController.text = temp.toStringAsFixed(2);
                                                  print(temp);
                                                  isValidQty.value = true;
                                                } else {
                                                  var temp = (num.parse(qtyController.text) / arrPositionScriptList[selectedScriptIndex].lotSize!);

                                                  print(temp);
                                                  if ((num.parse(qtyController.text) % arrPositionScriptList[selectedScriptIndex].lotSize!) == 0) {
                                                    lotController.text = temp.toStringAsFixed(0);
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Text(
                                            "Lot",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors().whiteColor,
                                              fontFamily: CustomFonts.family1Regular,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 100,
                                          height: 40,
                                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                          child: NumberInputWithIncrementDecrementOwn(
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
                                            autovalidateMode: AutovalidateMode.disabled,
                                            fractionDigits: 2,
                                            textAlign: TextAlign.left,

                                            initialValue: 1,
                                            incDecFactor: 1,
                                            isInt: true,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: CustomFonts.family1Regular,
                                              color: AppColors().darkText,
                                            ),
                                            numberFieldDecoration: InputDecoration(border: InputBorder.none, fillColor: AppColors().whiteColor, contentPadding: EdgeInsets.only(bottom: 8, left: 20)),

                                            widgetContainerDecoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(0),
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 0,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: Text(
                                              "Price",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors().whiteColor,
                                                fontFamily: CustomFonts.family1Regular,
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
                                            child: NumberInputWithIncrementDecrementOwn(
                                              incIconSize: 18,
                                              decIconSize: 18,
                                              validator: (value) {
                                                return null;
                                              },
                                              fractionDigits: 2,
                                              textAlign: TextAlign.left,
                                              enabled: selectedOrderType.value.name != "Market",
                                              initialValue: double.tryParse(priceController.text) ?? 0.0,
                                              incDecFactor: 0.05,
                                              isInt: false,

                                              numberFieldDecoration: InputDecoration(border: InputBorder.none, fillColor: AppColors().whiteColor, contentPadding: EdgeInsets.only(bottom: 8, left: 20)),

                                              widgetContainerDecoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(0),
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Symbol",
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
                                            child: CustomTextField(
                                              type: 'Symbol',
                                              // regex: '[0-9]',
                                              roundCorner: 0,
                                              borderColor: Colors.transparent,
                                              // fillColor: AppColors().headerBgColor,
                                              keyBoardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
                                              prefixIcon: SizedBox(),
                                              suffixIcon: SizedBox(),

                                              isEnabled: false,
                                              isOptional: false,
                                              inValidMsg: AppString.emptyPassword,
                                              placeHolderMsg: "Symbol",

                                              emptyFieldMsg: AppString.emptyPassword,
                                              controller: symbolController,
                                              focus: symbolFocus,
                                              isSecure: false,
                                              maxLength: 50,
                                              keyboardButtonType: TextInputAction.done,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (selectedOrderType.value.name == "Market")
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                            padding: EdgeInsets.only(left: selectedOrderType.value.name! == "Market" ? 0 : 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 210,
                                                  height: 42,
                                                  child: CustomButton(
                                                    isEnabled: true,
                                                    shimmerColor: AppColors().whiteColor,
                                                    title: "Submit",
                                                    textSize: 16,
                                                    focusKey: SubmitFocus,
                                                    onPress: () {
                                                      initiateTrade(isFromBuy);
                                                    },
                                                    bgColor: AppColors().grayLightLine,
                                                    focusShadowColor: AppColors().whiteColor,
                                                    borderColor: isFromBuy ? AppColors().redColor : AppColors().blueColor,
                                                    isFilled: true,
                                                    textColor: AppColors().darkText,
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
                                                    shimmerColor: AppColors().whiteColor,
                                                    title: "Cancel",
                                                    textSize: 16,
                                                    focusShadowColor: AppColors().whiteColor,
                                                    borderColor: isFromBuy ? AppColors().redColor : AppColors().blueColor,
                                                    focusKey: CancelFocus,
                                                    onPress: () {
                                                      selectedExchangeFromPopup.value = ExchangeData();

                                                      selectedScriptFromPopup.value = ScriptData();
                                                      qtyController.text = "";
                                                      priceController.text = "";

                                                      remarkController.text = "";
                                                      isBuyOpen = -1;
                                                      Get.back();
                                                    },
                                                    bgColor: AppColors().whiteColor,
                                                    isFilled: true,
                                                    textColor: AppColors().darkText,
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
            decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1), color: AppColors().whiteColor),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButtonFormField<Type>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: isBuyOpen == 1 ? AppColors().redColor : AppColors().blueColor, width: 2)),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
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
                              child: Text(item.name ?? "", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().grayColor)),
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
                    value: selectedOrderType.value.id == null ? null : selectedOrderType.value,
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
                      decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1), color: AppColors().whiteColor),
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
                                        child: Text(item.name ?? "", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().grayColor)),
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
                                              fontFamily: CustomFonts.family1Medium,
                                              color: AppColors().darkText,
                                            ),
                                          ),
                                        ))
                                    .toList();
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(left: 15),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: isBuyOpen == 1 ? AppColors().redColor : AppColors().blueColor, width: 2)),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
                              ),
                              value: selectedValidity.value.id == null ? null : selectedValidity.value,
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

  Widget userListDropDown(Rx<UserData> selectedUser) {
    return Obx(() {
      return Container(
          width: 210,
          height: 40,
          // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors().lightOnlyText, width: 1),
            color: AppColors().whiteColor,
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButtonFormField<UserData>(
                isExpanded: false,
                menuMaxHeight: 130,
                alignment: Alignment.bottomCenter,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 15),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: isBuyOpen == 1 ? AppColors().redColor : AppColors().blueColor, width: 2)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
                ),
                hint: Text(
                  'Select User',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: CustomFonts.family1Medium,
                    color: AppColors().darkText,
                  ),
                ),
                items: arrUserListOnlyClient
                    .map((UserData item) => DropdownMenuItem<UserData>(
                          value: item,
                          child: Text(item.userName ?? "", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().grayColor)),
                        ))
                    .toList(),
                selectedItemBuilder: (context) {
                  return arrUserListOnlyClient
                      .map((UserData item) => DropdownMenuItem<UserData>(
                            value: item,
                            child: Text(
                              item.userName ?? "",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: CustomFonts.family1Medium,
                                color: AppColors().darkText,
                              ),
                            ),
                          ))
                      .toList();
                },
                value: selectedUser.value.userId == null ? null : selectedUser.value,

                onChanged: (UserData? value) {
                  selectedUser.value = value!;
                },
                // buttonStyleData: ButtonStyleData(
                //   padding: EdgeInsets.symmetric(horizontal: 0),
                //   height: 40,

                // ),
                // dropdownStyleData: DropdownStyleData(maxHeight: 150),
                // menuItemStyleData: const MenuItemStyleData(
                //   height: 40,
                // ),
              ),
            ),
          ));
    });
  }
}
