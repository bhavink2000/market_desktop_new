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
  var userList = 6;
  var tradeLog = 7;
  var accountReport = 8;
  var tradeMargin = 9;
  var settlement = 10;
  var creditHistory = 11;
  var activityReport = 12;
  var userWisePLSummary = 13;
  var userScriptPositionTracking = 14;
  var symbolWisePositionReport = 15;
  var scriptMaster = 16;
  var scriptQty = 17;
  var message = 18;
  var userPosition = 19;
  var userTrade = 20;
  var userGroupSetting = 21;
  var userQtySetting = 22;
  var userCredit = 23;
  var userRejectionLog = 24;
  var bulkTrade = 25;
}

class ScreenTitles {
  var pendingOrder = "Pending Orders";
  var trades = "Trades";
  var netPosition = "Net Position";
  var rejectionLog = "Rejection Log";
  var loginHistory = "Login History";
  var userList = "User List";
  var tradeLog = "Trade Logs";
  var accountReport = "Account Report";
  var tradeMargin = "Trade Margin";
  var settlement = "Settlement";
  var creditHistory = "Credit History";
  var activityReport = "Activity Report";
  var userWisePLSummary = "Userwise P&L Summary";
  var userScriptPositionTracking = "User Script Psition Tracking";
  var symbolWisePositionReport = "Symbol Wise Position Report";
  var scriptMaster = "Script Master";
  var scriptQty = "Script Quantity";
  var message = "Message";
  var userPosition = "User Position";
  var userTrade = "User Trade";
  var userGroupSetting = "User Group Setting";
  var userQtySetting = "User Quantity Setting";
  var userCredit = "User Credit";
  var userRejectionLog = "User Rejection Log";
  var bulkTrade = "Bulk Trade";
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
  static const sequence = "SEQUENCE";
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
  static const comment = "COMMENT";
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

class UserListColumns {
  static const edit = "EDIT";
  static const more = "...";
  static const username = "USERNAME";
  static const parentUser = "PARENT USER";
  static const type = "TYPE";
  static const name = "NAME";
  static const ourPer = "OUR %";
  static const brkSharing = "BRK SHARING";
  static const leverage = "LEVERAGE";
  static const credit = "CREDIT";
  static const pAndl = "P/L";
  static const equity = "EQUITY";
  static const totalMargin = "TOTAL MARGIN";
  static const usedMargin = "USED MARGIN";
  static const freeMargin = "FREE MARGIN";
  static const bet = "BET";
  static const closeOnly = "CLOSE ONLY";
  static const autoSqroff = "AUTO SQROFF";
  static const viewOnly = "VIEW ONLY";
  static const status = "STATUS";
  static const createdDate = "CREATED DATE";
  static const lastLoginDT = "LAST LOGIN DATE/TIME";
  static const device = "DEVICE";
  static const deviceID = "DEVICE ID";
  static const ipAddress = "IP ADDRESS";
}

class TradeLogsColumns {
  static const username = "USERNAME";
  static const exchange = "EXCHANGE";
  static const symbol = "SYMBOL";
  static const oldUpdateType = "OLD UPDATE TYPE";
  static const updateType = "UPDATE TYPE";
  static const updateTime = "UPDATE TIME";
  static const modifyBy = "MODIFY BY";
}

class AccountReportColumns {
  static const username = "USERNAME";
  static const parentUser = "PARENT USER";
  static const exchange = "EXCHANGE";
  static const symbol = "SYMBOL";
  static const totalBuyQty = "TOTAL BUY QTY";
  static const totalBuyAPrice = "TOTAL BUY A PRICE";
  static const totalSellQty = "TOTAL SELL QTY";
  static const totalSellAPrice = "TOTAL SELL A PRICE";
  static const netQty = "NET QTY";
  static const netAPrice = "NET A PRICE";
  static const cmp = "CMP";
  static const brk = "BROKERAGE";
  static const pAndL = "P/L";
  static const releasepl = "RELEASE P/L";
  static const mtm = "MTM";
  static const mtmWithBrk = "MTM WITH BROKERAGE";
  static const total = "TOTAL";
  static const ourPer = "OUR %";
}

class TradeMarginColumns {
  static const exchange = "EXCHANGE";
  static const script = "SCRIPT";
  static const expiryDate = "EXPIRY DATE";
  static const marginPer = "MARGIN (%)";
  static const marginAmount = "MARGIN (AMOUNT)";
  static const description = "DESCRIPTION";
}

class SettlementColumns {
  static const username = "USERNAME";
  static const pl = "P/L";
  static const brk = "BRK";
  static const total = "TOTAL";
}

class CreditHistoryColumns {
  // static const dateTime = "DATE TIME";
  // static const username = "USERNAME";
  // static const opening = "OPENING";
  // static const amount = "AMOUNT";
  // static const closing = "CLOSING";
  // static const comment = "COMMENT";
  // static const actionBy = "ACTION BY";
  static const username = "USERNAME";
  static const dateTime = "DATE TIME";
  static const type = "TYPE";
  static const amount = "AMOUNT";
  static const balance = "BALANCE";
  static const comments = "COMMENTS";
}

class UserWisePLSummaryColumns {
  static const view = "VIEW";
  static const username = "USERNAME";
  static const sharingPer = "SHARING %";
  static const brkSharingPer = "BRK SHARING %";
  static const releaseClientPL = "RELEASE CLIENT P/L";
  static const clientBrk = "CLIENT BRK";
  static const clientM2M = "CLIENT M2M";
  static const PLWithBrk = "P/L WITH BRK";
  static const PLSharePer = "P/L SHARE %";
  static const brk = "BRK";
  static const netPL = "NET P/L";
}

class UserScriptPositionTrackingColumns {
  static const positionDate = "POSITION DATE";
  static const username = "USERNAME";
  static const symbol = "SYMBOL";
  static const position = "POSITION";
  static const openAPrice = "OPEN A PRICE";
}

class SymbolWisePositionReportColumns {
  static const exchange = "EXCHANGE";

