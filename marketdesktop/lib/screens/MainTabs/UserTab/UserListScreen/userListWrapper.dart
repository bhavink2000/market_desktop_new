import 'package:floating_dialog/floating_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_to_pdf/flutter_to_pdf.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/constantModelClass.dart';
import 'package:marketdesktop/modelClass/userRoleListModelClass.dart';
import 'package:marketdesktop/screens/MainTabs/UserTab/CreateUserScreen/createUserController.dart';
import 'package:marketdesktop/screens/MainTabs/UserTab/UserListScreen/userListController.dart';
import 'package:paginable/paginable.dart';

import 'package:responsive_framework/responsive_framework.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../../../constant/index.dart';
import '../../../../constant/screenColumnData.dart';
import '../../../../customWidgets/appScrollBar.dart';
import '../../../MainContainerScreen/mainContainerController.dart';

class UserListScreen extends BaseView<UserListController> {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Row(
        children: [
          filterPanel(
            context,
            isRecordDisplay: true,
            totalRecord: controller.totalRecord,
            onCLickFilter: () {
              controller.isFilterOpen = !controller.isFilterOpen;
              controller.update();
            },
            onCLickExcell: controller.onClickExcel,
            onCLickPDF: controller.onClickPDF,
          ),
          filterContent(context),
          Expanded(
            flex: 8,
            child: BouncingScrollWrapper.builder(
              context,
              controller.bytes != null
                  ? ExportFrame(
                      exportDelegate: controller.exportDelegate,
                      frameId: '2',
                      child: Image.memory(controller.bytes!), // the widget you want to export
                    )
                  : WidgetsToImage(
                      controller: controller.widgetToImagecontroller,
                      child: mainContent(context),
                    ),
              dragWithMouse: true,
            ),
            // child: BouncingScrollWrapper.builder(context, mainContent(context), dragWithMouse: true),
          ),
        ],
      ),
    );
  }

  Widget filterContent(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Visibility(
        visible: controller.isFilterOpen,
        child: AnimatedContainer(
          margin: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: AppColors().whiteColor, width: 1),
          )),
          width: controller.isFilterOpen ? 270 : 0,
          duration: Duration(milliseconds: 100),
          child: Offstage(
            offstage: !controller.isFilterOpen,
            child: Column(
              children: [
                SizedBox(
                  width: 35,
                ),
                Container(
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Container(
                        child: Text("Filter",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: CustomFonts.family1SemiBold,
                              color: AppColors().darkText,
                            )),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          controller.isFilterOpen = false;
                          controller.update();
                        },
                        child: Container(
                          padding: EdgeInsets.all(9),
                          width: 30,
                          height: 30,
                          color: Colors.transparent,
                          child: Image.asset(
                            AppImages.closeIcon,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  color: AppColors().slideGrayBG,
                  child: Column(
                    children: [
                      // SizedBox(
                      //   height: 10,
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Container(
                              child: Text("Filter Type:",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: CustomFonts.family1Regular,
                                    color: AppColors().fontColor,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            filterTypeDropDown(controller.selectedFilterType, width: 150),
                            SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Container(
                              child: Text("User Type:",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: CustomFonts.family1Regular,
                                    color: AppColors().fontColor,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            userTypeDropDown(controller.selectedUserType, height: 30, width: 150),
                            SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Container(
                              child: Text("User Status:",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: CustomFonts.family1Regular,
                                    color: AppColors().fontColor,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            statusListDropDown(controller.selectUserStatusdropdownValue, width: 150),
                            SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 35,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Container(
                              child: Text("Search:",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: CustomFonts.family1Regular,
                                    color: AppColors().fontColor,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 150,
                              decoration: BoxDecoration(color: AppColors().whiteColor, border: Border.all(color: AppColors().lightOnlyText, width: 1), borderRadius: BorderRadius.circular(5)),
                              child: TextFormField(
                                textInputAction: TextInputAction.search,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: CustomFonts.family1Medium,
                                  color: AppColors().darkText,
                                ),
                                controller: controller.textController,
                                onFieldSubmitted: (String value) {},
                                validator: (String? value) {
                                  // if (!foodTags.contains(value)) {
                                  //   return 'Nothing selected.';
                                  // }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(8),
                                  // labelText: 'Food Type',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 0, color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(width: 0, color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
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
                              title: "View",
                              textSize: 14,
                              onPress: () {
                                controller.arrUserListData.clear();
                                controller.currentPage = 1;
                                controller.getUserList(isFromButtons: true);
                              },
                              focusKey: controller.viewFocus,
                              borderColor: Colors.transparent,
                              focusShadowColor: AppColors().blueColor,
                              bgColor: AppColors().blueColor,
                              isFilled: true,
                              textColor: AppColors().whiteColor,
                              isTextCenter: true,
                              isLoading: controller.isLoadingData,
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
                              title: "Clear",
                              textSize: 14,
                              prefixWidth: 0,
                              onPress: () {
                                controller.selectedUserType.value = userRoleListData();
                                controller.selectedScriptFromFilter.value = GlobalSymbolData();
                                controller.textController.clear();
                                controller.selectedFilterType.value = AddMaster();
                                controller.selectUserStatusdropdownValue.value = AddMaster();
                                controller.fromDate.value = "";
                                controller.endDate.value = "";
                                controller.arrUserListData.clear();
                                controller.currentPage = 1;
                                controller.update();
                                controller.getUserList(isFromClear: true, isFromButtons: true);
                              },
                              bgColor: AppColors().whiteColor,
                              isFilled: true,
                              focusKey: controller.clearFocus,
                              borderColor: Colors.transparent,
                              focusShadowColor: AppColors().blueColor,
                              textColor: AppColors().blueColor,
                              isTextCenter: true,
                              isLoading: controller.isResetData,
                            ),
                          ),
                          // SizedBox(width: 5.w,),
                        ],
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mainContent(BuildContext context) {
    print(controller.isScrollEnable.value);
    return CustomScrollBar(
      bgColor: AppColors().blueColor,
      child: SingleChildScrollView(
        physics: controller.isLoadingData == false && controller.arrUserListData.isEmpty
            ? NeverScrollableScrollPhysics()
            : controller.isScrollEnable.value
                ? ClampingScrollPhysics()
                : NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          width: globalMaxWidth > 3375 ? globalMaxWidth : 3375,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 3.h,
                color: AppColors().whiteColor,
                child: Row(
                  children: [
                    // Container(
                    //   width: 30,
                    // ),
                    listTitleContent(controller),
                  ],
                ),
              ),
              Expanded(
                child: (controller.isLoadingData == false && controller.isResetData == false) && controller.arrUserListData.isEmpty
                    ? Container(
                        width: 100.w,
                        child: Center(
                          child: Text("Users not found", style: TextStyle(fontSize: 20, fontFamily: CustomFonts.family1Medium, color: AppColors().lightOnlyText)),
                        ))
                    : CustomScrollBar(
                        bgColor: AppColors().blueColor,
                        child: PaginableListView.builder(
                            loadMore: () async {
                              if (controller.totalPage >= controller.currentPage) {
                                //print(controller.currentPage);
                                controller.getUserList();
                              }
                            },
                            errorIndicatorWidget: (exception, tryAgain) => dataNotFoundView("Data not found"),
                            progressIndicatorWidget: displayIndicator(),
                            physics: const ClampingScrollPhysics(),
                            clipBehavior: Clip.hardEdge,
                            itemCount: controller.isLoadingData || controller.isResetData ? 50 : controller.arrUserListData.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return orderContent(context, index);
                            }),
                      ),
              ),
              Container(
                height: 30,
                decoration: BoxDecoration(color: AppColors().whiteColor, border: Border(top: BorderSide(color: AppColors().lightOnlyText, width: 1))),
                child: Center(
                    child: Row(
                  children: [
                    totalContent(value: "Total", textColor: AppColors().darkText, width: 1200),
                    totalContent(value: controller.totalPL.toStringAsFixed(2), textColor: controller.totalPL < 0 ? AppColors().redColor : AppColors().blueColor, width: 110),
                    totalContent(value: controller.totalPLPercentage.toStringAsFixed(2), textColor: controller.totalPLPercentage < 0 ? AppColors().redColor : AppColors().blueColor, width: 110),
                  ],
                )),
              ),
              Container(
                height: 2.h,
                color: AppColors().headerBgColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget totalContent({String? value, Color? textColor, double? width}) {
    return Container(
      width: width ?? 6.w,
      padding: EdgeInsets.only(left: 5),
      decoration: BoxDecoration(color: AppColors().whiteColor, border: Border(top: BorderSide(color: AppColors().lightOnlyText, width: 1), bottom: BorderSide(color: AppColors().lightOnlyText, width: 1), right: BorderSide(color: AppColors().lightOnlyText, width: 1))),
      child: Text(value ?? "",
          style: TextStyle(
            fontSize: 12,
            fontFamily: CustomFonts.family1Medium,
            color: textColor ?? AppColors().redColor,
          )),
    );
  }

  Widget orderContent(BuildContext context, int index) {
    // var scriptValue = controller.arrUserListData[index];
    if (controller.isLoadingData || controller.isResetData) {
      return Container(
        margin: EdgeInsets.only(bottom: 3.h),
        child: Shimmer.fromColors(
            child: Container(
              height: 3.h,
              color: Colors.white,
            ),
            baseColor: AppColors().whiteColor,
            highlightColor: AppColors().grayBg),
      );
    } else {
      return GestureDetector(
        onTap: () {
          controller.selectedUserIndex = index;
          controller.update();
        },
        child: Container(
          height: 30,
          decoration: BoxDecoration(color: Colors.transparent, border: Border.all(width: 1, color: controller.selectedUserIndex == index ? AppColors().darkText : Colors.transparent)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: controller.arrListTitle1.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int indexT) {
                  switch (controller.arrListTitle1[indexT].title) {
                    case 'EDIT':
                      {
                        return dynamicValueBox1("", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index, indexT, controller.arrListTitle1, isImage: true, strImage: AppImages.editUserImage, onClickImage: () async {
                          var dashbaordScreen = Get.find<MainContainerController>();
                          dashbaordScreen.isCreateUserClick = true;
                          dashbaordScreen.isNotificationSettingClick = false;
                          // dashbaordScreen.widgetOptions.clear();
                          // dashbaordScreen.arrAvailableController.clear();
                          // dashbaordScreen.arrAvailableTabs.clear();
                          Get.back();
                          await callForRoleList();
                          var createUserVC = Get.find<CreateUserController>();
                          createUserVC.selectedUserForEdit = null;
                          createUserVC.selectedUserForEdit = controller.arrUserListData[index];
                          createUserVC.fillUserDataForEdit();
                          dashbaordScreen.update();
                        });
                      }
                    case '...':
                      {
                        return PopupMenuButton<String>(
                          tooltip: "",
                          onSelected: (String value) {
                            // Handle menu item selection here
                            print('Selected: $value');
                            if (value == "1") {
                              showChangePasswordPopUp(selectedUserId: controller.arrUserListData[index].userId!);
                            }
                            if (value == "2") {
                              showLeverageUpdatePopUp(selectedUser: controller.arrUserListData[index]);
                            }
                            if (value == "4") {
                              showUserAccessUpdatePopUp(selectedUser: controller.arrUserListData[index]);
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: '1',
                              child: Text('Change password'),
                            ),
                            PopupMenuItem<String>(
                              value: '2',
                              child: Text('Update Leverage'),
                            ),
                            PopupMenuItem<String>(
                              value: '3',
                              child: Text(controller.arrUserListData[index].role == UserRollList.user ? '% MARGIN SQUER' : "Account limit"),
                            ),
                            PopupMenuItem<String>(
                              value: '4',
                              child: Text("Action"),
                            ),
                          ],
                          child: IgnorePointer(
                            ignoring: true,
                            child: dynamicValueBox1(
                              "",
                              index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                              Colors.transparent,
                              index,
                              indexT,
                              controller.arrListTitle1,
                              isImage: true,
                              strImage: AppImages.cpImage,
                            ),
                          ),
                        );
                      }
                    case 'USERNAME':
                      {
                        return dynamicValueBox1(controller.arrUserListData[index].userName ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1, isUnderlined: true, onClickValue: () {
                          showUserDetailsPopUp(userId: controller.arrUserListData[index].userId!, userName: controller.arrUserListData[index].userName!, roll: controller.arrUserListData[index].role!);
                        });
                      }
                    case 'PARENT USER':
                      {
                        return dynamicValueBox1(controller.arrUserListData[index].parentUser ?? "--", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1);
                      }
                    case 'TYPE':
                      {
                        return dynamicValueBox1(
                          controller.arrUserListData[index].roleName ?? "",
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          AppColors().darkText,
                          index,
                          indexT,
                          controller.arrListTitle1,
                        );
                      }
                    case 'NAME':
                      {
                        return dynamicValueBox1(
                          controller.arrUserListData[index].name ?? "",
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          AppColors().darkText,
                          index,
                          indexT,
                          controller.arrListTitle1,
                        );
                      }
                    case 'OUR %':
                      {
                        return dynamicValueBox1(
                          "${controller.arrUserListData[index].ourProfitAndLossSharing}",
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          AppColors().blueColor,
                          index,
                          indexT,
                          controller.arrListTitle1,
                        );
                      }
                    case 'BRK SHARING':
                      {
                        return dynamicValueBox1(
                          "${controller.arrUserListData[index].ourBrkSharing}",
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          AppColors().blueColor,
                          index,
                          indexT,
                          controller.arrListTitle1,
                        );
                      }
                    case 'LEVERAGE':
                      {
                        return dynamicValueBox1(controller.arrUserListData[index].leverage!.toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().blueColor, index, indexT, controller.arrListTitle1, onClickValue: () {
                          showLeverageUpdatePopUp(selectedUser: controller.arrUserListData[index]);
                        }, isUnderlined: true);
                      }
                    case 'CREDIT':
                      {
                        return dynamicValueBox1(controller.arrUserListData[index].credit.toString(), index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1, isUnderlined: true, onClickValue: () {
                          showUserDetailsPopUp(userId: controller.arrUserListData[index].userId!, userName: controller.arrUserListData[index].userName!, roll: controller.arrUserListData[index].role!, selectedCurrentTab: 5, selectedMenuName: "Credit");
                        });
                      }
                    case 'P/L':
                      {
                        return dynamicValueBox1(
                          controller.arrUserListData[index].role == UserRollList.user
                              ? (controller.arrUserListData[index].profitLoss! - controller.arrUserListData[index].brokerageTotal!).toStringAsFixed(2)
                              : (controller.arrUserListData[index].profitLoss! + controller.arrUserListData[index].brokerageTotal!).toStringAsFixed(2),
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          AppColors().blueColor,
                          index,
                          indexT,
                          controller.arrListTitle1,
                        );
                      }
                    case 'EQUITY':
                      {
                        return dynamicValueBox1(
                          controller.arrUserListData[index].balance!.toStringAsFixed(2),
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          AppColors().blueColor,
                          index,
                          indexT,
                          controller.arrListTitle1,
                        );
                      }
                    case 'TOTAL MARGIN':
                      {
                        return dynamicValueBox1(
                          controller.arrUserListData[index].marginBalance!.toStringAsFixed(2),
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          AppColors().blueColor,
                          index,
                          indexT,
                          controller.arrListTitle1,
                        );
                      }
                    case 'USED MARGIN':
                      {
                        return dynamicValueBox1(
                          controller.arrUserListData[index].role == UserRollList.user ? (controller.arrUserListData[index].marginBalance! - controller.arrUserListData[index].tradeMarginBalance!).toStringAsFixed(2) : "0",
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          AppColors().blueColor,
                          index,
                          indexT,
                          controller.arrListTitle1,
                        );
                      }
                    case 'FREE MARGIN':
                      {
                        return dynamicValueBox1(
                          controller.arrUserListData[index].tradeMarginBalance!.toStringAsFixed(2),
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          AppColors().blueColor,
                          index,
                          indexT,
                          controller.arrListTitle1,
                        );
                      }
                    case 'BET':
                      {
                        return dynamicValueBox1("", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index, indexT, controller.arrListTitle1, isSwitch: true, switchValue: controller.arrUserListData[index].bet!.obs, onSwitchChanged: (value) {
                          final payload = {
                            "userId": controller.arrUserListData[index].userId,
                            "bet": value,
                            "logStatus": "bet",
                          };
                          controller.updateUserStatus(payload);
                        });
                      }
                    case 'CLOSE ONLY':
                      {
                        return dynamicValueBox1("", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index, indexT, controller.arrListTitle1, isSwitch: true, switchValue: controller.arrUserListData[index].closeOnly!.obs, onSwitchChanged: (value) {
                          final payload = {
                            "userId": controller.arrUserListData[index].userId,
                            "closeOnly": value,
                            "logStatus": "closeOnly",
                          };
                          controller.updateUserStatus(payload);
                        });
                      }
                    case 'AUTO SQROFF':
                      {
                        return dynamicValueBox1("", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index, indexT, controller.arrListTitle1, isSwitch: true, switchValue: controller.arrUserListData[index].autoSquareOff == 0 ? false.obs : true.obs,
                            onSwitchChanged: (value) {
                          final payload = {
                            "userId": controller.arrUserListData[index].userId,
                            "autoSquareOff": value ? 1 : 0,
                            "logStatus": "autoSquareOff",
                          };
                          controller.updateUserStatus(payload);
                        });
                      }
                    case 'VIEW ONLY':
                      {
                        return dynamicValueBox1("", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index, indexT, controller.arrListTitle1, isSwitch: true, switchValue: controller.arrUserListData[index].viewOnly!.obs, onSwitchChanged: (value) {
                          final payload = {
                            "userId": controller.arrUserListData[index].userId,
                            "viewOnly": value,
                            "logStatus": "viewOnly",
                          };
                          controller.updateUserStatus(payload);
                        });
                      }
                    case 'STATUS':
                      {
                        return dynamicValueBox1("", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index, indexT, controller.arrListTitle1, isSwitch: true, switchValue: controller.arrUserListData[index].status == 1 ? true.obs : false.obs, onSwitchChanged: (value) {
                          final payload = {
                            "userId": controller.arrUserListData[index].userId,
                            "status": value ? 1 : 2,
                            "logStatus": "status",
                          };
                          controller.updateUserStatus(payload);
                        });
                      }
                    case 'CREATED DATE':
                      {
                        return dynamicValueBox1(
                          shortFullDateTime(controller.arrUserListData[index].createdAt!),
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          AppColors().darkText,
                          index,
                          indexT,
                          controller.arrListTitle1,
                        );
                      }
                    case 'LAST LOGIN DATE/TIME':
                      {
                        return dynamicValueBox1(
                          shortFullDateTime(controller.arrUserListData[index].createdAt!),
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          AppColors().darkText,
                          index,
                          indexT,
                          controller.arrListTitle1,
                        );
                      }
                    case 'DEVICE':
                      {
                        return dynamicValueBox1(
                          controller.arrUserListData[index].deviceType ?? "--",
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          AppColors().darkText,
                          index,
                          indexT,
                          controller.arrListTitle1,
                        );
                      }
                    case 'DEVICE ID':
                      {
                        return dynamicValueBox1(
                          controller.arrUserListData[index].deviceId ?? "--",
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          AppColors().darkText,
                          index,
                          indexT,
                          controller.arrListTitle1,
                        );
                      }
                    case 'IP ADDRESS':
                      {
                        return dynamicValueBox1(
                          controller.arrUserListData[index].ipAddress ?? "--",
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          AppColors().darkText,
                          index,
                          indexT,
                          controller.arrListTitle1,
                        );
                      }
                    default:
                      {
                        return const SizedBox();
                      }
                  }
                },
              ),

              // valueBox("", 0, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index,
              //     isImage: true, isBig: true, strImage: AppImages.shareDetailsImage, onClickImage: () {
              //   controller.selectedUserIndex = index;
              //   showSharingPopup();
              // }),
            ],
          ),
        ),
      );
    }
  }

  Widget contextMenuButton() {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        // Handle menu item selection here
        print('Selected: $value');
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'Option 1',
          child: Text('Option 1'),
        ),
        PopupMenuItem<String>(
          value: 'Option 2',
          child: Text('Option 2'),
        ),
        PopupMenuItem<String>(
          value: 'Option 3',
          child: Text('Option 3'),
        ),
      ],
    );
  }

  // Widget listTitleContentFinal() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       titleBox("EDIT", isSmall: true),
  //       // titleBox("Share Details", isBig: true),
  //       titleBox("...", isSmall: true),
  //       titleBox("Username"),
  //       titleBox("PARENT USER"),
  //       titleBox("Type"),
  //       titleBox("Name", isBig: true),
  //       titleBox("our %"),
  //       titleBox("Brk Sharing"),
  //       titleBox("Leverage"),

  //       titleBox("Credit"),

  //       titleBox("P/L"),
  //       titleBox("equity"),
  //       // titleBox("P/L % WISE"),
  //       titleBox("Total Margin", isBig: true),
  //       titleBox("Used Margin", isBig: true),
  //       titleBox("free margin"),

  //       titleBox("bet"),
  //       titleBox("Close only"),

  //       // titleBox("Modify Order", isBig: true),

  //       titleBox("AUTO SQROFF", isBig: true),
  //       titleBox("View only"),
  //       titleBox("Status"),

  //       titleBox("CREATED DATE", isForDate: true),
  //       titleBox("last login date/time", isLarge: true),
  //       titleBox("Device"),
  //       titleBox("Device Id", isBig: true),
  //       titleBox("IP ADRESS"),
  //     ],
  //   );
  // }

  // Widget listTitleContent() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       ReorderableListView.builder(
  //         scrollDirection: Axis.horizontal,
  //         buildDefaultDragHandles: false,
  //         padding: EdgeInsets.zero,
  //         itemCount: controller.arrListTitle1.length,
  //         shrinkWrap: true,
  //         itemBuilder: (BuildContext context, int index) {
  //           switch (controller.arrListTitle1[index].title) {
  //             case 'EDIT':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("EDIT", index, controller.arrListTitle1, controller.isScrollEnable, updateCallback: controller.refreshView, isSmall: true)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case '...':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("...", index, isSmall: true, hasFilterIcon: true, controller.arrListTitle1, controller.isScrollEnable, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'USERNAME':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("USERNAME", index, controller.arrListTitle1, controller.isScrollEnable, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'PARENT USER':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("PARENT USER", index, controller.arrListTitle1, controller.isScrollEnable, isBig: true, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'TYPE':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("TYPE", index, controller.arrListTitle1, controller.isScrollEnable, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'NAME':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("NAME", index, controller.arrListTitle1, controller.isScrollEnable, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'OUR %':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("OUR %", index, controller.arrListTitle1, controller.isScrollEnable, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'BRK SHARING':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("BRK SHARING", index, controller.arrListTitle1, controller.isScrollEnable, isBig: true, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'LEVERAGE':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("LEVERAGE", index, controller.arrListTitle1, controller.isScrollEnable, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'CREDIT':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("CREDIT", index, controller.arrListTitle1, controller.isScrollEnable, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'P/L':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("P/L", index, controller.arrListTitle1, controller.isScrollEnable, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'EQUITY':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("EQUITY", index, controller.arrListTitle1, controller.isScrollEnable, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'TOTAL MARGIN':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("TOTAL MARGIN", index, controller.arrListTitle1, controller.isScrollEnable, isBig: true, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'USED MARGIN':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("USED MARGIN", index, controller.arrListTitle1, controller.isScrollEnable, isBig: true, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'FREE MARGIN':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("FREE MARGIN", index, controller.arrListTitle1, controller.isScrollEnable, isBig: true, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'BET':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("BET", index, controller.arrListTitle1, controller.isScrollEnable, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'CLOSE ONLY':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox(
  //                         "CLOSE ONLY",
  //                         index,
  //                         controller.arrListTitle1,
  //                         controller.isScrollEnable,
  //                         updateCallback: controller.refreshView,
  //                       )
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'AUTO SQROFF':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("AUTO SQROFF", index, controller.arrListTitle1, controller.isScrollEnable, isBig: true, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'VIEW ONLY':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("VIEW ONLY", index, controller.arrListTitle1, controller.isScrollEnable, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'STATUS':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("STATUS", index, controller.arrListTitle1, controller.isScrollEnable, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'CREATED DATE':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("CREATED DATE", index, controller.arrListTitle1, controller.isScrollEnable, isForDate: true, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'LAST LOGIN DATE/TIME':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("LAST LOGIN DATE/TIME", index, controller.arrListTitle1, controller.isScrollEnable, isLarge: true, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'DEVICE':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("DEVICE", index, controller.arrListTitle1, controller.isScrollEnable, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'DEVICE ID':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("DEVICE ID", index, controller.arrListTitle1, controller.isScrollEnable, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }
  //             case 'IP ADDRESS':
  //               {
  //                 return controller.arrListTitle1[index].isSelected
  //                     ? dynamicTitleBox("IP ADDRESS", index, controller.arrListTitle1, controller.isScrollEnable, updateCallback: controller.refreshView)
  //                     : SizedBox(
  //                         key: Key('$index'),
  //                       );
  //               }

  //             default:
  //               {
  //                 return SizedBox(
  //                   key: Key('$index'),
  //                 );
  //               }
  //           }
  //         },
  //         onReorder: (int oldIndex, int newIndex) {
  //           if (oldIndex < newIndex) {
  //             newIndex -= 1;
  //           }
  //           var temp = controller.arrListTitle1.removeAt(oldIndex);
  //           if (newIndex > controller.arrListTitle1.length) {
  //             newIndex = controller.arrListTitle1.length;
  //           }
  //           controller.arrListTitle1.insert(newIndex, temp);
  //           controller.update();
  //         },
  //       ),
  //     ],
  //   );
  // }

  showSharingPopup() {
    isUserDetailPopUpOpen = true;

    showDialog<String>(
        context: Get.context!,
        // barrierColor: Colors.transparent,
        barrierDismissible: true,
        builder: (BuildContext context) => FloatingDialog(
              // titlePadding: EdgeInsets.zero,
              // backgroundColor: AppColors().bgColor,
              // surfaceTintColor: AppColors().bgColor,

              // contentPadding: EdgeInsets.zero,
              // insetPadding: EdgeInsets.symmetric(
              //   horizontal: 20.w,
              //   vertical: 32.h,
              // ),
              enableDragAnimation: false,
              child: Container(
                // width: 30.w,
                // height: 28.h,
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
                child: Column(
                  children: [
                    headerViewContent(Get.context!),
                    contentView(),
                    SizedBox(
                      height: 20,
                    ),
                    buttonsView(),
                    SizedBox(
                      height: 5,
                    )
                  ],
                ),
              ),
            ));
  }

  Widget buttonsView() {
    var userValue = controller.arrUserListData[controller.selectedUserIndex];
    var tempString = "";

    tempString = "Username : ${userValue.userName}\n Password : Please enter your password\n Servername  : ${serverName} \n iOS Link : https://www.apple.com \n Android Link : https://www.google.com \n Mac Link : https://www.appleMac.com \n Window Link : https://www.microsoft.com";
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 70,
          ),
          SizedBox(
            width: 6.w,
            height: 3.h,
            child: CustomButton(
              isEnabled: true,
              shimmerColor: AppColors().whiteColor,
              title: "Copy",
              textSize: 14,
              onPress: () async {
                await Clipboard.setData(ClipboardData(text: tempString));
                showSuccessToast("Details copied successfully.");
              },
              bgColor: AppColors().blueColor,
              isFilled: true,
              textColor: AppColors().whiteColor,
              isTextCenter: true,
              isLoading: false,
            ),
          ),
          SizedBox(
            width: 1.w,
          ),
          SizedBox(
            width: 6.w,
            height: 3.h,
            child: CustomButton(
              isEnabled: true,
              shimmerColor: AppColors().blueColor,
              title: "Send",
              textSize: 14,
              prefixWidth: 0,
              onPress: () async {
                var tempEmail = "";

                final Uri _url = Uri.parse("mailto:${tempEmail}?subject=${userValue.name!} Details&body=${tempString}");
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
              },
              bgColor: AppColors().whiteColor,
              isFilled: true,
              borderColor: AppColors().blueColor,
              textColor: AppColors().blueColor,
              isTextCenter: true,
              isLoading: false,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget contentView() {
    var userValue = controller.arrUserListData[controller.selectedUserIndex];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                child: Text("Username : ",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: CustomFonts.family1Medium,
                      color: AppColors().darkText,
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Text(userValue.userName ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: CustomFonts.family1Medium,
                    color: AppColors().darkText,
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                child: Text("Password : ",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: CustomFonts.family1Medium,
                      color: AppColors().darkText,
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text("Please enter your password",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: CustomFonts.family1Medium,
                      color: AppColors().darkText,
                    )),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                child: Text("Server Name : ",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: CustomFonts.family1Medium,
                      color: AppColors().darkText,
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(AppString.appName,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: CustomFonts.family1Medium,
                      color: AppColors().darkText,
                    )),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                child: Text("iOS Link : ",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: CustomFonts.family1Medium,
                      color: AppColors().darkText,
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text("https://www.apple.com",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: CustomFonts.family1Medium,
                      color: AppColors().darkText,
                    )),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                child: Text("Android Link : ",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: CustomFonts.family1Medium,
                      color: AppColors().darkText,
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text("https://www.google.com",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: CustomFonts.family1Medium,
                      color: AppColors().darkText,
                    )),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                child: Text("Mac Link : ",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: CustomFonts.family1Medium,
                      color: AppColors().darkText,
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text("https://www.appleMac.com",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: CustomFonts.family1Medium,
                      color: AppColors().darkText,
                    )),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                child: Text("Window Link : ",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: CustomFonts.family1Medium,
                      color: AppColors().darkText,
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text("https://www.microsoft.com",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: CustomFonts.family1Medium,
                      color: AppColors().darkText,
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget headerViewContent(BuildContext context) {
    var userValue = controller.arrUserListData[controller.selectedUserIndex];
    return Container(
        width: 100.w,
        height: 35,
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
            Text("User Details [${userValue.userName}]",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().blueColor,
                )),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Get.back();
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
}
