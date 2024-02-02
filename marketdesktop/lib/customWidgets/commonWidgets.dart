import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/tableColumnsModelClass.dart';

import '../constant/index.dart';
import '../screens/MainTabs/ViewTab/MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';

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

double setWidthDynamic(
  int index, {
  bool isBig = false,
  bool isSmall = false,
  bool isSmallLarge = false,
  bool isForDate = false,
  bool isLarge = false,
  bool isExtraLarge = false,
  List<ListItem>? arrListTitle,
}) {
  var width = arrListTitle![index].normalUpdated;

  if (isBig) {
    width = arrListTitle[index].bigUpdated;
  } else if (isSmall) {
    width = arrListTitle[index].smallUpdated;
  } else if (isSmallLarge) {
    width = arrListTitle[index].smallLargeUpdated;
  } else if (isLarge) {
    width = arrListTitle[index].largeUpdated;
  } else if (isExtraLarge) {
    width = arrListTitle[index].extraLargeUpdated;
  } else if (isForDate) {
    width = arrListTitle[index].forDateUpdated;
  }
  // if (arrListTitle[index].isSortingActive) {
  //   width += 3.h;
  // }

  return width;
}

Widget dynamicTitleBox(
  String title,
  int index,
  List<ListItem> arrListTitle,
  RxBool isScrollEnable, {
  bool isBig = false,
  bool isSmall = false,
  bool isSmallLarge = false,
  bool isLarge = false,
  bool isExtraLarge = false,
  bool isForDate = false,
  Function? onClickImage,
  bool isImage = false,
  String? strImage = "",
  bool hasFilterIcon = false,
  Function? updateCallback,
}) {
  return Row(
    key: Key('$index'),
    children: [
      ReorderableDragStartListener(
        enabled: true,
        index: index,
        child: isImage == false
            ? Container(
                color: AppColors().backgroundColor,
                width: setWidthDynamic(index, isBig: isBig, isSmall: isSmall, isLarge: isLarge, isExtraLarge: isExtraLarge, isSmallLarge: isSmallLarge, isForDate: isForDate, arrListTitle: arrListTitle),
                height: 3.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Text(title, style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1SemiBold, color: AppColors().fontColor)),
                    const Spacer(),
                  ],
                ),
              )
            : GestureDetector(
                key: Key(strImage!),
                onTap: () {
                  if (onClickImage != null) {
                    onClickImage();
                  }
                },
                child: Container(
                  color: AppColors().backgroundColor,
                  height: 3.h,
                  padding: const EdgeInsets.only(left: 22, right: 22),
                  child: Image.asset(
                    strImage,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
      ),
      MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        child: GestureDetector(
          onPanStart: (details) {
            arrListTitle![index].start = details.localPosition;
            isScrollEnable.value = false;
          },
          onPanEnd: (details) {
            arrListTitle![index].start = null;
            if (updateCallback != null) {
              isScrollEnable.value = true;
              updateCallback();
            }

            if (isBig) {
              arrListTitle[index].big = arrListTitle[index].bigUpdated;
            } else if (isSmall) {
              arrListTitle[index].small = arrListTitle[index].smallUpdated;
            } else if (isLarge) {
              arrListTitle[index].large = arrListTitle[index].largeUpdated;
            } else if (isExtraLarge) {
              arrListTitle[index].extraLarge = arrListTitle[index].extraLargeUpdated;
            } else if (isForDate) {
              arrListTitle[index].forDate = arrListTitle[index].forDateUpdated;
            } else {
              arrListTitle[index].normal = arrListTitle[index].normalUpdated;
            }
          },
          onPanUpdate: (details) {
            var diff = details.localPosition.dx - arrListTitle![index].start!.dx;
            if ((globalMaxWidth + diff) >= globalScreenSize.width) {
              globalMaxWidth = globalScreenSize.width + diff;
            }

            if (isBig) {
              if ((arrListTitle[index].big + diff) >= arrListTitle[index].bigOriginal) {
                arrListTitle[index].bigUpdated = arrListTitle[index].big + diff;
              }
            } else if (isSmall) {
              if ((arrListTitle[index].small + diff) >= arrListTitle[index].smallOriginal) {
                arrListTitle[index].smallUpdated = arrListTitle[index].small + diff;
              }
            } else if (isSmallLarge) {
              if ((arrListTitle[index].smallLarge + diff) >= arrListTitle[index].smallLarge) {
                arrListTitle[index].smallLargeUpdated = arrListTitle[index].smallLarge + diff;
              }
            } else if (isLarge) {
              if ((arrListTitle[index].large + diff) >= arrListTitle[index].largeOriginal) {
                arrListTitle[index].largeUpdated = arrListTitle[index].large + diff;
              }
            } else if (isExtraLarge) {
              if ((arrListTitle[index].extraLarge + diff) >= arrListTitle[index].extraLargeOriginal) {
                arrListTitle[index].extraLargeUpdated = arrListTitle[index].extraLarge + diff;
              }
            } else if (isForDate) {
              if ((arrListTitle[index].forDate + diff) >= arrListTitle[index].forDateOriginal) {
                arrListTitle[index].forDateUpdated = arrListTitle[index].forDate + diff;
              }
            } else {
              if ((arrListTitle[index].normal + diff) >= arrListTitle[index].normalOriginal) {
                arrListTitle[index].normalUpdated = arrListTitle[index].normal + diff;
              }
            }
            if (updateCallback != null) {
              updateCallback();
            }
          },
          child: Container(
            height: 3.h,
            width: 5,
            color: AppColors().backgroundColor,
            child: Center(
              child: Container(
                color: AppColors().whiteColor,
                width: 2,
              ),
            ),
          ),
        ),
      )
    ],
  );
}

