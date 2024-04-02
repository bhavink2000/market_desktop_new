import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/screens/MainContainerScreen/mainContainerController.dart';
import 'package:marketdesktop/screens/MainTabs/SettingsTab/notificationSettingWrapper.dart';

import 'package:marketdesktop/screens/MainTabs/UserTab/CreateUserScreen/createUserWrapper.dart';

import 'package:marketdesktop/screens/MainContainerScreen/headerMenu.dart';
import 'package:marketdesktop/screens/MainTabs/UserTab/UserListScreen/userListController.dart';
import 'package:marketdesktop/screens/MainTabs/UserTab/UserListScreen/userListWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/PositionScreen/positionScreenController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/PositionScreen/positionScreenWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/successTradeListController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/successTradeListWrapper.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/tradeListController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/tradeListWrapper.dart';

import 'package:marquee_text/marquee_text.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../constant/color.dart';

import '../../constant/assets.dart';
import '../../constant/dropdownFunctions.dart';
import '../../constant/font_family.dart';
import '../../constant/index.dart';
import '../BaseController/baseController.dart';
import '../MainTabs/ViewTab/MarketWatchScreen/marketWatchWrapper.dart';

class MainContainerScreen extends BaseView<MainContainerController> {
  const MainContainerScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (ispop) async {
          Get.back();
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: AppColors().headerBgColor,
          body: Column(
            children: [
              Container(
                width: 100.w,
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        // width: 90.w,
                        margin: EdgeInsets.only(left: 9),
                        height: 50,
                        child: MyMenuBar(),
                      ),
                    ),
                    // Spacer(),
                    Image.asset(
                      AppImages.appLogo,
                      width: 50,
                      height: 22,
                    ),
                    SizedBox(
                      width: 20,
                    )
                  ],
                ),
              ),
              Offstage(
                offstage: !controller.isToolBarVisible,
                child: Container(
                  width: 100.w,
                  height: 40,
                  child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      clipBehavior: Clip.hardEdge,
                      itemCount: controller.arrAdditionMenu.length,
                      controller: controller.listcontroller,
                      scrollDirection: Axis.horizontal,
                      // shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return menuOptionlistContent(context, index);
                      }),
                ),
              ),
              Expanded(
                  child: Row(
                children: [
                  SizedBox(
                    width: 1.w,
                  ),
                  if (controller.isCreateUserClick)
                    Container(
                      width: 97.9.w,
                      alignment: Alignment.center,
                      // color: AppColors().slideGrayBG,
                      child: controller.isCreateUserClick ? CreateUserScreen() : SizedBox(),
                    ),
                  if (controller.isNotificationSettingClick)
                    Container(
                      width: controller.isNotificationSettingClick ? 350 : 0,
                      color: AppColors().slideGrayBG,
                      child: controller.isNotificationSettingClick ? NotificationSettingsScreen() : SizedBox(),
                    ),
                  SizedBox(
                    width: 1,
                  ),
                  if (controller.isCreateUserClick == false)
                    Expanded(
                      flex: 7,
                      child: Column(
                        children: [
                          Expanded(child: MarketWatchScreen()),
                        ],
                      ),
                    ),
                  SizedBox(
                    width: 1.w,
                  ),
                ],
              )),
              Offstage(
                offstage: !controller.isStatusBarVisible,
                child: advertiseContent(context),
              )
            ],
          ),
        ));
  }

  Widget advertiseContent(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100.w,
          height: 30,
          color: AppColors().whiteColor,
          child: Row(
            children: [
              SizedBox(
                width: 12,
              ),
              Text("Username : ${userData?.userName ?? ""}, Roll : ${userData?.roleName ?? ""}", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
              Spacer(),
              Text("v1.0.0", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
              Spacer(),
              // Text(controller.setupbottomData(), style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
              // SizedBox(
              //   width: 5,
              // ),
              // Image.asset(
              //   AppImages.infoGreenIcon,
              //   width: 20,
              //   height: 20,
              //   fit: BoxFit.cover,
              // ),
              SizedBox(
                width: 12,
              ),
            ],
          ),
        ),
        Container(
          width: 100.w,
          height: 1,
          color: AppColors().lightOnlyText,
        ),
        Container(
          width: 100.w,
          height: 40,
          color: AppColors().whiteColor,
          child: Center(
            child: MarqueeText(
              alwaysScroll: true,
              text: TextSpan(text: (constantValues!.settingData?.banMessage ?? "")),
              style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1Medium, color: AppColors().redColor),
              speed: constantValues!.settingData!.banMessage!.length < 80 ? 5 : 30,
            ),
          ),
        ),
      ],
    );
  }

  Widget menuOptionlistContent(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        // controller.selectedTab = index;
        // controller.update();
        controller.isCreateUserClick = false;
        controller.isNotificationSettingClick = false;
        controller.update();
        if (index != 4) {
          switch (index) {
            case 0:
              {
                break;
              }
            case 1:
              {
                isCommonScreenPopUpOpen = true;

                currentOpenedScreen = ScreenViewNames.orders;
                Get.put(TradeListController());
                generalContainerPopup(view: TradeListScreen(), title: ScreenViewNames.orders);
                break;
              }
            case 2:
              {
                isCommonScreenPopUpOpen = true;
                currentOpenedScreen = ScreenViewNames.trades;
                Get.put(SuccessTradeListController());
                generalContainerPopup(view: SuccessTradeListScreen(), title: ScreenViewNames.trades);
                break;
              }
            case 3:
              {
                isCommonScreenPopUpOpen = true;
                currentOpenedScreen = ScreenViewNames.positions;
                Get.put(PositionController());
                generalContainerPopup(view: PositionScreen(), title: ScreenViewNames.positions);
                break;
              }
            case 5:
              {
                isCommonScreenPopUpOpen = true;
                currentOpenedScreen = ScreenViewNames.userList;
                Get.put(UserListController());
                generalContainerPopup(view: UserListScreen(), title: ScreenViewNames.userList);
                break;
              }

            default:
              {
                break;
              }
          }
        } else if (index == 4) {
          controller.isCreateUserClick = true;

          controller.update();
        }
      },
      child: Padding(
        padding: index == 0
            ? const EdgeInsets.only(right: 0, left: 10)
            : index == controller.arrAdditionMenu.length - 1
                ? const EdgeInsets.only(left: 0)
                : const EdgeInsets.symmetric(horizontal: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 45,
              height: 40,
              child: Center(
                  child: Image.asset(
                controller.arrAdditionMenu[index],
                width: 20,
                height: 20,
              )),
            ),
            // Spacer(),
            Container(
              height: 15,
              width: 1,
              color: AppColors().lightOnlyText,
            )
          ],
        ),
      ),
    );
  }
}
