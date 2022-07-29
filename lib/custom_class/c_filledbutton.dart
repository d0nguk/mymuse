import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FilledButton extends StatefulWidget {
  
  final Text hintText;
  final VoidCallback func;
  final Color mainColor;
  
  double width;
  double height;
  Alignment alignment;

  bool enabledbutton = false;
  bool isVisible;

  FilledButton(
      {Key? key,
      required this.hintText,
      required this.func,
      required this.mainColor,
      this.enabledbutton = false,
      this.isVisible = false,
      this.width = 80,
      this.height = 40,
      this.alignment = Alignment.center})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<FilledButton> createState() =>
      _FilledButtonState(hintText, func, mainColor, isVisible, width, height, alignment);
}

class _FilledButtonState extends State<FilledButton> {
  Text hintText;
  VoidCallback func;
  Color mainColor;

  bool isVisible;

  double width;
  double height;
  Alignment alignment;

  _FilledButtonState(
    this.hintText,
    this.func,
    this.mainColor,
    this.isVisible,
    this.width,
    this.height,
    this.alignment
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height : height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          // Text Color
          onPrimary: Colors.white,
          // Box Color
          primary: mainColor,//Theme.of(context).colorScheme.primary,
          alignment: alignment,
        ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
        onPressed: func,
        child: hintText,
      ),
    );
  }
}
