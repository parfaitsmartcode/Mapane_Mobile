import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geodesy/geodesy.dart' as gdsy;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mapane/constants/assets.dart';
import 'package:mapane/custom/widgets/notif.dart';
import 'package:mapane/custom/widgets/notification_widget.dart';
import 'package:mapane/custom/widgets/util_button.dart';
import 'package:mapane/models/alert.dart';
import 'package:mapane/state/LoadingState.dart';
import 'package:mapane/state/alert_provider.dart';
import 'package:mapane/state/bottom_bar_provider.dart';
import 'package:mapane/state/place_provider.dart';
import 'package:mapane/state/search_provider.dart';
import 'package:mapane/state/user_provider.dart';
import 'package:mapane/utils/PermissionHelper.dart';
import 'package:mapane/utils/hexcolor.dart';
import 'package:mapane/utils/mapane_zone_util.dart';
import 'package:mapane/utils/n_exception.dart';
import 'package:mapane/utils/size_config.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../utils/theme_mapane.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:audioplayer/audioplayer.dart';

const String URI = "http://mapane.smartcodegroup.com/";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

enum TtsState { playing, stopped, paused, continued }
const double CAMERA_ZOOME = 16;
double zooming = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(4.0747638, 9.7497398);
const LatLng DEST_LOCATION = LatLng(4.0771125, 9.7486008);

class _HomePageState extends State<HomePage> {
  bool isExpanded = false;
  double alertHeight = 30.0;
  double bottomPadding;
  String addresse = "";
  bool soundchange = true;
  AudioPlayer audioPlugin = AudioPlayer();
  String mp3Uri;
  String customAddress;
  String procto;
  final _startPointController = TextEditingController();
  Widget swiperIcon = Container(
    child: SvgPicture.asset(
      Assets.arrowUpIcon,
    ),
    height: 32.0,
    width: 32.0,
  );
  CameraPosition cameraCurrentPosition =
      new CameraPosition(target: LatLng(15, 15));
  List<String> toPrint = ["trying to connect"];
  SocketIOManager manager;
  gdsy.Geodesy geodesy = new gdsy.Geodesy();
  Map<String, SocketIO> sockets = {};
  Map<String, bool> _isProbablyConnected = {};
  Alert notifications = new Alert();
  Set<Marker> _markers = Set<Marker>();
// for my drawn routes on the map
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  String googleAPIKey = "AIzaSyA1vPvfFjBhjgx0rOJcP8_K9vv5Xa2y1ZU";
// for my custom marker pins
  BitmapDescriptor sourceIcon;

  BitmapDescriptor embouteillageMarker;
  BitmapDescriptor radarMarker;
  BitmapDescriptor accidentMarker;
  BitmapDescriptor controleMarker;
  BitmapDescriptor routebarreeMarker;
  BitmapDescriptor routechantierMarker;
  BitmapDescriptor dangerMarker;
  BitmapDescriptor proximityMarker;
  BitmapDescriptor destinationIcon;
// the user's initial location and current location
// as it moves
  LocationData currentLocation;
// a reference to the destination location
  LocationData destinationLocation;
// wrapper around the location API
  Location location;
  String userId;
  bool loadera = false;
  FlutterTts flutterTts;
  dynamic languages;
  String language;
  double volume = 0.8;
  double pitch = 1.2;
  double rate = 1;
  bool isCurrentLanguageInstalled = false;
  List<Alert> mapanes = List<Alert>();
  gdsy.LatLng locationTmp;
  TtsState ttsState = TtsState.stopped;
  Set<Circle> _circles = HashSet<Circle>();
  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWeb => kIsWeb;
  bool test = true;
  Timer _timer;
  Timer _circleTimer;

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _kPosition = CameraPosition(
      bearing: CAMERA_BEARING,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: CAMERA_TILT,
      zoom: zooming);

