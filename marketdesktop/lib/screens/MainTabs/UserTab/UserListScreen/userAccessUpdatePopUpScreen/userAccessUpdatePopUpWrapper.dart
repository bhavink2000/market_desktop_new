import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';

import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/screens/MainTabs/UserTab/UserListScreen/userAccessUpdatePopUpScreen/userAccessUpdatePopUpController.dart';

import '../../../../../constant/index.dart';
import '../../../../../modelClass/constantModelClass.dart';
import '../../../../BaseController/baseController.dart';

class UserAccessUpdatePopUpScreen extends BaseView<UserAccessUpdatePopUpController> {
  const UserAccessUpdatePopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    //print(MediaQuery.of(context).size.width);
    //print(MediaQuery.of(context).size.height);
    return Scaffold(
        backgroundColor: AppColors().slideGrayBG,
        body: SafeArea(
            child: Column(
          children: [
            headerViewContent(
                title: "Update Access [${controller.selectedUser.value.userName!}] ",
                isFilterAvailable: false,
                isFromMarket: false,
                closeClick: () {
                  Get.back();
                  Get.delete<UserAccessUpdatePopUpController>();
                }),
            SizedBox(
              height: 10,
            ),
            Obx(() {
              return Container(
                height: 3.h,

                // padding: EdgeInsets.symmetric(horizontal: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      child: Text("BET : ", textAlign: TextAlign.start, style: TextStyle(fontSize: 13, overflow: TextOverflow.ellipsis, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: controller.selectedUser.value.bet!,
                        activeColor: AppColors().blueColor,
                        onChanged: (bool value) async {
                          final payload = {
                            "userId": controller.selectedUser.value.userId,
                            "bet": value,
                            "logStatus": "bet",
                          };
                          controller.selectedUser.value.bet = value;
                          controller.update();
                          controller.updateUserStatus(payload);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(
              height: 10,
            ),
            Obx(() {
              return Container(
                height: 3.h,

                // padding: EdgeInsets.symmetric(horizontal: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      child: Text("CLOSE ONLY : ", textAlign: TextAlign.start, style: TextStyle(fontSize: 13, overflow: TextOverflow.ellipsis, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: controller.selectedUser.value.closeOnly!,
                        activeColor: AppColors().blueColor,
                        onChanged: (bool value) async {
                          final payload = {
                            "userId": controller.selectedUser.value.userId,
                            "closeOnly": value,
                            "logStatus": "closeOnly",
                          };
                          controller.selectedUser.value.closeOnly = value;
                          controller.update();
                          controller.updateUserStatus(payload);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(
              height: 10,
            ),
            Obx(() {
              return Container(
                height: 3.h,

                // padding: EdgeInsets.symmetric(horizontal: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      child: Text("AUTO SQROFF : ", textAlign: TextAlign.start, style: TextStyle(fontSize: 13, overflow: TextOverflow.ellipsis, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: controller.selectedUser.value.autoSquareOff! == 1 ? true : false,
                        activeColor: AppColors().blueColor,
                        onChanged: (bool value) async {
                          final payload = {
                            "userId": controller.selectedUser.value.userId,
                            "autoSquareOff": value ? 1 : 0,
                            "logStatus": "autoSquareOff",
                          };
                          controller.selectedUser.value.autoSquareOff = value ? 1 : 0;
                          controller.update();
                          controller.updateUserStatus(payload);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(
              height: 10,
            ),
            Obx(() {
              return Container(
                height: 3.h,

                // padding: EdgeInsets.symmetric(horizontal: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      child: Text("VIEW ONLY : ", textAlign: TextAlign.start, style: TextStyle(fontSize: 13, overflow: TextOverflow.ellipsis, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: controller.selectedUser.value.viewOnly!,
                        activeColor: AppColors().blueColor,
                        onChanged: (bool value) async {
                          final payload = {
                            "userId": controller.selectedUser.value.userId,
                            "viewOnly": value,
                            "logStatus": "viewOnly",
                          };
                          controller.selectedUser.value.viewOnly = value;
                          controller.update();
                          controller.updateUserStatus(payload);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(
              height: 10,
            ),
            Obx(() {
              return Container(
                height: 3.h,

                // padding: EdgeInsets.symmetric(horizontal: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      child: Text("STATUS : ", textAlign: TextAlign.start, style: TextStyle(fontSize: 13, overflow: TextOverflow.ellipsis, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: controller.selectedUser.value.status! == 1 ? true : false,
                        activeColor: AppColors().blueColor,
                        onChanged: (bool value) async {
                          final payload = {
                            "userId": controller.selectedUser.value.userId,
                            "status": value ? 1 : 2,
                            "logStatus": "status",
                          };
                          controller.selectedUser.value.status = value ? 1 : 0;
                          controller.update();
                          controller.updateUserStatus(payload);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        )));
  }
}
