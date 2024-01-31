import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:marketdesktop/modelClass/profileInfoModelClass.dart';
import 'package:marketdesktop/service/network/apiService.dart';
import 'package:marketdesktop/service/network/socket_io_service.dart';
import 'package:marketdesktop/service/network/socket_service.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';
import 'constant/const_string.dart';
import 'modelClass/constantModelClass.dart';
import 'navigation/navigation.dart';
import 'navigation/routename.dart';

void main() async {
  await GetStorage.init();

  getMyIP().whenComplete(() async {
    myIpAddress = await getMyIP();
  });
  deviceInfoPlugin.deviceInfo.then((value) {
    deviceId = Platform.isWindows ? value.data["deviceId"].toString().replaceAll("{", "").replaceAll("}", "") : value.data["systemGUID"];
    deviceName = Platform.isWindows ? value.data["productName"] : value.data["model"];
  });
  await windowManager.ensureInitialized();
  Future.delayed(Duration(milliseconds: 100), () {
    windowManager.center(animate: false);
  });

  final localStorage = GetStorage();
  currentDarkModeOn = await localStorage.read(LocalStorageKeys.isDarkMode) ?? false;
  userId = await localStorage.read(LocalStorageKeys.userId);
  userToken = await localStorage.read(LocalStorageKeys.userToken);

  // if (userId != null) {
  //   userData = await ProfileInfoData.fromJson(localStorage.read(LocalStorageKeys.userData));
  //   AllApiCallService service = AllApiCallService();
  //   var response = await service.getConstantCall();
  //   if (response != null) {
  //     constantValues = response.data;
  //     arrStatuslist = constantValues?.status ?? [];
  //     arrFilterType = constantValues?.userFilterType ?? [];
  //     getExchangeList();
  //     getScriptList();
  //     getUserList();

  //     arrLeverageList = constantValues?.leverageList ?? [];
  //   }
  // }

  Timer.periodic(const Duration(seconds: 2), (timer) {
    internetConnectivity();
  });

  if (Platform.isWindows) {
    sqfliteFfiInit();

    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MyApp());
}

bool isProduction = false;
var userId;
var userToken;
bool isKeyBoardListenerActive = false;
bool isUserDetailPopUpOpen = false;
bool isUserViewPopUpOpen = false;
var serverName = "";
var deviceName = "";
var deviceId = "";
int pageLimit = 50;
RxBool isMarketSocketConnected = false.obs;
bool isShowToastAfterLogout = false;
final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
var myIpAddress = "0.0.0.0";
ProfileInfoData? userData;
final socket = SocketService();
final socketIO = SocketIOService();
ConstantData? constantValues;
// SignInData? userObj;
Size globalScreenSize = const Size(0, 0);
double globalMaxWidth = 0.0;
bool currentDarkModeOn = false;
bool isAccessTokenExpired = false;
bool isScoketDisconnted = false;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return GetMaterialApp(
        title: 'TESLA',
        initialRoute: RouterName.signInScreen,
        debugShowCheckedModeBanner: false,
        getPages: Pages.pages(),
      );
    });
  }
}

internetConnectivity() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      if (Get.isDialogOpen!) {
        Get.back();
        // Get.offAllNamed(userId == null
        //     ? RouterName.searchWithoutLoginScreen
        //     : RouterName.homeScreen);
      }
    }
  } on SocketException catch (_) {
    //print("There is no internet");
    if (Get.isDialogOpen == false) {
      Get.dialog(Material(
        color: Colors.transparent,
        child: WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            content: SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  "There is no internet connection".tr,
                  maxLines: 3,
                ),
              ),
            ),
          ),
        ),
      ));
      // showAlert("There is no internet connection");
    }
  }
}
