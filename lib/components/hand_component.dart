import 'package:flutter/material.dart';

class Hand extends StatefulWidget {
  List<Widget> children = [];
  Hand({super.key, required this.children});

  late final _HandState state;

  @override
  State<Hand> createState() {
    state = _HandState();
    return state;
  }
}

class _HandState extends State<Hand> {
  Function updateWidget = () {};

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      alignment: Alignment.centerLeft,
      child: ListView(
        key: UniqueKey(),
        scrollDirection: Axis.horizontal,
        children: widget.children,
      ),
    );
  }

  void addChild(Widget child) {
    setState(() {
      widget.children.add(child);
    });
  }

  void addChildren(List<Widget> children) {
    setState(() {
      widget.children.addAll(children);
    });
  }

  void removeChildren(){
    setState(() {
      widget.children = [const SizedBox(width: 10)];
    });
  }
}
