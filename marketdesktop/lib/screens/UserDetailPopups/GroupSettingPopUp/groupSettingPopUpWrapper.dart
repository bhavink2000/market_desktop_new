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
        // // controller.selectedScript!.value = scriptValue;
        // controller.focusNode.requestFocus();
        // controller.update();
      },
      child: Container(
        // decoration: BoxDecoration(color: Colors.transparent, border: Border.all(width: 1, color: controller.selectedScriptIndex == index ? AppColors().darkText : Colors.transparent)),
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: controller.arrListTitle.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int indexT) {
                switch (controller.arrListTitle[indexT].title) {
                  case 'GROUP':
                    {
                      return controller.arrListTitle[indexT].isSelected ? IgnorePointer(child: dynamicValueBox(groupValue.groupName ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isBig: true)) : const SizedBox();
                    }
                  case 'LAST UPDATED':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? IgnorePointer(
                              child: dynamicValueBox(shortFullDateTime(groupValue.updatedAt!), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle, isForDate: true),
                            )
                          : const SizedBox();
                    }
                  case 'VIEW':
                    {
                      return controller.arrListTitle[indexT].isSelected
                          ? dynamicValueBox("", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, isImage: true, strImage: AppImages.viewIcon, AppColors().darkText, index, indexT, controller.arrListTitle, isSmall: true, onClickImage: () {
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
                            })
                          : const SizedBox();
                    }

                  default:
                    {
                      return const SizedBox();
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget listTitleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ReorderableListView.builder(
          scrollDirection: Axis.horizontal,
          buildDefaultDragHandles: false,
          padding: EdgeInsets.zero,
          itemCount: controller.arrListTitle.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            switch (controller.arrListTitle[index].title) {
              case 'GROUP':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("GROUP", index, controller.arrListTitle, controller.isScrollEnable, isBig: true, updateCallback: controller.refreshView)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'LAST UPDATED':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("LAST UPDATED", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isForDate: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }
              case 'VIEW':
                {
                  return controller.arrListTitle[index].isSelected
                      ? dynamicTitleBox("VIEW", index, controller.arrListTitle, controller.isScrollEnable, updateCallback: controller.refreshView, isSmall: true)
                      : SizedBox(
                          key: Key('$index'),
                        );
                }

              default:
                {
                  return SizedBox(
                    key: Key('$index'),
                  );
                }
            }
          },
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            var temp = controller.arrListTitle.removeAt(oldIndex);
            if (newIndex > controller.arrListTitle.length) {
              newIndex = controller.arrListTitle.length;
            }
            controller.arrListTitle.insert(newIndex, temp);
            controller.update();
          },
        ),
      ],
    );
  }
}
