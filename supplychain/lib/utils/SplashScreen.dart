// ignore_for_file: avoid_single_cascade_in_expression_statements, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supplychain/utils/AppTheme.dart';

class SplashScreen extends StatefulWidget {
  final Widget launchScreen;
  const SplashScreen({super.key, required this.launchScreen});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  int cnt = 0;
  late AnimationController _lottieAnimation;
  final transitionDuration = Duration(seconds: 1);
  var expanded = false;
  double _bigFontSize = kIsWeb ? 234 : 178;
  @override
  void initState() {
    _lottieAnimation = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    Future.delayed(Duration(seconds: 1))
        .then((value) => setState(() => expanded = true))
        .then((value) => Duration(seconds: 1))
        .then(
          (value) => Future.delayed(Duration(seconds: 1)).then(
            (value) => _lottieAnimation.forward().then(
                  (value) => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => widget.launchScreen),
                      (route) => false),
                ),
          ),
        );
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: AppTheme().themeGradient),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 50,
            ),
            !expanded
                ? SizedBox()
                : LottieBuilder.asset(
                    'assets/plantAnimation.json',
                    onLoaded: (composition) {
                      _lottieAnimation
                        ..duration = composition
                            .duration; // set the duration of our AnimationController to the length of the lottie animation
                    },
                    frameRate: FrameRate.max,
                    repeat: false,
                    animate: false, // don't start the animation immediately
                    height: 150,
                    width: 150,
                    controller: _lottieAnimation,
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedDefaultTextStyle(
                  duration: transitionDuration,
                  curve: Curves.fastOutSlowIn,

                  style: GoogleFonts.kaushanScript(
                    color: AppTheme.secondaryColor,
                    fontSize: !expanded ? _bigFontSize : 50,
                    fontWeight: FontWeight.w600,
                  ),
                  child: Text(
                    "B",
                  ),
                ),
                AnimatedCrossFade(
                  firstCurve: Curves.fastOutSlowIn,
                  crossFadeState: !expanded
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: transitionDuration,
                  firstChild: Container(),
                  secondChild: _logoRemainder(),
                  alignment: Alignment.centerLeft,
                  sizeCurve: Curves.easeInOut,
                ),
              ],
            ),
            CircularProgressIndicator(color: AppTheme.secondaryColor)
          ],
        )),
      ),
    );
  }

  Widget _logoRemainder() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "ioZen",
          style: GoogleFonts.kaushanScript(
            color: AppTheme.secondaryColor,
            fontSize: 50,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