  static const symbol = "SYMBOL";
  static const netQty = "NET QTY";
  static const netQtyPerWise = "NET QTY % WISE";
  static const netAPrice = "NET A PRICE";
  static const brk = "BROKERAGE";
  static const withBrkAPrice = "WITH BROKERAGE A PRICE";
  static const cmp = "CMP";
  static const pl = "P/L";
  static const plPer = "P/L (%)";
  static const brkPer = "BROKERAGE %";
}

class ScriptMasterColumns {
  static const exchange = "EXCHANGE";
  static const script = "SCRIPT";
  static const expiryDate = "EXPIRY DATE";
  static const desc = "DESCRIPTION";
  static const tradeAttribute = "TRADE ATTRIBUTE";
  static const allowTrade = "ALLOW TRADE";
}

class ScriptQtyColumns {
  static const symbol = "SYMBOL";
  static const breakUpQty = "BREAKUP QTY";
  static const maxQty = "MAX QTY";
  static const breakUpLot = "BREAKUP LOT";
  static const maxLot = "MAX LOT";
}

class MessageColumns {
  static const index = "INDEX";
  static const message = "MESSAGE";
  static const receivedOn = "RECEIVED ON";
}

class UserPositionColumns {
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

class UserTradeColumns {
  static const sequence = "SEQUENCE";
  static const username = "USERNAME";
  static const parentUser = "PARENT USER";
  static const segment = "SEGMENT";
  static const symbol = "SYMBOL";
  static const bs = "B/S";
  static const qty = "QTY";
  static const lot = "LOT";
  static const type = "TRADE TYPE";
  static const totalQty = "TOTAL QTY";
  static const validity = "VALIDITY";
  static const tradePrice = "TRADE PRICE";
  static const brk = "BROKERAGE";
  static const netPrice = "NET PRICE";
  static const orderDT = "ORDER D/T";
  static const executionDT = "EXECUTION D/T";
  static const refPrice = "REFERENCE PRICE";
  static const ipAddress = "IP ADDRESS";
  static const device = "DEVICE";
  static const deviceId = "DEVICE ID";
}

class UserGroupSettingColumns {
  static const group = "GROUP";
  static const lastUpdated = "LAST UPDATED";
  static const view = "VIEW";
}

class UserQtySettingColumns {
  static const checkBox = "";
  static const script = "SCRIPT";
  static const lotMax = "LOT MAX";
  static const qtyMax = "QTY MAX";
  static const breakupQty = "BREAKUP QTY";
  static const breakupLot = "BREAKUP LOT";
  static const lastUpdated = "LAST UPDATED";
}

class UserCreditColumns {
  static const dateTime = "DATE TIME";
  static const type = "TYPE";
  static const amount = "AMOUNT";
  static const balance = "BALANCE";
  static const comments = "COMMENTS";
}

class UserRejectionLogColumns {
  static const date = "DATE";
  static const message = "MESSAGE";
  static const username = "USERNAME";
  static const symbol = "SYMBOL";
  static const type = "TYPE";
  static const qty = "QUANTITY";
  static const price = "PRICE";

