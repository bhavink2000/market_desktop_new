import 'package:flutter_super_html_viewer/flutter_super_html_viewer.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/MarketWatchScreen/marketWatchController.dart';
import '../../../../constant/index.dart';
import '../../../../main.dart';

class RulesPopUpScreen extends BaseView<MarketWatchController> {
  const RulesPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return Container(
      // width: 30.w,
      // height: 28.h,
      width: 25.w,
      // height: 40.h,

      child: Column(
        children: [
          headerViewContent(
              title: "Rules & Regulations",
              isFilterAvailable: false,
              isFromMarket: false,
              closeClick: () {
                controller.isScripDetailOpen = false;
                controller.update();
                Get.back();
              }),
          Expanded(
              child: SingleChildScrollView(
            child: SingleChildScrollView(
              child: HtmlWidget(
                constantValues!.settingData!.rulesAndRegulations!,
              ),
            ),
          )),
        ],
      ),
    );
  }

  String isOddLot() {
    var obj = controller.arrExchange.firstWhereOrNull((element) =>
        element.exchangeId == controller.selectedSymbol!.exchangeId);
    if (obj != null) {
      return obj.oddLotTradeValue!;
    }
    return "";
  }

  Widget sheetList(String name, String value, int index) {
    Color backgroundColor =
        index % 2 == 1 ? AppColors().headerBgColor : AppColors().contentBg;
    return Container(
      width: 100.w,
      height: 38,
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Row(
          children: [
            Text(name.toString(),
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: CustomFonts.family1Regular,
                    color: AppColors().lightText)),
            const Spacer(),
            Text(value.toString(),
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: CustomFonts.family1Medium,
                    color: AppColors().darkText)),
          ],
        ),
      ),
    );
  }
}
