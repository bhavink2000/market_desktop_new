import 'package:marketdesktop/modelClass/notificationListModelClass.dart';

import '../../../../constant/index.dart';
import '../ViewTab/MarketWatchScreen/MarketColumnPopUp/marketColumnController.dart';

class MessagesController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  bool isApiCallRunning = false;
  bool isPagingApiCall = false;
  int totalPage = 0;
  int currentPage = 1;
  ScrollController mainScroll = ScrollController();
  List<NotificationData> arrNotification = [];
  List<ListItem> arrListTitle = [
    ListItem("INDEX", true),
    ListItem("MESSAGE", true),
    ListItem("RECEIVED ON", true),
  ];
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    isApiCallRunning = true;
    notificationList();
  }

  refreshView() {
    update();
  }

  notificationList() async {
    if (isPagingApiCall) {
      return;
    }
    isPagingApiCall = true;
    update();
    var response = await service.notificaitonListCall(currentPage);
    arrNotification.addAll(response!.data!);
    isApiCallRunning = false;
    isPagingApiCall = false;
    totalPage = response.meta!.totalPage!;
    if (totalPage >= currentPage) {
      currentPage = currentPage + 1;
    }
    update();
  }
}
