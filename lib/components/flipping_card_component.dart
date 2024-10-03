import 'dart:math';

import 'package:flutter/material.dart';

class FlippingCard extends StatefulWidget {
  String flippingCardImg = "";
  FlippingCard({super.key, required this.flippingCardImg}) {}

  @override
  State<FlippingCard> createState() => _FlippingCardState();

  static startAnimation(){
    _FlippingCardState.startAnimation();
  }

  static resetAnimation(){
    _FlippingCardState.played = 0;
  }
}

class _FlippingCardState extends State<FlippingCard>
    with SingleTickerProviderStateMixin {
  static late AnimationController _animationController;
  late Animation<double> _animation;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;
  static double played = 0;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animation = Tween(begin: played, end: 1.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _animationStatus = status;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002)
        ..rotateY(pi * _animation.value)
        ..rotateX(pi),
      child: _animation.value < 0.5
          ? Image.network(
              'https://deckofcardsapi.com/static/img/back.png',
              scale: 2,
            )
          : Image.network(
              widget.flippingCardImg,
              scale: 2,
            ),
    );
  }

  static void startAnimation() {
    _animationController.forward();
    played = 1;
  }
}
