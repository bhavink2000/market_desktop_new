import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constant/assets.dart';
import '../constant/color.dart';
import '../constant/constantTextStyle.dart';
import '../constant/font_family.dart';
import '../constant/utilities.dart';

// ignore_for_file: must_be_immutable
class appNavigationBar extends AppBar {
  appNavigationBar(
      {Key? key,
      this.scaffoldKey,
      this.headerTitle,
      this.isBackDisplay,
      this.isTrailingDisplay,
      this.isMoreDisplay,
      this.isForEdit,
      this.isForShare,
      this.onDrawerButtonPress,
      this.onTrailingButtonPress,
      this.onMoreButtonPress,
      this.onBackButtonPress,
      this.centerIcon,
      this.backGroundColor,
      this.trailingIcon,
      this.isMarketDisplay,
      this.leadingTitleText})
      : super(key: key);
  GlobalKey<ScaffoldState>? scaffoldKey;
  String? headerTitle;
  bool? isBackDisplay;
  bool? isTrailingDisplay;
  bool? isMoreDisplay;
  bool? isForEdit;
  bool? isForShare;
  Widget? centerIcon;
  Function? onDrawerButtonPress;
  Function? onBackButtonPress;
  Function? onMoreButtonPress;
  Function? onTrailingButtonPress;
  Color? backGroundColor;
  Widget? trailingIcon;
  bool? isMarketDisplay;
  String? leadingTitleText;
  @override
  State<appNavigationBar> createState() => _appNavigationBar();
}

class _appNavigationBar extends State<appNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        systemOverlayStyle: getSystemUiOverlayStyle(),
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: widget.backGroundColor ?? AppColors().headerBgColor,
        foregroundColor: widget.backGroundColor ?? AppColors().fontColor,
        flexibleSpace: Container(color: widget.backGroundColor ?? AppColors().whiteColor),
        leading: widget.isBackDisplay != null
            ? SizedBox(
                height: 24.sp,
                width: 24.sp,
                child: widget.isBackDisplay != null
                    ? IconButton(
                        //Menu Icon Start
                        onPressed: () {
                          if (widget.isBackDisplay == true) {
                            widget.onBackButtonPress!();
                          } else if (widget.isBackDisplay != null) {
                            Get.back();
                          } else {
                            widget.onDrawerButtonPress!();
                          }
                        },
                        icon: widget.isBackDisplay != null
                            ? Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: Image.asset(
                                  AppImages.backIcon,
                                  color: AppColors().fontColor,
                                ),
                              )
                            : Image.asset(
                                AppImages.settingIcon,
                                width: 24,
                                color: AppColors().footerColor,
                              ),
                      )
                    : null)
            : null,
        title: widget.centerIcon != null
            ? Center(
                child: widget.centerIcon,
              )
            : Row(
                mainAxisAlignment: widget.isMarketDisplay == null ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  widget.isMarketDisplay != null
                      ? Center(
                          child: Text(widget.leadingTitleText ?? "Market Watch",
                              style:
                                  TextStyle(fontSize: 20, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)))
                      : const SizedBox(),
                  Center(
                      child: Text(
                    widget.headerTitle ?? "",
                    style: TextStyles().navTitleText,
                  )),
                ],
              ),
        actions: [
          Row(
            children: [
              widget.isTrailingDisplay != null
                  ? widget.trailingIcon != null
                      ? Container(
                          // margin: EdgeInsets.only(right: 10),
                          child: IconButton(
                            visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
                            padding: EdgeInsets.zero,
                            // Photo Stack Icon
                            onPressed: () async {
                              if (widget.onTrailingButtonPress != null) {
                                widget.onTrailingButtonPress!();
                              } else {
                                // Get.toNamed(RouterName.notificationScreen);
                              }
                            },
                            icon: widget.trailingIcon!,
                          ),
                        )
                      : const SizedBox()
                  : const SizedBox(),
              widget.isMoreDisplay != null
                  ? Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        visualDensity: const VisualDensity(horizontal: -4.0, vertical: -4.0),
                        padding: EdgeInsets.zero,
                        // Photo Stack Icon
                        onPressed: () async {
                          widget.onMoreButtonPress!();
                        },
                        icon: Image.asset(
                          AppImages.arrowDown,
                          width: 25,
                          height: 25,
                          color: AppColors().fontColor,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 30.sp,
                    ),
            ],
          )
        ]);
  }
}
