import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mymuse/custom_class/c_global.dart';
import 'package:mymuse/custom_class/c_privacy_manage.dart';
import 'package:mymuse/pages/login_page.dart';

import 'c_filledbutton.dart';
import 'c_privacy_appinfo.dart';
import 'c_privacy_myreserve.dart';
import 'c_privacy_notice.dart';

class PrivacyWidget extends StatelessWidget {
  PrivacyWidget({Key? key}) : super(key: key);

  late BuildContext _context;

  void changeNotifyTab() {
    createSnackBar(_context, "준비중입니다.");
  }

  void changePrivacyInfoTab() {
    createSnackBar(_context, "준비중입니다.");
  }

  void changeManageTab() {

    if(service.user.manage.isNotEmpty) {
      //createSnackBar(_context, "준비중입니다.");
      Navigator.push(
        _context,
        MaterialPageRoute(builder: (context) => const ManageTab())
      );
    }
    else {
      createSnackBar(_context, "관리할 수 있는 학원이 없습니다.");
    }
  }

  void changeNoticeTab() {
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => const NoticeWidget())
    );
  }

  void changeAppInfoTab() {

    createSnackBar(_context, "준비중입니다.");

    // Navigator.push(
    //   _context,
    //   MaterialPageRoute(builder: (context) => const AppInfoWidget())
    // );
  }

  void changeReservationTab() {
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => const MyReserveWidget())
    );
  }

  void signout() {
    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("로그아웃"),
          content: const Text("정말로 로그아웃하시겠습니까?"),
          actions: [
            ElevatedButton(
              onPressed: () {

                final storage = new FlutterSecureStorage();
                storage.delete(key: "login");

                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(builder: (context) => LoginPage()), 
                  (route) => false
                );

              },
              child: const Text('예')
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('아니오')
            ),
          ],
        );
      }
    );
  }

  void deleteAccount() {
    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("계정 탈퇴"),
          content: const Text("정말로 탈퇴하시겠습니까?"),
          actions: [
            ElevatedButton(
              onPressed: () async {

                await deleteAccountOnDB();

                final storage = new FlutterSecureStorage();
                storage.delete(key: "login");

                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(builder: (context) => LoginPage()), 
                  (route) => false
                );

              },
              child: const Text('예')
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('아니오')
            ),
          ],
        );
      }
    );
  }

  Future<void> deleteAccountOnDB() async {
    var auth = FirebaseAuth.instance;
    var store = FirebaseFirestore.instance;

    print(auth.currentUser);

    await auth.currentUser!.delete();

    await store.collection("Users").doc(service.user.email).delete();
  }

  final double fontsize = 18;
  final Color buttonColor = Color.fromARGB(255, 222, 167, 232);

  @override
  Widget build(BuildContext context) {

    _context = context;

    return Container(
      padding: const EdgeInsets.only(top:30),
      margin: const EdgeInsets.only(left:20, right:20),
      child: ListView(
        children: [
          FilledButton(
            hintText: Text("공지사항", style: TextStyle(fontSize: fontsize)),
            func: changeNoticeTab,
            mainColor: buttonColor,
            width: double.infinity,
            height : 70,
            alignment: Alignment.centerLeft,
          ),
          const Padding(padding: EdgeInsets.only(top:10)),
          // FilledButton(
          //   hintText: Text("알림", style: TextStyle(fontSize: fontsize)),
          //   func: changeNotifyTab,
          //   mainColor: buttonColor,
          //   width: double.infinity,
          //   height : 70,
          //   alignment: Alignment.centerLeft,
          // ),
          // const Padding(padding: EdgeInsets.only(top:10)),
          // FilledButton(
          //   hintText: Text("개인정보", style: TextStyle(fontSize: fontsize)),
          //   func: changePrivacyInfoTab,
          //   mainColor: buttonColor,
          //   width: double.infinity,
          //   height : 70,
          //   alignment: Alignment.centerLeft,
          // ),
          // const Padding(padding: EdgeInsets.only(top:10)),
          FilledButton(
            hintText: Text("예약확인", style: TextStyle(fontSize: fontsize)),
            func: changeReservationTab,
            mainColor: buttonColor,
            width: double.infinity,
            height : 70,
            alignment: Alignment.centerLeft,
          ),
          // const Padding(padding: EdgeInsets.only(top: 10)),
          // FilledButton(
          //   hintText: Text("어플리케이션 정보", style: TextStyle(fontSize: fontsize)),
          //   func: changeAppInfoTab,
          //   mainColor: buttonColor,
          //   width: double.infinity,
          //   height : 70,
          //   alignment: Alignment.centerLeft,
          // ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          FilledButton(
            hintText: Text("학원 관리", style: TextStyle(fontSize: fontsize)),
            func: changeManageTab,
            mainColor: buttonColor,
            width: double.infinity,
            height : 70,
            alignment: Alignment.centerLeft,
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          FilledButton(
            hintText: Text("로그아웃", style: TextStyle(fontSize: fontsize)),
            func: signout,
            mainColor: buttonColor,
            width: double.infinity,
            height : 70,
            alignment: Alignment.centerLeft,
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          FilledButton(
            hintText: Text("계정 탈퇴", style: TextStyle(fontSize: fontsize)),
            func: deleteAccount,
            mainColor: buttonColor,
            width: double.infinity,
            height : 70,
            alignment: Alignment.centerLeft,
          ),
        ],
      ),
    );
  }
}