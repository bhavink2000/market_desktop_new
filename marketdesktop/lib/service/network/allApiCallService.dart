// ignore_for_file: unused_local_variable

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:marketdesktop/modelClass/expiryListModelClass.dart';
import 'package:marketdesktop/modelClass/groupListModelClass.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/accountSummaryModelClass.dart';
import 'package:marketdesktop/modelClass/addSymbolToTabModelClass.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/billGenerateModelClass.dart';
import 'package:marketdesktop/modelClass/brokerListModelClass.dart';
import 'package:marketdesktop/modelClass/changePasswordModelClass.dart';
import 'package:marketdesktop/modelClass/commonModelClass.dart';
import 'package:marketdesktop/modelClass/createUserModelClass.dart';
import 'package:marketdesktop/modelClass/creditListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeAllowModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/groupSettingListModelClass.dart';
import 'package:marketdesktop/modelClass/holidayListModelClass.dart';
import 'package:marketdesktop/modelClass/loginHistoryModelClass.dart';
import 'package:marketdesktop/modelClass/m2mProfitLossModelClass.dart';
import 'package:marketdesktop/modelClass/marketTimingModelClass.dart';
import 'package:marketdesktop/modelClass/notificationListModelClass.dart';
import 'package:marketdesktop/modelClass/positionTrackListModelClass.dart';
import 'package:marketdesktop/modelClass/profileInfoModelClass.dart';
import 'package:marketdesktop/modelClass/quantitySettingListMmodelClass.dart';
import 'package:marketdesktop/modelClass/rejectLogLisTModelClass.dart';
import 'package:marketdesktop/modelClass/scriptQuantityModelClass.dart';
import 'package:marketdesktop/modelClass/serverNameModelClass.dart';
import 'package:marketdesktop/modelClass/settelementListModelClass.dart';
import 'package:marketdesktop/modelClass/signInModelClass.dart';
import 'package:marketdesktop/modelClass/strikePriceModelClass.dart';
import 'package:marketdesktop/modelClass/symbolWisePlListModelClass.dart';
import 'package:marketdesktop/modelClass/tabListModelClass.dart';
import 'package:marketdesktop/modelClass/tradeDetailModelClass.dart';
import 'package:marketdesktop/modelClass/tradeLogsModelClass.dart';
import 'package:marketdesktop/modelClass/tradeMarginListModelClass.dart';
import 'package:marketdesktop/modelClass/userLogListModelClass.dart';
import 'package:marketdesktop/modelClass/userRoleListModelClass.dart';
import 'package:marketdesktop/modelClass/userWiseProfitLossSummaryModelClass.dart';
import 'package:marketdesktop/modelClass/userwiseBrokerageListModelClass.dart';
import 'package:marketdesktop/modelClass/weeklyAdminModelClass.dart';
import 'package:path_provider/path_provider.dart';
import '../../constant/const_string.dart';

import '../../modelClass/accountSummaryNewListModelClass.dart';
import '../../modelClass/bulkTradeModelClass.dart';
import '../../modelClass/constantModelClass.dart';
import '../../modelClass/myTradeListModelClass.dart';
import '../../modelClass/myUserListModelClass.dart';
import '../../modelClass/notificationSettingModelClass.dart';
import '../../modelClass/positionModelClass.dart';
import '../../modelClass/profitLossListModelClass.dart';
import '../../modelClass/squareOffPositionRequestModelClass.dart';
import '../../modelClass/tabWiseSymbolListModelClass.dart';
import '../../modelClass/tradeExecuteModelClass.dart';
import 'api.dart';
import 'apiService.dart';

class AllApiCallService {
  static final _dio = ApiService.dio;

  Future<ConstantListModel?> getConstantCall() async {
    try {
      _dio.options.headers = getHeaders();

      final data = await _dio.post(Api.getConstant, data: null);
      // print(data.data);
      return ConstantListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<ServerNameModel?> getServerNameCall() async {
    try {
      _dio.options.headers = getHeaders();

      final data = await _dio.get(Api.getServerName);
      //print(data.data);
      return ServerNameModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<AccountSummaryNewListModel?> accountSummaryNewListCall(
    int page,
    String search, {
    String userId = "",
    String exchangeId = "",
    String symbolId = "",
    String startDate = "",
    String endDate = "",
    String productType = "",
  }) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {
        "page": page,
        "limit": pageLimit,
        "search": search,
        "userId": userId,
        "startDate": startDate,
        "endDate": endDate,
        "symbolId": symbolId,
        "exchangeId": exchangeId,
        "productType": productType,
      };
      print(payload);
      final data = await _dio.post(Api.accountSummaryNewList, data: payload);
      print(data.data);
      return AccountSummaryNewListModel.fromJson(data.data);
    } catch (e) {
      return null;
    }
  }

  Future<AccountSummaryNewListModel?> symbolWisePositionListCall(
    int page,
    String search, {
    String userId = "",
    String exchangeId = "",
    String symbolId = "",
    String startDate = "",
    String endDate = "",
    String productType = "",
  }) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {
        "page": page,
        "limit": pageLimit,
        "search": search,
        "userId": userId,
        "startDate": startDate,
        "endDate": endDate,
        "symbolId": symbolId,
        "exchangeId": exchangeId,
        "productType": productType,
      };
      print(payload);
      final data = await _dio.post(Api.symbolWisePositionReport, data: payload);
      print(data.data);
      return AccountSummaryNewListModel.fromJson(data.data);
    } catch (e) {
      return null;
    }
  }

