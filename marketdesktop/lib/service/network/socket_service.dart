import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/ManageTradeScreen/manageTradeController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/OpenPositionScreen/openPositionController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/SymbolWisePositionReportScreen/symbolWisePositionReportController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/UserWisePLSummaryScreen/userWisePLSummaryController.dart';
import 'package:marketdesktop/screens/MainTabs/ReportTab/WeeklyAdminScreen/weeklyAdminController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/MarketWatchScreen/marketWatchController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/PositionScreen/positionScreenController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/successTradeListController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/tradeListController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/OpenPositionPopUpScreen/openPositionPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/PositionPopUp/positionPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/TradeListPopUp/tradeListPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/userWisePLSummaryPopUp/userWisePLSummaryPopUpController.dart';
import '../../constant/const_string.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/status.dart' as status;

import '../../modelClass/getScriptFromSocket.dart';
import '../../screens/MainTabs/ReportTab/ClientAccountReportScreen/clientAccountReportController.dart';
import '../../screens/MainTabs/ReportTab/ProfitAndLossSummaryScreen/profitAndLossSummaryController.dart';
import '../../screens/MainTabs/ViewTab/ProfitAndLossScreen/profitAndLossController.dart';

var bouncer = Debouncer(milliseconds: 2000);

class SocketService {
  WebSocketChannel? channel;

