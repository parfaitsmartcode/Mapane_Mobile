import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapane/constants/assets.dart';
import 'package:mapane/custom/widgets/newWidgets/custom_dropdown_widget.dart';
import '../utils/size_config.dart';
import '../custom/widgets/newWidgets/topCustomBar.dart';
import '../custom/widgets/newWidgets/customtextform.dart';
import '../custom/widgets/newWidgets/buttonCustom.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../custom/widgets/newWidgets/rps_custom_painter.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../utils/theme_mapane.dart';
import '../state/user_provider.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:mapane/networking/services/user_service.dart';
import 'package:mapane/state/bottom_bar_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:mapane/screens/settings.dart';
import 'package:mapane/state/LoadingState.dart';
import 'dart:io' show File, Platform;
import 'package:mapane/localization/language/languages.dart';
import 'package:mapane/localization/locale_constant.dart';
import 'package:flutter_switch/flutter_switch.dart';

class ProfileEditEntreprise extends StatefulWidget {
  const ProfileEditEntreprise({Key key}) : super(key: key);

  @override
  _ProfileEditEntrepriseState createState() => _ProfileEditEntrepriseState();
}

class _ProfileEditEntrepriseState extends State<ProfileEditEntreprise> {
  bool test_switch = true;
  File _image;
  var _imageb64;
  String img64;
  String imgName;
  String typeUser;

  List<File> _imagesList = [];
  List<String> typeEntreprise = [
    'Hôtel',
    'Hôtel',
    'Hôtel',
    'Hôtel',
    'Hôtel',
    'Hôtel',
    'Hôtel',
    'Hôtel',
    'Hôtel',
  ];
  List<String> _imageb64List;

  final picker = ImagePicker();

