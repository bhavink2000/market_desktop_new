import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/constant/index.dart';
import 'package:marketdesktop/screens/MainTabs/ToolsTab/MarketTimingScreen/marketTimingScreenController.dart';
import 'package:marketdesktop/screens/MainTabs/ToolsTab/ShortcutScreen/shortcutController.dart';

import '../../../../../constant/color.dart';
import '../../../BaseController/baseController.dart';

class ShortcutScreen extends BaseView<ShortcutController> {
  const ShortcutScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().bgColor,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: AppColors().bgColor,
        ),
        child: Row(
          children: [
            Expanded(
                child: Column(children: [
              headerViewContent(
                  title: "Shortcuts",
                  isFilterAvailable: false,
                  isFromMarket: false,
                  closeClick: () {
                    Get.back();
                    Get.delete<MarketTimingController>();
                  }),
              ListView(
                physics: const NeverScrollableScrollPhysics(),
                clipBehavior: Clip.hardEdge,
                shrinkWrap: true,
                controller: controller.sheetController,
                children: [
                  // sheetList("Script", controller.selectedScript.value!.symbol.toString(), 0),
                  sheetList("BUY", "F1", 0),
                  sheetList("SELL", "F2", 1),
                  sheetList("PENDING ORDER", "F3", 2),
                  sheetList("MARKET PICTURE", "F5", 3),
                  sheetList("NET POSITION", "F6", 4),
                  sheetList("TRADES", "F8", 5),
                  sheetList("MESSAGES", "F10", 6),
                  sheetList("SELECT SCRIPT UPSIDE", "AERO UP", 7),
                  sheetList("SELECT SCRIPT DOWNSIDE", "AERO DOWN", 8),
                  sheetList("CUT SCRIPT", "CTRL + X", 9),
                  sheetList("PASTE SCRIPT", "CTRL + V", 10),
                  sheetList("UNDO SCRIPT", "CTRL + Z", 11),
                ],
              ),
            ]))
          ],
        ),
      ),
    );
  }

  Widget sheetList(String name, String value, int index) {
    Color backgroundColor = index % 2 == 0 ? AppColors().headerBgColor : AppColors().contentBg;
    return Container(
      width: 100.w,
      height: 38,
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 1.w,
        ),
        child: Row(
          children: [
            Text(name.toString(), style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
            const Spacer(),
            Text(value.toString(), style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1SemiBold, color: AppColors().blueColor)),
          ],
        ),
      ),
    );
  }
}
