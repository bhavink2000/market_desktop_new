import 'dart:convert';

import 'package:floating_dialog/floating_dialog.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/constantModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/getScriptFromSocket.dart';
import 'package:marketdesktop/modelClass/ltpUpdateModelClass.dart';
import 'package:marketdesktop/modelClass/myTradeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import '../../../../constant/index.dart';
import '../../../../customWidgets/appButton.dart';
import '../../../../customWidgets/appTextField.dart';
import '../../../../customWidgets/incrimentField.dart';
import '../MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';

class TradeListController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;
  Rx<UserData> selectedUser = UserData().obs;
  int selectedOrderIndex = -1;

  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<Type> selectedOrderType = Type().obs;
  ScrollController listcontroller = ScrollController();
  int openPopUpCount = 0;
  List<TradeData> arrTrade = [];
  TradeData? selectedTrade;
  bool isLocalDataLoading = true;
  bool isApiCallRunning = false;

  bool isSuccessSelected = false;
  int totalSuccessRecord = 0;
  int totalPendingRecord = 0;

  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  FocusNode modifyFocus = FocusNode();
  FocusNode successFocus = FocusNode();
  int pageNumber = 1;
  int totalPage = 0;
  bool isResetCall = false;

  int isBuyOpen = -1;
  RxBool isValidQty = true.obs;
  TextEditingController qtyController = TextEditingController();
  FocusNode qtyFocus = FocusNode();
  TextEditingController lotController = TextEditingController();
  FocusNode lotFocus = FocusNode();
  TextEditingController priceController = TextEditingController();
  FocusNode priceFocus = FocusNode();

  FocusNode SubmitFocus = FocusNode();
  FocusNode CancelFocus = FocusNode();

  List<LtpUpdateModel> arrLtpUpdate = [];
  List<ListItem> arrListTitle = [
    if (userData!.role != UserRollList.user) ListItem("USERNAME", true),
    if (userData!.role != UserRollList.user) ListItem("PARENT USER", true),
    ListItem("SEGMENT", true),
    ListItem("SYMBOL", true),
    ListItem("B/S", true),
    ListItem("QTY", true),
    ListItem("LOT", true),
    ListItem("PRICE", true),
    ListItem("ORDER D/T", true),
    ListItem("TYPE", true),
    ListItem("CMP", true),
    ListItem("REFERENCE PRICE", true),
    ListItem("IP ADDRESS", true),
    ListItem("DEVICE", true),
    ListItem("DEVICE ID", true),
  ];

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getTradeList();
    lotController.addListener(() {
      // if (isQuantityUpdate == false) {
      if (!qtyFocus.hasFocus) {
        var temp = num.parse(lotController.text) * arrTrade[selectedOrderIndex].lotSize!;
        qtyController.text = temp.toString();
        // isValidQty = true.obs;
      }

      // }
    });
    listcontroller.addListener(() async {
      if ((listcontroller.position.pixels > listcontroller.position.maxScrollExtent / 2.5 && totalPage > 1 && pageNumber < totalPage && !isLocalDataLoading)) {
        isLocalDataLoading = true;
        pageNumber++;
        String strFromDate = "";
        String strToDate = "";
        if (fromDate.value != "Start Date") {
          strFromDate = fromDate.value;
        }
        if (endDate.value != "End Date") {
          strToDate = endDate.value;
        }
        update();
        var response = await service.getMyTradeListCall(
            status: "pending", page: pageNumber, text: "", userId: selectedUser.value.userId ?? "", symbolId: selectedScriptFromFilter.value.symbolId ?? "", exchangeId: selectedExchange.value.exchangeId ?? "", startDate: strFromDate, endDate: strToDate, orderType: selectedOrderType.value.id ?? "");
        if (response != null) {
          if (response.statusCode == 200) {
            totalPage = response.meta?.totalPage ?? 0;
            if (isSuccessSelected) {
              totalSuccessRecord = response.meta?.totalCount ?? 0;
            } else {
              totalPendingRecord = response.meta?.totalCount ?? 0;
            }

            for (var v in response.data!) {
              arrTrade.add(v);
            }
            isLocalDataLoading = false;
            update();
            var arrTemp = [];
            for (var element in response.data!) {
              if (!socket.arrSymbolNames.contains(element.symbolName)) {
                arrTemp.insert(0, element.symbolName);
                socket.arrSymbolNames.insert(0, element.symbolName!);
              }
            }

            if (arrTemp.isNotEmpty) {
              var txt = {"symbols": arrTemp};
              socket.connectScript(jsonEncode(txt));
            }
          }
        }
      }
    });
  }

  refreshView() {
    update();
  }

  getTradeList({bool isFromClear = false}) async {
    arrTrade.clear();
    pageNumber = 1;

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

    var response = await service.getMyTradeListCall(
        status: "pending", page: pageNumber, text: "", userId: selectedUser.value.userId ?? "", symbolId: selectedScriptFromFilter.value.symbolId ?? "", exchangeId: selectedExchange.value.exchangeId ?? "", startDate: strFromDate, endDate: strToDate, orderType: selectedOrderType.value.id ?? "");
    isLocalDataLoading = false;
    isApiCallRunning = false;
    isResetCall = false;
    update();
    if (response != null) {
      if (response.statusCode == 200) {
        var arrTemp = [];
        response.data?.forEach((v) {
          arrTrade.add(v);
        });
        update();
        totalPage = response.meta?.totalPage ?? 0;
        if (isSuccessSelected) {
          totalSuccessRecord = response.meta?.totalCount ?? 0;
        } else {
          totalPendingRecord = response.meta?.totalCount ?? 0;
        }
        for (var element in response.data!) {
          if (!socket.arrSymbolNames.contains(element.symbolName)) {
            arrTemp.insert(0, element.symbolName);
            socket.arrSymbolNames.insert(0, element.symbolName!);
          }
        }

        if (arrTemp.isNotEmpty) {
          var txt = {"symbols": arrTemp};
          socket.connectScript(jsonEncode(txt));
        }
      }
    }
  }

  cancelTrade() async {
    if (selectedOrderIndex == -1) {
      showWarningToast("Please select order.");
      return;
    }
    var response = await service.cancelTradeCall(arrTrade[selectedOrderIndex].tradeId!);
    if (response?.statusCode == 200) {
      arrTrade.removeAt(selectedOrderIndex);
      showSuccessToast(response!.meta!.message ?? "");
      selectedOrderIndex = -1;
      update();
    }
  }

  String validateForm() {
    var msg = "";
    if (qtyController.text.isEmpty) {
      msg = AppString.emptyQty;
    } else if (isValidQty == false) {
      msg = AppString.inValidQty;
    } else if (priceController.text.isEmpty) {
      msg = AppString.emptyPrice;
    }

    return msg;
  }

  cancelAllTrade() async {
    var response = await service.cancelAllTradeCall();
    if (response?.statusCode == 200) {
      arrTrade.clear();
      showSuccessToast(response!.meta!.message ?? "");
      selectedOrderIndex = -1;
      update();
    }
  }

  initiateTrade(bool isFromBuy) async {
    var msg = validateForm();

    if (msg.isEmpty) {
      isBuyOpen = -1;
      Get.back();

      update();
      var response = await service.modifyTradeCall(
        tradeId: arrTrade[selectedOrderIndex].tradeId!,
        symbolId: arrTrade[selectedOrderIndex].symbolId!,
        quantity: double.parse(lotController.text),
        totalQuantity: double.parse(qtyController.text),
        price: double.parse(priceController.text),
        marketPrice: double.parse(priceController.text),
        lotSize: arrTrade[selectedOrderIndex].lotSize!.toDouble(),
        orderType: arrTrade[selectedOrderIndex].orderType,
        tradeType: isFromBuy ? "buy" : "sell",
        exchangeId: arrTrade[selectedOrderIndex].exchangeId,
        productType: arrTrade[selectedOrderIndex].productTypeMain!,
        refPrice: isFromBuy ? arrTrade[selectedOrderIndex].scriptDataFromSocket.value.ask!.toDouble() : arrTrade[selectedOrderIndex].scriptDataFromSocket.value.bid!.toDouble(),
      );

      if (response != null) {
        // Get.back();
        if (response.statusCode == 200) {
          showSuccessToast(response.meta!.message!, bgColor: isFromBuy ? AppColors().blueColor : AppColors().redColor);
          // pageNumber = 1;
          // arrTrade.clear();
          // getTradeList();
          update();
        } else {
          showErrorToast(response.message!);
          update();
        }

        qtyController.text = "";
        priceController.text = "";
      }
    } else {
      // stateSetter(() {});
      showWarningToast(msg);
      Future.delayed(const Duration(milliseconds: 100), () {});
    }
  }

  pendingToSuccessTrade(bool isFromBuy) async {
    var ltpObj = arrLtpUpdate.firstWhereOrNull((element) => element.symbolTitle == arrTrade[selectedOrderIndex].symbolName);
    if (ltpObj == null) {
      showWarningToast("Something went wrong in trade price.");
      return;
    } else {
      var difference = DateTime.now().difference(ltpObj.dateTime!);
      var differenceInSeconds = difference.inSeconds;
      if (differenceInSeconds >= 40) {
        showWarningToast("Something went wrong in trade price.");
        return;
      }
    }
    var response = await service.modifyTradeCall(
      tradeId: arrTrade[selectedOrderIndex].tradeId!,
      symbolId: arrTrade[selectedOrderIndex].symbolId!,
      quantity: arrTrade[selectedOrderIndex].quantity!.toDouble(),
      totalQuantity: arrTrade[selectedOrderIndex].totalQuantity!.toDouble(),
      price: arrTrade[selectedOrderIndex].currentPriceFromSocket,
      marketPrice: arrTrade[selectedOrderIndex].currentPriceFromSocket,
      lotSize: arrTrade[selectedOrderIndex].lotSize!.toDouble(),
      orderType: "market",
      tradeType: isFromBuy ? "buy" : "sell",
      exchangeId: arrTrade[selectedOrderIndex].exchangeId,
      productType: arrTrade[selectedOrderIndex].productTypeMain!,
      refPrice: isFromBuy ? arrTrade[selectedOrderIndex].scriptDataFromSocket.value.ask!.toDouble() : arrTrade[selectedOrderIndex].scriptDataFromSocket.value.bid!.toDouble(),
    );

    if (response != null) {
      // Get.back();
      if (response.statusCode == 200) {
        showSuccessToast(response.meta!.message!, bgColor: isFromBuy ? AppColors().blueColor : AppColors().redColor);
        pageNumber = 1;
        arrTrade.clear();
        getTradeList();
        update();
      } else {
        showErrorToast(response.message!);
        update();
      }

      qtyController.text = "";
      priceController.text = "";
    }
  }

  addSymbolInSocket(String symbolName) {
    if (!socket.arrSymbolNames.contains(symbolName)) {
      socket.arrSymbolNames.insert(0, symbolName);
      var txt = {
        "symbols": [symbolName]
      };
      socket.connectScript(jsonEncode(txt));
    }
  }

  listenTradeScriptFromSocket(GetScriptFromSocket socketData) {
    if (socketData.status == true) {
      var obj = arrTrade.firstWhereOrNull((element) => socketData.data!.symbol == element.symbolName);

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
        for (var i = 0; i < arrTrade.length; i++) {
          if (arrTrade[i].symbolName == socketData.data!.symbol) {
            arrTrade[i].scriptDataFromSocket.value = socketData.data!;
            arrTrade[i].currentPriceFromSocket = arrTrade[i].tradeType == "buy" ? double.parse(socketData.data!.ask.toString()) : double.parse(socketData.data!.bid.toString());
          }
        }
      }
      update();
    }
  }

  Color getPriceColor(String type, double currentPrice, double tradePrice) {
    switch (type) {
      case "buy":
        {
          if (currentPrice > tradePrice) {
            return AppColors().greenColor;
          } else if (currentPrice < tradePrice) {
            return AppColors().redColor;
          } else {
            return AppColors().fontColor;
          }
        }
      case "sell":
        {
          if (currentPrice < tradePrice) {
            return AppColors().greenColor;
          } else if (currentPrice > tradePrice) {
            return AppColors().redColor;
          } else {
            return AppColors().fontColor;
          }
        }

      default:
        {
          return AppColors().darkText;
        }
    }
  }

  num getNetPrice(String isFromBuy, num tradePrice, num brokerage) {
    if (isFromBuy == "buy") {
      return tradePrice + brokerage;
    } else {
      return tradePrice - brokerage;
    }
  }

  modifyBuySellPopupDialog({bool isFromBuy = true}) {
    selectedUser = UserData().obs;

    showDialog<String>(
        context: Get.context!,
        barrierDismissible: true,
        builder: (BuildContext context) => FloatingDialog(
              enableDragAnimation: false,
              // titlePadding: EdgeInsets.zero,
              // backgroundColor: AppColors().bgColor,
              // surfaceTintColor: AppColors().bgColor,
              // insetPadding: EdgeInsets.symmetric(
              //   horizontal: 20.w,
              //   vertical: 32.h,
              // ),
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
                          height: 40,
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
                                isFromBuy ? "Modify Buy Order" : "Modify Sell Order",
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
                        Container(
                          height: 1,
                          color: AppColors().lightOnlyText,
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
                                          "Client Name",
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
                                          color: AppColors().whiteColor,
                                          margin: EdgeInsets.only(top: 5, bottom: 5, right: 10),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  arrTrade[selectedOrderIndex].userName!,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors().darkText,
                                                    fontFamily: CustomFonts.family1Regular,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Order Type",
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
                                          color: AppColors().whiteColor,
                                          margin: EdgeInsets.only(top: 5, bottom: 5, right: 10),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  arrTrade[selectedOrderIndex].orderTypeValue!,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors().darkText,
                                                    fontFamily: CustomFonts.family1Regular,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
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
                                            keyBoardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
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
                                                if (arrTrade[selectedOrderIndex].oddLotTrade == 1) {
                                                  var temp = (num.parse(qtyController.text) / arrTrade[selectedOrderIndex].lotSize!);
                                                  lotController.text = temp.toStringAsFixed(2);
                                                  isValidQty.value = true;
                                                } else {
                                                  var temp = (num.parse(qtyController.text) / arrTrade[selectedOrderIndex].lotSize!);

                                                  print(temp);
                                                  if ((num.parse(qtyController.text) % arrTrade[selectedOrderIndex].lotSize!) == 0) {
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
                                            onDecrement: (newValue) {
                                              isValidQty = true.obs;
                                              setState(() {});
                                            },
                                            onIncrement: (newValue) {
                                              isValidQty = true.obs;
                                              setState(() {});
                                            },
                                            onChanged: (newValue) {},
                                            autovalidateMode: AutovalidateMode.disabled,
                                            fractionDigits: 2,
                                            textAlign: TextAlign.left,

                                            initialValue: num.tryParse(lotController.text) ?? 0,
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
                                        // if (userData?.role != UserRollList.superAdmin)
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
                                              onChanged: (newValue) {},
                                              autovalidateMode: AutovalidateMode.disabled,
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
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Exchange",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors().whiteColor,
                                            fontFamily: CustomFonts.family1Regular,
                                          ),
                                        ),
                                        Container(
                                          width: 210,
                                          height: 40,
                                          color: AppColors().whiteColor,
                                          margin: EdgeInsets.only(top: 5, bottom: 5, right: 10),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  arrTrade[selectedOrderIndex].exchangeName!,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors().darkText,
                                                    fontFamily: CustomFonts.family1Regular,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                                          color: AppColors().whiteColor,
                                          margin: EdgeInsets.only(top: 5, bottom: 5, right: 10),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  arrTrade[selectedOrderIndex].symbolTitle!,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors().darkText,
                                                    fontFamily: CustomFonts.family1Regular,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
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
                                                borderColor: isFromBuy ? AppColors().redColor : AppColors().blueColor,
                                                focusShadowColor: AppColors().whiteColor,
                                                onPress: () {
                                                  // initiateManualTrade(isFromBuy);
                                                  initiateTrade(isFromBuy);
                                                },
                                                bgColor: AppColors().grayLightLine,
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
                                                borderColor: isFromBuy ? AppColors().redColor : AppColors().blueColor,
                                                textSize: 16,
                                                focusKey: CancelFocus,
                                                focusShadowColor: AppColors().whiteColor,
                                                // buttonWidth: 36.w,
                                                onPress: () {
                                                  // selectedExchangeFromPopup.value = ExchangeData();
                                                  // selectedOrderType = Type().obs;
                                                  // selectedScriptFromPopup.value = ScriptData();
                                                  // qtyController.text = "";
                                                  // priceController.text = "";
                                                  // selectedUser.value = "";
                                                  // selectedValidity.value = "";
                                                  // remarkController.text = "";
                                                  isBuyOpen = -1;
                                                  // focusNode.requestFocus();
                                                  update();
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
                                      ],
                                    )
                                  ],
                                ),
                                // SizedBox(
                                //   height: 20,
                                // ),
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
}
