import 'package:flutter/material.dart';
import 'package:Mapane/utils/size_config.dart';
import 'package:Mapane/routes.dart';
import 'package:Mapane/utils/theme_mapane.dart';

class Popup extends StatefulWidget {
  @override
  _PopupState createState() => _PopupState();
  final String type;
  final String msg;
  final ImageProvider image;
  Popup({@required this.type, this.msg, this.image});
}

class _PopupState extends State<Popup> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                                horizontal: getSize(30, "width", context)),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: AppColors.greenColor.withOpacity(0.35),
                            ),
                            child: Center(
                                child: Icon(
                              Icons.check,
                              size: getSize(38, "height", context),
                              color: AppColors.greenColor,
                            )),
                          ),
                          SizedBox(
                            height: getSize(21, "height", context),
                          ),
                          Text(
                            "Sauvegardé",
                            style: AppTheme.defaultParagraph,
                          ),
                          SizedBox(
                            height: getSize(12, "height", context),
                          ),
                          Container(
                            width: getSize(220, "width", context),
                            child: Text(
                              widget.msg,
                              style: AppTheme.bodyText1.copyWith(
                                color: AppColors.blackColor.withOpacity(0.5),
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