  connectSocket() async {
    try {
      // channel = IOWebSocketChannel.connect(
      //   'ws://16.171.242.99:7722/data',
      //   headers: {"Authorization": "Bearer ${GetStorage().read(LocalStorageKeys.userToken)}"},
      // );
      // channel = IOWebSocketChannel.connect(
      //   'ws://16.16.188.77:7722/data',
      //   headers: {"Authorization": "Bearer ${GetStorage().read(LocalStorageKeys.userToken)}"},
      // );
      channel = IOWebSocketChannel.connect(
        'ws://socket-2110916353.eu-north-1.elb.amazonaws.com:7722/data',
        headers: {
          "Authorization":
              "Bearer ${GetStorage().read(LocalStorageKeys.userToken)}"
        },
      );

      print({
        "Authorization":
            "Bearer ${GetStorage().read(LocalStorageKeys.userToken)}"
      });
      await channel?.ready;
      isMarketSocketConnected.value = true;
      // Future.delayed(Duration(seconds: 2), () {
      //   showWarningToast("Socket ready for listen");
      // });

      channel?.stream.listen(
        (event) {
          // print(event);
          log(event.toString());
          bool isHomeVcAvailable = Get.isRegistered<MarketWatchController>();
          bool isPositionAvailable = Get.isRegistered<PositionController>();
          bool isPositionPopUpAvailable =
              Get.isRegistered<PositionPopUpController>();
          bool isOpenPositionAvailable =
              Get.isRegistered<OpenPositionController>();
          bool isTradePopUpAvailable =
              Get.isRegistered<TradeListPopUpController>();
          bool isTradeAvailable = Get.isRegistered<TradeListController>();
          bool isSuccessTradeAvailable =
              Get.isRegistered<SuccessTradeListController>();
          bool isManageTradeAvailable =
              Get.isRegistered<ManageTradeController>();

          bool isWeeklyAdminAvailable =
              Get.isRegistered<WeeklyAdminController>();
          bool isUSerWisePlAvailable =
              Get.isRegistered<UserWisePLSummaryController>();
          bool isPlAvailable = Get.isRegistered<ProfitAndLossController>();
          bool isSymbolWisePlAvailable =
              Get.isRegistered<ProfitAndLossSummaryController>();
          bool isOpenPositionPopUpAvailable =
              Get.isRegistered<OpenPositionPopUpController>();
          bool isAccountSummaryNewAvailable =
              Get.isRegistered<ClientAccountReportController>();
          bool isSymbolWisePositionAvailable =
              Get.isRegistered<SymbolWisePositionReportController>();
          bool isUserWisePLSummaryPopUpControllerAvailable =
              Get.isRegistered<UserWisePLSummaryPopUpController>();

          if (isUserWisePLSummaryPopUpControllerAvailable) {
            var homeVC = Get.find<UserWisePLSummaryPopUpController>();

            homeVC.listenUserWiseProfitLossScriptFromSocket(
                GetScriptFromSocket.fromJson(jsonDecode(event)));
          }
          if (isAccountSummaryNewAvailable) {
            var homeVC = Get.find<ClientAccountReportController>();

            homeVC.listenClientAccountScriptFromSocket(
                GetScriptFromSocket.fromJson(jsonDecode(event)));
          }
          if (isSymbolWisePositionAvailable) {
            var homeVC = Get.find<SymbolWisePositionReportController>();

            homeVC.listenSymbolWisePositionScriptFromSocket(
                GetScriptFromSocket.fromJson(jsonDecode(event)));
          }
          if (isHomeVcAvailable) {
            var homeVC = Get.find<MarketWatchController>();

            homeVC.listenScriptFromSocket(
                GetScriptFromSocket.fromJson(jsonDecode(event)));
          }
          if (isTradeAvailable) {
            var tradeVC = Get.find<TradeListController>();
            tradeVC.listenTradeScriptFromSocket(
                GetScriptFromSocket.fromJson(jsonDecode(event)));
          }
          if (isSuccessTradeAvailable) {
            var tradeVC = Get.find<SuccessTradeListController>();
            tradeVC.listenSuccessTradeScriptFromSocket(
                GetScriptFromSocket.fromJson(jsonDecode(event)));
          }
          if (isManageTradeAvailable) {
            var tradeVC = Get.find<ManageTradeController>();
            tradeVC.listenSuccessTradeScriptFromSocket(
                GetScriptFromSocket.fromJson(jsonDecode(event)));
          }
          if (isPositionAvailable) {
            var tradeVC = Get.find<PositionController>();
            tradeVC.listenPositionScriptFromSocket(
                GetScriptFromSocket.fromJson(jsonDecode(event)));
          }
          if (isOpenPositionPopUpAvailable) {
            var tradeVC = Get.find<OpenPositionPopUpController>();
            tradeVC.listenPositionScriptFromSocket(
                GetScriptFromSocket.fromJson(jsonDecode(event)));
          }
          if (isUSerWisePlAvailable) {
            var tradeVC = Get.find<UserWisePLSummaryController>();
            tradeVC.listenUserWiseProfitLossScriptFromSocket(
                GetScriptFromSocket.fromJson(jsonDecode(event)));
          }
          if (isPlAvailable) {
            var tradeVC = Get.find<ProfitAndLossController>();
            tradeVC.listenUserWiseProfitLossScriptFromSocket(
                GetScriptFromSocket.fromJson(jsonDecode(event)));
          }
          if (isSymbolWisePlAvailable) {
            var tradeVC = Get.find<ProfitAndLossSummaryController>();
            tradeVC.listenSymbolWiseProfitLossScriptFromSocket(
                GetScriptFromSocket.fromJson(jsonDecode(event)));
          }
          if (isPositionPopUpAvailable) {
            var tradeVC = Get.find<PositionPopUpController>();
            tradeVC.listenPositionPopUpScriptFromSocket(
                GetScriptFromSocket.fromJson(jsonDecode(event)));
          }
          if (isTradePopUpAvailable) {
            var tradeVC = Get.find<TradeListPopUpController>();
            tradeVC.listenTradePopUpScriptFromSocket(
                GetScriptFromSocket.fromJson(jsonDecode(event)));
          }
          if (isOpenPositionAvailable) {
            var tradeVC = Get.find<OpenPositionController>();
            tradeVC.listenOpenPositionScriptFromSocket(
                GetScriptFromSocket.fromJson(jsonDecode(event)));
          }
          if (isWeeklyAdminAvailable) {
            var tradeVC = Get.find<WeeklyAdminController>();
            tradeVC.listenWeeklyAdminScriptFromSocket(
                GetScriptFromSocket.fromJson(jsonDecode(event)));
          }
          // else {
          //   channel?.sink.close(status.goingAway);
          // }
        },
        onDone: () {
          print("here");
          if (isLogoutRunning == false) {
            socket.channel?.sink.close(status.normalClosure);
            bouncer.run(() async {
              await socket.connectSocket();
              var txt = {"symbols": arrSymbolNames};
              if (arrSymbolNames.isNotEmpty) {
                socket.connectScript(jsonEncode(txt));
              }
            });
          }
        },
        onError: (err) => {
          isMarketSocketConnected.value = false,
          print('onError: Will close WebSocket: ${channel?.closeReason}'),
        },
        cancelOnError: false,
      );
    } catch (e) {
      print(e);
      showWarningToast(e.toString());
    }
  }

  connectScript(String symbols) async {
    try {
      channel?.sink.add(symbols);
    } catch (e) {
      // await socket.connectSocket();
      // socket.connectScript(symbols);
      print("socketDisconnected123");
      print(e);
    }
  }
}
