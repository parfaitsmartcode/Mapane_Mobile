import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mapane/constants/assets.dart';
import 'package:mapane/custom/widgets/alert.dart';
import 'package:mapane/custom/widgets/util_button.dart';
import 'package:mapane/state/LoadingState.dart';
import 'package:mapane/state/bottom_bar_provider.dart';
import 'package:mapane/state/search_provider.dart';
import 'package:mapane/utils/PermissionHelper.dart';
import 'package:mapane/utils/hexcolor.dart';
import 'package:mapane/utils/n_exception.dart';
import 'package:mapane/utils/size_config.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const LatLng SOURCE_LOCATION = LatLng(42.747932,-71.167889);
const LatLng DEST_LOCATION = LatLng(37.335685,-122.0605916);

class _HomePageState extends State<HomePage> {
  bool isExpanded = false;
  double alertHeight = 30.0;
  double bottomPadding = SizeConfig.blockSizeVertical;
  final _startPointController = TextEditingController();
  Widget swiperIcon = SvgPicture.asset(
        Assets.arrowUpIcon,
  );

  Set<Marker> _markers = Set<Marker>();
// for my drawn routes on the map
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;
  String googleAPIKey = "<YOUR_API_KEY>";
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


  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 16,
  );
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  initState() {
    PermissionHelper.checkPermission(Permission.location);
    super.initState();
    // create an instance of Location
    location = new Location();
    polylinePoints = PolylinePoints();

    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
    location.onLocationChanged.listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;
      updatePinOnMap();
    });
    // set custom marker pins
    setSourceAndDestinationIcons();
    // set the initial location
    setInitialLocation();
  }
  Future<void> _goTo() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        Assets.locationMarker);

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
    var pinPosition = LatLng(currentLocation.latitude,
        currentLocation.longitude);
    // get a LatLng out of the LocationData object
    var destPosition = LatLng(destinationLocation.latitude,
        destinationLocation.longitude);
    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon: sourceIcon
    ));
    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        icon: destinationIcon
    ));
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    setPolylines();
  }

  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(currentLocation.latitude, currentLocation.longitude),
        PointLatLng(destinationLocation.latitude,destinationLocation.longitude),
    );

    if(result.points.isNotEmpty){
      result.points.forEach((PointLatLng point){
        polylineCoordinates.add(
            LatLng(point.latitude,point.longitude)
        );
      });
      setState(() {
        _polylines.add(Polyline(
            width: 5, // set the width of the polylines
            polylineId: PolylineId("poly"),
            color: Color.fromARGB(255, 40, 122, 198),
            points: polylineCoordinates
        ));
      });
    }
  }

  void updatePinOnMap() async {

    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude,
          currentLocation.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition = LatLng(currentLocation.latitude,
          currentLocation.longitude);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere(
              (m) => m.markerId.value == "sourcePin");
      _markers.add(Marker(
          markerId: MarkerId("sourcePin"),
          position: pinPosition, // updated position
          icon: sourceIcon
      ));
    });
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION
    );
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude,
              currentLocation.longitude),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING
      );
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
                      Column(
                        children: [
                          Text(
                            "Avenue Kennedy",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 19.0),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: SizeConfig.blockSizeHorizontal * 5,
                                top: SizeConfig.blockSizeVertical / 2),
                            child: Text("Yaoundé,Cameroun"),
                          )
                        ],
                      ),
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 5,
                      ),
                      UtilButton(
                        height: SizeConfig.blockSizeVertical * 6,
                        width: SizeConfig.blockSizeHorizontal * 13,
                        icon: SvgPicture.asset(
                          Assets.soundIcon,
                        ),
                      ),
                      UtilButton(
                        height: SizeConfig.blockSizeVertical * 6,
                        width: SizeConfig.blockSizeHorizontal * 13,
                        icon: SvgPicture.asset(
                          Assets.zoomPlusIcon,
                        ),
                      ),
                      UtilButton(
                        height: SizeConfig.blockSizeVertical * 6,
                        width: SizeConfig.blockSizeHorizontal * 13,
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
                            height: SizeConfig.blockSizeVertical * 40,
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
                                      print(value);
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
                                                                    print(placesResult.toList().toString());
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
                    height: SizeConfig.blockSizeVertical * 8,
                    width: SizeConfig.blockSizeHorizontal * 17,
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
                          isExpanded ?
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ) :
                          BoxShadow(
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
                          left: SizeConfig.blockSizeVertical * 21.75,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (isExpanded) {
                                  isExpanded = false;
                                  alertHeight = 30.0;
                                } else {
                                  isExpanded = true;
                                  alertHeight = 300.0;
                                }
                              });
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
                                            childAspectRatio: 0.75,
                                            crossAxisSpacing: 15.0,
                                            mainAxisSpacing: 20.0),
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
                                      ),
                                      Alert(
                                        title: "Zône dangereuse",
                                        color: HexColor("#FD4B89")
                                            .withOpacity(0.25),
                                        picture: SvgPicture.asset(
                                          Assets.dangerIcon,
                                        ),
                                        radius: 30.0,
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
                                      ),
                                      Alert(
                                        title: "Route en barrée",
                                        color: HexColor("#2EDACD")
                                            .withOpacity(0.25),
                                        picture: SvgPicture.asset(
                                          Assets.roadblockIcon,
                                        ),
                                        radius: 30.0,
                                      ),
                                      Alert(
                                        title: "Route en chantier",
                                        color: HexColor("#CBAB81")
                                            .withOpacity(0.25),
                                        picture: SvgPicture.asset(
                                          Assets.highwayIcon,
                                        ),
                                        radius: 30.0,
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
                          swiperIcon = SvgPicture.asset(
                              Assets.arrowUpIcon
                          );
                          context
                              .read<BottomBarProvider>()
                              .modifyColor(Colors.white.withOpacity(0.3));
                          bottomPadding = SizeConfig.blockSizeVertical;
                        } else {
                          context
                              .read<BottomBarProvider>()
                              .modifyColor(Colors.white);
                          swiperIcon = SvgPicture.asset(
                            Assets.arrowDownIcon,
                          );
                          bottomPadding = SizeConfig.blockSizeVertical * 34.5;
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
