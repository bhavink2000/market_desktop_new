import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/constantModelClass.dart';
import 'package:marketdesktop/modelClass/expiryListModelClass.dart';
import 'package:marketdesktop/modelClass/strikePriceModelClass.dart';
import 'package:marketdesktop/screens/MainTabs/DashboardTab/dashboardController.dart';
import 'package:marketdesktop/screens/MainTabs/FileTab/ChangePasswordScreen/changePasswordController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/BillGenerateScreen/billGenerateController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/BulkTradeScreen/bulkTradeController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/ClientAccountReportScreen/clientAccountReportController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/LogHistoryScreen/logHistoryController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/LogsHistoryNewScreen/logsHistoryNewController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/ManageTradeScreen/manageTradeController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/OpenPositionScreen/openPositionController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/PercentOpenPositionScreen/percentOpenPositionController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/ProfitAndLossSummaryScreen/profitAndLossSummaryController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/ScriptMasterScreen/scriptMasterController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/SettelmentScreen/settelmentController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/SymbolWisePositionReportScreen/symbolWisePositionReportController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/TradeAccountScreen/tradeAccountController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/TradeLogScreen/tradeLogController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/TradeMarginScreen/tradeMarginListController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/UserScriptPositionTrackScreen/userScriptPositionTrackController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/UserWisePLSummaryScreen/userWisePLSummaryController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/WeeklyAdminScreen/weeklyAdminController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/historyOfCreditScreen/historyOfCreditController.dart';
import 'package:marketdesktop/screens/MainTabs/SettingsTab/notificationSettingController.dart';
import 'package:marketdesktop/screens/MainTabs/ToolsTab/ScriptQuantityScreen/ScriptQuantityScreenController.dart';
import 'package:marketdesktop/screens/MainTabs/ToolsTab/messagesController.dart';
import 'package:marketdesktop/screens/MainTabs/UserTab/UserListScreen/LeverageUpdateScreen/leverageUpdateController.dart';
import 'package:marketdesktop/screens/MainTabs/UserTab/UserListScreen/userListController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/LoginHistoryScreen/loginHistoryController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/M2mProfitAndLossScreen/m2mProfitAndLossController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/ManualOrderscreen/manualOrderController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/MarketWatchScreen/marketWatchController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/PositionScreen/positionScreenController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/ProfitAndLossScreen/profitAndLossController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/RejectionLogScreen/rejectionLogController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/successTradeListController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/tradeListController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/SuperAdminTradePopUp/superAdminTradePopUpController.dart';
import 'package:window_size/window_size.dart';
import '../../constant/index.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';
import '../../modelClass/getScriptFromSocket.dart';
import '../MainTabs/UserTab/CreateUserScreen/createUserController.dart';
import '../UserDetailPopups/userDetailsPopUpController.dart';

class MainContainerControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(MarketWatchController());
    Get.lazyPut(() => MainContainerController());
  }
}

