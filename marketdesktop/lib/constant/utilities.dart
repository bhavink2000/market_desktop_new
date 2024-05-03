import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:floating_dialog/floating_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart' as excelLib;
import 'package:flutter_to_pdf/args/color.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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

getAlphabetMap() {
  List<String> excelStyleAlphabetSequence = [];

  for (int row = 1; row <= 26; row++) {
    for (int col = 1; col <= 26; col++) {
      int position = (row - 1) * 26 + col;
      if (position <= 26) {
        excelStyleAlphabetSequence.add(String.fromCharCode(position + 64));
      } else {
        int firstDigit = (position - 1) ~/ 26;
        int secondDigit = (position - 1) % 26 + 1;
        excelStyleAlphabetSequence.add('${String.fromCharCode(firstDigit + 64)}${String.fromCharCode(secondDigit + 64)}');
      }
    }
  }
  return excelStyleAlphabetSequence;
}

Future<void> generatePdfFromExcel(String excelFilePath) async {
  final pdf = pw.Document();

  // Read the Excel file
  var file = File(excelFilePath);
  var bytes = file.readAsBytesSync();
  var excel = excelLib.Excel.decodeBytes(bytes);

  excel.tables.keys.forEach((sheetName) {
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: excel.tables[sheetName]!.rows.map((row) {
              return pw.Text(row.join(', ')); // Create a text widget for each row
            }).toList(),
          );
        },
      ),
    );
  });
  final path = await FilePicker.platform.saveFile(
    dialogTitle: 'Please select an output file:',
    fileName: excelFilePath.split("/").last.split(".").first + ".pdf",
  );
  if (path != null) {
    final file = File(path);

    file.writeAsBytesSync(await pdf.save());
  }
}

exportExcelFile(String fileName, List<excelLib.TextCellValue?> titleList, List<List<excelLib.TextCellValue?>> dataList) async {
  final excel = excelLib.Excel.createExcel();
  final sheet = excel['Sheet1'];
  var listCellHeader = getAlphabetMap();
  sheet.appendRow(titleList);
  excelLib.CellStyle cellStyle = excelLib.CellStyle(bold: true, backgroundColorHex: excelLib.ExcelColor.fromHexString("#2173FD"), fontColorHex: excelLib.ExcelColor.fromHexString("ffffff"));
  for (var i = 0; i < titleList.length; i++) {
    sheet.setColumnAutoFit(i);
    var cell = sheet.cell(excelLib.CellIndex.indexByString("${listCellHeader[i]}1"));
    cell.cellStyle = cellStyle;
  }

  for (var element in dataList) {
    sheet.appendRow(element);
  }

  fileName = fileName.split(".").first;

  final path = await FilePicker.platform.saveFile(
    dialogTitle: 'Please select an output file:',
    fileName: fileName + ".xlsx",
  );
  if (path != null) {
    final file = File(path);

    file.writeAsBytesSync(excel.encode()!);
  }
}

Future<void> exportExcelWithTwoSheetFile(
  String fileName,
  String sheet1Name,
  String sheet2Name,
  List<excelLib.TextCellValue?> titleList,
  List<List<excelLib.TextCellValue?>> dataList1,
  List<List<excelLib.TextCellValue?>> dataList2,
) async {
  final excel = excelLib.Excel.createExcel();
  // Use your existing code to create or reference sheet1 and sheet2
  final sheet1 = excel["Sheet1"];
  final sheet2 = excel["Sheet2"];

  // Assuming getAlphabetMap() gives you a mapping to Excel columns ('A', 'B', 'C', ...)
  var listCellHeader = getAlphabetMap();

  sheet1.merge(excelLib.CellIndex.indexByString("A1"), excelLib.CellIndex.indexByString("D1"), customValue: excelLib.TextCellValue("Profit"));

  sheet2.merge(excelLib.CellIndex.indexByString("A1"), excelLib.CellIndex.indexByString("D1"), customValue: excelLib.TextCellValue("Loss"));

  excelLib.CellStyle cellStyleHeader = excelLib.CellStyle(bold: true, backgroundColorHex: excelLib.ExcelColor.fromHexString("#2173FD"), fontColorHex: excelLib.ExcelColor.fromHexString("ffffff"), horizontalAlign: excelLib.HorizontalAlign.Center, fontSize: 16);
  var cell1 = sheet1.cell(excelLib.CellIndex.indexByString("A1"));
  var cell2 = sheet2.cell(excelLib.CellIndex.indexByString("A1"));
  cell1.cellStyle = cellStyleHeader;
  cell2.cellStyle = cellStyleHeader;

  sheet1.appendRow(titleList);
  sheet2.appendRow(titleList);
  excelLib.CellStyle cellStyle = excelLib.CellStyle(bold: true, backgroundColorHex: excelLib.ExcelColor.fromHexString("#2173FD"), fontColorHex: excelLib.ExcelColor.fromHexString("ffffff"));
  for (var i = 0; i < titleList.length; i++) {
    sheet2.setColumnAutoFit(i);
    sheet1.setColumnAutoFit(i);
    var cell1 = sheet1.cell(excelLib.CellIndex.indexByString("${listCellHeader[i]}2"));
    var cell2 = sheet2.cell(excelLib.CellIndex.indexByString("${listCellHeader[i]}2"));
    cell1.cellStyle = cellStyle;
    cell2.cellStyle = cellStyle;
  }

  for (var element in dataList1) {
    sheet1.appendRow(element);
  }
  for (var element in dataList2) {
    sheet2.appendRow(element);
  }
  fileName = fileName.split(".").first;

  final path = await FilePicker.platform.saveFile(
    dialogTitle: 'Please select an output file:',
    fileName: fileName + ".xlsx",
  );
  if (path != null) {
    final file = File(path);

    file.writeAsBytesSync(excel.encode()!);
  }
}