  Future<CommonModel?> rollOverTradeCall({
    List<String>? symbolId,
    String? userId,
  }) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "symbolId": symbolId,
        "userId": userId,
        "ipAddress": myIpAddress,
        "deviceId": deviceId,
        "orderMethod": deviceName,
      };

      print(payload);
      final data = await _dio.post(Api.tradeRollOver, data: payload);
      print(data.data);
      return CommonModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<CommonModel?> userChangeStatusCall({
    Map<String, Object?>? payload,
  }) async {
    try {
      _dio.options.headers = getHeaders();

      print(payload);
      final data = await _dio.post(Api.userChangeStatus, data: payload);
      print(data.data);
      return CommonModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<CommonModel?> tradeDeleteCall({
    List<String>? tradeId,
  }) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "tradeId": tradeId,
      };

      //print(payload);
      final data = await _dio.post(Api.tradeDelete, data: payload);
      //print(data.data);
      return CommonModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<LoginModel?> signInCall({String? userName, String? password, String? serverName}) async {
    try {
      _dio.options.headers = getHeaders();

      final payload = {"userName": userName, "password": password, "serverName": serverName, "deviceToken": "xxxxx", "loginBy": deviceName, 'deviceId': deviceId, "ip": myIpAddress, "systemToken": "", "deviceType": deviceName};

      final data = await _dio.post(Api.login, data: payload);
      print(data.data);
      return LoginModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<TradeExecuteModel?> tradeCall({String? symbolId, double? quantity, double? totalQuantity, double? price, int? lotSize, String? orderType, String? tradeType, String? exchangeId, bool? isFromStopLoss, double? marketPrice, String? productType, double? refPrice}) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "symbolId": symbolId,
        "quantity": quantity,
        "totalQuantity": totalQuantity,
        "price": orderType == "limit" ? price : marketPrice,
        "lotSize": lotSize,
        "stopLoss": isFromStopLoss == true ? price : "0",
        "orderType": orderType,
        "tradeType": tradeType,
        "exchangeId": exchangeId,
        "productType": productType,
        "ipAddress": myIpAddress,
        'deviceId': deviceId,
        "orderMethod": deviceName,
        "referencePrice": refPrice,
      };
      print(payload);
      final data = await _dio.post(Api.createTrade, data: payload);
      print("--------------------------------");
      print(data.data);
      return TradeExecuteModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<TradeExecuteModel?> modifyTradeCall({String? symbolId, double? quantity, double? totalQuantity, double? price, double? lotSize, String? orderType, String? tradeType, String? exchangeId, double? marketPrice, String? productType, String? tradeId, double? refPrice}) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "tradeId": tradeId,
        "symbolId": symbolId,
        "quantity": quantity,
        "totalQuantity": totalQuantity,
        "price": marketPrice,
        "lotSize": lotSize,
        "stopLoss": "0",
        "orderType": orderType,
        "tradeType": tradeType,
        "exchangeId": exchangeId,
        "productType": productType,
        "ipAddress": myIpAddress,
        'deviceId': deviceId,
        "orderMethod": deviceName,
        "referencePrice": refPrice,
      };
      print(payload);
      final data = await _dio.post(Api.modifyTrade, data: payload);
      print("--------------------------------");
      print(data.data);
      return TradeExecuteModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<TradeExecuteModel?> manualTradeCall(
      {String? userId,
      String? symbolId,
      double? quantity,
      double? totalQuantity,
      double? price,
      int? lotSize,
      String? orderType,
      String? tradeType,
      String? exchangeId,
      String? executionTime,
      String? manuallyTradeAddedFor,
      bool? isFromStopLoss,
      double? marketPrice,
      String? productType,
      double? refPrice}) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "userId": userId,
        "symbolId": symbolId,
        "quantity": quantity,
        "totalQuantity": totalQuantity,
        "price": orderType == "limit" ? price : marketPrice,
        "stopLoss": isFromStopLoss == true ? price : "0",
        "lotSize": lotSize,
        "orderType": orderType,
        "tradeType": tradeType,
        "exchangeId": exchangeId,
        "productType": productType,
        "ipAddress": myIpAddress,
        "deviceId": deviceId,
        "orderMethod": deviceName,
        "executionDateTime": executionTime,
        if (manuallyTradeAddedFor != null) "manuallyTradeAddedFor": manuallyTradeAddedFor,
        "referencePrice": refPrice,
      };
      print(payload);
      final data = await _dio.post(Api.manualOrderCreate, data: payload);
      print(data.data);
      return TradeExecuteModel.fromJson(data.data);
    } catch (e) {
      print(e);
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<TradeExecuteModel?> manualTradeFromSACall(
      {String? userId,
      String? symbolId,
      double? quantity,
      double? totalQuantity,
      double? price,
      int? lotSize,
      int? isBrokerageCalculatedOrNot,
      String? orderType,
      String? tradeType,
      String? exchangeId,
      String? executionTime,
      String? manuallyTradeAddedFor,
      bool? isFromStopLoss,
      double? marketPrice,
      String? productType,
      double? refPrice}) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "userId": userId,
        "symbolId": symbolId,
        "quantity": quantity,
        "totalQuantity": totalQuantity,
        "price": price,
        "lotSize": lotSize,
        "orderType": orderType,
        "tradeType": tradeType,
        "exchangeId": exchangeId,
        "productType": "longTerm",
        "ipAddress": myIpAddress,
        "deviceId": deviceId,
        "orderMethod": deviceName,
        "executionDateTime": executionTime,
        "isBrokerageCalculatedOrNot": isBrokerageCalculatedOrNot,
        if (manuallyTradeAddedFor != null) "manuallyTradeAddedFor": manuallyTradeAddedFor,
        "referencePrice": refPrice,
      };
      print(payload);
      final data = await _dio.post(Api.manualOrderCreate, data: payload);
      print(data.data);
      return TradeExecuteModel.fromJson(data.data);
    } catch (e) {
      print(e);
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<MyTradeListModel?> getMyTradeListCall({
    String? status,
    String? tradeStatus,
    int? page,
    String? text,
    String? userId,
    String? symbolId,
    String? exchangeId,
    String? startDate,
    String? endDate,
    String? orderType,
    String? tradeTypeFilter,
  }) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "status": status,
        "page": page,
        "limit": pageLimit,
        "search": text,
        "userId": userId ?? "",
        "symbolId": symbolId ?? "",
        "exchangeId": exchangeId ?? "",
        "startDate": startDate,
        "endDate": endDate,
        "orderTypeFilter": orderType,
        "tradeStatusFilter": tradeStatus,
        "tradeTypeFilter": tradeTypeFilter,
      };
      print(payload);
      final data = await _dio.post(Api.myTradeList, data: payload);
      print(data.data);
      return MyTradeListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<MyTradeListModel?> getManageTradeListCall({
    int? page,
    String? text,
    String? userId,
    String? symbolId,
    String? exchangeId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "page": page,
        "limit": pageLimit,
        "search": text,
        "userId": userId ?? "",
        "symbolId": symbolId ?? "",
        "exchangeId": exchangeId ?? "",
        "startDate": startDate,
        "endDate": endDate,
      };

      final data = await _dio.post(Api.manageTrade, data: payload);
      print(data.data);
      return MyTradeListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<PositionTrackListModel?> positionTrackingListCall({
    int? page,
    String? text,
    String? userId,
    String? symbolId,
    String? exchangeId,
    String? endDate,
  }) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "page": page,
        "limit": pageLimit,
        "search": text,
        "userId": userId ?? "",
        "symbolId": symbolId ?? "",
        "exchangeId": exchangeId ?? "",
        "endDate": endDate,
      };

      final data = await _dio.post(Api.positionTracking, data: payload);
      print(data.data);
      return PositionTrackListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<RejectLogListModel?> getRejectLogListCall({
    int? page,
    String? text,
    String? userId,
    String? symbolId,
    String? exchangeId,
    String? startDate,
    String? endDate,
    String? status,
  }) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "page": page,
        "limit": pageLimit,
        "status": userData!.role == UserRollList.superAdmin ? status : "rejected",
        "search": text,
        "userId": userId ?? "",
        "symbolId": symbolId ?? "",
        "exchangeId": exchangeId ?? "",
        "startDate": startDate,
        "endDate": endDate,
      };

      final data = await _dio.post(Api.rejectLog, data: payload);
      //print(data.data);
      return RejectLogListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<GroupSettingListModel?> groupSettingListCall({
    int? page,
    String? text,
    String? userId,
    String? groupId,
  }) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {"page": page, "limit": pageLimit, "search": text, "sortKey": "createdAt", "sortBy": -1, "groupId": groupId, "userId": userId};

      final data = await _dio.post(Api.groupSettingList, data: payload);
      //print(data.data);
      return GroupSettingListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<TradeMarginListModel?> tradeMarginListCall({
    int? page,
    String? text,
    String? exchangeId,
  }) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "page": page,
        "limit": pageLimit,
        "search": text,
        "sortKey": "createdAt",
        "sortBy": -1,
        "exchangeId": exchangeId,
      };

      final data = await _dio.post(Api.tradeMargin, data: payload);
      //print(data.data);
      return TradeMarginListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<QuantitySettingListModel?> quantitySettingListCall({
    int? page,
    String? text,
    String? userId,
    String? groupId,
  }) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {"page": 1, "limit": 100000, "search": text, "sortKey": "createdAt", "sortBy": -1, "userId": userId, "groupId": groupId};

      //print(payload);
      final data = await _dio.post(Api.quantitySettingList, data: payload);
      //print(data.data);
      return QuantitySettingListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<CommonModel?> updateQuantityCall({
    List<String>? arrIDs,
    String? quantityMax,
    String? userId,
    String? lotMax,
    String? breakQuantity,
    String? breakUpLot,
  }) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {"userWiseGroupDataAssociationId": arrIDs, "userId": userId, "quantityMax": quantityMax, "lotMax": lotMax, "breakQuantity": breakQuantity, "breakUpLot": breakUpLot, "status": 1};

      //print(payload);
      final data = await _dio.post(Api.updateQuantity, data: payload);
      //print(data.data);
      return CommonModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<CommonModel?> updateBrkCall({
    List<String>? arrIDs,
    String? brokerageType,
    String? userId,
    String? brokeragePrice,
  }) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "userWiseBrokerageId": arrIDs,
        "userId": userId,
        "brokerageType": brokerageType,
        "brokeragePrice": brokeragePrice,
      };

      //print(payload);
      final data = await _dio.post(Api.updateUserWiseBrokerage, data: payload);
      //print(data.data);
      return CommonModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<AccountSuumaryListModel?> accountSummaryCall({String? search, String? userId, String? type, String? startDate, String? endDate, int? page}) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {"page": page, "limit": 1000000, "search": search, "userId": userId, "type": type, "startDate": startDate, "endDate": endDate, "sortKey": "createdAt", "sortBy": -1};
      //print(payload);
      final data = await _dio.post(Api.accountSummary, data: payload);
      print(data.data);
      return AccountSuumaryListModel.fromJson(data.data);
    } catch (e) {
      return null;
    }
  }

  Future<UserWiseBrokerageListModel?> userWiseBrokerageListCall({String? search, String? userId, String? type, String? exchangeId}) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {"page": 1, "limit": 1000000, "search": search, "sortKey": "createdAt", "brokerageType": type, "sortBy": -1, "userId": userId, "exchangeId": exchangeId};
      {}
      //print(payload);
      final data = await _dio.post(Api.userWiseBrokerageList, data: payload);
      //print(data.data);
      return UserWiseBrokerageListModel.fromJson(data.data);
    } catch (e) {
      return null;
    }
  }

  Future<UserListModel?> getChildUserListCall({String? text, String? filterType, String? roleId, String? userId, String? status, int? page}) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "page": page,
        "limit": 1000,
        "search": text,
        "filterType": filterType,
        "roleId": roleId,
        "status": status,
        "userId": userId,
      };
      final data = await _dio.post(Api.childUserList, data: payload);
      print(data.data);
      return UserListModel.fromJson(data.data);
    } catch (e) {
      return null;
    }
  }

  Future<UserListModel?> getMyUserListCall({String? text, String? filterType, String? roleId, String? userId, String? status, int? page}) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "page": 1,
        "limit": 100000,
        "search": text,
        "filterType": filterType,
        "roleId": roleId,
        "status": status,
        "userId": userId,
      };
      final data = await _dio.post(Api.myUserList, data: payload);
      print(data.data);
      return UserListModel.fromJson(data.data);
    } catch (e) {
      return null;
    }
  }

  Future<WeeklyAdminModel?> weeklyAdminListCall({
    String? text,
    String? userId,
  }) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "page": 1,
        "limit": pageLimit,
        "search": text,
        "userId": userId,
      };
      final data = await _dio.post(Api.weeklyAdmin, data: payload);
      //print(data.data);
      return WeeklyAdminModel.fromJson(data.data);
    } catch (e) {
      return null;
    }
  }

  Future<CommonModel?> addCreditCall({String? userId, String? amount, String? type, String? transactionType, String? comment}) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {"userId": userId, "amount": amount, "type": type, "transactionType": transactionType, "comment": comment};
      final data = await _dio.post(Api.addCredit, data: payload);
      //print(data.data);
      return CommonModel.fromJson(data.data);
    } catch (e) {
      return null;
    }
  }

  Future<CreditListModel?> getCreditListCall({String? userId}) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "userId": userId,
      };
      final data = await _dio.post(Api.creditList, data: payload);
      //print(data.data);
      return CreditListModel.fromJson(data.data);
    } catch (e) {
      return null;
    }
  }

  Future<ExchangeListModel?> getExchangeListCall() async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {"page": 1, "limit": 10000000, "search": "", "sortKey": "createdAt", "sortBy": -1};
      final data = await _dio.post(Api.getExchangeList, data: payload);
      //print(data.data);
      return ExchangeListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<ExchangeListModel?> getExchangeListUserWiseCall({String userId = "", String brokerageType = ""}) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {"page": 1, "limit": 10000000, "search": "", "sortKey": "createdAt", "sortBy": -1, "userId": userId, "brokerageType": brokerageType};
      final data = await _dio.post(Api.getExchangeListUserWise, data: payload);

      return ExchangeListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<TabListModel?> getUserTabListCall() async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final data = await _dio.get(Api.getAllUserTabList);
      //print(data.data);
      return TabListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<TabWiseSymbolListModel?> getAllSymbolTabWiseListCall(String tabId) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "userTabId": tabId,
      };
      //print(_dio.options.headers);
      //print(payload);
      final data = await _dio.post(Api.getAllSymbolTabWiseList, data: payload);
      print(data.data);
      return TabWiseSymbolListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<AllSymbolListModel?> allSymbolListCallForMarket(int page, String search, String exchangeId) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {"page": page, "limit": 100000, "search": search, "sortKey": "createdAt", "sortBy": 1, "exchangeId": exchangeId};
      final data = await _dio.post(Api.getAllSymbolForCEPE, data: payload);

      return AllSymbolListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<AllSymbolListModel?> allSymbolListCall(int page, String search, String exchangeId) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {"page": page, "limit": 100000, "search": search, "sortKey": "createdAt", "sortBy": 1, "exchangeId": exchangeId};
      final data = await _dio.post(Api.getAllSymbol, data: payload);

      return AllSymbolListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<ProfitLossListModel?> profitLossListCall({String userId = ""}) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {
        "page": 1,
        "limit": 100000,
        "search": "",
        "userId": userId,
      };
      final data = await _dio.post(Api.profitLossList, data: payload);

      return ProfitLossListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<AddSymbolListModel?> getSymbolDetailCall(String symbolId) async {
    try {
      _dio.options.headers = getHeaders();
      print(_dio.options.headers);
      final payload = {
        "symbolId": symbolId,
      };
      // //print(payload);
      final data = await _dio.post(Api.symbolView, data: payload);
      //print(data);
      return AddSymbolListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<NotificationSettingModel?> getNotificationSettingCall() async {
    try {
      _dio.options.headers = getHeaders();
      print(_dio.options.headers);
      final payload = {
        "userId": userData!.userId,
      };
      // //print(payload);
      final data = await _dio.post(Api.getNotificationSetting, data: payload);
      //print(data);
      return NotificationSettingModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<NotificationSettingModel?> updateNotificationSettingCall({bool? marketOrder, bool? pendingOrder, bool? executePendingOrder, bool? deletePendingOrder, bool? tradingSound}) async {
    try {
      _dio.options.headers = getHeaders();
      print(_dio.options.headers);
      final payload = {"userId": userData!.userId, "marketOrder": marketOrder, "pendingOrder": pendingOrder, "executePendingOrder": executePendingOrder, "deletePendingOrder": deletePendingOrder, "treadingSound": tradingSound};
      // //print(payload);
      final data = await _dio.post(Api.updateNotificationSetting, data: payload);
      //print(data);
      return NotificationSettingModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<AddSymbolListModel?> addSymbolToTabCall(String tabId, String symbolId) async {
    try {
      _dio.options.headers = getHeaders();
      print(_dio.options.headers);
      final payload = {
        "userTabId": tabId,
        "symbolId": symbolId,
      };
      // //print(payload);
      final data = await _dio.post(Api.addSymbolToTab, data: payload);
      //print(data);
      return AddSymbolListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<AddSymbolListModel?> deleteSymbolFromTabCall(String tabSymbolId) async {
    try {
      _dio.options.headers = getHeaders();
      // //print(_dio.options.headers);
      final payload = {
        "userTabSymbolId": tabSymbolId,
      };
      // //print(payload);
      final data = await _dio.post(Api.deleteSymbolFromTab, data: payload);
      //print(data);
      return AddSymbolListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<UserRoleListModel?> userRoleListCall() async {
    try {
      _dio.options.headers = getHeaders();

      final data = await _dio.post(Api.userRoleList, data: null);
      //print(data.data);
      //print('========================================');
      return UserRoleListModel.fromJson(data.data);
    } catch (e) {
      return null;
    }
  }

  Future<UserRoleListModel?> userRoleListCallForPosition() async {
    try {
      _dio.options.headers = getHeaders();

      final data = await _dio.post(Api.userRoleListForPosition, data: null);
      //print(data.data);
      //print('========================================');
      return UserRoleListModel.fromJson(data.data);
    } catch (e) {
      return null;
    }
  }

  Future<BrokerListModel?> brokerListCall() async {
    try {
      _dio.options.headers = getHeaders();
      final data = await _dio.post(Api.brokerList, data: null);
      //print(data.data);
      //print('========================================');
      return BrokerListModel.fromJson(data.data);
    } catch (e) {
      return null;
    }
  }

  Future<GroupListModel?> getGroupListCall(String? exchangeId) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "page": 1,
        "limit": pageLimit,
        "search": "",
        "exchangeId": exchangeId,
        "sortKey": "createdAt",
        "sortBy": -1,
      };
      final data = await _dio.post(Api.groupList, data: payload);
      // print(data.data);
      return GroupListModel.fromJson(data.data);
    } catch (e) {
      return null;
    }
  }

  Future<CreateUserModel?> createBrokerCall({
    String? name,
    String? userName,
    String? password,
    String? phone,
    bool? changePassword,
    String? role,
  }) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "name": name,
        "userName": userName,
        "password": password,
        "phone": phone,
        "changePasswordOnFirstLogin": changePassword,
        "role": role,
      };
      final data = await _dio.post(Api.createUser, data: payload);
      print(data.data);
      return CreateUserModel.fromJson(data.data);
    } catch (e) {
      print(e);
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<CreateUserModel?> editBrokerCall({
    String? name,
    String? userName,
    String? phone,
    bool? changePassword,
    String? role,
  }) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "name": name,
        "phone": phone,
        "changePasswordOnFirstLogin": changePassword,
        "role": role,
      };
      final data = await _dio.post(Api.editUser, data: payload);
      print(data.data);
      return CreateUserModel.fromJson(data.data);
    } catch (e) {
      print(e);
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<CreateUserModel?> createAdminCall({String? name, String? userName, String? password, String? phone, String? role, int? cmpOrder, int? manualOrder, int? deleteTrade, int? executePendingOrder}) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "name": name,
        "userName": userName,
        "password": password,
        "phone": phone,
        "role": role,
        "cmpOrder": cmpOrder,
        "manualOrder": manualOrder,
        "deleteTrade": deleteTrade,
        "executePendingOrder": executePendingOrder,
      };
      final data = await _dio.post(Api.createUser, data: payload);
      //print(data.data);
      return CreateUserModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<CreateUserModel?> editAdminCall(
      {String? name,
      String? userName,
      // String? password,
      String? phone,
      String? role,
      String? userId,
      int? cmpOrder,
      int? manualOrder,
      int? deleteTrade,
      int? executePendingOrder}) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "name": name,
        "userId": userId,
        "phone": phone,
        "role": role,
        "cmpOrder": cmpOrder,
        "manualOrder": manualOrder,
        "deleteTrade": deleteTrade,
        "executePendingOrder": executePendingOrder,
      };
      final data = await _dio.post(Api.editUser, data: payload);
      print(data.data);
      return CreateUserModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<CreateUserModel?> createUserCall({
    String? name,
    String? userName,
    String? password,
    String? phone,
    int? credit,
    List<ExchangeAllow>? exchangeAllow,
    List<String>? highLowBetweenTradeLimits,
    bool? changePassword,
    String? role,
    int? modifyOrder,
    int? autoSquareOff,
    int? leverage,
    int? cutOff,
    bool? closeOnly,
    String? brokerId,
    int? intraday,
    String? remark,
    int? brkSharingDownLine,
    bool? symbolWiseSL,
    bool? freshLimitSL,
  }) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "name": name,
        "userName": userName,
        "password": password,
        "phone": phone,
        "changePasswordOnFirstLogin": changePassword,
        "remark": remark,
        "modifyOrder": modifyOrder,
        "autoSquareOff": autoSquareOff,
        "leverage": leverage,
        "cutOff": cutOff,
        "closeOnly": closeOnly,
        "credit": credit,
        "role": role,
        "highLowSLLimitPercentage": symbolWiseSL,
        "brkSharingDownLine": brkSharingDownLine,
        "intraday": intraday,
        "exchangeAllow": exchangeAllow == null ? [] : List<dynamic>.from(exchangeAllow.map((x) => x.toJson())),
        "highLowBetweenTradeLimit": highLowBetweenTradeLimits == null ? [] : List<dynamic>.from(highLowBetweenTradeLimits.map((x) => x)),
        "freshLimitSL": freshLimitSL,
      };
      print(payload);
      final data = await _dio.post(Api.createUser, data: payload);
      print(data.data);
      return CreateUserModel.fromJson(data.data);
    } catch (e) {
      print(e);
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<CreateUserModel?> editUserCall({
    String? userId,
    String? name,
    String? userName,
    // String? password,
    String? phone,
    int? credit,
    List<ExchangeAllow>? exchangeAllow,
    List<String>? highLowBetweenTradeLimits,
    bool? changePassword,
    String? role,
    int? modifyOrder,
    int? autoSquareOff,
    int? leverage,
    int? cutOff,
    bool? closeOnly,
    String? brokerId,
    int? intraday,
    String? remark,
    int? brkSharingDownLine,
    bool? symbolWiseSL,
    bool? freshLimitSL,
  }) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "userId": userId,
        "name": name,
        "phone": phone,
        "remark": remark,
        "autoSquareOff": autoSquareOff,
        "cutOff": cutOff,
        "highLowSLLimitPercentage": symbolWiseSL,
        "highLowBetweenTradeLimit": highLowBetweenTradeLimits == null ? [] : List<dynamic>.from(highLowBetweenTradeLimits.map((x) => x)),
        "freshLimitSL": freshLimitSL,
        "exchangeAllow": exchangeAllow == null ? [] : List<dynamic>.from(exchangeAllow.map((x) => x.toJson())),
      };
      print(payload);
      final data = await _dio.post(Api.editUser, data: payload);
      print(data.data);
      return CreateUserModel.fromJson(data.data);
    } catch (e) {
      print(e);
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<CreateUserModel?> createMasterCall({
    String? name,
    String? userName,
    String? password,
    String? phone,
    int? credit,
    int? profitandLossSharing,
    int? brkSharing,
    int? profitandLossSharingDownline,
    int? brkSharingDownline,
    List<ExchangeAllowforMaster>? exchangeAllow,
    List<String>? highLowBetweenTradeLimits,
    bool? changePassword,
    String? role,
    int? manualOrder,
    int? addMaster,
    int? modifyOrder,
    int? leverage,
    int? marketOrder,
    String? remark,
    bool? symbolWiseSL,
  }) async {
    try {
      _dio.options.headers = getHeaders();

      final payload = {
        "name": name,
        "userName": userName,
        "password": password,
        "phone": phone,
        "profitAndLossSharing": profitandLossSharing,
        "brkSharing": brkSharing,
        "profitAndLossSharingDownLine": profitandLossSharingDownline,
        "brkSharingDownLine": brkSharingDownline,
        "changePasswordOnFirstLogin": changePassword,
        "manualOrder": manualOrder,
        "addMaster": addMaster,
        "modifyOrder": modifyOrder,
        "leverage": leverage,
        "credit": credit,
        "role": role,
        "remark": remark,
        "marketOrder": marketOrder,
        "exchangeAllow": exchangeAllow == null ? [] : List<dynamic>.from(exchangeAllow.map((x) => x.toJson())),
        "highLowBetweenTradeLimit": highLowBetweenTradeLimits == null ? [] : List<dynamic>.from(highLowBetweenTradeLimits.map((x) => x)),
        "highLowSLLimitPercentage": symbolWiseSL,
      };
      print(GetStorage().read(LocalStorageKeys.userToken));
      print(payload);
      final data = await _dio.post(Api.createUser, data: payload);
      print(data.data);
      return CreateUserModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<CreateUserModel?> editMasterCall({
    String? userId,
    String? name,
    String? userName,
    // String? password,
    String? phone,
    int? credit,
    int? profitandLossSharing,
    int? brkSharing,
    int? profitandLossSharingDownline,
    int? brkSharingDownline,
    List<ExchangeAllowforMaster>? exchangeAllow,
    List<String>? highLowBetweenTradeLimits,
    bool? changePassword,
    String? role,
    int? manualOrder,
    int? addMaster,
    int? modifyOrder,
    int? leverage,
    int? marketOrder,
    String? remark,
    bool? symbolWiseSL,
  }) async {
    try {
      _dio.options.headers = getHeaders();

      final payload = {
        "userId": userId,
        "name": name,
        "phone": phone,
        "addMaster": addMaster,
        "remark": remark,
        "marketOrder": marketOrder,
        "exchangeAllow": exchangeAllow == null ? [] : List<dynamic>.from(exchangeAllow.map((x) => x.toJson())),
        "highLowBetweenTradeLimit": highLowBetweenTradeLimits == null ? [] : List<dynamic>.from(highLowBetweenTradeLimits.map((x) => x)),
        "highLowSLLimitPercentage": symbolWiseSL,
      };
      print(payload);
      final data = await _dio.post(Api.editUser, data: payload);
      //print(data.data);
      return CreateUserModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<PositionModel?> positionListCall(int page, String search, {String userId = "", String exchangeId = "", String symbolId = ""}) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {
        "page": page,
        "limit": 200000,
        "search": search,
        "userId": userId,
        "exchangeId": exchangeId,
        "symbolId": symbolId,
      };
      final data = await _dio.post(Api.positionList, data: payload);
      //print(data.data);
      return PositionModel.fromJson(data.data);
    } catch (e) {
      return null;
    }
  }

  Future<PositionModel?> openPositionListCall(int page, {String search = "", String exchangeId = "", String symbolId = "", String userId = ""}) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {"search": search, "exchangeId": exchangeId, "symbolId": symbolId, "userId": userId, "page": page, "limit": pageLimit};
      final data = await _dio.post(Api.openPositionList, data: payload);
      //print(data.data);
      return PositionModel.fromJson(data.data);
    } catch (e) {
      return null;
    }
  }

  Future<TradeLogsModel?> tradeLogsListCall(
    int page, {
    String search = "",
    String exchangeId = "",
    String symbolId = "",
    String userId = "",
    String startDate = "",
    String endDate = "",
  }) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {
        "search": search,
        "exchangeId": exchangeId,
        "symbolId": symbolId,
        "userId": userId,
        "page": page,
        "limit": pageLimit,
        "startDate": startDate,
        "endDate": endDate,
      };
      final data = await _dio.post(Api.tradeLogs, data: payload);
      print(data.data);
      return TradeLogsModel.fromJson(data.data);
    } catch (e) {
      return null;
    }
  }

  Future<CommonModel?> updateLeverageCall(int? leverage, {String? userId}) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {"leverage": leverage, "userId": userId};
      final data = await _dio.post(Api.updateLeverage, data: payload);
      print(data.realUri);
      return CommonModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<ChangePasswordModel?> changePasswordCall(String? oldPassword, String? newPassword, {String? userId}) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {"oldPassword": oldPassword, "newPassword": newPassword, "userId": userId, "changePasswordOnFirstLogin": false};
      final data = await _dio.post(userId == "" ? Api.changePassword : Api.otherUserchangePassword, data: payload);
      print(data.realUri);
      return ChangePasswordModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<ViewProfileModel?> profileInfoCall() async {
    try {
      _dio.options.headers = getHeaders();
      // print(_dio.options.headers);
      final data = await _dio.post(Api.viewProfile, data: null);
      //print(data.data);
      return ViewProfileModel.fromJson(data.data);
    } catch (e) {
      return null;
    }
  }

  Future<ViewProfileModel?> profileInfoByUserIdCall(String userId) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {
        "userId": userId,
      };
      //print(payload);
      final data = await _dio.post(Api.viewProfile, data: payload);
      //print(data.data);
      return ViewProfileModel.fromJson(data.data);
    } catch (e) {
      return null;
    }
  }

  Future<M2MProfitLossModel?> m2mProfitLossListCall(int page, String search, String userId) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {"page": page, "limit": pageLimit, "search": search, "userId": userId};
      final data = await _dio.post(Api.m2mProfitLoss, data: payload);
      //print(data.data);
      return M2MProfitLossModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<UserLogListModel?> userLogsListCall(
    int page, {
    String logStatus = "",
    String userId = "",
    String startDate = "",
    String endDate = "",
  }) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {
        "logStatus": logStatus,
        "sortKey": "createdAt",
        "sortBy": -1,
        "userId": userId,
        "page": page,
        "limit": 10000000,
        "startDate": startDate,
        "endDate": endDate,
      };
      final data = await _dio.post(Api.userLogList, data: payload);
      print(data.data);
      return UserLogListModel.fromJson(data.data);
    } catch (e) {
      return null;
    }
  }

  Future<ExpiryListmodel?> expiryListCall(String exchangeId, String symbolId) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {"page": 1, "limit": 5000, "exchangeId": exchangeId, "symbolId": symbolId};
      print(payload);
      final data = await _dio.post(Api.expiryList, data: payload);
      print(data.data);
      return ExpiryListmodel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<StrikePriceListModel?> strikePriceListCall(String exchangeId, String symbolId, String instrumentType, String expiryDate) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {"page": 1, "limit": 5000, "exchangeId": exchangeId, "symbolId": symbolId, "instrumentType": instrumentType, "expiryDate": expiryDate};
      print(payload);
      final data = await _dio.post(Api.strikePriceList, data: payload);
      print(data.data);
      return StrikePriceListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<NotificationListModel?> notificaitonListCall(
    int page,
  ) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {"page": page, "limit": pageLimit};
      final data = await _dio.post(Api.notificationList, data: payload);
      //print(data.data);
      return NotificationListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<ScriptQuantityModel?> getScriptQuantityListCall({String? text, String? userId, String? groupId, int? page}) async {
    try {
      _dio.options.headers = getHeaders();
      final payload = {"page": page, "limit": pageLimit, "search": text, "sortKey": "createdAt", "sortBy": -1, "userId": userId, "groupId": groupId};
      final data = await _dio.post((userData!.role == UserRollList.superAdmin || userData!.role == UserRollList.admin) ? Api.scriptQuantityListForAdmin : Api.scriptQuantityList, data: payload);
      print(data.data);
      return ScriptQuantityModel.fromJson(data.data);
    } catch (e) {
      return null;
    }
  }

  Future<UserWiseProfitLossSummaryModel?> userWiseProfitLossListCall(int page, String search, String userId) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {"page": page, "limit": pageLimit, "search": search, "userId": userId};
      final data = await _dio.post(Api.userWiseProfitLoss, data: payload);
      //print(data.data);
      return UserWiseProfitLossSummaryModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<LoginHistoryModel?> loginHistoryListCall(int page) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {"page": page, "limit": pageLimit};
      final data = await _dio.post(Api.loginHistory, data: payload);
      // print(data.data);
      return LoginHistoryModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<BulkTradeModel?> bulkTradeListCall(int page, String exchnageId, String symbolId, String userId) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {"page": page, "limit": pageLimit, "search": "", "exchangeId": exchnageId, "symbolId": symbolId, "userId": userId, "sortKey": "createdAt", "sortBy": -1};
      final data = await _dio.post(Api.bulkTradeList, data: payload);
      //print(data.data);
      return BulkTradeModel.fromJson(data.data);
    } catch (e) {
      print(e);
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<SettlementListModel?> settelementListCall(int page, String startDate, String endDate, {String? userId}) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {"page": page, "limit": pageLimit, "startDate": startDate, "endDate": endDate, "userId": userId};
      final data = await _dio.post(Api.settelmentList, data: payload);
      //print(data.data);
      return SettlementListModel.fromJson(data.data);
    } catch (e) {
      print(e);
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<BillGenerateModel?> billGenerateCall(String startDate, String search, String endDate, String userId, int billType) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {"startDate": startDate, "endDate": endDate, "search": search, "userId": userId, "billType": billType};
      final data = await _dio.post(Api.billGenerate, data: payload);
      //print(data.data);
      return BillGenerateModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<CommonModel?> cancelAllTradeCall() async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {"userId": userData!.userId};
      final data = await _dio.post(Api.cancelAllTrade, data: payload);
      //print(data.data);
      return CommonModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<CommonModel?> squareOffPositionCall({List<SymbolRequestData>? arrSymbol, String? userId}) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      var symbolData = List<dynamic>.from(arrSymbol!.map((x) => x.toJson()));

      final payload = {
        "userId": userId,
        "symbolData": symbolData,
        "ipAddress": myIpAddress,
        "deviceId": deviceId,
        "orderMethod": deviceName,
      };
      print(payload);
      final data = await _dio.post(Api.squareOffPosition, data: payload);
      print(data.data);
      return CommonModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<CommonModel?> cancelTradeCall(
    String tradeId,
  ) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {"tradeId": tradeId};
      final data = await _dio.post(Api.cancelTrade, data: payload);
      //print(data.data);
      return CommonModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<CommonModel?> logoutCall() async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {"deviceToken": "xxxxxx", "loginBy": Platform.isMacOS ? "Mac" : "Window", "deviceId": deviceId, "ip": myIpAddress, "systemToken": "Bearer ${GetStorage().read(LocalStorageKeys.userToken)}"};
      final data = await _dio.post(Api.logout, data: payload);
      print(data.data);
      return CommonModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<TradeDetailModel?> getTradeDetailCall(String tradeID) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {"tradeId": tradeID};
      final data = await _dio.post(Api.tradeDetail, data: payload);
      print(data.data);
      return TradeDetailModel.fromJson(data.data);
    } catch (e) {
      print(e);
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<MarketTimingModel?> getMarketTimingCall(String exchangeId) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {"exchangeId": exchangeId};
      final data = await _dio.post(Api.marketTiming, data: payload);
      //print(data.data);
      return MarketTimingModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<HolidayListModel?> holidayListCall(String exchangeId) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {"exchangeId": exchangeId};
      final data = await _dio.post(Api.holidayList, data: payload);
      //print(data.data);
      return HolidayListModel.fromJson(data.data);
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<SymbolWisePlListModel?> SymbolWisePlListCall({String? userId}) async {
    try {
      _dio.options.headers = getHeaders();
      //print(_dio.options.headers);
      final payload = {"search": "", "userId": userId, "page": 1, "limit": 100000};
      final data = await _dio.post(Api.symbolWisePlList, data: payload);
      print(data.data);
      return SymbolWisePlListModel.fromJson(data.data);
    } catch (e) {
      print(e);
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  Future<File?> downloadFilefromUrl(String url, {String type = "", Function? progress}) async {
    try {
      _dio.options.headers = getHeaders();
      var temp = await getTemporaryDirectory();
      var fileName = "";
      fileName = "${url.split("/").last}";
      fileName = fileName.split(".").first;
      var filePath = "${temp.path}/" + fileName;

      if (type.isNotEmpty) {
        filePath += ".$type";
      } else {
        filePath += ".${url.split("/").last}";
      }
      final data = await _dio.download(
        url,
        filePath,
        onReceiveProgress: (count, total) {
          var value = (count / total);
          if (progress != null) {
            progress(value);
          }
        },
      );
      try {
        // await FileSaver.instance.saveAs(name: fileName, ext: filePath.split(".").last, mimeType: MimeType.pdf, filePath: filePath);
        final path = await FilePicker.platform.saveFile(
          dialogTitle: 'Please select an output file:',
          fileName: fileName + ".$type",
        );

        if (path != null) {
          final file = File(path);
          var dataFile = File(filePath); // await file.writeAsString(data);
          dataFile.copySync(path);
        }
      } catch (e) {
        print(e);
      }

      // String path = await FileSaver.instance.saveFile(
      //   name: fileName,
      //   //link:  linkController.text,
      //   // bytes: Uint8List.fromList(excel.encode()!),
      //   file: File(filePath),
      //   ext: filePath.split(".").last,

      //   ///extController.text,
      //   mimeType: MimeType.pdf,
      // );

      return Future.value(File(filePath));
    } catch (e) {
      return null;
      // final errMsg = e.response?.data['message'];
      // throw Exception(errMsg);
    }
  }

  getHeaders() {
    return {
      'Accept': 'application/json',
      'apptype': Platform.isAndroid ? 'android' : 'ios',
      'deviceId': deviceId,
      'deviceToken': "xxxxxx",
      'Authorization': "Bearer ${GetStorage().read(LocalStorageKeys.userToken)}",
      'userId': GetStorage().read(LocalStorageKeys.userId),
      'version': "1.0",
    };
  }
}
