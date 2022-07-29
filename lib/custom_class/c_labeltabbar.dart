import 'package:flutter/material.dart';

class LabelTabbar extends StatefulWidget {
  final Text label;
  final double height;

  const LabelTabbar({Key? key, required this.label, required this.height})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api, no_logic_in_create_state
  _LabelTabbarState createState() => _LabelTabbarState(label, height);
}

class _LabelTabbarState extends State<LabelTabbar> {
  Text label;
  double height;

  _LabelTabbarState(this.label, this.height);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(0, 255, 255, 255),
      alignment: Alignment.center,
      child: label,
    );
  }
}
