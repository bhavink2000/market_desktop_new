import 'package:marketdesktop/screens/BaseController/baseController.dart';
import 'package:marketdesktop/screens/MainTabs/FileTab/AboutScreen/aboutUsController.dart';

import '../../../../constant/index.dart';

class AboutUsPopUpScreen extends BaseView<AboutUsPopUpController> {
  const AboutUsPopUpScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerViewContent(title: "About", isFilterAvailable: false, isFromMarket: false),
          versionView(),
          componentView(),
        ],
      ),
    );
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
              SizedBox(
                height: 10,
              ),
              Center(
                child: Image.asset(
                  AppImages.appLogo,
                  width: 300,
                  height: 100,
                ),
              ),
              // Center(
              //   child: Text("TESLA", style: TextStyle(fontSize: 40, fontFamily: CustomFonts.family1ExtraBold, color: AppColors().blueColor)),
              // ),
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
                      child: Text("TESLA",
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
                      child: Text(controller.packageInfo.version + " (${controller.packageInfo.buildNumber})",
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
