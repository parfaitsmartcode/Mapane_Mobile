import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mapane/constants/assets.dart';
import 'package:mapane/custom/widgets/alert.dart';
import 'package:mapane/custom/widgets/util_button.dart';
import 'package:mapane/models/place.dart';
import 'package:mapane/networking/services/alert_service.dart';
import 'package:mapane/state/LoadingState.dart';
import 'package:mapane/state/alert_provider.dart';
import 'package:mapane/state/bottom_bar_provider.dart';
import 'package:mapane/state/place_provider.dart';
import 'package:mapane/state/search_provider.dart';
import 'package:mapane/state/user_provider.dart';
import 'package:mapane/utils/PermissionHelper.dart';
import 'package:mapane/utils/hexcolor.dart';
import 'package:mapane/utils/n_exception.dart';
import 'package:mapane/utils/size_config.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../utils/theme_mapane.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'dart:convert';
import 'dart:io' show Platform;
// import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:flutter_tts/flutter_tts.dart';

const String URI = "http://mapane.smartcodegroup.com/";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// enum TtsState { playing, stopped, paused, continued }
const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.747932, -71.167889);
const LatLng DEST_LOCATION = LatLng(37.335685, -122.0605916);

class _HomePageState extends State<HomePage> {
  bool isExpanded = false;
  double alertHeight = 30.0;
  double bottomPadding;
  String addresse = "";
  final _startPointController = TextEditingController();
  Widget swiperIcon = Container(
    child: SvgPicture.asset(
      Assets.arrowUpIcon,
    ),
    height: 32.0,
    width: 32.0,
  );

  List<String> toPrint = ["trying to connect"];
  SocketIOManager manager;
  Map<String, SocketIO> sockets = {};
  Map<String, bool> _isProbablyConnected = {};

  Set<Marker> _markers = Set<Marker>();
// for my drawn routes on the map
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  String googleAPIKey = "AIzaSyA1vPvfFjBhjgx0rOJcP8_K9vv5Xa2y1ZU";
// for my custom marker pins
  BitmapDescriptor sourceIcon;
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

  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _kPosition = CameraPosition(
      bearing: CAMERA_BEARING,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: CAMERA_TILT,
      zoom: CAMERA_ZOOM);

