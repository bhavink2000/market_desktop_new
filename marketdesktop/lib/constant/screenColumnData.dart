import 'package:marketdesktop/constant/index.dart';
import 'package:marketdesktop/main.dart';

import '../modelClass/tableColumnsModelClass.dart';
import '../service/database/dbService.dart';

class ScreenIds {
  var pendingOrder = 1;
  var trades = 2;
  var netPosition = 3;
  var rejectionLog = 4;
  var loginHistory = 5;
}

class ScreenTitles {
  var pendingOrder = "Pending Orders";
  var trades = "Trades";
  var netPosition = "Net Position";
  var rejectionLog = "Rejection Log";
  var loginHistory = "Login History";
}

class ColumnSizes {
  static const big = 150.0;
  static const small = 63.0;
  static const large = 280.0;
  static const extraLarge = 500.0;
  static const date = 170.0;
  static const smallLarge = 180.0;
  static const normal = 110.0;
}

class PendingOrderColumns {
  static const username = "USERNAME";
  static const parentUser = "PARENT USER";
  static const segment = "SEGMENT";
  static const symbol = "SYMBOL";
  static const bs = "B/S";
  static const qty = "QTY";
  static const lot = "LOT";
  static const price = "PRICE";
  static const orderDT = "ORDER D/T";
  static const type = "TYPE";
  static const cmp = "CMP";
  static const refPrice = "REFERENCE PRICE";
  static const ipAddress = "IP ADDRESS";
  static const device = "DEVICE";
  static const deviceId = "DEVICE ID";
}

class TradeColumns {
  static const checkBox = "";
  static const username = "USERNAME";
  static const parentUser = "PARENT USER";
  static const segment = "SEGMENT";
  static const symbol = "SYMBOL";
  static const bs = "B/S";
  static const qty = "QTY";
  static const lot = "LOT";
  static const type = "TYPE";
  static const tradePrice = "TRADE PRICE";
  static const brk = "BROKERAGE";
  static const priceB = "PRICE(B)";
  static const orderDT = "ORDER D/T";
  static const executionDT = "EXECUTION D/T";
  static const refPrice = "REFERENCE PRICE";
  static const ipAddress = "IP ADDRESS";
  static const device = "DEVICE";
  static const deviceId = "DEVICE ID";
}

class NetPositionColumns {
  static const checkBox = "";
  static const view = "VIEW";
  static const parentUser = "PARENT USER";
  static const exchange = "EXCHANGE";
  static const symbolName = "SYMBOL NAME";
  static const totalBuyAQty = "TOTAL BUY A QTY";
  static const totalBuyAPrice = "TOTAL BUY A PRICE";
  static const totalSellQty = "TOTAL SELL QTY";
  static const sellAPrice = "SELL A PRICE";
  static const netQty = "NET QTY";
  static const netLot = "NET LOT";
  static const netAPrice = "NET A PRICE";
  static const cmp = "CMP";
  static const pl = "P/L";
  static const plPerWise = "P/L % WISE";
}

class RejectionLogColumns {
  static const date = "DATE";
  static const status = "STATUS";
  static const username = "USERNAME";
  static const symbol = "SYMBOL";
  static const type = "TYPE";
  static const qty = "QUANTITY";
  static const price = "PRICE";
  static const ipAddress = "IP ADDRESS";
  static const deviceId = "DEVICE ID";
}

class LoginHistoryColumns {
  static const loginTime = "LOGIN TIME";
  static const logoutTime = "LOGOUT TIME";
  static const username = "USERNAME";
  static const userType = "USER TYPE";
  static const ipAddress = "IP ADDRESS";
  static const deviceId = "DEVICE ID";
}

Future<void> getColumnListFromDB(int screenId, List<ColumnItem> arrList) async {
  var indexOfScreen = getColumnNames().indexWhere(
    (element) {
      return element["screenId"] == screenId;
    },
  );
  (getColumnNames()[indexOfScreen]["columns"] as List).forEach((element) {
    arrList.add(ColumnItem.fromJson(element));
  });
  var values = await DbService().readColumns(screenId);
  if (values.isEmpty) {
    await DbService().addColumns(arrList);
  } else {
    var tempValues = [];
    tempValues.addAll(values);
    for (var i = 0; i < tempValues.length; i++) {
      var isAvailable = arrList.contains(ColumnItem.fromJson(values[i]));
      if (isAvailable == false) {
        await DbService().deleteColumn(tempValues[i]["columnId"]);
        values.removeAt(i);
      }
    }
    for (var i = 0; i < arrList.length; i++) {
      var isAvailable = values.indexWhere((element) => element["title"] == arrList[i].title && element["columnId"] == arrList[i].columnId);
      if (isAvailable == -1) {
        await DbService().addColumns([arrList[i]]);
        values.add(arrList[i].toJson());
      }
    }
    arrList.clear();
    values.forEach((element) {
      arrList.add(ColumnItem.fromJson(element));
    });
  }
  print(values);

  arrList.sort((a, b) {
    return a.position!.compareTo(b.position!);
  });
}