Widget dynamicTitleBox1(
  String title,
  int index,
  List<ColumnItem> arrListTitle,
  RxBool isScrollEnable, {
  bool isBig = false,
  bool isSmall = false,
  bool isSmallLarge = false,
  bool isLarge = false,
  bool isExtraLarge = false,
  bool isForDate = false,
  Function? onClickImage,
  bool isImage = false,
  String? strImage = "",
  bool hasFilterIcon = false,
  Function? updateCallback,
}) {
  return Row(
    key: Key('$index'),
    children: [
      ReorderableDragStartListener(
        enabled: true,
        index: index,
        child: isImage == false
            ? Container(
                color: AppColors().backgroundColor,
                width: arrListTitle[index].width ?? 100,
                height: 3.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Text(title, style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1SemiBold, color: AppColors().fontColor)),
                    const Spacer(),
                  ],
                ),
              )
            : GestureDetector(
                key: Key(strImage!),
                onTap: () {
                  if (onClickImage != null) {
                    onClickImage();
                  }
                },
                child: Container(
                  color: AppColors().backgroundColor,
                  height: 3.h,
                  padding: const EdgeInsets.only(left: 22, right: 22),
                  child: Image.asset(
                    strImage,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
      ),
      MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        child: GestureDetector(
          onPanStart: (details) {
            arrListTitle![index].start = details.localPosition;
            isScrollEnable.value = false;
          },
          onPanEnd: (details) {
            arrListTitle![index].start = Offset.zero;
            if (updateCallback != null) {
              isScrollEnable.value = true;
              updateCallback();
            }
          },
          onPanUpdate: (details) {
            var diff = details.localPosition.dx - arrListTitle![index].start!.dx;
            if ((globalMaxWidth + diff) >= globalScreenSize.width) {
              globalMaxWidth = globalScreenSize.width + diff;
            }
            if ((arrListTitle[index].width! + diff) >= arrListTitle[index].defaultWidth!) {
              arrListTitle[index].width = arrListTitle[index].defaultWidth! + diff;
            }
            if (updateCallback != null) {
              updateCallback();
            }
          },
          child: Container(
            height: 3.h,
            width: 5,
            color: AppColors().backgroundColor,
            child: Center(
              child: Container(
                color: AppColors().whiteColor,
                width: 2,
              ),
            ),
          ),
        ),
      )
    ],
  );
}

Widget dynamicValueBox(String title, Color? bgColor, Color? textColor, int index, int titleIndex, List<ListItem> arrListTitle,
    {bool isBig = false,
    isUnderlined = false,
    bool isLarge = false,
    bool isSmall = false,
    bool isForDate = false,
    bool isExtraLarge = false,
    bool isSmallLarge = false,
    Function? onClickValue,
    Function? onClickImage,
    Function? onSwitchChanged,
    bool isImage = false,
    RxBool? switchValue,
    bool isSwitch = false,
    String? strImage = ""}) {
  try {
    return isImage == false && isSwitch == false
        ? IgnorePointer(
            ignoring: onClickValue == null,
            child: Container(
              width: setWidthDynamic(titleIndex, isBig: isBig, isSmall: isSmall, isLarge: isLarge, isExtraLarge: isExtraLarge, isSmallLarge: isSmallLarge, isForDate: isForDate, arrListTitle: arrListTitle) + 5,
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
                      width: setWidthDynamic(titleIndex, isBig: isBig, isSmall: isSmall, isLarge: isLarge, isExtraLarge: isExtraLarge, isSmallLarge: isSmallLarge, isForDate: isForDate, arrListTitle: arrListTitle) - 20,
                      child: Text(title,
                          textAlign: TextAlign.start, style: TextStyle(fontSize: 13, overflow: TextOverflow.ellipsis, fontFamily: CustomFonts.family1Regular, color: textColor != null ? textColor : AppColors().darkText, decoration: isUnderlined ? TextDecoration.underline : TextDecoration.none)),
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
                  width: setWidthDynamic(titleIndex, isBig: isBig, isSmall: isSmall, isLarge: isLarge, isExtraLarge: isExtraLarge, isSmallLarge: isSmallLarge, isForDate: isForDate, arrListTitle: arrListTitle) + 5,
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
                            if (onSwitchChanged != null) {
                              onSwitchChanged(value);
                            }
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
                  width: setWidthDynamic(titleIndex, isBig: isBig, isSmall: isSmall, isLarge: isLarge, isExtraLarge: isExtraLarge, isSmallLarge: isSmallLarge, isForDate: isForDate, arrListTitle: arrListTitle) + 2,
                  color: bgColor,
                  padding: EdgeInsets.only(left: isBig ? 3.4.w : 1.1.w, right: isBig ? 3.4.w : 1.1.w),
                  child: Image.asset(
                    strImage ?? "",
                    width: 20,
                    height: 20,
                  ),
                ),
              );
  } catch (e) {
    print(e);
    return SizedBox();
  }
}

