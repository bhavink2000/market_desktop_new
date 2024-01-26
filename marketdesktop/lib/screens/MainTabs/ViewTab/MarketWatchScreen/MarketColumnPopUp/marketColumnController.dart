import 'package:get/get.dart';
import 'package:marketdesktop/screens/MainTabs/ViewTab/MarketWatchScreen/marketWatchController.dart';
import '../../../../../../constant/index.dart';

class MarketColumnBinding implements Bindings {
  @override
  void dependencies() {
    // Get.put(() => SignInController());
    Get.put(MarketColumnController());
  }
}

class MarketColumnController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  List<ListItem> arrListTitle = [];

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    var marketVC = Get.find<MarketWatchController>();
    arrListTitle.addAll(marketVC.arrListTitle);
    update();
  }

  //*********************************************************************** */
  // Field Validation
  //*********************************************************************** */

  //*********************************************************************** */
  // Api Calls
  //*********************************************************************** */
}

// class ListItem {
//   String title;
//   bool isSelected;
//   bool isSortingActive = false;
//   int sortType = 0;
//   double smallOriginal = 60;
//   double normalOriginal = 110;
//   double bigOriginal = 150;
//   double largeOriginal = 260;
//   double extraLargeOriginal = 500;
//   double small = 60;
//   double normal = 110;
//   double big = 150;
//   double large = 260;
//   double extraLarge = 500;
//   double smallUpdated = 60;
//   double normalUpdated = 110;
//   double bigUpdated = 150;
//   double largeUpdated = 260;
//   double extraLargeUpdated = 500;
//   Offset? start;

//   ListItem(this.title, this.isSelected);
// }
class ListItem {
  String title;
  bool isSelected;
  bool isSortingActive = false;
  int sortType = 0;
  double smallOriginal = 60;
  double normalOriginal = 102;
  double bigOriginal = 120;
  double smallLargeOriginal = 155;
  double largeOriginal = 210;
  double extraLargeOriginal = 500;
  double forDateOriginal = 180;
  double small = 60;
  double normal = 102;
  double big = 120;
  double large = 210;
  double smallLarge = 155;
  double extraLarge = 500;
  double forDate = 180;
  double smallUpdated = 60;
  double normalUpdated = 102;
  double bigUpdated = 120;
  double smallLargeUpdated = 155;
  double largeUpdated = 210;
  double extraLargeUpdated = 500;
  double forDateUpdated = 180;
  Offset? start;

  ListItem(this.title, this.isSelected);
}
