import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/exchangeListModelClass.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:marketdesktop/screens/BaseController/baseController.dart';

import '../../../../constant/index.dart';

class TradeAccountController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  bool isFilterOpen = false;

  Rx<UserData> selectedUser = UserData().obs;
  Rx<ExchangeData> selectedExchange = ExchangeData().obs;
  Rx<GlobalSymbolData> selectedScriptFromFilter = GlobalSymbolData().obs;
  List<ExchangeData> arrExchange = [];
  List<GlobalSymbolData> arrAllScript = [];
  FocusNode viewFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
  }
}
