import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../constant/index.dart';

Widget titleBox(String title, {bool isBig = false, bool isSmall = false, bool isLarge = false, bool isForDate = false, bool isExtraLarge = false, Function? onClickImage, bool isImage = false, String? strImage = ""}) {
  return isImage == false
      ? Container(
          color: AppColors().backgroundColor,
          width: isBig
              ? 150
              : isSmall
                  ? 63
                  : isLarge
                      ? 280
                      : isExtraLarge
                          ? 500
                          : isForDate
                              ? 170
                              : 110,
          height: 3.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              Text(title.toUpperCase(), style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1SemiBold, color: AppColors().fontColor)),
              Spacer(),
              Container(
                height: 3.h,
                width: 2,
                color: AppColors().whiteColor,
              )
            ],
          ),
        )
      : GestureDetector(
          onTap: () {
            if (onClickImage != null) {
              onClickImage();
            }
          },
          child: Container(
            color: AppColors().backgroundColor,
            height: 3.h,
            padding: EdgeInsets.only(left: 22, right: 22),
            child: Image.asset(
              strImage ?? "",
              width: 20,
              height: 20,
            ),
          ),
        );
}

Widget valueBox(String title, double width, Color? bgColor, Color? textColor, int index,
    {bool isBig = false, isUnderlined = false, bool isLarge = false, bool isSmall = false, bool isForDate = false, bool isExtraLarge = false, Function? onClickValue, Function? onClickImage, bool isImage = false, RxBool? switchValue, bool isSwitch = false, String? strImage = ""}) {
  return isImage == false && isSwitch == false
      ? IgnorePointer(
          ignoring: onClickValue == null,
          child: Container(
            width: isBig
                ? ListCellWidth().big
                : isSmall
                    ? ListCellWidth().small
                    : isLarge
                        ? ListCellWidth().large
                        : isExtraLarge
                            ? ListCellWidth().extraLarge
                            : isForDate
                                ? ListCellWidth().bigForDate
                                : ListCellWidth().normal,
            color: bgColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    if (onClickValue != null) {
                      onClickValue();
                    }
                  },
                  child: Container(
                    width: isBig
                        ? ListCellWidth().big - 20
                        : isSmall
                            ? ListCellWidth().small - 20
                            : isLarge
                                ? ListCellWidth().large - 20
                                : isExtraLarge
                                    ? ListCellWidth().extraLarge - 20
                                    : isForDate
                                        ? ListCellWidth().bigForDate - 20
                                        : ListCellWidth().normal - 20,
                    child: Text(title,
                        textAlign: TextAlign.start, style: TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis, fontFamily: CustomFonts.family1Regular, color: textColor != null ? textColor : AppColors().darkText, decoration: isUnderlined ? TextDecoration.underline : TextDecoration.none)),
                  ),
                ),
                // SizedBox(
                //   width: 20,
                // ),
                Spacer(),
                Container(
                  height: 3.h,
                  width: 2,
                  color: AppColors().whiteColor,
                )
              ],
            ),
          ),
        )
      : isSwitch
          ? Obx(() {
              return Container(
                width: isBig
                    ? ListCellWidth().big
                    : isSmall
                        ? ListCellWidth().small
                        : isLarge
                            ? ListCellWidth().large
                            : isExtraLarge
                                ? ListCellWidth().extraLarge
                                : ListCellWidth().normal,
                height: 3.h,
                color: bgColor,
                // padding: EdgeInsets.symmetric(horizontal: 80),
                child: Row(
                  children: [
                    Transform.scale(
                      scale: 0.7,
                      child: Switch(
                        value: switchValue!.value,
                        activeColor: AppColors().blueColor,
                        onChanged: (bool value) async {
                          switchValue.value = value;
                        },
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: 3.h,
                      width: 2,
                      color: AppColors().whiteColor,
                    )
                  ],
                ),
              );
            })
          : GestureDetector(
              onTap: () {
                if (onClickImage != null) {
                  onClickImage();
                }
              },
              child: Container(
                height: 3.h,
                width: isBig
                    ? 150
                    : isSmall
                        ? 63
                        : isLarge
                            ? 280
                            : isExtraLarge
                                ? 500
                                : 110,
                color: bgColor,
                padding: EdgeInsets.only(left: isBig ? 3.4.w : 1.1.w, right: isBig ? 3.4.w : 1.1.w),
                child: Image.asset(
                  strImage ?? "",
                  width: 20,
                  height: 20,
                ),
              ),
            );
}

Widget filterPanel(
  BuildContext context, {
  bool? isRecordDisplay = false,
  Function? onCLickFilter,
  Function? onCLickExcell,
  Function? onCLickPDF,
  double? bottomMargin,
  int? totalRecord,
  String name = "",
}) {
  return Container(
    width: 40,
    margin: EdgeInsets.only(bottom: bottomMargin ?? 2.h),
    decoration: BoxDecoration(color: AppColors().headerBgColor, border: Border(left: BorderSide(color: AppColors().lightOnlyText, width: 1), bottom: BorderSide(color: AppColors().whiteColor, width: 1), right: BorderSide(color: AppColors().whiteColor, width: 1))),
    // color: Colors.red,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {
            if (onCLickPDF != null) {
              onCLickPDF();
            }
          },
          child: Image.asset(
            AppImages.pdfIcon,
            width: 30,
            height: 30,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            if (onCLickExcell != null) {
              onCLickExcell();
            }
          },
          child: Image.asset(
            AppImages.excelIcon,
            width: 25,
            height: 25,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            if (onCLickFilter != null) {
              onCLickFilter();
            }
          },
          child: Row(
            children: [
              Container(
                width: 3,
                height: 50,
                color: AppColors().blueColor,
              ),
              SizedBox(
                width: 10,
              ),
              RotatedBox(
                quarterTurns: 1,
                child: Text(name != "" ? name : "Filter",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: CustomFonts.family1Medium,
                      color: AppColors().fontColor,
                    )),
              )
            ],
          ),
        ),
        Spacer(),
        if (isRecordDisplay == true)
          RotatedBox(
            quarterTurns: 1,
            child: Text("Record : ${totalRecord ?? 0}",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().fontColor,
                )),
          ),
        SizedBox(
          height: 10,
        ),
      ],
    ),
  );
}
