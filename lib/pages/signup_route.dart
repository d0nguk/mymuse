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
        _displayText = 'Your password is too short';
      });
    } else if (_password.length < 9) {
      setState(() {
        _strength = 0.5;
        _displayText = 'Your password is acceptable but not strong';
      });
    } else {
      if (!letterReg.hasMatch(_password) ||
          !numReg.hasMatch(_password) ||
          !speciReg.hasMatch(_password)) {
        setState(() {
          _strength = 0.75;
          _displayText = 'Your password is strong';
        });
      } else {
        setState(() {
          _strength = 1;
          _displayText = 'Your password is great';
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
      createSnackBar(context, 'Please enter name');
      return;
    }
    else if(checkController(newuserEmailController)){
      createSnackBar(context, 'Please enter email');
      return;
    }
    else if(checkController(newuserPasswordController)){
      createSnackBar(context, 'Please enter password');
      return;
    }

    var instance = FirebaseAuth.instance;
    bool bcomplete = true;

    try {
      print('await 1 enter');
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
    
    List<String> favorited = ["오드럼의드럼스쿨"];
    Map reserve = Map();

    final user = <String, dynamic>{
      "Email" : newuserEmailController.text,
      "Name" : newuserNameController.text,
      "Favorited" : favorited,
      "Reserve" : reserve,
    };

    print('await 2 enter');

    await store.collection('Users').doc(newuserEmailController.text).set(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("SignUp"),
        backgroundColor: Colors.purple,
      ),
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 50),
          child:
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              InputField(
                hintText: 'name',
                padding: const EdgeInsets.only(left: 10),
                margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                controller: newuserNameController,
                type: TextInputType.text,
              ),

            // Email Address
              InputField(
                hintText: 'Email Address',
                padding: const EdgeInsets.only(left: 10),
                margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                controller: newuserEmailController,
                type: TextInputType.emailAddress,
              ),

            // Password
              InputField(
                hintText: 'Password',
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
        
            FilledButton(hintText: Text("Sign Up"), func: signup, mainColor: Colors.purple,)
          ]
        )
      )
    );
  }
}
