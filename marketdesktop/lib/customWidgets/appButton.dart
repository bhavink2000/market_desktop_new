import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../constant/color.dart';
import '../constant/font_family.dart';

// ignore_for_file: must_be_immutable
class CustomButton extends StatefulWidget {
  CustomButton({
    Key? key,
    required this.isEnabled,
    this.prefixIcon,
    this.suffixIcon,
    required this.title,
    required this.onPress,
    required this.bgColor,
    this.borderColor,
    required this.isFilled,
    required this.textColor,
    required this.isTextCenter,
    required this.isLoading,
    required this.shimmerColor,
    required this.textSize,
    this.buttonHeight,
    // required this.fontFamily,
    this.prefixHeight,
    this.prefixWidth,
    this.isGradiantBG,
    this.noNeedBorderRadius,
    this.focusKey,
    this.focusShadowColor,
  }) : super(key: key);

  bool isEnabled;
  Widget? prefixIcon;
  Widget? suffixIcon;
  String title;
  double? textSize;
  Function onPress;
  Color bgColor;
  Color? borderColor;
  bool isFilled;
  Color textColor;
  bool isTextCenter;
  bool isLoading;
  Color shimmerColor;
  Color? focusShadowColor;
  double? prefixWidth;
  double? buttonHeight;
  double? prefixHeight;
  bool? isGradiantBG;
  bool? noNeedBorderRadius;
  FocusNode? focusKey;
  // String? fontFamily;

  @override
  State<CustomButton> createState() => _CustomButton();
}

class _CustomButton extends State<CustomButton> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.focusKey != null) {
      Future.delayed(Duration(seconds: 1), () {
        widget.focusKey!.addListener(updateUI);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.focusKey != null) {
      widget.focusKey!.removeListener(updateUI);
    }
  }

  updateUI() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onPress();
        if (widget.focusKey != null) {
          widget.focusKey!.unfocus();
        }
      },
      focusNode: widget.focusKey,
      child: Stack(
        children: [
          Container(
            height: widget.buttonHeight ?? 8.h,
            width: 100.w,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: widget.focusKey != null && widget.focusKey!.hasFocus ? widget.focusShadowColor! : Colors.transparent,
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: const Offset(0, 0), // changes position of shadow
                ),
              ],
              borderRadius: widget.noNeedBorderRadius != null ? BorderRadius.circular(0) : BorderRadius.circular(4),
              border: Border.all(
                  color: widget.focusKey != null && widget.focusKey!.hasFocus
                      ? widget.borderColor ?? Colors.transparent
                      : Colors.transparent,
                  width: 2),
              color: widget.isFilled ? widget.bgColor : AppColors().whiteColor,
            ),
            child: Center(
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: widget.textSize,
                  color: Get.isDarkMode ? Colors.white : widget.textColor,
                  fontFamily: CustomFonts.family1Medium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          if (widget.isLoading)
            Shimmer.fromColors(
              baseColor: widget.isFilled ? widget.bgColor : AppColors().whiteColor,
              highlightColor: widget.shimmerColor,
              child: Container(
                height: widget.buttonHeight ?? 8.h,
                width: 90.w,
                decoration: BoxDecoration(
                    borderRadius: widget.noNeedBorderRadius != null ? BorderRadius.circular(0) : BorderRadius.circular(4),
                    border: Border.all(color: widget.borderColor ?? Colors.transparent),
                    color: widget.isFilled ? widget.bgColor : AppColors().whiteColor),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.textColor,
                    fontFamily: CustomFonts.family1Medium,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
