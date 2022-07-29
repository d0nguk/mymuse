import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'c_global.dart';

class ReserveButton extends StatefulWidget {

  final DateTime time;
  final int day;

  late ReserveButtonState value;

  ReserveButton({Key? key, required this.time, required this.day}) : super(key: key);

  @override
  //State<ReserveButton> createState() => ReserveButtonState(time, day);
  // ignore: no_logic_in_create_state
  State<ReserveButton> createState() {
    value = ReserveButtonState(time, day);
    return value;
  }
}

class ReserveButtonState extends State<ReserveButton> {

  DateTime time;
  int day;

  late int hour;
  late bool breserve = true;
  late DateTime checkTime;

  ReserveButtonState(this.time, this.day);
  late String _tmp;

  set setTime(DateTime newtime) => setState(() => {
    time = newtime,

    _tmp = convertDateToString(time),

    if(service.reserve.containsKey(_tmp)) {
      breserve = false,
    }
    else {
      breserve = time.compareTo(checkTime) >= 0 ? true : false,
    },
  });

  @override
  void initState() {
    super.initState();

    hour = time.hour;
    checkTime = DateTime.now();
    checkTime = checkTime.add(const Duration(minutes: 30));
    breserve = time.compareTo(checkTime) >= 0 ? true : false;

    setTime = time;
  }

  void reserve() async {
    Map reserve = service.reserve;

    if(service.authority > 2) {
      if(!checkReserveCount(time)) {

        createSnackBar(context, "해당 날짜에 더이상 예약을 할 수 없습니다.");

        return;    
      }
    }

    reserve[convertDateToString(time)] = service.user.name;

    var store = FirebaseFirestore.instance;
    var acadmey = await store.collection("Academies").doc(service.academy).update(
      {"Reserve": reserve}
    );

    var userReserve = service.user.reserve;
    userReserve[convertDateToString(time)] = service.academy;
    var user = await store.collection("Users").doc(service.user.email).update(
      {"Reserve": userReserve}
    );

    setState(() {
      breserve = false;
      createSnackBar(context, "예약되었습니다.");
      //showToast("Success");
    });
  }

  @override
  Widget build(BuildContext context) {

    return TextButton(
      onPressed: breserve ? reserve : null,
      // style: ButtonStyle(
        
      // ),
      child: Text(
        (time.hour >= 10 ? "${time.hour}:00 ~ ${time.hour+1}:00" : 
          time.hour == 9 ? "0${time.hour}:00 ~ ${time.hour+1}:00" :
          "0${time.hour}:00 ~ 0${time.hour+1}:00") + "\n" + 
          (breserve ? "예약 가능" : "예약 불가능")
      ),
    );
  }
}

class ReserveTable {

  DateTime day;
  int open, close;

  List<ReserveButton> buttons = [];

  ReserveTable() :
    //day = DateTime(2022,6,1),
    day = DateTime.now(),
    // 학원 정보 받아와서 데이터 세팅
    open = 6,
    close = 22 {

    generateButtons();
    
  }

  void generateButtons() {

    buttons = List.generate(
      close - open + 1,
      (index) => ReserveButton(
          time: DateTime(day.year, day.month, day.day, open + index, 0),
          day: day.day,
          key: Key(index.toString())
        ),
      growable: true);
  }

  void changeButtons(DateTime newDate, int newRoom) { 
    //day = newDate;

    day = newDate;
    int index = 0;
    for(var item in buttons) {
      item.value.setTime = DateTime(day.year, day.month, day.day, open+index, 0, newRoom);
      ++index;
    }
  }

  // void refreshData(List<String> reserves) {
  //   buttons.clear();

  //   generateButtons();
  // }

  List<ReserveButton> getButtons() {
    return buttons;
  }

  void noSuchMethod(Invocation invocation) {
    print('You tried to use a non-existent member: ' + '${invocation.memberName}');
  }
}