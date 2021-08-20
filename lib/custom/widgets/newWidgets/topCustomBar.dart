import 'package:flutter/material.dart';
import '../../../utils/size_config.dart';
import 'package:mapane/state/bottom_bar_provider.dart';
import 'package:provider/provider.dart';
import './topBar.dart';

class topCustomBar extends StatelessWidget {
  final String type;
  final String text;
  const topCustomBar({Key key, this.type, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        type == "black" ? topBar() : topBar(type: "black"),
        SizedBox(
          height: getSize(20, "height", context),
        ),
        Container(
          child: Row(
            children: [
              InkWell(
                  child: Padding(
                    padding:
                        EdgeInsets.only(right: getSize(13, "width", context)),
                    child: Icon(
                      Icons.arrow_back,
                      color: type == "black" ? Colors.black : Colors.white,
                    ),
                  ),
                  onTap: () {
                    context.read<BottomBarProvider>().setWidget(false);
                  }),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getSize(5, "width", context), vertical: 0),
                child: Text(
                  text,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: getSize(
                        18,
                        "height",
                        context,
                      ),
                      color: type == "black" ? Colors.black : Colors.white),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

