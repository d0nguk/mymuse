// ignore_for_file: use_build_context_synchronously, unused_local_variable

import 'package:flutter/material.dart';

//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../custom_class/c_filledbutton.dart';
import '../custom_class/c_global.dart';
import '../custom_class/c_inputfield.dart';

class signup_route extends StatefulWidget {
  const signup_route({Key? key}) : super(key: key);

  @override
  State<signup_route> createState() => _signup_route();
}

class _signup_route extends State<signup_route> {


  var newuserNameController = TextEditingController();
  var newuserEmailController = TextEditingController();
  var newuserPasswordController = TextEditingController();

  bool isemptyemail = true;
  bool isemptyName = true;
  bool isemptypassword = true;

  bool enabledbutton = false;

  late String _email = "";
  late String _password = "";
  late double _strength = 0;
  late String _displayText = "";

  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z0-9].*");
  RegExp speciReg = RegExp(r'.*[!@#$%^&*(),.?":{}|<>].*');

  void _checkPassword(String value) {
    _password = value.trim();

    if (_password.isEmpty) {
      setState(() {
        _strength = 0;
        _displayText = "";
      });
    } else if (_password.length < 6) {
      setState(() {
        _strength = 0.25;
        _displayText = '비밀번호가 너무 짧습니다.';
      });
    } else if (_password.length < 9) {
      setState(() {
        _strength = 0.5;
        _displayText = '적절하지만 강력하진 않은 비밀번호입니다.';
      });
    } else {
      if (!letterReg.hasMatch(_password) ||
          !numReg.hasMatch(_password) ||
          !speciReg.hasMatch(_password)) {
        setState(() {
          _strength = 0.75;
          _displayText = '강력한 비밀번호입니다.';
        });
      } else {
        setState(() {
          _strength = 1;
          _displayText = '매우 강력한 비밀번호입니다.';
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();


    newuserPasswordController.addListener(() {
      setState(() {
        isemptypassword = newuserPasswordController.text.isEmpty;

        enabledbutton = !isemptyName && !isemptyemail && !isemptypassword;

        _checkPassword(newuserPasswordController.text.trim());
      });
    });
  }

  bool checkController(TextEditingController controller){
    return controller.text.isEmpty;
  }

  void signup() async {
    if(checkController(newuserNameController)){
      createSnackBar(context, '이름을 입력하세요');
      return;
    }
    else if(checkController(newuserEmailController)){
      createSnackBar(context, '이메일을 입력하세요');
      return;
    }
    else if(checkController(newuserPasswordController)){
      createSnackBar(context, '비밀번호를 입력하세요');
      return;
    }

    var instance = FirebaseAuth.instance;
    bool bcomplete = true;

    try {
      UserCredential userCredential = await instance.createUserWithEmailAndPassword(
        email: newuserEmailController.text,
        password: newuserPasswordController.text
      );
    } 
    on FirebaseAuthException catch (e) {
      createSnackBar(context, e.code);
      bcomplete = false;
    }
    catch (e) {
      bcomplete = false;
    }

    if(bcomplete){
      createSnackBar(context, 'Your Account is created successfully!');
      Navigator.pop(context);
      setDB();
      instance.currentUser!.updateDisplayName(newuserNameController.text);
    }
  }

  void setDB() async {
    var store = FirebaseFirestore.instance;
    
    List<String> favorited = [];
    Map reserve = Map();

    final user = <String, dynamic>{
      "Email" : newuserEmailController.text,
      "Name" : newuserNameController.text,
      "Favorited" : favorited,
      "Reserve" : reserve,
    };

    await store.collection('Users').doc(newuserEmailController.text).set(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("회원 가입"),
        backgroundColor: Colors.purple,
      ),
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 50),
          child:
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              InputField(
                hintText: '이름',
                padding: const EdgeInsets.only(left: 10),
                margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                controller: newuserNameController,
                type: TextInputType.text,
              ),

            // Email Address
              InputField(
                hintText: '이메일',
                padding: const EdgeInsets.only(left: 10),
                margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                controller: newuserEmailController,
                type: TextInputType.emailAddress,
              ),

            // Password
              InputField(
                hintText: '비밀번호',
                padding: const EdgeInsets.only(left: 10),
                margin: const EdgeInsets.fromLTRB(15, 20, 15, 5),
                isPassword: true,
                controller: newuserPasswordController,
                type: TextInputType.visiblePassword,
              ),

            SizedBox(
              width: 200,
              height: 10,
              child: LinearProgressIndicator(
                value: _strength,
                backgroundColor: Colors.grey[300],
                color: _strength <= 1 / 4 ? Colors.red
                      : _strength == 2 / 4 ? Colors.yellow
                      : _strength == 3 / 4 ? Colors.blue : Colors.green,
                minHeight: 20,
              ),
            ),

            Text(
              _displayText,
              style: const TextStyle(fontSize: 10),
            ),
        
            FilledButton(hintText: Text("회원 가입"), width: 120, func: signup, mainColor: Colors.purple,)
          ]
        )
      )
    );
  }
}
