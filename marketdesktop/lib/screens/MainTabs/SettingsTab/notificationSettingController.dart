import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/screens/BaseController/baseController.dart';

import '../../../modelClass/notificationSettingModelClass.dart';

class NotificationSettingsControllerBinding implements Bindings {
  @override
  void dependencies() {
    // Get.put(() => SignInController());
    Get.put(NotificationSettingsController());
  }
}

enum notificationOnOff { On, Off }

class NotificationSettingsController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  List<Map<String, dynamic>> arrNotification = [];
  FocusNode submitFocus = FocusNode();
  FocusNode resetFocus = FocusNode();
  bool isApiCallRunning = false;
  bool isResetApiCallRunning = false;
  NotificationSettingData? notificationSettings;
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    getNotificationSettings();
  }

//*********************************************************************** */
  // Field Validation
  //*********************************************************************** */

  //*********************************************************************** */
  // Api Calls
  //*********************************************************************** */
  getNotificationSettings() async {
    update();

    var response = await service.getNotificationSettingCall();
    isApiCallRunning = false;
    isResetApiCallRunning = false;
    update();
    if (response?.statusCode == 200) {
      notificationSettings = response!.data!;
      arrNotification.add({"title": "Market Order", "value": notificationSettings!.marketOrder!});
      arrNotification.add({"title": "Pending Order", "value": notificationSettings!.pendingOrder!});
      arrNotification.add({"title": "Execute Pending Order", "value": notificationSettings!.executePendingOrder!});
      arrNotification.add({"title": "Delete Pending Order", "value": notificationSettings!.deletePendingOrder!});
      arrNotification.add({"title": "Treading Sound", "value": notificationSettings!.treadingSound!});

      update();
    }
  }

  updateNotificationSettings({bool isFromReset = false}) async {
    if (isFromReset) {
      isResetApiCallRunning = true;
    } else {
      isApiCallRunning = true;
    }
    update();
    var response = await service.updateNotificationSettingCall(marketOrder: arrNotification[0]["value"], pendingOrder: arrNotification[1]["value"], executePendingOrder: arrNotification[2]["value"], deletePendingOrder: arrNotification[3]["value"], tradingSound: arrNotification[4]["value"]);
    isApiCallRunning = false;
    isResetApiCallRunning = false;
    update();
    if (response?.statusCode == 200) {
      notificationSettings = response!.data!;

      arrNotification.clear();
      arrNotification.add({"title": "Market Order", "value": notificationSettings!.marketOrder!});
      arrNotification.add({"title": "Pending Order", "value": notificationSettings!.pendingOrder!});
      arrNotification.add({"title": "Execute Pending Order", "value": notificationSettings!.executePendingOrder!});
      arrNotification.add({"title": "Delete Pending Order", "value": notificationSettings!.deletePendingOrder!});
      arrNotification.add({"title": "Treading Sound", "value": notificationSettings!.treadingSound!});
      showSuccessToast(response.meta!.message ?? "");
      update();
    }
  }
}
