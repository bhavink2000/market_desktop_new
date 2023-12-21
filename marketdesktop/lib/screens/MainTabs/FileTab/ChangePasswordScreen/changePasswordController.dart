import 'package:get/get.dart';
import 'package:marketdesktop/constant/utilities.dart';
import '../../../../constant/index.dart';

class ChangePasswordBinding implements Bindings {
  @override
  void dependencies() {
    // Get.put(() => SignInController());
    Get.put(ChangePasswordController());
  }
}

class ChangePasswordController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  TextEditingController confirmController = TextEditingController();
  FocusNode confirmFocus = FocusNode();
  TextEditingController currentPasswordController = TextEditingController();
  FocusNode currentPasswordFocus = FocusNode();
  TextEditingController passwordController = TextEditingController();
  FocusNode passwordFocus = FocusNode();
  RxBool isLoadingSignIn = false.obs;
  bool isApiCallRunning = false;
  String selectedUserID = "";

  bool isEyeOpen = true;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    update();
    Future.delayed(const Duration(milliseconds: 100), () {
      update();
    });
    confirmFocus.addListener(() {
      update();
    });
    currentPasswordFocus.addListener(() {
      update();
    });
    passwordFocus.addListener(() {
      update();
    });
  }

//*********************************************************************** */
  // Field Validation
  //*********************************************************************** */

  String validateField() {
    var msg = "";
    if (selectedUserID == "") {
      if (currentPasswordController.text.trim().isEmpty) {
        msg = AppString.emptyCurrentPassword;
      } else if (passwordController.text.trim().isEmpty) {
        msg = AppString.emptyPassword;
      } else if (confirmController.text.trim().isEmpty) {
        msg = AppString.emptyConfirmPassword;
      } else if (passwordController.text.trim() != confirmController.text.trim()) {
        msg = AppString.passwordNotMatch;
      }
    } else {
      if (passwordController.text.trim().isEmpty) {
        msg = AppString.emptyPassword;
      } else if (confirmController.text.trim().isEmpty) {
        msg = AppString.emptyConfirmPassword;
      } else if (passwordController.text.trim() != confirmController.text.trim()) {
        msg = AppString.passwordNotMatch;
      }
    }

    return msg;
  }
//*********************************************************************** */
  // Api Calls
  //*********************************************************************** */

  callForChangePassword() async {
    var msg = validateField();
    if (msg.isEmpty) {
      currentPasswordFocus.unfocus();
      passwordFocus.unfocus();
      confirmFocus.unfocus();
      isApiCallRunning = true;
      update();

      var response = await service.changePasswordCall(currentPasswordController.text.trim(), passwordController.text.trim(),
          userId: selectedUserID);
      if (response != null) {
        isApiCallRunning = false;
        if (response.statusCode == 200) {
          Get.back();
          currentPasswordController.clear();
          passwordController.clear();
          confirmController.clear();
          showSuccessToast(response.meta?.message ?? "");
          update();
        } else {
          showErrorToast(response.message ?? "");
          update();
        }
      } else {
        showErrorToast(AppString.generalError);
        update();
      }
    } else {
      showWarningToast(msg);
    }
  }
}
