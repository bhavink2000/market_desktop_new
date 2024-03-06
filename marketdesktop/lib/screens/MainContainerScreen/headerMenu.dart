import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/navigation/routename.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/BulkTradeScreen/bulkTradeController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/BulkTradeScreen/bulkTradeWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/ClientAccountReportScreen/clientAccountReportWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/SettelmentScreen/settelmentController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/SettelmentScreen/settelmentWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/SymbolWisePositionReportScreen/symbolWisePositionReportController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/SymbolWisePositionReportScreen/symbolWisePositionReportWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/TradeLogScreen/tradeLogController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/TradeLogScreen/tradeLogWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/TradeMarginScreen/tradeMarginListController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/TradeMarginScreen/tradeMarginListWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/historyOfCreditScreen/historyOfCreditController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/historyOfCreditScreen/historyOfCreditWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ToolsTab/ScriptQuantityScreen/ScriptQuantityScreenController.dart';
import 'package:marketdesktop/screens/MainTabs/ToolsTab/ScriptQuantityScreen/ScriptQuantityScreenWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/UserTab/CreateUserScreen/createUserController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/successTradeListController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/successTradeListWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/BillGenerateScreen/billGenerateController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/BillGenerateScreen/billGenerateWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/LogHistoryScreen/logHistoryController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/LogHistoryScreen/logHistoryWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/ScriptMasterScreen/scriptMasterController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/ScriptMasterScreen/scriptMasterWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/UserScriptPositionTrackScreen/userScriptPositionTrackController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/UserScriptPositionTrackScreen/userScriptPostionTrackWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/UserWisePLSummaryScreen/userWisePLSummaryController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/UserWisePLSummaryScreen/userWisePLSummaryWrapper.dart';
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
import 'package:window_size/window_size.dart';
import '../../constant/index.dart';
import 'package:marketdesktop/screens/MainContainerScreen/mainContainerController.dart';
import 'package:web_socket_channel/status.dart' as status;

