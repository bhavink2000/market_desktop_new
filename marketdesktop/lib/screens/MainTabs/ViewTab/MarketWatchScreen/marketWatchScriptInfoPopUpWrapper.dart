import 'package:get/get.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/MarketWatchScreen/marketWatchController.dart';
import '../../../../constant/index.dart';

class MArketWatchScriptInfoPopUpScreen extends BaseView<MarketWatchController> {
  const MArketWatchScriptInfoPopUpScreen({Key? key}) : super(key: key);

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
              title: "Script Info",
              isFilterAvailable: false,
              isFromMarket: false,
              closeClick: () {
                controller.isScripDetailOpen = false;
                controller.update();
                Get.back();
              }),
          Expanded(
              child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  clipBehavior: Clip.hardEdge,
                  shrinkWrap: true,
                  children: [
                    sheetList("Exchange Name", controller.selectedSymbol!.exchange ?? "", 0),
                    sheetList("Script", controller.selectedSymbol!.symbolTitle!, 1),
                    sheetList("Expiry Date", shortFullDateTime(controller.selectedSymbol!.expiry!), 2),
                    sheetList("Lot Size", controller.selectedScript.value!.ls!.toString(), 3),
                    sheetList("Trade Margin", controller.selectedSymbol!.tradeMargin!.toString(), 4),
                    sheetList("Trade Attribute", controller.selectedSymbol!.tradeAttribute!.toString(), 5),
                    sheetList("Odd Lot Trade", isOddLot(), 6),
                    sheetList("Max Qty", controller.selectedSymbol!.quantityMax!.toString(), 7),
                    sheetList("Breakup Qty", controller.selectedSymbol!.breakQuantity!.toString(), 8),
                    sheetList("Max Lot", controller.selectedSymbol!.lotMax!.toString(), 9),
                    sheetList("Breakup Lot", controller.selectedSymbol!.breakUpLot!.toString(), 10),
                  ],
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  String isOddLot() {
    var obj = controller.arrExchange.firstWhereOrNull((element) => element.exchangeId == controller.selectedSymbol!.exchangeId);
    if (obj != null) {
      return obj.oddLotTradeValue!;
    }
    return "";
  }

  Widget sheetList(String name, String value, int index) {
    Color backgroundColor = index % 2 == 1 ? AppColors().headerBgColor : AppColors().contentBg;
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
            Text(name.toString(), style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Regular, color: AppColors().lightText)),
            const Spacer(),
            Text(value.toString(), style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
          ],
        ),
      ),
    );
  }
}
