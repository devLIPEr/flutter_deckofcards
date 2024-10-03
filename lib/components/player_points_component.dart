import 'package:flutter/material.dart';

/// @reference - https://stackoverflow.com/questions/48481590/how-to-set-update-state-of-statefulwidget-from-other-statefulwidget-in-flutter
class PlayerPoint extends StatefulWidget {
  PlayerPoint({super.key});

  late _PlayerPointState state;
  @override
  State<PlayerPoint> createState() {
    state = _PlayerPointState();
    return state;
  }
}

class _PlayerPointState extends State<PlayerPoint> {
  int points = 0;
  int wins = 0;
  int loses = 0;
  int draws = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "$points - ",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        Text(
          "$wins/",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        Text(
          "$loses/",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        Text(
          "$draws",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  void addPoints(int addedPoints) {
    setState(() {
      if (addedPoints == 11 && points + addedPoints > 21) {
        addedPoints = 1;
      }
      points += addedPoints;
    });
  }

  void addWin() {
    setState(() {
      wins++;
    });
  }

  void addLose() {
    setState(() {
      loses++;
    });
  }

  void addDraw() {
    setState(() {
      draws++;
    });
  }

  void updateState(){
    setState(() {});
  }
}
