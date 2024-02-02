import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:marketdesktop/constant/const_string.dart';
import 'package:marketdesktop/constant/index.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/positionModelClass.dart';
import 'package:marketdesktop/modelClass/superAdminTradePopUpModelClass.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/PositionScreen/positionScreenController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/successTradeListController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/tradeListController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/SuperAdminTradePopUp/superAdminTradePopUpController.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../../modelClass/myTradeListModelClass.dart';
import '../../modelClass/profileInfoModelClass.dart';

class SocketIOService {
  var SERVER_URL = "wss://socket-io.bazaar2.in"; //test url

  late IO.Socket socketForTrade;

  SocketIOService init() {
    log('Connecting to socket service');
    try {
      // socket = IO.io(SERVER_URL, <String, dynamic>{
      //   'transports': ['websocket'],
      //   'autoConnect': true,
      // });
      socketForTrade = IO.io(
        SERVER_URL,
        OptionBuilder().setTransports(["websocket"]).setAuth({
          'token': 'json-web-token',
        }).build(),
      );
      socketForTrade.onConnecting((data) {
        print(data);
      });
      socketForTrade.connect();
      socketForTrade.onConnect((_) {
        log('connected to websocket');
        socketForTrade.emit('unsubscribe', userData!.userName);
        socketForTrade.emit('subscribe', userData!.userName);
      });

      socketForTrade.on("trade", (data) {
        print(data);

        try {
          if (data["userData"] != null) {
            print(data["userData"]);
            var obj = ProfileInfoData.fromJson(data["userData"]);
            if (obj.profitLoss != null && obj.brokerageTotal != null && obj.credit != null && obj.tradeMarginBalance != null) {
              userData!.profitLoss = obj.profitLoss;
              userData!.brokerageTotal = obj.brokerageTotal;
              userData!.credit = obj.credit;
              userData!.marginBalance = obj.marginBalance;
              userData!.tradeMarginBalance = obj.tradeMarginBalance;
              bool isPositionAvailable = Get.isRegistered<PositionController>();
              if (isPositionAvailable) {
                Get.find<PositionController>().update();
              }
            }
          }
          if (data["alertTradeStatus"] == 1) {
            if (userData!.role == UserRollList.superAdmin) {
              var obj = SuperAdminPopUpModel.fromJson(data["alertTradeData"]);
              showSuperAdminTradePopUp();
              isSuperAdminPopUpOpen = true;
              Get.find<SuperAdminTradePopUpController>().values = obj;
              Get.find<SuperAdminTradePopUpController>().update();
              // if (isSuperAdminPopUpOpen) {
              //   Get.back();
              //   showSuperAdminTradePopUp();
              //   isSuperAdminPopUpOpen = true;
              //   Get.find<SuperAdminTradePopUpController>().values = obj;
              //   Get.find<SuperAdminTradePopUpController>().update();
              // } else {
              //   showSuperAdminTradePopUp();
              //   isSuperAdminPopUpOpen = true;
              //   Get.find<SuperAdminTradePopUpController>().values = obj;
              //   Get.find<SuperAdminTradePopUpController>().update();
              // }
            }
          } else {
            if (userData!.role != UserRollList.user) {
              if (data["notificationStatus"] == 1) {
                showSuccessToast(data["notificationMessage"]);
              }
            }

            var obj = TradeData.fromJson(data["trade"]);
            var status = data["tradeStatus"];

            if (obj.status == "executed") {
              bool isTradeAvailable = Get.isRegistered<TradeListController>();
              if (isTradeAvailable) {
                var vcObj = Get.find<TradeListController>();
                print("trade From obj : ${obj.tradeId}");
                if (status == 1) {
                  vcObj.arrTrade.removeWhere((element) => element.tradeId == obj.tradeId);

                  vcObj.update();
                }
              }
              log("***************************************");
              print(data);
              log("***************************************");
              bool isSuccessTradeAvailable = Get.isRegistered<SuccessTradeListController>();
              if (isSuccessTradeAvailable) {
                var vcObj = Get.find<SuccessTradeListController>();
                var isAvailableObj = vcObj.arrTrade.firstWhereOrNull((element) => element.tradeId == obj.tradeId);
                if (isAvailableObj == null) {
                  vcObj.arrTrade.insert(0, obj);
                  vcObj.addSymbolInSocket(obj.symbolName!);
                  vcObj.update();
                }
              }
            } else if (obj.status == "deleted") {
              bool isSuccessTradeAvailable = Get.isRegistered<SuccessTradeListController>();
              if (isSuccessTradeAvailable) {
                var vcObj = Get.find<SuccessTradeListController>();
                var index = vcObj.arrTrade.indexWhere((element) => element.tradeId == obj.tradeId);
                if (index != -1) {
                  vcObj.arrTrade.removeAt(index);

                  vcObj.update();
                }
              }
            } else {
              bool isTradeAvailable = Get.isRegistered<TradeListController>();
              if (isTradeAvailable) {
                var vcObj = Get.find<TradeListController>();
                if (status == 1 || status == 0) {
                  vcObj.arrTrade.removeWhere((element) => element.tradeId == obj.tradeId);
                }
                if (obj.tradeId != null && obj.tradeId != "") {
                  vcObj.arrTrade.insert(0, obj);
                  vcObj.addSymbolInSocket(obj.symbolName!);
                }

                vcObj.update();
              }
            }

            bool isPositionAvailable = Get.isRegistered<PositionController>();
            if (data["position"]["data"] != null) {
              var obj = positionListData.fromJson(data["position"]["data"]);

              if (isPositionAvailable) {
                var vcObj = Get.find<PositionController>();
                var index = vcObj.arrPositionScriptList.indexWhere((element) => obj.symbolId == element.symbolId);
                if (index != -1) {
                  if (data["position"]["positionStatus"] != null && data["position"]["positionStatus"] == 1) {
                    vcObj.arrPositionScriptList.removeAt(index);
                  } else {
                    vcObj.arrPositionScriptList[index] = positionListData.fromJson(data["position"]["data"]);
                    vcObj.update();
                  }
                } else {
                  vcObj.arrPositionScriptList.insert(0, positionListData.fromJson(data["position"]["data"]));
                  var arrTemp = [];
                  for (var element in vcObj.arrPositionScriptList) {
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
              }
            } else {
              var obj = data["position"]["symbolId"] as String;
              if (isPositionAvailable) {
                var vcObj = Get.find<PositionController>();
                var index = vcObj.arrPositionScriptList.indexWhere((element) => obj == element.symbolId);
                if (index != -1) {
                  vcObj.arrPositionScriptList.removeAt(index);
                  vcObj.update();
                }
              }
            }
          }
        } catch (e) {}

        try {
          // log("SOCKET NEW EVENT");
        } catch (e) {
          log(e.toString());
        }
      });

      socketForTrade.onDisconnect((_) async {
        log('Socket disconnect');
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('connected');
          }
        } on SocketException catch (e) {
          print("Ex---------------------");
          print(e);
        }
      });
      socketForTrade.onConnectError((data) => log(data.toString()));
    } catch (e) {
      print(e);
    }

    return this;
  }
}
