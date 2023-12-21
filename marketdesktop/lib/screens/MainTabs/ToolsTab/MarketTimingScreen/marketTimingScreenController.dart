import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../modelClass/exchangeListModelClass.dart';
import '../../../../modelClass/marketTimingModelClass.dart';
import '../../../BaseController/baseController.dart';

class MarketTimingControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MarketTimingController());
  }
}

class MarketTimingController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  ScrollController listcontroller = ScrollController();
  Rx<ExchangeData?>? selectedExchangedropdownValue = ExchangeData().obs;
  RxBool isSearchPressed = false.obs;
  RxBool isDateSelected = false.obs;
  bool isDarkMode = false;
  String? selectedDate;
  DateTime currentDate = DateTime.now();
  DateTime currentDate2 = DateTime.now();
  String currentMonth = DateFormat.yMMM().format(DateTime.now());
  DateTime targetDateTime = DateTime.now();
  bool isApiCallRunning = false;
  Size? screenSize;
  List<ExchangeData> arrExchangeList = [];
  MarketTimingModel? timingData;
  FocusNode viewFocus = FocusNode();
  @override
  void onInit() async {
    super.onInit();
    screenSize = WidgetsBinding.instance.platformDispatcher.displays.first.size;
    getExchangeList();
    update();
  }

  getExchangeList() async {
    var response = await service.getExchangeListCall();
    if (response != null) {
      if (response.statusCode == 200) {
        arrExchangeList = response.exchangeData ?? [];
        update();
      }
    }
  }

  getTiming() async {
    isApiCallRunning = true;
    update();
    currentDate = DateTime.now();
    currentDate2 = DateTime.now();
    var response = await service.getMarketTimingCall(selectedExchangedropdownValue!.value!.exchangeId!);
    isApiCallRunning = false;
    update();
    if (response?.statusCode == 200) {
      timingData = response;
      isDateSelected.value = false;
      if (timingData?.data == null) {}
      update();
    }
  }
}
