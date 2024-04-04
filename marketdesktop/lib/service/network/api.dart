abstract class Api {
  static const baseUrl = 'https://account.bazaar2.in/api/v1/';

  // Authentication
  static const getConstant = 'constant/list';
  static const getServerName = 'server/list';
  static const login = 'user/login';
  static const getAllSymbol = 'symbol/list';
  static const getAllSymbolForCEPE = 'symbol/search-list';
  static const getAllUserTabList = 'user/get-user-tab-list';
  static const addSymbolToTab = 'user/post-user-tab-wise-symbols';
  static const deleteSymbolFromTab = 'user/delete-user-tab-symbol';
  static const getAllSymbolTabWiseList = 'user/get-user-tab-wise-symbols-list';
  static const createTrade = 'trade/create';
  static const modifyTrade = 'trade/update';
  static const myTradeList = 'trade/list';
  static const myUserList = 'user/list';
  static const childUserList = 'user/child-list';
  static const getExchangeListUserWise = 'exchange/user-wise-list';
  static const getExchangeList = 'exchange/list';
  static const userRoleList = 'role/list';
  static const userRoleListForPosition = 'role/admin-list';
  static const brokerList = 'user/list-broker';
  static const groupList = 'group/list';
  static const createUser = 'user/create';
  static const editUser = 'user/edit';
  static const positionList = 'position/list';
  static const openPositionList = 'symbol-position/list';
  static const changePassword = 'user/change-password';
  static const scriptQuantityList = 'user-wise-group-data-association/list';
  static const scriptQuantityListForAdmin = 'group-data-association/list';
  static const otherUserchangePassword = 'user/change-password-to-admin';
  static const viewProfile = 'user/view-profile';
  static const m2mProfitLoss = 'm2m-profit-loss/list';
  static const userWiseProfitLoss = 'user-wise-profit-loss/list';
  static const creditList = 'list-credit';
  static const addCredit = 'add-credit';
  static const accountSummary = 'account-summary/list';
  static const rejectLog = 'reject-trade/list';
  static const groupSettingList = 'assign-group/list';
  static const quantitySettingList = 'user-wise-group-data-association/list';
  static const updateQuantity = 'user-wise-group-data-association/create-edit';
  static const userWiseBrokerageList = 'user-wise-brokerage/list';
  static const updateUserWiseBrokerage = 'user-wise-brokerage/create-edit';
  static const manualOrderCreate = 'manually-trade/create';
  static const weeklyAdmin = 'weekly-admin/list';
  static const loginHistory = 'user/login-history';
  static const settelmentList = 'settlement/list';
  static const billGenerate = 'bill-generate';
  static const tradeDetail = 'trade/get';
  static const marketTiming = 'exchange-time-schedule/list';
  static const cancelTrade = 'trade/cancel';
  static const cancelAllTrade = 'trade/all-cancel';
  static const squareOffPosition = 'trade/square-off-position';
  static const symbolView = 'symbol/view';
  static const notificationList = 'notification/list';
  static const getNotificationSetting = 'notification/get-user-setting';
  static const updateNotificationSetting = 'notification/create-user-setting';
  static const profitLossList = 'profit-loss/list';
  static const symbolWisePlList = 'symbol-profit-loss-summary/list';
  static const manageTrade = 'manage-trade/list';
  static const positionTracking = 'user-script-position-tracking/list';
  static const logout = 'user/logout';
  static const tradeMargin = 'trade-margin/list';
  static const tradeLogs = 'trade/log-list';
  static const accountSummaryNewList = 'account-summary-new/list';
  static const tradeDelete = 'trade/delete';
  static const tradeRollOver = 'trade/roll-over';
  static const symbolWisePositionReport = 'symbol-wise-position-report/list';
  static const expiryList = 'symbol/expiry-list';
  static const strikePriceList = 'symbol/strike-price-list';
  static const userChangeStatus = 'user/change-status';
  static const userLogList = 'user-log/list';
  static const updateLeverage = 'user/change-leverage';
  static const holidayList = 'holiday/list';
  static const bulkTradeList = 'bulk-trade-alert/list';
}
