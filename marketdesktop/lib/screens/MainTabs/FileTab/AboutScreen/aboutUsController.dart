import 'package:marketdesktop/main.dart';
import 'package:marketdesktop/screens/BaseController/baseController.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutUsPopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  String system = "";
  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initPackageInfo();
    deviceInfoPlugin.deviceInfo.then((value) {
      system = value.data["model"] + ", " + value.data["osRelease"];

      update();
    });
  }

  Future<void> initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    packageInfo = info;
  }
}