  Future<List<String>> getTypeEntreprises(String entreprise) async {
    return await Future.delayed(Duration(milliseconds: 100), () {
      return typeEntreprise;
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    final bytes = await pickedFile.readAsBytes();

    setState(() {
      if (pickedFile != null) {
        _imageb64 = File(pickedFile.path).readAsBytesSync();
        var imagetaille = File(pickedFile.path).lengthSync();
        final kb = imagetaille / 1024;
        final mb = kb / 1024;
        print("taille de l'image");
        print(mb);
        if (mb > 1) {
          // showPopupErrorSuccess(context, "error",
          //     "Veuillez sélectionner une image de moins de 1Mb");
        } else {
          imgName = File(pickedFile.path).uri.toString().split(
              "/")[File(pickedFile.path).uri.toString().split("/").length - 1];
          _image = File(pickedFile.path);

          _imagesList.add(_image);

          img64 = base64Encode(_imageb64);
        }
      } else {
        // print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFA7BACB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              // width: getSize(375, "width", context),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    AppColors.whiteGradientColor1,
                    Color(0x5DA7BACB),
                    Color(0x5DA7BACB),
                    AppColors.whiteGradientColor1
                  ],
                      stops: [
                    0.1,
                    0.3,
                    0.75,
                    1
                  ])),
              // padding: EdgeInsets.symmetric(
              //     vertical: getSize(0, "height", context),
              //     horizontal: getSize(22.5, "width", context)),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            bottom: getSize(15, "width", context)),
                        padding: EdgeInsets.symmetric(
                            vertical: getSize(0, "height", context),
                            horizontal: getSize(22.5, "width", context)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            topCustomBar(
                                type: "black", text: "Modifier entreprise"),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: getSize(15, "height", context)),
                              child: Text("Information sur votre entreprise",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                          fontSize:
                                              getSize(16, "height", context),
                                          fontWeight: FontWeight.normal,
                                          color:
                                              Colors.black.withOpacity(0.4))),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getSize(10, "height", context),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: getSize(0, "height", context),
                        horizontal: getSize(22.5, "width", context)),
                    child: Column(
                      children: [
                        Container(
                          height: getSize(50, "height", context),
                          child: CustomTextForm(),
                        ),
                        SizedBox(
                          height: getSize(25, "height", context),
                        ),
                        // Container(
                        //   child: SizedBox(
                        //     // width: getSize(120, "width", context),
                        //     height: getSize(50, "height", context),
                        //     child: CustomDropdown<String>(
                        //       child: Text(
                        //         'Hôtels',
                        //         style: Theme.of(context)
                        //             .textTheme
                        //             .bodyText1
                        //             .copyWith(
                        //                 fontSize: getSize(16, "height", context),
                        //                 fontWeight: FontWeight.normal,
                        //                 color: Colors.black.withOpacity(1)),
                        //       ),
                        //       onChange: (String value, int index) {
                        //         print("value de select");
                        //         print(value);
                        //         setState(() {
                        //           // monnaie = value;
                        //         });
                        //       },
                        //       dropdownButtonStyle: DropdownButtonStyle(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         elevation: 0,
                        //         shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(20)),
                        //         backgroundColor: Colors.white,
                        //         primaryColor: Colors.grey.withOpacity(0.5),
                        //       ),
                        //       dropdownStyle: DropdownStyle(
                        //           borderRadius: BorderRadius.circular(4),
                        //           elevation: 3,
                        //           color: Colors.white),
                        //       items: [
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //         'Hôtel',
                        //       ]
                        //           .asMap()
                        //           .entries
                        //           .map(
                        //             (item) => DropdownItem<String>(
                        //               value: item.value,
                        //               child: Text(item.value,
                        //                   style: Theme.of(context)
                        //                       .textTheme
                        //                       .bodyText1
                        //                       .copyWith(
                        //                           fontSize: getSize(
                        //                               16, "height", context),
                        //                           fontWeight: FontWeight.normal,
                        //                           color: Colors.black
                        //                               .withOpacity(1))),
                        //             ),
                        //           )
                        //           .toList(),
                        //     ),
                        //   ),
                        // ),
                        Container(
                          height: getSize(50, "height", context),
                          child: TypeAheadField(
                            suggestionsBoxDecoration: SuggestionsBoxDecoration(
                              color: Colors.white,
                            ),
                            textFieldConfiguration: TextFieldConfiguration(
                                autofocus: true,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        fontSize:
                                            getSize(16, "height", context),
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black.withOpacity(0.4)),
                                decoration: InputDecoration(
                                  hintText: "Startup",
                                  prefixIcon: SizedBox(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              getSize(16, "height", context),
                                          horizontal:
                                              getSize(13, "width", context)),
                                      child: Image.asset(
                                        'assets/images/iconpoints.png',
                                        height: getSize(20, "width", context),
                                        width: getSize(20, "width", context),
                                      ),
                                    ),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintStyle: TextStyle(
                                    fontSize: getSize(18, "height", context),
                                    height: 2.9,
                                    //fontFamily: 'Robotto',
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        getSize(25, "height", context)),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        getSize(25, "height", context)),
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
                                  ),
                                )),
                            suggestionsCallback: getTypeEntreprises,
                            itemBuilder: (context, suggestion) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: getSize(5, "height", context),
                                    horizontal:
                                        getSize(22.5, "width", context)),
                                child: Text(suggestion,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            fontSize:
                                                getSize(16, "height", context),
                                            fontWeight: FontWeight.normal,
                                            color:
                                                Colors.black.withOpacity(1))),
                              );
                            },
                            onSuggestionSelected: (suggestion) {},
                          ),
                        ),
                        SizedBox(
                          height: getSize(25, "height", context),
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                if (_imagesList != null)
                                  for (var i = 0;
                                      i < this._imagesList.length;
                                      i++)
                                    GestureDetector(
                                      onLongPress: () {
                                        showGeneralDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            barrierLabel:
                                                MaterialLocalizations.of(
                                                        context)
                                                    .modalBarrierDismissLabel,
                                            barrierColor: AppColors.whiteColor
                                                .withOpacity(0.96),
                                            transitionDuration: const Duration(
                                                milliseconds: 200),
                                            pageBuilder: (BuildContext
                                                    buildContext,
                                                Animation animation,
                                                Animation secondaryAnimation) {
                                              return Center(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: getSize(303,
                                                          "width", context),
                                                      // height: getSize(256, "height", context),
                                                      // padding: EdgeInsets.all(getSize(0,"height",context)),
                                                      decoration: BoxDecoration(
                                                        color: AppColors
                                                            .whiteColor,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                getSize(
                                                                    20,
                                                                    "height",
                                                                    context)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color(
                                                                    0xFF000000)
                                                                .withOpacity(
                                                                    0.11),
                                                            spreadRadius: 5,
                                                            blurRadius: 10,
                                                            offset: Offset(0,
                                                                5), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets
                                                                .all(getSize(
                                                                    20,
                                                                    "height",
                                                                    context)),
                                                            decoration:
                                                                BoxDecoration(
                                                                    // color: AppColors.whiteColor,
                                                                    ),
                                                            child: Material(
                                                              elevation: 0,
                                                              color:
                                                                  Colors.white,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    "Supprimer la photo ?",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize: getSize(
                                                                          18,
                                                                          "height",
                                                                          context),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: getSize(
                                                                        29,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Container(
                                                                          height: getSize(
                                                                              40,
                                                                              "height",
                                                                              context),
                                                                          width: getSize(
                                                                              162,
                                                                              "width",
                                                                              context),
                                                                          child:
                                                                              FlatButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                            textColor:
                                                                                Colors.white,
                                                                            color:
                                                                                Colors.transparent,
                                                                            padding:
                                                                                EdgeInsets.all(0),
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(100),
                                                                                gradient: LinearGradient(
                                                                                  colors: <Color>[
                                                                                    Color(0xFFA7BACB),
                                                                                    Color(0xFF25296A),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              padding: EdgeInsets.fromLTRB(0, getSize(5, "height", context), 0, getSize(5, "height", context)),
                                                                              child: Center(
                                                                                  child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  Text(
                                                                                    "Non",
                                                                                    style: TextStyle(
                                                                                      fontSize: getSize(18, "height", context),
                                                                                      fontWeight: FontWeight.w400,
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              )),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          child:
                                                                              Container(
                                                                            height: getSize(
                                                                                40,
                                                                                "height",
                                                                                context),
                                                                            width: getSize(
                                                                                91,
                                                                                "width",
                                                                                context),
                                                                            child:
                                                                                FlatButton(
                                                                              onPressed: () {
                                                                                setState(() {
                                                                                  _imagesList.remove(_imagesList[i]);
                                                                                });
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              color: Color(0x162C306F),
                                                                              padding: EdgeInsets.fromLTRB(0, getSize(5, "height", context), 0, getSize(5, "height", context)),
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(100),
                                                                              ),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  "Oui",
                                                                                  style: TextStyle(
                                                                                    fontSize: getSize(18, "height", context),
                                                                                    fontWeight: FontWeight.w400,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ])
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        margin: EdgeInsets.symmetric(
                                            vertical:
                                                getSize(0, "height", context),
                                            horizontal:
                                                getSize(8, "width", context)),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          child: Image.file(
                                            _imagesList[i],
                                            fit: BoxFit.cover,
                                            height:
                                                getSize(77, "height", context),
                                            width:
                                                getSize(77, "height", context),
                                          ),
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                            SizedBox(
                              width: getSize(8, "width", context),
                            ),
                            this._imagesList.length < 3
                                ? GestureDetector(
                                    onTap: () {
                                      getImage();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: getSize(77, "height", context),
                                      width: getSize(77, "height", context),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          color: Color(0xFF6386B8)
                                              .withOpacity(0.1),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Image.asset(
                                        'assets/images/iconpic.png',
                                        height:
                                            getSize(24.5, "height", context),
                                        width: getSize(24.5, "width", context),
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    width: 0,
                                  ),
                          ],
                        ),
                        SizedBox(
                          height: getSize(25, "height", context),
                        ),
                        Column(
                          children: [
                            ButtonCustom(
                              text: "Enregistrer",
                              colorText: Colors.white,
                              gradientType: 1,
                            ),
                            SizedBox(
                              height: getSize(15, "height", context),
                            ),
                            ButtonCustom(
                              text: "Supprimer l’entreprise",
                              colorText: Colors.white,
                              gradientType: 2,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
