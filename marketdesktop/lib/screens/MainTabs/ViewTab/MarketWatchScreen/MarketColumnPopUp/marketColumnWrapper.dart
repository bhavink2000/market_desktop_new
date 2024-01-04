import 'package:get/get.dart';
import 'package:marketdesktop/customWidgets/appButton.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/MarketWatchScreen/marketWatchController.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';
import '../../../../../../constant/index.dart';

class marketColumnScreen extends BaseView<MarketColumnController> {
  const marketColumnScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    //print(MediaQuery.of(context).size.width);
    //print(MediaQuery.of(context).size.height);
    return Scaffold(
        backgroundColor: AppColors().slideGrayBG,
        body: SafeArea(
            child: Column(
          children: [
            headerViewContent(
                isFilterAvailable: false,
                isFromMarket: false,
                title: "Market",
                closeClick: () {
                  Get.back();
                  Get.delete<MarketColumnController>();
                }),
            Container(
              child: Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.w),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(1), border: Border.all(color: AppColors().lightText, width: 1)),
                  child: ReorderableListView(
                    buildDefaultDragHandles: false,
                    children: <Widget>[
                      for (int index = 0; index < controller.arrListTitle.length; index++)
                        ColoredBox(
                          key: Key('$index'),
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 30,
                                height: 30,
                                color: Colors.transparent,
                                child: ReorderableDragStartListener(
                                    index: index,
                                    child: Icon(
                                      Icons.menu,
                                      color: AppColors().darkText,
                                    )),
                              ),
                              columnContent(context, index)
                            ],
                          ),
                        ),
                    ],
                    onReorder: (int oldIndex, int newIndex) {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }

                      final ListItem item = controller.arrListTitle.removeAt(oldIndex);

                      controller.arrListTitle.insert(newIndex, item);
                      controller.update();
                    },
                  ),
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: AppColors().blueColor, width: 1)),
                    child: SizedBox(
                      width: 6.w,
                      height: 3.5.h,
                      child: CustomButton(
                        isEnabled: true,
                        shimmerColor: AppColors().whiteColor,
                        title: "Save",
                        textSize: 14,
                        onPress: () async {
                          // var marketVC = Get.find<MarketWatchController>();
                          // marketVC.arrListTitle.clear();
                          // marketVC.arrListTitle.addAll(controller.arrListTitle);
                          // marketVC.update();
                          Get.back();
                          await Get.delete<MarketColumnController>();
                        },
                        bgColor: AppColors().whiteColor,
                        isFilled: true,
                        textColor: AppColors().darkText,
                        isTextCenter: true,
                        isLoading: false,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 1.w,
                  ),
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: AppColors().lightText, width: 1)),
                    child: SizedBox(
                      width: 6.w,
                      height: 3.5.h,
                      child: CustomButton(
                        isEnabled: true,
                        shimmerColor: AppColors().whiteColor,
                        title: "Cancel",
                        textSize: 14,
                        onPress: () async {
                          Get.back();
                          await Get.delete<MarketColumnController>();
                        },
                        bgColor: Colors.transparent,
                        isFilled: true,
                        textColor: AppColors().darkText,
                        isTextCenter: true,
                        isLoading: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 1.5.h,
            )
          ],
        )));
  }

  Widget columnContent(BuildContext context, int index) {
    return GestureDetector(
      key: Key('$index'),
      onTap: () {
        controller.arrListTitle[index].isSelected = !controller.arrListTitle[index].isSelected;
        Get.find<MarketWatchController>().arrListTitle = controller.arrListTitle;
        Get.find<MarketWatchController>().update();
        controller.update();
      },
      child: Container(
        width: 15.5.w,
        color: Colors.transparent,
        // decoration: BoxDecoration(
        //     color: Colors.transparent,
        //     border: Border.all(width: 1, color: Colors.white)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Text(controller.arrListTitle[index].title, style: TextStyle(fontSize: 12, fontFamily: CustomFonts.family1SemiBold, color: AppColors().darkText)),
            ),
            Spacer(),
            controller.arrListTitle[index].isSelected
                ? Icon(
                    Icons.check_box,
                    color: AppColors().blueColor,
                    size: 18,
                  )
                : Icon(
                    Icons.check_box_outline_blank,
                    color: AppColors().lightText,
                    size: 18,
                  )
          ],
        ),
      ),
    );
  }
}