  Future<void> _goToMyPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kPosition));
  }

  Future<void> _goTo(CameraPosition position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  activateNotif(Alert alert) {
    setState(() {
      notifications = alert;
    });
  }
  vocallyNotifyMapane(){
    mapanes.forEach((element) async {
      num distance = geodesy.distanceBetweenTwoGeoPoints(
          gdsy.LatLng(
              currentLocation.latitude, currentLocation.longitude),
          gdsy.LatLng(
              double.parse(element.lat), double.parse(element.lon)));
      print(distance);
      if(distance.round() >= 0 && distance <= 50){
        var text = element.category.name +
            " à moins de 50 mètres de votre position";
        if (context.read<UserProvider>().audioVal) {
          await _speak(text);
        }
      } else if(distance.round() > 50 && distance <= 100){
        var text = element.category.name +
            " à moins de 100 mètres de votre position";
        if (context.read<UserProvider>().audioVal) {
          await _speak(text);
        }
      } else if(distance.round() > 100 && distance <= 150){
        var text = element.category.name +
            " à moins de 150 mètres de votre position";
        if (context.read<UserProvider>().audioVal) {
          await _speak(text);
        }
      } else if(distance.round() > 150 && distance <= 200){
        var text = element.category.name +
            " à moins de 200 mètres de votre position";
        if (context.read<UserProvider>();.audioVal) {
          await _speak(text);
        }
      }else{
        var text = element.category.name +
            " à moins de " + distance.round().toString() +" mètres de votre position";
        if (context.read<UserProvider>().audioVal) {
          await _speak(text);
        }
      }
    });
  }

  @override
  initState() {
    if (!Platform.isIOS) {
      PermissionHelper.checkPermission(Permission.location);
    }
    super.initState();
    context.read<AlertProvider>().getAlertList(false, addresse);
    context.read<UserProvider>().getPopupVal();
    context.read<UserProvider>().getAudioVal();
    context
        .read<UserProvider>()
        .getPositionVal()
        .then((value) => procto = value);
    //context.read<NetworkProvider>().init();
    initTts();
    manager = SocketIOManager();
    initSocket("default");
    // create an instance of Location
    location = new Location();
    context.read<UserProvider>().getUserId().then((value) => userId = value);
    polylinePoints = PolylinePoints();

    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
    location.onLocationChanged.listen((LocationData cLoc) {
      // if (currentLocation != null) test = false;
      currentLocation = cLoc;
      // if (!test) {
      context.read<PlaceProvider>().getPlace(
          LatLng(currentLocation.latitude, currentLocation.longitude));
      print("le cas false");
      // }
      if (procto != null) {
        CameraPosition cPositionGo = CameraPosition(
          zoom: zooming,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING,
          target: LatLng(double.parse(procto.split(",")[0]),
              double.parse(procto.split(",")[1])),
        );
        _goTo(cPositionGo);
        context.read<UserProvider>().updatePosition(null);
        procto = null;
        test = false;
      } else {
        if (test) {
          print("ici première fois");
          // context.read<PlaceProvider>().getPlace(
          //     LatLng(currentLocation.latitude, currentLocation.longitude));
          CameraPosition cPosition = CameraPosition(
            zoom: zooming,
            tilt: CAMERA_TILT,
            bearing: CAMERA_BEARING,
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
          );
          _goTo(cPosition);
          test = false;
          locationTmp =
              gdsy.LatLng(currentLocation.latitude, currentLocation.longitude);
        }
      }
      updatePinOnMap();
      num distance = geodesy.distanceBetweenTwoGeoPoints(
          gdsy.LatLng(currentLocation.latitude, currentLocation.longitude),
          locationTmp);
      print("la distance est de " + distance.toString());
      if (distance >= 50) {
        locationTmp =
            gdsy.LatLng(currentLocation.latitude, currentLocation.longitude);
        CameraPosition cPosition = CameraPosition(
          zoom: zooming,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING,
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
        );
        _goTo(cPosition);
      }
      setState(() {
        mapanes = nearbyPoints(context.read<AlertProvider>().countryAlerts,
            LatLng(currentLocation.latitude, currentLocation.longitude));
      });
      if (mapanes.isNotEmpty) {
        const duration = const Duration(seconds: 60);
        if (_timer == null) {
          vocallyNotifyMapane();
          _timer = new Timer.periodic(duration, (Timer timer) {
           vocallyNotifyMapane();
          });
        } else {
          if (!_timer.isActive) {
            _timer = new Timer.periodic(duration, (Timer timer) {
              vocallyNotifyMapane();
            });
          }
        }
      } else {
        if (_timer.isActive && _timer != null) _timer.cancel();
      }
      print(mapanes);
    });
    // set custom marker pins
    setSourceAndDestinationIcons();
    // set the initial location
    if (!Platform.isIOS) {
      setInitialLocation();
    }
  }

  // void _playSound() {
  //   audioPlugin.play("http://mapane.smartcodegroup.com/alert_notif.mp3");
  // }

  initSocket(String identifier) async {
    setState(() => _isProbablyConnected[identifier] = true);
    SocketIO socket = await manager.createInstance(SocketOptions(
        //Socket IO server URI
        URI,
        nameSpace: (identifier == "namespaced") ? "/adhara" : "/",
        //Query params - can be used for authentication
        query: {
          "auth": "--SOME AUTH STRING---",
          "info": "new connection from adhara-socketio",
          "timestamp": DateTime.now().toString()
        },
        //Enable or disable platform channel logging
        enableLogging: false,
        transports: [Transports.POLLING] //Enable required transport
        ));
    socket.onConnect((data) {
      print("connected...");
      print(data);
    });
    socket.onConnectError(manageLoader());
    socket.onConnectTimeout(manageLoader());
    socket.onError(manageLoader());
    socket.onDisconnect(manageLoader());

    socket.on("createAlertNo", (data) => print(data));
    socket.on("createAlertOk", (data) {
      // var readText = '';
      // if (data['alert']['category']['name'] == "Embouteillage" || data['alert']['category']['name'] == "Accident de circulation") {
      //   readText = 'Possible alerte d\'' + data['alert']['category']['name'] + ' signalée à ' + data['alert']['address'].split(',')[0];
      // } else {
      //   readText = 'Possible alerte de ' + data['alert']['category']['name'] + ' signalée à ' + data['alert']['address'].split(',')[0];
      // }
      // if (context.read<UserProvider>().audioVal) {
      //   _speak(readText);
      // }
      if (context.read<UserProvider>().popupVal) {
        if (addresse.split(",")[2] == data['alert']['address'].split(",")[2]) {
          audioPlugin.play("http://mapane.smartcodegroup.com/alert_notif.mp3");
          context
              .read<AlertProvider>()
              .pushNotification(Alert.fromJson(data['alert']));
        }
      }
      context.read<AlertProvider>().getAlertList(false, addresse);
    });
    socket.on("createAlertOkUser", (data) {
      Navigator.pop(context);
      setState(() => loadera = false);
      context.read<AlertProvider>().getAlertList(false, addresse);
      //sample event
      print("createAlertOkUser");
      print(data);
      if (data.containsKey('message')) {
        if (data['id'] == userId){
          if (data['message'] == "alerte inactive") {
            showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel:
                    MaterialLocalizations.of(context).modalBarrierDismissLabel,
                barrierColor: AppColors.whiteColor.withOpacity(0.96),
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (BuildContext buildContext, Animation animation,
                    Animation secondaryAnimation) {
                  return Center(
                    child: Card(
                      shadowColor: Colors.transparent,
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: getSize(303, "width", context),
                            // height: getSize(256, "height", context),
                            // padding: EdgeInsets.all(getSize(0,"height",context)),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(
                                  getSize(20, "height", context)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF000000).withOpacity(0.11),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset:
                                      Offset(0, 5), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: getSize(33, "height", context),
                                  horizontal: getSize(28, "width", context)),
                              child: Column(
                                children: [
                                  Container(
                                    width: getSize(100, "height", context),
                                    height: getSize(100, "height", context),
                                    padding: EdgeInsets.symmetric(
                                        vertical: getSize(0, "height", context),
                                        horizontal: getSize(0, "width", context)),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color:
                                          AppColors.greenColor.withOpacity(0.35),
                                    ),
                                    child: Stack(
                                      overflow: Overflow.visible,
                                      children: <Widget>[
                                        Positioned(
                                          child: Center(
                                              child: Image.asset(
                                            'assets/images/Map pin-3.png',
                                            height:
                                                getSize(45.6, "height", context),
                                            width:
                                                getSize(37.77, "width", context),
                                          )),
                                        ),
                                        Positioned(
                                          left: getSize(60, "width", context),
                                          top: getSize(61, "height", context),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical:
                                                    getSize(9, "width", context),
                                                horizontal: getSize(
                                                    9, "height", context)),
                                            child: SizedBox(
                                              width:
                                                  getSize(31, "height", context),
                                              height:
                                                  getSize(31, "height", context),
                                              child: Card(
                                                elevation: 2.5,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                100))),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.check,
                                                    size: getSize(
                                                        9, "height", context),
                                                    color: AppColors.greenColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: getSize(21, "height", context),
                                  ),
                                  Text(
                                    "Alerte envoyé",
                                    style: AppTheme.defaultParagraph,
                                  ),
                                  SizedBox(
                                    height: getSize(12, "height", context),
                                  ),
                                  Container(
                                    width: getSize(220, "width", context),
                                    child: Text(
                                      "Une alerte de ce type a déjà été créee dans votre zone, Merci.",
                                      style: AppTheme.bodyText1.copyWith(
                                        color:
                                            AppColors.blackColor.withOpacity(0.5),
                                      ),
                                      textAlign: TextAlign.center,
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
          } else {
            showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel:
                    MaterialLocalizations.of(context).modalBarrierDismissLabel,
                barrierColor: AppColors.whiteColor.withOpacity(0.96),
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (BuildContext buildContext, Animation animation,
                    Animation secondaryAnimation) {
                  return Center(
                    child: Card(
                      shadowColor: Colors.transparent,
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: getSize(303, "width", context),
                            // height: getSize(256, "height", context),
                            // padding: EdgeInsets.all(getSize(0,"height",context)),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(
                                  getSize(20, "height", context)),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF000000).withOpacity(0.11),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset:
                                      Offset(0, 5), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: getSize(33, "height", context),
                                  horizontal: getSize(28, "width", context)),
                              child: Column(
                                children: [
                                  Container(
                                    width: getSize(100, "height", context),
                                    height: getSize(100, "height", context),
                                    padding: EdgeInsets.symmetric(
                                        vertical: getSize(36, "height", context),
                                        horizontal:
                                            getSize(30, "width", context)),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.red.withOpacity(0.35),
                                    ),
                                    child: Center(
                                        child: Icon(
                                      Icons.close,
                                      size: getSize(38, "height", context),
                                      color: Colors.white,
                                    )),
                                  ),
                                  SizedBox(
                                    height: getSize(21, "height", context),
                                  ),
                                  Text(
                                    "Erreur",
                                    style: AppTheme.defaultParagraph,
                                  ),
                                  SizedBox(
                                    height: getSize(12, "height", context),
                                  ),
                                  Container(
                                    width: getSize(220, "width", context),
                                    child: Text(
                                      data['message'],
                                      style: AppTheme.bodyText1.copyWith(
                                        color:
                                            AppColors.blackColor.withOpacity(0.5),
                                      ),
                                      textAlign: TextAlign.center,
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
          }
        }
      } else {
        if (data['alert']['postedBy']['_id'] == userId)
          showGeneralDialog(
              context: context,
              barrierDismissible: true,
              barrierLabel:
                  MaterialLocalizations.of(context).modalBarrierDismissLabel,
              barrierColor: AppColors.whiteColor.withOpacity(0.96),
              transitionDuration: const Duration(milliseconds: 200),
              pageBuilder: (BuildContext buildContext, Animation animation,
                  Animation secondaryAnimation) {
                return Center(
                  child: Card(
                    shadowColor: Colors.transparent,
                    margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: getSize(303, "width", context),
                          // height: getSize(256, "height", context),
                          // padding: EdgeInsets.all(getSize(0,"height",context)),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(
                                getSize(20, "height", context)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF000000).withOpacity(0.11),
                                spreadRadius: 5,
                                blurRadius: 10,
                                offset:
                                    Offset(0, 5), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: getSize(33, "height", context),
                                horizontal: getSize(28, "width", context)),
                            child: Column(
                              children: [
                                Container(
                                  width: getSize(100, "height", context),
                                  height: getSize(100, "height", context),
                                  padding: EdgeInsets.symmetric(
                                      vertical: getSize(0, "height", context),
                                      horizontal: getSize(0, "width", context)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color:
                                        AppColors.greenColor.withOpacity(0.35),
                                  ),
                                  child: Stack(
                                    overflow: Overflow.visible,
                                    children: <Widget>[
                                      Positioned(
                                        child: Center(
                                            child: Image.asset(
                                          'assets/images/Map pin-3.png',
                                          height:
                                              getSize(45.6, "height", context),
                                          width:
                                              getSize(37.77, "width", context),
                                        )),
                                      ),
                                      Positioned(
                                        left: getSize(60, "width", context),
                                        top: getSize(61, "height", context),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  getSize(9, "width", context),
                                              horizontal: getSize(
                                                  9, "height", context)),
                                          child: SizedBox(
                                            width:
                                                getSize(31, "height", context),
                                            height:
                                                getSize(31, "height", context),
                                            child: Card(
                                              elevation: 2.5,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              100))),
                                              child: Center(
                                                child: Icon(
                                                  Icons.check,
                                                  size: getSize(
                                                      9, "height", context),
                                                  color: AppColors.greenColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: getSize(21, "height", context),
                                ),
                                Text(
                                  "Alerte envoyé",
                                  style: AppTheme.defaultParagraph,
                                ),
                                SizedBox(
                                  height: getSize(12, "height", context),
                                ),
                                Container(
                                  width: getSize(220, "width", context),
                                  child: Text(
                                    "Votre alerte a été signalée à tous les utilisateurs de Mapane",
                                    style: AppTheme.bodyText1.copyWith(
                                      color:
                                          AppColors.blackColor.withOpacity(0.5),
                                    ),
                                    textAlign: TextAlign.center,
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
      }
    });
    socket.connect();
    sockets[identifier] = socket;
  }

  bool isProbablyConnected(String identifier) {
    return _isProbablyConnected[identifier] ?? false;
  }

  disconnect(String identifier) async {
    await manager.clearInstance(sockets[identifier]);
    setState(() => _isProbablyConnected[identifier] = false);
  }

  manageLoader() {
    // Navigator.pop(context);
    setState(() => loadera = false);
  }

  sendAlertPopup(category, address, posted, latlon) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: AppColors.whiteColor.withOpacity(0.96),
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: getSize(303, "width", context),
                  // height: getSize(256, "height", context),
                  // padding: EdgeInsets.all(getSize(0,"height",context)),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius:
                        BorderRadius.circular(getSize(20, "height", context)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF000000).withOpacity(0.11),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(getSize(20, "height", context)),
                        decoration: BoxDecoration(
                            // color: AppColors.whiteColor,
                            ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                  text: "Quelle est votre position ?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: getSize(18, "height", context),
                                      color: Colors.black)),
                            ),
                            SizedBox(
                              height: getSize(29, "height", context),
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: getSize(44, "height", context),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      child: Drawer(
                                        elevation: 0,
                                        child: Container(
                                          color: Colors.white,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: TextField(
                                            controller:
                                                TextEditingController(text: ""),
                                            onChanged: (value) {
                                              customAddress = value;
                                            },
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                ),
                                                filled: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 5.0,
                                                        horizontal: 12),
                                                hintStyle: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(.22)),
                                                hintText: "Entrer l'adresse",
                                                fillColor: Colors.black
                                                    .withOpacity(.04)),
                                            style: AppTheme.buttonText,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: getSize(16, "height", context),
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    child: Container(
                                      height: getSize(40, "height", context),
                                      width: getSize(162, "width", context),
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          loaderPopup();
                                          sendAlert(
                                              "default",
                                              category,
                                              address,
                                              posted,
                                              latlon,
                                              customAddress);
                                        },
                                        color: Color(0x162C306F),
                                        padding: EdgeInsets.fromLTRB(
                                            0,
                                            getSize(5, "height", context),
                                            0,
                                            getSize(5, "height", context)),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Non, merci.',
                                            style: TextStyle(
                                              fontSize: getSize(
                                                  18, "height", context),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: getSize(40, "height", context),
                                    width: getSize(91, "width", context),
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        loaderPopup();
                                        sendAlert("default", category, address,
                                            posted, latlon, customAddress);
                                      },
                                      textColor: Colors.white,
                                      color: Colors.transparent,
                                      padding: EdgeInsets.all(0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          gradient: LinearGradient(
                                            colors: <Color>[
                                              Color(0xFFA7BACB),
                                              Color(0xFF25296A),
                                            ],
                                          ),
                                        ),
                                        padding: EdgeInsets.fromLTRB(
                                            0,
                                            getSize(5, "height", context),
                                            0,
                                            getSize(5, "height", context)),
                                        child: Center(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Oui',
                                              style: TextStyle(
                                                fontSize: getSize(
                                                    18, "height", context),
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        )),
                                      ),
                                    ),
                                  ),
                                ])
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  sendAlert(identifier, category, address, posted, latlon, desc) {
    print(_isProbablyConnected[identifier]);
    // var readText = 'Alerte d\'embouteillage à Monde-uni Bilingual School depuis 1 heures 30 minutes.';
    // _speak(readText);
    // var readText = "Attention, vous êtes à 300 mètres d'un point Mapane";
    print("Emission prepared");
    if (sockets[identifier] != null) {
      if (_isProbablyConnected[identifier]) {
        sockets[identifier].emit("createAlert", [
          JsonEncoder().convert({
            "lat": latlon.latitude,
            "long": latlon.longitude,
            "desc": desc == "" || desc == null ? "desc" : desc,
            "postedBy": posted,
            "category": category,
            "address": address == '' ? ' ' : address
          })
        ]);
      } else {
        initSocket(identifier);
        sockets[identifier].emit("createAlert", [
          JsonEncoder().convert({
            "lat": latlon.latitude,
            "long": latlon.longitude,
            "desc": desc == "" || desc == null ? "desc" : desc,
            "postedBy": posted,
            "category": category,
            "address": address == '' ? ' ' : address
          })
        ]);
      }
    }
  }

  loaderPopup() {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: AppColors.whiteColor.withOpacity(0.92),
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Center(
            child: Card(
              shadowColor: Colors.transparent,
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: getSize(70, "width", context),
                    height: getSize(70, "height", context),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius:
                          BorderRadius.circular(getSize(15, "height", context)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF000000).withOpacity(0.11),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: getSize(10, "height", context),
                          horizontal: getSize(10, "width", context)),
                      child: Column(
                        children: [
                          Center(
                            child: SpinKitChasingDots(
                              color: HexColor("#A7BACB"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    if (isAndroid) {
      _getEngines();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
        setState(() {
          print("Paused");
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    if (languages != null) setState(() => languages);
  }

  Future _getEngines() async {
    var engines = await flutterTts.getEngines;
    if (engines != null) {
      for (dynamic engine in engines) {
        print(engine);
      }
    }
  }

  Future _speak(test) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (test != null) {
      if (test.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(test);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), Assets.locationMarker);
    embouteillageMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), Assets.embouteillageMarker2);
    radarMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), Assets.radarMarker2);
    accidentMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), Assets.accidentMarker2);
    controleMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), Assets.controleMarker2);
    routebarreeMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), Assets.routebarreeMarker2);
    routechantierMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), Assets.routechantierMarker2);
    dangerMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), Assets.dangerMarker2);
    proximityMarker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), Assets.proximityMarker);

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), Assets.proximityMarker);
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location.getLocation();

    // hard-coded destination for this example
    destinationLocation = LocationData.fromMap({
      "latitude": DEST_LOCATION.latitude,
      "longitude": DEST_LOCATION.longitude
    });
  }

  void showPinsOnMap() {
    _markers = Set<Marker>();
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    var pinPosition =
        LatLng(currentLocation.latitude, currentLocation.longitude);
    // get a LatLng out of the LocationData object
    var destPosition =
        LatLng(destinationLocation.latitude, destinationLocation.longitude);
    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon: sourceIcon));

    context.read<AlertProvider>().getAlertList(false, addresse);

    // destination
    context.read<AlertProvider>().alertList.fold((l) => null, (r) {
      int i = 1;
      print("lise des alertes " + r.length.toString());
      if (r.length > 0) {
        r.forEach((element) {
          Moment.setLocaleGlobally(new LocaleFr());
          var moment = Moment.now();
          var dateForComparison = DateTime.parse(element.createdAt);
          print(mapanes.contains(element));
          _markers.add(Marker(
              position:
                  LatLng(double.parse(element.lat), double.parse(element.lon)),
              markerId: MarkerId('alerte ' + element.id),
              icon: mapanes.contains(element)
                  ? destinationIcon
                  : getAppropriateIcon(element.category.name),
              infoWindow: InfoWindow(
                  title: element.category.name,
                  snippet: 'Alerte créee ' + moment.from(dateForComparison))));
          i++;
        });
      }
    });
    /*_markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        icon: destinationIcon));*/

    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    setPolylines();
    showCirclesOnMap();
  }
  dynamic radiusTest = {
    "radius" : 300,
    "level" : true
  };
  updateCirlce(){
    if(radiusTest["level"]){
      if( radiusTest["radius"] == 100){
        setState(() {
          radiusTest["level"] = false;
          showCirclesOnMap();
        });
      } else {
        setState(() {
          radiusTest["radius"] -= 100;
          showCirclesOnMap();
        });
      }
    }else{
      if( radiusTest["radius"] == 300){
        setState(() {
          radiusTest["level"] = true;
          showCirclesOnMap();
        });
      } else {
        setState(() {
          radiusTest["radius"] += 100;
          showCirclesOnMap();
        });
      }
    }
  }
  void showCirclesOnMap(){
    int i = 0;
    _circles.clear();
    mapanes.forEach((element) {
      _circles.add(
        Circle(
          circleId: CircleId("circle"+i.toString()),
          center: LatLng(double.parse(element.lat),double.parse(element.lon)),
          radius: double.parse(radiusTest["radius"].toString()),//element.category.perimeter * 1000,
          fillColor: Colors.redAccent[200].withOpacity(0.1),
          strokeWidth: 3,
          strokeColor: Colors.red
        )
      );
    });
    if(mapanes.isNotEmpty){
      const duration = const Duration(milliseconds: 100);
      if(_circleTimer == null){
        _circleTimer = new Timer.periodic(duration,(Timer timer){
          updateCirlce();
        });
      } else {
        if(!_circleTimer.isActive){
          _circleTimer = new Timer.periodic(duration,(Timer timer){
            updateCirlce();
          });
        }
      }
    }
  }

  getAppropriateIcon(alert) {
    switch (alert) {
      case "Embouteillage":
        return embouteillageMarker;
        break;
      case "Route en chantier":
        return routechantierMarker;
        break;
      case "Zone dangereuse":
        return dangerMarker;
        break;
      case "Controle routier":
        return controleMarker;
        break;
      case "Radar":
        return radarMarker;
        break;
      case "Accident de circulation":
        return accidentMarker;
        break;
      case "Route barrée":
        return routebarreeMarker;
        break;
      default:
        return embouteillageMarker;
    }
  }

  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      setState(() {
        _polylines.add(Polyline(
            width: 5, // set the width of the polylines
            polylineId: PolylineId("poly"),
            visible: true,
            color: Color.fromARGB(255, 40, 122, 198),
            points: polylineCoordinates));
      });
    }
  }

  void updatePinOnMap() async {
    setState(() {
      // updated position
      var pinPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);
      _kPosition = CameraPosition(
          zoom: zooming,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING,
          target: pinPosition);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere((m) => m.markerId.value == "sourcePin");
      _markers.add(Marker(
          markerId: MarkerId("sourcePin"),
          position: pinPosition, // updated position
          icon: sourceIcon));
      showPinsOnMap();
    });
  }

  updateBottomPadding(context) {
    if (bottomPadding == null) {
      bottomPadding = SizeConfig.screenHeight / 50;
      setState((){
        if (isExpanded) {
          isExpanded = false;
          alertHeight =
              getSize(30, "height", context);
          print(getSize(17, "height", context));
          bottomPadding =
              getSize(17, "height", context);
        } else {
          isExpanded = true;
          alertHeight =
              getSize(300, "height", context);
          bottomPadding =
              getSize(285, "height", context);
          swiperIcon = Container(
            child: SvgPicture.asset(
              Assets.arrowDownIcon,
            ),
            height: 32.0,
            width: 32.0,
          );

        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    updateBottomPadding(context);
    return SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white.withOpacity(0.5),
          extendBody: true,
          body: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: GoogleMap(
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  markers: _markers,
                  circles: _circles,
                  tiltGesturesEnabled: false,
                  polylines: _polylines,
                  mapType: MapType.normal,
                  initialCameraPosition: _kPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    // my map has completed being created;
                    showPinsOnMap();
                  },
                  onCameraMove: (CameraPosition position) {
                    setState(() {
                      cameraCurrentPosition = position;
                    });
                  },
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      child:
                          context.watch<AlertProvider>().notifications.isEmpty
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: context
                                              .watch<AlertProvider>()
                                              .notifications
                                              .length ==
                                          1
                                      ? Notif(
                                          alert: context
                                              .watch<AlertProvider>()
                                              .notifications[0],
                                          onClose: () {
                                            context
                                                .read<AlertProvider>()
                                                .popNotification(0);
                                          },
                                          move: () {
                                            CameraPosition cPosition =
                                                CameraPosition(
                                              zoom: zooming,
                                              tilt: CAMERA_TILT,
                                              bearing: CAMERA_BEARING,
                                              target: LatLng(
                                                  double.parse(context
                                                      .read<AlertProvider>()
                                                      .notifications[0]
                                                      .lat),
                                                  double.parse(context
                                                      .read<AlertProvider>()
                                                      .notifications[0]
                                                      .lon)),
                                            );
                                            _goTo(cPosition);
                                            context
                                                .read<AlertProvider>()
                                                .popNotification(0);
                                          },
                                        )
                                      : NotificationMapane(
                                          CAMERA_ZOOM: zooming,
                                          CAMERA_TILT: CAMERA_TILT,
                                          CAMERA_BEARING: CAMERA_BEARING,
                                          completer: _controller,
                                        ),
                                ))),
              Padding(
                padding: EdgeInsets.only(
                    top: SizeConfig.blockSizeVertical * 2,
                    left: SizeConfig.blockSizeHorizontal * 4,
                    right: SizeConfig.blockSizeHorizontal * 4),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      context.watch<PlaceProvider>().loadingState ==
                              LoadingState.loading
                          ? Column(
                              children: [
                                SpinKitThreeBounce(
                                  color: HexColor("#A7BACB"),
                                ),
                              ],
                            )
                          : context
                              .select((PlaceProvider provider) => provider)
                              .userPlace
                              .fold((NException error) {
                              return Container(
                                width:
                                SizeConfig.blockSizeHorizontal * 38,
                                child: Column(
                                  children: [
                                    Text(
                                      error.message,
                                    )
                                  ],
                                ),
                              );
                            }, (userPlace) {
                              if (userPlace.name != null &&
                                  userPlace.city != null &&
                                  userPlace.country != null) {
                                addresse = userPlace.name +
                                    ", " +
                                    userPlace.city +
                                    ", " +
                                    userPlace.country;
                              }
                              return userPlace == null
                                  ? Container(
                                width:
                                SizeConfig.blockSizeHorizontal * 38,
                                    child: Column(
                                        children: [
                                          Text(
                                            "Not available right now.",
                                            style: TextStyle(
                                                fontSize: 18.0),
                                          )
                                        ],
                                      ),
                                  )
                                  : Container(
                                      width:
                                          SizeConfig.blockSizeHorizontal * 38,
                                      child: Column(
                                        children: [
                                          Text(
                                            userPlace.name ?? " ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.0),
                                            overflow: TextOverflow.clip,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: SizeConfig
                                                        .blockSizeHorizontal *
                                                    5,
                                                top: SizeConfig
                                                        .blockSizeVertical /
                                                    2),
                                            child: Text(
                                              userPlace.city == null
                                                  ? " "
                                                  : userPlace.city +
                                                      "," +
                                                      userPlace.country,
                                              overflow: TextOverflow.clip,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                            }),
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 5,
                      ),
                      UtilButton(
                        onTap: () async {
                          context.read<UserProvider>().modifyPopupParam(
                              !context.read<UserProvider>().popupVal);
                        },
                        height: getSize(38, "width", context),
                        width: getSize(38, "width", context),
                        icon: context.watch<UserProvider>().popupVal
                            ? Icon(Icons.notifications_none_outlined)
                            : Icon(Icons.notifications_off_outlined),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<UserProvider>().modifyAudioParam(
                              !context.read<UserProvider>().audioVal);
                        },
                        child: UtilButton(
                          height: getSize(38, "width", context),
                          width: getSize(38, "width", context),
                          icon: context.watch<UserProvider>().audioVal
                              ? SvgPicture.asset(Assets.soundIcon)
                              : Icon(Icons.volume_off_outlined),
                        ),
                      ),
                      UtilButton(
                        onTap: () async {
                          final GoogleMapController controller =
                              await _controller.future;
                          var currentZoomLevel =
                              await controller.getZoomLevel();
                          setState(() {
                            zooming = currentZoomLevel + 1;
                          });
                          controller.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: cameraCurrentPosition.target,
                                zoom: zooming,
                              ),
                            ),
                          );
                        },
                        height: getSize(38, "width", context),
                        width: getSize(38, "width", context),
                        icon: SvgPicture.asset(
                          Assets.zoomPlusIcon,
                        ),
                      ),
                      UtilButton(
                        onTap: () async {
                          final GoogleMapController controller =
                              await _controller.future;
                          var currentZoomLevel =
                              await controller.getZoomLevel();
                          setState(() {
                            zooming = currentZoomLevel - 1;
                          });
                          controller.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: cameraCurrentPosition.target,
                                zoom: zooming,
                              ),
                            ),
                          );
                        },
                        height: getSize(38, "width", context),
                        width: getSize(38, "width", context),
                        icon: SvgPicture.asset(
                          Assets.zoomMinIcon,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedPadding(
                duration: Duration(milliseconds: 500),
                padding: EdgeInsets.only(
                    bottom: !isExpanded
                        ? getSize(160, "height", context)
                        : getSize(422, "height", context),
                    right: SizeConfig.blockSizeHorizontal * 6),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: UtilButton(
                      height: getSize(46, "width", context),
                      width: getSize(46, "width", context),
                      icon: Icon(Icons.my_location),
                      onTap: () {
                        _goToMyPosition();
                      },
                    )),
              ),
              AnimatedPadding(
                duration: Duration(milliseconds: 500),
                padding: EdgeInsets.only(
                    bottom: !isExpanded
                        ? getSize(100, "height", context)
                        : getSize(365, "height", context),
                    right: SizeConfig.blockSizeHorizontal * 6),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: UtilButton(
                    onTap: () {
                      showMaterialModalBottomSheet(
                        context: context,
                        builder: (context) => SingleChildScrollView(
                          controller: ModalScrollController.of(context),
                          child: Container(
                            height: SizeConfig.blockSizeVertical * 50,
                            width: SizeConfig.screenWidth,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(35),
                                  topRight: Radius.circular(35)),
                            ),
                            child: Stack(
                              overflow: Overflow.visible,
                              children: [
                                Positioned(
                                    bottom: getSize(320, "height", context),
                                    child: Container(
                                      width: getSize(375, "width", context),
                                      alignment: Alignment.center,
                                      child: SvgPicture.asset(
                                        Assets.arrowDownIcon,
                                      ),
                                    )),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.blockSizeVertical * 5,
                                      left: SizeConfig.blockSizeHorizontal * 7,
                                      right:
                                          SizeConfig.blockSizeHorizontal * 7),
                                  child: TextField(
                                    textInputAction: TextInputAction.go,
                                    controller: _startPointController,
                                    style: TextStyle(fontSize: 17.0),
                                    onSubmitted: (value) {
                                      print("resultat recehrcehe");
                                      print(value);
                                      context
                                          .read<SearchProvider>()
                                          .getSearchResults(value);
                                      // context
                                      //     .read<SearchProvider>()
                                      //     .toggleSearchState();
                                    },
                                    // onTap: () {
                                    //   context
                                    //       .read<SearchProvider>()
                                    //       .toggleSearchState();
                                    // },
                                    decoration: InputDecoration(
                                        hintText: 'Rechercher un lieu',
                                        hintStyle: TextStyle(fontSize: 17.0),
                                        border: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.red)),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.grey[200])),
                                        suffixIcon: Icon(Icons.search)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.blockSizeVertical * 5),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              SizeConfig.blockSizeHorizontal *
                                                  7),
                                      child:
                                          context
                                                      .watch<SearchProvider>()
                                                      .isSearchEnable ==
                                                  false
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SvgPicture.asset(
                                                      Assets.illustration,
                                                    ),
                                                    SizedBox(
                                                      width: SizeConfig
                                                              .blockSizeHorizontal *
                                                          6,
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        "Avec Mapane, recherchez des lieux de vos choix et soyez informé en temps réel en cas d’alerte.",
                                                        overflow:
                                                            TextOverflow.clip,
                                                      ),
                                                    )
                                                  ],
                                                )
                                              : context
                                                          .watch<
                                                              SearchProvider>()
                                                          .loadingState ==
                                                      LoadingState.loading
                                                  ? Center(
                                                      child: SpinKitChasingDots(
                                                        color:
                                                            HexColor("#A7BACB"),
                                                      ),
                                                    )
                                                  : context
                                                      .select((SearchProvider
                                                              provider) =>
                                                          provider)
                                                      .placesResult
                                                      .fold((NException error) {
                                                      return Column(
                                                        children: [
                                                          AspectRatio(
                                                              aspectRatio:
                                                                  5 / 1),
                                                          Center(
                                                            child: Text(
                                                              error.message,
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    }, (placesResult) {
                                                      return placesResult
                                                              .isEmpty
                                                          ? Column(
                                                              children: [
                                                                AspectRatio(
                                                                    aspectRatio:
                                                                        5 / 1),
                                                                Center(
                                                                  child: Text(
                                                                      "Aucun résultat pour cette recherche"),
                                                                )
                                                              ],
                                                            )
                                                          : Padding(
                                                              padding: EdgeInsets.only(
                                                                  top: SizeConfig
                                                                          .blockSizeVertical *
                                                                      7),
                                                              child: Container(
                                                                child: ListView
                                                                    .separated(
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    String osm_value = placesResult[index].osm_value !=
                                                                            null
                                                                        ? placesResult[index].osm_value +
                                                                            ","
                                                                        : " ";
                                                                    String city = placesResult[index].city !=
                                                                            null
                                                                        ? placesResult[index].city +
                                                                            ","
                                                                        : " ";
                                                                    String country = placesResult[index].country !=
                                                                            null
                                                                        ? placesResult[index].country +
                                                                            ","
                                                                        : " ";
                                                                    return ListTile(
                                                                      leading:
                                                                          SvgPicture
                                                                              .asset(
                                                                        Assets
                                                                            .pathIcon,
                                                                      ),
                                                                      title:
                                                                          Text(
                                                                        placesResult[index].name !=
                                                                                null
                                                                            ? placesResult[index].name
                                                                            : " ",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                17.0,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                      subtitle:
                                                                          Text(
                                                                        osm_value +
                                                                            city +
                                                                            country,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12.0,
                                                                            color:
                                                                                Colors.grey),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        CameraPosition positionToGo = CameraPosition(
                                                                            bearing:
                                                                                CAMERA_BEARING,
                                                                            target:
                                                                                LatLng(placesResult[index].coordinates[1], placesResult[index].coordinates[0]),
                                                                            tilt: CAMERA_TILT,
                                                                            zoom: zooming);
                                                                        _goTo(
                                                                            positionToGo);
                                                                      },
                                                                    );
                                                                  },
                                                                  itemCount:
                                                                      placesResult
                                                                          .length,
                                                                  separatorBuilder:
                                                                      (index,
                                                                          count) {
                                                                    return Divider(
                                                                      color: Colors
                                                                          .transparent,
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            );
                                                    }),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    height: getSize(46, "width", context),
                    width: getSize(46, "width", context),
                    icon: SvgPicture.asset(
                      Assets.searchIcon,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: SizeConfig.blockSizeVertical * 7.27),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    alignment: Alignment.topCenter,
                    height: alertHeight,
                    width: SizeConfig.screenWidth,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(isExpanded ? 35 : 0),
                            topRight: Radius.circular(isExpanded ? 35 : 0)),
                        color: isExpanded
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        boxShadow: [
                          isExpanded
                              ? BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                )
                              : BoxShadow(
                                  color: Colors.transparent,
                                )
                        ]),
                    duration: Duration(milliseconds: 500),
                    child: Stack(
                      overflow: Overflow.visible,
                      children: [
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 500),
                          bottom: bottomPadding,
                          child: Container(
                            alignment: Alignment.center,
                            width: getSize(375, "width", context),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (isExpanded) {
                                    isExpanded = false;
                                    alertHeight =
                                        getSize(30, "height", context);
                                    print(getSize(17, "height", context));
                                    bottomPadding =
                                        getSize(17, "height", context);
                                  } else {
                                    isExpanded = true;
                                    alertHeight =
                                        getSize(300, "height", context);
                                    bottomPadding =
                                        getSize(285, "height", context);
                                  }
                                });
                              },
                              child: swiperIcon,
                            ),
                          ),
                        ),
                        isExpanded
                            ? Padding(
                                padding: const EdgeInsets.all(28.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            sendAlertPopup(
                                                "embouteillage3",
                                                addresse,
                                                userId,
                                                LatLng(currentLocation.latitude,
                                                    currentLocation.longitude));
                                          },
                                          child: Container(
                                              width:
                                                  getSize(75, "width", context),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: getSize(75,
                                                            "width", context),
                                                        child: Image.asset(
                                                            'assets/images/embouteillage.png',
                                                            height: getSize(
                                                                56,
                                                                "height",
                                                                context)),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: getSize(15,
                                                          "height", context)),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: getSize(75,
                                                            "width", context),
                                                        height: getSize(30,
                                                            "height", context),
                                                        child: Text(
                                                          "Embouteillages",
                                                          maxLines: 2,
                                                          softWrap: true,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      .5),
                                                              fontSize: getSize(
                                                                  12,
                                                                  "height",
                                                                  context)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            sendAlertPopup(
                                                "controle-routier2",
                                                addresse,
                                                userId,
                                                LatLng(currentLocation.latitude,
                                                    currentLocation.longitude));
                                          },
                                          child: Container(
                                              width:
                                                  getSize(75, "width", context),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: getSize(75,
                                                            "width", context),
                                                        child: Image.asset(
                                                            'assets/images/controle-routier.png',
                                                            height: getSize(
                                                                56,
                                                                "height",
                                                                context)),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: getSize(15,
                                                          "height", context)),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: getSize(75,
                                                            "width", context),
                                                        height: getSize(30,
                                                            "height", context),
                                                        child: Text(
                                                          "Contrôle routier",
                                                          maxLines: 2,
                                                          softWrap: true,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      .5),
                                                              fontSize: getSize(
                                                                  12,
                                                                  "height",
                                                                  context)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            sendAlertPopup(
                                                "zone-dangereuse-1",
                                                addresse,
                                                userId,
                                                LatLng(currentLocation.latitude,
                                                    currentLocation.longitude));
                                          },
                                          child: Container(
                                              width:
                                                  getSize(75, "width", context),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: getSize(75,
                                                            "width", context),
                                                        child: Image.asset(
                                                            'assets/images/zone-danger.png',
                                                            height: getSize(
                                                                56,
                                                                "height",
                                                                context)),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: getSize(15,
                                                          "height", context)),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: getSize(75,
                                                            "width", context),
                                                        height: getSize(30,
                                                            "height", context),
                                                        child: Text(
                                                          "Zône dangereuse",
                                                          maxLines: 2,
                                                          softWrap: true,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      .5),
                                                              fontSize: getSize(
                                                                  12,
                                                                  "height",
                                                                  context)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            sendAlertPopup(
                                                "Radar1",
                                                addresse,
                                                userId,
                                                LatLng(currentLocation.latitude,
                                                    currentLocation.longitude));
                                          },
                                          child: Container(
                                              width:
                                                  getSize(75, "width", context),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: getSize(75,
                                                            "width", context),
                                                        child: Image.asset(
                                                            'assets/images/radar-test.png',
                                                            height: getSize(
                                                                56,
                                                                "height",
                                                                context)),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: getSize(15,
                                                          "height", context)),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: getSize(75,
                                                            "width", context),
                                                        height: getSize(30,
                                                            "height", context),
                                                        child: Text(
                                                          "Radar",
                                                          maxLines: 2,
                                                          softWrap: true,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      .5),
                                                              fontSize: getSize(
                                                                  12,
                                                                  "height",
                                                                  context)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                        height: getSize(30, "height", context)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            sendAlertPopup(
                                                "Accident-de-circulation-1",
                                                addresse,
                                                userId,
                                                LatLng(currentLocation.latitude,
                                                    currentLocation.longitude));
                                          },
                                          child: Container(
                                              width:
                                                  getSize(75, "width", context),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: getSize(75,
                                                            "width", context),
                                                        child: Image.asset(
                                                            'assets/images/accident-circulation.png',
                                                            height: getSize(
                                                                56,
                                                                "height",
                                                                context)),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: getSize(15,
                                                          "height", context)),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: getSize(75,
                                                            "width", context),
                                                        height: getSize(42,
                                                            "height", context),
                                                        child: Text(
                                                          "Accident de circulation",
                                                          maxLines: 2,
                                                          softWrap: true,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      .5),
                                                              fontSize: getSize(
                                                                  12,
                                                                  "height",
                                                                  context)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            sendAlertPopup(
                                                "route-barree2",
                                                addresse,
                                                userId,
                                                LatLng(currentLocation.latitude,
                                                    currentLocation.longitude));
                                          },
                                          child: Container(
                                              width:
                                                  getSize(75, "width", context),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: getSize(75,
                                                            "width", context),
                                                        child: Image.asset(
                                                            'assets/images/route block.png',
                                                            height: getSize(
                                                                56,
                                                                "height",
                                                                context)),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: getSize(15,
                                                          "height", context)),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: getSize(75,
                                                            "width", context),
                                                        height: getSize(42,
                                                            "height", context),
                                                        child: Text(
                                                          "Route barrée",
                                                          maxLines: 2,
                                                          softWrap: true,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      .5),
                                                              fontSize: getSize(
                                                                  12,
                                                                  "height",
                                                                  context)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            sendAlertPopup(
                                                "Route-en-chantier-2",
                                                addresse,
                                                userId,
                                                LatLng(currentLocation.latitude,
                                                    currentLocation.longitude));
                                          },
                                          child: Container(
                                              width:
                                                  getSize(75, "width", context),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: getSize(75,
                                                            "width", context),
                                                        child: Image.asset(
                                                            'assets/images/chantier.png',
                                                            height: getSize(
                                                                56,
                                                                "height",
                                                                context)),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: getSize(15,
                                                          "height", context)),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: getSize(75,
                                                            "width", context),
                                                        height: getSize(42,
                                                            "height", context),
                                                        child: Text(
                                                          "Route en chantier",
                                                          maxLines: 2,
                                                          softWrap: true,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      .5),
                                                              fontSize: getSize(
                                                                  12,
                                                                  "height",
                                                                  context)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        ),
                                        Container(
                                            width:
                                                getSize(75, "width", context),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: getSize(
                                                          75, "width", context),
                                                      child: Image.asset(
                                                          'assets/images/publierposition.png',
                                                          height: getSize(
                                                              56,
                                                              "height",
                                                              context)),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: getSize(
                                                        15, "height", context)),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: getSize(
                                                          75, "width", context),
                                                      height: getSize(32,
                                                          "height", context),
                                                      child: Text(
                                                        "Publier ma position",
                                                        maxLines: 2,
                                                        softWrap: true,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    .5),
                                                            fontSize: getSize(
                                                                12,
                                                                "height",
                                                                context)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Container()
                      ],
                    ),
                    onEnd: () {
                      setState(() {
                        if (!isExpanded) {
                          swiperIcon = Container(
                            child: SvgPicture.asset(
                              Assets.arrowUpIcon,
                            ),
                            height: 32.0,
                            width: 32.0,
                          );
                          context
                              .read<BottomBarProvider>()
                              .modifyColor(Colors.white.withOpacity(0.3));
                        } else {
                          context
                              .read<BottomBarProvider>()
                              .modifyColor(Colors.white);
                          swiperIcon = Container(
                            child: SvgPicture.asset(
                              Assets.arrowDownIcon,
                            ),
                            height: 32.0,
                            width: 32.0,
                          );
                        }
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
