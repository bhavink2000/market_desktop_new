import 'dart:async';
import 'dart:io';

import 'package:floating_dialog/floating_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:marketdesktop/main.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'color.dart';
import 'constantTextStyle.dart';
import 'font_family.dart';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

void showWarningToast(String msg, {bool? isFromTop}) {
  if (isShowToastAfterLogout) {
    return;
  }
  if (isFromTop != null) {
    Get.showSnackbar(GetSnackBar(
      messageText: Row(
        children: [
          Icon(
            Icons.warning,
            color: AppColors().whiteColor,
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 80.w,
            child: Text(
              msg,
              style: TextStyles().drawerTitleText,
              maxLines: 3,
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors().blueColor,
    ));
  } else {
    Get.showSnackbar(GetSnackBar(
      messageText: Row(
        children: [
          Spacer(),
          Container(
            width: 25.w,
            height: 50,
            color: AppColors().blueColor,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.warning,
                  color: AppColors().whiteColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 12.w,
                  child: Text(
                    msg,
                    style: TextStyles().drawerTitleText,
                    maxLines: 6,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.transparent,
    ));
  }
}

void showErrorToast(String msg, {bool? isFromTop}) {
  if (isShowToastAfterLogout) {
    return;
  }
  if (isFromTop != null) {
    Get.showSnackbar(GetSnackBar(
      messageText: Row(
        children: [
          Icon(
            Icons.error,
            color: AppColors().whiteColor,
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 80.w,
            child: Text(
              msg,
              style: TextStyles().drawerTitleText,
              maxLines: 3,
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors().redColor,
    ));
  } else {
    Get.showSnackbar(GetSnackBar(
      messageText: Row(
        children: [
          Spacer(),
          Container(
            width: 25.w,
            height: 50,
            color: AppColors().redColor,
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.error,
                  color: AppColors().whiteColor,
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 12.w,
                  child: Text(
                    msg,
                    style: TextStyles().drawerTitleText,
                    maxLines: 6,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.transparent,
    ));
  }
}

void showSuccessToast(String msg, {bool? isFromTop, Color? bgColor}) {
  if (isShowToastAfterLogout) {
    return;
  }
  if (isFromTop != null) {
    Get.showSnackbar(GetSnackBar(
      messageText: Row(
        children: [
          Icon(
            Icons.check,
            color: AppColors().whiteColor,
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 80.w,
            child: Text(
              msg,
              style: TextStyles().drawerTitleText,
              maxLines: 3,
            ),
          ),
        ],
      ),
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors().blueColor,
    ));
  } else {
    Get.showSnackbar(GetSnackBar(
      messageText: Row(
        children: [
          Spacer(),
          IntrinsicHeight(
            child: Container(
              width: 15.w,
              // height: 50,
              color: bgColor != null ? bgColor : AppColors().greenColor,
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.check,
                    color: AppColors().whiteColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    width: 12.w,
                    child: Text(
                      msg,
                      style: TextStyles().drawerTitleText,
                      maxLines: 6,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.transparent,
    ));
  }
}

String shortTime(DateTime time) {
  // var utcTime =
  //     // DateTime.utc(time.year, time.month, time.day, time.hour, time.minute, time.second, time.millisecond, time.microsecond);
  final DateFormat formatter = DateFormat('hh:mm:ss');
  return formatter.format(time.toLocal());
}

String shortTimeFromTimeString(String timeString) {
  // var utcTime =
  //     // DateTime.utc(time.year, time.month, time.day, time.hour, time.minute, time.second, time.millisecond, time.microsecond);
  DateFormat formatter = DateFormat('hh:mm');
  var time = formatter.parse(timeString);
  formatter = DateFormat('hh:mm a');
  return formatter.format(time);
}

String shortFullDateTime(DateTime time) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy hh:mm:ss a');
  return formatter.format(time.toLocal());
}

String serverFormatDateTime(DateTime time) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  return formatter.format(time.toLocal());
}

String shortDate(DateTime date) {
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(date.toLocal());
}

String shortDateForBackend(DateTime date) {
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(date.toLocal());
}

extension DateTimeExtension on DateTime {
  String timeAgo() {
    Duration diff = DateTime.now().difference(this);
    if (diff.inDays > 365) return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    if (diff.inDays > 30) return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    if (diff.inDays > 7) return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    if (diff.inDays > 0) return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    if (diff.inHours > 0) return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    if (diff.inMinutes > 0) return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    return "just now";
  }

  String formatDate() {
    final formatter = DateFormat('MMMM dd, y');
    return formatter.format(this);
  }

  String formatDateInHours() {
    final formatter = DateFormat('hh:mm aa');
    return formatter.format(this);
  }

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  int getDifferenceInDaysWithNow() {
    final now = DateTime.now();
    var difference = now.difference(this).inDays;
    if (difference == 0) {
      if (now.day - 1 == day) {
        return 1;
      } else {
        return 0;
      }
    }
    return difference;
  }
}

updateSystemOverlay() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    statusBarIconBrightness: Platform.isAndroid ? Brightness.light : Brightness.dark,
    statusBarBrightness: Platform.isAndroid ? Brightness.light : Brightness.dark,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarDividerColor: Colors.black,
  ));
}

SystemUiOverlayStyle getSystemUiOverlayStyle() {
  if (Platform.isAndroid) {
    if (currentDarkModeOn) {
      return const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      );
    } else {
      return const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      );
    }
  } else {
    if (currentDarkModeOn) {
      return const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      );
    } else {
      return const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      );
    }
  }
}

Widget dataNotFoundView(String msg) {
  return Container(
      width: 100.w,
      child: Center(
        child: Text(msg, style: TextStyle(fontSize: 20, fontFamily: CustomFonts.family1Medium, color: AppColors().lightOnlyText)),
      ));
}

Widget displayIndicator() {
  return Container(
    child: Center(
      child: CircularProgressIndicator(
        color: AppColors().blueColor,
        strokeWidth: 2,
      ),
    ),
  );
}

showPermissionDialog({String? message, String? acceptButtonTitle, String? rejectButtonTitle, Function? yesClick, Function? noclick}) {
  showDialog<String>(
      context: Get.context!,
      builder: (BuildContext context) => FloatingDialog(
            // titlePadding: EdgeInsets.zero,
            // backgroundColor: AppColors().footerColor,
            // surfaceTintColor: AppColors().fontColor,
            // contentPadding:
            //     const EdgeInsets.only(top: 10, bottom: 16, left: 20, right: 20),
            // title: Container(
            //   //color: Colors.red,
            //   // width: 100.w,
            //   padding:  EdgeInsets.only(right: 60, left: 50),
            //   margin:  EdgeInsets.symmetric(vertical: 20),
            //   child: Image.asset(
            //     AppImages.logoNameImage,
            //     width: 30.w,
            //   ),
            // ),
            child: Padding(
              padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
              child: Column(
                children: [
                  Text(
                    message!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors().fontColor,
                      fontFamily: CustomFonts.family1Medium,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Container(
                          width: 120,
                          height: 35,
                          // color: AppColors().extralightGrayThemeColor,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.transparent, width: 1),
                              color: AppColors().redColor),
                          child: TextButton(
                            // style: ButtonStyle(

                            //   foregroundColor:
                            //       MaterialStateProperty.all<Color>(
                            //           AppColors().blackThemeColor),
                            // ),
                            onPressed: () {
                              if (noclick == null) {
                                Get.back();
                              } else {
                                noclick();
                              }
                            },
                            child: Text('No', style: TextStyle(fontFamily: CustomFonts.family1Medium, fontSize: 14, color: AppColors().whiteColor)),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          width: 120,
                          height: 35,
                          // color: AppColors().extralightGrayThemeColor,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.transparent, width: 1),
                              color: AppColors().blueColor),
                          child: TextButton(
                            onPressed: () {
                              if (yesClick == null) {
                                Get.back();
                              } else {
                                yesClick();
                              }
                            },
                            child: Text('Yes', style: TextStyle(fontFamily: CustomFonts.family1Medium, fontSize: 14, color: AppColors().whiteColor)),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
            // actionsAlignment: MainAxisAlignment.center,
            // actionsPadding: const EdgeInsets.only(bottom: 25),
            // actions: <Widget>[

            // ],
          ));
}
