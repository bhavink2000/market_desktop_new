import '../../../../BaseController/baseController.dart';

class FontChangeController extends BaseController {
  //*********************************************************************** */
  // Variable Declaration
  //*********************************************************************** */

  var arrSize = [
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
  ];
  List<Map<String, dynamic>> arrFont = [
    {
      "name": "Arial",
      "family": [
        "Bold",
        "Bold Italiq",
        "Obliq",
        "Italiq",
        "Narrow",
        "Narrow Bold",
        "Narrow Bold Italiq",
        "Narrow Italiq",
        "Regular",
        "Black"
      ]
    },
    {
      "name": "Gilroy",
      "family": ["Bold", "Medium", "Regular"]
    },
    {
      "name": "Inter",
      "family": ["Bold", "Medium", "Regular"]
    },
    {
      "name": "Lato",
      "family": ["Bold", "Medium", "Regular"]
    },
    {
      "name": "Manrope",
      "family": ["Bold", "Medium", "Regular"]
    },
    {
      "name": "Montserrat",
      "family": ["Bold", "Medium", "Regular"]
    },
    {
      "name": "NunitoSans",
      "family": ["Bold", "Medium", "Regular"]
    },
    {
      "name": "OpenSans",
      "family": ["Bold", "Medium", "Regular"]
    },
    {
      "name": "Poppins",
      "family": ["Bold", "Medium", "Regular"]
    },
    {
      "name": "Raleway",
      "family": ["Bold", "Medium", "Regular"]
    },
    {
      "name": "Roboto",
      "family": ["Bold", "Medium", "Regular"]
    },
    {
      "name": "Cabin",
      "family": ["SemiBold"]
    },
    {
      "name": "NotoSans",
      "family": ["Medium"]
    },
  ];
  int selectedFamilyIndex = 0;
  int selectedStyleIndex = 0;
  int selectedSizeIndex = 0;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
  }

  String setArialStyles(int index) {
    var fontName = "";
    if (index == 0) {
      fontName = "ARIALBD";
    } else if (index == 1) {
      fontName = "ARIALBI";
    } else if (index == 2) {
      fontName = "ArialCEBoldItalic";
    } else if (index == 3) {
      fontName = "ARIALI";
    } else if (index == 4) {
      fontName = "ARIALN";
    } else if (index == 5) {
      fontName = "ARIALNB";
    } else if (index == 6) {
      fontName = "ARIALNBI";
    } else if (index == 7) {
      fontName = "ARIALNI";
    } else if (index == 8) {
      fontName = "ARIALR";
    } else if (index == 9) {
      fontName = "ARIBLK";
    }
    return fontName;
  }
}