  Future<void> _goToMyPosition() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kPosition));
  }

  Future<void> _goTo(CameraPosition position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  @override
  initState() {
    if (!Platform.isIOS) {
      PermissionHelper.checkPermission(Permission.location);
    }
    super.initState();
    context.read<AlertProvider>().getAlertList();
    manager = SocketIOManager();
    initSocket("default");
    // create an instance of Location
    location = new Location();
    context.read<UserProvider>().getUserId().then((value) => userId = value);
    polylinePoints = PolylinePoints();

    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
    location.onLocationChanged.listen((LocationData cLoc) {
      bool test = true;
      if (currentLocation != null) test = false;

      if (!test)
        context.read<PlaceProvider>().getPlace(
            LatLng(currentLocation.latitude, currentLocation.longitude));
      currentLocation = cLoc;
      if (test) {
        context.read<PlaceProvider>().getPlace(
            LatLng(currentLocation.latitude, currentLocation.longitude));
        CameraPosition cPosition = CameraPosition(
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING,
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
        );
        _goTo(cPosition);
      }

      updatePinOnMap();
    });
    // set custom marker pins
    setSourceAndDestinationIcons();
    // set the initial location
    if (!Platform.isIOS) {
      setInitialLocation();
    }
  }

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
    socket.on("createAlertOkUser", (data) {
      Navigator.pop(context);
      setState(() => loadera = false);
      //sample event
      print("createAlertOkUser");
      print(data);
      if (data.containsKey('message')) {
        if (data['id'] == userId) if (data['message'] == "alerte inactive") {
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
                                    "Votre alerte a été signalé à tous les utilisateurs de Mapane",
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
      } else {
        if (data['alert']['postedBy'] == userId)
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
                                    "Votre alerte a été signalé à tous les utilisateurs de Mapane",
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

  sendAlert(identifier, category, address, posted, latlon) {
    print(_isProbablyConnected[identifier]);
    print("Emission prepared");
    if (sockets[identifier] != null) {
      if (_isProbablyConnected[identifier]) {
        sockets[identifier].emit("createAlert", [
          JsonEncoder().convert({
            "lat": latlon.latitude,
            "long": latlon.longitude,
            "desc": "test",
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
            "desc": "test",
            "postedBy": posted,
            "category": category,
            "address": address == '' ? ' ' : address
          })
        ]);
      }
    }
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), Assets.locationMarker);

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination_map_marker.png');
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
    // destination
    // context.watch<AlertProvider>().loadingState == LoadingState.loading ? print("test") :
    //     context
    //         .select((AlertProvider provider) => provider)
    //         .alertList
    //         .fold((NException error) {
    //           return false;
    //         // ignore: missing_return
    //         }, (alertList) {
    //       for (var i = 0; i < alertList.length; i++) {
    //         print("hoalal");
    //         print(alertList[i].category.name);
    //       }
    //     });
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        icon: destinationIcon));
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    setPolylines();
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
          zoom: CAMERA_ZOOM,
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
    });
  }

  updateBottomPadding() {
    if (bottomPadding == null) bottomPadding = SizeConfig.screenHeight / 50;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    updateBottomPadding();
    // bottomPadding = SizeConfig.screenHeight / 42;
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude, currentLocation.longitude),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING);
    }
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
                  tiltGesturesEnabled: false,
                  polylines: _polylines,
                  mapType: MapType.normal,
                  initialCameraPosition: initialCameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    // my map has completed being created;
                    // i'm ready to show the pins on the map
                    showPinsOnMap();
                  },
                ),
              ),
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
                              return Column(
                                children: [
                                  AspectRatio(aspectRatio: 5 / 1),
                                  Text(
                                    error.message,
                                  )
                                ],
                              );
                            }, (userPlace) {
                              if (userPlace.name != null &&
                                  userPlace.city != null &&
                                  userPlace.country != null) {
                                addresse = userPlace.name +
                                    "," +
                                    userPlace.city +
                                    "," +
                                    userPlace.country;
                              }
                              return userPlace == null
                                  ? Column(
                                      children: [
                                        AspectRatio(aspectRatio: 5 / 1),
                                        Text(
                                          "Not available right now.",
                                        )
                                      ],
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
                        height: getSize(38, "width", context),
                        width: getSize(38, "width", context),
                        icon: SvgPicture.asset(
                          Assets.soundIcon,
                        ),
                      ),
                      UtilButton(
                        height: getSize(38, "width", context),
                        width: getSize(38, "width", context),
                        icon: SvgPicture.asset(
                          Assets.zoomPlusIcon,
                        ),
                      ),
                      UtilButton(
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
                        ? SizeConfig.blockSizeVertical * 22
                        : SizeConfig.blockSizeVertical * 52,
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
                        ? SizeConfig.blockSizeVertical * 15
                        : SizeConfig.blockSizeVertical * 45,
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
                              children: [
                                Align(
                                    alignment: Alignment.topCenter,
                                    child: SvgPicture.asset(
                                      Assets.arrowDownIcon,
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
                                    onSubmitted: (value) {
                                      context
                                          .read<SearchProvider>()
                                          .getSearchResults(value);
                                    },
                                    onTap: () {
                                      context
                                          .read<SearchProvider>()
                                          .toggleSearchState();
                                    },
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
                                                        "Avec Mapane, rechercher des lieux de vos choix et soyez informé en temps réel en cas d’alerte.",
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
                                                      child:
                                                          CircularProgressIndicator(),
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
                                                                    print(placesResult
                                                                        .toList()
                                                                        .toString());
                                                                    return ListTile(
                                                                      leading:
                                                                          SvgPicture
                                                                              .asset(
                                                                        Assets
                                                                            .pathIcon,
                                                                      ),
                                                                      title:
                                                                          Text(
                                                                        placesResult[index]
                                                                            .name,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                17.0,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                      subtitle:
                                                                          Text(
                                                                        placesResult[index].osm_value +
                                                                            "," +
                                                                            placesResult[index].city +
                                                                            "," +
                                                                            placesResult[index].country +
                                                                            ",",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                12.0,
                                                                            color:
                                                                                Colors.grey),
                                                                      ),
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
                          left: getSize(173.64, "width", context),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (isExpanded) {
                                  isExpanded = false;
                                  alertHeight = 30.0;
                                  bottomPadding = SizeConfig.screenHeight / 50;
                                } else {
                                  isExpanded = true;
                                  alertHeight = 300.0;
                                  bottomPadding =
                                      SizeConfig.screenHeight / 2.90;
                                }
                              });
                              print(bottomPadding);
                            },
                            child: swiperIcon,
                          ),
                        ),
                        isExpanded
                            ? Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.blockSizeVertical * 5,
                                    left: SizeConfig.blockSizeHorizontal * 5,
                                    right: SizeConfig.blockSizeHorizontal * 5),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: GridView(
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            childAspectRatio:
                                                MediaQuery.of(context)
                                                        .devicePixelRatio /
                                                    4,
                                            crossAxisSpacing:
                                                SizeConfig.screenHeight / 55,
                                            mainAxisSpacing:
                                                SizeConfig.screenWidth / 19.6),
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom:
                                                SizeConfig.blockSizeVertical *
                                                    2),
                                        child: Alert(
                                          title: "Embouteillage",
                                          color: HexColor("#FECE4C")
                                              .withOpacity(0.25),
                                          picture: SvgPicture.asset(
                                            Assets.trafficIcon,
                                          ),
                                          radius: 30.0,
                                          onTap: () {
                                            setState(() => loadera = true);
                                            sendAlert(
                                                "default",
                                                "embouteillage3",
                                                addresse,
                                                userId,
                                                LatLng(currentLocation.latitude,
                                                    currentLocation.longitude));
                                            if (loadera) {
                                              showGeneralDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  barrierLabel:
                                                      MaterialLocalizations.of(
                                                              context)
                                                          .modalBarrierDismissLabel,
                                                  barrierColor: AppColors
                                                      .whiteColor
                                                      .withOpacity(0.92),
                                                  transitionDuration:
                                                      const Duration(
                                                          milliseconds: 200),
                                                  pageBuilder: (BuildContext
                                                          buildContext,
                                                      Animation animation,
                                                      Animation
                                                          secondaryAnimation) {
                                                    return Center(
                                                      child: Card(
                                                        shadowColor:
                                                            Colors.transparent,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 0,
                                                                vertical: 0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              width: getSize(
                                                                  70,
                                                                  "width",
                                                                  context),
                                                              height: getSize(
                                                                  70,
                                                                  "height",
                                                                  context),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .whiteColor,
                                                                borderRadius: BorderRadius
                                                                    .circular(getSize(
                                                                        15,
                                                                        "height",
                                                                        context)),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Color(
                                                                            0xFF000000)
                                                                        .withOpacity(
                                                                            0.11),
                                                                    spreadRadius:
                                                                        5,
                                                                    blurRadius:
                                                                        10,
                                                                    offset: Offset(
                                                                        0,
                                                                        5), // changes position of shadow
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Container(
                                                                padding: EdgeInsets.symmetric(
                                                                    vertical: getSize(
                                                                        10,
                                                                        "height",
                                                                        context),
                                                                    horizontal: getSize(
                                                                        10,
                                                                        "width",
                                                                        context)),
                                                                child: Column(
                                                                  children: [
                                                                    Center(
                                                                      child:
                                                                          SpinKitChasingDots(
                                                                        color: HexColor(
                                                                            "#A7BACB"),
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
                                          },
                                        ),
                                      ),
                                      Alert(
                                        title: "Contrôle routier",
                                        color: HexColor("#69BFFD")
                                            .withOpacity(0.25),
                                        picture: SvgPicture.asset(
                                          Assets.policeIcon,
                                        ),
                                        radius: 30.0,
                                        onTap: () {
                                          alertService
                                              .createAlert(
                                            LatLng(currentLocation.latitude,
                                                currentLocation.longitude),
                                            "test",
                                            userId,
                                            "controle-routier2",
                                            addresse,
                                          )
                                              .then((value) {
                                            showGeneralDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                barrierLabel:
                                                    MaterialLocalizations.of(
                                                            context)
                                                        .modalBarrierDismissLabel,
                                                barrierColor: AppColors
                                                    .whiteColor
                                                    .withOpacity(0.96),
                                                transitionDuration:
                                                    const Duration(
                                                        milliseconds: 200),
                                                pageBuilder: (BuildContext
                                                        buildContext,
                                                    Animation animation,
                                                    Animation
                                                        secondaryAnimation) {
                                                  return Center(
                                                    child: Card(
                                                      shadowColor:
                                                          Colors.transparent,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 0,
                                                              vertical: 0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            width: getSize(
                                                                303,
                                                                "width",
                                                                context),
                                                            // height: getSize(256, "height", context),
                                                            // padding: EdgeInsets.all(getSize(0,"height",context)),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .whiteColor,
                                                              borderRadius: BorderRadius
                                                                  .circular(getSize(
                                                                      20,
                                                                      "height",
                                                                      context)),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Color(
                                                                          0xFF000000)
                                                                      .withOpacity(
                                                                          0.11),
                                                                  spreadRadius:
                                                                      5,
                                                                  blurRadius:
                                                                      10,
                                                                  offset: Offset(
                                                                      0,
                                                                      5), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical: getSize(
                                                                      33,
                                                                      "height",
                                                                      context),
                                                                  horizontal: getSize(
                                                                      28,
                                                                      "width",
                                                                      context)),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    width: getSize(
                                                                        100,
                                                                        "height",
                                                                        context),
                                                                    height: getSize(
                                                                        100,
                                                                        "height",
                                                                        context),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical: getSize(
                                                                            0,
                                                                            "height",
                                                                            context),
                                                                        horizontal: getSize(
                                                                            0,
                                                                            "width",
                                                                            context)),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      color: AppColors
                                                                          .greenColor
                                                                          .withOpacity(
                                                                              0.35),
                                                                    ),
                                                                    child:
                                                                        Stack(
                                                                      overflow:
                                                                          Overflow
                                                                              .visible,
                                                                      children: <
                                                                          Widget>[
                                                                        Positioned(
                                                                          child: Center(
                                                                              child: Image.asset(
                                                                            'assets/images/Map pin-3.png',
                                                                            height: getSize(
                                                                                45.6,
                                                                                "height",
                                                                                context),
                                                                            width: getSize(
                                                                                37.77,
                                                                                "width",
                                                                                context),
                                                                          )),
                                                                        ),
                                                                        Positioned(
                                                                          left: getSize(
                                                                              60,
                                                                              "width",
                                                                              context),
                                                                          top: getSize(
                                                                              61,
                                                                              "height",
                                                                              context),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(vertical: getSize(9, "width", context), horizontal: getSize(9, "height", context)),
                                                                            child:
                                                                                SizedBox(
                                                                              width: getSize(31, "height", context),
                                                                              height: getSize(31, "height", context),
                                                                              child: Card(
                                                                                elevation: 2.5,
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100))),
                                                                                child: Center(
                                                                                  child: Icon(
                                                                                    Icons.check,
                                                                                    size: getSize(9, "height", context),
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
                                                                    height: getSize(
                                                                        21,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Text(
                                                                    "Alerte envoyé",
                                                                    style: AppTheme
                                                                        .defaultParagraph,
                                                                  ),
                                                                  SizedBox(
                                                                    height: getSize(
                                                                        12,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Container(
                                                                    width: getSize(
                                                                        220,
                                                                        "width",
                                                                        context),
                                                                    child: Text(
                                                                      "Votre alerte a été signalé à tous les utilisateurs de Mapane",
                                                                      style: AppTheme
                                                                          .bodyText1
                                                                          .copyWith(
                                                                        color: AppColors
                                                                            .blackColor
                                                                            .withOpacity(0.5),
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                          }).catchError((onError) {
                                            showGeneralDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                barrierLabel:
                                                    MaterialLocalizations.of(
                                                            context)
                                                        .modalBarrierDismissLabel,
                                                barrierColor: AppColors
                                                    .whiteColor
                                                    .withOpacity(0.96),
                                                transitionDuration:
                                                    const Duration(
                                                        milliseconds: 200),
                                                pageBuilder: (BuildContext
                                                        buildContext,
                                                    Animation animation,
                                                    Animation
                                                        secondaryAnimation) {
                                                  return Center(
                                                    child: Card(
                                                      shadowColor:
                                                          Colors.transparent,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 0,
                                                              vertical: 0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            width: getSize(
                                                                303,
                                                                "width",
                                                                context),
                                                            // height: getSize(256, "height", context),
                                                            // padding: EdgeInsets.all(getSize(0,"height",context)),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .whiteColor,
                                                              borderRadius: BorderRadius
                                                                  .circular(getSize(
                                                                      20,
                                                                      "height",
                                                                      context)),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Color(
                                                                          0xFF000000)
                                                                      .withOpacity(
                                                                          0.11),
                                                                  spreadRadius:
                                                                      5,
                                                                  blurRadius:
                                                                      10,
                                                                  offset: Offset(
                                                                      0,
                                                                      5), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical: getSize(
                                                                      33,
                                                                      "height",
                                                                      context),
                                                                  horizontal: getSize(
                                                                      28,
                                                                      "width",
                                                                      context)),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    width: getSize(
                                                                        100,
                                                                        "height",
                                                                        context),
                                                                    height: getSize(
                                                                        100,
                                                                        "height",
                                                                        context),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical: getSize(
                                                                            36,
                                                                            "height",
                                                                            context),
                                                                        horizontal: getSize(
                                                                            30,
                                                                            "width",
                                                                            context)),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      color: Colors
                                                                          .red
                                                                          .withOpacity(
                                                                              0.35),
                                                                    ),
                                                                    child: Center(
                                                                        child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: getSize(
                                                                          38,
                                                                          "height",
                                                                          context),
                                                                      color: Colors
                                                                          .white,
                                                                    )),
                                                                  ),
                                                                  SizedBox(
                                                                    height: getSize(
                                                                        21,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Text(
                                                                    "Erreur",
                                                                    style: AppTheme
                                                                        .defaultParagraph,
                                                                  ),
                                                                  SizedBox(
                                                                    height: getSize(
                                                                        12,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Container(
                                                                    width: getSize(
                                                                        220,
                                                                        "width",
                                                                        context),
                                                                    child: Text(
                                                                      onError.response == null ||
                                                                              onError.response ==
                                                                                  ""
                                                                          ? 'Une erreur est survenue, verifier votre connexion.'
                                                                          : onError
                                                                              .response
                                                                              .data["message"],
                                                                      style: AppTheme
                                                                          .bodyText1
                                                                          .copyWith(
                                                                        color: AppColors
                                                                            .blackColor
                                                                            .withOpacity(0.5),
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                      ),
                                      Alert(
                                        title: "Zône dangereuse",
                                        color: HexColor("#FD4B89")
                                            .withOpacity(0.25),
                                        picture: SvgPicture.asset(
                                          Assets.dangerIcon,
                                        ),
                                        radius: 30.0,
                                        onTap: () {
                                          alertService
                                              .createAlert(
                                            LatLng(currentLocation.latitude,
                                                currentLocation.longitude),
                                            "test",
                                            userId,
                                            "zone-dangereuse-1",
                                            addresse,
                                          )
                                              .then((value) {
                                            showGeneralDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                barrierLabel:
                                                    MaterialLocalizations.of(
                                                            context)
                                                        .modalBarrierDismissLabel,
                                                barrierColor: AppColors
                                                    .whiteColor
                                                    .withOpacity(0.96),
                                                transitionDuration:
                                                    const Duration(
                                                        milliseconds: 200),
                                                pageBuilder: (BuildContext
                                                        buildContext,
                                                    Animation animation,
                                                    Animation
                                                        secondaryAnimation) {
                                                  return Center(
                                                    child: Card(
                                                      shadowColor:
                                                          Colors.transparent,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 0,
                                                              vertical: 0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            width: getSize(
                                                                303,
                                                                "width",
                                                                context),
                                                            // height: getSize(256, "height", context),
                                                            // padding: EdgeInsets.all(getSize(0,"height",context)),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .whiteColor,
                                                              borderRadius: BorderRadius
                                                                  .circular(getSize(
                                                                      20,
                                                                      "height",
                                                                      context)),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Color(
                                                                          0xFF000000)
                                                                      .withOpacity(
                                                                          0.11),
                                                                  spreadRadius:
                                                                      5,
                                                                  blurRadius:
                                                                      10,
                                                                  offset: Offset(
                                                                      0,
                                                                      5), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical: getSize(
                                                                      33,
                                                                      "height",
                                                                      context),
                                                                  horizontal: getSize(
                                                                      28,
                                                                      "width",
                                                                      context)),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    width: getSize(
                                                                        100,
                                                                        "height",
                                                                        context),
                                                                    height: getSize(
                                                                        100,
                                                                        "height",
                                                                        context),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical: getSize(
                                                                            0,
                                                                            "height",
                                                                            context),
                                                                        horizontal: getSize(
                                                                            0,
                                                                            "width",
                                                                            context)),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      color: AppColors
                                                                          .greenColor
                                                                          .withOpacity(
                                                                              0.35),
                                                                    ),
                                                                    child:
                                                                        Stack(
                                                                      overflow:
                                                                          Overflow
                                                                              .visible,
                                                                      children: <
                                                                          Widget>[
                                                                        Positioned(
                                                                          child: Center(
                                                                              child: Image.asset(
                                                                            'assets/images/Map pin-3.png',
                                                                            height: getSize(
                                                                                45.6,
                                                                                "height",
                                                                                context),
                                                                            width: getSize(
                                                                                37.77,
                                                                                "width",
                                                                                context),
                                                                          )),
                                                                        ),
                                                                        Positioned(
                                                                          left: getSize(
                                                                              60,
                                                                              "width",
                                                                              context),
                                                                          top: getSize(
                                                                              61,
                                                                              "height",
                                                                              context),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(vertical: getSize(9, "width", context), horizontal: getSize(9, "height", context)),
                                                                            child:
                                                                                SizedBox(
                                                                              width: getSize(31, "height", context),
                                                                              height: getSize(31, "height", context),
                                                                              child: Card(
                                                                                elevation: 2.5,
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100))),
                                                                                child: Center(
                                                                                  child: Icon(
                                                                                    Icons.check,
                                                                                    size: getSize(9, "height", context),
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
                                                                    height: getSize(
                                                                        21,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Text(
                                                                    "Alerte envoyé",
                                                                    style: AppTheme
                                                                        .defaultParagraph,
                                                                  ),
                                                                  SizedBox(
                                                                    height: getSize(
                                                                        12,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Container(
                                                                    width: getSize(
                                                                        220,
                                                                        "width",
                                                                        context),
                                                                    child: Text(
                                                                      "Votre alerte a été signalé à tous les utilisateurs de Mapane",
                                                                      style: AppTheme
                                                                          .bodyText1
                                                                          .copyWith(
                                                                        color: AppColors
                                                                            .blackColor
                                                                            .withOpacity(0.5),
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                          }).catchError((onError) {
                                            showGeneralDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                barrierLabel:
                                                    MaterialLocalizations.of(
                                                            context)
                                                        .modalBarrierDismissLabel,
                                                barrierColor: AppColors
                                                    .whiteColor
                                                    .withOpacity(0.96),
                                                transitionDuration:
                                                    const Duration(
                                                        milliseconds: 200),
                                                pageBuilder: (BuildContext
                                                        buildContext,
                                                    Animation animation,
                                                    Animation
                                                        secondaryAnimation) {
                                                  return Center(
                                                    child: Card(
                                                      shadowColor:
                                                          Colors.transparent,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 0,
                                                              vertical: 0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            width: getSize(
                                                                303,
                                                                "width",
                                                                context),
                                                            // height: getSize(256, "height", context),
                                                            // padding: EdgeInsets.all(getSize(0,"height",context)),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .whiteColor,
                                                              borderRadius: BorderRadius
                                                                  .circular(getSize(
                                                                      20,
                                                                      "height",
                                                                      context)),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Color(
                                                                          0xFF000000)
                                                                      .withOpacity(
                                                                          0.11),
                                                                  spreadRadius:
                                                                      5,
                                                                  blurRadius:
                                                                      10,
                                                                  offset: Offset(
                                                                      0,
                                                                      5), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical: getSize(
                                                                      33,
                                                                      "height",
                                                                      context),
                                                                  horizontal: getSize(
                                                                      28,
                                                                      "width",
                                                                      context)),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    width: getSize(
                                                                        100,
                                                                        "height",
                                                                        context),
                                                                    height: getSize(
                                                                        100,
                                                                        "height",
                                                                        context),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical: getSize(
                                                                            36,
                                                                            "height",
                                                                            context),
                                                                        horizontal: getSize(
                                                                            30,
                                                                            "width",
                                                                            context)),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      color: Colors
                                                                          .red
                                                                          .withOpacity(
                                                                              0.35),
                                                                    ),
                                                                    child: Center(
                                                                        child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: getSize(
                                                                          38,
                                                                          "height",
                                                                          context),
                                                                      color: Colors
                                                                          .white,
                                                                    )),
                                                                  ),
                                                                  SizedBox(
                                                                    height: getSize(
                                                                        21,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Text(
                                                                    "Erreur",
                                                                    style: AppTheme
                                                                        .defaultParagraph,
                                                                  ),
                                                                  SizedBox(
                                                                    height: getSize(
                                                                        12,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Container(
                                                                    width: getSize(
                                                                        220,
                                                                        "width",
                                                                        context),
                                                                    child: Text(
                                                                      onError.response == null ||
                                                                              onError.response ==
                                                                                  ""
                                                                          ? 'Une erreur est survenue, verifier votre connexion.'
                                                                          : onError
                                                                              .response
                                                                              .data["message"],
                                                                      style: AppTheme
                                                                          .bodyText1
                                                                          .copyWith(
                                                                        color: AppColors
                                                                            .blackColor
                                                                            .withOpacity(0.5),
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom:
                                                SizeConfig.blockSizeVertical *
                                                    2),
                                        child: Alert(
                                          title: "Radar",
                                          color: HexColor("#4BB38F")
                                              .withOpacity(0.25),
                                          picture: SvgPicture.asset(
                                            Assets.radarIcon,
                                          ),
                                          radius: 30.0,
                                          onTap: () {
                                            alertService
                                                .createAlert(
                                              LatLng(currentLocation.latitude,
                                                  currentLocation.longitude),
                                              "test",
                                              userId,
                                              "Radar1",
                                              addresse,
                                            )
                                                .then((value) {
                                              showGeneralDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  barrierLabel:
                                                      MaterialLocalizations.of(
                                                              context)
                                                          .modalBarrierDismissLabel,
                                                  barrierColor: AppColors
                                                      .whiteColor
                                                      .withOpacity(0.96),
                                                  transitionDuration:
                                                      const Duration(
                                                          milliseconds: 200),
                                                  pageBuilder: (BuildContext
                                                          buildContext,
                                                      Animation animation,
                                                      Animation
                                                          secondaryAnimation) {
                                                    return Center(
                                                      child: Card(
                                                        shadowColor:
                                                            Colors.transparent,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 0,
                                                                vertical: 0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              width: getSize(
                                                                  303,
                                                                  "width",
                                                                  context),
                                                              // height: getSize(256, "height", context),
                                                              // padding: EdgeInsets.all(getSize(0,"height",context)),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .whiteColor,
                                                                borderRadius: BorderRadius
                                                                    .circular(getSize(
                                                                        20,
                                                                        "height",
                                                                        context)),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Color(
                                                                            0xFF000000)
                                                                        .withOpacity(
                                                                            0.11),
                                                                    spreadRadius:
                                                                        5,
                                                                    blurRadius:
                                                                        10,
                                                                    offset: Offset(
                                                                        0,
                                                                        5), // changes position of shadow
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Container(
                                                                padding: EdgeInsets.symmetric(
                                                                    vertical: getSize(
                                                                        33,
                                                                        "height",
                                                                        context),
                                                                    horizontal: getSize(
                                                                        28,
                                                                        "width",
                                                                        context)),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      width: getSize(
                                                                          100,
                                                                          "height",
                                                                          context),
                                                                      height: getSize(
                                                                          100,
                                                                          "height",
                                                                          context),
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical: getSize(
                                                                              0,
                                                                              "height",
                                                                              context),
                                                                          horizontal: getSize(
                                                                              0,
                                                                              "width",
                                                                              context)),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(100),
                                                                        color: AppColors
                                                                            .greenColor
                                                                            .withOpacity(0.35),
                                                                      ),
                                                                      child:
                                                                          Stack(
                                                                        overflow:
                                                                            Overflow.visible,
                                                                        children: <
                                                                            Widget>[
                                                                          Positioned(
                                                                            child: Center(
                                                                                child: Image.asset(
                                                                              'assets/images/Map pin-3.png',
                                                                              height: getSize(45.6, "height", context),
                                                                              width: getSize(37.77, "width", context),
                                                                            )),
                                                                          ),
                                                                          Positioned(
                                                                            left: getSize(
                                                                                60,
                                                                                "width",
                                                                                context),
                                                                            top: getSize(
                                                                                61,
                                                                                "height",
                                                                                context),
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.symmetric(vertical: getSize(9, "width", context), horizontal: getSize(9, "height", context)),
                                                                              child: SizedBox(
                                                                                width: getSize(31, "height", context),
                                                                                height: getSize(31, "height", context),
                                                                                child: Card(
                                                                                  elevation: 2.5,
                                                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100))),
                                                                                  child: Center(
                                                                                    child: Icon(
                                                                                      Icons.check,
                                                                                      size: getSize(9, "height", context),
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
                                                                      height: getSize(
                                                                          21,
                                                                          "height",
                                                                          context),
                                                                    ),
                                                                    Text(
                                                                      "Alerte envoyé",
                                                                      style: AppTheme
                                                                          .defaultParagraph,
                                                                    ),
                                                                    SizedBox(
                                                                      height: getSize(
                                                                          12,
                                                                          "height",
                                                                          context),
                                                                    ),
                                                                    Container(
                                                                      width: getSize(
                                                                          220,
                                                                          "width",
                                                                          context),
                                                                      child:
                                                                          Text(
                                                                        "Votre alerte a été signalé à tous les utilisateurs de Mapane",
                                                                        style: AppTheme
                                                                            .bodyText1
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
                                            }).catchError((onError) {
                                              showGeneralDialog(
                                                  context: context,
                                                  barrierDismissible: true,
                                                  barrierLabel:
                                                      MaterialLocalizations.of(
                                                              context)
                                                          .modalBarrierDismissLabel,
                                                  barrierColor: AppColors
                                                      .whiteColor
                                                      .withOpacity(0.96),
                                                  transitionDuration:
                                                      const Duration(
                                                          milliseconds: 200),
                                                  pageBuilder: (BuildContext
                                                          buildContext,
                                                      Animation animation,
                                                      Animation
                                                          secondaryAnimation) {
                                                    return Center(
                                                      child: Card(
                                                        shadowColor:
                                                            Colors.transparent,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 0,
                                                                vertical: 0),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Container(
                                                              width: getSize(
                                                                  303,
                                                                  "width",
                                                                  context),
                                                              // height: getSize(256, "height", context),
                                                              // padding: EdgeInsets.all(getSize(0,"height",context)),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: AppColors
                                                                    .whiteColor,
                                                                borderRadius: BorderRadius
                                                                    .circular(getSize(
                                                                        20,
                                                                        "height",
                                                                        context)),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Color(
                                                                            0xFF000000)
                                                                        .withOpacity(
                                                                            0.11),
                                                                    spreadRadius:
                                                                        5,
                                                                    blurRadius:
                                                                        10,
                                                                    offset: Offset(
                                                                        0,
                                                                        5), // changes position of shadow
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Container(
                                                                padding: EdgeInsets.symmetric(
                                                                    vertical: getSize(
                                                                        33,
                                                                        "height",
                                                                        context),
                                                                    horizontal: getSize(
                                                                        28,
                                                                        "width",
                                                                        context)),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      width: getSize(
                                                                          100,
                                                                          "height",
                                                                          context),
                                                                      height: getSize(
                                                                          100,
                                                                          "height",
                                                                          context),
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical: getSize(
                                                                              36,
                                                                              "height",
                                                                              context),
                                                                          horizontal: getSize(
                                                                              30,
                                                                              "width",
                                                                              context)),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(100),
                                                                        color: Colors
                                                                            .red
                                                                            .withOpacity(0.35),
                                                                      ),
                                                                      child: Center(
                                                                          child: Icon(
                                                                        Icons
                                                                            .close,
                                                                        size: getSize(
                                                                            38,
                                                                            "height",
                                                                            context),
                                                                        color: Colors
                                                                            .white,
                                                                      )),
                                                                    ),
                                                                    SizedBox(
                                                                      height: getSize(
                                                                          21,
                                                                          "height",
                                                                          context),
                                                                    ),
                                                                    Text(
                                                                      "Erreur",
                                                                      style: AppTheme
                                                                          .defaultParagraph,
                                                                    ),
                                                                    SizedBox(
                                                                      height: getSize(
                                                                          12,
                                                                          "height",
                                                                          context),
                                                                    ),
                                                                    Container(
                                                                      width: getSize(
                                                                          220,
                                                                          "width",
                                                                          context),
                                                                      child:
                                                                          Text(
                                                                        onError.response == null ||
                                                                                onError.response == ""
                                                                            ? 'Une erreur est survenue, verifier votre connexion.'
                                                                            : onError.response.data["message"],
                                                                        style: AppTheme
                                                                            .bodyText1
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
                                        ),
                                      ),
                                      Alert(
                                        title: "Accident de circulation",
                                        color: HexColor("#2C2BFB")
                                            .withOpacity(0.25),
                                        picture: SvgPicture.asset(
                                          Assets.accidentIcon,
                                        ),
                                        radius: 30.0,
                                        onTap: () {
                                          alertService
                                              .createAlert(
                                            LatLng(currentLocation.latitude,
                                                currentLocation.longitude),
                                            "test",
                                            userId,
                                            "Accident-de-circulation-1",
                                            addresse,
                                          )
                                              .then((value) {
                                            showGeneralDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                barrierLabel:
                                                    MaterialLocalizations.of(
                                                            context)
                                                        .modalBarrierDismissLabel,
                                                barrierColor: AppColors
                                                    .whiteColor
                                                    .withOpacity(0.96),
                                                transitionDuration:
                                                    const Duration(
                                                        milliseconds: 200),
                                                pageBuilder: (BuildContext
                                                        buildContext,
                                                    Animation animation,
                                                    Animation
                                                        secondaryAnimation) {
                                                  return Center(
                                                    child: Card(
                                                      shadowColor:
                                                          Colors.transparent,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 0,
                                                              vertical: 0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            width: getSize(
                                                                303,
                                                                "width",
                                                                context),
                                                            // height: getSize(256, "height", context),
                                                            // padding: EdgeInsets.all(getSize(0,"height",context)),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .whiteColor,
                                                              borderRadius: BorderRadius
                                                                  .circular(getSize(
                                                                      20,
                                                                      "height",
                                                                      context)),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Color(
                                                                          0xFF000000)
                                                                      .withOpacity(
                                                                          0.11),
                                                                  spreadRadius:
                                                                      5,
                                                                  blurRadius:
                                                                      10,
                                                                  offset: Offset(
                                                                      0,
                                                                      5), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical: getSize(
                                                                      33,
                                                                      "height",
                                                                      context),
                                                                  horizontal: getSize(
                                                                      28,
                                                                      "width",
                                                                      context)),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    width: getSize(
                                                                        100,
                                                                        "height",
                                                                        context),
                                                                    height: getSize(
                                                                        100,
                                                                        "height",
                                                                        context),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical: getSize(
                                                                            0,
                                                                            "height",
                                                                            context),
                                                                        horizontal: getSize(
                                                                            0,
                                                                            "width",
                                                                            context)),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      color: AppColors
                                                                          .greenColor
                                                                          .withOpacity(
                                                                              0.35),
                                                                    ),
                                                                    child:
                                                                        Stack(
                                                                      overflow:
                                                                          Overflow
                                                                              .visible,
                                                                      children: <
                                                                          Widget>[
                                                                        Positioned(
                                                                          child: Center(
                                                                              child: Image.asset(
                                                                            'assets/images/Map pin-3.png',
                                                                            height: getSize(
                                                                                45.6,
                                                                                "height",
                                                                                context),
                                                                            width: getSize(
                                                                                37.77,
                                                                                "width",
                                                                                context),
                                                                          )),
                                                                        ),
                                                                        Positioned(
                                                                          left: getSize(
                                                                              60,
                                                                              "width",
                                                                              context),
                                                                          top: getSize(
                                                                              61,
                                                                              "height",
                                                                              context),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(vertical: getSize(9, "width", context), horizontal: getSize(9, "height", context)),
                                                                            child:
                                                                                SizedBox(
                                                                              width: getSize(31, "height", context),
                                                                              height: getSize(31, "height", context),
                                                                              child: Card(
                                                                                elevation: 2.5,
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100))),
                                                                                child: Center(
                                                                                  child: Icon(
                                                                                    Icons.check,
                                                                                    size: getSize(9, "height", context),
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
                                                                    height: getSize(
                                                                        21,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Text(
                                                                    "Alerte envoyé",
                                                                    style: AppTheme
                                                                        .defaultParagraph,
                                                                  ),
                                                                  SizedBox(
                                                                    height: getSize(
                                                                        12,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Container(
                                                                    width: getSize(
                                                                        220,
                                                                        "width",
                                                                        context),
                                                                    child: Text(
                                                                      "Votre alerte a été signalé à tous les utilisateurs de Mapane",
                                                                      style: AppTheme
                                                                          .bodyText1
                                                                          .copyWith(
                                                                        color: AppColors
                                                                            .blackColor
                                                                            .withOpacity(0.5),
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                          }).catchError((onError) {
                                            showGeneralDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                barrierLabel:
                                                    MaterialLocalizations.of(
                                                            context)
                                                        .modalBarrierDismissLabel,
                                                barrierColor: AppColors
                                                    .whiteColor
                                                    .withOpacity(0.96),
                                                transitionDuration:
                                                    const Duration(
                                                        milliseconds: 200),
                                                pageBuilder: (BuildContext
                                                        buildContext,
                                                    Animation animation,
                                                    Animation
                                                        secondaryAnimation) {
                                                  return Center(
                                                    child: Card(
                                                      shadowColor:
                                                          Colors.transparent,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 0,
                                                              vertical: 0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            width: getSize(
                                                                303,
                                                                "width",
                                                                context),
                                                            // height: getSize(256, "height", context),
                                                            // padding: EdgeInsets.all(getSize(0,"height",context)),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .whiteColor,
                                                              borderRadius: BorderRadius
                                                                  .circular(getSize(
                                                                      20,
                                                                      "height",
                                                                      context)),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Color(
                                                                          0xFF000000)
                                                                      .withOpacity(
                                                                          0.11),
                                                                  spreadRadius:
                                                                      5,
                                                                  blurRadius:
                                                                      10,
                                                                  offset: Offset(
                                                                      0,
                                                                      5), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical: getSize(
                                                                      33,
                                                                      "height",
                                                                      context),
                                                                  horizontal: getSize(
                                                                      28,
                                                                      "width",
                                                                      context)),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    width: getSize(
                                                                        100,
                                                                        "height",
                                                                        context),
                                                                    height: getSize(
                                                                        100,
                                                                        "height",
                                                                        context),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical: getSize(
                                                                            36,
                                                                            "height",
                                                                            context),
                                                                        horizontal: getSize(
                                                                            30,
                                                                            "width",
                                                                            context)),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      color: Colors
                                                                          .red
                                                                          .withOpacity(
                                                                              0.35),
                                                                    ),
                                                                    child: Center(
                                                                        child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: getSize(
                                                                          38,
                                                                          "height",
                                                                          context),
                                                                      color: Colors
                                                                          .white,
                                                                    )),
                                                                  ),
                                                                  SizedBox(
                                                                    height: getSize(
                                                                        21,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Text(
                                                                    "Erreur",
                                                                    style: AppTheme
                                                                        .defaultParagraph,
                                                                  ),
                                                                  SizedBox(
                                                                    height: getSize(
                                                                        12,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Container(
                                                                    width: getSize(
                                                                        220,
                                                                        "width",
                                                                        context),
                                                                    child: Text(
                                                                      onError.response == null ||
                                                                              onError.response ==
                                                                                  ""
                                                                          ? 'Une erreur est survenue, verifier votre connexion.'
                                                                          : onError
                                                                              .response
                                                                              .data["message"],
                                                                      style: AppTheme
                                                                          .bodyText1
                                                                          .copyWith(
                                                                        color: AppColors
                                                                            .blackColor
                                                                            .withOpacity(0.5),
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                      ),
                                      Alert(
                                        title: "Route en barrée",
                                        color: HexColor("#2EDACD")
                                            .withOpacity(0.25),
                                        picture: SvgPicture.asset(
                                          Assets.roadblockIcon,
                                        ),
                                        radius: 30.0,
                                        onTap: () {
                                          alertService
                                              .createAlert(
                                            LatLng(currentLocation.latitude,
                                                currentLocation.longitude),
                                            "test",
                                            userId,
                                            "travaux2",
                                            addresse,
                                          )
                                              .then((value) {
                                            showGeneralDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                barrierLabel:
                                                    MaterialLocalizations.of(
                                                            context)
                                                        .modalBarrierDismissLabel,
                                                barrierColor: AppColors
                                                    .whiteColor
                                                    .withOpacity(0.96),
                                                transitionDuration:
                                                    const Duration(
                                                        milliseconds: 200),
                                                pageBuilder: (BuildContext
                                                        buildContext,
                                                    Animation animation,
                                                    Animation
                                                        secondaryAnimation) {
                                                  return Center(
                                                    child: Card(
                                                      shadowColor:
                                                          Colors.transparent,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 0,
                                                              vertical: 0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            width: getSize(
                                                                303,
                                                                "width",
                                                                context),
                                                            // height: getSize(256, "height", context),
                                                            // padding: EdgeInsets.all(getSize(0,"height",context)),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .whiteColor,
                                                              borderRadius: BorderRadius
                                                                  .circular(getSize(
                                                                      20,
                                                                      "height",
                                                                      context)),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Color(
                                                                          0xFF000000)
                                                                      .withOpacity(
                                                                          0.11),
                                                                  spreadRadius:
                                                                      5,
                                                                  blurRadius:
                                                                      10,
                                                                  offset: Offset(
                                                                      0,
                                                                      5), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical: getSize(
                                                                      33,
                                                                      "height",
                                                                      context),
                                                                  horizontal: getSize(
                                                                      28,
                                                                      "width",
                                                                      context)),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    width: getSize(
                                                                        100,
                                                                        "height",
                                                                        context),
                                                                    height: getSize(
                                                                        100,
                                                                        "height",
                                                                        context),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical: getSize(
                                                                            0,
                                                                            "height",
                                                                            context),
                                                                        horizontal: getSize(
                                                                            0,
                                                                            "width",
                                                                            context)),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      color: AppColors
                                                                          .greenColor
                                                                          .withOpacity(
                                                                              0.35),
                                                                    ),
                                                                    child:
                                                                        Stack(
                                                                      overflow:
                                                                          Overflow
                                                                              .visible,
                                                                      children: <
                                                                          Widget>[
                                                                        Positioned(
                                                                          child: Center(
                                                                              child: Image.asset(
                                                                            'assets/images/Map pin-3.png',
                                                                            height: getSize(
                                                                                45.6,
                                                                                "height",
                                                                                context),
                                                                            width: getSize(
                                                                                37.77,
                                                                                "width",
                                                                                context),
                                                                          )),
                                                                        ),
                                                                        Positioned(
                                                                          left: getSize(
                                                                              60,
                                                                              "width",
                                                                              context),
                                                                          top: getSize(
                                                                              61,
                                                                              "height",
                                                                              context),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(vertical: getSize(9, "width", context), horizontal: getSize(9, "height", context)),
                                                                            child:
                                                                                SizedBox(
                                                                              width: getSize(31, "height", context),
                                                                              height: getSize(31, "height", context),
                                                                              child: Card(
                                                                                elevation: 2.5,
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100))),
                                                                                child: Center(
                                                                                  child: Icon(
                                                                                    Icons.check,
                                                                                    size: getSize(9, "height", context),
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
                                                                    height: getSize(
                                                                        21,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Text(
                                                                    "Alerte envoyé",
                                                                    style: AppTheme
                                                                        .defaultParagraph,
                                                                  ),
                                                                  SizedBox(
                                                                    height: getSize(
                                                                        12,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Container(
                                                                    width: getSize(
                                                                        220,
                                                                        "width",
                                                                        context),
                                                                    child: Text(
                                                                      "Votre alerte a été signalé à tous les utilisateurs de Mapane",
                                                                      style: AppTheme
                                                                          .bodyText1
                                                                          .copyWith(
                                                                        color: AppColors
                                                                            .blackColor
                                                                            .withOpacity(0.5),
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                          }).catchError((onError) {
                                            showGeneralDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                barrierLabel:
                                                    MaterialLocalizations.of(
                                                            context)
                                                        .modalBarrierDismissLabel,
                                                barrierColor: AppColors
                                                    .whiteColor
                                                    .withOpacity(0.96),
                                                transitionDuration:
                                                    const Duration(
                                                        milliseconds: 200),
                                                pageBuilder: (BuildContext
                                                        buildContext,
                                                    Animation animation,
                                                    Animation
                                                        secondaryAnimation) {
                                                  return Center(
                                                    child: Card(
                                                      shadowColor:
                                                          Colors.transparent,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 0,
                                                              vertical: 0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            width: getSize(
                                                                303,
                                                                "width",
                                                                context),
                                                            // height: getSize(256, "height", context),
                                                            // padding: EdgeInsets.all(getSize(0,"height",context)),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .whiteColor,
                                                              borderRadius: BorderRadius
                                                                  .circular(getSize(
                                                                      20,
                                                                      "height",
                                                                      context)),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Color(
                                                                          0xFF000000)
                                                                      .withOpacity(
                                                                          0.11),
                                                                  spreadRadius:
                                                                      5,
                                                                  blurRadius:
                                                                      10,
                                                                  offset: Offset(
                                                                      0,
                                                                      5), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical: getSize(
                                                                      33,
                                                                      "height",
                                                                      context),
                                                                  horizontal: getSize(
                                                                      28,
                                                                      "width",
                                                                      context)),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    width: getSize(
                                                                        100,
                                                                        "height",
                                                                        context),
                                                                    height: getSize(
                                                                        100,
                                                                        "height",
                                                                        context),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical: getSize(
                                                                            36,
                                                                            "height",
                                                                            context),
                                                                        horizontal: getSize(
                                                                            30,
                                                                            "width",
                                                                            context)),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      color: Colors
                                                                          .red
                                                                          .withOpacity(
                                                                              0.35),
                                                                    ),
                                                                    child: Center(
                                                                        child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: getSize(
                                                                          38,
                                                                          "height",
                                                                          context),
                                                                      color: Colors
                                                                          .white,
                                                                    )),
                                                                  ),
                                                                  SizedBox(
                                                                    height: getSize(
                                                                        21,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Text(
                                                                    "Erreur",
                                                                    style: AppTheme
                                                                        .defaultParagraph,
                                                                  ),
                                                                  SizedBox(
                                                                    height: getSize(
                                                                        12,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Container(
                                                                    width: getSize(
                                                                        220,
                                                                        "width",
                                                                        context),
                                                                    child: Text(
                                                                      onError.response == null ||
                                                                              onError.response ==
                                                                                  ""
                                                                          ? 'Une erreur est survenue, verifier votre connexion.'
                                                                          : onError
                                                                              .response
                                                                              .data["message"],
                                                                      style: AppTheme
                                                                          .bodyText1
                                                                          .copyWith(
                                                                        color: AppColors
                                                                            .blackColor
                                                                            .withOpacity(0.5),
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                      ),
                                      Alert(
                                        title: "Route en chantier",
                                        color: HexColor("#CBAB81")
                                            .withOpacity(0.25),
                                        picture: SvgPicture.asset(
                                          Assets.highwayIcon,
                                        ),
                                        radius: 30.0,
                                        onTap: () {
                                          alertService
                                              .createAlert(
                                            LatLng(currentLocation.latitude,
                                                currentLocation.longitude),
                                            "test",
                                            userId,
                                            "Route-en-chantier-2",
                                            addresse,
                                          )
                                              .then((value) {
                                            showGeneralDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                barrierLabel:
                                                    MaterialLocalizations.of(
                                                            context)
                                                        .modalBarrierDismissLabel,
                                                barrierColor: AppColors
                                                    .whiteColor
                                                    .withOpacity(0.96),
                                                transitionDuration:
                                                    const Duration(
                                                        milliseconds: 200),
                                                pageBuilder: (BuildContext
                                                        buildContext,
                                                    Animation animation,
                                                    Animation
                                                        secondaryAnimation) {
                                                  return Center(
                                                    child: Card(
                                                      shadowColor:
                                                          Colors.transparent,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 0,
                                                              vertical: 0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            width: getSize(
                                                                303,
                                                                "width",
                                                                context),
                                                            // height: getSize(256, "height", context),
                                                            // padding: EdgeInsets.all(getSize(0,"height",context)),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .whiteColor,
                                                              borderRadius: BorderRadius
                                                                  .circular(getSize(
                                                                      20,
                                                                      "height",
                                                                      context)),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Color(
                                                                          0xFF000000)
                                                                      .withOpacity(
                                                                          0.11),
                                                                  spreadRadius:
                                                                      5,
                                                                  blurRadius:
                                                                      10,
                                                                  offset: Offset(
                                                                      0,
                                                                      5), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical: getSize(
                                                                      33,
                                                                      "height",
                                                                      context),
                                                                  horizontal: getSize(
                                                                      28,
                                                                      "width",
                                                                      context)),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    width: getSize(
                                                                        100,
                                                                        "height",
                                                                        context),
                                                                    height: getSize(
                                                                        100,
                                                                        "height",
                                                                        context),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical: getSize(
                                                                            0,
                                                                            "height",
                                                                            context),
                                                                        horizontal: getSize(
                                                                            0,
                                                                            "width",
                                                                            context)),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      color: AppColors
                                                                          .greenColor
                                                                          .withOpacity(
                                                                              0.35),
                                                                    ),
                                                                    child:
                                                                        Stack(
                                                                      overflow:
                                                                          Overflow
                                                                              .visible,
                                                                      children: <
                                                                          Widget>[
                                                                        Positioned(
                                                                          child: Center(
                                                                              child: Image.asset(
                                                                            'assets/images/Map pin-3.png',
                                                                            height: getSize(
                                                                                45.6,
                                                                                "height",
                                                                                context),
                                                                            width: getSize(
                                                                                37.77,
                                                                                "width",
                                                                                context),
                                                                          )),
                                                                        ),
                                                                        Positioned(
                                                                          left: getSize(
                                                                              60,
                                                                              "width",
                                                                              context),
                                                                          top: getSize(
                                                                              61,
                                                                              "height",
                                                                              context),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(vertical: getSize(9, "width", context), horizontal: getSize(9, "height", context)),
                                                                            child:
                                                                                SizedBox(
                                                                              width: getSize(31, "height", context),
                                                                              height: getSize(31, "height", context),
                                                                              child: Card(
                                                                                elevation: 2.5,
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100))),
                                                                                child: Center(
                                                                                  child: Icon(
                                                                                    Icons.check,
                                                                                    size: getSize(9, "height", context),
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
                                                                    height: getSize(
                                                                        21,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Text(
                                                                    "Alerte envoyé",
                                                                    style: AppTheme
                                                                        .defaultParagraph,
                                                                  ),
                                                                  SizedBox(
                                                                    height: getSize(
                                                                        12,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Container(
                                                                    width: getSize(
                                                                        220,
                                                                        "width",
                                                                        context),
                                                                    child: Text(
                                                                      "Votre alerte a été signalé à tous les utilisateurs de Mapane",
                                                                      style: AppTheme
                                                                          .bodyText1
                                                                          .copyWith(
                                                                        color: AppColors
                                                                            .blackColor
                                                                            .withOpacity(0.5),
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                          }).catchError((onError) {
                                            showGeneralDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                barrierLabel:
                                                    MaterialLocalizations.of(
                                                            context)
                                                        .modalBarrierDismissLabel,
                                                barrierColor: AppColors
                                                    .whiteColor
                                                    .withOpacity(0.96),
                                                transitionDuration:
                                                    const Duration(
                                                        milliseconds: 200),
                                                pageBuilder: (BuildContext
                                                        buildContext,
                                                    Animation animation,
                                                    Animation
                                                        secondaryAnimation) {
                                                  return Center(
                                                    child: Card(
                                                      shadowColor:
                                                          Colors.transparent,
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 0,
                                                              vertical: 0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            width: getSize(
                                                                303,
                                                                "width",
                                                                context),
                                                            // height: getSize(256, "height", context),
                                                            // padding: EdgeInsets.all(getSize(0,"height",context)),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .whiteColor,
                                                              borderRadius: BorderRadius
                                                                  .circular(getSize(
                                                                      20,
                                                                      "height",
                                                                      context)),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Color(
                                                                          0xFF000000)
                                                                      .withOpacity(
                                                                          0.11),
                                                                  spreadRadius:
                                                                      5,
                                                                  blurRadius:
                                                                      10,
                                                                  offset: Offset(
                                                                      0,
                                                                      5), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: Container(
                                                              padding: EdgeInsets.symmetric(
                                                                  vertical: getSize(
                                                                      33,
                                                                      "height",
                                                                      context),
                                                                  horizontal: getSize(
                                                                      28,
                                                                      "width",
                                                                      context)),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    width: getSize(
                                                                        100,
                                                                        "height",
                                                                        context),
                                                                    height: getSize(
                                                                        100,
                                                                        "height",
                                                                        context),
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical: getSize(
                                                                            36,
                                                                            "height",
                                                                            context),
                                                                        horizontal: getSize(
                                                                            30,
                                                                            "width",
                                                                            context)),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100),
                                                                      color: Colors
                                                                          .red
                                                                          .withOpacity(
                                                                              0.35),
                                                                    ),
                                                                    child: Center(
                                                                        child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: getSize(
                                                                          38,
                                                                          "height",
                                                                          context),
                                                                      color: Colors
                                                                          .white,
                                                                    )),
                                                                  ),
                                                                  SizedBox(
                                                                    height: getSize(
                                                                        21,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Text(
                                                                    "Erreur",
                                                                    style: AppTheme
                                                                        .defaultParagraph,
                                                                  ),
                                                                  SizedBox(
                                                                    height: getSize(
                                                                        12,
                                                                        "height",
                                                                        context),
                                                                  ),
                                                                  Container(
                                                                    width: getSize(
                                                                        220,
                                                                        "width",
                                                                        context),
                                                                    child: Text(
                                                                      onError.response == null ||
                                                                              onError.response ==
                                                                                  ""
                                                                          ? 'Une erreur est survenue, verifier votre connexion.'
                                                                          : onError
                                                                              .response
                                                                              .data["message"],
                                                                      style: AppTheme
                                                                          .bodyText1
                                                                          .copyWith(
                                                                        color: AppColors
                                                                            .blackColor
                                                                            .withOpacity(0.5),
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
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
                                      ),
                                      Alert(
                                        title: "Publier ma position",
                                        color: HexColor("#000000")
                                            .withOpacity(0.25),
                                        picture: SvgPicture.asset(
                                          Assets.pathIcon,
                                        ),
                                        radius: 30.0,
                                      ),
                                    ],
                                  ),
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
