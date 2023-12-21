import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:marketdesktop/navigation/routename.dart';
import 'package:marketdesktop/screens/MainContainerScreen/mainContainerController.dart';

import 'package:marketdesktop/screens/MainContainerScreen/mainContainerWrapper.dart';

import '../screens/Authentication/SignInScreen/signInController.dart';
import '../screens/Authentication/SignInScreen/signInWrapper.dart';

class Pages {
  static List<GetPage> pages() {
    return [
      GetPage(name: RouterName.signInScreen, page: () => SignInScreen(), binding: SignInControllerBinding()),
      GetPage(name: RouterName.dashbaordScreen, page: () => MainContainerScreen(), binding: MainContainerControllerBinding()),
    ];
  }
}
