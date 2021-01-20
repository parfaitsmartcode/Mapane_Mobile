import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapane/custom/widgets/util_button.dart';
import 'package:mapane/state/bottom_bar_provider.dart';
import 'package:mapane/utils/PermissionHelper.dart';
import 'package:mapane/utils/size_config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isExpanded = false;
  double alertHeight = 30.0;
  Icon swiperIcon  = Icon(
    Icons.keyboard_arrow_up,
    color: Colors.grey,
    size: 30.0,
  );

  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
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
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
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
                        icon: Icon(Icons.volume_up_rounded),
                      ),
                      UtilButton(
                        height: SizeConfig.blockSizeVertical * 6,
                        width: SizeConfig.blockSizeHorizontal * 13,
                        icon: Icon(Icons.zoom_in),
                      ),
                      UtilButton(
                        height: SizeConfig.blockSizeVertical * 6,
                        width: SizeConfig.blockSizeHorizontal * 13,
                        icon: Icon(Icons.zoom_out),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedPadding(
                duration: Duration(seconds: 1),
                padding: EdgeInsets.only(
                    bottom: !isExpanded ? SizeConfig.blockSizeVertical * 15 : SizeConfig.blockSizeVertical * 45,
                    right: SizeConfig.blockSizeHorizontal * 6),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: UtilButton(
                    height: SizeConfig.blockSizeVertical * 8,
                    width: SizeConfig.blockSizeHorizontal * 17,
                    icon: Icon(Icons.search,size: 35.0,),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 7.27),
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
                            : Colors.white.withOpacity(0.3)),
                    duration: Duration(seconds: 1),
                    child: Stack(
                      overflow: Overflow.visible,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          //bottom:  15.0,
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
                            child: CircleAvatar(
                              radius: 15.0,
                              backgroundColor: Colors.blueGrey,
                                child: Center(child: swiperIcon)
                            ),
                          ),
                        ),
                      ],
                    ),
                    onEnd: (){
                      setState(() {
                        if(!isExpanded){
                          swiperIcon = Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.grey,
                            size: 30.0,
                          );
                          context.read<BottomBarProvider>().modifyColor(Colors.white.withOpacity(0.3));
                        }else {
                          context.read<BottomBarProvider>().modifyColor(Colors.white);
                          swiperIcon = Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                            size: 30.0,
                          );
                        }
                      });
                    },
                  ),
                ),
              ),
              /*Align(
                alignment: Alignment.bottomCenter,
                child: Card(
                  elevation: 10.0,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: 200,
                  ),
                )
              ),*/
            ],
          ),
        ));
  }
}