class MainContainerController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  ScrollController listcontroller = ScrollController();
  bool isTotalViewExpanded = false;
  TextEditingController textController = TextEditingController();
  FocusNode textFocus = FocusNode();

  int? selectedTab;

  List<String> arrAdditionMenu = [];

  List<String> arrAvailableTabs = [];
  String selectedCurrentTab = "";
  int selectedCurrentTabIndex = -1;
  bool isCreateUserClick = false;
  bool isNotificationSettingClick = false;
  bool isStatusBarVisible = true;
  bool isToolBarVisible = false;
  final FocusNode focusNode = FocusNode();
  bool isKeyPressActive = false;
  bool isInitCallRequired = true;
  final debouncer = Debouncer(milliseconds: 300);
  final oneSecondDebouncer = Debouncer(milliseconds: 1000);
  RxDouble? pl;
  CreateUserController? createUserVc;
  @override
  void onInit() async {
    if (userData?.role == UserRollList.user || userData?.role == UserRollList.broker) {
      arrAdditionMenu = [
        AppImages.watchIcon,
        AppImages.addYellowIcon,
        AppImages.addRedIcon,
        AppImages.marketIcon,
      ];
    } else {
      arrAdditionMenu = [AppImages.watchIcon, AppImages.addYellowIcon, AppImages.addRedIcon, AppImages.marketIcon, AppImages.userAddIcon, AppImages.searchColorIcon];
    }

    super.onInit();
    Get.put(CreateUserController());
    Get.put(NotificationSettingsController());
    createUserVc = Get.find<CreateUserController>();
    if (Platform.isMacOS) {
      await windowManager.setMinimumSize(Size(1280, 800));
      // // setWindowMinSize(const Size(1280, 800));
      // await windowManager.center(animate: true);
      await windowManager.setAlignment(Alignment.topCenter, animate: false);
      await windowManager.setMovable(true);
      await windowManager.setResizable(true);
      await windowManager.setMaximizable(true);

      await windowManager.maximize();
      Screen? size = await getCurrentScreen();
      print(size);
      await windowManager.setSize(Size(size!.frame.width, size.frame.height - 50));
    } else {
      setWindowMinSize(const Size(1280, 800));
      Future.delayed(Duration(milliseconds: 100), () async {
        Screen? size = await getCurrentScreen();
        print(size);
        await windowManager.setSize(Size(size!.frame.width, size.frame.height - 50));
        Future.delayed(const Duration(milliseconds: 100), () async {
          await windowManager.center(animate: true);
          await windowManager.setResizable(true);
          await windowManager.setMaximizable(true);
          await windowManager.maximize();
          update();
          Future.delayed(const Duration(milliseconds: 500), () async {
            setWindowMinSize(const Size(1280, 800));
            update();
          });
        });
      });
    }

    Timer.periodic(const Duration(seconds: 5), (timer) {
      getOwnProfile();
      getConstantLisT();
      if (Platform.isWindows) {
        setWindowMinSize(const Size(1280, 800));
      }
    });

    Future.delayed(const Duration(milliseconds: 100), () async {
      if (userData!.changePasswordOnFirstLogin == true) {
        showChangePasswordPopUp();
      }
      update();
    });

    // if (isKeyBoardListenerActive == false) {

    //   isKeyBoardListenerActive = true;
    // }
    RawKeyboard.instance.addListener(handleKeyBoard);

    update();
  }

  @override
  void onClose() {
    RawKeyboard.instance.removeListener(handleKeyBoard);
    super.onClose();
  }

  String setupbottomData() {
    if (userData?.role != UserRollList.user) {
      return "PL : ${pl != null ? pl!.value.toStringAsFixed(2) : userData!.profitLoss!.toStringAsFixed(2)}  | BK : ${userData!.brokerageTotal!.toStringAsFixed(2)} | BAL :  ${userData!.balance!.toStringAsFixed(2)} | CRE : ${userData!.credit!.toStringAsFixed(2)} |";
    } else {
      return "PL : ${pl != null ? pl!.value.toStringAsFixed(2) : userData!.profitLoss!.toStringAsFixed(2)}  | BAL :  ${userData!.balance!.toStringAsFixed(2)} | CRE : ${userData!.credit!.toStringAsFixed(2)} |";
    }
  }

  getConstantLisT() async {
    var response = await service.getConstantCall();
    if (response != null) {
      constantValues = response.data;
      arrStatuslist = constantValues?.status ?? [];
      arrFilterType = constantValues?.userFilterType ?? [];

      arrLeverageList = constantValues?.leverageList ?? [];

      if (arrLeverageList.isNotEmpty && createUserVc!.selectedLeverage.value.id == null) {
        createUserVc!.selectedLeverage.value = arrLeverageList.first;
        createUserVc!.update();
      }
      // update();
    }
  }

  getOwnProfile() async {
    var userResponse = await service.profileInfoCall();
    if (userResponse != null) {
      if (userResponse.statusCode == 200) {
        userData = userResponse.data;

        setupbottomData();
        // update();
        //print("data Updated");
      }
    }
  }

  handleKeyBoard(RawKeyEvent event) {
    if (event.logicalKey.keyLabel == "Escape" && isSuperAdminPopUpOpen) {
      Get.back();
      isSuperAdminPopUpOpen = false;
      Get.delete<SuperAdminTradePopUpController>();
      return;
    }
    if (currentOpenedScreen == ScreenViewNames.marketWatch && isCreateUserClick == false) {
      handleMarketWatchKeyEvents(event);
    } else if (currentOpenedScreen == ScreenViewNames.positions && isCreateUserClick == false) {
      handlePositionKeyEvent(event);
    } else {
      if (event.logicalKey.keyLabel == "Escape") {
        debouncer.run(() async {
          isKeyPressActive = true;
          update();
          if (currentOpenedScreen == ScreenViewNames.orders) {
            if (Get.find<TradeListController>().openPopUpCount != 0) {
              Get.find<TradeListController>().openPopUpCount--;
            } else {
              onKeyHite();
            }
          } else {
            onKeyHite();
          }
        });
      } else if (event.logicalKey.keyLabel == "F9") {
        debouncer.run(() async {
          var dashBoardVC = Get.find<MainContainerController>();
          if (!dashBoardVC.arrAvailableTabs.contains("Dashboard")) {
            dashBoardVC.arrAvailableTabs.insert(0, "Dashboard");

            dashBoardVC.update();
          }
        });
      }
    }
  }

  onKeyHite() async {
    debouncer.run(() async {
      if (isChangePasswordScreenPopUpOpen) {
        Get.back();

        await Get.delete<ChangePasswordController>();
        isChangePasswordScreenPopUpOpen = false;
      } else if (isUpdateLeveragePopUpOpen) {
        Get.back();

        await Get.delete<LeverageUpdateController>();
        isUpdateLeveragePopUpOpen = false;
      } else if (isUserDetailPopUpOpen) {
        Get.back();
        await Get.find<UserDetailsPopUpController>().deleteAllController();
        await Get.delete<UserDetailsPopUpController>();
        isUserDetailPopUpOpen = false;

        return;
      } else if (isUserViewPopUpOpen) {
        Get.back();
        isUserViewPopUpOpen = false;
      } else {
        Get.back();
        isCommonScreenPopUpOpen = false;

        if (currentOpenedScreen == ScreenViewNames.orders) {
          await Get.delete<TradeListController>();
        } else if (currentOpenedScreen == ScreenViewNames.positions) {
          pl = null;
          update();
          await Get.delete<PositionController>();
        } else if (currentOpenedScreen == ScreenViewNames.profitAndLoss) {
          await Get.delete<ProfitAndLossController>();
        } else if (currentOpenedScreen == ScreenViewNames.userList) {
          await Get.delete<UserListController>();
        } else if (currentOpenedScreen == ScreenViewNames.m2mProfitAndLoss) {
          await Get.delete<M2MProfitAndLossController>();
        } else if (currentOpenedScreen == ScreenViewNames.rejectionLog) {
          await Get.delete<RejectionLogController>();
        } else if (currentOpenedScreen == ScreenViewNames.loginHistory) {
          await Get.delete<LoginHistoryController>();
        } else if (currentOpenedScreen == ScreenViewNames.openPosition) {
          await Get.delete<OpenPositionController>();
        } else if (currentOpenedScreen == ScreenViewNames.manageTrades) {
          await Get.delete<ManageTradeController>();
        } else if (currentOpenedScreen == ScreenViewNames.tradeAccount) {
          await Get.delete<TradeAccountController>();
        } else if (currentOpenedScreen == ScreenViewNames.settelment) {
          await Get.delete<SettlementController>();
        } else if (currentOpenedScreen == ScreenViewNames.creditHistory) {
          await Get.delete<HistoryOfCreditController>();
        } else if (currentOpenedScreen == ScreenViewNames.billGenerate) {
          await Get.delete<BillGenerateController>();
        } else if (currentOpenedScreen == ScreenViewNames.percentopenPosition) {
          await Get.delete<PercentOpenPositionController>();
        } else if (currentOpenedScreen == ScreenViewNames.weeklyAdmin) {
          await Get.delete<WeeklyAdminController>();
        } else if (currentOpenedScreen == ScreenViewNames.logsHistory) {
          await Get.delete<LogHistoryController>();
        } else if (currentOpenedScreen == ScreenViewNames.scriptMaster) {
          await Get.delete<ScriptMasterController>();
        } else if (currentOpenedScreen == ScreenViewNames.pAndlSummary) {
          await Get.delete<ProfitAndLossSummaryController>();
        } else if (currentOpenedScreen == ScreenViewNames.userLogsNew) {
          await Get.delete<LogsHistoryNewController>();
        } else if (currentOpenedScreen == ScreenViewNames.userwisePAndLSummary) {
          await Get.delete<UserWisePLSummaryController>();
        } else if (currentOpenedScreen == ScreenViewNames.userScriptPositionTracking) {
          await Get.delete<UserScriptPositionTrackController>();
        } else if (currentOpenedScreen == ScreenViewNames.messages) {
          await Get.delete<MessagesController>();
        } else if (currentOpenedScreen == ScreenViewNames.dashboard) {
          await Get.delete<DashboardController>();
        } else if (currentOpenedScreen == ScreenViewNames.trades) {
          await Get.delete<SuccessTradeListController>();
        } else if (currentOpenedScreen == ScreenViewNames.tradeLogs) {
          await Get.delete<TradeLogController>();
        } else if (currentOpenedScreen == ScreenViewNames.tradeMargin) {
          await Get.delete<TradeMarginController>();
        } else if (currentOpenedScreen == ScreenViewNames.manualOrder) {
          await Get.delete<manualOrderController>();
        } else if (currentOpenedScreen == ScreenViewNames.symbolWisePositionReport) {
          await Get.delete<SymbolWisePositionReportController>();
        } else if (currentOpenedScreen == ScreenViewNames.clientAccountReport) {
          await Get.delete<ClientAccountReportController>();
        } else if (currentOpenedScreen == ScreenViewNames.scriptQty) {
          await Get.delete<ScriptQuantityController>();
        } else if (currentOpenedScreen == ScreenViewNames.bulkTrade) {
          await Get.delete<BulkTradeController>();
        }

        currentOpenedScreen = ScreenViewNames.marketWatch;

        isKeyPressActive = false;
        update();
      }
    });
  }

  handleMarketWatchKeyEvents(RawKeyEvent event) {
    // RawKeyboard.instance.addListener((event) {

    // });
    // print(event);
    var marketVC = Get.find<MarketWatchController>();
    if (event.isKeyPressed(LogicalKeyboardKey.escape) == false) {
      if (marketVC.tempFocus.value.hasFocus == false) {
        return;
      }
    }

    if (event.isKeyPressed(LogicalKeyboardKey.f1) || event.isKeyPressed(LogicalKeyboardKey.numpadAdd)) {
      if (userData!.role == UserRollList.admin || userData!.role == UserRollList.superAdmin) {
        return;
      }
      if (marketVC.selectedScriptIndex != -1) {
        if (marketVC.isBuyOpen == -1 && marketVC.isScripDetailOpen == false) {
          var obj = marketVC.arrSymbol.firstWhereOrNull((element) => marketVC.arrScript[marketVC.selectedScriptIndex].symbol == element.symbolName);
          var exchangeObj = arrExchange.firstWhereOrNull((element) => element.exchangeId == obj!.exchangeId!);
          if (exchangeObj != null) {
            marketVC.selectedExchangeFromPopup.value = exchangeObj;
          }
          marketVC.qtyController.text = obj!.ls!.toString();
          marketVC.isValidQty = true.obs;
          if (userData?.role != UserRollList.superAdmin) {
            marketVC.priceController.text = marketVC.arrScript[marketVC.selectedScriptIndex].ask!.toString();
          }

          marketVC.selectedScriptFromPopup.value = marketVC.arrScript[marketVC.selectedScriptIndex];
          marketVC.isBuyOpen = 1;
          debouncer.run(() async {
            isKeyPressActive = true;
            print("testtttttt");
            marketVC.adminBuySellPopupDialog(isFromBuy: true);
            Future.delayed(Duration(milliseconds: 100), () {});
          });
        }
      }
    } else if (event.isKeyPressed(LogicalKeyboardKey.f2) || event.isKeyPressed(LogicalKeyboardKey.numpadSubtract)) {
      if (userData!.role == UserRollList.admin || userData!.role == UserRollList.superAdmin) {
        return;
      }
      if (marketVC.selectedScriptIndex != -1) {
        if (marketVC.isBuyOpen == -1 && marketVC.isScripDetailOpen == false) {
          var obj = marketVC.arrSymbol.firstWhereOrNull((element) => marketVC.arrScript[marketVC.selectedScriptIndex].symbol == element.symbolName);
          var exchangeObj = arrExchange.firstWhereOrNull((element) => element.exchangeId == obj!.exchangeId!);
          if (exchangeObj != null) {
            marketVC.selectedExchangeFromPopup.value = exchangeObj;
          }
          marketVC.isBuyOpen = 2;
          marketVC.qtyController.text = obj!.ls!.toString();
          marketVC.isValidQty = true.obs;
          if (userData?.role != UserRollList.superAdmin) {
            marketVC.priceController.text = marketVC.arrScript[marketVC.selectedScriptIndex].bid!.toString();
          }

          marketVC.selectedScriptFromPopup.value = marketVC.arrScript[marketVC.selectedScriptIndex];
          debouncer.run(() async {
            isKeyPressActive = true;

            marketVC.adminBuySellPopupDialog(isFromBuy: false);
            Future.delayed(Duration(milliseconds: 100), () {});
          });
        }
      }
    } else if (event.isKeyPressed(LogicalKeyboardKey.escape)) {
      if (marketVC.isBuyOpen != -1) {
        debouncer.run(() async {
          isKeyPressActive = true;
          marketVC.isBuyOpen = -1;
          marketVC.update();
          Get.back();
        });
      } else if (marketVC.isScripDetailOpen) {
        debouncer.run(() async {
          isKeyPressActive = true;
          marketVC.isScripDetailOpen = false;
          marketVC.update();
          Get.back();
        });
      } else {
        debouncer.run(() async {
          isKeyPressActive = true;
          marketVC.isScripDetailOpen = false;
          marketVC.update();
          Get.back();
        });
      }
    } else if (event.isKeyPressed(LogicalKeyboardKey.f5)) {
      if (marketVC.isBuyOpen == -1) {
        if (marketVC.selectedScriptIndex != -1 && marketVC.isScripDetailOpen == false) {
          marketVC.isScripDetailOpen = true;
          marketVC.selectedExpiryForF5.value = expiryData();
          marketVC.arrExpiry.clear();
          marketVC.arrStrikePrice.clear();
          marketVC.selectedCallPutForF5.value = Type();
          marketVC.selectedStrikePriceForF5.value = StrikePriceData();
          marketVC.selectedExchangeForF5.value = marketVC.arrExchange.firstWhere((element) => element.exchangeId == marketVC.selectedSymbol!.exchangeId);
          marketVC.getScriptList(isFromF5: true);

          showScriptDetailPopUp();
          marketVC.update();
        }
      }
    } else if (event.isKeyPressed(LogicalKeyboardKey.delete)) {
      if (marketVC.selectedScriptIndex != -1 && marketVC.isScripDetailOpen == false) {
        marketVC.isFilterClicked = 0;
        if (marketVC.arrScript[marketVC.selectedScriptIndex].symbol != "") {
          var selectedScriptObj = marketVC.arrScript[marketVC.selectedScriptIndex];
          var temp = marketVC.arrSymbol.firstWhereOrNull((value) => value.symbolName == selectedScriptObj.symbol);
          if (temp != null) {
            marketVC.deleteSymbolFromTab(temp.userTabSymbolId!);
          }
        } else {
          marketVC.isFilterClicked = 0;
          marketVC.arrScript.removeAt(marketVC.selectedScriptIndex);
          marketVC.arrPreScript.removeAt(marketVC.selectedScriptIndex);
          // selectedScriptIndex = selectedScriptIndex + 1;
          marketVC.arrCurrentWatchListOrder.clear();
          marketVC.storeScripsInDB();
          marketVC.update();
        }
      }
    } else if (event.isKeyPressed(LogicalKeyboardKey.space)) {
      if (marketVC.isBuyOpen == -1) {
        if (marketVC.selectedScriptIndex != -1 && marketVC.isScripDetailOpen == false) {
          marketVC.arrScript.insert(marketVC.selectedScriptIndex + 1, ScriptData());
          marketVC.arrPreScript.insert(marketVC.selectedScriptIndex + 1, ScriptData());
          marketVC.storeScripsInDB();

          // selectedScriptIndex = -1;
          marketVC.isFilterClicked = 0;
          marketVC.update();
        }
      }
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      if (marketVC.isBuyOpen == -1 && marketVC.isScripDetailOpen == false) {
        if (marketVC.selectedScriptIndex != marketVC.arrScript.length - 1) {
          marketVC.selectedScriptIndex = marketVC.selectedScriptIndex + 1;
          focusNode.requestFocus();

          marketVC.selectedScript.value!.copyObject(ScriptData.fromJson(marketVC.arrScript[marketVC.selectedScriptIndex].toJson()));
          marketVC.selectedScriptForF5.value!.copyObject(ScriptData.fromJson(marketVC.arrScript[marketVC.selectedScriptIndex].toJson()));
          marketVC.upScrollToIndex(marketVC.selectedScriptIndex);
          marketVC.update();
          var indexOfSymbol = marketVC.arrSymbol.indexWhere((element) => marketVC.arrScript[marketVC.selectedScriptIndex].symbol == element.symbolName);
          if (indexOfSymbol != -1) {
            marketVC.selectedSymbol = marketVC.arrSymbol[indexOfSymbol];
            marketVC.update();
          }
        }
        //  else if (marketVC.selectedScriptIndex == marketVC.arrScript.length - 1) {
        //   marketVC.selectedScriptIndex = 0;
        //   marketVC.scrollToIndex(marketVC.selectedScriptIndex);
        //   // marketVC.update();
        // }
      }
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      if (marketVC.isBuyOpen == -1 && marketVC.isScripDetailOpen == false) {
        if (marketVC.selectedScriptIndex > 0) {
          marketVC.selectedScriptIndex = marketVC.selectedScriptIndex - 1;
          focusNode.requestFocus();

          marketVC.selectedScript.value!.copyObject(ScriptData.fromJson(marketVC.arrScript[marketVC.selectedScriptIndex].toJson()));
          marketVC.selectedScriptForF5.value!.copyObject(ScriptData.fromJson(marketVC.arrScript[marketVC.selectedScriptIndex].toJson()));
          marketVC.upScrollToIndex(marketVC.selectedScriptIndex);
          marketVC.update();
          var indexOfSymbol = marketVC.arrSymbol.indexWhere((element) => marketVC.arrScript[marketVC.selectedScriptIndex].symbol == element.symbolName);
          if (indexOfSymbol != -1) {
            marketVC.selectedSymbol = marketVC.arrSymbol[indexOfSymbol];
            marketVC.update();
          }
        }
        // else if (marketVC.selectedScriptIndex == 0) {
        //   marketVC.selectedScriptIndex = marketVC.arrScript.length - 1;
        //   marketVC.scrollToIndex(marketVC.selectedScriptIndex);
        //   marketVC.update();
        // }
      }
    } else if ((event.isMetaPressed || event.isControlPressed) && event.isKeyPressed(LogicalKeyboardKey.keyX)) {
      if (marketVC.isBuyOpen == -1 && marketVC.isScripDetailOpen == false) {
        if (marketVC.selectedScriptIndex > 0) {}
        if (marketVC.selectedScriptIndex != -1) {
          marketVC.selectedIndexforCut = marketVC.selectedScriptIndex;
          marketVC.selectedIndexforUndo = marketVC.selectedScriptIndex;
          marketVC.update();
        } else {
          showWarningToast("Please selected script for cut");
        }
      }
    } else if ((event.isMetaPressed || event.isControlPressed) && event.isKeyPressed(LogicalKeyboardKey.keyV)) {
      if (marketVC.isBuyOpen == -1 && marketVC.isScripDetailOpen == false) {
        if (marketVC.selectedScriptIndex > 0) {}
        if (marketVC.selectedIndexforCut != -1) {
          final ScriptData item = marketVC.arrScript.removeAt(marketVC.selectedIndexforCut);

          marketVC.arrScript.insert(marketVC.selectedScriptIndex, item);

          final ScriptData preItem = marketVC.arrPreScript.removeAt(marketVC.selectedIndexforCut);

          marketVC.arrPreScript.insert(marketVC.selectedScriptIndex, preItem);

          marketVC.selectedIndexforCut = -1;

          marketVC.selectedIndexforPaste = marketVC.selectedScriptIndex;

          marketVC.storeScripsInDB();
          marketVC.update();
        }
      }
    } else if ((event.isMetaPressed || event.isControlPressed) && event.isKeyPressed(LogicalKeyboardKey.keyZ)) {
      if (marketVC.selectedIndexforUndo != -1) {
        final ScriptData item = marketVC.arrScript.removeAt(marketVC.selectedIndexforPaste);

        marketVC.arrScript.insert(marketVC.selectedIndexforUndo, item);

        final ScriptData preItem = marketVC.arrPreScript.removeAt(marketVC.selectedIndexforPaste);

        marketVC.arrPreScript.insert(marketVC.selectedIndexforUndo, preItem);
        marketVC.selectedIndexforCut = -1;
        marketVC.selectedIndexforPaste = -1;
        marketVC.selectedIndexforUndo = -1;

        marketVC.storeScripsInDB();
        marketVC.update();
      }
    } else {
      if (event is RawKeyDownEvent) {
        if (!event.isAltPressed && !event.isControlPressed && !event.isMetaPressed && !event.isShiftPressed && event.logicalKey.keyLabel.length == 1) {
          marketVC.typedString = marketVC.typedString + event.logicalKey.keyLabel;
          print(marketVC.typedString);
          var index = marketVC.arrSymbol.indexWhere((element) => element.symbolTitle!.toLowerCase().startsWith(marketVC.typedString.toLowerCase()));
          if (index != -1) {
            var scriptValue = marketVC.arrScript[index];
            marketVC.selectedScriptIndex = index;
            marketVC.tempFocus.value.requestFocus();
            marketVC.selectedScript.value!.copyObject(scriptValue);
            marketVC.selectedScriptForF5.value!.copyObject(scriptValue);
            marketVC.selectedScriptForF5.value!.lut = DateTime.now();
            var indexOfSymbol = marketVC.arrSymbol.indexWhere((element) => marketVC.arrScript[index].symbol == element.symbolName);
            if (indexOfSymbol != -1) {
              marketVC.selectedSymbol = marketVC.arrSymbol[indexOfSymbol];
            }

            marketVC.update();
          }
          oneSecondDebouncer.run(() async {
            marketVC.typedString = "";
          });
        }
      }
    }
  }

  handlePositionKeyEvent(RawKeyEvent event) {
    var positionVc = Get.find<PositionController>();

    if (event.isKeyPressed(LogicalKeyboardKey.f1) || event.isKeyPressed(LogicalKeyboardKey.numpadAdd)) {
      if (userData!.role != UserRollList.user) {
        return;
      }
      if (positionVc.selectedScriptIndex != -1) {
        if (positionVc.isBuyOpen == -1) {
          positionVc.isBuyOpen = 1;
          positionVc.qtyController.text = positionVc.arrPositionScriptList[positionVc.selectedScriptIndex].lotSize!.toString();
          positionVc.priceController.text = positionVc.arrPositionScriptList[positionVc.selectedScriptIndex].scriptDataFromSocket.value.bid.toString();
          positionVc.symbolController.text = positionVc.arrPositionScriptList[positionVc.selectedScriptIndex].symbolName ?? "";
          positionVc.exchangeController.text = positionVc.arrPositionScriptList[positionVc.selectedScriptIndex].exchangeName ?? "";
          positionVc.isValidQty = true.obs;
          debouncer.run(() async {
            isKeyPressActive = true;

            positionVc.buySellPopupDialog(isFromBuy: true);
            Future.delayed(Duration(milliseconds: 100), () {
              positionVc.popUpfocusNode.requestFocus();
            });
          });
        }
      }
    } else if (event.isKeyPressed(LogicalKeyboardKey.f2) || event.isKeyPressed(LogicalKeyboardKey.numpadSubtract)) {
      if (userData!.role != UserRollList.user) {
        return;
      }
      if (positionVc.selectedScriptIndex != -1) {
        if (positionVc.isBuyOpen == -1) {
          positionVc.isBuyOpen = 2;
          positionVc.qtyController.text = positionVc.arrPositionScriptList[positionVc.selectedScriptIndex].lotSize!.toString();
          positionVc.priceController.text = positionVc.arrPositionScriptList[positionVc.selectedScriptIndex].scriptDataFromSocket.value.bid.toString();
          positionVc.symbolController.text = positionVc.arrPositionScriptList[positionVc.selectedScriptIndex].symbolName ?? "";
          positionVc.exchangeController.text = positionVc.arrPositionScriptList[positionVc.selectedScriptIndex].exchangeName ?? "";
          positionVc.isValidQty = true.obs;
          debouncer.run(() async {
            isKeyPressActive = true;

            positionVc.buySellPopupDialog(isFromBuy: false);
            Future.delayed(Duration(milliseconds: 100), () {
              positionVc.popUpfocusNode.requestFocus();
            });
          });
        }
      }
    } else if (event.logicalKey.keyLabel == "Escape") {
      if (positionVc.isBuyOpen == -1) {
        debouncer.run(() async {
          onKeyHite();
        });
      } else {
        debouncer.run(() async {
          isKeyPressActive = true;
          positionVc.update();
          positionVc.isBuyOpen = -1;
          Get.back();
        });
      }
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      if (positionVc.isBuyOpen != -1) {
        return;
      }
      if (positionVc.selectedScriptIndex != positionVc.arrPositionScriptList.length - 1) {
        positionVc.selectedScriptIndex = positionVc.selectedScriptIndex + 1;
        // selectedScript!.value = arrPositionScriptList[selectedScriptIndex];

        positionVc.update();
      }
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      if (positionVc.isBuyOpen != -1) {
        return;
      }
      if (positionVc.selectedScriptIndex > 0) {
        positionVc.selectedScriptIndex = positionVc.selectedScriptIndex - 1;
        // selectedScript!.value = arrPositionScriptList[selectedScriptIndex];

        positionVc.update();
      }
    }

    //print(event.logicalKey);
    return KeyEventResult.handled;
  }
}
