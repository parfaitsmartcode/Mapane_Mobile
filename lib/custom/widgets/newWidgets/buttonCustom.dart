import 'package:flutter/material.dart';
import 'package:mapane/utils/size_config.dart';

class ButtonCustom extends StatefulWidget {
  final VoidCallback method;
  final String text;
  final Color colorText;
  final int gradientType;
  const ButtonCustom(
      {Key key, this.text, this.method, this.colorText, this.gradientType})
      : super(key: key);

  @override
  _ButtonCustomState createState() => _ButtonCustomState();
}

class _ButtonCustomState extends State<ButtonCustom> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: widget.method,
      textColor: Colors.white,
      color: Colors.transparent,
      padding: EdgeInsets.all(0),
      child: Container(
        height: getSize(40, "height", context),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            gradient: getGradientType(widget.gradientType)),
        padding: EdgeInsets.fromLTRB(
            0, getSize(8, "height", context), 0, getSize(8, "height", context)),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.text,
              style: TextStyle(
                color: widget.colorText,
                fontSize: getSize(18, "height", context),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        )),
      ),
    );
  }
}

getGradientType(int type) {
  var colorGradient;
  switch (type) {
    case 1:
      colorGradient = <Color>[
        Color(0xFFA7BACB),
        Color(0xFF25296A),
      ];
      break;
    case 2:
      colorGradient = <Color>[
        Color(0xFFA7BACB),
        Color(0xFF6A2525),
      ];
      break;
    default:
      colorGradient = <Color>[
        Color(0xFFA7BACB),
        Color(0xFF25296A),
      ];
  }

  return LinearGradient(colors: colorGradient);
}
