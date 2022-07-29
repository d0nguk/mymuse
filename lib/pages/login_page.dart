import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../custom_class/c_academy_data.dart';
import '../custom_class/c_filledbutton.dart';
import '../custom_class/c_global.dart';
import '../custom_class/c_inputfield.dart';
import '../custom_class/c_notice.dart';
import '../custom_class/c_user.dart';
import '../main.dart';
import 'forgot_password_page.dart';
import 'main_page.dart';
import 'signup_route.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:myflutterapp/pages/acdemey_info_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var buttontest = GestureDetector();

  bool isemptyemail = true;
  bool isemptypassword = true;

  bool progressVisible = false;

  CustomUser user = CustomUser('','', [], Map());

  //BuildContext _context;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  bool checkController(TextEditingController controller) {
    return controller.text.isEmpty;
  }

  Future<bool> signin() async {
    if (checkController(emailController)) {
      createSnackBar(context, 'Please enter email');
      return false;
    } else if (checkController(passwordController)) {
      createSnackBar(context, 'Please enter password');
      return false;
    }

    setState(() {
      progressVisible = true;
    });

    var instance = FirebaseAuth.instance;
    bool bcomplete = true;

    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      // print('enter FirebaseAuthException Catch');
      // print(e.code);
      createSnackBar(context, e.code);
      bcomplete = false;
    } catch (e) {
      // print('Catch');
      bcomplete = false;
    }

    if(!bcomplete){
      return false;
    }

    if (instance.currentUser!.emailVerified) {
      //String name = instance.currentUser!.displayName.toString();
      String email = instance.currentUser!.email.toString();

      await getDataByDB(email);

      service.curUser = user;

      //Navigator push signin->main

      Navigator.pushAndRemoveUntil(
        context, 
        MaterialPageRoute(builder: (context) => MainPage()), 
        (route) => false
      );
    }
    else {

      setState(() {
        progressVisible = false;
      });

      await instance.currentUser!.sendEmailVerification();
      createSnackBar(context, 'Please verify your email');
    }

    return bcomplete;
  }

  void _showDialog() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(),
        ),
      ),
    );

    bool res = false;

    res = await signin();

    if(!res)
      Navigator.of(context).pop();
  }

  Future<void> getDataByDB(String email) async{
    var store = FirebaseFirestore.instance;

    String name = "";
    List<String> favorited = [];
    Map reserve = Map();

    var v = await store.collection('Users').doc(email).get();

    for (var item in await v.get('Favorited')) {
      favorited.add(item);
    }
    name = await v.get('Name');
    reserve = await v.get('Reserve');

    user.email = email;
    user.name = name;
    user.favorited = favorited;
    user.reserve = reserve;

    return;
  }

  Future<void> testDB() async {
/*
    String academyName = "임시학원3";
    var members = Map();
    var member = Map();
    var reserve = Map();
    var settings = Map();
    var searchList = [];

    member["Name"] = "김동욱";
    member["Auth"] = 3;
    member["Denied"] = "99999999";
    member["Warning"] = 0;
    member["Reserve"] = [];

    members[member["Name"]] = member;

    settings["Open"] = 6;
    settings["Close"] = 23;
    settings["Rooms"] = 2;
    settings["Subject"] = "보컬";

    int len = academyName.length;
    for(int i = 0; i < len; ++i) {
      for(int j = 1; j < len - i + 1; ++j) {
        // first 0 ~ len-1 _ 1 char
        // second 0 ~ len-2 _ 2 char
        // .....
        // last all characters
        // print(academyName.substring(j-1, j + i));
        searchList.add(academyName.substring(j-1, j + i));
      }
    }

    AcademyData academy = AcademyData(
      academyName, members, reserve, settings, searchList
    );

    //await store.collection("Academies").doc(academyName).set(academy.toJson());
    await store.collection("Academies").doc(academyName).set(academy.toJson());

*/  
    
    // CustomUser my = CustomUser(
    //   "",
    //   "김성은",
    //   [],
    //   Map()
    // );

    // var store = FirebaseFirestore.instance;
    // await store.collection("Users").doc(my.email).set(my.toJson());

    // FirebaseAuth.instance.currentUser!.updateDisplayName("김동욱");

/*
    Notice notice;
    String noticeHead = "공지사항3";
    DateTime time = DateTime(2022,7,21,17,00);
    String noticeBody = "임시 공지사항입니다.\n";

    notice = Notice(Timestamp.fromDate(time), noticeHead, noticeBody);

    var store = FirebaseFirestore.instance;
    //await store.collection("Notice").doc(noticeHead).set(notice.toJson());
    await store.collection("Notice").doc(noticeHead).set(notice.toJson());
*/

/*

    final ref = FirebaseStorage.instance.ref().child('Academy/임시학원3/icon.png');

    String res = "";

    try {
      res = await ref.getDownloadURL();

      res = convertFromHTTPSToGS(res);

      print(res);
    }
    on FirebaseException catch (e) {
      res = e.message.toString();
    }
*/

    var store = FirebaseFirestore.instance;
    var v = await store.collection("Academies").doc("오드럼의드럼스쿨").get();

    var members = await v.get("Members");

    print(members["김동욱"]["Auth"]);

//    print(await v.get("Members"));
  }

  void signup() { 
    Navigator.push( 
        context, 
        MaterialPageRoute(builder: (context) => const signup_route())
    );
  }

  void reset() {
    Navigator.push( 
        context, 
        MaterialPageRoute(builder: (context) => const ForgotPasswordPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'my muse',
                    style: TextStyle(
                      fontSize: 44,
                      color: Colors.black,
                    ),
                  ),
                  InputField(
                    hintText: 'Email Address',
                    padding: const EdgeInsets.only(left: 10),
                    margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                    controller: emailController,
                    type: TextInputType.emailAddress,
                  ),
                  InputField(
                    hintText: 'Password',
                    padding: const EdgeInsets.only(left: 10),
                    margin: const EdgeInsets.fromLTRB(15, 20, 15, 25),
                    isPassword: true,
                    controller: passwordController,
                    type: TextInputType.visiblePassword,
                  ),
          
                  FilledButton(hintText: const Text('Sign in'), func: _showDialog, mainColor: MyApp.mainColor),
          
                  const Padding(padding: EdgeInsets.only(top:30)),
          
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                    ),
                    onPressed: signup,
                    child: const Text('Sign up'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                    ),
                    onPressed: reset,
                    child: const Text('Forgot Password'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                    ),
                    onPressed: testDB,
                    child: const Text('DB Test Button'),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Visibility(
        //   visible: progressVisible,
        //   child: const Center(
        //     child: SizedBox(
        //       width: 250,
        //       height: 250,
        //       child: CircularProgressIndicator(),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
/*
// ignore: must_be_immutable
class InputField extends StatefulWidget {
  
  final EdgeInsets padding;
  final EdgeInsets margin;
  final String hintText;

  bool isPassword = false;
  bool isVisible;

  InputField({
    Key? key,
    required this.padding,
    required this.margin,
    required this.hintText,
    this.isPassword = false,
    this.isVisible = false}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<InputField> createState() => _InputFieldState(
    padding, margin, hintText, isPassword, isVisible
  );
}

class _InputFieldState extends State<InputField> {
  
  EdgeInsets padding;
  EdgeInsets margin;
  String hintText;

  bool isPassword = false;
  bool isVisible;

  _InputFieldState(
    this.padding,
    this.margin,
    this.hintText,
    this.isPassword,
    this.isVisible);

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
        decoration: InputDecoration(
          labelText: hintText,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          suffixIcon: isPassword ? InkWell(
            onTap: () {
              setState(() {
                isVisible = !isVisible;
              });
            },
            child: Icon(
              isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: const Color.fromARGB(255, 111, 111, 111),
              size: 22
            )
          ) : null,
        ),
        style: const TextStyle(fontSize: 15),
        keyboardType: isVisible ? TextInputType.visiblePassword : TextInputType.emailAddress,
      ),
    );
  }
}
*/
