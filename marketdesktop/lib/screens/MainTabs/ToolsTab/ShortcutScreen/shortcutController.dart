import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../BaseController/baseController.dart';

class ShortcutControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShortcutController());
  }
}

class ShortcutController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  Size? screenSize;
  ScrollController sheetController = ScrollController();

  @override
  void onInit() async {
    super.onInit();
    screenSize = WidgetsBinding.instance.platformDispatcher.displays.first.size;

    update();
  }
}