exportPDFWith2DataFile({required String fileName, required String title, required String title1, required double width, required List<String> titleList, required List<List<dynamic>> dataList, required List<List<dynamic>> dataList1}) async {
  try {
    final pdf = pw.Document();
    var data1 = dataList.length;
    var data2 = dataList1.length;
    var count = data1 > data2 ? data2 : data1;
    var height = (count * 30) + 150;
    var format = PdfPageFormat(width, height.toDouble() < 841.89 ? 841.89 : height.toDouble(), marginAll: 10);
    final headerStyle = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14);
    final titleTextStyle = pw.TextStyle(
      fontWeight: pw.FontWeight.bold,
      color: AppColors().blueColor.toPdfColor(),
      fontSize: 18,
    );
    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Row(children: [
              pw.Expanded(
                child: pw.Column(children: [
                  pw.Header(
                    level: 0,
                    child: pw.Center(
                      child: pw.Text(title, style: titleTextStyle),
                    ),
                  ),

                  // Add a SizedBox or Divider for spacing

                  // Then add your table or content
                  pw.TableHelper.fromTextArray(
                    headers: titleList,
                    data: dataList,
                    headerStyle: headerStyle,
                    headerDecoration: pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    cellHeight: 30.0,
                    headerHeight: 40.0,
                  ),
                ]),
              ),
              pw.SizedBox(width: 20),
              pw.Expanded(
                  child: pw.Column(children: [
                pw.Header(
                  level: 0,
                  child: pw.Center(
                    child: pw.Text(title1, style: titleTextStyle),
                  ),
                ),
                pw.TableHelper.fromTextArray(
                  headers: titleList,
                  data: dataList1,
                  headerStyle: headerStyle,
                  headerDecoration: pw.BoxDecoration(
                    color: PdfColors.grey300,
                  ),
                  cellHeight: 30.0,
                  headerHeight: 40.0,
                ),
              ])),
            ]),

            // You can add more widgets here for additional content
          ];
        },
      ),
    );

    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: fileName + ".pdf",
    );

    final File file = File(path!);
    await file.writeAsBytes(await pdf.save());
  } catch (e) {
    print(e);
  }
}

exportPDFFile({required String fileName, required String title, required double width, required List<String> titleList, required List<List<dynamic>> dataList}) async {
  try {
    final pdf = pw.Document();

    var format = PdfPageFormat(width, 841.89, marginAll: 10);
    final headerStyle = pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14);
    final titleTextStyle = pw.TextStyle(
      fontWeight: pw.FontWeight.bold,
      color: AppColors().blueColor.toPdfColor(),
      fontSize: 18,
    );
    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Center(
                child: pw.Text(title, style: titleTextStyle),
              ),
            ),

            // Add a SizedBox or Divider for spacing

            // Then add your table or content
            pw.TableHelper.fromTextArray(
              headers: titleList,
              data: dataList,
              headerStyle: headerStyle,
              headerDecoration: pw.BoxDecoration(
                color: PdfColors.grey300,
              ),
              cellHeight: 30.0,
              headerHeight: 40.0,
            ),
            // You can add more widgets here for additional content
          ];
        },
      ),
    );

    final path = await FilePicker.platform.saveFile(
      dialogTitle: 'Please select an output file:',
      fileName: fileName + ".pdf",
    );

    final File file = File(path!);
    await file.writeAsBytes(await pdf.save());
  } catch (e) {
    print(e);
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
      animationDuration: Duration(milliseconds: 500),
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
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.transparent, width: 1), color: AppColors().redColor),
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
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.transparent, width: 1), color: AppColors().blueColor),
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
