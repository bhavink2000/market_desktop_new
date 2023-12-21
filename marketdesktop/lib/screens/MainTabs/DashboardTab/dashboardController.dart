import 'package:get/get.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../constant/index.dart';

class DashboardController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  Rx<UserData> selectedUserChart = UserData().obs;
  Rx<UserData> selectedUserPie = UserData().obs;
  RxString selectedCount = "".obs;
  RxString selectedPeriod = "".obs;
  RxString selectedSortType = "".obs;
  bool isChartViewSelected = true;
  bool isPieViewSelected = true;
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;
  late List<ChartData> data;
  late TooltipBehavior tooltip;
  late TooltipBehavior tooltipBar;
  final List<PieChartData> chartData = [
    PieChartData('David', 25, Colors.red),
    PieChartData('Steve', 38, Colors.blue),
    PieChartData('Jack', 34, Colors.green),
    PieChartData('Others', 52, Colors.yellow)
  ];

  @override
  void onInit() async {
    // TODO: implement onInit
    data = [
      ChartData("Jan", 235, 240, 235),
      ChartData("Feb", 242, 250, 260),
      ChartData("Mar", 320, 280, 220),
      ChartData("Apr", 360, 355, 410),
      ChartData("May", 270, 245, 310)
    ];

    super.onInit();
    tooltip = TooltipBehavior(enable: true);
    tooltipBar = TooltipBehavior(enable: true);
  }
}

class ChartData {
  ChartData(this.x, this.y, this.y1, this.y2);
  final String x;
  final double y;
  final double y1;
  final double y2;
}

class PieChartData {
  PieChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
