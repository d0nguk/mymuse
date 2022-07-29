import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/Material.dart';

import '../custom_class/c_filledbutton.dart';
import '../custom_class/c_global.dart';
import '../custom_class/c_inputfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  
  //var nameController = TextEditingController();
  var emailController = TextEditingController();
  
  void reset() async {
    if(emailController.text.isEmpty){
      //MyApp.createSnackBar(context, 'Please enter email');
      createSnackBar(context, '이메일을 입력해주세요.');
      return;
    }

    var instance = FirebaseAuth.instance;
    bool bcomplete = true;

    try {
      await instance.sendPasswordResetEmail(email: emailController.text);
    } 
    on FirebaseAuthException catch (e) {
      createSnackBar(context, e.code);
      bcomplete = false;
    }
    catch (e) {
      bcomplete = false;
    }

    if(bcomplete){
      createSnackBar(context, '초기화 메일을 발송했습니다. 메일을 확인해주세요.');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 초기화'),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top:50),
        child: Column(
          children: [
            // InputField(
            //   hintText: 'Name',
            //   padding: const EdgeInsets.only(left: 10),
            //   margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
            //   controller: nameController,
            //   type: TextInputType.text,
            // ),

            // Email Address
            InputField(
              hintText: '이메일',
              padding: const EdgeInsets.only(left: 10),
              margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
              controller: emailController,
              type: TextInputType.emailAddress,
            ),
  
            Padding(padding: EdgeInsets.only(top:40)),

            FilledButton(hintText: Text("초기화"), func: reset, mainColor: Colors.purple,)
          ],
        ),
      ),
    );
  }
}