Widget listTitleContent(BaseController controller) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      ReorderableListView.builder(
        scrollDirection: Axis.horizontal,
        buildDefaultDragHandles: false,
        padding: EdgeInsets.zero,
        itemCount: controller.arrListTitle1.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return dynamicTitleBox1(controller.arrListTitle1[index].title ?? "", index, controller.arrListTitle1, controller.isScrollEnable,
              updateCallback: () {
                controller.refreshView();
              },
              isForDate: true,
              isImage: controller.arrListTitle1[index].title!.isEmpty,
              strImage: controller.isAllSelected ? AppImages.checkBoxSelected : AppImages.checkBox,
              onClickImage: () {
                controller.isAllSelected = !controller.isAllSelected;
                controller.update();
                controller.isAllSelectedUpdate(controller.isAllSelected);
              });
        },
        onReorder: (int oldIndex, int newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          var temp = controller.arrListTitle1.removeAt(oldIndex);
          if (newIndex > controller.arrListTitle1.length) {
            newIndex = controller.arrListTitle1.length;
          }
          controller.arrListTitle1.insert(newIndex, temp);
          controller.refreshView();
        },
      ),
    ],
  );
}

List<Map> getColumnNames() {
  return [
    {
      "screenId": ScreenIds().pendingOrder,
      "title": ScreenTitles().pendingOrder,
      "columns": [
        {
          "title": PendingOrderColumns.username,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 0,
          "columnId": "${ScreenIds().pendingOrder}-0",
        },
        {
          "title": PendingOrderColumns.parentUser,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 1,
          "columnId": "${ScreenIds().pendingOrder}1",
        },
        {
          "title": PendingOrderColumns.segment,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 2,
          "columnId": "${ScreenIds().pendingOrder}2",
        },
        {
          "title": PendingOrderColumns.symbol,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 3,
          "columnId": "${ScreenIds().pendingOrder}3",
        },
        {
          "title": PendingOrderColumns.bs,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.small,
          "updatedWidth": ColumnSizes.small,
          "position": 4,
          "columnId": "${ScreenIds().pendingOrder}4",
        },
        {
          "title": PendingOrderColumns.qty,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.small,
          "updatedWidth": ColumnSizes.small,
          "position": 5,
          "columnId": "${ScreenIds().pendingOrder}5",
        },
        {
          "title": PendingOrderColumns.lot,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.small,
          "updatedWidth": ColumnSizes.small,
          "position": 6,
          "columnId": "${ScreenIds().pendingOrder}6",
        },
        {
          "title": PendingOrderColumns.price,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 7,
          "columnId": "${ScreenIds().pendingOrder}7",
        },
        {
          "title": PendingOrderColumns.orderDT,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 8,
          "columnId": "${ScreenIds().pendingOrder}8",
        },
        {
          "title": PendingOrderColumns.type,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 9,
          "columnId": "${ScreenIds().pendingOrder}9",
        },
        {
          "title": PendingOrderColumns.cmp,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 10,
          "columnId": "${ScreenIds().pendingOrder}10",
        },
        {
          "title": PendingOrderColumns.refPrice,
          "screenId": ScreenIds().pendingOrder,
          "width": 220.0,
          "updatedWidth": 220.0,
          "position": 11,
          "columnId": "${ScreenIds().pendingOrder}11",
        },
        {
          "title": PendingOrderColumns.ipAddress,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 12,
          "columnId": "${ScreenIds().pendingOrder}12",
        },
        {
          "title": PendingOrderColumns.device,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 13,
          "columnId": "${ScreenIds().pendingOrder}13",
        },
        {
          "title": PendingOrderColumns.deviceId,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 14,
          "columnId": "${ScreenIds().pendingOrder}14",
        }
      ]
    },
    {
      "screenId": ScreenIds().trades,
      "title": ScreenTitles().trades,
      "columns": [
        if (userData!.role == UserRollList.superAdmin)
          {
            "title": TradeColumns.checkBox,
            "screenId": ScreenIds().trades,
            "width": ColumnSizes.small,
            "updatedWidth": ColumnSizes.small,
            "position": 0,
            "columnId": "${ScreenIds().trades}-0",
          },
        if (userData!.role != UserRollList.user)
          {
            "title": TradeColumns.username,
            "screenId": ScreenIds().trades,
            "width": ColumnSizes.normal,
            "updatedWidth": ColumnSizes.normal,
            "position": 1,
            "columnId": "${ScreenIds().trades}-1",
          },
        if (userData!.role != UserRollList.user)
          {
            "title": TradeColumns.parentUser,
            "screenId": ScreenIds().trades,
            "width": ColumnSizes.big,
            "updatedWidth": ColumnSizes.big,
            "position": 2,
            "columnId": "${ScreenIds().trades}-2",
          },
        {
          "title": TradeColumns.segment,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 3,
          "columnId": "${ScreenIds().trades}-3",
        },
        {
          "title": TradeColumns.symbol,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 4,
          "columnId": "${ScreenIds().trades}-4",
        },
        {
          "title": TradeColumns.bs,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.small,
          "updatedWidth": ColumnSizes.small,
          "position": 5,
          "columnId": "${ScreenIds().trades}-5",
        },
        {
          "title": TradeColumns.qty,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.small,
          "updatedWidth": ColumnSizes.small,
          "position": 6,
          "columnId": "${ScreenIds().trades}-6",
        },
        {
          "title": TradeColumns.lot,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.small,
          "updatedWidth": ColumnSizes.small,
          "position": 7,
          "columnId": "${ScreenIds().trades}-7",
        },
        {
          "title": TradeColumns.type,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 8,
          "columnId": "${ScreenIds().trades}-8",
        },
        {
          "title": TradeColumns.tradePrice,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 9,
          "columnId": "${ScreenIds().trades}-9",
        },
        {
          "title": TradeColumns.brk,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 10,
          "columnId": "${ScreenIds().trades}-10",
        },
        {
          "title": TradeColumns.priceB,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 11,
          "columnId": "${ScreenIds().trades}-11",
        },
        {
          "title": TradeColumns.orderDT,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 12,
          "columnId": "${ScreenIds().trades}-12",
        },
        {
          "title": TradeColumns.executionDT,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 13,
          "columnId": "${ScreenIds().trades}-13",
        },
        {
          "title": TradeColumns.refPrice,
          "screenId": ScreenIds().trades,
          "width": 160.0,
          "updatedWidth": 160.0,
          "position": 14,
          "columnId": "${ScreenIds().trades}-14",
        },
        {
          "title": TradeColumns.ipAddress,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 15,
          "columnId": "${ScreenIds().trades}-15",
        },
        {
          "title": TradeColumns.device,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 16,
          "columnId": "${ScreenIds().trades}-16",
        },
        {
          "title": TradeColumns.deviceId,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 17,
          "columnId": "${ScreenIds().trades}-17",
        }
      ]
    },
    {
      "screenId": ScreenIds().netPosition,
      "title": ScreenTitles().netPosition,
      "columns": [
        if (userData!.role == UserRollList.user)
          {
            "title": NetPositionColumns.checkBox,
            "screenId": ScreenIds().netPosition,
            "width": ColumnSizes.small,
            "updatedWidth": ColumnSizes.small,
            "position": 0,
            "columnId": "${ScreenIds().netPosition}-0",
          },
        if (userData!.role != UserRollList.user)
          {
            "title": NetPositionColumns.view,
            "screenId": ScreenIds().netPosition,
            "width": ColumnSizes.small,
            "updatedWidth": ColumnSizes.small,
            "position": 1,
            "columnId": "${ScreenIds().netPosition}-1",
          },
        {
          "title": NetPositionColumns.exchange,
          "screenId": ScreenIds().netPosition,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 3,
          "columnId": "${ScreenIds().netPosition}-3",
        },
        {
          "title": NetPositionColumns.symbolName,
          "screenId": ScreenIds().netPosition,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 4,
          "columnId": "${ScreenIds().netPosition}-4",
        },
        {
          "title": NetPositionColumns.totalBuyAQty,
          "screenId": ScreenIds().netPosition,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 5,
          "columnId": "${ScreenIds().netPosition}-5",
        },
        {
          "title": NetPositionColumns.totalBuyAPrice,
          "screenId": ScreenIds().netPosition,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 6,
          "columnId": "${ScreenIds().netPosition}-6",
        },
        {
          "title": NetPositionColumns.totalSellQty,
          "screenId": ScreenIds().netPosition,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 7,
          "columnId": "${ScreenIds().netPosition}-7",
        },
        {
          "title": NetPositionColumns.sellAPrice,
          "screenId": ScreenIds().netPosition,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 8,
          "columnId": "${ScreenIds().netPosition}-8",
        },
        {
          "title": NetPositionColumns.netQty,
          "screenId": ScreenIds().netPosition,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 9,
          "columnId": "${ScreenIds().netPosition}-9",
        },
        {
          "title": NetPositionColumns.netLot,
          "screenId": ScreenIds().netPosition,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 10,
          "columnId": "${ScreenIds().netPosition}-10",
        },
        {
          "title": NetPositionColumns.netAPrice,
          "screenId": ScreenIds().netPosition,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 11,
          "columnId": "${ScreenIds().netPosition}-11",
        },
        {
          "title": NetPositionColumns.cmp,
          "screenId": ScreenIds().netPosition,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 12,
          "columnId": "${ScreenIds().netPosition}-12",
        },
        {
          "title": NetPositionColumns.pl,
          "screenId": ScreenIds().netPosition,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 13,
          "columnId": "${ScreenIds().netPosition}-13",
        },
        if (userData!.role != UserRollList.user)
          {
            "title": NetPositionColumns.plPerWise,
            "screenId": ScreenIds().netPosition,
            "width": ColumnSizes.normal,
            "updatedWidth": ColumnSizes.normal,
            "position": 14,
            "columnId": "${ScreenIds().netPosition}-14",
          }
      ]
    },
    {
      "screenId": ScreenIds().rejectionLog,
      "title": ScreenTitles().rejectionLog,
      "columns": [
        {
          "title": RejectionLogColumns.date,
          "screenId": ScreenIds().rejectionLog,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 0,
          "columnId": "${ScreenIds().rejectionLog}-0",
        },
        {
          "title": RejectionLogColumns.status,
          "screenId": ScreenIds().rejectionLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 1,
          "columnId": "${ScreenIds().rejectionLog}-1",
        },
        {
          "title": RejectionLogColumns.username,
          "screenId": ScreenIds().rejectionLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 2,
          "columnId": "${ScreenIds().rejectionLog}-2",
        },
        {
          "title": RejectionLogColumns.symbol,
          "screenId": ScreenIds().rejectionLog,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 3,
          "columnId": "${ScreenIds().rejectionLog}-3",
        },
        {
          "title": RejectionLogColumns.type,
          "screenId": ScreenIds().rejectionLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 4,
          "columnId": "${ScreenIds().rejectionLog}-4",
        },
        {
          "title": RejectionLogColumns.qty,
          "screenId": ScreenIds().rejectionLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 5,
          "columnId": "${ScreenIds().rejectionLog}-5",
        },
        {
          "title": RejectionLogColumns.price,
          "screenId": ScreenIds().rejectionLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 6,
          "columnId": "${ScreenIds().rejectionLog}-6",
        },
        {
          "title": RejectionLogColumns.ipAddress,
          "screenId": ScreenIds().rejectionLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 7,
          "columnId": "${ScreenIds().rejectionLog}-7",
        },
        {
          "title": RejectionLogColumns.deviceId,
          "screenId": ScreenIds().rejectionLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 8,
          "columnId": "${ScreenIds().rejectionLog}-8",
        }
      ]
    },
    {
      "screenId": ScreenIds().loginHistory,
      "title": ScreenTitles().loginHistory,
      "columns": [
        {
          "title": LoginHistoryColumns.loginTime,
          "screenId": ScreenIds().loginHistory,
          "width": ColumnSizes.smallLarge,
          "updatedWidth": ColumnSizes.smallLarge,
          "position": 1,
          "columnId": "${ScreenIds().loginHistory}-0",
        },
        {
          "title": LoginHistoryColumns.logoutTime,
          "screenId": ScreenIds().loginHistory,
          "width": ColumnSizes.smallLarge,
          "updatedWidth": ColumnSizes.smallLarge,
          "position": 0,
          "columnId": "${ScreenIds().loginHistory}-1",
        },
        {
          "title": LoginHistoryColumns.username,
          "screenId": ScreenIds().loginHistory,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 2,
          "columnId": "${ScreenIds().loginHistory}-2",
        },
        {
          "title": LoginHistoryColumns.userType,
          "screenId": ScreenIds().loginHistory,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 3,
          "columnId": "${ScreenIds().loginHistory}-3",
        },
        {
          "title": LoginHistoryColumns.ipAddress,
          "screenId": ScreenIds().loginHistory,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 4,
          "columnId": "${ScreenIds().loginHistory}-4",
        },
        {
          "title": LoginHistoryColumns.deviceId,
          "screenId": ScreenIds().loginHistory,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 5,
          "columnId": "${ScreenIds().loginHistory}-5",
        }
      ]
    }
  ];
}
