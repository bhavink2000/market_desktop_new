import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/screens/MainContainerScreen/mainContainerController.dart';
import 'package:marketdesktop/screens/MainTabs/SettingsTab/notificationSettingController.dart';

import '../../../../constant/index.dart';

class NotificationSettingsScreen extends BaseView<NotificationSettingsController> {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return Future.value(false);
        },
        child: Column(
          children: [
            Container(
              height: 32,
              color: AppColors().blueColor,
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text("Notification Alert",
                          style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1SemiBold, color: AppColors().whiteColor)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      var dashbaordScreen = Get.find<MainContainerController>();
                      dashbaordScreen.isNotificationSettingClick = false;
                      dashbaordScreen.update();
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        AppImages.closeIcon,
                        width: 10,
                        height: 10,
                        color: AppColors().whiteColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 250,
              child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  clipBehavior: Clip.hardEdge,
                  itemCount: controller.arrNotification.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return notificationContent(context, index);
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 35,
                  child: CustomButton(
                    isEnabled: true,
                    shimmerColor: AppColors().whiteColor,
                    title: "Submit",
                    textSize: 14,
                    onPress: () {
                      controller.updateNotificationSettings();
                    },
                    focusKey: controller.submitFocus,
                    borderColor: Colors.transparent,
                    focusShadowColor: AppColors().blueColor,
                    bgColor: AppColors().blueColor,
                    isFilled: true,
                    textColor: AppColors().whiteColor,
                    isTextCenter: true,
                    isLoading: controller.isApiCallRunning,
                  ),
                ),
                SizedBox(
                  width: 1.w,
                ),
                SizedBox(
                  width: 80,
                  height: 35,
                  child: CustomButton(
                    isEnabled: true,
                    shimmerColor: AppColors().blueColor,
                    title: "Reset",
                    textSize: 14,
                    prefixWidth: 0,
                    focusKey: controller.resetFocus,
                    borderColor: Colors.transparent,
                    focusShadowColor: AppColors().blueColor,
                    onPress: () {
                      controller.arrNotification.clear();
                      controller.arrNotification.add({"title": "Market Order", "value": true});
                      controller.arrNotification.add({"title": "Pending Order", "value": true});
                      controller.arrNotification.add({"title": "Execute Pending Order", "value": true});
                      controller.arrNotification.add({"title": "Delete Pending Order", "value": true});
                      controller.arrNotification.add({"title": "Treading Sound", "value": true});
                      controller.updateNotificationSettings(isFromReset: true);
                    },
                    bgColor: AppColors().whiteColor,
                    isFilled: true,
                    textColor: AppColors().blueColor,
                    isTextCenter: true,
                    isLoading: controller.isResetApiCallRunning,
                  ),
                ),
                // SizedBox(width: 5.w,),
              ],
            )
          ],
        ));
  }

  Widget notificationContent(BuildContext context, int index) {
    return Container(
      height: 50,
      child: Row(
        children: [
          SizedBox(
            width: 20,
          ),
          Container(
            width: 150,
            child: Text("${controller.arrNotification[index]["title"]} :",
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: CustomFonts.family1Regular,
                  color: AppColors().fontColor,
                )),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            // width: 350,
            // height: 50,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 80,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'On',
                    ),
                    horizontalTitleGap: 0,
                    dense: true,
                    visualDensity: VisualDensity(
                      vertical: -3,
                    ),
                    titleTextStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: CustomFonts.family1Regular,
                      color: AppColors().fontColor,
                    ),
                    leading: Radio<bool>(
                      value: true,
                      activeColor: AppColors().darkText,
                      groupValue: controller.arrNotification[index]["value"],
                      onChanged: (bool? value) {
                        controller.arrNotification[index]["value"] = value;
                        controller.update();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Off',
                    ),
                    horizontalTitleGap: 0,
                    dense: true,
                    visualDensity: VisualDensity(vertical: -3),
                    titleTextStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: CustomFonts.family1Regular,
                      color: AppColors().fontColor,
                    ),
                    leading: Radio<bool>(
                      value: false,
                      activeColor: AppColors().darkText,
                      groupValue: controller.arrNotification[index]["value"],
                      onChanged: (bool? value) {
                        controller.arrNotification[index]["value"] = value;
                        controller.update();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
