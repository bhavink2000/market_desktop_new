import 'package:get/get.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/TradeScreen/tradeListController.dart';

import '../../../../constant/index.dart';
import '../../../../customWidgets/appButton.dart';

class TradeInfoPopUpScreen extends BaseView<TradeListController> {
  const TradeInfoPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return Container(
      // width: 30.w,
      // height: 28.h,
      width: 25.w,
      height: 40.h,

      child: Column(
        children: [
          headerViewContent(Get.context!),
          Container(
              height: 65.h,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      clipBehavior: Clip.hardEdge,
                      shrinkWrap: true,
                      children: [
                        sheetList("Order Id", controller.arrTrade[controller.selectedOrderIndex].tradeId ?? "", 0),
                        sheetList("Exchange", controller.arrTrade[controller.selectedOrderIndex].exchangeName ?? "", 1),
                        sheetList("Symbol", controller.arrTrade[controller.selectedOrderIndex].symbolTitle ?? "", 2),
                        sheetList("Username", controller.arrTrade[controller.selectedOrderIndex].userName ?? "", 3),
                        sheetList("Order Type", (controller.arrTrade[controller.selectedOrderIndex].orderTypeValue ?? "").toUpperCase(), 4),
                        sheetList("Qty", controller.arrTrade[controller.selectedOrderIndex].quantity.toString(), 5),
                        sheetList("Rate", controller.arrTrade[controller.selectedOrderIndex].price!.toStringAsFixed(2), 6),
                        sheetList("Reference Price", controller.arrTrade[controller.selectedOrderIndex].currentPriceFromSocket.toStringAsFixed(2), 7),
                        sheetList("Brokerage", controller.arrTrade[controller.selectedOrderIndex].brokerageAmount!.toStringAsFixed(2), 8),
                        sheetList("Order Timing", controller.arrTrade[controller.selectedOrderIndex].executionDateTime != null ? shortFullDateTime(controller.arrTrade[controller.selectedOrderIndex].executionDateTime!) : "", 9),
                        sheetList("Device", controller.arrTrade[controller.selectedOrderIndex].orderMethod ?? "", 10),
                        sheetList("IP Address", controller.arrTrade[controller.selectedOrderIndex].ipAddress ?? "", 11),
                        sheetList("Device Id", controller.arrTrade[controller.selectedOrderIndex].deviceId ?? "", 12),
                        sheetList("Device Location", "Not Available", 13),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (userData!.role != UserRollList.admin && userData!.role != UserRollList.superAdmin)
                        SizedBox(
                          width: 180,
                          height: 40,
                          child: CustomButton(
                            isEnabled: true,
                            shimmerColor: AppColors().whiteColor,
                            title: "Modify Trade",
                            textSize: 14,
                            onPress: () {
                              controller.priceController.text = controller.arrTrade[controller.selectedOrderIndex].price!.toString();
                              controller.lotController.text = (controller.arrTrade[controller.selectedOrderIndex].totalQuantity! / controller.arrTrade[controller.selectedOrderIndex].lotSize!).toStringAsFixed(2);

                              // controller.qtyController.text = controller.arrTrade[controller.selectedOrderIndex].totalQuantity!.toString();
                              Get.back();

                              controller.modifyBuySellPopupDialog(isFromBuy: controller.arrTrade[controller.selectedOrderIndex].tradeType == "buy" ? true : false);
                            },
                            focusKey: controller.modifyFocus,
                            borderColor: Colors.transparent,
                            focusShadowColor: AppColors().blueColor,
                            bgColor: AppColors().blueColor,
                            isFilled: true,
                            textColor: AppColors().whiteColor,
                            isTextCenter: true,
                            isLoading: controller.isApiCallRunning,
                          ),
                        ),
                      SizedBox(
                        width: 1.w,
                      ),
                      if (userData!.role != UserRollList.admin || (userData!.role == UserRollList.admin && userData!.executePendingOrder == 1))
                        SizedBox(
                          width: 180,
                          height: 40,
                          child: CustomButton(
                            isEnabled: true,
                            shimmerColor: AppColors().blueColor,
                            title: "Pending To Success",
                            textSize: 14,
                            prefixWidth: 0,
                            onPress: () {
                              Get.back();
                              showPermissionDialog(
                                  message: "Are you sure you want to pending to success order?",
                                  acceptButtonTitle: "Yes",
                                  rejectButtonTitle: "No",
                                  yesClick: () {
                                    Get.back();
                                    controller.pendingToSuccessTrade(controller.arrTrade[controller.selectedOrderIndex].tradeType == "buy" ? true : false);
                                  },
                                  noclick: () {
                                    Get.back();
                                  });
                            },
                            focusKey: controller.successFocus,
                            borderColor: Colors.transparent,
                            focusShadowColor: AppColors().blueColor,
                            bgColor: AppColors().grayBorderColor,
                            isFilled: true,
                            textColor: AppColors().blueColor,
                            isTextCenter: true,
                            isLoading: controller.isResetCall,
                          ),
                        ),
                      // SizedBox(width: 5.w,),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Widget headerViewContent(BuildContext context) {
    return Container(
        width: 100.w,
        height: 50,
        decoration: BoxDecoration(
            color: AppColors().whiteColor,
            border: Border(
              bottom: BorderSide(
                color: AppColors().lightOnlyText,
                width: 1,
              ),
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
            Text("Update Trade",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().blueColor,
                )),
            const Spacer(),
            GestureDetector(
              onTap: () {
                controller.openPopUpCount--;
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
