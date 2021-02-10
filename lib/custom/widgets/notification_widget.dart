import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:mapane/constants/assets.dart';
import 'package:mapane/utils/hexcolor.dart';
import 'package:mapane/utils/size_config.dart';

class NotificationMapane extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    CardController controller; //Use this to trigger swap.
    SizeConfig().init(context);
    return  Container(
      height: 127,
      //width: 400,
      child: new TinderSwapCard(
        swipeUp: false,
        swipeDown: false,
        orientation: AmassOrientation.TOP,
        totalNum: welcomeImages.length,
        stackNum: welcomeImages.length,
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
                        color: HexColor("#707070").withOpacity(0.4),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: SvgPicture.asset(
                        Assets.mapIn,
                        color: Colors.white,
                      ),
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
                          "Accident de la circulation",
                          style: TextStyle(
                              fontSize: 16.0, color: Colors.white),
                          overflow: TextOverflow.clip,
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 0.5,
                        ),
                        Text(
                          "Accident de la circulation",
                          style: TextStyle(
                              fontSize: 12.0, color: Colors.white),
                          overflow: TextOverflow.clip,
                        ),
                        SizedBox(
                          height: SizeConfig.blockSizeVertical * 0.5,
                        ),
                        Text(
                          "il y a 14 min",
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
                  top: SizeConfig.screenHeight / 8.5,
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
                          Text(
                            "Tout fermer"
                          ),
                          Icon(
                            Icons.close,
                            size: 20.0,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ) //Image.network('${welcomeImages[index]}',fit: BoxFit.cover,),
            ),
        cardController: controller = CardController(),
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
