import 'dart:async';
import 'package:provider/provider.dart';
import "package:flutter/material.dart";
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapane/constants/assets.dart';
import 'package:mapane/state/alert_provider.dart';
import 'package:mapane/utils/hexcolor.dart';
import 'package:mapane/utils/size_config.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:mapane/localization/language/languages.dart';
import 'package:mapane/state/user_provider.dart';
import 'package:audioplayer/audioplayer.dart';

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

  AudioPlayer audioPlugin = AudioPlayer();

  @override
  void initState() {
    super.initState();
    if (context.read<UserProvider>().audioVal) {
      audioPlugin.play("http://mapane.smartcodegroup.com/alert_notif.mp3");
    }
    context.read<UserProvider>().getLangVal();
  }
  getAppropriateIcon(alert){
    switch (alert) {
      case "Embouteillage":
        return Assets.embouteillageMarker3;
        break;
      case "Route-en-chantier":
        return Assets.routechantierMarker3;
        break;
      case "Route-barree":
        return Assets.routebarreeMarker3;
        break;
      case "Controle-routier":
        return Assets.controleMarker3;
        break;
      case "Zone-dangereuse":
        return Assets.dangerMarker3;
        break;
      case "Police":
        return Assets.controleMarker2;
        break;
      case "Accident-de-circulation":
        return Assets.accidentMarker3;
        break;
      case "S.O.S":
        return Assets.sosMarker3;
        break;
      default:
        return Assets.embouteillageMarker3;
    }
  }

  @override
  Widget build(BuildContext context) {
    CardController controller = CardController(); //Use this to trigger swap.
    SizeConfig().init(context);
    Moment.setLocaleGlobally(context.watch<UserProvider>().languageVal ? LocaleFr() : LocaleEn());
    print(context.watch<AlertProvider>().notifications[0].lat);
    var moment = Moment.now();
    return  Container(
      height: getSize(96, "height", context),
      child: new TinderSwapCard(
        swipeUp: false,
        swipeDown: false,
        orientation: AmassOrientation.TOP,
        totalNum: context.watch<AlertProvider>().notifications.length,
        stackNum: context.watch<AlertProvider>().notifications.length,
        swipeEdge: 4.0,
        maxWidth: getSize(327, "width", context),
        maxHeight: getSize(96, "height", context),
        minWidth: getSize(326, "width", context),
        minHeight: getSize(95, "height", context),
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
                          onTap: (){
                            context.read<AlertProvider>().popNotification(index);
                          },
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: getSize(10, "width", context)),
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
                          child: Image.asset(getAppropriateIcon(context.watch<AlertProvider>().notifications[index].category.slug),height:getSize(35, "height", context),width: getSize(35, "width", context)),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: getSize(16, "width", context)),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                        context.watch<UserProvider>().languageVal ? context.watch<AlertProvider>().notifications[index].category.name : context.watch<AlertProvider>().notifications[index].category.name_en,

                          style: TextStyle(
                              fontSize: 16.0, color: Colors.white),
                          overflow: TextOverflow.clip,
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 0.5,
                        ),
                        SizedBox(
                          width: getSize(210, "width", context),
                          child: Text(
                            context.watch<AlertProvider>().notifications[index].address.split(",")[0]+","+context.watch<AlertProvider>().notifications[index].address.split(",")[1],
                            maxLines: 2,
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 12.0, color: Colors.white),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 0.5,
                        ),
                        Text(
                          moment.from(DateTime.parse(context.watch<AlertProvider>().notifications[index].createdAt)),
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
                  top: getSize(72, "height", context),
                  width: getSize(327, "width", context),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: getSize(40, "height", context),
                        width: getSize(250, "width", context),
                        child: Card(
                          elevation: 1,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: FlatButton(
                                  onPressed: () async{
                                    CameraPosition cPosition = CameraPosition(
                                      zoom: widget.CAMERA_ZOOM,
                                      tilt: widget.CAMERA_TILT,
                                      bearing: widget.CAMERA_BEARING,
                                      target: LatLng(double.parse(context.read<AlertProvider>().notifications[index].lat), double.parse(context.read<AlertProvider>().notifications[index].lon)),
                                    );
                                    final GoogleMapController controller = await widget.completer.future;
                                    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
                                    context.read<AlertProvider>().popAllNotifications();
                                  },
                                  child: Text(
                                    Languages.of(context).localiser,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: getSize(12, "height", context),
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                thickness: 1.5,
                                endIndent: 2,
                                indent: 2,
                              ),
                              FlatButton(
                                onPressed: (){
                                  context.read<AlertProvider>().popAllNotifications();
                                },
                                child: Text(Languages.of(context).closeall,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: getSize(12, "height", context),
                                        fontWeight: FontWeight.normal)),
                              ),
                              Icon(
                                Icons.close,
                                size: 20.0,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
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
