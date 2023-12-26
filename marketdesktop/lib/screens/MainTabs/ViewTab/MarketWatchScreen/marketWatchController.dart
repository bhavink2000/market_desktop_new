import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:floating_dialog/floating_dialog.dart';
import 'package:marketdesktop/service/database/dbService.dart';
import 'package:web_socket_channel/status.dart' as status;
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
  ScrollController sheetController = ScrollController();
  final debouncer = Debouncer(milliseconds: 300);
  final slowDebouncer = Debouncer(milliseconds: 200);
  bool isKeyPressActive = false;
  List<Type> arrValidaty = [];
  double maxWidth = 0.0;
  int selectedIndexforCut = -1;
  int selectedIndexforUndo = -1;
  int selectedIndexforPaste = -1;

  // FocusNode userListDropDownFocus = FocusNode();
  List<ListItem> arrListTitle = [
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
  List<Map<String, dynamic>> arrCurrentWatchListOrder = [];
  List<List<Map<String, dynamic>>> arrWatchListsOrder = [];

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await dbSerivice.initDatabase();
    arrCurrentWatchListOrder.addAll(await dbSerivice.readScripts((selectedPortfolio + 1).toString()));

    priceController.text = "0.0";
    arrValidaty = constantValues!.productType ?? [];
    // handleKeyEvents();
    arrOrderType = constantValues?.orderType ?? [];
    if (userData!.role == UserRollList.superAdmin) {
      arrOrderType.removeWhere((element) => element.id == "stopLoss");
    } else if (userData!.role == UserRollList.master) {
      arrOrderType.removeWhere((element) => element.id == "stopLoss");
      arrOrderType.removeWhere((element) => element.id == "limit");
    } else if (userData!.role == UserRollList.user) {
      arrOrderType.add(Type(name: "Intraday", id: "123"));
    }
    Future.delayed(const Duration(milliseconds: 100), () async {
      Screen? size = await getCurrentScreen();
      screenSize = Size(size!.frame.width, size!.frame.height);
      maxWidth = size.frame.width > 1410 ? size.frame.width : 1410; //

      selectedOrderType.value = arrOrderType.firstWhere((element) => element.id == "market");
      update();
      getUserList();
      getExchangeList();
      getScriptList();
      getUserTabList();
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

  @override
  void onClose() async {
    // var MainVC = Get.find<MainContainerController>();
    // MainVC.focusNode.requestFocus();

    socket.channel?.sink.close(status.normalClosure);
  }

  getUserList() async {
    var response = await service.getMyUserListCall(roleId: UserRollList.user);
    arrUserListOnlyClient = response!.data ?? [];
    if (arrUserListOnlyClient.isNotEmpty) {
      selectedUser.value = arrUserListOnlyClient.first;
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

  getScriptList({bool isFromF5 = false}) async {
    isScriptApiGoing = true;
    if (isFromF5) {
      arrAllScriptForF5.clear();
      // selectedScriptForF5.value = ScriptData();
    } else {
      arrAllScript.clear();
    }

    update();
    var response = await service.allSymbolListCall(1, "", isFromF5 ? selectedExchangeForF5.value.exchangeId ?? "" : selectedExchange.value.exchangeId ?? "");
    if (isFromF5) {
      arrAllScriptForF5 = response!.data ?? [];
      var temp = arrAllScriptForF5.firstWhereOrNull((element) => element.symbolId == selectedSymbol!.symbolId);
      selectedSymbolForF5.value = temp ?? GlobalSymbolData();

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
    var index = arrListTitle.indexWhere((element) => element.title == name);
    switch (name) {
      case "EXCHANGE":
        switch (arrListTitle[index].sortType) {
          case 0:
          case -1:
            {
              arrListTitle[index].sortType = 1;
              arrScript.sort((a, b) => b.exchange!.compareTo(a.exchange!));

              break;
            }
          case 1:
            {
              arrListTitle[index].sortType = -1;
              arrScript.sort((a, b) => a.exchange!.compareTo(b.exchange!));
              break;
            }
        }
        break;
      case "SYMBOL":
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.symbol!.compareTo(a.symbol!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.symbol!.compareTo(b.symbol!));
                break;
              }
          }

          break;
        }
      case "EXPIRY":
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.expiry!.compareTo(a.expiry!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.expiry!.compareTo(b.expiry!));
                break;
              }
          }

          break;
        }
      case "BUY QTY":
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.tbq!.compareTo(a.tbq!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.tbq!.compareTo(b.tbq!));
                break;
              }
          }

          break;
        }
      case "BUY PRICE":
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.bid!.compareTo(a.bid!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.bid!.compareTo(b.bid!));
                break;
              }
          }

          break;
        }
      case "SELL PRICE":
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.ask!.compareTo(a.ask!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.ask!.compareTo(b.ask!));
                break;
              }
          }

          break;
        }
      case "SELL QTY":
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.tsq!.compareTo(a.tsq!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.tsq!.compareTo(b.tsq!));
                break;
              }
          }

          break;
        }
      case "NET CHANGE":
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.ch!.compareTo(a.ch!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.ch!.compareTo(b.ch!));
                break;
              }
          }

          break;
        }
      case "HIGH":
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.high!.compareTo(a.high!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.high!.compareTo(b.high!));
                break;
              }
          }

          break;
        }
      case "LOW":
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.low!.compareTo(a.low!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.low!.compareTo(b.low!));
                break;
              }
          }

          break;
        }
      case "OPEN":
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.open!.compareTo(a.open!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.open!.compareTo(b.open!));
                break;
              }
          }

          break;
        }
      case "CLOSE":
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.close!.compareTo(a.close!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.close!.compareTo(b.close!));
                break;
              }
          }

          break;
        }
      case "LTP":
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.ltp!.compareTo(a.ltp!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.ltp!.compareTo(b.ltp!));
                break;
              }
          }

          break;
        }
      case "NET CHANGE %":
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.chp!.compareTo(a.chp!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.chp!.compareTo(b.chp!));
                break;
              }
          }

          break;
        }
      default:
    }

    for (var i = 0; i < arrScript.length; i++) {
      var preIndex = arrPreScript.indexWhere((element) => element.symbol == arrScript[i].symbol);
      var temp = arrPreScript.removeAt(preIndex);
      arrPreScript.insert(i, temp);
    }

    storeScripsInDB();

    update();
  }

  sortScriptOld(int index) {
    arrScript.removeWhere((element) => element.symbol!.isEmpty);
    arrPreScript.removeWhere((element) => element.symbol!.isEmpty);
    switch (index) {
      case 0:
        switch (arrListTitle[index].sortType) {
          case 0:
          case -1:
            {
              arrListTitle[index].sortType = 1;
              arrScript.sort((a, b) => b.exchange!.compareTo(a.exchange!));

              break;
            }
          case 1:
            {
              arrListTitle[index].sortType = -1;
              arrScript.sort((a, b) => a.exchange!.compareTo(b.exchange!));
              break;
            }
        }
        break;
      case 1:
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.symbol!.compareTo(a.symbol!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.symbol!.compareTo(b.symbol!));
                break;
              }
          }

          break;
        }
      case 2:
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.expiry!.compareTo(a.expiry!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.expiry!.compareTo(b.expiry!));
                break;
              }
          }

          break;
        }
      case 3:
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.ls!.compareTo(a.ls!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.ls!.compareTo(b.ls!));
                break;
              }
          }

          break;
        }
      case 4:
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.bid!.compareTo(a.bid!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.bid!.compareTo(b.bid!));
                break;
              }
          }

          break;
        }
      case 5:
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.ask!.compareTo(a.ask!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.ask!.compareTo(b.ask!));
                break;
              }
          }

          break;
        }
      case 6:
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.ts!.compareTo(a.ts!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.ts!.compareTo(b.ts!));
                break;
              }
          }

          break;
        }
      case 7:
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.ltp!.compareTo(a.ltp!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.ltp!.compareTo(b.ltp!));
                break;
              }
          }

          break;
        }
      case 8:
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.ch!.compareTo(a.ch!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.ch!.compareTo(b.ch!));
                break;
              }
          }

          break;
        }
      case 9:
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.open!.compareTo(a.open!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.open!.compareTo(b.open!));
                break;
              }
          }

          break;
        }
      case 10:
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.high!.compareTo(a.high!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.high!.compareTo(b.high!));
                break;
              }
          }

          break;
        }
      case 11:
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.low!.compareTo(a.low!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.low!.compareTo(b.low!));
                break;
              }
          }

          break;
        }
      case 12:
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.close!.compareTo(a.close!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.close!.compareTo(b.close!));
                break;
              }
          }

          break;
        }
      case 13:
        {
          switch (arrListTitle[index].sortType) {
            case 0:
            case -1:
              {
                arrListTitle[index].sortType = 1;
                arrScript.sort((a, b) => b.expiry!.compareTo(a.expiry!));

                break;
              }
            case 1:
              {
                arrListTitle[index].sortType = -1;
                arrScript.sort((a, b) => a.expiry!.compareTo(b.expiry!));
                break;
              }
          }

          break;
        }
      default:
    }

    for (var i = 0; i < arrScript.length; i++) {
      var preIndex = arrPreScript.indexWhere((element) => element.symbol == arrScript[i].symbol);
      var temp = arrPreScript.removeAt(preIndex);
      arrPreScript.insert(i, temp);
    }
    update();
  }

  String validateForm() {
    var msg = "";
    if (selectedOrderType.value.id != "limit") {
      var ltpObj = arrLtpUpdate.firstWhereOrNull((element) => element.symbolTitle == selectedScript.value!.symbol);

      if (ltpObj == null) {
        return "Not Allowed For Trade";
      } else {
        var difference = DateTime.now().difference(ltpObj.dateTime!);
        var differenceInSeconds = difference.inSeconds;
        if (differenceInSeconds >= 40) {
          return "Not Allowed For Trade";
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
    if (index >= 0 && index < arrScript.length) {
      final double itemHeight = 30.0; // Replace with your item height
      final double listViewHeight = listScroll.position.viewportDimension;
      final double scrollTo = index * itemHeight;

      final double currentScrollOffset = listScroll.offset;

      if (scrollTo < currentScrollOffset && currentScrollOffset != 0) {
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
        totalQuantity: int.parse(qtyController.text),
        price: double.parse(priceController.text),
        isFromStopLoss: selectedOrderType.value.id == "stopLoss",
        marketPrice: selectedOrderType.value.id == "stopLoss"
            ? isFromBuy
                ? selectedScript.value!.ask!.toDouble()
                : selectedScript.value!.bid!.toDouble()
            : selectedOrderType.value.id == "limit"
                ? double.parse(priceController.text)
                : isFromBuy
                    ? selectedScript.value!.ask!.toDouble()
                    : selectedScript.value!.bid!.toDouble(),
        lotSize: selectedSymbol!.lotSize!,
        orderType: selectedOrderType.value.id == "123" ? "market" : selectedOrderType.value.id,
        tradeType: isFromBuy ? "buy" : "sell",
        exchangeId: selectedSymbol!.exchangeId,
        productType: selectedOrderType.value.id == "123" ? "intraday" : "longTerm",
        refPrice: isFromBuy ? selectedScript.value!.ask!.toDouble() : selectedScript.value!.bid!.toDouble(),
      );

      //longterm
      isTradeCallFinished.value = false;
      update();
      selectedOrderType.value = arrOrderType.firstWhere((element) => element.id == "market");
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

          showSuccessToast(response.meta!.message!, bgColor: isFromBuy ? AppColors().blueColor : AppColors().redColor);
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
        orderType: selectedOrderType.value.id,
        tradeType: isFromBuy ? "buy" : "sell",
        exchangeId: selectedSymbol!.exchangeId,
        executionTime: serverFormatDateTime(DateTime.now()),
        userId: selectedUser.value.userId!,
        refPrice: isFromBuy ? selectedScript.value!.ask!.toDouble() : selectedScript.value!.bid!.toDouble(),
      );

      //longterm
      isTradeCallFinished.value = false;
      update();
      if (response != null) {
        // Get.back();
        selectedOrderType.value = arrOrderType.firstWhere((element) => element.id == "market");
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

          showSuccessToast(response.meta!.message!, bgColor: isFromBuy ? AppColors().blueColor : AppColors().redColor);
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
    var response = await service.getAllSymbolTabWiseListCall(selectedTab!.userTabId!);
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
          var index = arrCurrentWatchListOrder.indexWhere((it) => it.values.toList().last == arrSymbol[i].symbol);
          if (index != -1) {
            arrScript[index] = (ScriptData.fromJson(arrSymbol[i].toJson()));
            arrPreScript[index] = (ScriptData.fromJson(arrSymbol[i].toJson()));
          } else {
            var position = arrCurrentWatchListOrder.length;
            Map<String, dynamic> newItem = {position.toString(): arrSymbol[i].symbol};
            if (position == 0) {
              arrCurrentWatchListOrder = [newItem];
            } else {
              arrCurrentWatchListOrder.add(newItem);
            }
            dbSerivice.addScript((selectedPortfolio + 1).toString(), arrSymbol[i].symbol!, position);
            arrScript.add(ScriptData.fromJson(arrSymbol[i].toJson()));
            arrPreScript.add(ScriptData.fromJson(arrSymbol[i].toJson()));
          }
        }

        update();
      } catch (e) {
        print(e);
      }
      for (var element in response.data!) {
        if (!socket.arrSymbolNames.contains(element.symbolName)) {
          arrTemp.insert(0, element.symbolName);
          socket.arrSymbolNames.insert(0, element.symbolName!);
        }
      }
      var txt = {"symbols": arrTemp};

      update();
      if (arrTemp.isNotEmpty) {
        socket.connectScript(jsonEncode(txt));
      }
    }
  }

  listenScriptFromSocket(GetScriptFromSocket socketData) {
    try {
      if (socketData.status == true) {
        if (isScriptApiGoing == false) {
          if (selectedScriptForF5.value?.symbol != null) {
            if (selectedScriptForF5.value!.symbol == socketData.data!.symbol || selectedScriptForF5.value!.name == socketData.data!.symbol) {
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
        // print(arrLtpUpdate.length);
        var obj = arrScript.firstWhereOrNull((element) => socketData.data!.symbol == element.symbol);

        if (obj?.symbol == selectedScript.value?.symbol) {
          selectedScript.value = socketData.data!;

          selectedScript.value!.copyObject(socketData.data!);
        }
        if (obj != null) {
          var index = arrScript.indexOf(obj);
          var preIndex = arrPreScript.indexWhere((element) => element.symbol == obj.symbol);
          arrPreScript.removeAt(preIndex);
          arrPreScript.insert(preIndex, arrScript[index]);
          if (index == 0) {}
          arrScript[index] = socketData.data!;
          arrScript[index].lut = DateTime.now();
        }
        //else {
        //   var obj = arrSymbol.firstWhereOrNull((element) => socketData.data!.symbol == element.symbolName);
        //   if (obj != null) {
        //     arrScript.add(socketData.data!);
        //     arrPreScript.add(socketData.data!);
        //   }
        // }

        if (isBuyOpen != -1) {
          if (selectedOrderType.value.name == "Market" || selectedOrderType.value.name == "Intraday") {
            if (arrScript[selectedScriptIndex].symbol == socketData.data?.symbol) {
              // if (userData?.role == UserRollList.user) {
              //   priceController.text = isBuyOpen == 1 ? socketData.data!.ask.toString() : socketData.data!.bid.toString();
              // }
              // if (userData?.role != UserRollList.superAdmin) {
              priceController.text = isBuyOpen == 1 ? socketData.data!.ask.toString() : socketData.data!.bid.toString();
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
      var symbol = "";
      arrSymbol.removeWhere((element) {
        if (element.userTabSymbolId == tabSymbolId) {
          symbolNmae = element.symbolName!;
          symbol = element.symbol!;
          return true;
        } else {
          return false;
        }
      });
      var tempIndex = arrScript.indexWhere((element) => element.symbol == symbolNmae);
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
      var response = await service.allSymbolListCall(1, text, "");
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
    var response = await service.addSymbolToTabCall(selectedTab!.userTabId!.toString(), symbolId);
    try {
      if (response?.statusCode == 200) {
        // showSuccessToast(response?.meta?.message ?? "");
        isAddDeleteApiLoading = false;

        arrSymbol.insert(0, response!.data!);
        if (selectedScriptIndex == arrScript.length - 1) {
          arrScript.add(ScriptData.fromJson(response.data!.toJson()));
          arrPreScript.add(ScriptData.fromJson(response.data!.toJson()));
        } else {
          if (selectedScriptIndex != -1 && selectedScriptIndex < arrScript.length) {
            if (arrScript[selectedScriptIndex - 1].symbol!.isEmpty) {
              arrScript[selectedScriptIndex - 1] = ScriptData.fromJson(response.data!.toJson());
              arrPreScript[selectedScriptIndex - 1] = ScriptData.fromJson(response.data!.toJson());
            } else if (arrScript[selectedScriptIndex + 1].symbol!.isEmpty) {
              arrScript[selectedScriptIndex + 1] = ScriptData.fromJson(response.data!.toJson());
              arrPreScript[selectedScriptIndex + 1] = ScriptData.fromJson(response.data!.toJson());
            } else {
              arrScript.add(ScriptData.fromJson(response.data!.toJson()));
              arrPreScript.add(ScriptData.fromJson(response.data!.toJson()));
            }
          } else {
            arrScript.add(ScriptData.fromJson(response.data!.toJson()));
            arrPreScript.add(ScriptData.fromJson(response.data!.toJson()));
          }
        }
        storeScripsInDB();
        isFilterClicked = 0;
        var arrTemp = [];

        arrTemp.add(response.data!.symbolName!);
        var txt = {"symbols": arrTemp};
        socket.connectScript(jsonEncode(txt));
        update();
      } else {
        showErrorToast(response?.message ?? "");
      }
    } catch (e) {
      //print(e);
    }
  }

  storeScripsInDB() {
    Future.delayed(const Duration(milliseconds: 100), () {
      arrCurrentWatchListOrder.clear();
      for (int i = 0; i < arrScript.length; i++) {
        Map<String, dynamic> newItem = {i.toString(): arrScript[i].symbol};
        arrCurrentWatchListOrder.add(newItem);
      }
      dbSerivice.bulkUpdate((selectedPortfolio + 1).toString(), arrCurrentWatchListOrder);
    });
  }

  buySellPopupDialog({bool isFromBuy = true, Function? CancelClick, Function? DeleteClick}) {
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
                              const SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                AppImages.appLogo,
                                width: 22,
                                height: 22,
                                color: isFromBuy ? AppColors().blueColor : AppColors().redColor,
                              ),
                              const SizedBox(
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
                            color: isFromBuy ? AppColors().blueColor : AppColors().redColor,
                            padding: const EdgeInsets.all(10),
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
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: userListDropDown(selectedUser),
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
                                          margin: const EdgeInsets.symmetric(vertical: 5),
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
                                                if (selectedSymbol?.oddLotTrade == 1) {
                                                  var temp = (num.parse(qtyController.text) / selectedScript.value!.ls!);
                                                  lotController.text = temp.toStringAsFixed(2);
                                                  isValidQty.value = true;
                                                } else {
                                                  var temp = (num.parse(qtyController.text) / selectedScript.value!.ls!);

                                                  print(temp);
                                                  if ((num.parse(qtyController.text) % selectedScript.value!.ls!) == 0) {
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
                                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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

                                            initialValue: 1,
                                            incDecFactor: 1,
                                            isInt: true,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: CustomFonts.family1Regular,
                                              color: AppColors().darkText,
                                            ),
                                            numberFieldDecoration: InputDecoration(border: InputBorder.none, fillColor: AppColors().whiteColor, contentPadding: const EdgeInsets.only(bottom: 8, left: 20)),

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
                                            margin: const EdgeInsets.symmetric(
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
                                              numberFieldDecoration: InputDecoration(border: InputBorder.none, fillColor: AppColors().whiteColor, contentPadding: const EdgeInsets.only(bottom: 8, left: 20)),
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
                                        exchangeTypeDropDown(selectedExchangeFromPopup, isFromPopUp: true)
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                          ),
                                          child: Text(
                                            "Symbol",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors().whiteColor,
                                              fontFamily: CustomFonts.family1Regular,
                                            ),
                                          ),
                                        ),
                                        ScriptDropdownFromPopupDropDown(selectedScriptFromPopup)
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10),
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
                                                  borderColor: isFromBuy ? AppColors().redColor : AppColors().blueColor,
                                                  focusShadowColor: AppColors().whiteColor,
                                                  onPress: () {
                                                    initiateManualTrade(isFromBuy);
                                                  },
                                                  bgColor: AppColors().grayLightLine,
                                                  isFilled: true,
                                                  textColor: AppColors().darkText,
                                                  isTextCenter: true,
                                                  isLoading: false,
                                                ),
                                              ),
                                              const SizedBox(
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

  adminBuySellPopupDialog({bool isFromBuy = true, Function? CancelClick, Function? DeleteClick}) {
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
                              const SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                AppImages.appLogo,
                                width: 22,
                                height: 22,
                                color: isFromBuy ? AppColors().blueColor : AppColors().redColor,
                              ),
                              const SizedBox(
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
                            color: isFromBuy ? AppColors().blueColor : AppColors().redColor,
                            padding: const EdgeInsets.all(10),
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
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: userListDropDown(selectedUser),
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
                                        orderTypeListDropDown(isFromAdmin: userData!.role == UserRollList.user ? false : true)
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
                                          margin: const EdgeInsets.symmetric(vertical: 5),
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
                                                if (selectedSymbol?.oddLotTrade == 1) {
                                                  var temp = (num.parse(qtyController.text) / selectedScript.value!.ls!);
                                                  lotController.text = temp.toStringAsFixed(2);
                                                  isValidQty.value = true;
                                                } else {
                                                  var temp = (num.parse(qtyController.text) / selectedScript.value!.ls!);

                                                  print(temp);
                                                  if ((num.parse(qtyController.text) % selectedScript.value!.ls!) == 0) {
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
                                          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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

                                            initialValue: 1,
                                            incDecFactor: 1,
                                            isInt: true,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: CustomFonts.family1Regular,
                                              color: AppColors().darkText,
                                            ),
                                            numberFieldDecoration: InputDecoration(border: InputBorder.none, fillColor: AppColors().whiteColor, contentPadding: const EdgeInsets.only(bottom: 8, left: 20)),

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
                                            margin: const EdgeInsets.symmetric(
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
                                              enabled: selectedOrderType.value.name != "Market" && selectedOrderType.value.name != "Intraday",
                                              initialValue: double.tryParse(priceController.text) ?? 0.0,
                                              incDecFactor: 0.05,
                                              isInt: false,
                                              numberFieldDecoration: InputDecoration(border: InputBorder.none, fillColor: AppColors().whiteColor, contentPadding: const EdgeInsets.only(bottom: 8, left: 20)),
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
                                        exchangeTypeDropDown(selectedExchangeFromPopup, isFromPopUp: true)
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                          ),
                                          child: Text(
                                            "Symbol",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors().whiteColor,
                                              fontFamily: CustomFonts.family1Regular,
                                            ),
                                          ),
                                        ),
                                        ScriptDropdownFromPopupDropDown(selectedScriptFromPopup)
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10),
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
                                                  borderColor: isFromBuy ? AppColors().redColor : AppColors().blueColor,
                                                  focusShadowColor: AppColors().whiteColor,
                                                  onPress: () {
                                                    if (userData!.role == UserRollList.user) {
                                                      initiateTrade(isFromBuy);
                                                    } else {
                                                      initiateManualTrade(isFromBuy);
                                                    }
                                                  },
                                                  bgColor: AppColors().grayLightLine,
                                                  isFilled: true,
                                                  textColor: AppColors().darkText,
                                                  isTextCenter: true,
                                                  isLoading: false,
                                                ),
                                              ),
                                              const SizedBox(
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

  Widget exchangeTypeDropDown(Rx<ExchangeData> value, {bool isFromPopUp = false}) {
    return IgnorePointer(
      ignoring: isFromPopUp,
      child: Container(
        width: 210,
        height: 40,
        margin: EdgeInsets.symmetric(horizontal: isFromPopUp ? 0 : 10, vertical: 5),
        decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1), color: AppColors().whiteColor),
        child: Obx(() {
          return Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<ExchangeData>(
                isExpanded: true,
                onMenuStateChange: (isOpen) {},
                iconStyleData: IconStyleData(
                  icon: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: isFromPopUp
                          ? const SizedBox()
                          : Icon(
                              Icons.keyboard_arrow_down_outlined,
                              size: 25,
                              color: AppColors().fontColor,
                            )),
                ),
                hint: Text(
                  isFromPopUp ? value.value.name ?? "" : "Exchange",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: CustomFonts.family1Medium,
                    color: AppColors().darkText,
                  ),
                ),
                items: isFromPopUp
                    ? []
                    : arrExchange
                        .map((ExchangeData item) => DropdownMenuItem<ExchangeData>(
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
                        .toList(),
                selectedItemBuilder: (context) {
                  return arrExchange
                      .map((ExchangeData item) => DropdownMenuItem<ExchangeData>(
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
                value: value.value.exchangeId != null ? value.value : null,
                onChanged: (ExchangeData? newSelectedValue) {
                  // setState(() {
                  value.value = newSelectedValue!;
                  //focusNode.requestFocus();
                  update();
                  getScriptList();
                  // });
                },
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  height: 40,
                  // width: 140,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget ScriptDropdownFromPopupDropDown(Rx<ScriptData?> value) {
    return IgnorePointer(
      ignoring: true,
      child: Container(
        width: 210,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1), color: AppColors().whiteColor),
        child: Obx(() {
          return Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<ScriptData>(
                isExpanded: true,
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
                  selectedScriptIndex = arrScript.indexWhere((element) => element.symbol == newSelectedValue?.symbol);
                  var obj = arrSymbol.firstWhereOrNull((element) => arrScript[selectedScriptIndex].symbol == element.symbolName);
                  var exchangeObj = arrExchange.firstWhereOrNull((element) => element.exchangeId == obj!.exchangeId!);
                  if (exchangeObj != null) {
                    selectedExchangeFromPopup.value = exchangeObj;
                  }
                  qtyController.text = obj!.lotSize!.toString();

                  priceController.text = arrScript[selectedScriptIndex].bid!.toString();

                  selectedScriptFromPopup.value = arrScript[selectedScriptIndex];
                  update();
                  // });
                },
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  height: 40,
                  // width: 140,
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
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
        width: 250,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<GlobalSymbolData>(
              isExpanded: true,
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
                          size: 25,
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
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Container(
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
                  return item.value!.symbolTitle.toString().toLowerCase().startsWith(searchValue.toLowerCase());
                },
              ),
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  textEditingController.clear();
                }
              },
              dropdownStyleData: const DropdownStyleData(maxHeight: 250),
              hint: Text(
                'Script',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().darkText,
                ),
              ),
              items: arrAllScript
                  .map((GlobalSymbolData item) => DropdownMenuItem<GlobalSymbolData>(
                        value: item,
                        child: StatefulBuilder(builder: (context, menuSetState) {
                          return GestureDetector(
                            onTap: () async {
                              // focusNode.requestFocus();
                              menuSetState(() {
                                item.isApiCallRunning = true;
                              });
                              var temp = arrSymbol.firstWhereOrNull((element) => item.symbolId == element.symbolId);

                              if (temp != null) {
                                await deleteSymbolFromTab(temp.userTabSymbolId!);
                              } else {
                                await addSymbolToTab(item.symbolId.toString());
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
                                    child: Text(item.symbolTitle ?? "", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().borderColor)),
                                  ),
                                  const Spacer(),
                                  item.isApiCallRunning
                                      ? SizedBox(
                                          width: 15,
                                          height: 15,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: AppColors().blueColor,
                                          ))
                                      : arrSymbol.firstWhereOrNull((element) => element.symbolId == item.symbolId) != null
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
                              fontSize: 14,
                              fontFamily: CustomFonts.family1Medium,
                              color: AppColors().darkText,
                            ),
                          ),
                        ))
                    .toList();
              },
              value: null,
              onChanged: (GlobalSymbolData? value) {
                // // setState(() {
                // controller.selectedScriptFromAll = value;
                // controller.update();
                // // });
                // focusNode.requestFocus();
                var temp = arrSymbol.firstWhereOrNull((element) => value!.symbolId == element.symbolId);

                if (temp != null) {
                  deleteSymbolFromTab(temp.userTabSymbolId!);
                } else {
                  addSymbolToTab(value!.symbolId.toString());
                }
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 40,
                // width: 140,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
            ),
          ),
        ));
  }

  Widget orderTypeListDropDown({bool isFromAdmin = false}) {
    return Obx(() {
      return IgnorePointer(
        ignoring: userData!.role == UserRollList.superAdmin ? false : isFromAdmin,
        child: Container(
            width: 210,
            height: 40,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1), color: AppColors().whiteColor),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<Type>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 15),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: isBuyOpen == 1 ? AppColors().redColor : AppColors().blueColor, width: 2)),
                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
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
                    update();

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
                    decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1), color: AppColors().whiteColor),
                    child: Center(
                      child: DropdownButtonHideUnderline(
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
                            contentPadding: const EdgeInsets.only(left: 15),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: isBuyOpen == 1 ? AppColors().redColor : AppColors().blueColor, width: 2)),
                            enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
                          ),
                          value: selectedValidity.value.id == null ? null : selectedValidity.value,
                          onChanged: (Type? value) {
                            selectedValidity.value = value!;

                            // focusNode.requestFocus();
                          },
                        ),
                      ),
                    )),
              ],
            );
    });
  }

  Widget userListDropDown(Rx<UserData> selectedUser, {double? width}) {
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
            child: DropdownButtonFormField<UserData>(
              isExpanded: false,
              menuMaxHeight: 130,
              alignment: Alignment.bottomCenter,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 15),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: isBuyOpen == 1 ? AppColors().redColor : AppColors().blueColor, width: 2)),
                enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent, width: 0)),
              ),
              hint: Text(
                userData!.role == UserRollList.user ? userData!.userName! : 'Select User',
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
          ));
    });
  }

  Widget allScriptListDropDownForF5() {
    return Container(
        width: 250,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<GlobalSymbolData>(
              isExpanded: true,
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
                          size: 25,
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
                searchInnerWidgetHeight: 50,
                searchInnerWidget: Container(
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
                  return item.value!.symbolTitle.toString().toLowerCase().startsWith(searchValue.toLowerCase());
                },
              ),
              onMenuStateChange: (isOpen) {
                if (!isOpen) {
                  textEditingController.clear();
                }
              },
              dropdownStyleData: const DropdownStyleData(maxHeight: 250),
              hint: Text(
                'Script',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().darkText,
                ),
              ),
              items: arrAllScriptForF5
                  .map((GlobalSymbolData item) => DropdownMenuItem<GlobalSymbolData>(
                        value: item,
                        child: StatefulBuilder(builder: (context, menuSetState) {
                          return Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Center(
                                  child: Text(item.symbolTitle ?? "", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().borderColor)),
                                ),
                                // const Spacer(),
                                // item.isApiCallRunning
                                //     ? SizedBox(
                                //         width: 15,
                                //         height: 15,
                                //         child: CircularProgressIndicator(
                                //           strokeWidth: 2,
                                //           color: AppColors().blueColor,
                                //         ))
                                //     : arrSymbol.firstWhereOrNull((element) => element.symbolId == item.symbolId) != null
                                //         ? Icon(
                                //             Icons.check_box,
                                //             color: AppColors().blueColor,
                                //             size: 18,
                                //           )
                                //         : Icon(
                                //             Icons.check_box_outline_blank,
                                //             color: AppColors().lightText,
                                //             size: 18,
                                //           )
                              ],
                            ),
                          );
                        }),
                      ))
                  .toList(),
              selectedItemBuilder: (context) {
                return arrAllScriptForF5
                    .map((GlobalSymbolData item) => DropdownMenuItem<String>(
                          value: item.symbolTitle,
                          child: Text(
                            item.symbolTitle ?? "",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: CustomFonts.family1Medium,
                              color: AppColors().darkText,
                            ),
                          ),
                        ))
                    .toList();
              },
              value: selectedSymbolForF5.value?.symbolId == null ? null : selectedSymbolForF5.value!,
              onChanged: (GlobalSymbolData? value) {
                selectedSymbolForF5.value = value!;
                getselectedSymbolDetailFromF5PopUp(value.symbolId!);
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.symmetric(horizontal: 0),
                height: 40,
                // width: 140,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
            ),
          ),
        ));
  }

  Widget exchangeTypeDropDownForF5(
    Rx<ExchangeData> value,
  ) {
    return Container(
      width: 210,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1), color: AppColors().whiteColor),
      child: Obx(() {
        return Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<ExchangeData>(
              isExpanded: true,
              onMenuStateChange: (isOpen) {},
              iconStyleData: IconStyleData(
                icon: Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      size: 25,
                      color: AppColors().fontColor,
                    )),
              ),
              hint: Text(
                "Exchange",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().darkText,
                ),
              ),
              items: arrExchange
                  .map((ExchangeData item) => DropdownMenuItem<ExchangeData>(
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
                  .toList(),
              selectedItemBuilder: (context) {
                return arrExchange
                    .map((ExchangeData item) => DropdownMenuItem<ExchangeData>(
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
                // width: 140,
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
              ),
            ),
          ),
        );
      }),
    );
  }
}
