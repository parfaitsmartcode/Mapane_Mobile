import 'dart:async';
import 'package:provider/provider.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapane/constants/assets.dart';
import 'package:mapane/models/alert.dart';
import 'package:mapane/state/alert_provider.dart';
import 'package:mapane/utils/hexcolor.dart';
import 'package:mapane/utils/size_config.dart';
import 'package:simple_moment/simple_moment.dart';

class NotificationMapane extends StatefulWidget {
  final double CAMERA_ZOOM;
  final double CAMERA_TILT;
  final double CAMERA_BEARING;
  final Completer<GoogleMapController> completer;

  NotificationMapane({this.CAMERA_ZOOM,this.CAMERA_TILT,this.CAMERA_BEARING,this.completer});
  @override
  _NotificationMapaneState createState() => _NotificationMapaneState();
}

class _NotificationMapaneState extends State<NotificationMapane>
    with TickerProviderStateMixin {
  List<String> welcomeImages = [
    "https://i.picsum.photos/id/519/200/200.jpg?hmac=7MwcBjyXrRX5GB6GuDATVm_6MFDRmZaSK7r5-jqDNS0",
    "https://i.picsum.photos/id/519/200/200.jpg?hmac=7MwcBjyXrRX5GB6GuDATVm_6MFDRmZaSK7r5-jqDNS0",
    "https://i.picsum.photos/id/519/200/200.jpg?hmac=7MwcBjyXrRX5GB6GuDATVm_6MFDRmZaSK7r5-jqDNS0",
    "https://i.picsum.photos/id/519/200/200.jpg?hmac=7MwcBjyXrRX5GB6GuDATVm_6MFDRmZaSK7r5-jqDNS0",
  ];

  getAppropriateIcon(alert){
    switch (alert) {
      case "embouteillage":
        return Assets.embouteillageMarker3;
        break;
      case "travaux":
        return Assets.embouteillageMarker3;
        break;
      case "zone dangereuse":
        return Assets.embouteillageMarker3;
        break;
      case "controle routier":
        return Assets.embouteillageMarker3;
        break;
      case "Radar":
        return Assets.embouteillageMarker3;
        break;
      case "Accident de circulation":
        return Assets.embouteillageMarker3;
        break;
      case "route barrée":
        return Assets.embouteillageMarker3;
        break;
      default:
        return Assets.embouteillageMarker3;
    }
  }

  @override
  Widget build(BuildContext context) {
    CardController controller = CardController(); //Use this to trigger swap.
    SizeConfig().init(context);
    Moment.setLocaleGlobally(new LocaleFr());
    var moment = Moment.now();
    return  Container(
      height: 127,
      //width: 400,
      child: new TinderSwapCard(
        swipeUp: false,
        swipeDown: false,
        orientation: AmassOrientation.TOP,
        totalNum: context.read<AlertProvider>().notifications.length,
        stackNum: context.read<AlertProvider>().notifications.length,
        swipeEdge: 4.0,
        maxWidth: MediaQuery.of(context).size.width * 0.9,
        maxHeight: MediaQuery.of(context).size.width * 0.9,
        minWidth: MediaQuery.of(context).size.width * 0.8,
        minHeight: MediaQuery.of(context).size.width * 0.8,
        cardBuilder: (context, index) => Card(
            elevation: 5.0,
            semanticContainer: true,
            color: HexColor("#4B4B4B"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Stack(
              overflow: Overflow.visible,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: SizeConfig.blockSizeVertical * 1.5,
                      right: SizeConfig.blockSizeHorizontal),
                  child: InkWell(
                    child: Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: SizeConfig.blockSizeHorizontal * 3),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      alignment: Alignment.center,
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: HexColor("#ffffff"),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Image.asset(Assets.embouteillageMarker3,height:getSize(35, "height", context),width: getSize(35, "width", context)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: SizeConfig.blockSizeHorizontal * 13),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                        context.read<AlertProvider>().notifications[index].category.name,

                          style: TextStyle(
                              fontSize: 16.0, color: Colors.white),
                          overflow: TextOverflow.clip,
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 0.5,
                        ),
                        Text(
                          context.read<AlertProvider>().notifications[index].address,
                          style: TextStyle(
                              fontSize: 12.0, color: Colors.white),
                          overflow: TextOverflow.clip,
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 0.5,
                        ),
                        Text(
                          moment.from(DateTime.parse(context.read<AlertProvider>().notifications[index].createdAt)),
                          style: TextStyle(
                              fontSize: 12.0,
                              color: HexColor("#707070").withOpacity(0.49)),
                          overflow: TextOverflow.clip,
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: getSize(95, "height", context),
                  left: SizeConfig.screenWidth / 6,
                  child: SizedBox(
                    height: 35.0,
                    width: 200,
                    child: Card(
                      elevation: 1,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Localiser"
                          ),
                          VerticalDivider(
                            thickness: 1.5,
                            endIndent: 2,
                            indent: 2,
                          ),
                          InkWell(
                            onTap: (){
                              setState(() {
                                context.read<AlertProvider>().notifications = [];
                              });
                            },
                            child: Text(
                              "Tout fermer"
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              setState(() {
                                context.read<AlertProvider>().notifications.removeAt(index);
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 20.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ) //Image.network('${welcomeImages[index]}',fit: BoxFit.cover,),
            ),
        cardController: controller ,
        swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
          /// Get swiping card's alignment
          if (align.x < 0) {
            //Card is LEFT swiping
          } else if (align.x > 0) {
            //Card is RIGHT swiping
          }
        },
        swipeCompleteCallback:
            (CardSwipeOrientation orientation, int index) {
          /// Get orientation & index of swiped card!
        },
      ),
    );
  }
}
