import 'package:flutter/material.dart';
import 'package:mapane/utils/hexcolor.dart';
import 'package:mapane/utils/size_config.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:mapane/models/alert.dart';
import 'package:mapane/constants/assets.dart';

class Notif extends StatefulWidget {
  final Function onClose;
  final Function move;
  final Alert alert;

  Notif({this.alert,this.onClose,this.move});

  @override
  _NotifState createState() => _NotifState();
}

class _NotifState extends State<Notif> {
  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    Moment.setLocaleGlobally(new LocaleFr());
    var moment = Moment.now();

    return Scaffold(
      body: Center(
        child: Container(
          height: 127,
          child: Card(
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
                            onTap: widget.onClose,
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
                        padding: EdgeInsets.only(
                            left: getSize(20, "width", context)),
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
                            widget.alert.category.name,

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
                              widget.alert.address,
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
                            "lol",//moment.from(DateTime.parse(widget.alert.createdAt)),
                            style: TextStyle(
                                fontSize: 12.0,
                                color: HexColor("#707070").withOpacity(0.49)),
                            overflow: TextOverflow.clip,
                          )
                        ],
                      ),
                    ),
                  ),
                    ],
                  ),
                  Positioned(
                    top: getSize(75, "height", context),
                    left: getSize(82, "width", context),
                    child: SizedBox(
                      height: getSize(35,"height",context),
                      width: getSize(230,"width",context),
                      child: Card(
                        elevation: 1,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              onPressed: widget.move,
                              child: Text(
                                  "Localiser",
                                style: TextStyle(
                                  color: Colors.black
                                ),
                              ),
                            ),
                            VerticalDivider(
                              thickness: 1.5,
                              endIndent: 2,
                              indent: 2,
                            ),
                            FlatButton(
                              onPressed: widget.onClose,
                              child: Text(
                                  "Fermer"
                              ),
                            ),
                            InkWell(
                              onTap: widget.onClose,
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
        ),
      ),
    );
  }
}
