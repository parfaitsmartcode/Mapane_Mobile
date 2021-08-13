import 'package:flutter/material.dart';
import '../../../utils/size_config.dart';
import 'package:mapane/state/bottom_bar_provider.dart';
import 'package:provider/provider.dart';
import './topBar.dart';

class topCustomBar extends StatelessWidget {
  const topCustomBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        topBar(),
        SizedBox(
          height: getSize(20, "height", context),
        ),
        Container(
          child: Row(
            children: [
              IconButton(
                  padding: EdgeInsets.only(left: 0),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    context.read<BottomBarProvider>().setWidget(false);
                  }),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getSize(5, "width", context), vertical: 0),
                child: Text(
                  "Espace jeu",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
