import 'package:intl/intl.dart';

class AppString {
  static const String emptyUserType = "Please Select User Type.";
  static const String emptyServer = "Please Enter Server Name.";
  static const String invalidServer = "Please enter valid server name.";
  static const String emptyUserName = "Please Enter User Name.";
  static const String notSelectedUserName = "Please select User Name.";
  static const String emptyAmount = "Please Enter Amount";
  static const String emptyComment = "Please Enter Comment.";
  static const String rangeUserName = "User Name Should Be Min 4 Characters.";
  static const String emptyPassword = "Please Enter Your password.";
  static const String emptyCurrentPassword = "Please Enter Your current password.";
  static const String wrongPassword = "Password Should be Atleast 6 Characters.";
  static const String wrongRetypePassword = "Retype Password Should be Atleast 6 Characters.";
  static const String mobileNumberLength = "Mobile Number Should Not be Less than 10 Characters.";
  static const String cutOffValid = "Cut Off Should be Between 60% to 100%.";
  static const String emptyConfirmPassword = "Please Confirm Your Password.";
  static const String passwordNotMatch = "Your Password And Retype Password Doesn't Match.";
  static const String emptyMobileNumber = "Enter Mobile Number.";
  static const String emptyQty = "Please Enter Quantity.";
  static const String inValidQty = "Please Enter valid Quantity.";
  static const String inValidLot = "Please select lot.";
  static const String emptyTradeDisplayFor = "Please select trade display for";
  static const String emptyCutOff = "Please Cut Off.";
  static const String emptyCredit = "Please Credit.";
  static const String emptyPrice = "Please Enter Price.";
  static const String generalError = "Something Went Wrong.";
  static const String emptyName = "Please Enter Name.";
  static const String emptyRemark = "Please Enter Remark.";
  static const String emptyProfitLossSharing = "Please Enter Profit and Loss Sharing .";
  static const String rangeProfitLossSharing = "Profit and Loss Should Be Between 0 to 100 %.";
  static const String emptyBrokerageSharing = "Please Enter Brokerage Sharing.";
  static const String rangeBrokerageSharing = "Brokerage Should be Between 0 to 100 %.";
  static const String emptyLotMax = "Please enter max lot";
  static const String emptyqtyMax = "Please enter quantity max";
  static const String emptybrkQty = "Please enter breakup quantity";
  static const String emptybrkLot = "Please enter breakup lot";
  static const String emptyScriptSelection = "Please select script";
  static const String emptyExchangeGroup = "Please select atleast one exchange group";
  static const String emptyExchange = "Please select exchange.";
  static const String emptyScript = "Please select script.";
}

class ScreenViewNames {
  static const String marketWatch = "Market Watch";
  static const String orders = "Pending Orders";
  static const String trades = "Trades";
  static const String positions = "Net Position";
  static const String createUser = "Create User";
  static const String userList = "User List";
  static const String manualOrder = "Manual Order";
  static const String profitAndLoss = "Profit & Loss";
  static const String m2mProfitAndLoss = "M2M Profit & Loss";
  static const String rejectionLog = "Rejection Log";
  static const String loginHistory = "Login History";
  static const String openPosition = "Open Position";
  static const String manageTrades = "Manage Trades";
  static const String tradeAccount = "Trade Account";
  static const String clientAccountReport = "Account Report";
  static const String tradeMargin = "Trade Margin";
  static const String tradeLogs = "Trade Logs";
  static const String settelment = "Settlement";
  static const String accountSummary = "Credit History";
  static const String billGenerate = "Bill Generate";
  static const String percentopenPosition = "% Open Position";
  static const String weeklyAdmin = "Weekly Admin";
  static const String logsHistory = "Activity Report";
  static const String scriptMaster = "Script Master";
  static const String pAndlSummary = "Scriptwise P&L Summary";
  static const String userLogsNew = "User Logs New";
  static const String userwisePAndLSummary = "Userwise P&L Summary";
  static const String userScriptPositionTracking = "User Script Position Tracking";
  static const String symbolWisePositionReport = "Symbol Wise Position Report";
  static const String messages = "Messages";
  static const String dashboard = "Dashboard";
}

class ListCellWidth {
  double small = 63;
  double normal = 110;
  double big = 150;
  double bigForDate = 170;
  double large = 280;
  double extraLarge = 500;
}

class ListCellWidthForMarket {
  double small = 60;
  double normal = 112;
  double big = 152;
  double bigForDate = 162;
  double large = 190;
  double extraLarge = 500;
}

class LocalStorageKeys {
  static const String userToken = "userToken";
  static const String userId = "userId";
  static const String userData = "userData";
  static const String userType = "userType";
  static const String isDetailSciptOn = "isDetailSciptOn";
  static const String isDarkMode = "isDarkMode";
  static const String isStatusBarVisible = "isStatusBarVisible";
  static const String isToolBarVisible = "isToolBarVisible";
}

class TradeMarginClass {
  static const String isFromTradeMarginClass = "";
}

class CommonCustomDateSelection {
  List<String> arrCustomDate = <String>[];

  CommonCustomDateSelection() {
    DateTime currentDate = DateTime.now();
    // Calculate the start and end dates for "This Week"
    DateTime thisWeekStartDate = currentDate.subtract(Duration(days: currentDate.weekday - 1));
    DateTime thisWeekEndDate = thisWeekStartDate.add(const Duration(days: 6));
    // Calculate the start and end dates for "Previous Week"
    DateTime previousWeekEndDate = thisWeekStartDate.subtract(const Duration(days: 1));
    DateTime previousWeekStartDate = previousWeekEndDate.subtract(const Duration(days: 6));
    // Format the dates as strings
    String thisWeekDateRange = 'This Week \n${DateFormat('yyyy-MM-dd').format(thisWeekStartDate)} to ${DateFormat('yyyy-MM-dd').format(thisWeekEndDate)}';
    String previousWeekDateRange = 'Previous Week \n${DateFormat('yyyy-MM-dd').format(previousWeekStartDate)} to ${DateFormat('yyyy-MM-dd').format(previousWeekEndDate)}';

    // Initialize the arrCustomDate list
    arrCustomDate = <String>[thisWeekDateRange, previousWeekDateRange, 'Custom Period'];
  }
}

class UserRollList {
  static const String superAdmin = "64b63755c71461c502ea4713";
  static const String admin = "64b63755c71461c502ea4714";
  static const String master = "64b63755c71461c502ea4715";
  static const String broker = "64b63755c71461c502ea4716";
  static const String user = "64b63755c71461c502ea4717";
}
