import 'package:flutter/material.dart';
import 'dart:io';
import 'package:mapane/models/slider_model.dart';
import 'package:mapane/utils/size_config.dart';
import 'package:mapane/routes.dart';
import 'dart:io' show Platform;


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(                           
      builder: (context, constraints) {
        return OrientationBuilder(                  
          builder: (context, orientation) {
            return MaterialApp(
              title: "App Onboarding",
              home: Walk(),
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}

class Walk extends StatefulWidget {
  @override
  _WalkState createState() => _WalkState();
}

class _WalkState extends State<Walk> {
  List<SliderModel> slides = new List<SliderModel>();
  int currentIndex = 0;
  PageController pageController = new PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    slides = getSlides();
  }

  Widget pageIndexIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: getSize(15.5, "height", context)),
      height: isCurrentPage ? getSize(13, "height", context) : getSize(12, "height", context),
      width: isCurrentPage ? getSize(13, "width", context) : getSize(12, "width", context),
      decoration: BoxDecoration(
        color: isCurrentPage ? Color.fromRGBO(37, 41, 106, 1) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: pageController,
        onPageChanged: (val) {
          setState(() {
            currentIndex = val;
          });
        },
        itemBuilder: (context, index) {
          return SliderTile(
            imageAssetPath: slides[index].imagePath,
            title: slides[index].title,
            description: slides[index].description,
          );
        },
        itemCount: slides.length,
      ),
      bottomSheet: currentIndex != slides.length - 1
          ? Container(
              decoration: new BoxDecoration(
                color: Colors.white,
              ),
              height: Platform.isIOS ? getSize(70, "height", context) : getSize(60, "height", context),
              // padding: EdgeInsets.symmetric(horizontal: 40),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    left: getSize(40, "width", context),
                    child: GestureDetector(
                      onTap: () {
                        pageController.animateToPage(
                          slides.length - 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.linear,
                        );
                      },
                      child: new Text(
                            'Passer',
                            style: new TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Robotto',
                              color: Colors.black,
                            )
                          ),
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (int i = 0; i < slides.length; i++)
                          currentIndex == i
                              ? pageIndexIndicator(true)
                              : pageIndexIndicator(false)
                      ],
                  ),
                  GestureDetector(
                    onTap: () {
                      pageController.animateToPage(
                        currentIndex + 1,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.linear,
                      );
                    },
                    child: Text(""),
                  ),
                ],
              ),
            )
          : Container(
              decoration: new BoxDecoration(
                color: Colors.white,
              ),
              height: Platform.isIOS ? getSize(70, "height", context) : getSize(60, "height", context),
              padding: EdgeInsets.symmetric(horizontal: getSize(40, "height", context)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      for (int i = 0; i < slides.length; i++)
                        currentIndex == i
                            ? pageIndexIndicator(true)
                            : pageIndexIndicator(false)
                    ],
                  )
                ],
              ),
            ),
    );
  }
}

// ignore: must_be_immutable
class SliderTile extends StatelessWidget {
  //initialising variables here
  String imageAssetPath;
  String title;
  String description;

  SliderTile({this.imageAssetPath, this.title, this.description});
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return new Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        new Positioned(
          top: getSize(0, "height", context),
          child: Image.asset("assets/images/Groupe 152.png"),
        ),
        new Positioned(
          top: 103,
          child: ClipPath(
            child: Container(height: 200,width: MediaQuery.of(context).size.width,color: Colors.white),
            clipper: DrawTriangle(),
          )
        ),
        new Positioned(
          top:getSize(150, "height", context),
          width: getSize(400, "width", context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(imageAssetPath, height: getSize(171, "height", context)),
              SizedBox(
                height: 0.06529*deviceSize.height,
              ),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 40,
                  color: Color.fromRGBO(37, 41, 106, 1)
                ),
              ),
              SizedBox(
                height: 0.05377*deviceSize.height,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getSize(36, "height", context)),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 0.05889*deviceSize.height,
              ),
              title == "Notifications" ? Padding(
                padding: EdgeInsets.symmetric(horizontal: getSize(36, "height", context)),
                child: RaisedButton(
                  onPressed: () {
                    Platform.isAndroid ? Navigator.of(context).pushNamed(Routes.numero_get) : Navigator.of(context).pushNamed(Routes.numero_get_ios);
                  },
                  textColor: Colors.white,
                  color: Colors.transparent,
                  padding: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                  ),
                  child: Container(
                      width: getSize(400, "width", context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFFA7BACB),
                              Color(0xFF25296A),
                            ],
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                      child: Center(child: const Text('C\'est parti', style: TextStyle(fontSize: 18))),
                  ),
                ), 
              ) : SizedBox(
                height: 0,
              )
            ],
          )
        ),
      ],
    );
  }
}


class DrawTriangle extends CustomClipper<Path> {
  final double scaleFactor;
  DrawTriangle({this.scaleFactor = 0});

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width, size.height/2);
    path.lineTo(size.width, size.height*100);
    path.lineTo(size.width/250, size.height/1.25);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;  
}