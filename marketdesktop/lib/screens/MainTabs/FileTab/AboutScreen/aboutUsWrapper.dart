import 'dart:async';

import 'package:get/get.dart';
import 'package:marketdesktop/screens/BaseController/baseController.dart';
import 'package:marketdesktop/screens/MainTabs/FileTab/AboutScreen/aboutUsController.dart';

import '../../../../constant/index.dart';

class AboutUsPopUpScreen extends BaseView<AboutUsPopUpController> {
  const AboutUsPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Get.back();
          return Future.value(false);
        },
        child: Container(
          color: AppColors().lightOnlyText.withOpacity(0.3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerViewContent(context),
              versionView(),
              componentView(),
            ],
          ),
        ));
  }

  Widget headerViewContent(BuildContext context) {
    return Container(
        width: 100.w,
        height: 4.h,
        decoration: BoxDecoration(
            color: AppColors().whiteColor,
            border: Border(
              bottom: BorderSide(color: AppColors().lightOnlyText, width: 1),
            )),
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Image.asset(
              AppImages.appLogo,
              width: 3.h,
              height: 3.h,
            ),
            const SizedBox(
              width: 10,
            ),
            Text("About",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: CustomFonts.family1Medium,
                  color: AppColors().blueColor,
                )),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Get.back();
                Get.delete<AboutUsPopUpController>();
              },
              child: Container(
                width: 3.h,
                height: 3.h,
                padding: EdgeInsets.all(0.5.h),
                child: Image.asset(
                  AppImages.closeIcon,
                  color: AppColors().redColor,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ));
  }

  Widget versionView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Text("Operating System",
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: CustomFonts.family1ExtraBold,
                    color: AppColors().darkText,
                  )),
              Text(controller.system,
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: CustomFonts.family1SemiBold,
                    color: AppColors().darkText,
                  )),
            ],
          ),
          Spacer(),
          Column(
            children: [
              Center(
                child: Image.asset(
                  AppImages.appLogo,
                  width: 100,
                  height: 100,
                ),
              ),
              Center(
                child: Text("BAZAAR 2.0",
                    style: TextStyle(
                        fontSize: 40,
                        fontFamily: CustomFonts.family1ExtraBold,
                        color: AppColors().blueColor)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget componentView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Components",
              style: TextStyle(
                fontSize: 30,
                fontFamily: CustomFonts.family1ExtraBold,
                color: AppColors().darkText,
              )),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: 55,
            decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors().lightOnlyText,
                  width: 1,
                ),
                color: AppColors().whiteColor),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 25.w,
                      child: Text("Component",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: CustomFonts.family1SemiBold,
                            color: AppColors().darkText,
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: 1,
                      color: AppColors().lightOnlyText,
                      height: 20,
                    ),
                    SizedBox(
                      width: 10.w,
                      child: Text("Version",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: CustomFonts.family1SemiBold,
                            color: AppColors().darkText,
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: 1,
                      color: AppColors().lightOnlyText,
                      height: 20,
                    ),
                    SizedBox(
                      width: 10.w,
                      child: Text("Copyrights",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: CustomFonts.family1SemiBold,
                            color: AppColors().darkText,
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 25.w,
                      child: Text("BAZAAR",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: CustomFonts.family1SemiBold,
                            color: AppColors().darkText,
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: 1,
                      color: AppColors().lightOnlyText,
                      height: 20,
                    ),
                    SizedBox(
                      width: 10.w,
                      child: Text(
                          controller.packageInfo.version +
                              " (${controller.packageInfo.buildNumber})",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: CustomFonts.family1SemiBold,
                            color: AppColors().darkText,
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      width: 1,
                      color: AppColors().lightOnlyText,
                      height: 20,
                    ),
                    SizedBox(
                      child: Text("Copyright @ 2023",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: CustomFonts.family1SemiBold,
                            color: AppColors().darkText,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text("Copyright @ 2023, All rights reserved.",
              style: TextStyle(
                fontSize: 14,
                fontFamily: CustomFonts.family1SemiBold,
                color: AppColors().blueColor,
              )),
        ],
      ),
    );
  }
}
