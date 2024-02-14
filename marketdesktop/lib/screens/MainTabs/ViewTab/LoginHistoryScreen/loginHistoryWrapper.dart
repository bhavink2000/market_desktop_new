import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/constant/color.dart';
import 'package:marketdesktop/constant/popUpFunctions.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:paginable/paginable.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../constant/index.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../constant/screenColumnData.dart';
import '../../../../customWidgets/appButton.dart';
import '../../../BaseController/baseController.dart';
import 'loginHistoryController.dart';

class LoginHistoryScreen extends BaseView<LoginHistoryController> {
  const LoginHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return FocusTraversalGroup(
      policy: WidgetOrderTraversalPolicy(),
      child: Row(
        children: [
          // filterPanel(context, bottomMargin: 0, isRecordDisplay: false, onCLickFilter: () {
          //   controller.isFilterOpen = !controller.isFilterOpen;
          //   controller.update();
          // }),
          // filterContent(context),
          Expanded(
            flex: 8,
            child: BouncingScrollWrapper.builder(context, mainContent(context), dragWithMouse: true),
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
          // margin: EdgeInsets.only(bottom: 2.h),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: AppColors().whiteColor, width: 1),
          )),
          width: controller.isFilterOpen ? 380 : 0,
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
                  color: AppColors().headerBgColor,
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
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 4.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Container(
                              child: Text("From:",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: CustomFonts.family1Regular,
                                    color: AppColors().fontColor,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                showCalenderPopUp(DateTime.now(), (DateTime selectedDate) {
                                  controller.fromDate.value = shortDateForBackend(selectedDate);
                                });
                              },
                              child: Obx(() {
                                return Container(
                                  height: 4.h,
                                  width: 250,
                                  decoration: BoxDecoration(
                                      color: AppColors().whiteColor,
                                      border: Border.all(
                                        color: AppColors().lightOnlyText,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(3)),
                                  // color: AppColors().whiteColor,
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        controller.fromDate.value,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: CustomFonts.family1Medium,
                                          color: AppColors().darkText,
                                        ),
                                      ),
                                      const Spacer(),
                                      Image.asset(
                                        AppImages.calendarIcon,
                                        width: 25,
                                        height: 25,
                                        color: AppColors().fontColor,
                                      )
                                    ],
                                  ),
                                );
                              }),
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
                      Container(
                        height: 4.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // SizedBox(
                            //   width: 30,
                            // ),
                            Spacer(),

                            Container(
                              child: Text("To:",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: CustomFonts.family1Regular,
                                    color: AppColors().fontColor,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                // selectToDate(controller.endDate);
                                showCalenderPopUp(DateTime.now(), (DateTime selectedDate) {
                                  controller.endDate.value = shortDateForBackend(selectedDate);
                                });
                              },
                              child: Obx(() {
                                return Container(
                                  height: 4.h,
                                  width: 250,
                                  decoration: BoxDecoration(
                                      color: AppColors().whiteColor,
                                      border: Border.all(
                                        color: AppColors().lightOnlyText,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(3)),
                                  // color: AppColors().whiteColor,
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        controller.endDate.value,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: CustomFonts.family1Medium,
                                          color: AppColors().darkText,
                                        ),
                                      ),
                                      const Spacer(),
                                      Image.asset(
                                        AppImages.calendarIcon,
                                        width: 25,
                                        height: 25,
                                        color: AppColors().fontColor,
                                      )
                                    ],
                                  ),
                                );
                              }),
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
                      Container(
                        height: 4.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Spacer(),
                            Container(
                              child: Text("Username:",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: CustomFonts.family1Regular,
                                    color: AppColors().fontColor,
                                  )),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            userListDropDown(controller.selectedUser),
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
                        height: 4.h,
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
                              width: 250,
                              decoration: BoxDecoration(color: AppColors().whiteColor, border: Border.all(color: AppColors().lightOnlyText, width: 1)),
                              child: TextFormField(
                                textInputAction: TextInputAction.search,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: CustomFonts.family1Medium,
                                  color: AppColors().darkText,
                                ),
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
                              onPress: () {},
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
                              shimmerColor: AppColors().whiteColor,
                              title: "Clear",
                              textSize: 14,
                              prefixWidth: 0,
                              onPress: () {
                                controller.selectedUser.value = UserData();
                                controller.fromDate.value = "";
                                controller.endDate.value = "";
                              },
                              bgColor: AppColors().whiteColor,
                              isFilled: true,
                              borderColor: AppColors().blueColor,
                              textColor: AppColors().blueColor,
                              isTextCenter: true,
                              isLoading: false,
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
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        width: globalMaxWidth,
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
                  listTitleContent(controller),
                ],
              ),
            ),
            Expanded(
              child: controller.isApiCallRunning == false && controller.arrLoginHistory.isEmpty
                  ? dataNotFoundView("Login history not found")
                  : PaginableListView.builder(
                      loadMore: () async {
                        if (controller.totalPage >= controller.currentPage) {
                          //print(controller.currentPage);
                          controller.loginHistoryList();
                        }
                      },
                      errorIndicatorWidget: (exception, tryAgain) => dataNotFoundView("Data not found"),
                      progressIndicatorWidget: displayIndicator(),
                      physics: const ClampingScrollPhysics(),
                      clipBehavior: Clip.hardEdge,
                      itemCount: controller.arrLoginHistory.length,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return loginHistoryContent(context, index);
                      }),
            ),
          ],
        ),
      ),
    );
  }

  Widget loginHistoryContent(BuildContext context, int index) {
    if (controller.isApiCallRunning) {
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
      var historyValue = controller.arrLoginHistory[index];
      return GestureDetector(
        onTap: () {
          // controller.selectedScriptIndex = index;
          controller.update();
        },
        child: Container(
          height: 30,
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
                    case 'LOGIN TIME':
                      {
                        return dynamicValueBox1(
                          historyValue.loginDate != "" && historyValue.loginDate != null ? shortFullDateTime(historyValue.loginDate!) : "--",
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          AppColors().darkText,
                          index,
                          indexT,
                          controller.arrListTitle1,
                        );
                      }
                    case 'LOGOUT TIME':
                      {
                        return dynamicValueBox1(
                          historyValue.logoutDate != "" && historyValue.logoutDate != null ? shortFullDateTime(historyValue.logoutDate!) : "--",
                          index % 2 == 0 ? Colors.transparent : AppColors().grayBg,
                          AppColors().darkText,
                          index,
                          indexT,
                          controller.arrListTitle1,
                        );
                      }
                    case 'USERNAME':
                      {
                        return dynamicValueBox1(historyValue.userName ?? "", index % 2 == 0 ? Colors.transparent : AppColors().grayBg, AppColors().darkText, index, indexT, controller.arrListTitle1, isUnderlined: true, onClickValue: () {
                          showUserDetailsPopUp(userId: controller.arrLoginHistory[index].userId!, userName: controller.arrLoginHistory[index].userName ?? "");
                        });
                      }
                    case 'USER TYPE':
                      {
                        return dynamicValueBox1(
                          historyValue.role ?? "",
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
                          historyValue.ip ?? "",
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
                          historyValue.deviceId ?? "",
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
            ],
          ),
        ),
      );
    }
  }
}
