import 'package:get/get.dart';
import 'package:marketdesktop/constant/utilities.dart';
import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/modelClass/myUserListModelClass.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../constant/index.dart';

class BillGenerateController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  RxString fromDate = "Start Date".obs;
  RxString endDate = "End Date".obs;
  bool isFilterOpen = false;
  bool isApiCall = false;
  Rx<UserData> selectedUser = UserData().obs;
  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();
  String pdfUrl = "";
  RxDouble fileDownloading = 0.0.obs;
  FocusNode submitFocus = FocusNode();
  FocusNode clearFocus = FocusNode();
  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
    if (userData!.role == UserRollList.user) {
      selectedUser.value = UserData(userId: userData!.userId);
    }
  }

  getBill() async {
    isApiCall = true;
    update();
    var response = await service.billGenerateCall(fromDate.value != "Start Date" ? fromDate.value : "", "", endDate.value != "End Date" ? endDate.value : "", selectedUser.value.userId ?? "");
    if (response?.statusCode == 200) {
      pdfUrl = response!.data!.pdfUrl!;
      //print(response!.data);
      // await service.downloadFilefromUrl(response!.data!.pdfUrl!);
      selectedUser.value = UserData();
      fromDate.value = "";
      endDate.value = "";
      update();
      // showSuccessToast("File successfully saved on your download folder.");
    } else {
      showErrorToast(response!.message ?? "");
    }
    isApiCall = false;
    //print(response);

    update();
  }

  downloadFile() async {
    await service.downloadFilefromUrl(pdfUrl, progress: (value) {
      fileDownloading.value = value;
      print(value);
    });
    Future.delayed(Duration(seconds: 1), () {
      fileDownloading.value = 00;
    });
    update();
    showSuccessToast("File successfully saved on your download folder.");
  }
}
