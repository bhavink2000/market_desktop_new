import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/screens/UserDetailPopups/userDetailsPopUpController.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:window_manager/window_manager.dart';

import '../../../constant/assets.dart';
import '../../../constant/color.dart';
import '../../../constant/font_family.dart';
import '../../constant/const_string.dart';
import '../BaseController/baseController.dart';

class UserDetailsPopUpScreen extends BaseView<UserDetailsPopUpController> {
  const UserDetailsPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors().bgColor,
        body: Column(
          children: [
            headerViewContent(isFilterAvailable: controller.isShowFilter()),
            menuListContent(context),
            Expanded(
                child: IndexedStack(
              index: controller.selectedCurrentTab,
              children: controller.widgetOptions,
            )),
            if (controller.selectedUserData != null)
              Container(
                height: 30,
                decoration: BoxDecoration(
                    color: AppColors().whiteColor,
                    border: Border(
                      top: BorderSide(color: AppColors().lightOnlyText, width: 1),
                    )),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                        "PL : ${controller.selectedUserData?.profitLoss!.toStringAsFixed(2)}  | BK : ${controller.selectedUserData?.brokerageTotal?.toStringAsFixed(2)} | BAL :  ${controller.selectedUserData?.balance?.toStringAsFixed(2)} | CRD : ${controller.selectedUserData?.credit!.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
                    const Spacer(),
                    Text("Total P/L : ${(controller.selectedUserData!.profitLoss! + controller.selectedUserData!.brokerageTotal!).toStringAsFixed(2)}", style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              )
          ],
        ));
  }

  Widget headerViewContent({String title = "", bool isFromMarket = false, bool isFilterAvailable = true, Function? filterClick, Function? pdfClick, Function? excelClick}) {
    return Container(
        width: 100.w,
        height: 40,
        decoration: BoxDecoration(
            color: AppColors().whiteColor,
            border: Border(
              bottom: BorderSide(color: AppColors().lightOnlyText, width: 1),
            )),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Image.asset(
              AppImages.appLogo,
              width: 3.h,
              height: 3.h,
            ),
            const SizedBox(
              width: 10,
            ),
            Text("User Details [${controller.userName}]",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().blueColor,
                )),
            const Spacer(),
            if (isFilterAvailable)
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (pdfClick != null) {
                        pdfClick();
                      }
                    },
                    child: Image.asset(
                      AppImages.pdfIcon,
                      width: 30,
                      height: 30,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (excelClick != null) {
                        excelClick();
                      }
                    },
                    child: Image.asset(
                      AppImages.excelIcon,
                      width: 25,
                      height: 25,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.giveClickEvent();
                    },
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Icon(
                        Icons.tune,
                        size: 25,
                        color: AppColors().blueColor,
                      ),
                    ),
                    // child: Text("Filter",
                    //     style: TextStyle(
                    //       fontSize: 14,
                    //       fontFamily: CustomFonts.family1Medium,
                    //       color: AppColors().fontColor,
                    //     )),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                ],
              ),
            GestureDetector(
              onTap: () {
                Get.back();
                controller.deleteAllController();
              },
              child: Container(
                width: 3.h,
                height: 3.h,
                padding: EdgeInsets.all(0.5.h),
                child: Image.asset(
                  AppImages.closeIcon,
                  color: AppColors().redColor,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ));
  }

  Widget menuListContent(BuildContext context) {
    return Container(
      width: 100.w,
      height: 40,
      decoration: BoxDecoration(
          color: AppColors().whiteColor,
          border: Border(
            bottom: BorderSide(color: AppColors().lightOnlyText, width: 1),
          )),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 1.w),
      child: ListView.builder(
          physics: const ClampingScrollPhysics(),
          clipBehavior: Clip.hardEdge,
          itemCount: controller.userRoll == UserRollList.user ? controller.arrUserMenuList.length : controller.arrMasterMenuList.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return menuContent(context, index);
          }),
    );
  }

  Widget menuContent(BuildContext context, int index) {
    var title = "";
    if (controller.userRoll == UserRollList.user) {
      title = controller.arrUserMenuList[index];
    } else {
      title = controller.arrMasterMenuList[index];
    }
    return GestureDetector(
      onTap: () {
        controller.selectedCurrentTab = index;
        if (controller.userRoll == UserRollList.user) {
          controller.selectedMenuName = controller.arrUserMenuList[index];
        } else {
          controller.selectedMenuName = controller.arrMasterMenuList[index];
        }

        controller.update();
        controller.updateUnSelectedView();
        controller.updateSelectedView();
      },
      child: Container(
        // width: 170,
        color: controller.selectedCurrentTab == index ? AppColors().blueColor : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: index == 3 && controller.selectedCurrentTab != 3 ? 0 : 10),
        child: Container(
          height: 30,
          padding: EdgeInsets.symmetric(horizontal: index == 3 && controller.selectedCurrentTab != 3 ? 0 : 5),
          child: Center(
            child: Text(index == 3 && controller.selectedCurrentTab != 3 ? "" : title,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: CustomFonts.family1Medium,
                  color: controller.selectedCurrentTab == index ? AppColors().whiteColor : AppColors().darkText,
                )),
          ),
        ),
      ),
    );
  }
}
