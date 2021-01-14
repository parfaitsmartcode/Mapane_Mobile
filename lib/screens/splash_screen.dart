import 'package:flutter/material.dart';
import 'package:walkthrough/flutterwalkthrough.dart';
import 'package:walkthrough/walkthrough.dart';
import 'dart:async';
import 'dart:core';
import 'walk.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen2(
      seconds: 5, 
      navigateAfterSeconds: new AfterSplash(),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Image.asset('assets/images/Logo-long-edited.png', width: 300,),
          new Padding(
            padding: const EdgeInsets.only(top: 15.0),
          ),
          Container(
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: new Text(
                    'C\'est plus facile de se déplacer',
                    style: new TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Robotto',
                      color: Colors.black.withOpacity(.8),
                    )
                  ),
                ),
              ]
            )
          ),
        ],
      ),
      useLoader: false,
      pageRoute: _createRoute(),
      imageBackground: AssetImage("assets/images/Background.png"),
      gradientBackground: LinearGradient(
          colors: [
            Color.fromRGBO(73, 113, 172, 0.6),
            Color.fromRGBO(73, 113, 172, 0.6),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
      )
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Walk(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
class AfterSplash extends StatelessWidget {
  final List<Walkthrough> list = [
        Walkthrough(
          title: "Title 1",
          content: "Content 1",
          imageIcon: Icons.restaurant_menu,
        ),
        Walkthrough(
          title: "Title 2",
          content: "Content 2",
          imageIcon: Icons.search,
        ),
        Walkthrough(
          title: "Title 3",
          content: "Content 3",
          imageIcon: Icons.shopping_cart,
        ),
        Walkthrough(
          title: "Title 4",
          content: "Content 4",
          imageIcon: Icons.verified_user,
        ),
  ];
  @override
  Widget build(BuildContext context) {
    return IntroScreen(
          list,
          MaterialPageRoute(builder: (context) => AfterSplash()),
    );
  }
}
class SplashScreen2 extends StatefulWidget {
  /// Seconds to navigate after for time based navigation
  final int seconds;

  /// App title, shown in the middle of screen in case of no image available
  final Widget title;

  /// Page background color
  final Color backgroundColor;

  /// Style for the laodertext
  final TextStyle styleTextUnderTheLoader;

  /// The page where you want to navigate if you have chosen time based navigation
  final dynamic navigateAfterSeconds;

  /// Main image size
  final double photoSize;

  /// Triggered if the user clicks the screen
  final dynamic onClick;

  /// Loader color
  final Color loaderColor;

  /// Main image mainly used for logos and like that
  final Image image;

  /// Loading text, default: "Loading"
  final Text loadingText;

  ///  Background image for the entire screen
  final ImageProvider imageBackground;

  /// Background gradient for the entire screen
  final Gradient gradientBackground;

  /// Whether to display a loader or not
  final bool useLoader;

  /// Custom page route if you have a custom transition you want to play
  final Route pageRoute;

  /// RouteSettings name for pushing a route with custom name (if left out in MaterialApp route names) to navigator stack (Contribution by Ramis Mustafa)
  final String routeName;

  /// expects a function that returns a future, when this future is returned it will navigate
  final Future<dynamic> navigateAfterFuture;

  /// Use one of the provided factory constructors instead of.
  @protected
  SplashScreen2({
    this.loaderColor,
    this.navigateAfterFuture,
    this.seconds,
    this.photoSize,
    this.pageRoute,
    this.onClick,
    this.navigateAfterSeconds,
    this.title,
    this.backgroundColor = Colors.white,
    this.styleTextUnderTheLoader =
        const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
    this.image,
    this.loadingText = const Text(""),
    this.imageBackground,
    this.gradientBackground,
    this.useLoader = true,
    this.routeName,
  });

  factory SplashScreen2.timer(
          {@required int seconds,
          Color loaderColor,
          Color backgroundColor,
          double photoSize,
          Text loadingText,
          Image image,
          Route pageRoute,
          dynamic onClick,
          dynamic navigateAfterSeconds,
          Widget title,
          TextStyle styleTextUnderTheLoader,
          ImageProvider imageBackground,
          Gradient gradientBackground,
          bool useLoader,
          String routeName}) =>
      SplashScreen2(
        loaderColor: loaderColor,
        seconds: seconds,
        photoSize: photoSize,
        loadingText: loadingText,
        backgroundColor: backgroundColor,
        image: image,
        pageRoute: pageRoute,
        onClick: onClick,
        navigateAfterSeconds: navigateAfterSeconds,
        title: title,
        styleTextUnderTheLoader: styleTextUnderTheLoader,
        imageBackground: imageBackground,
        gradientBackground: gradientBackground,
        useLoader: useLoader,
        routeName: routeName,
      );

  factory SplashScreen2.network(
          {@required Future<dynamic> navigateAfterFuture,
          Color loaderColor,
          Color backgroundColor,
          double photoSize,
          Text loadingText,
          Image image,
          Route pageRoute,
          dynamic onClick,
          dynamic navigateAfterSeconds,
          Widget title,
          TextStyle styleTextUnderTheLoader,
          ImageProvider imageBackground,
          Gradient gradientBackground,
          bool useLoader,
          String routeName}) =>
      SplashScreen2(
        loaderColor: loaderColor,
        navigateAfterFuture: navigateAfterFuture,
        photoSize: photoSize,
        loadingText: loadingText,
        backgroundColor: backgroundColor,
        image: image,
        pageRoute: pageRoute,
        onClick: onClick,
        navigateAfterSeconds: navigateAfterSeconds,
        title: title,
        styleTextUnderTheLoader: styleTextUnderTheLoader,
        imageBackground: imageBackground,
        gradientBackground: gradientBackground,
        useLoader: useLoader,
        routeName: routeName,
      );

  @override
  _SplashScreen2State createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  @override
  void initState() {
    super.initState();
    if (widget.routeName != null && widget.routeName is String && "${widget.routeName[0]}" != "/") {
      throw new ArgumentError("widget.routeName must be a String beginning with forward slash (/)");
    }
    if (widget.navigateAfterFuture == null) {
      Timer(Duration(seconds: widget.seconds), () {
        if (widget.navigateAfterSeconds is String) {
          // It's fairly safe to assume this is using the in-built material
          // named route component
          Navigator.of(context).pushReplacementNamed(widget.navigateAfterSeconds);
        } else if (widget.navigateAfterSeconds is Widget) {
          Navigator.of(context).pushReplacement(widget.pageRoute != null
              ? widget.pageRoute
              : new MaterialPageRoute(
                  settings:
                      widget.routeName != null ? RouteSettings(name: "${widget.routeName}") : null,
                  builder: (BuildContext context) => widget.navigateAfterSeconds));
        } else {
          throw new ArgumentError('widget.navigateAfterSeconds must either be a String or Widget');
        }
      });
    } else {
      widget.navigateAfterFuture.then((navigateTo) {
        if (navigateTo is String) {
          // It's fairly safe to assume this is using the in-built material
          // named route component
          Navigator.of(context).pushReplacementNamed(navigateTo);
        } else if (navigateTo is Widget) {
          Navigator.of(context).pushReplacement(widget.pageRoute != null
              ? widget.pageRoute
              : new MaterialPageRoute(
                  settings:
                      widget.routeName != null ? RouteSettings(name: "${widget.routeName}") : null,
                  builder: (BuildContext context) => navigateTo));
        } else {
          throw new ArgumentError('widget.navigateAfterFuture must either be a String or Widget');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new InkWell(
        onTap: widget.onClick,
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                image: widget.imageBackground == null
                    ? null
                    : new DecorationImage(
                        fit: BoxFit.cover,
                        image: widget.imageBackground,
                      ),
                gradient: widget.gradientBackground,
                color: widget.backgroundColor,
              ),
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  flex: 2,
                  child: new Container(
                    // decoration: BoxDecoration(
                    //   gradient: LinearGradient(
                    //     begin: Alignment.topCenter,
                    //     end: Alignment.bottomCenter,
                    //     colors: [Color(0x00FFFFFF) , Color(0xD9FFFFFF), Color(0xD9FFFFFF), Color(0xD9FFFFFF),Color(0x00FFFFFF)],
                    //     stops: [
                    //       0,
                    //       0.3,
                    //       0.7,
                    //       0,
                    //       1
                    //     ]
                    //   )
                    // ),
                      child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      widget.title
                    ],
                  )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
