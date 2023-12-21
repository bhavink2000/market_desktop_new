import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/navigation/routename.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/ClientAccountReportScreen/clientAccountReportWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/SettelmentScreen/settelmentController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/SettelmentScreen/settelmentWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/SymbolWisePositionReportScreen/symbolWisePositionReportController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/SymbolWisePositionReportScreen/symbolWisePositionReportWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/TradeLogScreen/tradeLogController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/TradeLogScreen/tradeLogWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/TradeMarginScreen/tradeMarginListController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/TradeMarginScreen/tradeMarginListWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/successTradeListController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/successTradeListWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/AccountSummaryScreen/accountSummaryController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/AccountSummaryScreen/accountSummaryWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/BillGenerateScreen/billGenerateController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/BillGenerateScreen/billGenerateWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/LogHistoryScreen/logHistoryController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/LogHistoryScreen/logHistoryWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/ManageTradeScreen/manageTradeController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/ManageTradeScreen/manageTradeWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/OpenPositionScreen/openPositionController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/OpenPositionScreen/openPositionWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/ProfitAndLossSummaryScreen/profitAndLossSummaryController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/ProfitAndLossSummaryScreen/profitAndLossSummaryWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/ScriptMasterScreen/scriptMasterController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/ScriptMasterScreen/scriptMasterWrapper.dart';

import 'package:marketdesktop/screens/MainTabs/ReportTab/TradeAccountScreen/tradeAccountController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/TradeAccountScreen/tradeAccountWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/UserScriptPositionTrackScreen/userScriptPositionTrackController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/UserScriptPositionTrackScreen/userScriptPostionTrackWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/UserWisePLSummaryScreen/userWisePLSummaryController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/UserWisePLSummaryScreen/userWisePLSummaryWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/WeeklyAdminScreen/weeklyAdminController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/WeeklyAdminScreen/weeklyAdminWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ToolsTab/messagesController.dart';
import 'package:marketdesktop/screens/MainTabs/ToolsTab/messagesWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/UserTab/UserListScreen/userListController.dart';
import 'package:marketdesktop/screens/MainTabs/UserTab/UserListScreen/userListWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/LoginHistoryScreen/loginHistoryController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/LoginHistoryScreen/loginHistoryWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/MarketWatchScreen/marketWatchController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/PositionScreen/positionScreenController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/PositionScreen/positionScreenWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/RejectionLogScreen/rejectionLogController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/RejectionLogScreen/rejectionLogWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/tradeListController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/tradeListWrapper.dart';
import 'package:window_manager/window_manager.dart';
import '../../constant/index.dart';
import 'package:marketdesktop/screens/MainContainerScreen/mainContainerController.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../MainTabs/ReportTab/ClientAccountReportScreen/clientAccountReportController.dart';
import '../MainTabs/ViewTab/ManualOrderscreen/manualOrderController.dart';
import '../MainTabs/ViewTab/ManualOrderscreen/manualOrderWrapper.dart';
import '../MainTabs/ViewTab/ProfitAndLossScreen/profitAndLossController.dart';
import '../MainTabs/ViewTab/ProfitAndLossScreen/profitAndLossWrapper.dart';

class MenuEntry {
  const MenuEntry({required this.label, this.shortcut, this.onPressed, this.menuChildren}) : assert(menuChildren == null || onPressed == null, 'onPressed is ignored if menuChildren are provided');
  final String label;

  final MenuSerializableShortcut? shortcut;
  final VoidCallback? onPressed;
  final List<MenuEntry>? menuChildren;

  static List<Widget> build(List<MenuEntry> selections) {
    Widget buildSelection(MenuEntry selection) {
      if (selection.menuChildren != null) {
        return SubmenuButton(
          menuChildren: MenuEntry.build(selection.menuChildren!),
          style: selection.label != "File" ? null : ButtonStyle(minimumSize: MaterialStateProperty.all(Size(40, 48))),
          child: Text(
            selection.label,
            style: TextStyle(
              fontSize: 12,
              overflow: TextOverflow.ellipsis,
              fontFamily: CustomFonts.family1Medium,
              color: AppColors().darkText,
            ),
          ),
        );
      }
      return MenuItemButton(
          shortcut: selection.shortcut,
          style: selection.label == "Dashboard" ? null : ButtonStyle(minimumSize: MaterialStateProperty.all(Size(200, 35))),
          onPressed: selection.onPressed,
          child: Text(
            selection.label,
            style: TextStyle(
              fontSize: 12,
              overflow: TextOverflow.ellipsis,
              fontFamily: CustomFonts.family1Medium,
              color: AppColors().darkText,
            ),
          ));
    }

    return selections.map<Widget>(buildSelection).toList();
  }