Widget dynamicValueBox1(String title, Color? bgColor, Color? textColor, int index, int titleIndex, List<ColumnItem> arrListTitle,
    {bool isBig = false,
    isUnderlined = false,
    bool isLarge = false,
    bool isSmall = false,
    bool isForDate = false,
    bool isExtraLarge = false,
    bool isSmallLarge = false,
    Function? onClickValue,
    Function? onClickImage,
    Function? onSwitchChanged,
    bool isImage = false,
    RxBool? switchValue,
    bool isSwitch = false,
    String? strImage = ""}) {
  try {
    return isImage == false && isSwitch == false
        ? IgnorePointer(
            ignoring: onClickValue == null,
            child: Container(
              width: (arrListTitle[titleIndex].width ?? 0) + 5,
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
                      width: (arrListTitle[titleIndex].width ?? 0) - 20,
                      child: Text(title,
                          textAlign: TextAlign.start, style: TextStyle(fontSize: 13, overflow: TextOverflow.ellipsis, fontFamily: CustomFonts.family1Regular, color: textColor != null ? textColor : AppColors().darkText, decoration: isUnderlined ? TextDecoration.underline : TextDecoration.none)),
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
                  width: (arrListTitle[index].width ?? 0) + 5,
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
                            if (onSwitchChanged != null) {
                              onSwitchChanged(value);
                            }
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
                  width: (arrListTitle[index].width ?? 0) + 2,
                  color: bgColor,
                  padding: EdgeInsets.only(left: isBig ? 3.4.w : 1.1.w, right: isBig ? 3.4.w : 1.1.w),
                  child: Image.asset(
                    strImage ?? "",
                    width: 20,
                    height: 20,
                  ),
                ),
              );
  } catch (e) {
    print(e);
    return SizedBox();
  }
}

Widget valueBox(String title, double width, Color? bgColor, Color? textColor, int index,
    {bool isBig = false,
    isUnderlined = false,
    bool isLarge = false,
    bool isSmall = false,
    bool isForDate = false,
    bool isExtraLarge = false,
    Function? onClickValue,
    Function? onClickImage,
    Function? onSwitchChanged,
    bool isImage = false,
    RxBool? switchValue,
    bool isSwitch = false,
    String? strImage = ""}) {
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
                        textAlign: TextAlign.start, style: TextStyle(fontSize: 13, overflow: TextOverflow.ellipsis, fontFamily: CustomFonts.family1Regular, color: textColor != null ? textColor : AppColors().darkText, decoration: isUnderlined ? TextDecoration.underline : TextDecoration.none)),
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
                          if (onSwitchChanged != null) {
                            onSwitchChanged(value);
                          }
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

var commonFocusBorder = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  contentPadding: const EdgeInsets.only(left: 0),
  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors().blueColor, width: 2)),
  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors().lightOnlyText, width: 1)),
);
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
        // GestureDetector(
        //   onTap: () {
        //     if (onCLickPDF != null) {
        //       onCLickPDF();
        //     }
        //   },
        //   child: Image.asset(
        //     AppImages.pdfIcon,
        //     width: 30,
        //     height: 30,
        //   ),
        // ),
        // SizedBox(
        //   height: 10,
        // ),
        // GestureDetector(
        //   onTap: () {
        //     if (onCLickExcell != null) {
        //       onCLickExcell();
        //     }
        //   },
        //   child: Image.asset(
        //     AppImages.excelIcon,
        //     width: 25,
        //     height: 25,
        //   ),
        // ),
        // SizedBox(
        //   height: 10,
        // ),
        // GestureDetector(
        //   onTap: () {
        //     if (onCLickFilter != null) {
        //       onCLickFilter();
        //     }
        //   },
        //   child: Row(
        //     children: [
        //       Container(
        //         width: 3,
        //         height: 50,
        //         color: AppColors().blueColor,
        //       ),
        //       SizedBox(
        //         width: 10,
        //       ),
        //       RotatedBox(
        //         quarterTurns: 1,
        //         child: Text(name != "" ? name : "Filter",
        //             style: TextStyle(
        //               fontSize: 12,
        //               fontFamily: CustomFonts.family1Medium,
        //               color: AppColors().fontColor,
        //             )),
        //       )
        //     ],
        //   ),
        // ),
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
