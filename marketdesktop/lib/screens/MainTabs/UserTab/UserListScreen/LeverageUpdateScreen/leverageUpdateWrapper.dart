import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:get/get.dart';

import 'package:marketdesktop/customWidgets/appButton.dart';

import '../../../../../constant/index.dart';
import '../../../../../modelClass/constantModelClass.dart';
import '../../../../BaseController/baseController.dart';
import 'leverageUpdateController.dart';

class LeverageUpdateScreen extends BaseView<LeverageUpdateController> {
  const LeverageUpdateScreen({Key? key}) : super(key: key);

  @override
  Widget vBuilder(BuildContext context) {
    //print(MediaQuery.of(context).size.width);
    //print(MediaQuery.of(context).size.height);
    return Scaffold(
        backgroundColor: AppColors().slideGrayBG,
        body: SafeArea(
            child: Column(
          children: [
            headerViewContent(
              title: "Update Leverage [${controller.selectedUser.userName!}] ",
              isFilterAvailable: false,
              isFromMarket: false,
            ),
            SizedBox(
              height: 20,
            ),
            leverageDropDown(controller.selectedLeverage),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 120,
              height: 40,
              child: CustomButton(
                isEnabled: true,
                shimmerColor: AppColors().whiteColor,
                title: "Save",
                textSize: 14,
                onPress: () {
                  controller.callForUpdateLeverage();
                },
                bgColor: AppColors().blueColor,
                isFilled: true,
                textColor: AppColors().whiteColor,
                isTextCenter: true,
                isLoading: controller.isApiCallRunning,
              ),
            ),
          ],
        )));
  }

  Widget leverageDropDown(Rx<AddMaster> selectedLeverage, {double? width, double? height, FocusNode? focus}) {
    return Obx(() {
      return Container(
          width: width ?? 250,
          height: height ?? 30,
          // padding: EdgeInsets.symmetric(horizontal: 15),
          // decoration: BoxDecoration(border: Border.all(color: focus!.hasFocus ? AppColors().blueColor : AppColors().lightOnlyText, width: 1), color: AppColors().whiteColor),
          child: DropdownButtonFormField2<AddMaster>(
            focusNode: focus,
            decoration: commonFocusBorder,
            key: controller.dropdownLeveargeKey,
            value: selectedLeverage.value.id != null ? selectedLeverage.value : null,
            style: TextStyle(color: AppColors().darkText),
            onChanged: (AddMaster? value) {
              // This is called when the user selects an item.
              selectedLeverage.value = value!;
              // focus.nextFocus();
            },
            isExpanded: true,
            items: arrLeverageList
                .map((AddMaster item) => DropdownItem<AddMaster>(
                      value: item,
                      height: 30,
                      child: Text(item.name ?? "", style: TextStyle(fontSize: 10, fontFamily: CustomFonts.family2Regular, color: AppColors().darkText, overflow: TextOverflow.ellipsis)),
                    ))
                .toList(),
          ));
    });
  }
}
