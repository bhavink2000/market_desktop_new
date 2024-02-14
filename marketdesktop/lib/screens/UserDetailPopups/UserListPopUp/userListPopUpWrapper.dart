import 'package:get/get.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/modelClass/allSymbolListModelClass.dart';
import 'package:marketdesktop/modelClass/constantModelClass.dart';
import 'package:marketdesktop/modelClass/userRoleListModelClass.dart';
import 'package:marketdesktop/screens/UserDetailPopups/UserListPopUp/userListPopUpController.dart';

import 'package:responsive_framework/responsive_framework.dart';

import '../../../../constant/index.dart';
import '../userDetailsPopUpController.dart';

class UserListPopUpScreen extends BaseView<UserListPopUpController> {
  const UserListPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Visibility(
        visible: Get.find<UserDetailsPopUpController>().selectedMenuName == "User List",
        child: GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              // filterPanel(context, isRecordDisplay: true, totalRecord: controller.arrUserListData.length, onCLickFilter: () {
              //   controller.isFilterOpen = !controller.isFilterOpen;
              //   controller.update();
              // }),
              // filterContent(context),
              Expanded(
                flex: 8,
                child: BouncingScrollWrapper.builder(context, mainContent(context), dragWithMouse: true),
                // child: BouncingScrollWrapper.builder(context, mainContent(context), dragWithMouse: true),
              ),
            ],
          ),
        ),
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
          width: controller.isFilterOpen ? 380 : 0,
          duration: const Duration(milliseconds: 100),
          child: Offstage(
            offstage: !controller.isFilterOpen,
            child: Column(
              children: [
                const SizedBox(
                  width: 35,
                ),
                SizedBox(
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Text("Filter",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: CustomFonts.family1SemiBold,
                            color: AppColors().darkText,
                          )),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          controller.isFilterOpen = false;
                          controller.update();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(9),
                          width: 30,
                          height: 30,
                          color: Colors.transparent,
                          child: Image.asset(
                            AppImages.closeIcon,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
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
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 4.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Text("Filter Type:",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: CustomFonts.family1Regular,
                                  color: AppColors().fontColor,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            filterTypeDropDown(controller.selectedFilterType),
                            const SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 4.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Text("User Type:",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: CustomFonts.family1Regular,
                                  color: AppColors().fontColor,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            userTypeDropDown(controller.selectedUserType, height: 4.h),
                            const SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 4.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Text("User Status:",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: CustomFonts.family1Regular,
                                  color: AppColors().fontColor,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            statusListDropDown(controller.selectUserStatusdropdownValue, height: 4.h),
                            const SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 4.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Text("Search:",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: CustomFonts.family1Regular,
                                  color: AppColors().fontColor,
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 250,
                              decoration: BoxDecoration(color: AppColors().whiteColor, border: Border.all(color: AppColors().lightOnlyText, width: 1)),
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
                            const SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 70,
                          ),
                          SizedBox(
                            width: 6.w,
                            height: 3.h,
                            child: CustomButton(
                              isEnabled: true,
                              shimmerColor: AppColors().whiteColor,
                              title: "View",
                              textSize: 14,
                              onPress: () {
                                controller.getUserList();
                              },
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
                            width: 6.w,
                            height: 3.h,
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
                                controller.fromDate.value = "";
                                controller.endDate.value = "";
                                controller.getUserList(isFromClear: true);
                              },
                              bgColor: AppColors().whiteColor,
                              isFilled: true,
                              borderColor: AppColors().blueColor,
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
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 1370,
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
                  itemCount: controller.arrUserListData.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return orderContent(context, index);
                  }),
            ),
            Container(
              height: 2.h,
              color: AppColors().headerBgColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget orderContent(BuildContext context, int index) {
    // var scriptValue = controller.arrUserListData[index];

    return GestureDetector(
      onTap: () {
        controller.update();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          valueBox(controller.arrUserListData[index].userName ?? "", 33, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true, isUnderlined: true, onClickValue: () {
            showUserDetailsPopUp(userId: controller.arrUserListData[index].userId!, userName: controller.arrUserListData[index].userName!);
          }),
          valueBox(controller.arrUserListData[index].name ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true),
          valueBox(controller.arrUserListData[index].roleName ?? "", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
          valueBox(controller.arrUserListData[index].parentUser ?? "--", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
          valueBox(controller.arrUserListData[index].credit.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
          valueBox(controller.arrUserListData[index].balance.toString(), 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().blueColor, index),
          valueBox("${controller.arrUserListData[index].ourBrkSharing}%", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().blueColor, index),
          valueBox("${controller.arrUserListData[index].ourProfitAndLossSharing}%", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().blueColor, index),
          // valueBox("", 0, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index,
          //     isSwitch: true, switchValue: controller.arrUserListData[index].bet!.obs),
          // valueBox("", 0, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index,
          //     isSwitch: controller.arrUserListData[index].role == UserRollList.master ? false : true,
          //     switchValue: controller.arrUserListData[index].closeOnly!.obs),
          // valueBox("", 0, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index,
          //     isSwitch: true, switchValue: controller.arrUserListData[index].marginSquareOff!.obs, isBig: true),
          // valueBox("", 0, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index,
          //     isSwitch: true, switchValue: controller.arrUserListData[index].status == 1 ? true.obs : false.obs),
          valueBox(controller.arrUserListData[index].deviceId ?? "--", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true),
          valueBox(shortDate(controller.arrUserListData[index].createdAt!), 60, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, isBig: true),
          valueBox(controller.arrUserListData[index].ipAddress ?? "--", 45, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index),
          // valueBox("", 0, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index,
          //     isImage: true, isSmall: true, strImage: AppImages.editUserImage),
          // valueBox("", 0, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index,
          //     isImage: true, isBig: true, strImage: AppImages.shareDetailsImage, onClickImage: () {
          //   // ShareDetailPopUpScreen();
          //   // showSharingDetailPopup();
          // }),
          // valueBox("", 0, index % 2 == 0 ? Colors.transparent : AppColors().grayBg, Colors.transparent, index,
          //     isImage: true, isBig: true, strImage: AppImages.cpImage, onClickImage: () {
          //   showChangePasswordPopUp();
          // }),
        ],
      ),
    );
  }

  Widget listTitleContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        titleBox("Username", isBig: true),
        titleBox("Name", isBig: true),
        titleBox("Type"),
        titleBox("Parent"),
        titleBox("Credit"),
        titleBox("Balance"),
        titleBox("Brk Sharing"),
        titleBox("P/L Sharing"),
        // titleBox("Modify Order"),
        // titleBox("Close On"),
        // titleBox("Auto Square Off", isBig: true),
        // titleBox("Status"),
        titleBox("Device Id", isBig: true),
        titleBox("Created At", isBig: true),
        titleBox("IP Address"),
        // titleBox("Edit", isSmall: true),
        // titleBox("Share Details", isBig: true),
        // titleBox("Change Password", isBig: true),
      ],
    );
  }
}