  static const comment = "COMMENT";
  static const ipAddress = "IP ADDRESS";
  static const deviceId = "DEVICE ID";
}

class BulkTradeColumns {
  static const exchange = "EXCHANGE";
  static const symbol = "SYMBOL";
  static const buyTotalQty = "BUY TOTAL QTY";
  static const sellTotalQty = "SELL TOTAL QTY";
  static const totalQty = "TOTAL QTY";
  static const dateTime = "DATE & TIME";
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
          return controller.isHiddenTitle(controller.arrListTitle1[index].title ?? "")
              ? SizedBox(
                  key: Key("$index"),
                )
              : dynamicTitleBox1(controller.arrListTitle1[index].title ?? "", index, controller.arrListTitle1, controller.isScrollEnable,
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
          "columnId": "${ScreenIds().pendingOrder}-1",
        },
        {
          "title": PendingOrderColumns.segment,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 2,
          "columnId": "${ScreenIds().pendingOrder}-2",
        },
        {
          "title": PendingOrderColumns.symbol,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 3,
          "columnId": "${ScreenIds().pendingOrder}-3",
        },
        {
          "title": PendingOrderColumns.bs,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.small,
          "updatedWidth": ColumnSizes.small,
          "position": 4,
          "columnId": "${ScreenIds().pendingOrder}-4",
        },
        {
          "title": PendingOrderColumns.qty,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.small,
          "updatedWidth": ColumnSizes.small,
          "position": 5,
          "columnId": "${ScreenIds().pendingOrder}-5",
        },
        {
          "title": PendingOrderColumns.lot,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.small,
          "updatedWidth": ColumnSizes.small,
          "position": 6,
          "columnId": "${ScreenIds().pendingOrder}-6",
        },
        {
          "title": PendingOrderColumns.price,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 7,
          "columnId": "${ScreenIds().pendingOrder}-7",
        },
        {
          "title": PendingOrderColumns.orderDT,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 8,
          "columnId": "${ScreenIds().pendingOrder}-8",
        },
        {
          "title": PendingOrderColumns.type,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 9,
          "columnId": "${ScreenIds().pendingOrder}-9",
        },
        {
          "title": PendingOrderColumns.cmp,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 10,
          "columnId": "${ScreenIds().pendingOrder}-10",
        },
        {
          "title": PendingOrderColumns.refPrice,
          "screenId": ScreenIds().pendingOrder,
          "width": 220.0,
          "updatedWidth": 220.0,
          "position": 11,
          "columnId": "${ScreenIds().pendingOrder}-11",
        },
        {
          "title": PendingOrderColumns.ipAddress,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 12,
          "columnId": "${ScreenIds().pendingOrder}-12",
        },
        {
          "title": PendingOrderColumns.device,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 13,
          "columnId": "${ScreenIds().pendingOrder}-13",
        },
        {
          "title": PendingOrderColumns.deviceId,
          "screenId": ScreenIds().pendingOrder,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 14,
          "columnId": "${ScreenIds().pendingOrder}-14",
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
        {
          "title": TradeColumns.sequence,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 1,
          "columnId": "${ScreenIds().trades}-1",
        },
        if (userData!.role != UserRollList.user)
          {
            "title": TradeColumns.username,
            "screenId": ScreenIds().trades,
            "width": ColumnSizes.normal,
            "updatedWidth": ColumnSizes.normal,
            "position": 2,
            "columnId": "${ScreenIds().trades}-2",
          },
        if (userData!.role != UserRollList.user)
          {
            "title": TradeColumns.parentUser,
            "screenId": ScreenIds().trades,
            "width": ColumnSizes.big,
            "updatedWidth": ColumnSizes.big,
            "position": 3,
            "columnId": "${ScreenIds().trades}-3",
          },
        {
          "title": TradeColumns.segment,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 4,
          "columnId": "${ScreenIds().trades}-4",
        },
        {
          "title": TradeColumns.symbol,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 5,
          "columnId": "${ScreenIds().trades}-5",
        },
        {
          "title": TradeColumns.bs,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.small,
          "updatedWidth": ColumnSizes.small,
          "position": 6,
          "columnId": "${ScreenIds().trades}-6",
        },
        {
          "title": TradeColumns.qty,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.small,
          "updatedWidth": ColumnSizes.small,
          "position": 7,
          "columnId": "${ScreenIds().trades}-7",
        },
        {
          "title": TradeColumns.lot,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.small,
          "updatedWidth": ColumnSizes.small,
          "position": 8,
          "columnId": "${ScreenIds().trades}-8",
        },
        {
          "title": TradeColumns.type,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 9,
          "columnId": "${ScreenIds().trades}-9",
        },
        {
          "title": TradeColumns.tradePrice,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 10,
          "columnId": "${ScreenIds().trades}-10",
        },
        {
          "title": TradeColumns.brk,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 11,
          "columnId": "${ScreenIds().trades}-11",
        },
        {
          "title": TradeColumns.priceB,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 12,
          "columnId": "${ScreenIds().trades}-12",
        },
        {
          "title": TradeColumns.orderDT,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 13,
          "columnId": "${ScreenIds().trades}-13",
        },
        {
          "title": TradeColumns.executionDT,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 14,
          "columnId": "${ScreenIds().trades}-14",
        },
        {
          "title": TradeColumns.refPrice,
          "screenId": ScreenIds().trades,
          "width": 160.0,
          "updatedWidth": 160.0,
          "position": 15,
          "columnId": "${ScreenIds().trades}-15",
        },
        {
          "title": TradeColumns.ipAddress,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 16,
          "columnId": "${ScreenIds().trades}-16",
        },
        {
          "title": TradeColumns.device,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 17,
          "columnId": "${ScreenIds().trades}-17",
        },
        {
          "title": TradeColumns.deviceId,
          "screenId": ScreenIds().trades,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 18,
          "columnId": "${ScreenIds().trades}-18",
        }
      ]
    },
    {
      "screenId": ScreenIds().netPosition,
      "title": ScreenTitles().netPosition,
      "columns": [
        if (userData!.role != UserRollList.superAdmin)
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
          "title": RejectionLogColumns.comment,
          "screenId": ScreenIds().rejectionLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 7,
          "columnId": "${ScreenIds().rejectionLog}-7",
        },
        {
          "title": RejectionLogColumns.ipAddress,
          "screenId": ScreenIds().rejectionLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 8,
          "columnId": "${ScreenIds().rejectionLog}-8",
        },
        {
          "title": RejectionLogColumns.deviceId,
          "screenId": ScreenIds().rejectionLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 9,
          "columnId": "${ScreenIds().rejectionLog}-9",
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
        },
      ]
    },
    {
      "screenId": ScreenIds().userList,
      "title": ScreenTitles().userList,
      "columns": [
        {
          "title": UserListColumns.edit,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.small,
          "updatedWidth": ColumnSizes.small,
          "position": 1,
          "columnId": "${ScreenIds().userList}-0",
        },
        {
          "title": UserListColumns.more,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.small,
          "updatedWidth": ColumnSizes.small,
          "position": 2,
          "columnId": "${ScreenIds().userList}-1",
        },
        {
          "title": UserListColumns.username,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 3,
          "columnId": "${ScreenIds().userList}-2",
        },
        {
          "title": UserListColumns.parentUser,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 4,
          "columnId": "${ScreenIds().userList}-3",
        },
        {
          "title": UserListColumns.type,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 5,
          "columnId": "${ScreenIds().userList}-4",
        },
        {
          "title": UserListColumns.name,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 6,
          "columnId": "${ScreenIds().userList}-5",
        },
        {
          "title": UserListColumns.ourPer,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 7,
          "columnId": "${ScreenIds().userList}-6",
        },
        {
          "title": UserListColumns.brkSharing,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 8,
          "columnId": "${ScreenIds().userList}-7",
        },
        {
          "title": UserListColumns.leverage,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 9,
          "columnId": "${ScreenIds().userList}-8",
        },
        {
          "title": UserListColumns.credit,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 10,
          "columnId": "${ScreenIds().userList}-9",
        },
        {
          "title": UserListColumns.pAndl,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 11,
          "columnId": "${ScreenIds().userList}-10",
        },
        {
          "title": UserListColumns.equity,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 12,
          "columnId": "${ScreenIds().userList}-11",
        },
        {
          "title": UserListColumns.totalMargin,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 13,
          "columnId": "${ScreenIds().userList}-12",
        },
        {
          "title": UserListColumns.usedMargin,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 14,
          "columnId": "${ScreenIds().userList}-13",
        },
        {
          "title": UserListColumns.freeMargin,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 15,
          "columnId": "${ScreenIds().userList}-14",
        },
        {
          "title": UserListColumns.bet,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 16,
          "columnId": "${ScreenIds().userList}-15",
        },
        {
          "title": UserListColumns.closeOnly,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 17,
          "columnId": "${ScreenIds().userList}-16",
        },
        {
          "title": UserListColumns.autoSqroff,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 18,
          "columnId": "${ScreenIds().userList}-17",
        },
        {
          "title": UserListColumns.viewOnly,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 19,
          "columnId": "${ScreenIds().userList}-18",
        },
        {
          "title": UserListColumns.status,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 20,
          "columnId": "${ScreenIds().userList}-19",
        },
        {
          "title": UserListColumns.createdDate,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 21,
          "columnId": "${ScreenIds().userList}-20",
        },
        {
          "title": UserListColumns.lastLoginDT,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.large,
          "updatedWidth": ColumnSizes.large,
          "position": 22,
          "columnId": "${ScreenIds().userList}-21",
        },
        {
          "title": UserListColumns.device,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 23,
          "columnId": "${ScreenIds().userList}-22",
        },
        {
          "title": UserListColumns.deviceID,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 24,
          "columnId": "${ScreenIds().userList}-23",
        },
        {
          "title": UserListColumns.ipAddress,
          "screenId": ScreenIds().userList,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 25,
          "columnId": "${ScreenIds().userList}-24",
        },
      ]
    },
    {
      "screenId": ScreenIds().tradeLog,
      "title": ScreenTitles().tradeLog,
      "columns": [
        {
          "title": TradeLogsColumns.username,
          "screenId": ScreenIds().tradeLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 1,
          "columnId": "${ScreenIds().tradeLog}-0",
        },
        {
          "title": TradeLogsColumns.exchange,
          "screenId": ScreenIds().tradeLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 2,
          "columnId": "${ScreenIds().tradeLog}-1",
        },
        {
          "title": TradeLogsColumns.symbol,
          "screenId": ScreenIds().tradeLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 3,
          "columnId": "${ScreenIds().tradeLog}-2",
        },
        {
          "title": TradeLogsColumns.oldUpdateType,
          "screenId": ScreenIds().tradeLog,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 4,
          "columnId": "${ScreenIds().tradeLog}-3",
        },
        {
          "title": TradeLogsColumns.updateType,
          "screenId": ScreenIds().tradeLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 5,
          "columnId": "${ScreenIds().tradeLog}-4",
        },
        {
          "title": TradeLogsColumns.updateTime,
          "screenId": ScreenIds().tradeLog,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 6,
          "columnId": "${ScreenIds().tradeLog}-5",
        },
        {
          "title": TradeLogsColumns.modifyBy,
          "screenId": ScreenIds().tradeLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 7,
          "columnId": "${ScreenIds().tradeLog}-6",
        },
      ]
    },
    {
      "screenId": ScreenIds().accountReport,
      "title": ScreenTitles().accountReport,
      "columns": [
        if (userData!.role != UserRollList.user)
          {
            "title": AccountReportColumns.username,
            "screenId": ScreenIds().accountReport,
            "width": ColumnSizes.normal,
            "updatedWidth": ColumnSizes.normal,
            "position": 1,
            "columnId": "${ScreenIds().accountReport}-0",
          },
        if (userData!.role != UserRollList.user)
          {
            "title": AccountReportColumns.parentUser,
            "screenId": ScreenIds().accountReport,
            "width": ColumnSizes.normal,
            "updatedWidth": ColumnSizes.normal,
            "position": 2,
            "columnId": "${ScreenIds().accountReport}-1",
          },
        {
          "title": AccountReportColumns.exchange,
          "screenId": ScreenIds().accountReport,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 3,
          "columnId": "${ScreenIds().accountReport}-2",
        },
        {
          "title": AccountReportColumns.symbol,
          "screenId": ScreenIds().accountReport,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 4,
          "columnId": "${ScreenIds().accountReport}-3",
        },
        {
          "title": AccountReportColumns.totalBuyQty,
          "screenId": ScreenIds().accountReport,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 5,
          "columnId": "${ScreenIds().accountReport}-4",
        },
        {
          "title": AccountReportColumns.totalBuyAPrice,
          "screenId": ScreenIds().accountReport,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 6,
          "columnId": "${ScreenIds().accountReport}-5",
        },
        {
          "title": AccountReportColumns.totalSellQty,
          "screenId": ScreenIds().accountReport,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 7,
          "columnId": "${ScreenIds().accountReport}-6",
        },
        {
          "title": AccountReportColumns.totalSellAPrice,
          "screenId": ScreenIds().accountReport,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 8,
          "columnId": "${ScreenIds().accountReport}-7",
        },
        {
          "title": AccountReportColumns.netQty,
          "screenId": ScreenIds().accountReport,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 9,
          "columnId": "${ScreenIds().accountReport}-8",
        },
        {
          "title": AccountReportColumns.netAPrice,
          "screenId": ScreenIds().accountReport,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 10,
          "columnId": "${ScreenIds().accountReport}-9",
        },
        {
          "title": AccountReportColumns.cmp,
          "screenId": ScreenIds().accountReport,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 11,
          "columnId": "${ScreenIds().accountReport}-10",
        },
        {
          "title": AccountReportColumns.brk,
          "screenId": ScreenIds().accountReport,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 12,
          "columnId": "${ScreenIds().accountReport}-11",
        },
        {
          "title": AccountReportColumns.pAndL,
          "screenId": ScreenIds().accountReport,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 13,
          "columnId": "${ScreenIds().accountReport}-12",
        },
        {
          "title": AccountReportColumns.releasepl,
          "screenId": ScreenIds().accountReport,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 14,
          "columnId": "${ScreenIds().accountReport}-13",
        },
        {
          "title": AccountReportColumns.mtm,
          "screenId": ScreenIds().accountReport,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 15,
          "columnId": "${ScreenIds().accountReport}-14",
        },
        {
          "title": AccountReportColumns.mtmWithBrk,
          "screenId": ScreenIds().accountReport,
          "width": ColumnSizes.smallLarge,
          "updatedWidth": ColumnSizes.smallLarge,
          "position": 16,
          "columnId": "${ScreenIds().accountReport}-15",
        },
        {
          "title": AccountReportColumns.total,
          "screenId": ScreenIds().accountReport,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 17,
          "columnId": "${ScreenIds().accountReport}-16",
        },
        if (userData!.role != UserRollList.user)
          {
            "title": AccountReportColumns.ourPer,
            "screenId": ScreenIds().accountReport,
            "width": ColumnSizes.normal,
            "updatedWidth": ColumnSizes.normal,
            "position": 18,
            "columnId": "${ScreenIds().accountReport}-17",
          },
      ]
    },
    {
      "screenId": ScreenIds().tradeMargin,
      "title": ScreenTitles().tradeMargin,
      "columns": [
        {
          "title": TradeMarginColumns.exchange,
          "screenId": ScreenIds().tradeMargin,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 1,
          "columnId": "${ScreenIds().tradeMargin}-0",
        },
        {
          "title": TradeMarginColumns.script,
          "screenId": ScreenIds().tradeMargin,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 2,
          "columnId": "${ScreenIds().tradeMargin}-1",
        },
        {
          "title": TradeMarginColumns.expiryDate,
          "screenId": ScreenIds().tradeMargin,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 3,
          "columnId": "${ScreenIds().tradeMargin}-2",
        },
        {
          "title": TradeMarginColumns.marginPer,
          "screenId": ScreenIds().tradeMargin,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 4,
          "columnId": "${ScreenIds().tradeMargin}-3",
        },
        {
          "title": TradeMarginColumns.marginAmount,
          "screenId": ScreenIds().tradeMargin,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 5,
          "columnId": "${ScreenIds().tradeMargin}-4",
        },
        {
          "title": TradeMarginColumns.description,
          "screenId": ScreenIds().tradeMargin,
          "width": ColumnSizes.large,
          "updatedWidth": ColumnSizes.large,
          "position": 6,
          "columnId": "${ScreenIds().tradeMargin}-5",
        },
      ]
    },
    {
      "screenId": ScreenIds().settlement,
      "title": ScreenTitles().settlement,
      "columns": [
        {
          "title": SettlementColumns.username,
          "screenId": ScreenIds().settlement,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 1,
          "columnId": "${ScreenIds().settlement}-0",
        },
        {
          "title": SettlementColumns.pl,
          "screenId": ScreenIds().settlement,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 2,
          "columnId": "${ScreenIds().settlement}-1",
        },
        {
          "title": SettlementColumns.brk,
          "screenId": ScreenIds().settlement,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 3,
          "columnId": "${ScreenIds().settlement}-2",
        },
        {
          "title": SettlementColumns.total,
          "screenId": ScreenIds().settlement,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 4,
          "columnId": "${ScreenIds().settlement}-3",
        },
      ]
    },
    {
      "screenId": ScreenIds().creditHistory,
      "title": ScreenTitles().creditHistory,
      "columns": [
        {
          "title": CreditHistoryColumns.username,
          "screenId": ScreenIds().creditHistory,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 0,
          "columnId": "${ScreenIds().creditHistory}-0",
        },
        {
          "title": CreditHistoryColumns.dateTime,
          "screenId": ScreenIds().creditHistory,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 1,
          "columnId": "${ScreenIds().creditHistory}-1",
        },
        {
          "title": CreditHistoryColumns.type,
          "screenId": ScreenIds().creditHistory,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 2,
          "columnId": "${ScreenIds().creditHistory}-2",
        },
        {
          "title": CreditHistoryColumns.amount,
          "screenId": ScreenIds().creditHistory,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 3,
          "columnId": "${ScreenIds().creditHistory}-3",
        },
        {
          "title": CreditHistoryColumns.balance,
          "screenId": ScreenIds().creditHistory,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 4,
          "columnId": "${ScreenIds().creditHistory}-4",
        },
        {
          "title": CreditHistoryColumns.comments,
          "screenId": ScreenIds().creditHistory,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 5,
          "columnId": "${ScreenIds().creditHistory}-5",
        },
      ]
    },
    {
      "screenId": ScreenIds().userWisePLSummary,
      "title": ScreenTitles().userWisePLSummary,
      "columns": [
        {
          "title": UserWisePLSummaryColumns.view,
          "screenId": ScreenIds().userWisePLSummary,
          "width": ColumnSizes.small,
          "updatedWidth": ColumnSizes.small,
          "position": 1,
          "columnId": "${ScreenIds().userWisePLSummary}-0",
        },
        {
          "title": UserWisePLSummaryColumns.username,
          "screenId": ScreenIds().userWisePLSummary,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 2,
          "columnId": "${ScreenIds().userWisePLSummary}-1",
        },
        {
          "title": UserWisePLSummaryColumns.sharingPer,
          "screenId": ScreenIds().userWisePLSummary,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 3,
          "columnId": "${ScreenIds().userWisePLSummary}-2",
        },
        {
          "title": UserWisePLSummaryColumns.releaseClientPL,
          "screenId": ScreenIds().userWisePLSummary,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 4,
          "columnId": "${ScreenIds().userWisePLSummary}-3",
        },
        {
          "title": UserWisePLSummaryColumns.clientBrk,
          "screenId": ScreenIds().userWisePLSummary,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 5,
          "columnId": "${ScreenIds().userWisePLSummary}-4",
        },
        {
          "title": UserWisePLSummaryColumns.clientM2M,
          "screenId": ScreenIds().userWisePLSummary,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 6,
          "columnId": "${ScreenIds().userWisePLSummary}-5",
        },
        {
          "title": UserWisePLSummaryColumns.PLWithBrk,
          "screenId": ScreenIds().userWisePLSummary,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 7,
          "columnId": "${ScreenIds().userWisePLSummary}-6",
        },
        {
          "title": UserWisePLSummaryColumns.PLSharePer,
          "screenId": ScreenIds().userWisePLSummary,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 8,
          "columnId": "${ScreenIds().userWisePLSummary}-7",
        },
        {
          "title": UserWisePLSummaryColumns.brk,
          "screenId": ScreenIds().userWisePLSummary,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 9,
          "columnId": "${ScreenIds().userWisePLSummary}-8",
        },
        {
          "title": UserWisePLSummaryColumns.netPL,
          "screenId": ScreenIds().userWisePLSummary,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 10,
          "columnId": "${ScreenIds().userWisePLSummary}-9",
        },
      ]
    },
    {
      "screenId": ScreenIds().userScriptPositionTracking,
      "title": ScreenTitles().userScriptPositionTracking,
      "columns": [
        {
          "title": UserScriptPositionTrackingColumns.positionDate,
          "screenId": ScreenIds().userScriptPositionTracking,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 1,
          "columnId": "${ScreenIds().userScriptPositionTracking}-0",
        },
        {
          "title": UserScriptPositionTrackingColumns.username,
          "screenId": ScreenIds().userScriptPositionTracking,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 2,
          "columnId": "${ScreenIds().userScriptPositionTracking}-1",
        },
        {
          "title": UserScriptPositionTrackingColumns.symbol,
          "screenId": ScreenIds().userScriptPositionTracking,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 3,
          "columnId": "${ScreenIds().userScriptPositionTracking}-2",
        },
        {
          "title": UserScriptPositionTrackingColumns.position,
          "screenId": ScreenIds().userScriptPositionTracking,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 4,
          "columnId": "${ScreenIds().userScriptPositionTracking}-3",
        },
        {
          "title": UserScriptPositionTrackingColumns.openAPrice,
          "screenId": ScreenIds().userScriptPositionTracking,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 5,
          "columnId": "${ScreenIds().userScriptPositionTracking}-4",
        },
      ]
    },
    {
      "screenId": ScreenIds().symbolWisePositionReport,
      "title": ScreenTitles().symbolWisePositionReport,
      "columns": [
        {
          "title": SymbolWisePositionReportColumns.exchange,
          "screenId": ScreenIds().symbolWisePositionReport,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 1,
          "columnId": "${ScreenIds().symbolWisePositionReport}-0",
        },
        {
          "title": SymbolWisePositionReportColumns.symbol,
          "screenId": ScreenIds().symbolWisePositionReport,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 2,
          "columnId": "${ScreenIds().symbolWisePositionReport}-1",
        },
        {
          "title": SymbolWisePositionReportColumns.netQty,
          "screenId": ScreenIds().symbolWisePositionReport,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 3,
          "columnId": "${ScreenIds().symbolWisePositionReport}-2",
        },
        {
          "title": SymbolWisePositionReportColumns.netQtyPerWise,
          "screenId": ScreenIds().symbolWisePositionReport,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 4,
          "columnId": "${ScreenIds().symbolWisePositionReport}-3",
        },
        {
          "title": SymbolWisePositionReportColumns.netAPrice,
          "screenId": ScreenIds().symbolWisePositionReport,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 5,
          "columnId": "${ScreenIds().symbolWisePositionReport}-4",
        },
        {
          "title": SymbolWisePositionReportColumns.brk,
          "screenId": ScreenIds().symbolWisePositionReport,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 6,
          "columnId": "${ScreenIds().symbolWisePositionReport}-5",
        },
        {
          "title": SymbolWisePositionReportColumns.withBrkAPrice,
          "screenId": ScreenIds().symbolWisePositionReport,
          "width": ColumnSizes.large,
          "updatedWidth": ColumnSizes.large,
          "position": 7,
          "columnId": "${ScreenIds().symbolWisePositionReport}-6",
        },
        {
          "title": SymbolWisePositionReportColumns.cmp,
          "screenId": ScreenIds().symbolWisePositionReport,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 8,
          "columnId": "${ScreenIds().symbolWisePositionReport}-7",
        },
        {
          "title": SymbolWisePositionReportColumns.pl,
          "screenId": ScreenIds().symbolWisePositionReport,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 9,
          "columnId": "${ScreenIds().symbolWisePositionReport}-8",
        },
        {
          "title": SymbolWisePositionReportColumns.plPer,
          "screenId": ScreenIds().symbolWisePositionReport,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 10,
          "columnId": "${ScreenIds().symbolWisePositionReport}-9",
        },
        {
          "title": SymbolWisePositionReportColumns.brkPer,
          "screenId": ScreenIds().symbolWisePositionReport,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 11,
          "columnId": "${ScreenIds().symbolWisePositionReport}-10",
        },
      ]
    },
    {
      "screenId": ScreenIds().scriptMaster,
      "title": ScreenTitles().scriptMaster,
      "columns": [
        {
          "title": ScriptMasterColumns.exchange,
          "screenId": ScreenIds().scriptMaster,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 1,
          "columnId": "${ScreenIds().scriptMaster}-0",
        },
        {
          "title": ScriptMasterColumns.script,
          "screenId": ScreenIds().scriptMaster,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 2,
          "columnId": "${ScreenIds().scriptMaster}-1",
        },
        {
          "title": ScriptMasterColumns.expiryDate,
          "screenId": ScreenIds().scriptMaster,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 3,
          "columnId": "${ScreenIds().scriptMaster}-2",
        },
        {
          "title": ScriptMasterColumns.desc,
          "screenId": ScreenIds().scriptMaster,
          "width": ColumnSizes.smallLarge,
          "updatedWidth": ColumnSizes.smallLarge,
          "position": 4,
          "columnId": "${ScreenIds().scriptMaster}-3",
        },
        {
          "title": ScriptMasterColumns.tradeAttribute,
          "screenId": ScreenIds().scriptMaster,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 5,
          "columnId": "${ScreenIds().scriptMaster}-4",
        },
        {
          "title": ScriptMasterColumns.allowTrade,
          "screenId": ScreenIds().scriptMaster,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 6,
          "columnId": "${ScreenIds().scriptMaster}-5",
        },
      ]
    },
    {
      "screenId": ScreenIds().scriptQty,
      "title": ScreenTitles().scriptQty,
      "columns": [
        {
          "title": ScriptQtyColumns.symbol,
          "screenId": ScreenIds().scriptQty,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 1,
          "columnId": "${ScreenIds().scriptQty}-0",
        },
        {
          "title": ScriptQtyColumns.breakUpQty,
          "screenId": ScreenIds().scriptQty,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 2,
          "columnId": "${ScreenIds().scriptQty}-1",
        },
        {
          "title": ScriptQtyColumns.maxQty,
          "screenId": ScreenIds().scriptQty,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 3,
          "columnId": "${ScreenIds().scriptQty}-2",
        },
        {
          "title": ScriptQtyColumns.breakUpLot,
          "screenId": ScreenIds().scriptQty,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 4,
          "columnId": "${ScreenIds().scriptQty}-3",
        },
        {
          "title": ScriptQtyColumns.maxLot,
          "screenId": ScreenIds().scriptQty,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 5,
          "columnId": "${ScreenIds().scriptQty}-4",
        },
      ]
    },
    {
      "screenId": ScreenIds().message,
      "title": ScreenTitles().message,
      "columns": [
        {
          "title": MessageColumns.index,
          "screenId": ScreenIds().message,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 1,
          "columnId": "${ScreenIds().message}-0",
        },
        {
          "title": MessageColumns.message,
          "screenId": ScreenIds().message,
          "width": ColumnSizes.extraLarge,
          "updatedWidth": ColumnSizes.extraLarge,
          "position": 2,
          "columnId": "${ScreenIds().message}-1",
        },
        {
          "title": MessageColumns.receivedOn,
          "screenId": ScreenIds().message,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 3,
          "columnId": "${ScreenIds().message}-2",
        },
      ]
    },
    {
      "screenId": ScreenIds().userPosition,
      "title": ScreenTitles().userPosition,
      "columns": [
        {
          "title": NetPositionColumns.exchange,
          "screenId": ScreenIds().userPosition,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 1,
          "columnId": "${ScreenIds().userPosition}-0",
        },
        {
          "title": NetPositionColumns.symbolName,
          "screenId": ScreenIds().userPosition,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 2,
          "columnId": "${ScreenIds().userPosition}-1",
        },
        {
          "title": NetPositionColumns.totalBuyAQty,
          "screenId": ScreenIds().userPosition,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 3,
          "columnId": "${ScreenIds().userPosition}-2",
        },
        {
          "title": NetPositionColumns.totalBuyAPrice,
          "screenId": ScreenIds().userPosition,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 4,
          "columnId": "${ScreenIds().userPosition}-3",
        },
        {
          "title": NetPositionColumns.totalSellQty,
          "screenId": ScreenIds().userPosition,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 5,
          "columnId": "${ScreenIds().userPosition}-4",
        },
        {
          "title": NetPositionColumns.sellAPrice,
          "screenId": ScreenIds().userPosition,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 6,
          "columnId": "${ScreenIds().userPosition}-5",
        },
        {
          "title": NetPositionColumns.netQty,
          "screenId": ScreenIds().userPosition,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 7,
          "columnId": "${ScreenIds().userPosition}-6",
        },
        {
          "title": NetPositionColumns.netLot,
          "screenId": ScreenIds().userPosition,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 8,
          "columnId": "${ScreenIds().userPosition}-7",
        },
        {
          "title": NetPositionColumns.netAPrice,
          "screenId": ScreenIds().userPosition,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 9,
          "columnId": "${ScreenIds().userPosition}-8",
        },
        {
          "title": NetPositionColumns.cmp,
          "screenId": ScreenIds().userPosition,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 10,
          "columnId": "${ScreenIds().userPosition}-9",
        },
        {
          "title": NetPositionColumns.pl,
          "screenId": ScreenIds().userPosition,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 11,
          "columnId": "${ScreenIds().userPosition}-10",
        },
        if (userData!.role != UserRollList.user)
          {
            "title": NetPositionColumns.plPerWise,
            "screenId": ScreenIds().userPosition,
            "width": ColumnSizes.normal,
            "updatedWidth": ColumnSizes.normal,
            "position": 12,
            "columnId": "${ScreenIds().userPosition}-11",
          }
      ]
    },
    {
      "screenId": ScreenIds().userTrade,
      "title": ScreenTitles().userTrade,
      "columns": [
        {
          "title": UserTradeColumns.sequence,
          "screenId": ScreenIds().userTrade,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 0,
          "columnId": "${ScreenIds().userTrade}-0",
        },
        {
          "title": UserTradeColumns.username,
          "screenId": ScreenIds().userTrade,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 1,
          "columnId": "${ScreenIds().userTrade}-1",
        },
        if (userData!.role != UserRollList.user)
          {
            "title": UserTradeColumns.parentUser,
            "screenId": ScreenIds().userTrade,
            "width": ColumnSizes.big,
            "updatedWidth": ColumnSizes.big,
            "position": 2,
            "columnId": "${ScreenIds().userTrade}-2",
          },
        {
          "title": UserTradeColumns.segment,
          "screenId": ScreenIds().userTrade,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 3,
          "columnId": "${ScreenIds().userTrade}-3",
        },
        {
          "title": UserTradeColumns.symbol,
          "screenId": ScreenIds().userTrade,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 4,
          "columnId": "${ScreenIds().userTrade}-4",
        },
        if (userData!.role != UserRollList.user)
          {
            "title": UserTradeColumns.bs,
            "screenId": ScreenIds().userTrade,
            "width": ColumnSizes.small,
            "updatedWidth": ColumnSizes.small,
            "position": 5,
            "columnId": "${ScreenIds().userTrade}-5",
          },
        if (userData!.role != UserRollList.user)
          {
            "title": UserTradeColumns.type,
            "screenId": ScreenIds().userTrade,
            "width": ColumnSizes.normal,
            "updatedWidth": ColumnSizes.normal,
            "position": 6,
            "columnId": "${ScreenIds().userTrade}-6",
          },
        {
          "title": UserTradeColumns.qty,
          "screenId": ScreenIds().userTrade,
          "width": ColumnSizes.small,
          "updatedWidth": ColumnSizes.small,
          "position": 7,
          "columnId": "${ScreenIds().userTrade}-7",
        },
        {
          "title": UserTradeColumns.lot,
          "screenId": ScreenIds().userTrade,
          "width": ColumnSizes.small,
          "updatedWidth": ColumnSizes.small,
          "position": 8,
          "columnId": "${ScreenIds().userTrade}-8",
        },
        {
          "title": UserTradeColumns.totalQty,
          "screenId": ScreenIds().userTrade,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 9,
          "columnId": "${ScreenIds().userTrade}-9",
        },
        {
          "title": UserTradeColumns.validity,
          "screenId": ScreenIds().userTrade,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 10,
          "columnId": "${ScreenIds().userTrade}-10",
        },
        {
          "title": UserTradeColumns.tradePrice,
          "screenId": ScreenIds().userTrade,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 11,
          "columnId": "${ScreenIds().userTrade}-11",
        },
        {
          "title": UserTradeColumns.brk,
          "screenId": ScreenIds().userTrade,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 12,
          "columnId": "${ScreenIds().userTrade}-12",
        },
        {
          "title": UserTradeColumns.netPrice,
          "screenId": ScreenIds().userTrade,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 13,
          "columnId": "${ScreenIds().userTrade}-13",
        },
        {
          "title": UserTradeColumns.orderDT,
          "screenId": ScreenIds().userTrade,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 14,
          "columnId": "${ScreenIds().userTrade}-14",
        },
        {
          "title": UserTradeColumns.executionDT,
          "screenId": ScreenIds().userTrade,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 15,
          "columnId": "${ScreenIds().userTrade}-15",
        },
        {
          "title": UserTradeColumns.refPrice,
          "screenId": ScreenIds().userTrade,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 16,
          "columnId": "${ScreenIds().userTrade}-16",
        },
        {
          "title": UserTradeColumns.ipAddress,
          "screenId": ScreenIds().userTrade,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 17,
          "columnId": "${ScreenIds().userTrade}-17",
        },
        {
          "title": UserTradeColumns.device,
          "screenId": ScreenIds().userTrade,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 18,
          "columnId": "${ScreenIds().userTrade}-18",
        },
        {
          "title": UserTradeColumns.deviceId,
          "screenId": ScreenIds().userTrade,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 19,
          "columnId": "${ScreenIds().userTrade}-19",
        }
      ]
    },
    {
      "screenId": ScreenIds().userGroupSetting,
      "title": ScreenTitles().userGroupSetting,
      "columns": [
        {
          "title": UserGroupSettingColumns.group,
          "screenId": ScreenIds().userGroupSetting,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 1,
          "columnId": "${ScreenIds().userGroupSetting}-0",
        },
        {
          "title": UserGroupSettingColumns.lastUpdated,
          "screenId": ScreenIds().userGroupSetting,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 2,
          "columnId": "${ScreenIds().userGroupSetting}-1",
        },
        {
          "title": UserGroupSettingColumns.view,
          "screenId": ScreenIds().userGroupSetting,
          "width": ColumnSizes.small,
          "updatedWidth": ColumnSizes.small,
          "position": 3,
          "columnId": "${ScreenIds().userGroupSetting}-2",
        },
      ]
    },
    {
      "screenId": ScreenIds().userQtySetting,
      "title": ScreenTitles().userQtySetting,
      "columns": [
        {
          "title": UserQtySettingColumns.checkBox,
          "screenId": ScreenIds().userQtySetting,
          "width": ColumnSizes.small,
          "updatedWidth": ColumnSizes.small,
          "position": 1,
          "columnId": "${ScreenIds().userQtySetting}-0",
        },
        {
          "title": UserQtySettingColumns.script,
          "screenId": ScreenIds().userQtySetting,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 2,
          "columnId": "${ScreenIds().userQtySetting}-1",
        },
        {
          "title": UserQtySettingColumns.lotMax,
          "screenId": ScreenIds().userQtySetting,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 3,
          "columnId": "${ScreenIds().userQtySetting}-2",
        },
        {
          "title": UserQtySettingColumns.qtyMax,
          "screenId": ScreenIds().userQtySetting,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 4,
          "columnId": "${ScreenIds().userQtySetting}-3",
        },
        {
          "title": UserQtySettingColumns.breakupQty,
          "screenId": ScreenIds().userQtySetting,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 5,
          "columnId": "${ScreenIds().userQtySetting}-4",
        },
        {
          "title": UserQtySettingColumns.breakupLot,
          "screenId": ScreenIds().userQtySetting,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 6,
          "columnId": "${ScreenIds().userQtySetting}-5",
        },
        {
          "title": UserQtySettingColumns.lastUpdated,
          "screenId": ScreenIds().userQtySetting,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 7,
          "columnId": "${ScreenIds().userQtySetting}-6",
        },
      ]
    },
    {
      "screenId": ScreenIds().userCredit,
      "title": ScreenTitles().userCredit,
      "columns": [
        {
          "title": UserCreditColumns.dateTime,
          "screenId": ScreenIds().userCredit,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 1,
          "columnId": "${ScreenIds().userCredit}-0",
        },
        {
          "title": UserCreditColumns.type,
          "screenId": ScreenIds().userCredit,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 2,
          "columnId": "${ScreenIds().userCredit}-1",
        },
        {
          "title": UserCreditColumns.amount,
          "screenId": ScreenIds().userCredit,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 3,
          "columnId": "${ScreenIds().userCredit}-2",
        },
        {
          "title": UserCreditColumns.balance,
          "screenId": ScreenIds().userCredit,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 4,
          "columnId": "${ScreenIds().userCredit}-3",
        },
        {
          "title": UserCreditColumns.comments,
          "screenId": ScreenIds().userCredit,
          "width": ColumnSizes.large,
          "updatedWidth": ColumnSizes.large,
          "position": 5,
          "columnId": "${ScreenIds().userCredit}-4",
        },
      ]
    },
    {
      "screenId": ScreenIds().userRejectionLog,
      "title": ScreenTitles().userRejectionLog,
      "columns": [
        {
          "title": UserRejectionLogColumns.date,
          "screenId": ScreenIds().userRejectionLog,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 1,
          "columnId": "${ScreenIds().userRejectionLog}-0",
        },
        {
          "title": UserRejectionLogColumns.message,
          "screenId": ScreenIds().userRejectionLog,
          "width": ColumnSizes.large,
          "updatedWidth": ColumnSizes.large,
          "position": 2,
          "columnId": "${ScreenIds().userRejectionLog}-1",
        },
        {
          "title": UserRejectionLogColumns.username,
          "screenId": ScreenIds().userRejectionLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 3,
          "columnId": "${ScreenIds().userRejectionLog}-2",
        },
        {
          "title": UserRejectionLogColumns.symbol,
          "screenId": ScreenIds().userRejectionLog,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 4,
          "columnId": "${ScreenIds().userRejectionLog}-3",
        },
        {
          "title": UserRejectionLogColumns.type,
          "screenId": ScreenIds().userRejectionLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 5,
          "columnId": "${ScreenIds().userRejectionLog}-4",
        },
        {
          "title": UserRejectionLogColumns.qty,
          "screenId": ScreenIds().userRejectionLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 6,
          "columnId": "${ScreenIds().userRejectionLog}-5",
        },
        {
          "title": UserRejectionLogColumns.price,
          "screenId": ScreenIds().userRejectionLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 7,
          "columnId": "${ScreenIds().userRejectionLog}-6",
        },
        {
          "title": UserRejectionLogColumns.comment,
          "screenId": ScreenIds().userRejectionLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 8,
          "columnId": "${ScreenIds().userRejectionLog}-7",
        },
        {
          "title": UserRejectionLogColumns.ipAddress,
          "screenId": ScreenIds().userRejectionLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 9,
          "columnId": "${ScreenIds().userRejectionLog}-8",
        },
        {
          "title": UserRejectionLogColumns.deviceId,
          "screenId": ScreenIds().userRejectionLog,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 10,
          "columnId": "${ScreenIds().userRejectionLog}-9",
        },
      ]
    },
    {
      "screenId": ScreenIds().bulkTrade,
      "title": ScreenTitles().bulkTrade,
      "columns": [
        {
          "title": BulkTradeColumns.exchange,
          "screenId": ScreenIds().bulkTrade,
          "width": ColumnSizes.normal,
          "updatedWidth": ColumnSizes.normal,
          "position": 1,
          "columnId": "${ScreenIds().bulkTrade}-0",
        },
        {
          "title": BulkTradeColumns.symbol,
          "screenId": ScreenIds().bulkTrade,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 2,
          "columnId": "${ScreenIds().bulkTrade}-1",
        },
        {
          "title": BulkTradeColumns.buyTotalQty,
          "screenId": ScreenIds().bulkTrade,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 3,
          "columnId": "${ScreenIds().bulkTrade}-2",
        },
        {
          "title": BulkTradeColumns.sellTotalQty,
          "screenId": ScreenIds().bulkTrade,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 4,
          "columnId": "${ScreenIds().bulkTrade}-3",
        },
        {
          "title": BulkTradeColumns.totalQty,
          "screenId": ScreenIds().bulkTrade,
          "width": ColumnSizes.big,
          "updatedWidth": ColumnSizes.big,
          "position": 5,
          "columnId": "${ScreenIds().bulkTrade}-4",
        },
        {
          "title": BulkTradeColumns.dateTime,
          "screenId": ScreenIds().bulkTrade,
          "width": ColumnSizes.date,
          "updatedWidth": ColumnSizes.date,
          "position": 6,
          "columnId": "${ScreenIds().bulkTrade}-5",
        },
      ]
    },
  ];
}
