import 'package:get/get.dart';
import 'package:marketdesktop/screens/UserDetailPopups/IPTradeAlertPopUp/ipTradeAlertController.dart';
import '../../../constant/index.dart';

class IPTradeAlertPopUpScreen extends BaseView<IPTradeAlertPopUpController> {
  IPTradeAlertPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return Container(
      // width: 30.w,
      // height: 28.h,
      width: 25.w,

      decoration: BoxDecoration(border: Border.all(color: AppColors().lightOnlyText, width: 1)),
      child: Column(
        children: [
          headerViewContent(Get.context!),
          Container(
              height: 300,
              decoration: BoxDecoration(borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)), color: AppColors().bgColor),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      clipBehavior: Clip.hardEdge,
                      shrinkWrap: true,
                      children: [
                        sheetList("Exchange", controller.values?.exchangeName ?? "", 0),
                        sheetList("Symbol", controller.values?.symbolTitle ?? "", 1, isUnderline: false),

                        // sheetList("Total Sell Qty", controller.values!.sellTotalQuantity!.toString(), 3),
                        sheetList("Qty", controller.values!.totalQuantity!.toString(), 4),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Text("UserName",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: CustomFonts.family1SemiBold,
                            color: AppColors().darkText,
                          )),
                      Spacer(),
                      Text("TotalQty",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: CustomFonts.family1SemiBold,
                            color: AppColors().darkText,
                          )),
                      SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        clipBehavior: Clip.hardEdge,
                        itemCount: controller.values!.userWiseData!.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return orderContent(context, index);
                        }),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget orderContent(BuildContext context, int index) {
    var element = controller.values!.userWiseData![index];
    return Container(
      height: 40,
      child: Row(
        children: [
          SizedBox(
            width: 15,
          ),
          Text(element.userName!,
              style: TextStyle(
                fontSize: 14,
                fontFamily: CustomFonts.family2Regular,
                color: AppColors().darkText,
              )),
          Spacer(),
          Text(element.totalQuantity!.toString(),
              style: TextStyle(
                fontSize: 14,
                fontFamily: CustomFonts.family2Regular,
                color: AppColors().darkText,
              )),
          SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }

  Widget sheetList(String name, String value, int index, {bool isUnderline = false}) {
    Color backgroundColor = index % 2 == 1 ? AppColors().headerBgColor : AppColors().contentBg;
    return GestureDetector(
      onTap: () {
        if (isUnderline) {
          controller.redirectTradeScreen();
        }
      },
      child: Container(
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
                    color: AppColors().lightText,
                  )),
              const Spacer(),
              Text(
                value.toString(),
                style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText, decoration: isUnderline ? TextDecoration.underline : TextDecoration.none),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerViewContent(BuildContext context) {
    return Container(
        width: 100.w,
        height: 4.h,
        decoration: BoxDecoration(
            color: AppColors().whiteColor,
            border: Border(
              bottom: BorderSide(color: AppColors().lightOnlyText, width: 1),
            )),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Image.asset(
              AppImages.appLogo,
              width: 3.h,
              height: 3.h,
            ),
            const SizedBox(
              width: 10,
            ),
            Text("IP Alert Trades",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().blueColor,
                )),
            const Spacer(),
            GestureDetector(
              onTap: () {
                isSuperAdminPopUpOpen = false;
                Get.back();
              },
              child: Container(
                width: 3.h,
                height: 3.h,
                padding: EdgeInsets.all(0.5.h),
                child: Image.asset(
                  AppImages.closeIcon,
                  color: AppColors().redColor,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ));
  }
}
