// ignore_for_file: override_on_non_overriding_member

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_to_pdf/flutter_to_pdf.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import '../../../service/network/allApiCallService.dart';
import '../../constant/color.dart';
import '../../constant/dropdownFunctions.dart';
import '../../constant/font_family.dart';
import '../../modelClass/allSymbolListModelClass.dart';
import '../../modelClass/tableColumnsModelClass.dart';
import '../../service/database/dbService.dart';

class BaseController extends GetxController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  RxBool isLoading = false.obs;

  final localStorage = GetStorage();
  ScrollController headerSymbolListcontroller = ScrollController();
  RxBool isHedaderDropdownSelected = false.obs;
  RxBool isHedaderDropdownOpen = false.obs;
  AllApiCallService service = AllApiCallService();
  List<GlobalSymbolData> arrExchangeWiseScript = [];
  bool isFilterOpen = false;
  RxBool isScrollEnable = true.obs;
  bool isAllSelected = false;
  List<ColumnItem> arrListTitle1 = [];
  WidgetsToImageController widgetToImagecontroller = WidgetsToImageController();
  final ExportDelegate exportDelegate = ExportDelegate();
  Uint8List? bytes;
  onCLickFilter() {
    isFilterOpen = !isFilterOpen;
    update();
  }

  isAllSelectedUpdate(bool change) {}
  refreshView() {
    arrListTitle1.forEach((element) {
      element.position = arrListTitle1.indexOf(element);
    });
    DbService().addColumns(arrListTitle1);
    update();
  }

  bool isHiddenTitle(String title) {
    return false;
  }

  @override
  void onClose() {
    super.onClose();
    userEditingController.text = "";
    exchangeEditingController.text = "";
    scriptEditingController.text = "";
  }
}

abstract class BaseViewModel<T extends BaseController> extends StatelessWidget {
  const BaseViewModel({Key? key}) : super(key: key);

  final String? tag = null;

  T get controller => GetInstance().find<T>(tag: tag);

  @override
  Widget vBuilder(BuildContext context) {
    return Obx(() => vmBuilder());
  }

  Widget vmBuilder();
}

abstract class BaseView<T extends BaseController> extends StatelessWidget {
  const BaseView({Key? key}) : super(key: key);

  final String? tag = null;
  T get controller => GetInstance().find<T>(tag: tag);

  @override
  // Widget build(BuildContext context) {
  //   return BouncingScrollWrapper.builder(context, vBuilder(context), dragWithMouse: true);
  // }

  Widget build(BuildContext context) {
    return GetBuilder<T>(
      builder: (controller) {
        return vBuilder(context);
      },
    );
  }

  Widget headerDropDown() {
    GlobalKey globalKey = GlobalKey();
    return Obx(() {
      return AnimatedContainer(
        width: 100.w,
        height: controller.isHedaderDropdownSelected.value ? 25.h : 0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        key: globalKey,
        child: Offstage(
          offstage: !controller.isHedaderDropdownOpen.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 12.h,
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    clipBehavior: Clip.hardEdge,
                    itemCount: 3,
                    controller: controller.headerSymbolListcontroller,
                    scrollDirection: Axis.horizontal,
                    // shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(10),
                        width: 65.w,
                        decoration: BoxDecoration(
                          color: AppColors().footerColor,
                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: const Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 1.h,
                            ),
                            Text("Sensex", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                            Text("66498.84", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Regular, color: AppColors().greenColor)),
                            Text("-215.64(-0.33%)", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Regular, color: AppColors().redColor)),
                            SizedBox(
                              height: 1.h,
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              Container(margin: const EdgeInsets.only(left: 10), child: Text("Fund", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText))),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: 44.5.w,
                    decoration: BoxDecoration(
                      color: AppColors().footerColor,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 1.h,
                        ),
                        Text("Credit", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                        Text("29497.82", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Regular, color: AppColors().greenColor)),
                        SizedBox(
                          height: 1.h,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: 44.5.w,
                    decoration: BoxDecoration(
                      color: AppColors().footerColor,
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 1.h,
                        ),
                        Text("Credit", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Medium, color: AppColors().darkText)),
                        Text("29497.82", style: TextStyle(fontSize: 14, fontFamily: CustomFonts.family1Regular, color: AppColors().greenColor)),
                        SizedBox(
                          height: 1.h,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  Widget vBuilder(BuildContext context);
}