import '../MainTabs/ReportTab/ClientAccountReportScreen/clientAccountReportController.dart';
import '../MainTabs/ViewTab/ManualOrderscreen/manualOrderController.dart';
import '../MainTabs/ViewTab/ManualOrderscreen/manualOrderWrapper.dart';

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
            label: isMarketSocketConnected.value ? 'Reconnect' : 'Reconnect',
            onPressed: () async {
              if (isMarketSocketConnected.value) {
                socket.channel?.sink.close(status.normalClosure);
                isMarketSocketConnected.value = false;
              } else {
                await socket.connectSocket();
                if (arrSymbolNames.isNotEmpty) {
                  var txt = {"symbols": arrSymbolNames};
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
              isLogoutRunning = true;
              arrSymbolNames.clear();
              socket.channel?.sink.close(status.normalClosure);
              socketIO.socketForTrade.emit('unsubscribe', userData!.userName);
              socketIO.socketForTrade.disconnect();
              socketIO.socketForTrade.dispose();
              Get.find<MarketWatchController>().dbSerivice.closeDatabase();
              // socket.channel = null;
              isMarketSocketConnected.value = false;
              CancelToken().cancel();
              isShowToastAfterLogout = true;

              await windowManager.setFullScreen(false);
              setWindowMinSize(const Size(400, 490));
              Future.delayed(Duration(seconds: 2), () {
                isShowToastAfterLogout = false;
              });
              userData = null;
              Get.offAllNamed(RouterName.signInScreen);
            },
          ),
        ],
      ),
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
                var tradeVC = Get.put(TradeListController());
                generalContainerPopup(view: TradeListScreen(), title: ScreenViewNames.orders, isFilterAvailable: true, filterClick: tradeVC.onCLickFilter, excelClick: tradeVC.onClickExcel, pdfClick: tradeVC.onClickPDF);
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

                var tradeVC = Get.put(SuccessTradeListController());
                generalContainerPopup(view: SuccessTradeListScreen(), title: ScreenViewNames.trades, isFilterAvailable: true, filterClick: tradeVC.onCLickFilter, excelClick: tradeVC.onClickExcel, pdfClick: tradeVC.onClickPDF);
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
                var positionVc = Get.put(PositionController());
                generalContainerPopup(view: PositionScreen(), title: ScreenViewNames.positions, isFilterAvailable: true, filterClick: positionVc.onCLickFilter, excelClick: positionVc.onClickExcel, pdfClick: positionVc.onClickPDF);
              });
            },
          ),
          // if (userData?.role != UserRollList.user && userData?.role != UserRollList.broker)
          //   MenuEntry(
          //     label: ScreenViewNames.profitAndLoss,
          //     onPressed: () {
          //       if (marketViewObj.isBuyOpen != -1) {
          //         return;
          //       }
          //       isCommonScreenPopUpOpen = true;
          //       currentOpenedScreen = ScreenViewNames.profitAndLoss;
          //       var plVC = Get.put(ProfitAndLossController());
          //       generalContainerPopup(view: ProfitAndLossScreen(), title: ScreenViewNames.profitAndLoss, isFilterAvailable: true, filterClick: plVC.onCLickFilter);
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
              var rejectionVC = Get.put(RejectionLogController());
              generalContainerPopup(view: RejectionLogScreen(), title: ScreenViewNames.rejectionLog, isFilterAvailable: true, filterClick: rejectionVC.onCLickFilter, excelClick: rejectionVC.onClickExcel, pdfClick: rejectionVC.onClickPDF);
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
                var createUserVC = Get.find<CreateUserController>();

                dashbaordScreen.isCreateUserClick = true;
                dashbaordScreen.isNotificationSettingClick = false;
                Future.delayed(Duration(milliseconds: 100), () {
                  createUserVC.update();
                });
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
                var userListVC = Get.put(UserListController());
                generalContainerPopup(view: UserListScreen(), title: ScreenViewNames.userList, isFilterAvailable: true, filterClick: userListVC.onCLickFilter, excelClick: userListVC.onClickExcel, pdfClick: userListVC.onClickPDF);
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
          // if (userData?.role != UserRollList.user && userData?.role != UserRollList.broker)
          //   MenuEntry(
          //     label: ScreenViewNames.openPosition,
          //     onPressed: () {
          //       if (marketViewObj.isBuyOpen != -1) {
          //         return;
          //       }
          //       isCommonScreenPopUpOpen = true;
          //       currentOpenedScreen = ScreenViewNames.openPosition;
          //       var openVc = Get.put(OpenPositionController());
          //       generalContainerPopup(view: OpenPositionScreen(), title: ScreenViewNames.openPosition, isFilterAvailable: true, filterClick: openVc.onCLickFilter);
          //     },
          //   ),
          // if (userData?.role != UserRollList.user && userData?.role != UserRollList.broker)
          //   MenuEntry(
          //     label: ScreenViewNames.manageTrades,
          //     onPressed: () {
          //       if (marketViewObj.isBuyOpen != -1) {
          //         return;
          //       }
          //       isCommonScreenPopUpOpen = true;
          //       currentOpenedScreen = ScreenViewNames.manageTrades;
          //       var manageTradeVC = Get.put(ManageTradeController());
          //       generalContainerPopup(view: ManageTradeScreen(), title: ScreenViewNames.manageTrades, isFilterAvailable: true, filterClick: manageTradeVC.onCLickFilter);
          //     },
          //   ),
          if (userData?.role == UserRollList.superAdmin)
            MenuEntry(
              label: ScreenViewNames.bulkTrade,
              onPressed: () {
                if (marketViewObj.isBuyOpen != -1) {
                  return;
                }
                isCommonScreenPopUpOpen = true;
                currentOpenedScreen = ScreenViewNames.bulkTrade;
                var rejectionVC = Get.put(BulkTradeController());
                generalContainerPopup(view: BulkTradeScreen(), title: ScreenViewNames.bulkTrade, isFilterAvailable: true, filterClick: rejectionVC.onCLickFilter, excelClick: rejectionVC.onClickExcel, pdfClick: rejectionVC.onClickPDF);
              },
            ),
          MenuEntry(
            label: ScreenViewNames.tradeLogs,
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              isCommonScreenPopUpOpen = true;
              currentOpenedScreen = ScreenViewNames.tradeLogs;
              var tradeLogVC = Get.put(TradeLogController());
              generalContainerPopup(view: TradeLogScreen(), title: ScreenViewNames.tradeLogs, isFilterAvailable: true, filterClick: tradeLogVC.onCLickFilter, excelClick: tradeLogVC.onClickExcel, pdfClick: tradeLogVC.onClickPDF);
            },
          ),
          // if (userData?.role != UserRollList.user && userData?.role != UserRollList.broker)
          //   MenuEntry(
          //     label: ScreenViewNames.tradeAccount,
          //     onPressed: () {
          //       if (marketViewObj.isBuyOpen != -1) {
          //         return;
          //       }
          //       isCommonScreenPopUpOpen = true;
          //       currentOpenedScreen = ScreenViewNames.tradeAccount;
          //       var tradeAccountVC = Get.put(TradeAccountController());
          //       generalContainerPopup(view: TradeAccountScreen(), title: ScreenViewNames.tradeAccount, isFilterAvailable: true, filterClick: tradeAccountVC.onCLickFilter);
          //     },
          //   ),
          MenuEntry(
            label: ScreenViewNames.clientAccountReport,
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              isCommonScreenPopUpOpen = true;
              currentOpenedScreen = ScreenViewNames.clientAccountReport;
              var clientAccountVC = Get.put(ClientAccountReportController());
              generalContainerPopup(view: ClientAccountReportScreen(), title: ScreenViewNames.clientAccountReport, isFilterAvailable: true, filterClick: clientAccountVC.onCLickFilter, excelClick: clientAccountVC.onClickExcel, pdfClick: clientAccountVC.onClickPDF);
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
              var marginVC = Get.put(TradeMarginController());
              generalContainerPopup(view: TradeMarginScreen(), title: ScreenViewNames.tradeMargin, isFilterAvailable: true, filterClick: marginVC.onCLickFilter, excelClick: marginVC.onClickExcel, pdfClick: marginVC.onClickPDF);
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
                var settlementVC = Get.put(SettlementController());
                generalContainerPopup(view: SettlementScreen(), title: ScreenViewNames.settelment, isFilterAvailable: true, filterClick: settlementVC.onCLickFilter, excelClick: settlementVC.onClickExcel, pdfClick: settlementVC.onClickPDF);
              },
            ),
          MenuEntry(
            label: ScreenViewNames.creditHistory,
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }

              isCommonScreenPopUpOpen = true;
              currentOpenedScreen = ScreenViewNames.creditHistory;
              var accountSummaryVC = Get.put(HistoryOfCreditController());
              generalContainerPopup(view: HistoryOfCreditScreen(), title: ScreenViewNames.creditHistory, isFilterAvailable: true, filterClick: accountSummaryVC.onCLickFilter);
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
              var billVc = Get.put(BillGenerateController());
              generalContainerPopup(view: BillGenerateScreen(), title: ScreenViewNames.billGenerate, isFilterAvailable: true, filterClick: billVc.onCLickFilter);
            },
          ),

          // if (userData?.role != UserRollList.user && userData?.role != UserRollList.broker)
          //   MenuEntry(
          //     label: ScreenViewNames.weeklyAdmin,
          //     onPressed: () {
          //       if (marketViewObj.isBuyOpen != -1) {
          //         return;
          //       }
          //       isCommonScreenPopUpOpen = true;
          //       currentOpenedScreen = ScreenViewNames.weeklyAdmin;
          //       var weeklyVC = Get.put(WeeklyAdminController());
          //       generalContainerPopup(
          //           view: WeeklyAdminScreen(), title: ScreenViewNames.weeklyAdmin, isFilterAvailable: true, filterClick: weeklyVC.onCLickFilter);
          //     },
          //   ),
          MenuEntry(
            label: ScreenViewNames.logsHistory,
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              isCommonScreenPopUpOpen = true;
              currentOpenedScreen = ScreenViewNames.logsHistory;
              var logsVc = Get.put(LogHistoryController());
              generalContainerPopup(view: LogHistoryScreen(), title: ScreenViewNames.logsHistory, isFilterAvailable: true, filterClick: logsVc.onCLickFilter);
            },
          ),
          // if (userData?.role != UserRollList.user && userData?.role != UserRollList.broker)
          //   MenuEntry(
          //     label: ScreenViewNames.pAndlSummary,
          //     onPressed: () {
          //       if (marketViewObj.isBuyOpen != -1) {
          //         return;
          //       }

          //       isCommonScreenPopUpOpen = true;
          //       currentOpenedScreen = ScreenViewNames.pAndlSummary;
          //       var scriptVC = Get.put(ProfitAndLossSummaryController());
          //       generalContainerPopup(view: ProfitAndLossSummaryScreen(), title: ScreenViewNames.pAndlSummary, isFilterAvailable: true, filterClick: scriptVC.onCLickFilter);
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
                var userWiseVC = Get.put(UserWisePLSummaryController());
                generalContainerPopup(view: UserWisePLSummaryScreen(), title: ScreenViewNames.userwisePAndLSummary, isFilterAvailable: true, filterClick: userWiseVC.onCLickFilter);
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
                var trackingVC = Get.put(UserScriptPositionTrackController());
                generalContainerPopup(view: UserScriptPositionTrackScreen(), title: ScreenViewNames.userScriptPositionTracking, isFilterAvailable: true, filterClick: trackingVC.onCLickFilter);
              },
            ),
          if (userData?.role != UserRollList.user && userData?.role != UserRollList.broker)
            MenuEntry(
              label: ScreenViewNames.symbolWisePositionReport,
              onPressed: () {
                if (marketViewObj.isBuyOpen != -1) {
                  return;
                }
                isCommonScreenPopUpOpen = true;
                currentOpenedScreen = ScreenViewNames.symbolWisePositionReport;
                var symbolWiseVC = Get.put(SymbolWisePositionReportController());
                generalContainerPopup(view: SymbolWisePositionReportScreen(), title: ScreenViewNames.symbolWisePositionReport, isFilterAvailable: true, filterClick: symbolWiseVC.onCLickFilter);
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
          // MenuEntry(
          //   label: 'Notification Alert',
          //   onPressed: () {
          //     if (marketViewObj.isBuyOpen != -1) {
          //       return;
          //     }
          //     var dashbaordScreen = Get.find<MainContainerController>();
          //     dashbaordScreen.isCreateUserClick = false;
          //     dashbaordScreen.isNotificationSettingClick = true;
          //     dashbaordScreen.update();
          //   },
          // ),
          MenuEntry(
            label: 'Market Timings',
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              showMarketTimingPopup();
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
                var masterVC = Get.put(ScriptMasterController());
                generalContainerPopup(view: ScriptMasterScreen(), title: ScreenViewNames.scriptMaster, isFilterAvailable: true, filterClick: masterVC.onCLickFilter);
              },
            ),
          MenuEntry(
            label: ScreenViewNames.scriptQty,
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }

              isCommonScreenPopUpOpen = true;
              currentOpenedScreen = ScreenViewNames.scriptQty;
              var masterVC = Get.put(ScriptQuantityController());
              generalContainerPopup(view: ScriptQuantityScreen(), title: ScreenViewNames.scriptQty, isFilterAvailable: true, filterClick: masterVC.onCLickFilter);
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
          MenuEntry(
            label: 'Shortcuts',
            onPressed: () {
              if (marketViewObj.isBuyOpen != -1) {
                return;
              }
              showAppShortcutPopup();
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
