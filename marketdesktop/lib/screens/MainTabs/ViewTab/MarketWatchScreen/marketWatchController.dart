import 'dart:async';
import 'dart:convert';
import 'package:floating_dialog/floating_dialog.dart';
import 'package:marketdesktop/modelClass/strikePriceModelClass.dart';
import 'package:marketdesktop/service/database/dbService.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/customWidgets/incrimentField.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';
import 'package:window_size/window_size.dart';
import '../../../../constant/index.dart';
import '../../../../customWidgets/appButton.dart';
import '../../../../customWidgets/appTextField.dart';
import '../../../../modelClass/allSymbolListModelClass.dart';
import '../../../../modelClass/exchangeListModelClass.dart';
import '../../../../modelClass/expiryListModelClass.dart';
import '../../../../modelClass/getScriptFromSocket.dart';
import '../../../../modelClass/ltpUpdateModelClass.dart';
import '../../../../modelClass/myUserListModelClass.dart';
import '../../../../modelClass/tabListModelClass.dart';
import '../../../../modelClass/tabWiseSymbolListModelClass.dart';
import '../../../../modelClass/constantModelClass.dart';

class MarketWatchController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  TextEditingController qtyController = TextEditingController();
  FocusNode qtyFocus = FocusNode();
  TextEditingController lotController = TextEditingController();
  FocusNode lotFocus = FocusNode();
  TextEditingController priceController = TextEditingController();
  FocusNode priceFocus = FocusNode();
  FocusNode SubmitFocus = FocusNode();
  FocusNode CancelFocus = FocusNode();
  ScrollController mainScroll = ScrollController();
  ScrollController listScroll = ScrollController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  FocusNode textEditingFocus = FocusNode();
  FocusNode remarkFocus = FocusNode();
  List<ExchangeData> arrExchange = [];
  List<LtpUpdateModel> arrLtpUpdate = [];

  List<GlobalSymbolData> arrAllScript = [];
  List<GlobalSymbolData> arrAllScriptForF5 = [];
  List<GlobalSymbolData> arrSearchedScript = [];
  RxList<ScriptData> arrScript = RxList<ScriptData>();
  RxList<ScriptData> arrPreScript = RxList<ScriptData>();
  List<SymbolData> arrSymbol = [];
  List<Type> arrOrderType = [];
  List<expiryData> arrExpiry = [];
  List<StrikePriceData> arrStrikePrice = [];
  ScrollController sheetController = ScrollController();
  final debouncer = Debouncer(milliseconds: 300);
  final slowDebouncer = Debouncer(milliseconds: 200);
  bool isKeyPressActive = false;
  List<Type> arrValidaty = [];
  double maxWidth = 0.0;
  int selectedIndexforCut = -1;
  int selectedIndexforUndo = -1;
  int selectedIndexforPaste = -1;
  var typedString = "";

  // FocusNode userListDropDownFocus = FocusNode();
  List<ListItem> arrListTitleMarket = [
    ListItem("EXCHANGE", true),
    ListItem("SYMBOL", true),
    ListItem("BUY QTY", false),
    ListItem("BUY PRICE", true),
    ListItem("SELL PRICE", true),
    ListItem("SELL QTY", false),
    ListItem("NET CHANGE", true),
    ListItem("HIGH", true),
    ListItem("LOW", true),
    ListItem("OPEN", true),
    ListItem("CLOSE", true),
    ListItem("LTP", true),
    ListItem("NET CHANGE %", true),
    ListItem("EXPIRY", true),
    ListItem("STRIKE PRICE", true),
    ListItem("LUT", false),
  ];
  bool isAddDeleteApiLoading = false;
  int currentSelectedScriptIndexFromDropDown = -1;
  int selectedScriptIndex = -1;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<ExchangeData> selectedExchangeForF5 = ExchangeData().obs;
  Rx<Type> selectedOrderType = Type().obs;
  Rx<UserData> selectedUser = UserData().obs;
  Rx<Type> selectedValidity = Type().obs;
  Rx<ExchangeData> selectedExchangeFromPopup = ExchangeData().obs;
  int selectedPortfolio = 0;
  Rx<ScriptData> selectedScriptFromPopup = ScriptData().obs;
  List<TabData> arrTabList = [];
  List<UserData> arrUserListOnlyClient = [];

  Rx<ScriptData?> selectedScript = ScriptData().obs;
  Rx<ScriptData?> selectedScriptForF5 = ScriptData().obs;
  Rx<GlobalSymbolData?> selectedSymbolForF5 = GlobalSymbolData().obs;
  Rx<GlobalSymbolData?> selectedSymbolForTopDropDown = GlobalSymbolData().obs;
  // final FocusNode focusNode = FocusNode();

  RxBool isTradeCallFinished = true.obs;
  TabData? selectedTab;
  SymbolData? selectedSymbol;
  int isBuyOpen = -1;

  bool isScripDetailOpen = false;
  String selectedFontFamily = "ARIALBD";
  double selectedFontSize = 14;
  bool isScriptApiGoing = false;
  bool isSymbolListApiCall = false;
  bool isGridActive = false;
  RxDouble visibleWidth = 0.0.obs;
  bool isQuantityUpdate = false;
  RxBool isValidQty = true.obs;
  int isFilterClicked = 0;
  Size screenSize = const Size(0, 0);
  int marketWatchScreenIndex = -1;
  DbService dbSerivice = DbService();
  Rx<expiryData> selectedExpiry = expiryData().obs;
  Rx<Type> selectedCallPut = Type().obs;
  Rx<StrikePriceData> selectedStrikePrice = StrikePriceData().obs;
  Rx<expiryData> selectedExpiryForF5 = expiryData().obs;
  Rx<Type> selectedCallPutForF5 = Type().obs;
  Rx<StrikePriceData> selectedStrikePriceForF5 = StrikePriceData().obs;
  List<Map<String, dynamic>> arrCurrentWatchListOrder = [];
  List<List<Map<String, dynamic>>> arrWatchListsOrder = [];
  int availableOpenDropDown = 0;

  Rx<FocusNode> tempFocus = FocusNode().obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    tempFocus.value.addListener(() {
      if (tempFocus.value.hasFocus) {
        // selectedScriptIndex = 0;
      } else {
        // if (isBuyOpen == -1) {
        //   selectedScriptIndex = -1;
        // }
      }
      update();
    });
    tempFocus.value.requestFocus();
    priceController.text = "0.0";
    arrValidaty = constantValues!.productType ?? [];
    // handleKeyEvents();
    arrOrderType = constantValues?.orderType ?? [];
    if (userData!.role == UserRollList.superAdmin) {
      arrOrderType.removeWhere((element) => element.id == "stopLoss");
    } else if (userData!.role == UserRollList.master) {
      // arrOrderType.removeWhere((element) => element.id == "stopLoss");
      // arrOrderType.removeWhere((element) => element.id == "limit");
    } else if (userData!.role == UserRollList.user) {
      arrOrderType.add(Type(name: "Intraday", id: "123"));
    }
    arrOrderType.removeAt(0);
    Future.delayed(const Duration(milliseconds: 100), () async {
      Screen? size = await getCurrentScreen();
      screenSize = Size(size!.frame.width, size.frame.height);
      maxWidth = size.frame.width > 1750 ? size.frame.width : 1750; //
      globalScreenSize = Size(size.frame.width, size.frame.height);
      globalMaxWidth = size.frame.width > 1750 ? size.frame.width : 1750; //

      selectedOrderType.value =
          arrOrderType.firstWhere((element) => element.id == "market");
      update();
      // getUserList();
      getExchangeList();
      getScriptList();
      getUserTabList();
      Future.delayed(Duration(seconds: 2), () {
        showRulesPopup();
      });

      lotController.addListener(() {
        // if (isQuantityUpdate == false) {
        if (!qtyFocus.hasFocus) {
          var temp = num.parse(lotController.text) * selectedScript.value!.ls!;
          qtyController.text = temp.toString();
          // isValidQty = true.obs;
        }

        // }
      });
      // qtyController.addListener(() {
      //   // if (isQuantityUpdate) {
      //   var temp = num.parse(qtyController.text) / selectedScript.value!.ls!;
      //   lotController.text = temp.toString();
      //   // }
      // });
    });
    // focusNode.addListener(() {
    //   //print("has focus on market     ${focusNode.hasFocus}");
    // });
    // focusNode.requestFocus();
  }

  getUserList(String keyWord, String userType) async {
    print(keyWord);
    var response = await service.getMyUserListByKeywordCall(
        text: keyWord, roleId: userType);
    if (response != null) {
      if (response.statusCode == 200) {
        arrUserListOnlyClient = response.data ?? [];
        return arrUserListOnlyClient;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }

  double getTotal(bool isBuy) {
    var total = 0.0;
    if (isBuy) {
      for (var element in selectedScriptForF5.value!.depth!.buy!) {
        total = total + element.price!;
      }
    } else {
      for (var element in selectedScriptForF5.value!.depth!.sell!) {
        total = total + element.price!;
      }
    }
    return total;
  }

  getExchangeList() async {
    var response = await service.getExchangeListCall();
    if (response != null) {
      if (response.statusCode == 200) {
        arrExchange = response.exchangeData ?? [];
        update();
      }
    }
  }

  getExpiryList() async {
    var response = await service.expiryListCall(
        selectedExchangeForF5.value.exchangeId!,
        selectedSymbolForF5.value!.symbolId!);
    if (response != null) {
      if (response.statusCode == 200) {
        arrExpiry = response.data ?? [];
        update();
      }
    }
  }

  getExpiryListForTop() async {
    var response = await service.expiryListCall(
        selectedExchange.value.exchangeId!,
        selectedSymbolForTopDropDown.value!.symbolId!);
    if (response != null) {
      if (response.statusCode == 200) {
        arrExpiry = response.data ?? [];
        update();
      }
    }
  }

  getStrikePriceList() async {
    var response = await service.strikePriceListCall(
        selectedExchangeForF5.value.exchangeId!,
        selectedSymbolForF5.value!.symbolId!,
        selectedCallPutForF5.value.id!,
        shortDateForBackend(selectedExpiryForF5.value.expiryDate!));
    if (response != null) {
      if (response.statusCode == 200) {
        arrStrikePrice = response.data ?? [];
        update();
      }
    }
  }

  getStrikePriceListForTop() async {
    var response = await service.strikePriceListCall(
        selectedExchange.value.exchangeId!,
        selectedSymbolForTopDropDown.value!.symbolId!,
        selectedCallPut.value.id!,
        shortDateForBackend(selectedExpiry.value.expiryDate!));
    if (response != null) {
      if (response.statusCode == 200) {
        arrStrikePrice = response.data ?? [];
        update();
      }
    }
  }

  getScriptList({bool isFromF5 = false}) async {
    isScriptApiGoing = true;
    if (isFromF5) {
      arrAllScriptForF5.clear();
      // selectedScriptForF5.value = ScriptData();
    } else {
      arrAllScript.clear();
    }
    arrExpiry.clear();
    selectedExpiry.value = expiryData();
    selectedCallPut.value = Type();
    selectedStrikePrice.value = StrikePriceData();
    update();
    var response = await service.allSymbolListCallForMarket(
        1,
        "",
        isFromF5
            ? selectedExchangeForF5.value.exchangeId ?? ""
            : selectedExchange.value.exchangeId ?? "");
    if (isFromF5) {
      arrAllScriptForF5 = response!.data ?? [];
      var temp = arrAllScriptForF5.firstWhereOrNull(
          (element) => element.symbolId == selectedSymbol!.symbolId);
      selectedSymbolForF5.value = temp ?? GlobalSymbolData();

      getExpiryList();
      update();
    } else {
      arrAllScript = response!.data ?? [];
    }

    isScriptApiGoing = false;
    update();
  }

  //   ListItem("LUT", false),
  sortScript(String name) {
    arrScript.removeWhere((element) => element.symbol!.isEmpty);
    arrPreScript.removeWhere((element) => element.symbol!.isEmpty);
    var index =
        arrListTitleMarket.indexWhere((element) => element.title == name);
    switch (name) {
      case "EXCHANGE":
        switch (arrListTitleMarket[index].sortType) {
          case 0:
          case -1:
            {
              arrListTitleMarket[index].sortType = 1;
              arrScript.sort((a, b) => b.exchange!.compareTo(a.exchange!));

              break;
            }
          case 1:
            {
              arrListTitleMarket[index].sortType = -1;
              arrScript.sort((a, b) => a.exchange!.compareTo(b.exchange!));
              break;
            }
        }
        break;
      case "SYMBOL":
        {
          switch (arrListTitleMarket[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitleMarket[index].sortType = 1;
                arrScript.sort((a, b) => b.symbol!.compareTo(a.symbol!));

                break;
              }
            case 1:
              {
                arrListTitleMarket[index].sortType = -1;
                arrScript.sort((a, b) => a.symbol!.compareTo(b.symbol!));
                break;
              }
          }

          break;
        }
      case "EXPIRY":
        {
          switch (arrListTitleMarket[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitleMarket[index].sortType = 1;
                arrScript.sort((a, b) => b.expiry!.compareTo(a.expiry!));

                break;
              }
            case 1:
              {
                arrListTitleMarket[index].sortType = -1;
                arrScript.sort((a, b) => a.expiry!.compareTo(b.expiry!));
                break;
              }
          }

          break;
        }
      case "BUY QTY":
        {
          switch (arrListTitleMarket[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitleMarket[index].sortType = 1;
                arrScript.sort((a, b) => b.tbq!.compareTo(a.tbq!));

                break;
              }
            case 1:
              {
                arrListTitleMarket[index].sortType = -1;
                arrScript.sort((a, b) => a.tbq!.compareTo(b.tbq!));
                break;
              }
          }

          break;
        }
      case "BUY PRICE":
        {
          switch (arrListTitleMarket[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitleMarket[index].sortType = 1;
                arrScript.sort((a, b) => b.bid!.compareTo(a.bid!));

                break;
              }
            case 1:
              {
                arrListTitleMarket[index].sortType = -1;
                arrScript.sort((a, b) => a.bid!.compareTo(b.bid!));
                break;
              }
          }

          break;
        }
      case "SELL PRICE":
        {
          switch (arrListTitleMarket[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitleMarket[index].sortType = 1;
                arrScript.sort((a, b) => b.ask!.compareTo(a.ask!));

                break;
              }
            case 1:
              {
                arrListTitleMarket[index].sortType = -1;
                arrScript.sort((a, b) => a.ask!.compareTo(b.ask!));
                break;
              }
          }

          break;
        }
      case "SELL QTY":
        {
          switch (arrListTitleMarket[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitleMarket[index].sortType = 1;
                arrScript.sort((a, b) => b.tsq!.compareTo(a.tsq!));

                break;
              }
            case 1:
              {
                arrListTitleMarket[index].sortType = -1;
                arrScript.sort((a, b) => a.tsq!.compareTo(b.tsq!));
                break;
              }
          }

          break;
        }
      case "NET CHANGE":
        {
          switch (arrListTitleMarket[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitleMarket[index].sortType = 1;
                arrScript.sort((a, b) => b.ch!.compareTo(a.ch!));

                break;
              }
            case 1:
              {
                arrListTitleMarket[index].sortType = -1;
                arrScript.sort((a, b) => a.ch!.compareTo(b.ch!));
                break;
              }
          }

          break;
        }
      case "HIGH":
        {
          switch (arrListTitleMarket[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitleMarket[index].sortType = 1;
                arrScript.sort((a, b) => b.high!.compareTo(a.high!));

                break;
              }
            case 1:
              {
                arrListTitleMarket[index].sortType = -1;
                arrScript.sort((a, b) => a.high!.compareTo(b.high!));
                break;
              }
          }

          break;
        }
      case "LOW":
        {
          switch (arrListTitleMarket[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitleMarket[index].sortType = 1;
                arrScript.sort((a, b) => b.low!.compareTo(a.low!));

                break;
              }
            case 1:
              {
                arrListTitleMarket[index].sortType = -1;
                arrScript.sort((a, b) => a.low!.compareTo(b.low!));
                break;
              }
          }

          break;
        }
      case "OPEN":
        {
          switch (arrListTitleMarket[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitleMarket[index].sortType = 1;
                arrScript.sort((a, b) => b.open!.compareTo(a.open!));

                break;
              }
            case 1:
              {
                arrListTitleMarket[index].sortType = -1;
                arrScript.sort((a, b) => a.open!.compareTo(b.open!));
                break;
              }
          }

          break;
        }
      case "CLOSE":
        {
          switch (arrListTitleMarket[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitleMarket[index].sortType = 1;
                arrScript.sort((a, b) => b.close!.compareTo(a.close!));

                break;
              }
            case 1:
              {
                arrListTitleMarket[index].sortType = -1;
                arrScript.sort((a, b) => a.close!.compareTo(b.close!));
                break;
              }
          }

          break;
        }
      case "LTP":
        {
          switch (arrListTitleMarket[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitleMarket[index].sortType = 1;
                arrScript.sort((a, b) => b.ltp!.compareTo(a.ltp!));

                break;
              }
            case 1:
              {
                arrListTitleMarket[index].sortType = -1;
                arrScript.sort((a, b) => a.ltp!.compareTo(b.ltp!));
                break;
              }
          }

          break;
        }
      case "NET CHANGE %":
        {
          switch (arrListTitleMarket[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitleMarket[index].sortType = 1;
                arrScript.sort((a, b) => b.chp!.compareTo(a.chp!));

                break;
              }
            case 1:
              {
                arrListTitleMarket[index].sortType = -1;
                arrScript.sort((a, b) => a.chp!.compareTo(b.chp!));
                break;
              }
          }

          break;
        }
      case "STRIKE PRICE":
        {
          switch (arrListTitleMarket[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitleMarket[index].sortType = 1;
                arrScript.sort((a, b) => b.chp!.compareTo(a.chp!));

                break;
              }
            case 1:
              {
                arrListTitleMarket[index].sortType = -1;
                arrScript.sort((a, b) => a.chp!.compareTo(b.chp!));
                break;
              }
          }

          break;
        }
      default:
    }

    for (var i = 0; i < arrScript.length; i++) {
      var preIndex = arrPreScript
          .indexWhere((element) => element.symbol == arrScript[i].symbol);
      var temp = arrPreScript.removeAt(preIndex);
      arrPreScript.insert(i, temp);
    }

    storeScripsInDB();

    update();
  }

  String validateForm() {
    var msg = "";
    if (selectedOrderType.value.id != "limit") {
      if (selectedSymbol!.tradeSecond != 0) {
        var ltpObj = arrLtpUpdate.firstWhereOrNull(
            (element) => element.symbolTitle == selectedScript.value!.symbol);

        if (ltpObj == null) {
          return "INVALID SERVER TIME";
        } else {
          var difference = DateTime.now().difference(ltpObj.dateTime!);
          var differenceInSeconds = difference.inSeconds;
          if (differenceInSeconds >= selectedSymbol!.tradeSecond!) {
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
        if (selectedUser.value.userId == null) {
          msg = AppString.notSelectedUserName;
        } else if (qtyController.text.isEmpty) {
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

  void upScrollToIndex(int index) {
    print("called");
    if (index >= 0 && index < arrScript.length) {
      final double itemHeight = 30.0; // Replace with your item height
      final double listViewHeight = listScroll.position.viewportDimension;
      final double scrollTo = index * itemHeight;

      final double currentScrollOffset = listScroll.offset;
      print(scrollTo);
      print(currentScrollOffset);
      listScroll.animateTo(
        scrollTo,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      // if (scrollTo < currentScrollOffset && currentScrollOffset != 0) {
      //   if (currentScrollOffset - scrollTo < listViewHeight) {
      //     listScroll.animateTo(
      //       scrollTo,
      //       duration: const Duration(milliseconds: 300),
      //       curve: Curves.easeInOut,
      //     );
      //   } else {
      //     listScroll.animateTo(
      //       currentScrollOffset - listViewHeight,
      //       duration: const Duration(milliseconds: 300),
      //       curve: Curves.easeInOut,
      //     );
      //   }
      // }
    }
  }

  void scrollToIndex(int index) {
    if (index >= 0 && index < arrScript.length) {
      final double itemHeight = 31.0; // Replace with your item height
      final double listViewHeight = listScroll.position.viewportDimension;
      final double scrollTo = index * itemHeight;

      final double maxScrollExtent = listScroll.position.maxScrollExtent;
      final double currentScrollOffset = listScroll.offset;

      if (scrollTo > listViewHeight) {
        final double scrollOffset = scrollTo - listViewHeight + itemHeight;
        if (scrollOffset < maxScrollExtent) {
          if (currentScrollOffset != maxScrollExtent) {
            listScroll.animateTo(
              scrollOffset,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        } else {
          if (currentScrollOffset != maxScrollExtent) {
            listScroll.animateTo(
              maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        }
      } else if (scrollTo < currentScrollOffset) {
        if (currentScrollOffset - scrollTo < listViewHeight) {
          listScroll.animateTo(
            scrollTo,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          listScroll.animateTo(
            currentScrollOffset - listViewHeight,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    }
  }

  double getLimitPrice(double inputPrice, bool isFromBuy) {
    if (isFromBuy) {
      if (inputPrice > selectedScript.value!.ask!.toDouble()) {
        return selectedScript.value!.ask!.toDouble();
      } else {
        return inputPrice;
      }
    } else {
      if (inputPrice < selectedScript.value!.bid!.toDouble()) {
        return selectedScript.value!.bid!.toDouble();
      } else {
        return inputPrice;
      }
    }
  }

  bool isFromLimitCheck(double inputPrice, bool isFromBuy) {
    if (isFromBuy) {
      if (inputPrice > selectedScript.value!.ask!.toDouble()) {
        return false;
      } else {
        return true;
      }
    } else {
      if (inputPrice < selectedScript.value!.bid!.toDouble()) {
        return false;
      } else {
        return true;
      }
    }
  }

  initiateTrade(bool isFromBuy) async {
    var msg = validateForm();

    isTradeCallFinished.value = true;
    if (msg.isEmpty) {
      isBuyOpen = -1;
      Get.back();
      isTradeCallFinished.value = false;
      update();
      var response = await service.tradeCall(
        symbolId: selectedSymbol!.symbolId,
        quantity: double.parse(lotController.text),
        totalQuantity: double.parse(qtyController.text),
        price: double.parse(priceController.text),
        isFromStopLoss: selectedOrderType.value.id == "stopLoss",
        marketPrice: selectedOrderType.value.id == "stopLoss"
            ? isFromBuy
                ? selectedScript.value!.ask!.toDouble()
                : selectedScript.value!.bid!.toDouble()
            : selectedOrderType.value.id == "limit"
                ? getLimitPrice(double.parse(priceController.text), isFromBuy)
                : isFromBuy
                    ? selectedScript.value!.ask!.toDouble()
                    : selectedScript.value!.bid!.toDouble(),
        lotSize: selectedSymbol!.lotSize!,
        orderType: selectedOrderType.value.id == "123" ||
                (selectedOrderType.value.id == "limit" &&
                    isFromLimitCheck(
                            double.parse(priceController.text), isFromBuy) ==
                        false)
            ? "market"
            : selectedOrderType.value.id,
        tradeType: isFromBuy ? "buy" : "sell",
        exchangeId: selectedSymbol!.exchangeId,
        productType:
            selectedOrderType.value.id == "123" ? "intraday" : "longTerm",
        refPrice: isFromBuy
            ? selectedScript.value!.ask!.toDouble()
            : selectedScript.value!.bid!.toDouble(),
      );

      //longterm
      isTradeCallFinished.value = false;
      update();
      selectedOrderType.value =
          arrOrderType.firstWhere((element) => element.id == "market");
      if (response != null) {
        // Get.back();
        if (response.statusCode == 200) {
          // bool isPositionAvailable = Get.isRegistered<PositionController>();
          // bool isTradeAvailable = Get.isRegistered<TradeListController>();
          // bool isSuccessTradeAvailable = Get.isRegistered<SuccessTradeListController>();
          // if (isSuccessTradeAvailable) {
          //   Get.find<SuccessTradeListController>().getTradeList();
          // }
          // if (isTradeAvailable) {
          //   Get.find<TradeListController>().getTradeList();
          // }
          // if (isPositionAvailable) {
          //   var positionVC = Get.find<PositionController>();

          //   positionVC.arrPositionScriptList.clear();
          //   positionVC.currentPage = 1;
          //   positionVC.getPositionList("", isFromClear: true, isFromfilter: true);
          // }

          showSuccessToast(response.meta!.message!,
              bgColor:
                  isFromBuy ? AppColors().blueColor : AppColors().redColor);
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

    isTradeCallFinished.value = true;
    if (msg.isEmpty) {
      isBuyOpen = -1;
      Get.back();
      isTradeCallFinished.value = false;

      var response = await service.manualTradeCall(
        symbolId: selectedSymbol!.symbolId,
        quantity: double.parse(lotController.text),
        totalQuantity: double.parse(qtyController.text),
        price: double.parse(priceController.text),
        lotSize: selectedScript.value!.ls!.toInt(),
        exchangeId: selectedSymbol!.exchangeId,
        executionTime: serverFormatDateTime(DateTime.now()),
        userId: selectedUser.value.userId!,
        isFromStopLoss: selectedOrderType.value.id == "stopLoss",
        marketPrice: selectedOrderType.value.id == "stopLoss"
            ? isFromBuy
                ? selectedScript.value!.ask!.toDouble()
                : selectedScript.value!.bid!.toDouble()
            : selectedOrderType.value.id == "limit"
                ? getLimitPrice(double.parse(priceController.text), isFromBuy)
                : isFromBuy
                    ? selectedScript.value!.ask!.toDouble()
                    : selectedScript.value!.bid!.toDouble(),
        orderType: selectedOrderType.value.id == "123" ||
                (selectedOrderType.value.id == "limit" &&
                    isFromLimitCheck(
                            double.parse(priceController.text), isFromBuy) ==
                        false)
            ? "market"
            : selectedOrderType.value.id,
        tradeType: isFromBuy ? "buy" : "sell",
        productType:
            selectedOrderType.value.id == "123" ? "intraday" : "longTerm",
        refPrice: isFromBuy
            ? selectedScript.value!.ask!.toDouble()
            : selectedScript.value!.bid!.toDouble(),
      );

      //longterm
      isTradeCallFinished.value = false;
      update();
      if (response != null) {
        // Get.back();
        selectedOrderType.value =
            arrOrderType.firstWhere((element) => element.id == "market");
        if (response.statusCode == 200) {
          // bool isPositionAvailable = Get.isRegistered<PositionController>();
          // bool isTradeAvailable = Get.isRegistered<TradeListController>();
          // bool isSuccessTradeAvailable = Get.isRegistered<SuccessTradeListController>();
          // if (isSuccessTradeAvailable) {
          //   Get.find<SuccessTradeListController>().getTradeList();
          // }
          // if (isTradeAvailable) {
          //   Get.find<TradeListController>().getTradeList();
          // }
          // if (isPositionAvailable) {
          //   var positionVC = Get.find<PositionController>();

          //   positionVC.arrPositionScriptList.clear();
          //   positionVC.currentPage = 1;
          //   positionVC.getPositionList("", isFromClear: true, isFromfilter: true);
          // }

          showSuccessToast(response.meta!.message!,
              bgColor:
                  isFromBuy ? AppColors().blueColor : AppColors().redColor);
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

  getUserTabList() async {
    var response = await service.getUserTabListCall();
    if (response != null) {
      if (response.statusCode == 200) {
        arrTabList = response.data ?? [];
        if (arrTabList.isNotEmpty) {
          await dbSerivice.initDatabase(arrTabList.length);
          arrCurrentWatchListOrder.addAll(
              await dbSerivice.readScripts((selectedPortfolio + 1).toString()));
          selectedTab = arrTabList[0];
          getSymbolListTabWise();
        }
        update();
      }
    }
  }

  getSymbolListTabWise() async {
    arrScript.clear();
    arrPreScript.clear();
    isSymbolListApiCall = true;
    update();
    var response =
        await service.getAllSymbolTabWiseListCall(selectedTab!.userTabId!);
    isSymbolListApiCall = false;
    update();
    if (response?.statusCode == 200) {
      var arrTemp = [];
      arrSymbol = response!.data!.toSet().toList();
      for (int i = 0; i < arrCurrentWatchListOrder.length; i++) {
        arrScript.add(ScriptData());
        arrPreScript.add(ScriptData());
      }
      try {
        for (int i = 0; i < arrSymbol.length; i++) {
          var index = arrCurrentWatchListOrder.indexWhere(
              (it) => it.values.toList().last == arrSymbol[i].symbol);
          if (index != -1) {
            // arrScript[index] = (ScriptData.fromJson(arrSymbol[i].toJson()));
            // arrPreScript[index] = (ScriptData.fromJson(arrSymbol[i].toJson()));
            arrPreScript.removeAt(index);
            arrPreScript.insert(
                index, (ScriptData.fromJson(arrSymbol[i].toJson())));
            arrScript.removeAt(index);
            arrScript.insert(
                index, (ScriptData.fromJson(arrSymbol[i].toJson())));
          } else {
            var position = arrCurrentWatchListOrder.length;
            Map<String, dynamic> newItem = {
              position.toString(): arrSymbol[i].symbol
            };
            if (position == 0) {
              arrCurrentWatchListOrder = [newItem];
            } else {
              arrCurrentWatchListOrder.add(newItem);
            }
            dbSerivice.addScript((selectedPortfolio + 1).toString(),
                arrSymbol[i].symbol!, position);
            arrScript.add(ScriptData.fromJson(arrSymbol[i].toJson()));
            arrPreScript.add(ScriptData.fromJson(arrSymbol[i].toJson()));
          }
        }
        storeScripsInDB();
        update();
      } catch (e) {
        print(e);
      }
      for (var element in response.data!) {
        if (!arrSymbolNames.contains(element.symbolName)) {
          arrTemp.insert(0, element.symbolName);
          arrSymbolNames.insert(0, element.symbolName!);
        }
      }
      var txt = {"symbols": arrSymbolNames};

      update();
      if (arrSymbolNames.isNotEmpty) {
        socket.connectScript(jsonEncode(txt));
      }
    }
  }

  listenScriptFromSocket(GetScriptFromSocket socketData) {
    try {
      if (socketData.status == true) {
        if (isScriptApiGoing == false) {
          if (selectedScriptForF5.value?.symbol != null) {
            if (selectedScriptForF5.value!.symbol == socketData.data!.symbol ||
                selectedScriptForF5.value!.name == socketData.data!.symbol) {
              selectedScriptForF5.value = socketData.data!;
              selectedScriptForF5.value!.copyObject(socketData.data!);
              // print(selectedScriptForF5.value!.ask);
              // selectedScriptForF5 = null.obs;
              // selectedScriptForF5.value = ScriptData.fromJson(tempObj.toJson());
              // selectedScriptForF5.value!.lut = DateTime.now();
              selectedScriptForF5.value!.copyObject(socketData.data!);
              // print(selectedScriptForF5.value!.ask);
            }
          }
        }
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
        // print(arrLtpUpdate.length);
        var obj = arrScript.firstWhereOrNull(
            (element) => socketData.data!.symbol == element.symbol);

        if (obj?.symbol == selectedScript.value?.symbol) {
          selectedScript.value = socketData.data!;

          selectedScript.value!.copyObject(socketData.data!);
        }
        // log("*******************");
        // log(obj!.symbol!.toString());
        // log("*******************");
        if (obj != null) {
          var index = arrScript.indexOf(obj);
          var preIndex = arrPreScript
              .indexWhere((element) => element.symbol == obj.symbol);
          arrPreScript.removeAt(preIndex);
          arrPreScript.insert(preIndex, arrScript[index]);

          arrScript[index] = socketData.data!;
          arrScript[index].lut = DateTime.now();
          var symbolObj = arrSymbol.firstWhereOrNull(
              (element) => element.symbol == arrScript[index].symbol);
          if (symbolObj != null) {
            arrScript[index].strikePrice = symbolObj.strikePrice;
            arrScript[index].instrumentType = symbolObj.instrumentType;
            update();
          }
        }
        //else {
        //   var obj = arrSymbol.firstWhereOrNull((element) => socketData.data!.symbol == element.symbolName);
        //   if (obj != null) {
        //     arrScript.add(socketData.data!);
        //     arrPreScript.add(socketData.data!);
        //   }
        // }

        if (isBuyOpen != -1) {
          if (selectedOrderType.value.name == "Market" ||
              selectedOrderType.value.name == "Intraday") {
            if (arrScript[selectedScriptIndex].symbol ==
                socketData.data?.symbol) {
              // if (userData?.role == UserRollList.user) {
              //   priceController.text = isBuyOpen == 1 ? socketData.data!.ask.toString() : socketData.data!.bid.toString();
              // }
              // if (userData?.role != UserRollList.superAdmin) {
              priceController.text = isBuyOpen == 1
                  ? socketData.data!.ask.toString()
                  : socketData.data!.bid.toString();
              // }
            }
          }
        }

        // update();
      }
    } catch (e) {
      //print(e);
    }
  }

  deleteSymbolFromTab(String tabSymbolId) async {
    var response = await service.deleteSymbolFromTabCall(tabSymbolId);
    if (response?.statusCode == 200) {
      isFilterClicked = 0;
      // showSuccessToast(response?.meta?.message ?? "");
      isAddDeleteApiLoading = false;
      var symbolNmae = "";

      arrSymbol.removeWhere((element) {
        if (element.userTabSymbolId == tabSymbolId) {
          symbolNmae = element.symbolName!;

          return true;
        } else {
          return false;
        }
      });
      var tempIndex =
          arrScript.indexWhere((element) => element.symbol == symbolNmae);
      if (tempIndex != -1) {
        arrScript.removeAt(tempIndex);
        arrPreScript.removeAt(tempIndex);
        if (tempIndex == selectedScriptIndex) {
          if (selectedScriptIndex == arrScript.length) {
            if (arrScript.length > 0) {
              selectedScriptIndex = selectedScriptIndex - 1;
            } else {
              selectedScriptIndex = -1;
            }
          }
          // selectedScriptIndex = -1; //selectedScriptIndex - 1;
          // selectedScriptIndex = selectedScriptIndex + 1;
        }
      }
      storeScripsInDB();
      update();
      // await getSymbolListTabWise();
    }
  }

  Future<List<GlobalSymbolData>> getSymbolListByKeyword(String text) async {
    arrSearchedScript.clear();
    update();
    if (text != "") {
      var response = await service.allSymbolListCallForMarket(1, text, "");
      arrSearchedScript = response!.data ?? [];

      return arrSearchedScript;
    } else {
      return [];
    }
  }

  getselectedSymbolDetailFromF5PopUp(String symbolId) async {
    var response = await service.getSymbolDetailCall(symbolId);
    if (response?.statusCode == 200) {
      print(response!.data!.name);
      var arrTemp = [];
      var newObj = ScriptData.fromJson(response.data!.toJson());

      selectedScriptForF5.value!.copyObject(newObj);
      selectedScriptForF5.value!.lut = DateTime.now();

      arrTemp.add(response.data!.name!);
      var txt = {"symbols": arrTemp};
      socket.connectScript(jsonEncode(txt));
      update();
    }
  }

  addSymbolToTab(String symbolId) async {
    print(symbolId);
    var response = await service.addSymbolToTabCall(
        selectedTab!.userTabId!.toString(), symbolId);
    try {
      if (response?.statusCode == 200) {
        // showSuccessToast(response?.meta?.message ?? "");
        isAddDeleteApiLoading = false;

        arrSymbol.insert(0, response!.data!);
        if (selectedScriptIndex == arrScript.length - 1) {
          arrScript.add(ScriptData.fromJson(response.data!.toJson()));
          arrPreScript.add(ScriptData.fromJson(response.data!.toJson()));
        } else {
          if (selectedScriptIndex != -1 &&
              selectedScriptIndex < arrScript.length) {
            if (selectedScriptIndex == 0) {
              if (arrScript[selectedScriptIndex + 1].symbol!.isEmpty) {
                arrScript[selectedScriptIndex + 1] =
                    ScriptData.fromJson(response.data!.toJson());
                arrPreScript[selectedScriptIndex + 1] =
                    ScriptData.fromJson(response.data!.toJson());
              } else {
                arrScript.insert(selectedScriptIndex + 1,
                    ScriptData.fromJson(response.data!.toJson()));
                arrPreScript.insert(selectedScriptIndex + 1,
                    ScriptData.fromJson(response.data!.toJson()));
              }
            } else if (arrScript[selectedScriptIndex - 1].symbol!.isEmpty) {
              arrScript[selectedScriptIndex - 1] =
                  ScriptData.fromJson(response.data!.toJson());
              arrPreScript[selectedScriptIndex - 1] =
                  ScriptData.fromJson(response.data!.toJson());
            } else if (arrScript[selectedScriptIndex + 1].symbol!.isEmpty) {
              arrScript[selectedScriptIndex + 1] =
                  ScriptData.fromJson(response.data!.toJson());
              arrPreScript[selectedScriptIndex + 1] =
                  ScriptData.fromJson(response.data!.toJson());
            } else {
              arrScript.insert(selectedScriptIndex + 1,
                  ScriptData.fromJson(response.data!.toJson()));
              arrPreScript.insert(selectedScriptIndex + 1,
                  ScriptData.fromJson(response.data!.toJson()));
            }
          } else {
            arrScript.add(ScriptData.fromJson(response.data!.toJson()));
            arrPreScript.add(ScriptData.fromJson(response.data!.toJson()));
          }
        }
        // isMarketSocketConnected.value ? 'Disconnect' : 'Connect'
        storeScripsInDB();
        isFilterClicked = 0;
        var arrTemp = [];
        tempFocus.value.requestFocus();
        arrTemp.add(response.data!.symbolName!);
        arrSymbolNames.insert(0, response.data!.symbolName!);
        var txt = {"symbols": arrSymbolNames};

        socket.connectScript(jsonEncode(txt));
        update();
      } else {
        showErrorToast(response?.message ?? "");
      }
    } catch (e) {
      print(e);
    }
  }

  storeScripsInDB() {
    Future.delayed(const Duration(milliseconds: 100), () {
      arrCurrentWatchListOrder.clear();
      for (int i = 0; i < arrScript.length; i++) {
        Map<String, dynamic> newItem = {i.toString(): arrScript[i].symbol};
        arrCurrentWatchListOrder.add(newItem);
      }
      dbSerivice.bulkUpdate(
          (selectedPortfolio + 1).toString(), arrCurrentWatchListOrder);
    });
  }

  adminBuySellPopupDialog(
      {bool isFromBuy = true, Function? CancelClick, Function? DeleteClick}) {
    selectedUser = UserData().obs;

    showDialog<String>(
        context: Get.context!,
        barrierDismissible: false,
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
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent),
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
                              const SizedBox(
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
                              const SizedBox(
                                width: 10,
                              ),

                              Text(
                                isFromBuy ? "Buy Order" : "Sell Order",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isFromBuy
                                      ? AppColors().blueColor
                                      : AppColors().redColor,
                                  fontFamily: CustomFonts.family1Medium,
                                ),
                              ),

                              const Spacer(),
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
                                  padding: const EdgeInsets.all(10),
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
                            color: isFromBuy
                                ? AppColors().blueColor
                                : AppColors().redColor,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Client Name",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors().whiteColor,
                                            fontFamily:
                                                CustomFonts.family1Regular,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: IgnorePointer(
                                            ignoring: userData!.role ==
                                                UserRollList.user,
                                            child: userListView(selectedUser),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                          ),
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
                                        orderTypeListDropDown(
                                            isFromAdmin: userData!.role ==
                                                    UserRollList.user
                                                ? false
                                                : true)
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
                                          // margin: const EdgeInsets.symmetric(vertical: 5),
                                          child: CustomTextField(
                                            regex: "[0-9]",
                                            type: '',
                                            focusBorderColor:
                                                AppColors().redColor,
                                            keyBoardType: const TextInputType
                                                .numberWithOptions(
                                                signed: true, decimal: false),
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
                                                if (selectedSymbol
                                                        ?.oddLotTrade ==
                                                    1) {
                                                  var temp = (num.parse(
                                                          qtyController.text) /
                                                      selectedScript
                                                          .value!.ls!);
                                                  lotController.text =
                                                      temp.toStringAsFixed(2);
                                                  isValidQty.value = true;
                                                } else {
                                                  var temp = (num.parse(
                                                          qtyController.text) /
                                                      selectedScript
                                                          .value!.ls!);

                                                  print(temp);
                                                  if ((num.parse(qtyController
                                                              .text) %
                                                          selectedScript
                                                              .value!.ls!) ==
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
                                            roundCorner: 5,
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
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 10),
                                          child:
                                              NumberInputWithIncrementDecrementOwn(
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
                                            autovalidateMode:
                                                AutovalidateMode.disabled,
                                            fractionDigits: 2,
                                            textAlign: TextAlign.left,

                                            initialValue: 1,
                                            incDecFactor: 1,
                                            isInt: true,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily:
                                                  CustomFonts.family1Regular,
                                              color: AppColors().darkText,
                                            ),
                                            numberFieldDecoration:
                                                InputDecoration(
                                              border: InputBorder.none,
                                              fillColor: AppColors().whiteColor,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      bottom: 8, left: 20),
                                            ),

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
                                        // if (userData?.role != UserRollList.superAdmin)
                                        Obx(() {
                                          return Container(
                                            width: 210,
                                            height: 40,
                                            child:
                                                NumberInputWithIncrementDecrementOwn(
                                              incIconSize: 18,
                                              decIconSize: 18,
                                              validator: (value) {
                                                return null;
                                              },
                                              onChanged: (newValue) {},
                                              autovalidateMode:
                                                  AutovalidateMode.disabled,
                                              fractionDigits: 2,
                                              textAlign: TextAlign.left,
                                              enabled: selectedOrderType
                                                          .value.name !=
                                                      "Market" &&
                                                  selectedOrderType
                                                          .value.name !=
                                                      "Intraday",
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
                                                          const EdgeInsets.only(
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
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Exchange",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors().whiteColor,
                                            fontFamily:
                                                CustomFonts.family1Regular,
                                          ),
                                        ),
                                        // exchangeTypeDropDown
                                        //(selectedExchangeFromPopup, isFromPopUp: true)
                                        Container(
                                          width: 210,
                                          height: 40,

                                          decoration: BoxDecoration(
                                              color: AppColors().whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          // margin: EdgeInsets.only(top: 5, bottom: 5),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  selectedSymbol?.exchange ??
                                                      "",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors().darkText,
                                                    fontFamily: CustomFonts
                                                        .family1Regular,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
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

                                          decoration: BoxDecoration(
                                              color: AppColors().whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          // margin: EdgeInsets.only(top: 5, bottom: 5),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  selectedScriptFromPopup
                                                      .value.symbol!,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors().darkText,
                                                    fontFamily: CustomFonts
                                                        .family1Regular,
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
                                        const SizedBox(
                                          height: 18,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 210,
                                                height: 40,
                                                child: CustomButton(
                                                  isEnabled: true,
                                                  shimmerColor:
                                                      AppColors().whiteColor,
                                                  title: "Submit",
                                                  textSize: 16,
                                                  focusKey: SubmitFocus,
                                                  borderColor: isFromBuy
                                                      ? AppColors().redColor
                                                      : AppColors().blueColor,
                                                  focusShadowColor:
                                                      AppColors().whiteColor,
                                                  onPress: () {
                                                    if (userData!.role ==
                                                        UserRollList.user) {
                                                      initiateTrade(isFromBuy);
                                                    } else {
                                                      initiateManualTrade(
                                                          isFromBuy);
                                                    }
                                                  },
                                                  bgColor:
                                                      AppColors().grayLightLine,
                                                  isFilled: true,
                                                  textColor:
                                                      AppColors().darkText,
                                                  isTextCenter: true,
                                                  isLoading: false,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 210,
                                                height: 40,
                                                child: CustomButton(
                                                  isEnabled: true,
                                                  shimmerColor:
                                                      AppColors().whiteColor,
                                                  title: "Cancel",
                                                  borderColor: isFromBuy
                                                      ? AppColors().redColor
                                                      : AppColors().blueColor,
                                                  textSize: 16,
                                                  focusKey: CancelFocus,
                                                  focusShadowColor:
                                                      AppColors().whiteColor,
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

  Widget exchangeTypeDropDown(Rx<ExchangeData> value,
      {bool isFromPopUp = false}) {
    return IgnorePointer(
      ignoring: isFromPopUp,
      child: Obx(() {
        return Container(
            width: isFromPopUp ? 210 : 130,
            height: 40,
            margin: EdgeInsets.symmetric(
                horizontal: isFromPopUp ? 0 : 10, vertical: 10),
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField2<ExchangeData>(
                isExpanded: true,
                // focusNode: exchangeFocus.value,
                // autofocus: true,
                onMenuStateChange: (isOpen) {
                  if (isOpen) {
                    availableOpenDropDown++;
                  } else {
                    availableOpenDropDown--;
                  }
                },
                decoration: commonFocusBorder,
                buttonStyleData: ButtonStyleData(
                  width: 110,
                  height: 40,
                  padding: const EdgeInsets.only(left: 5, right: 5),
                ),
                iconStyleData: IconStyleData(
                  icon: isFromPopUp
                      ? const SizedBox()
                      : Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 20,
                          color: AppColors().fontColor,
                        ),
                ),
                hint: Text(
                  isFromPopUp ? value.value.name ?? "" : "Exchange",
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: CustomFonts.family1Medium,
                    color: AppColors().darkText,
                  ),
                ),
                items: isFromPopUp
                    ? []
                    : arrExchange
                        .map((ExchangeData item) => DropdownItem<ExchangeData>(
                              value: item,
                              height: 30,
                              child: Text(
                                item.name ?? "",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: CustomFonts.family1Medium,
                                  color: AppColors().darkText,
                                ),
                              ),
                            ))
                        .toList(),
                selectedItemBuilder: (context) {
                  return arrExchange
                      .map(
                          (ExchangeData item) => DropdownMenuItem<ExchangeData>(
                                value: item,
                                child: Text(
                                  item.name ?? "",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: CustomFonts.family1Medium,
                                    color: AppColors().darkText,
                                  ),
                                ),
                              ))
                      .toList();
                },
                value: value.value.exchangeId != null ? value.value : null,
                onChanged: (ExchangeData? newSelectedValue) {
                  // setState(() {
                  value.value = newSelectedValue!;
                  selectedSymbolForTopDropDown.value = GlobalSymbolData();
                  //focusNode.requestFocus();
                  update();

                  getScriptList();
                  // });
                },
              ),
            ));
      }),
    );
  }

  Widget ScriptDropdownFromPopupDropDown(Rx<ScriptData?> value) {
    return IgnorePointer(
      ignoring: true,
      child: Container(
        width: 210,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors().lightOnlyText, width: 1),
            color: AppColors().whiteColor),
        child: Obx(() {
          return Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField2<ScriptData>(
                isExpanded: true,
                onMenuStateChange: (isOpen) {
                  if (isOpen) {
                    availableOpenDropDown++;
                  } else {
                    availableOpenDropDown--;
                  }
                },
                iconStyleData: const IconStyleData(
                  icon: Padding(
                    padding: EdgeInsets.only(right: 10),
                    // child: Image.asset(
                    //   AppImages.arrowDown,
                    //   height: 20,
                    //   width: 20,
                    //   color: AppColors().fontColor,
                    // ),
                  ),
                ),
                dropdownStyleData: const DropdownStyleData(maxHeight: 150),
                hint: Text(
                  selectedSymbol?.symbolName ?? "",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: CustomFonts.family1Medium,
                    color: AppColors().darkText,
                  ),
                ),
                items: [],
                // items: arrScript
                //     .map((ScriptData item) => DropdownMenuItem<ScriptData>(
                //           value: item,
                //           child: Text(
                //             item.symbol ?? "",
                //             style: TextStyle(
                //               fontSize: 12,
                //               fontFamily: CustomFonts.family1Medium,
                //               color: AppColors().darkText,
                //             ),
                //           ),
                //         ))
                //     .toList(),
                selectedItemBuilder: (context) {
                  return arrScript
                      .map((ScriptData item) => DropdownMenuItem<ScriptData>(
                            value: item,
                            child: Text(
                              item.symbol ?? "",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: CustomFonts.family1Medium,
                                color: AppColors().darkText,
                              ),
                            ),
                          ))
                      .toList();
                },
                value: value.value!.symbol == null ? null : value.value,
                onChanged: (ScriptData? newSelectedValue) {
                  // setState(() {
                  value.value = newSelectedValue;
                  // focusNode.requestFocus();
                  selectedScriptIndex = arrScript.indexWhere(
                      (element) => element.symbol == newSelectedValue?.symbol);
                  var obj = arrSymbol.firstWhereOrNull((element) =>
                      arrScript[selectedScriptIndex].symbol ==
                      element.symbolName);
                  var exchangeObj = arrExchange.firstWhereOrNull(
                      (element) => element.exchangeId == obj!.exchangeId!);
                  if (exchangeObj != null) {
                    selectedExchangeFromPopup.value = exchangeObj;
                  }
                  qtyController.text = obj!.lotSize!.toString();

                  priceController.text =
                      arrScript[selectedScriptIndex].bid!.toString();

                  selectedScriptFromPopup.value =
                      arrScript[selectedScriptIndex];
                  update();
                  // });
                },
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  height: 40,
                  // width: 140,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget allScriptListDropDown() {
    return Container(
        width: 180,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<GlobalSymbolData>(
              isExpanded: true,
              decoration: commonFocusBorder,
              iconStyleData: IconStyleData(
                icon: isScriptApiGoing
                    ? Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 15,
                        height: 15,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors().darkText,
                          ),
                        ),
                      )
                    : Container(
                        // margin: const EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 20,
                          color: AppColors().fontColor,
                        ),
                        // child: Image.asset(
                        //   AppImages.arrowDown,
                        //   height: 20,
                        //   width: 20,
                        //   color: AppColors().fontColor,
                        // ),
                      ),
              ),
              dropdownSearchData: DropdownSearchData(
                searchController: textEditingController,
                searchBarWidgetHeight: 50,
                searchBarWidget: Container(
                  height: 40,
                  // padding: EdgeInsets.only(top: 2.w, right: 2.w, left: 2.w),
                  child: CustomTextField(
                    type: '',
                    keyBoardType: TextInputType.text,
                    isEnabled: true,
                    isOptional: false,
                    inValidMsg: "",
                    placeHolderMsg: "Search Script",
                    emptyFieldMsg: "",
                    controller: textEditingController,
                    focus: textEditingFocus,
                    isSecure: false,
                    borderColor: AppColors().grayLightLine,
                    keyboardButtonType: TextInputAction.done,
                    maxLength: 64,
                    prefixIcon: Image.asset(
                      AppImages.searchIcon,
                      height: 20,
                      width: 20,
                    ),
                    suffixIcon: Container(
                      child: GestureDetector(
                        onTap: () {
                          textEditingController.clear();
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
                  return item.value!.symbolTitle
                      .toString()
                      .toLowerCase()
                      .startsWith(searchValue.toLowerCase());
                },
              ),
              onMenuStateChange: (isOpen) {
                if (isOpen) {
                  availableOpenDropDown++;
                } else {
                  availableOpenDropDown--;
                }
              },
              dropdownStyleData: const DropdownStyleData(maxHeight: 250),
              hint: Text(
                'Script',
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().darkText,
                ),
              ),
              items: arrAllScript
                  .map((GlobalSymbolData item) =>
                      DropdownItem<GlobalSymbolData>(
                        value: item,
                        height: 30,
                        child:
                            StatefulBuilder(builder: (context, menuSetState) {
                          return IgnorePointer(
                            ignoring: selectedExchange.value.isCallPut,
                            child: GestureDetector(
                              onTap: () async {
                                // focusNode.requestFocus();
                                menuSetState(() {
                                  item.isApiCallRunning = true;
                                });

                                if (selectedExchange.value.isCallPut) {
                                  selectedSymbolForTopDropDown.value = item;
                                  selectedExpiry.value = expiryData();

                                  arrExpiry.clear();
                                  selectedCallPut.value = Type();
                                  selectedStrikePrice.value = StrikePriceData();
                                  arrStrikePrice.clear();
                                  update();
                                  getExpiryListForTop();
                                } else {
                                  var temp = arrSymbol.firstWhereOrNull(
                                      (element) =>
                                          item.symbolId == element.symbolId);
                                  if (temp != null) {
                                    await deleteSymbolFromTab(
                                        temp.userTabSymbolId!);
                                  } else {
                                    await addSymbolToTab(
                                        item.symbolId.toString());
                                  }
                                }

                                menuSetState(() {
                                  item.isApiCallRunning = false;
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    Center(
                                      child: Text(item.symbolTitle ?? "",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontFamily:
                                                  CustomFonts.family1Medium,
                                              color: AppColors().borderColor)),
                                    ),
                                    const Spacer(),
                                    if (selectedExchange.value.isCallPut ==
                                        false)
                                      item.isApiCallRunning
                                          ? SizedBox(
                                              width: 15,
                                              height: 15,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: AppColors().blueColor,
                                              ))
                                          : arrSymbol.firstWhereOrNull(
                                                      (element) =>
                                                          element.symbolId ==
                                                          item.symbolId) !=
                                                  null
                                              ? Icon(
                                                  Icons.check_box,
                                                  color: AppColors().blueColor,
                                                  size: 18,
                                                )
                                              : Icon(
                                                  Icons.check_box_outline_blank,
                                                  color: AppColors().lightText,
                                                  size: 18,
                                                )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return arrAllScript
                    .map((GlobalSymbolData item) => DropdownMenuItem<String>(
                          value: item.symbolTitle,
                          child: Text(
                            item.symbolTitle ?? "",
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: CustomFonts.family1Medium,
                              color: AppColors().darkText,
                            ),
                          ),
                        ))
                    .toList();
              },
              value: selectedExchange.value.isCallPut
                  ? selectedSymbolForTopDropDown.value?.symbolId != null
                      ? selectedSymbolForTopDropDown.value!
                      : null
                  : null,
              onChanged: (GlobalSymbolData? value) {
                // // setState(() {
                // controller.selectedScriptFromAll = value;
                // controller.update();
                // // });
                // focusNode.requestFocus();
                var temp = arrSymbol.firstWhereOrNull(
                    (element) => value!.symbolId == element.symbolId);
                if (selectedExchange.value.isCallPut) {
                  selectedSymbolForTopDropDown.value = value!;

                  selectedExpiry.value = expiryData();

                  arrExpiry.clear();
                  selectedCallPut.value = Type();
                  selectedStrikePrice.value = StrikePriceData();
                  arrStrikePrice.clear();
                  update();
                  getExpiryListForTop();
                } else {
                  if (temp != null) {
                    deleteSymbolFromTab(temp.userTabSymbolId!);
                  } else {
                    addSymbolToTab(value!.symbolId.toString());
                  }
                  selectedSymbolForTopDropDown.value = GlobalSymbolData();
                }
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 5),
                height: 40,
                width: 165,
              ),
            ),
          ),
        ));
  }

  Widget orderTypeListDropDown({bool isFromAdmin = false}) {
    return Obx(() {
      return IgnorePointer(
        ignoring:
            false, //userData!.role == UserRollList.superAdmin ? false : isFromAdmin,
        child: Container(
            width: 210,
            height: 30,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            // decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1), color: AppColors().whiteColor),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField2<Type>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.only(left: 0),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: isBuyOpen == 2
                                ? AppColors().blueColor
                                : AppColors().redColor,
                            width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors().lightOnlyText, width: 1)),
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
                      .map((Type item) => DropdownItem<Type>(
                            value: item,
                            height: 30,
                            alignment: AlignmentDirectional.centerStart,
                            child: StatefulBuilder(
                                builder: (context, menuSetState) {
                              return Container(
                                color: Colors.transparent,
                                child: Text(item.name ?? "",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: CustomFonts.family1Medium,
                                        color: AppColors().grayColor)),
                              );
                            }),
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
                    update();

                    // focusNode.requestFocus();
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    height: 40,
                    width: 190,
                  ),
                  // menuItemStyleData: const MenuItemStyleData(
                  //   height: 40,
                  // ),
                ),
              ),
            )),
      );
    });
  }

  Widget validityListDropDown() {
    return Obx(() {
      return selectedOrderType.value.name != "Market"
          ? const SizedBox()
          : Column(
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
                    margin: const EdgeInsets.symmetric(vertical: 5),
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
                                fontSize: 12,
                                fontFamily: CustomFonts.family1Medium,
                                color: AppColors().darkText,
                              ),
                            ),
                            items: arrValidaty
                                .map((Type item) => DropdownMenuItem<Type>(
                                      value: item,
                                      child: Text(item.name ?? "",
                                          style: TextStyle(
                                              fontSize: 12,
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
                                            fontSize: 12,
                                            fontFamily:
                                                CustomFonts.family1Medium,
                                            color: AppColors().darkText,
                                          ),
                                        ),
                                      ))
                                  .toList();
                            },
                            decoration: commonFocusBorder,
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
            );
    });
  }

  Widget userListView(Rx<UserData> selectedUser,
      {double? width, int isFromBS = 0}) {
    return Container(
        // height: 40.h,
        width: 210,
        height: 37,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors().bgColor,
            boxShadow: [
              BoxShadow(
                color: AppColors().fontColor.withOpacity(0.2),
                offset: Offset.zero,
                spreadRadius: 2,
                blurRadius: 7,
              ),
            ]),
        child: Container(
          width: 200,
          // height: 4.h,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent, width: 1),
              borderRadius: BorderRadius.circular(3)),
          child: Autocomplete<UserData>(
            displayStringForOption: (UserData option) => option.userName!,
            fieldViewBuilder: (BuildContext context,
                TextEditingController searchEditingController,
                FocusNode searchFocus,
                VoidCallback onFieldSubmitted) {
              return CustomTextField(
                type: 'Search User',
                keyBoardType: TextInputType.text,
                isEnabled: true,
                isOptional: false,
                inValidMsg: "",
                placeHolderMsg: userData!.role == UserRollList.user
                    ? userData!.userName!
                    : "Search User",
                emptyFieldMsg: "",
                // fontStyle: TextStyle(
                //   fontSize: 10,
                //   fontFamily: CustomFonts.family1Medium,
                //   color: AppColors().darkText,
                // ),
                controller: searchEditingController,
                focus: searchFocus,
                // focusBorderColor: AppColors().blueColor,
                isSecure: false,
                borderColor: Colors.transparent,
                keyboardButtonType: TextInputAction.search,
                maxLength: 64,
                focusBorderColor: Colors.transparent,
                isShowPrefix: false,
                isShowSufix: false,
                onTap: () {
                  searchFocus.requestFocus();
                },
              );
            },
            optionsViewBuilder: (context, onSelected, options) => Align(
              alignment: Alignment.topLeft,
              child: Material(
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(4.0)),
                ),
                child: Container(
                  height: 70,
                  width: 200, // <-- Right here !
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    shrinkWrap: false,
                    itemBuilder: (BuildContext context, int index) {
                      final String option =
                          arrUserListOnlyClient.elementAt(index).userName!;
                      return InkWell(
                        onTap: () =>
                            onSelected(arrUserListOnlyClient.elementAt(index)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: CustomFonts.family1Medium,
                              color: AppColors().darkText,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            optionsMaxHeight: 150,
            optionsBuilder: (TextEditingValue textEditingValue) async {
              if (textEditingValue.text == '') {
                return const Iterable<UserData>.empty();
              }
              if (textEditingValue.text.length > 2) {
                return await getUserList(
                    textEditingValue.text, UserRollList.user);
              } else {
                return const Iterable<UserData>.empty();
              }
            },
            onSelected: (UserData selection) {
              debugPrint('You just selected $selection');
              selectedUser.value = selection;
              // controller.addSymbolToTab(selection.symbolId!);
            },
          ),
        ));
  }

  Widget searchuserView(Rx<UserData> selectedUser,
      {double? width, int isFromBS = 0}) {
    return Container(
        // height: 40.h,
        width: 210,
        height: 37,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors().bgColor,
            boxShadow: [
              BoxShadow(
                color: AppColors().fontColor.withOpacity(0.2),
                offset: Offset.zero,
                spreadRadius: 2,
                blurRadius: 7,
              ),
            ]),
        child: Container(
          width: 200,
          // height: 4.h,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent, width: 1),
              borderRadius: BorderRadius.circular(3)),
          child: Autocomplete<UserData>(
            displayStringForOption: (UserData option) => option.userName!,
            fieldViewBuilder: (BuildContext context,
                TextEditingController searchEditingController,
                FocusNode searchFocus,
                VoidCallback onFieldSubmitted) {
              return CustomTextField(
                type: 'Search User',
                keyBoardType: TextInputType.text,
                isEnabled: true,
                isOptional: false,
                inValidMsg: "",
                placeHolderMsg: "Search User",
                emptyFieldMsg: "",
                // fontStyle: TextStyle(
                //   fontSize: 10,
                //   fontFamily: CustomFonts.family1Medium,
                //   color: AppColors().darkText,
                // ),
                controller: searchEditingController,
                focus: searchFocus,
                // focusBorderColor: AppColors().blueColor,
                isSecure: false,
                borderColor: Colors.transparent,
                keyboardButtonType: TextInputAction.search,
                maxLength: 64,
                focusBorderColor: Colors.transparent,
                isShowPrefix: false,
                isShowSufix: false,
                onTap: () {
                  searchFocus.requestFocus();
                },
              );
            },
            optionsViewBuilder: (context, onSelected, options) => Align(
              alignment: Alignment.topLeft,
              child: Material(
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(4.0)),
                ),
                child: Container(
                  height: 200,
                  width: 200, // <-- Right here !
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    shrinkWrap: false,
                    itemBuilder: (BuildContext context, int index) {
                      final String option =
                          arrUserListOnlyClient.elementAt(index).userName!;
                      return InkWell(
                        onTap: () =>
                            onSelected(arrUserListOnlyClient.elementAt(index)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: CustomFonts.family1Medium,
                              color: AppColors().darkText,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            optionsMaxHeight: 200,
            optionsBuilder: (TextEditingValue textEditingValue) async {
              if (textEditingValue.text == '') {
                return const Iterable<UserData>.empty();
              }
              if (textEditingValue.text.length > 2) {
                return await getUserList(textEditingValue.text, "");
              } else {
                return const Iterable<UserData>.empty();
              }
            },
            onSelected: (UserData selection) {
              debugPrint('You just selected $selection');
              showUserDetailsPopUp(
                  userId: selection.userId!,
                  userName: selection.userName!,
                  roll: selection.role!);
              // controller.addSymbolToTab(selection.symbolId!);
            },
          ),
        ));
  }

  Widget allScriptListDropDownForF5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("SYMBOL",
            style: TextStyle(
                fontSize: 12,
                fontFamily: CustomFonts.family1Medium,
                color: AppColors().darkText)),
        Container(
            width: 170,
            height: 20,
            margin: const EdgeInsets.only(bottom: 15, top: 5),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField2<GlobalSymbolData>(
                  isExpanded: true,
                  decoration: commonFocusBorder,
                  iconStyleData: IconStyleData(
                    icon: isScriptApiGoing
                        ? Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 15,
                            height: 15,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors().darkText,
                              ),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: Icon(
                              Icons.keyboard_arrow_down_outlined,
                              size: 20,
                              color: AppColors().fontColor,
                            ),
                            // child: Image.asset(
                            //   AppImages.arrowDown,
                            //   height: 20,
                            //   width: 20,
                            //   color: AppColors().fontColor,
                            // ),
                          ),
                  ),
                  dropdownSearchData: DropdownSearchData(
                    searchController: textEditingController,
                    searchBarWidgetHeight: 30,
                    searchBarWidget: Container(
                      height: 30,
                      // padding: EdgeInsets.only(top: 2.w, right: 2.w, left: 2.w),
                      child: CustomTextField(
                        type: '',
                        keyBoardType: TextInputType.text,
                        isEnabled: true,
                        isOptional: false,
                        inValidMsg: "",
                        placeHolderMsg: "Search Script",
                        emptyFieldMsg: "",
                        controller: textEditingController,
                        focus: textEditingFocus,
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
                              textEditingController.clear();
                            },
                            child: Image.asset(
                              AppImages.crossIcon,
                              height: 15,
                              width: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      return item.value!.symbolTitle
                          .toString()
                          .toLowerCase()
                          .startsWith(searchValue.toLowerCase());
                    },
                  ),
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      textEditingController.clear();
                    }
                    if (isOpen) {
                      availableOpenDropDown++;
                    } else {
                      availableOpenDropDown--;
                    }
                  },
                  dropdownStyleData: const DropdownStyleData(maxHeight: 250),
                  hint: Container(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      'Script',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: CustomFonts.family1Medium,
                        color: AppColors().darkText,
                      ),
                    ),
                  ),
                  items: arrAllScriptForF5
                      .map((GlobalSymbolData item) =>
                          DropdownItem<GlobalSymbolData>(
                            value: item,
                            height: 30,
                            alignment: AlignmentDirectional.centerStart,
                            child: StatefulBuilder(
                                builder: (context, menuSetState) {
                              return Container(
                                color: Colors.transparent,
                                child: Text(item.symbolTitle ?? "",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: CustomFonts.family1Medium,
                                        color: AppColors().blueColor)),
                              );
                            }),
                          ))
                      .toList(),
                  selectedItemBuilder: (context) {
                    return arrAllScriptForF5
                        .map(
                            (GlobalSymbolData item) => DropdownMenuItem<String>(
                                  value: item.symbolTitle,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Text(
                                      item.symbolTitle ?? "",
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: CustomFonts.family1Medium,
                                        color: AppColors().darkText,
                                      ),
                                    ),
                                  ),
                                ))
                        .toList();
                  },
                  value: selectedSymbolForF5.value?.symbolId == null
                      ? null
                      : selectedSymbolForF5.value!,
                  onChanged: (GlobalSymbolData? value) {
                    selectedSymbolForF5.value = value!;
                    if (selectedExchangeForF5.value.isCallPut) {
                      arrExpiry.clear();
                      selectedExpiryForF5.value = expiryData();
                      selectedCallPutForF5.value = Type();
                      arrStrikePrice.clear();
                      selectedStrikePriceForF5.value = StrikePriceData();
                      getExpiryList();
                    } else {
                      getselectedSymbolDetailFromF5PopUp(value.symbolId!);
                    }
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    height: 30,
                    width: 160,
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget exchangeTypeDropDownForF5(
    Rx<ExchangeData> value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(left: 10),
            child: Text("EXCHANGE",
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: CustomFonts.family1Medium,
                    color: AppColors().darkText))),
        Container(
          width: 80,
          height: 20,
          margin:
              const EdgeInsets.only(top: 5, bottom: 15, left: 10, right: 10),
          child: Obx(() {
            return Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField2<ExchangeData>(
                  isExpanded: true,
                  decoration: commonFocusBorder,
                  onMenuStateChange: (isOpen) {
                    if (isOpen) {
                      availableOpenDropDown++;
                    } else {
                      availableOpenDropDown--;
                    }
                  },
                  iconStyleData: IconStyleData(
                    icon: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 20,
                          color: AppColors().fontColor,
                        )),
                  ),
                  hint: Text(
                    "Exchange",
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: CustomFonts.family1Medium,
                      color: AppColors().darkText,
                    ),
                  ),
                  items: arrExchange
                      .map((ExchangeData item) => DropdownItem<ExchangeData>(
                            value: item,
                            height: 25,
                            child: Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text(
                                item.name ?? "",
                                style: TextStyle(
                                  fontSize: 10,
                                  fontFamily: CustomFonts.family1Medium,
                                  color: AppColors().darkText,
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                  selectedItemBuilder: (context) {
                    return arrExchange
                        .map((ExchangeData item) =>
                            DropdownMenuItem<ExchangeData>(
                              value: item,
                              child: Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  item.name ?? "",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: CustomFonts.family1Medium,
                                    color: AppColors().darkText,
                                  ),
                                ),
                              ),
                            ))
                        .toList();
                  },
                  value: value.value.exchangeId != null ? value.value : null,
                  onChanged: (ExchangeData? newSelectedValue) {
                    // setState(() {
                    value.value = newSelectedValue!;
                    //focusNode.requestFocus();
                    update();
                    getScriptList(isFromF5: true);
                    // });
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    height: 40,
                    width: 100,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget expiryTypeDropDownForF5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(left: 10),
            child: Text("EXPIRY",
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: CustomFonts.family1Medium,
                    color: AppColors().darkText))),
        Container(
          width: 100,
          height: 20,
          margin:
              const EdgeInsets.only(top: 5, bottom: 15, left: 10, right: 10),
          child: Obx(() {
            return Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField2<expiryData>(
                  isExpanded: true,
                  decoration: commonFocusBorder,
                  onMenuStateChange: (isOpen) {
                    if (isOpen) {
                      availableOpenDropDown++;
                    } else {
                      availableOpenDropDown--;
                    }
                  },
                  iconStyleData: IconStyleData(
                    icon: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 20,
                          color: AppColors().fontColor,
                        )),
                  ),
                  hint: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "",
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: CustomFonts.family1Medium,
                        color: AppColors().darkText,
                      ),
                    ),
                  ),
                  items: arrExpiry
                      .map((expiryData item) => DropdownItem<expiryData>(
                            value: item,
                            height: 30,
                            child: Text(
                              shortDate(item.expiryDate!),
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: CustomFonts.family1Medium,
                                color: AppColors().darkText,
                              ),
                            ),
                          ))
                      .toList(),
                  selectedItemBuilder: (context) {
                    return arrExpiry
                        .map((expiryData item) => DropdownMenuItem<expiryData>(
                              value: item,
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  shortDate(item.expiryDate!),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: CustomFonts.family1Medium,
                                    color: AppColors().darkText,
                                  ),
                                ),
                              ),
                            ))
                        .toList();
                  },
                  value: selectedExpiryForF5.value.name == null
                      ? null
                      : selectedExpiryForF5.value,
                  onChanged: (expiryData? newSelectedValue) {
                    // });
                    selectedExpiryForF5.value = newSelectedValue!;
                    selectedCallPutForF5.value = Type();
                    arrStrikePrice.clear();
                    selectedStrikePriceForF5.value = StrikePriceData();
                    update();
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    height: 40,
                    width: 120,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget callPutTypeDropDownForF5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("CE/PE",
            style: TextStyle(
                fontSize: 12,
                fontFamily: CustomFonts.family1Medium,
                color: AppColors().darkText)),
        Container(
          width: 65,
          height: 20,
          margin: const EdgeInsets.only(top: 5, bottom: 15),
          child: Obx(() {
            return Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField2<Type>(
                  isExpanded: true,
                  decoration: commonFocusBorder,
                  onMenuStateChange: (isOpen) {
                    if (isOpen) {
                      availableOpenDropDown++;
                    } else {
                      availableOpenDropDown--;
                    }
                  },
                  iconStyleData: IconStyleData(
                    icon: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          size: 20,
                          color: AppColors().fontColor,
                        )),
                  ),
                  hint: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "",
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: CustomFonts.family1Medium,
                        color: AppColors().darkText,
                      ),
                    ),
                  ),
                  items: constantValues!.instrumentType!
                      .map((Type item) => DropdownItem<Type>(
                            value: item,
                            height: 30,
                            child: Text(
                              item.name ?? "",
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: CustomFonts.family1Medium,
                                color: AppColors().darkText,
                              ),
                            ),
                          ))
                      .toList(),
                  selectedItemBuilder: (context) {
                    return constantValues!.instrumentType!
                        .map((Type item) => DropdownMenuItem<Type>(
                              value: item,
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  item.name ?? "",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: CustomFonts.family1Medium,
                                    color: AppColors().darkText,
                                  ),
                                ),
                              ),
                            ))
                        .toList();
                  },
                  value: selectedCallPutForF5.value.id == null
                      ? null
                      : selectedCallPutForF5.value,
                  onChanged: (Type? newSelectedValue) {
                    // });
                    selectedCallPutForF5.value = newSelectedValue!;
                    arrStrikePrice.clear();
                    selectedStrikePriceForF5.value = StrikePriceData();
                    update();
                    getStrikePriceList();
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    height: 30,
                    width: 130,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget strikePriceTypeDropDownForF5() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(left: 10),
            child: Text("Strike Price",
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: CustomFonts.family1Medium,
                    color: AppColors().darkText))),
        Container(
            width: 120,
            height: 20,
            margin:
                const EdgeInsets.only(top: 5, bottom: 15, left: 10, right: 10),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField2<StrikePriceData>(
                  isExpanded: true,
                  decoration: commonFocusBorder,
                  iconStyleData: IconStyleData(
                    icon: Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 20,
                        color: AppColors().fontColor,
                      ),
                    ),
                  ),
                  dropdownSearchData: DropdownSearchData(
                    searchController: textEditingController,
                    searchBarWidgetHeight: 30,
                    searchBarWidget: Container(
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
                        fontStyle: TextStyle(
                            fontSize: 10,
                            fontFamily: CustomFonts.family1Medium,
                            color: AppColors().fontColor),
                        controller: textEditingController,
                        focus: textEditingFocus,
                        isSecure: false,
                        borderColor: AppColors().grayLightLine,
                        keyboardButtonType: TextInputAction.done,
                        maxLength: 64,
                        // prefixIcon: Image.asset(
                        //   AppImages.searchIcon,
                        //   height: 15,
                        //   width: 15,
                        // ),
                        isShowPrefix: false,
                        suffixIcon: Container(
                          child: GestureDetector(
                            onTap: () {
                              textEditingController.clear();
                            },
                            child: Image.asset(
                              AppImages.crossIcon,
                              height: 15,
                              width: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      return item.value!.strikePrice
                          .toString()
                          .toLowerCase()
                          .startsWith(searchValue.toLowerCase());
                    },
                  ),
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      textEditingController.clear();
                    }
                    if (isOpen) {
                      availableOpenDropDown++;
                    } else {
                      availableOpenDropDown--;
                    }
                  },
                  dropdownStyleData: const DropdownStyleData(maxHeight: 250),
                  hint: Container(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: CustomFonts.family1Medium,
                        color: AppColors().darkText,
                      ),
                    ),
                  ),
                  items: arrStrikePrice
                      .map((StrikePriceData item) =>
                          DropdownItem<StrikePriceData>(
                            value: item,
                            height: 30,
                            alignment: AlignmentDirectional.centerStart,
                            child: StatefulBuilder(
                                builder: (context, menuSetState) {
                              return Container(
                                color: Colors.transparent,
                                child: Text(item.strikePrice!.toString(),
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: CustomFonts.family1Medium,
                                        color: AppColors().blueColor)),
                              );
                            }),
                          ))
                      .toList(),
                  selectedItemBuilder: (context) {
                    return arrStrikePrice
                        .map((StrikePriceData item) =>
                            DropdownMenuItem<StrikePriceData>(
                              value: item,
                              child: Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  item.strikePrice!.toString(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: CustomFonts.family1Medium,
                                    color: AppColors().darkText,
                                  ),
                                ),
                              ),
                            ))
                        .toList();
                  },
                  value: selectedStrikePriceForF5.value.strikePrice == null
                      ? null
                      : selectedStrikePriceForF5.value,
                  onChanged: (StrikePriceData? value) {
                    selectedStrikePriceForF5.value = value!;
                    getselectedSymbolDetailFromF5PopUp(value.symbolId!);
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    height: 30,
                    width: 160,
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget expiryTypeDropDown() {
    return Container(
      width: 100,
      height: 35,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Obx(() {
        return Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<expiryData>(
              isExpanded: true,
              decoration: commonFocusBorder,
              onMenuStateChange: (isOpen) {
                if (isOpen) {
                  availableOpenDropDown++;
                } else {
                  availableOpenDropDown--;
                }
              },
              iconStyleData: IconStyleData(
                icon: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      size: 20,
                      color: AppColors().fontColor,
                    )),
              ),
              hint: Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Expiry",
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: CustomFonts.family1Medium,
                    color: AppColors().darkText,
                  ),
                ),
              ),
              items: arrExpiry
                  .map((expiryData item) => DropdownItem<expiryData>(
                        value: item,
                        height: 30,
                        child: Text(
                          shortDate(item.expiryDate!),
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: CustomFonts.family1Medium,
                            color: AppColors().darkText,
                          ),
                        ),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return arrExpiry
                    .map((expiryData item) => DropdownMenuItem<expiryData>(
                          value: item,
                          child: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              shortDate(item.expiryDate!),
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: CustomFonts.family1Medium,
                                color: AppColors().darkText,
                              ),
                            ),
                          ),
                        ))
                    .toList();
              },
              value: selectedExpiry.value.name == null
                  ? null
                  : selectedExpiry.value,
              onChanged: (expiryData? newSelectedValue) {
                // });
                selectedExpiry.value = newSelectedValue!;
                selectedCallPut.value = Type();
                arrStrikePrice.clear();
                selectedStrikePrice.value = StrikePriceData();
                update();
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 40,
                width: 120,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget callPutTypeDropDown() {
    return Container(
      width: 70,
      height: 35,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Obx(() {
        return Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField2<Type>(
              isExpanded: true,
              decoration: commonFocusBorder,
              onMenuStateChange: (isOpen) {
                if (isOpen) {
                  availableOpenDropDown++;
                } else {
                  availableOpenDropDown--;
                }
              },
              iconStyleData: IconStyleData(
                icon: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      size: 20,
                      color: AppColors().fontColor,
                    )),
              ),
              hint: Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "CE/PE",
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: CustomFonts.family1Medium,
                    color: AppColors().darkText,
                  ),
                ),
              ),
              items: constantValues!.instrumentType!
                  .map((Type item) => DropdownItem<Type>(
                        value: item,
                        height: 30,
                        child: Text(
                          item.name ?? "",
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: CustomFonts.family1Medium,
                            color: AppColors().darkText,
                          ),
                        ),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return constantValues!.instrumentType!
                    .map((Type item) => DropdownMenuItem<Type>(
                          value: item,
                          child: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              item.name ?? "",
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: CustomFonts.family1Medium,
                                color: AppColors().darkText,
                              ),
                            ),
                          ),
                        ))
                    .toList();
              },
              value: selectedCallPut.value.id == null
                  ? null
                  : selectedCallPut.value,
              onChanged: (Type? newSelectedValue) {
                // });
                selectedCallPut.value = newSelectedValue!;
                arrStrikePrice.clear();
                selectedStrikePrice.value = StrikePriceData();
                update();
                getStrikePriceListForTop();
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 40,
                width: 120,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget strikePriceTypeDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: 120,
            height: 25,
            margin: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField2<StrikePriceData>(
                  isExpanded: true,
                  decoration: commonFocusBorder,
                  iconStyleData: IconStyleData(
                    icon: Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        size: 20,
                        color: AppColors().fontColor,
                      ),
                    ),
                  ),
                  dropdownSearchData: DropdownSearchData(
                    searchController: textEditingController,
                    searchBarWidgetHeight: 30,
                    searchBarWidget: Container(
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
                        fontStyle: TextStyle(
                            fontSize: 10,
                            fontFamily: CustomFonts.family1Medium,
                            color: AppColors().fontColor),
                        controller: textEditingController,
                        focus: textEditingFocus,
                        isSecure: false,
                        borderColor: AppColors().grayLightLine,
                        keyboardButtonType: TextInputAction.done,
                        maxLength: 64,
                        // prefixIcon: Image.asset(
                        //   AppImages.searchIcon,
                        //   height: 15,
                        //   width: 15,
                        // ),
                        isShowPrefix: false,
                        suffixIcon: Container(
                          child: GestureDetector(
                            onTap: () {
                              textEditingController.clear();
                            },
                            child: Image.asset(
                              AppImages.crossIcon,
                              height: 15,
                              width: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                    searchMatchFn: (item, searchValue) {
                      return item.value!.strikePrice
                          .toString()
                          .toLowerCase()
                          .startsWith(searchValue.toLowerCase());
                    },
                  ),
                  onMenuStateChange: (isOpen) {
                    if (!isOpen) {
                      textEditingController.clear();
                    }
                    if (isOpen) {
                      availableOpenDropDown++;
                    } else {
                      availableOpenDropDown--;
                    }
                  },
                  dropdownStyleData: const DropdownStyleData(maxHeight: 250),
                  hint: Container(
                    padding: EdgeInsets.only(left: 5),
                    child: Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: CustomFonts.family1Medium,
                        color: AppColors().darkText,
                      ),
                    ),
                  ),
                  items: arrStrikePrice
                      .map((StrikePriceData item) =>
                          DropdownItem<StrikePriceData>(
                            value: item,
                            height: 30,
                            alignment: AlignmentDirectional.centerStart,
                            child: StatefulBuilder(
                                builder: (context, menuSetState) {
                              return Container(
                                color: Colors.transparent,
                                child: Text(item.strikePrice!.toString(),
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontFamily: CustomFonts.family1Medium,
                                        color: AppColors().blueColor)),
                              );
                            }),
                          ))
                      .toList(),
                  selectedItemBuilder: (context) {
                    return arrStrikePrice
                        .map((StrikePriceData item) =>
                            DropdownMenuItem<StrikePriceData>(
                              value: item,
                              child: Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  item.strikePrice!.toString(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: CustomFonts.family1Medium,
                                    color: AppColors().darkText,
                                  ),
                                ),
                              ),
                            ))
                        .toList();
                  },
                  value: selectedStrikePriceForF5.value.strikePrice == null
                      ? null
                      : selectedStrikePriceForF5.value,
                  onChanged: (StrikePriceData? value) {
                    selectedStrikePrice.value = value!;
                    // getselectedSymbolDetailFromF5PopUp(newSelectedValue.symbolId!);
                    addSymbolToTab(value.symbolId!);
                  },
                  buttonStyleData: const ButtonStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    // height: 30,
                    width: 160,
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
