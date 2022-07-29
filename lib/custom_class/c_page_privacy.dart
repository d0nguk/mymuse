import 'package:flutter/material.dart';

import 'c_filledbutton.dart';
import 'c_privacy_appinfo.dart';
import 'c_privacy_myreserve.dart';
import 'c_privacy_notice.dart';

class PrivacyWidget extends StatelessWidget {
  PrivacyWidget({Key? key}) : super(key: key);

  late BuildContext _context;

  void testfunc() {

  }

  void changeNoticeTab() {
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => const NoticeWidget())
    );
  }

  void changeAppInfoTab() {
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => const AppInfoWidget())
    );
  }

  void changeReservationTab() {
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => const MyReserveWidget())
    );
  }

  final double fontsize = 18;
  final Color buttonColor = Color.fromARGB(255, 222, 167, 232);

  @override
  Widget build(BuildContext context) {

    _context = context;

    return Container(
      padding: const EdgeInsets.only(top:30),
      margin: const EdgeInsets.only(left:20, right:20),
      child: ListView(children: [
        FilledButton(
          hintText: Text("공지사항", style: TextStyle(fontSize: fontsize)),
          func: changeNoticeTab,
          mainColor: buttonColor,
          width: double.infinity,
          height : 70,
          alignment: Alignment.centerLeft,
        ),
        const Padding(padding: EdgeInsets.only(top:10)),
        FilledButton(
          hintText: Text("알림", style: TextStyle(fontSize: fontsize)),
          func: testfunc,
          mainColor: buttonColor,
          width: double.infinity,
          height : 70,
          alignment: Alignment.centerLeft,
        ),
        const Padding(padding: EdgeInsets.only(top:10)),
        FilledButton(
          hintText: Text("개인정보", style: TextStyle(fontSize: fontsize)),
          func: testfunc,
          mainColor: buttonColor,
          width: double.infinity,
          height : 70,
          alignment: Alignment.centerLeft,
        ),
        const Padding(padding: EdgeInsets.only(top:10)),
        FilledButton(
          hintText: Text("예약확인", style: TextStyle(fontSize: fontsize)),
          func: changeReservationTab,
          mainColor: buttonColor,
          width: double.infinity,
          height : 70,
          alignment: Alignment.centerLeft,
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        FilledButton(
          hintText: Text("어플리케이션 정보", style: TextStyle(fontSize: fontsize)),
          func: changeAppInfoTab,
          mainColor: buttonColor,
          width: double.infinity,
          height : 70,
          alignment: Alignment.centerLeft,
        ),
      ],),
    );
  }
}