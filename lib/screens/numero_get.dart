import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:mapane/networking/services/user_service.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mapane/routes.dart';
import '../utils/theme_mapane.dart';
import '../utils/size_config.dart';
import 'dart:async';

void main() {
  runApp(new MaterialApp(
    theme: ThemeData(
        fontFamily: 'Robotto',
        accentColor: Colors.black,
        primaryColor: Colors.black),
    home: new NumeroGet(),
    debugShowCheckedModeBanner: false,
  ));
}

class NumeroGet extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<NumeroGet> {
  String _mobileNumber = '';
  String _mobileNumberPhone = '';
  String _mobileNumberPhoneWrite = '';
  bool _loading = false;
  var isSelected = [false, false, false, false, false];
  List<SimCard> _simCard = <SimCard>[];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'CM';
  PhoneNumber number = PhoneNumber(isoCode: 'CM');

  void takenumber(String value) {
    setState(() => _mobileNumberPhone = value);
  }

  @override
  void initState() {
    super.initState();
    MobileNumber.listenPhonePermission((isPermissionGranted) {
      if (isPermissionGranted) {
        initMobileNumberState();
      } else {}
    });

    initMobileNumberState();
  }

  Future<void> initMobileNumberState() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      return;
    }
    String mobileNumber = '';
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      mobileNumber = await MobileNumber.mobileNumber;
      _simCard = await MobileNumber.getSimCards;
    } on PlatformException catch (e) {
      debugPrint("Failed to get mobile number because of '${e.message}'");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _mobileNumber = mobileNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      decoration: new BoxDecoration(
          image: new DecorationImage(
        fit: BoxFit.cover,
        image: AssetImage("assets/images/Background.png"),
      )),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/Logo-long-edited.png',
                width: 302,
              ),
              SizedBox(
                height: 0.01529 * deviceSize.height,
              ),
              Text(
                "Sélectionner un numéro",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.black),
              ),
              SizedBox(
                height: 0.02177 * deviceSize.height,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Color(0x26000000), width: 1),
                    ),
                    child: Container(
                      width: getSize(303, "width", context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 12),
                        child: Center(
                          child: Column(
                            children: [
                              _mobileNumber == null
                                  ? Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: ListTile(
                                        title: Align(
                                          child: Text(
                                            'Veuillez entrer une SIM',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: _mobileNumber.length <= 3
                                          ? EdgeInsets.fromLTRB(getSize(2.5, "width", context), 0, getSize(20.5, "width", context), 0) : EdgeInsets.all(0),
                                      child: _mobileNumber.length <= 3
                                          ? fillInput()
                                          : fillCards()),
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
              SizedBox(
                height: 0.02177 * deviceSize.height,
              ),
              _mobileNumber != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 36),
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            _loading = true;
                          });

                          // CoolAlert.show(
                          //   context: context,
                          //   type: CoolAlertType.success,
                          //   text: "Bienvenue",
                          //   onConfirmBtnTap:() => Navigator.of(context).pushNamed(Routes.splash_welcome)
                          // );
                          // Timer(Duration(seconds: 5), () => Navigator.of(context).pushNamed(Routes.splash_welcome));
                          userService
                              .registerUser(
                                  _mobileNumberPhone, _mobileNumberPhoneWrite)
                              .then((value) {
                            setState(() {
                              _loading = false;
                            });
                            showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: MaterialLocalizations.of(context)
                                    .modalBarrierDismissLabel,
                                barrierColor:
                                    AppColors.whiteColor.withOpacity(0.96),
                                transitionDuration:
                                    const Duration(milliseconds: 200),
                                pageBuilder: (BuildContext buildContext,
                                    Animation animation,
                                    Animation secondaryAnimation) {
                                  return Center(
                                    child: Card(
                                      shadowColor: Colors.transparent,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width:
                                                getSize(303, "width", context),
                                            // height: getSize(256, "height", context),
                                            // padding: EdgeInsets.all(getSize(0,"height",context)),
                                            decoration: BoxDecoration(
                                              color: AppColors.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(getSize(
                                                      20, "height", context)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xFF000000)
                                                      .withOpacity(0.11),
                                                  spreadRadius: 5,
                                                  blurRadius: 10,
                                                  offset: Offset(0,
                                                      5), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: getSize(
                                                      33, "height", context),
                                                  horizontal: getSize(
                                                      28, "width", context)),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: getSize(
                                                        100, "height", context),
                                                    height: getSize(
                                                        100, "height", context),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: getSize(
                                                                36,
                                                                "height",
                                                                context),
                                                            horizontal: getSize(
                                                                30,
                                                                "width",
                                                                context)),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      color: AppColors
                                                          .greenColor
                                                          .withOpacity(0.35),
                                                    ),
                                                    child: Center(
                                                        child: Icon(
                                                      Icons.check,
                                                      size: getSize(38,
                                                          "height", context),
                                                      color:
                                                          AppColors.greenColor,
                                                    )),
                                                  ),
                                                  SizedBox(
                                                    height: getSize(
                                                        21, "height", context),
                                                  ),
                                                  Text(
                                                    "Sauvegardé",
                                                    style: AppTheme
                                                        .defaultParagraph,
                                                  ),
                                                  SizedBox(
                                                    height: getSize(
                                                        12, "height", context),
                                                  ),
                                                  Container(
                                                    width: getSize(
                                                        220, "width", context),
                                                    child: Text(
                                                      value,
                                                      style: AppTheme.bodyText1
                                                          .copyWith(
                                                        color: AppColors
                                                            .blackColor
                                                            .withOpacity(0.5),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });

                            Timer(
                                Duration(seconds: 2),
                                () => Navigator.of(context)
                                    .pushReplacementNamed('/splash-welcome'));
                          }).catchError((onError) {
                            setState(() {
                              _loading = false;
                            });
                            showGeneralDialog(
                                context: context,
                                barrierDismissible: true,
                                barrierLabel: MaterialLocalizations.of(context)
                                    .modalBarrierDismissLabel,
                                barrierColor:
                                    AppColors.whiteColor.withOpacity(0.96),
                                transitionDuration:
                                    const Duration(milliseconds: 200),
                                pageBuilder: (BuildContext buildContext,
                                    Animation animation,
                                    Animation secondaryAnimation) {
                                  return Center(
                                    child: Card(
                                      shadowColor: Colors.transparent,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width:
                                                getSize(303, "width", context),
                                            // height: getSize(256, "height", context),
                                            // padding: EdgeInsets.all(getSize(0,"height",context)),
                                            decoration: BoxDecoration(
                                              color: AppColors.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(getSize(
                                                      20, "height", context)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xFF000000)
                                                      .withOpacity(0.11),
                                                  spreadRadius: 5,
                                                  blurRadius: 10,
                                                  offset: Offset(0,
                                                      5), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: getSize(
                                                      33, "height", context),
                                                  horizontal: getSize(
                                                      28, "width", context)),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: getSize(
                                                        100, "height", context),
                                                    height: getSize(
                                                        100, "height", context),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: getSize(
                                                                36,
                                                                "height",
                                                                context),
                                                            horizontal: getSize(
                                                                30,
                                                                "width",
                                                                context)),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      color: Colors.red
                                                          .withOpacity(0.5),
                                                    ),
                                                    child: Center(
                                                        child: Icon(
                                                      Icons.close,
                                                      size: getSize(38,
                                                          "height", context),
                                                      color: Colors.white,
                                                    )),
                                                  ),
                                                  SizedBox(
                                                    height: getSize(
                                                        21, "height", context),
                                                  ),
                                                  Text(
                                                    "Erreur",
                                                    style: AppTheme
                                                        .defaultParagraph,
                                                  ),
                                                  SizedBox(
                                                    height: getSize(
                                                        12, "height", context),
                                                  ),
                                                  Container(
                                                    width: getSize(
                                                        220, "width", context),
                                                    child: Text(
                                                      onError.response ==
                                                                  null ||
                                                              onError.response ==
                                                                  ""
                                                          ? 'Une erreur est survenue, verifier votre connexion.'
                                                          : onError.response
                                                              .data["message"],
                                                      style: AppTheme.bodyText1
                                                          .copyWith(
                                                        color: AppColors
                                                            .blackColor
                                                            .withOpacity(0.5),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          });
                        },
                        textColor: Colors.white,
                        color: Colors.transparent,
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(100.0),
                        ),
                        child: Container(
                          width: getSize(303, "width", context),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color(0xFFA7BACB),
                                Color(0xFF25296A),
                              ],
                            ),
                          ),
                          padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _loading
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          right: 12, top: 6, bottom: 6),
                                      child: SizedBox(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                          strokeWidth: 1,
                                        ),
                                        height: 18.0,
                                        width: 18.0,
                                      ),
                                    )
                                  : Row(),
                              Text('Continuer', style: TextStyle(fontSize: 18)),
                            ],
                          )),
                        ),
                      ),
                    )
                  : Row()
            ],
          ),
          Positioned(
            bottom: 21,
            child: Column(
              children: [
                Text(
                  "Informations légales",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 0.02177 * deviceSize.height,
                ),
                Text(
                  "V1.0.0",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.black),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  Widget pageIndexIndicator() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.5),
      height: 13,
      width: 13,
      decoration: BoxDecoration(color: Color.fromRGBO(37, 41, 106, 1)),
    );
  }

  Widget fillCards() {
    var taille = _simCard.length;
    if (taille == 1) {
      setState(() {
        _mobileNumberPhone = _simCard.first.number;
      });
    }
    List<Widget> widgets = _simCard
        .map(
          (SimCard sim) => Column(
            children: [
              ListTile(
                  leading: Image.asset(
                    'assets/images/Flag-CM.png',
                    height: 25,
                  ),
                  onTap: () {
                    setState(() {
                      _mobileNumberPhone = sim.number;
                      isSelected = [false, false, false, false, false];
                      isSelected[_simCard.indexOf(sim)] = true;
                    });
                  },
                  title: Align(
                    child: Text(
                      sim.number == null ? "" : sim.number,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Colors.black,
                          letterSpacing: 2),
                    ),
                    alignment: Alignment(-0.3, 0),
                  ),
                  trailing:
                      taille == 1 || isSelected[_simCard.indexOf(sim)] == true
                          ? Icon(
                              Icons.check_circle,
                              size: 23.0,
                              color: Color(0xFF25296A),
                            )
                          : Text('')),
              _simCard.indexOf(sim) != taille - 1
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.5),
                      child: Divider(thickness: 2, color: Colors.grey[200]),
                    )
                  : Row(),
            ],
          ),
        )
        .toList();
    return Column(children: widgets);
  }

  Widget fillInput() {
    return Form(
      key: formKey,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50,
              child: InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  setState(() {
                    _mobileNumberPhoneWrite = number.phoneNumber;
                  });
                },
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
                textStyle: TextStyle(fontSize: 16),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: TextStyle(color: Colors.black),
                initialValue: number,
                textFieldController: controller,
                formatInput: false,
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputBorder: UnderlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NumberSim extends StatelessWidget {
  const NumberSim({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: ListTile(
            leading: Image.asset('assets/images/Flag-CM.png'),
            title: Align(
              child: Text(
                "_isoCountryCode",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.black),
              ),
              alignment: Alignment(-1.2, 0),
            ),
            trailing: Icon(
              Icons.check_circle,
              size: 23.0,
              color: Color(0xFF25296A),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.5),
          child: Divider(thickness: 2, color: Colors.grey[200]),
        ),
      ],
    );
  }
}
