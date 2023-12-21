import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:marketdesktop/constant/color.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/screens/UserDetailPopups/GroupSettingPopUp/groupSettingPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/QuantitySettingPopUp/quantitySettingPopUpController.dart';
import 'package:marketdesktop/screens/UserDetailPopups/userDetailsPopUpController.dart';
import '../../../constant/index.dart';
import 'package:responsive_framework/responsive_framework.dart';

class GroupSettingPopUpScreen extends BaseView<GroupSettingPopUpController> {
  const GroupSettingPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      child: Visibility(
        visible: Get.find<UserDetailsPopUpController>().selectedMenuName == "Group Settings",
        child: GestureDetector(
          onTap: () {
            // controller.focusNode.requestFocus();
          },
          child: Row(
            children: [
              Expanded(
                flex: 8,
                child: BouncingScrollWrapper.builder(context, mainContent(context), dragWithMouse: true),
                // child: BouncingScrollWrapper.builder(context, mainContent(context), dragWithMouse: true),
              ),
              Container(
                width: 1.w,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget mainContent(BuildContext context) {
    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 1860,
        // margin: EdgeInsets.only(right: 1.w),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 3.h,
              color: AppColors().whiteColor,
              child: Row(
                children: [
                  // Container(
                  //   width: 30,
                  // ),
                  listTitleContent(),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  clipBehavior: Clip.hardEdge,
                  itemCount: controller.arrGroupSetting.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return groupContent(context, index);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget groupContent(BuildContext context, int index) {
    var groupValue = controller.arrGroupSetting[index];
    return GestureDetector(
      onTap: () {
        // controller.selectedScriptIndex = index;
        controller.update();
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            valueBox(groupValue.groupName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
            valueBox(shortFullDateTime(groupValue.updatedAt!), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isForDate: true),
            valueBox("", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index, isImage: true, strImage: AppImages.viewIcon, isSmall: true, onClickImage: () {
              var detailVC = Get.find<UserDetailsPopUpController>();
              detailVC.selectedCurrentTab = 3;
              if (detailVC.userRoll == UserRollList.user) {
                detailVC.selectedMenuName = detailVC.arrUserMenuList[index];
              } else {
                detailVC.selectedMenuName = detailVC.arrMasterMenuList[index];
              }

              // detailVC.selectedMenuName = detailVC.arrUserMenuList[detailVC.selectedCurrentTab];
              detailVC.updateUnSelectedView();
              detailVC.updateSelectedView();
              detailVC.update();
              var qtyVC = Get.find<QuantitySettingPopUpController>();
              qtyVC.selectedGroupId = groupValue.groupId!;
              qtyVC.quantitySettingList();
            }),
          ],
        ),
      ),
    );
  }

  Widget listTitleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // titleBox("", 0),

        titleBox("Group"),
        titleBox("Last Updated", isForDate: true),
        titleBox("View", isSmall: true),
      ],
    );
  }
}
