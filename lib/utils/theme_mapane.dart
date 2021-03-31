
import 'package:flutter/material.dart';


final _fontTheme = 'Robotto';


class ThemeMapane {

  static ThemeData themeMapane(BuildContext context){
    final base = ThemeData.light();
    return base.copyWith(
      primaryColor: AppColors.primaryColor,
      accentColor: AppColors.whiteColor,
      canvasColor: Colors.transparent,
      cursorColor: AppColors.blackColor,
      hintColor: AppColors.textColorLightXX,
      focusColor: AppColors.iconBlueColor,
      buttonColor: AppColors.iconBlueColor,
      textTheme: base.textTheme.copyWith(
        headline1: AppTheme.headerH1.copyWith(color: AppColors.mainBlueColor),
        headline2: AppTheme.headerH2.copyWith(color: AppColors.blackColor),
        headline3: AppTheme.headerH3.copyWith(color: AppColors.blackColor),
        bodyText1: AppTheme.defaultParagraph.copyWith(color: AppColors.blackColor),
        button: AppTheme.buttonText.copyWith(color: AppColors.whiteColor),
        caption: AppTheme.captionText.copyWith(color: AppColors.blackColor),
        subtitle1: AppTheme.tinyText.copyWith(color: AppColors.blackColor ),
        subtitle2: AppTheme.notice.copyWith(color: AppColors.blackColor),
      ),

    );
  }

}


class AppColors {

  // for 'custom' theme
  static const primaryColor = Color(0xFFA7BACB);

  /// App Background


  static const blackColor = Color(0xFF000000);

  static const mainBlueColor = Color(0xFF25296A);
  static const normalBlueColor = Color(0xFF6A2529);
  static const ligthtBlueColor = Color(0xFFA7BACB);

  //colors icons
  static const iconBlueColor = mainBlueColor;
  static const whiteColor = Color(0xFFFFFFFF);
  static const greenColor = Color(0xFF39C926);

  //Gradient Colors

  static const whiteGradientColor1 = Color(0x00A7BACB);
  static const whiteGradientColor2 = Color(0x5CFFFFFF);


  //border colors
  static const borderColorLow = Color(0x1A000000);


  //Text colors

  static const textColorPrimary = Color(0xFF000000);
  static const textColorGray = Color(0x32000000);
  static const textColorLightWhite = Color(0x31FFFFFF);
  static const textColorLight = Color(0xFFFFFFFF);
  static const textColorLightX = Color(0x28FFFFFF);
  static const textColorLightXX = Color(0x22000000);

  static const textColorLink = Color(0xFF6386B8);



  


  // Not use Now

  static const greenColorPalette = Color(0xff6cde9a);
  static const redColorPalette = Color(0xffff7e75);
  static const yellowColorPalette = Color(0xffffde42);
  static const borderColor = Color(0xff434343);
  static const darkGreyColor = Color(0xff3c3c3c);
  static const chartLineColor = Color(0xffECF0F4);

}


class AppTheme extends Theme {

  static TextStyle headerH1 = TextStyle(
    fontSize: 30,
    fontFamily: _fontTheme,
    letterSpacing: 1.5,
  );
  static TextStyle headerH2 = TextStyle(
    fontSize: 26,
    fontFamily: _fontTheme,
  );
  static TextStyle defaultParagraph = TextStyle(
    fontSize: 18,
    fontFamily: _fontTheme,
  );

  static TextStyle bodyText1 = TextStyle(
    fontFamily: _fontTheme,
    fontSize: 16,
  );

  static TextStyle tinyText = TextStyle(
    fontFamily: _fontTheme,
    fontSize: 12,
  );

  static TextStyle notice = TextStyle(
    fontFamily: _fontTheme,
    fontSize: 10,
  );

  static TextStyle captionText = TextStyle(
    fontFamily: _fontTheme,
    fontSize: 10,
  );

  static TextStyle buttonText = TextStyle(
    fontFamily: _fontTheme,
    fontSize: 18,
  );

  // Not use Now

  static TextStyle highlightText = TextStyle(
    fontFamily: _fontTheme,
    fontSize: 17,
    decoration: TextDecoration.underline,
  );

  static TextStyle headerH3 = TextStyle(
    fontSize: 20,
    fontFamily: _fontTheme,
  );
}


  //elevations

class Elevation {
  static List<BoxShadow> low = [
    BoxShadow(
        color: AppColors.blackColor.withOpacity(0.15),
        offset: Offset(1.0, 3.0),
        blurRadius: 5.5),
  ];

  static List<BoxShadow> high = [
    BoxShadow(color: Colors.black26, offset: Offset(4.0, 4.0), blurRadius: 4.0),
    BoxShadow(color: Colors.black26, offset: Offset(2.0, 2.0), blurRadius: 2.0),
    BoxShadow(color: Colors.black26, offset: Offset(1.0, 1.0), blurRadius: 1.0),
  ];
}