
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper/pages/home.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    //Provider.of<WallpaperHelper>(context,listen: false);
    Timer(
        Duration(
          seconds: 1,
        ),
            () => Navigator.pushReplacement(
            context,
            PageTransition(
                child: Home(), type: PageTransitionType.leftToRight))
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Image.asset('assets/cap.PNG',fit: BoxFit.fill,),
      ),
    );
  }
}