  static Map<MenuSerializableShortcut, Intent> shortcuts(List<MenuEntry> selections) {
    final Map<MenuSerializableShortcut, Intent> result = <MenuSerializableShortcut, Intent>{};
    for (final MenuEntry selection in selections) {
      if (selection.menuChildren != null) {
        result.addAll(MenuEntry.shortcuts(selection.menuChildren!));
      } else {
        if (selection.shortcut != null && selection.onPressed != null) {
          result[selection.shortcut!] = VoidCallbackIntent(selection.onPressed!);
        }
      }
    }
    return result;
  }
}

ShortcutRegistryEntry? _shortcutsEntry;

class MyMenuBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: Obx(() {
            return MenuBar(
              style: MenuStyle(shadowColor: MaterialStatePropertyAll<Color>(Colors.transparent)),
              children: MenuEntry.build(_getMenus(context)),
            );
          }),
        ),
      ],
    );
  }

  List<MenuEntry> _getMenus(BuildContext context) {
    Get.put(MarketWatchController());
    var marketViewObj = Get.find<MarketWatchController>();
    final List<MenuEntry> result = <MenuEntry>[
      MenuEntry(
        label: 'File',
        menuChildren: <MenuEntry>[
          MenuEntry(
            label: isMarketSocketConnected.value ? 'Disconnect' : 'Connect',
            onPressed: () async {
              if (isMarketSocketConnected.value) {
                socket.channel?.sink.close(status.normalClosure);
                isMarketSocketConnected.value = false;
              } else {
                await socket.connectSocket();
                if (socket.arrSymbolNames.isNotEmpty) {
                  var txt = {"symbols": socket.arrSymbolNames};
                  socket.connectScript(jsonEncode(txt));
                }
              }
            },
          ),
          MenuEntry(
            label: 'About',
            onPressed: () {
              showAboutUsPopup();
            },
          ),
          MenuEntry(
            label: 'Change Password',
            onPressed: () {
              showChangePasswordPopUp();
            },
          ),
          MenuEntry(
            label: 'Logout',
            onPressed: () async {
              // GetStorage().erase();
              service.logoutCall();
              socket.arrSymbolNames.clear();
              socket.channel?.sink.close(status.normalClosure);
              socketIO.socketForTrade.emit('unsubscribe', userData!.userName);
              socketIO.socketForTrade.disconnect();
              socketIO.socketForTrade.dispose();
              // socket.channel = null;
              isMarketSocketConnected.value = false;
              CancelToken().cancel();
              isShowToastAfterLogout = true;
              await windowManager.setFullScreen(false);
              Future.delayed(Duration(seconds: 2), () {
                isShowToastAfterLogout = false;
              });
              Get.offAllNamed(RouterName.signInScreen);
            },
          ),
        ],
      ),
      // MenuEntry(
      //   label: 'Dashboard',
      //   // shortcut: const SingleActivator(LogicalKeyboardKey.f9, control: false),
      //   onPressed: () {
      //     var dashBoardVC = Get.find<MainContainerController>();
      //     dashBoardVC.isCreateUserClick = false;
      //     dashBoardVC.isNotificationSettingClick = false;
      //     dashBoardVC.update();

      //     if (!dashBoardVC.arrAvailableTabs.contains("Dashboard")) {
      //       dashBoardVC.arrAvailableTabs.insert(0, "Dashboard");
      //       var marketVC = Get.put(DashboardController());
      //       dashBoardVC.arrAvailableController.insert(0, marketVC);
      //       dashBoardVC.widgetOptions.insert(0, DashboardScreen());
      //       dashBoardVC.selectedCurrentTabIndex = dashBoardVC.widgetOptions.indexWhere(
      //         (element) => element is DashboardScreen,
      //       );
      //       dashBoardVC.selectedCurrentTab = "Dashboard";
      //       dashBoardVC.update();
      //     }
      //   },
      // ),
      MenuEntry(
        label: 'View',
        menuChildren: <MenuEntry>[
          MenuEntry(
            label: ScreenViewNames.orders,
            shortcut: const SingleActivator(LogicalKeyboardKey.f3),
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              if (currentOpenedScreen == ScreenViewNames.orders) {
                return;
              }
              if (isCommonScreenPopUpOpen) {
                Get.find<MainContainerController>().onKeyHite();
              }
              Future.delayed(Duration(milliseconds: 500), () {
                isCommonScreenPopUpOpen = true;

                currentOpenedScreen = ScreenViewNames.orders;
                Get.put(TradeListController());
                generalContainerPopup(view: TradeListScreen(), title: ScreenViewNames.orders);
              });
            },
          ),
          MenuEntry(
            label: ScreenViewNames.trades,
            shortcut: const SingleActivator(LogicalKeyboardKey.f8),
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              if (currentOpenedScreen == ScreenViewNames.trades) {
                return;
              }
              if (isCommonScreenPopUpOpen) {
                Get.find<MainContainerController>().onKeyHite();
              }
              Future.delayed(Duration(milliseconds: 500), () {
                isCommonScreenPopUpOpen = true;
                currentOpenedScreen = ScreenViewNames.trades;
                Get.put(SuccessTradeListController());
                generalContainerPopup(view: SuccessTradeListScreen(), title: ScreenViewNames.trades);
              });
            },
          ),

          MenuEntry(
            label: ScreenViewNames.positions,
            shortcut: const SingleActivator(LogicalKeyboardKey.f6),
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              if (currentOpenedScreen == ScreenViewNames.positions) {
                return;
              }
              if (isCommonScreenPopUpOpen) {
                Get.find<MainContainerController>().onKeyHite();
              }
              Future.delayed(Duration(milliseconds: 500), () {
                isCommonScreenPopUpOpen = true;
                currentOpenedScreen = ScreenViewNames.positions;
                Get.put(PositionController());
                generalContainerPopup(view: PositionScreen(), title: ScreenViewNames.positions);
              });
            },
          ),
          // MenuEntry(
          //   label: 'Dashboard',
          //   // shortcut: const SingleActivator(LogicalKeyboardKey.f9, control: false),
          //   onPressed: () {
          //     var dashBoardVC = Get.find<MainContainerController>();
          //     dashBoardVC.isCreateUserClick = false;
          //     dashBoardVC.isNotificationSettingClick = false;
          //     dashBoardVC.update();

          //     if (!dashBoardVC.arrAvailableTabs.contains("Dashboard")) {
          //       dashBoardVC.arrAvailableTabs.insert(0, "Dashboard");
          //       var marketVC = Get.put(DashboardController());
          //       dashBoardVC.arrAvailableController.insert(0, marketVC);
          //       dashBoardVC.widgetOptions.insert(0, DashboardScreen());
          //       dashBoardVC.selectedCurrentTabIndex = dashBoardVC.widgetOptions.indexWhere(
          //         (element) => element is DashboardScreen,
          //       );
          //       dashBoardVC.selectedCurrentTab = "Dashboard";
          //       dashBoardVC.update();
          //     }
          //   },
          // ),
          if (userData?.role != UserRollList.user && userData?.role != UserRollList.broker)
            MenuEntry(
              label: ScreenViewNames.profitAndLoss,
              onPressed: () {
                if (marketViewObj.isBuyOpen != -1) {
                  return;
                }
                isCommonScreenPopUpOpen = true;
                currentOpenedScreen = ScreenViewNames.profitAndLoss;
                Get.put(ProfitAndLossController());
                generalContainerPopup(view: ProfitAndLossScreen(), title: ScreenViewNames.profitAndLoss);
              },
            ),
          // if (userData?.role != UserRollList.user &&
          //     userData?.role != UserRollList.broker)
          //   MenuEntry(
          //     label: 'M2M Profit & Loss',
          //     onPressed: () {
          //       var dashBoardVC = Get.find<MainContainerController>();
          //       dashBoardVC.isCreateUserClick = false;
          //       dashBoardVC.isNotificationSettingClick = false;
          //       dashBoardVC.update();
          //       if (!dashBoardVC.arrAvailableTabs
          //           .contains("M2M Profit & Loss")) {
          //         dashBoardVC.arrAvailableTabs.insert(0, "M2M Profit & Loss");
          //         var profitAndLossVC = Get.put(M2MProfitAndLossController());
          //         dashBoardVC.arrAvailableController.insert(0, profitAndLossVC);
          //         dashBoardVC.widgetOptions.insert(0, M2MProfitAndLossScreen());
          //         dashBoardVC.selectedCurrentTabIndex =
          //             dashBoardVC.widgetOptions.indexWhere(
          //           (element) => element is M2MProfitAndLossScreen,
          //         );
          //         dashBoardVC.selectedCurrentTab = "M2M Profit & Loss";
          //         dashBoardVC.update();
          //       } else {
          //         dashBoardVC.selectedCurrentTabIndex =
          //             dashBoardVC.widgetOptions.indexWhere(
          //           (element) => element is M2MProfitAndLossScreen,
          //         );
          //         dashBoardVC.selectedCurrentTab = "M2M Profit & Loss";
          //         dashBoardVC.update();
          //       }
          //     },
          //   ),
          MenuEntry(
            label: ScreenViewNames.rejectionLog,
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              isCommonScreenPopUpOpen = true;
              currentOpenedScreen = ScreenViewNames.rejectionLog;
              Get.put(RejectionLogController());
              generalContainerPopup(view: RejectionLogScreen(), title: ScreenViewNames.rejectionLog);
            },
          ),
          MenuEntry(
            label: ScreenViewNames.loginHistory,
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              isCommonScreenPopUpOpen = true;
              currentOpenedScreen = ScreenViewNames.loginHistory;
              Get.put(LoginHistoryController());
              generalContainerPopup(view: LoginHistoryScreen(), title: ScreenViewNames.loginHistory);
            },
          ),
          if (userData!.role == UserRollList.superAdmin || (userData!.role == UserRollList.admin && userData!.manualOrder == 1))
            MenuEntry(
              label: ScreenViewNames.manualOrder,
              onPressed: () {
                if (marketViewObj.isBuyOpen != -1) {
                  return;
                }
                isCommonScreenPopUpOpen = true;
                currentOpenedScreen = ScreenViewNames.manualOrder;
                Get.put(manualOrderController());
                generalContainerPopup(view: ManualOrderScreen(), title: ScreenViewNames.manualOrder);
              },
            ),
        ],
      ),
      if (userData?.role != UserRollList.user && userData?.role != UserRollList.broker)
        MenuEntry(
          label: 'Users',
          menuChildren: <MenuEntry>[
            MenuEntry(
              label: ScreenViewNames.createUser,
              onPressed: () {
                if (marketViewObj.isBuyOpen != -1) {
                  return;
                }
                var dashbaordScreen = Get.find<MainContainerController>();
                dashbaordScreen.isCreateUserClick = true;
                dashbaordScreen.isNotificationSettingClick = false;
                dashbaordScreen.update();
              },
            ),
            MenuEntry(
              label: 'User List',
              onPressed: () {
                if (marketViewObj.isBuyOpen != -1) {
                  return;
                }
                isCommonScreenPopUpOpen = true;
                currentOpenedScreen = ScreenViewNames.userList;
                Get.put(UserListController());
                generalContainerPopup(view: UserListScreen(), title: ScreenViewNames.userList);
              },
            ),
            // MenuEntry(
            //   label: 'Search User',
            //   onPressed: () {},
            // ),
          ],
        ),
      MenuEntry(
        label: 'Report',
        menuChildren: <MenuEntry>[
          if (userData?.role != UserRollList.user && userData?.role != UserRollList.broker)
            MenuEntry(
              label: ScreenViewNames.openPosition,
              onPressed: () {
                if (marketViewObj.isBuyOpen != -1) {
                  return;
                }
                isCommonScreenPopUpOpen = true;
                currentOpenedScreen = ScreenViewNames.openPosition;
                Get.put(OpenPositionController());
                generalContainerPopup(view: OpenPositionScreen(), title: ScreenViewNames.openPosition);
              },
            ),
          if (userData?.role != UserRollList.user && userData?.role != UserRollList.broker)
            MenuEntry(
              label: ScreenViewNames.manageTrades,
              onPressed: () {
                if (marketViewObj.isBuyOpen != -1) {
                  return;
                }
                isCommonScreenPopUpOpen = true;
                currentOpenedScreen = ScreenViewNames.manageTrades;
                Get.put(ManageTradeController());
                generalContainerPopup(view: ManageTradeScreen(), title: ScreenViewNames.manageTrades);
              },
            ),
          // if (userData?.role == UserRollList.master || userData?.role == UserRollList.superAdmin)
          MenuEntry(
            label: ScreenViewNames.tradeLogs,
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              isCommonScreenPopUpOpen = true;
              currentOpenedScreen = ScreenViewNames.tradeLogs;
              Get.put(TradeLogController());
              generalContainerPopup(view: TradeLogScreen(), title: ScreenViewNames.tradeLogs);
            },
          ),
          if (userData?.role != UserRollList.user && userData?.role != UserRollList.broker)
            MenuEntry(
              label: ScreenViewNames.tradeAccount,
              onPressed: () {
                if (marketViewObj.isBuyOpen != -1) {
                  return;
                }
                isCommonScreenPopUpOpen = true;
                currentOpenedScreen = ScreenViewNames.tradeAccount;
                Get.put(TradeAccountController());
                generalContainerPopup(view: TradeAccountScreen(), title: ScreenViewNames.tradeAccount);
              },
            ),
          MenuEntry(
            label: ScreenViewNames.clientAccountReport,
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              isCommonScreenPopUpOpen = true;
              currentOpenedScreen = ScreenViewNames.clientAccountReport;
              Get.put(ClientAccountReportController());
              generalContainerPopup(view: ClientAccountReportScreen(), title: ScreenViewNames.clientAccountReport);
            },
          ),
          MenuEntry(
            label: ScreenViewNames.tradeMargin,
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              isCommonScreenPopUpOpen = true;
              currentOpenedScreen = ScreenViewNames.tradeMargin;
              Get.put(TradeMarginController());
              generalContainerPopup(view: TradeMarginScreen(), title: ScreenViewNames.tradeMargin);
            },
          ),
          if (userData?.role != UserRollList.user && userData?.role != UserRollList.broker)
            MenuEntry(
              label: ScreenViewNames.settelment,
              onPressed: () {
                if (marketViewObj.isBuyOpen != -1) {
                  return;
                }
                isCommonScreenPopUpOpen = true;
                currentOpenedScreen = ScreenViewNames.settelment;
                Get.put(SettlementController());
                generalContainerPopup(view: SettlementScreen(), title: ScreenViewNames.settelment);
              },
            ),
          MenuEntry(
            label: ScreenViewNames.accountSummary,
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }

              isCommonScreenPopUpOpen = true;
              currentOpenedScreen = ScreenViewNames.accountSummary;
              Get.put(AccountSummaryController());
              generalContainerPopup(view: AccountSummaryScreen(), title: ScreenViewNames.accountSummary);
            },
          ),
          MenuEntry(
            label: ScreenViewNames.billGenerate,
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              isCommonScreenPopUpOpen = true;
              currentOpenedScreen = ScreenViewNames.billGenerate;
              Get.put(BillGenerateController());
              generalContainerPopup(view: BillGenerateScreen(), title: ScreenViewNames.billGenerate);
            },
          ),
          // if (userData?.role != UserRollList.user && userData?.role != UserRollList.broker)
          //   MenuEntry(
          //     label: '% Open Position',
          //     onPressed: () {
          //       var dashBoardVC = Get.find<MainContainerController>();
          //       dashBoardVC.isCreateUserClick = false;
          //       dashBoardVC.isNotificationSettingClick = false;
          //       dashBoardVC.update();
          //       if (!dashBoardVC.arrAvailableTabs.contains("% Open Position")) {
          //         dashBoardVC.arrAvailableTabs.insert(0, "% Open Position");
          //         var percentOpenPositionVC = Get.put(PercentOpenPositionController());
          //         dashBoardVC.arrAvailableController.insert(0, percentOpenPositionVC);
          //         dashBoardVC.widgetOptions.insert(0, PercentOpenPositionScreen());
          //         dashBoardVC.selectedCurrentTabIndex = dashBoardVC.widgetOptions.indexWhere(
          //           (element) => element is PercentOpenPositionScreen,
          //         );
          //         dashBoardVC.selectedCurrentTab = "% Open Position";
          //         dashBoardVC.update();
          //       } else {
          //         dashBoardVC.selectedCurrentTabIndex = dashBoardVC.widgetOptions.indexWhere(
          //           (element) => element is PercentOpenPositionScreen,
          //         );
          //         dashBoardVC.selectedCurrentTab = "% Open Position";
          //         dashBoardVC.update();
          //       }
          //     },
          //   ),
          if (userData?.role != UserRollList.user && userData?.role != UserRollList.broker)
            MenuEntry(
              label: ScreenViewNames.weeklyAdmin,
              onPressed: () {
                if (marketViewObj.isBuyOpen != -1) {
                  return;
                }
                isCommonScreenPopUpOpen = true;
                currentOpenedScreen = ScreenViewNames.weeklyAdmin;
                Get.put(WeeklyAdminController());
                generalContainerPopup(view: WeeklyAdminScreen(), title: ScreenViewNames.weeklyAdmin);
              },
            ),
          MenuEntry(
            label: ScreenViewNames.logsHistory,
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              isCommonScreenPopUpOpen = true;
              currentOpenedScreen = ScreenViewNames.logsHistory;
              Get.put(LogHistoryController());
              generalContainerPopup(view: LogHistoryScreen(), title: ScreenViewNames.logsHistory);
            },
          ),
          if (userData?.role != UserRollList.user && userData?.role != UserRollList.broker)
            MenuEntry(
              label: ScreenViewNames.scriptMaster,
              onPressed: () {
                if (marketViewObj.isBuyOpen != -1) {
                  return;
                }

                isCommonScreenPopUpOpen = true;
                currentOpenedScreen = ScreenViewNames.scriptMaster;
                Get.put(ScriptMasterController());
                generalContainerPopup(view: ScriptMasterScreen(), title: ScreenViewNames.scriptMaster);
              },
            ),
          MenuEntry(
            label: 'Scriptwise P&L Summary',
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }

              isCommonScreenPopUpOpen = true;
              currentOpenedScreen = ScreenViewNames.pAndlSummary;
              Get.put(ProfitAndLossSummaryController());
              generalContainerPopup(view: ProfitAndLossSummaryScreen(), title: ScreenViewNames.pAndlSummary);
            },
          ),
          // if (userData?.role != UserRollList.user && userData?.role != UserRollList.broker)
          //   MenuEntry(
          //     label: 'User Logs New',
          //     onPressed: () {
          //       if (marketViewObj.isBuyOpen != -1) {
          //         return;
          //       }
          //       var dashBoardVC = Get.find<MainContainerController>();
          //       dashBoardVC.isCreateUserClick = false;
          //       dashBoardVC.isNotificationSettingClick = false;
          //       dashBoardVC.update();
          //       if (!dashBoardVC.arrAvailableTabs.contains("User Logs New")) {
          //         dashBoardVC.arrAvailableTabs.insert(0, "User Logs New");
          //         var logsHistoryVC = Get.put(LogsHistoryNewController());
          //         dashBoardVC.arrAvailableController.insert(0, logsHistoryVC);
          //         dashBoardVC.widgetOptions.insert(0, LogsHistoryNewScreen());
          //         dashBoardVC.selectedCurrentTabIndex = dashBoardVC.widgetOptions.indexWhere(
          //           (element) => element is LogsHistoryNewScreen,
          //         );
          //         dashBoardVC.selectedCurrentTab = "User Logs New";
          //         dashBoardVC.updateSelectedView();
          //         dashBoardVC.updateUnSelectedView();
          //         dashBoardVC.update();
          //       } else {
          //         dashBoardVC.selectedCurrentTabIndex = dashBoardVC.widgetOptions.indexWhere(
          //           (element) => element is LogsHistoryNewScreen,
          //         );
          //         dashBoardVC.selectedCurrentTab = "User Logs New";
          //         dashBoardVC.updateSelectedView();
          //         dashBoardVC.updateUnSelectedView();
          //         dashBoardVC.update();
          //       }
          //     },
          //   ),
          if (userData?.role != UserRollList.user && userData?.role != UserRollList.broker)
            MenuEntry(
              label: ScreenViewNames.userwisePAndLSummary,
              onPressed: () {
                if (marketViewObj.isBuyOpen != -1) {
                  return;
                }
                isCommonScreenPopUpOpen = true;
                currentOpenedScreen = ScreenViewNames.userwisePAndLSummary;
                Get.put(UserWisePLSummaryController());
                generalContainerPopup(view: UserWisePLSummaryScreen(), title: ScreenViewNames.userwisePAndLSummary);
              },
            ),
          if (userData?.role != UserRollList.user && userData?.role != UserRollList.broker)
            MenuEntry(
              label: ScreenViewNames.userScriptPositionTracking,
              onPressed: () {
                if (marketViewObj.isBuyOpen != -1) {
                  return;
                }
                isCommonScreenPopUpOpen = true;
                currentOpenedScreen = ScreenViewNames.userScriptPositionTracking;
                Get.put(UserScriptPositionTrackController());
                generalContainerPopup(view: UserScriptPositionTrackScreen(), title: ScreenViewNames.userScriptPositionTracking);
              },
            ),
          MenuEntry(
            label: ScreenViewNames.symbolWisePositionReport,
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              isCommonScreenPopUpOpen = true;
              currentOpenedScreen = ScreenViewNames.symbolWisePositionReport;
              Get.put(SymbolWisePositionReportController());
              generalContainerPopup(view: SymbolWisePositionReportScreen(), title: ScreenViewNames.symbolWisePositionReport);
            },
          ),
        ],
      ),
      MenuEntry(
        label: 'Settings',
        menuChildren: <MenuEntry>[
          MenuEntry(
            label: 'Notification Alert',
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              var dashbaordScreen = Get.find<MainContainerController>();
              dashbaordScreen.isCreateUserClick = false;
              dashbaordScreen.isNotificationSettingClick = true;
              dashbaordScreen.update();
            },
          ),
        ],
      ),
      MenuEntry(
        label: 'Tools',
        menuChildren: <MenuEntry>[
          MenuEntry(
            label: 'Status Bar',
            onPressed: () async {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              var dashBoardVC = Get.find<MainContainerController>();
              dashBoardVC.isCreateUserClick = false;
              dashBoardVC.isNotificationSettingClick = false;
              dashBoardVC.update();
              dashBoardVC.isStatusBarVisible = !dashBoardVC.isStatusBarVisible;
              dashBoardVC.update();
            },
          ),
          MenuEntry(
            label: 'Tool Bar',
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              var dashBoardVC = Get.find<MainContainerController>();
              dashBoardVC.isCreateUserClick = false;
              dashBoardVC.isNotificationSettingClick = false;
              dashBoardVC.update();
              dashBoardVC.isToolBarVisible = !dashBoardVC.isToolBarVisible;
              dashBoardVC.update();
            },
          ),
          MenuEntry(
            label: 'Market Timings',
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              showMarketTimingPopup();
            },
          ),
          MenuEntry(
            label: ScreenViewNames.messages,
            shortcut: const SingleActivator(LogicalKeyboardKey.f10, control: false),
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              if (currentOpenedScreen == ScreenViewNames.messages) {
                return;
              }
              if (isCommonScreenPopUpOpen) {
                Get.find<MainContainerController>().onKeyHite();
              }
              Future.delayed(Duration(milliseconds: 500), () {
                isCommonScreenPopUpOpen = true;
                currentOpenedScreen = ScreenViewNames.messages;
                Get.put(MessagesController());
                generalContainerPopup(view: MessagesScreen(), title: ScreenViewNames.messages);
              });
            },
          ),
        ],
      ),
    ];

    _shortcutsEntry?.dispose();
    _shortcutsEntry = ShortcutRegistry.of(context).addAll(MenuEntry.shortcuts(result));
    return result;
  }
}
