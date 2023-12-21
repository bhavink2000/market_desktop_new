import 'package:marketdesktop/modelClass/profileInfoModelClass.dart';

import '../../../constant/index.dart';

class ShareDetailPopUpController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */
  TextEditingController plAdminController = TextEditingController();
  FocusNode plAdminFocus = FocusNode();
  TextEditingController plMasterController = TextEditingController();
  FocusNode plMasterFocus = FocusNode();
  TextEditingController brkAdminController = TextEditingController();
  FocusNode brkAdminFocus = FocusNode();
  TextEditingController brkMasterController = TextEditingController();
  FocusNode brkMasterFocus = FocusNode();
  String selectedUserId = "";

  ProfileInfoData? selectedUserData;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
  }

  getUSerInfo() async {
    var userResponse = await service.profileInfoByUserIdCall(selectedUserId);
    if (userResponse != null) {
      if (userResponse.statusCode == 200) {
        selectedUserData = userResponse.data;
        plAdminController.text = "${selectedUserData!.profitAndLossSharing!}%";
        plMasterController.text = "${selectedUserData!.profitAndLossSharingDownLine!}%";
        brkAdminController.text = "${selectedUserData!.brkSharing!}%";
        brkMasterController.text = "${selectedUserData!.brkSharingDownLine!}%";

        update();
      }
    }
  }
}
