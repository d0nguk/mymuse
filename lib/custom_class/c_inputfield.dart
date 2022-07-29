import 'package:flutter/material.dart';

import '../main.dart';

// ignore: must_be_immutable
class InputField extends StatefulWidget {
  final EdgeInsets padding;
  final EdgeInsets margin;
  final String hintText;
  final TextEditingController controller;
  final TextInputType type;

  bool isPassword = false;
  bool isVisible;

  InputField({
    Key? key,
    required this.padding,
    required this.margin,
    required this.hintText,
    required this.controller,
    required this.type,
    this.isPassword = false,
    this.isVisible = false}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<InputField> createState() => _InputFieldState(
    padding, margin, hintText, controller, type, isPassword, isVisible
  );

}

class _InputFieldState extends State<InputField> {
  EdgeInsets padding;
  EdgeInsets margin;
  String hintText;
  TextEditingController controller;
  TextInputType type;

  bool isPassword = false;
  bool isVisible;

  _InputFieldState(
    this.padding,
    this.margin,
    this.hintText,
    this.controller,
    this.type,
    this.isPassword,
    this.isVisible,
  );
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 246, 233),
        border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
      ),
      child: TextField(
        obscureText: isPassword ? !isVisible : false,
        controller: controller,
        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: TextStyle(color: MyApp.subColor),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          suffixIcon: isPassword
              ? InkWell(
                  onTap: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  child: Icon(
                      isVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: const Color.fromARGB(255, 111, 111, 111),
                      size: 22))
              : null,
        ),
        style: const TextStyle(fontSize: 15),

        //keyboardType: isVisible ? TextInputType.visiblePassword : TextInputType.emailAddress,
        keyboardType: type,
        cursorColor: Colors.purple,
        // onChanged: (value){
        //   setState(() {

        //   });
        // }
      ),
    );
  }
}
