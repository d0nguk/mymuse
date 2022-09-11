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
  late bool basync = false;
  late String _name = "";
  late List<String> errormsg = [
    "예약되었습니다.",
    "예약 가능 횟수를 초과하였습니다.",
    "경고 누적으로 인한 예약 불가 상태입니다.",
    "동일 시각에 이미 예약이 있습니다.",
    "권한이 없습니다.",
  ];

  set setTime(DateTime newtime) => setState(() => {
    time = newtime,

    _tmp = convertDateToString(time),

    if(service.academy.reserve.containsKey(_tmp)) {
      breserve = false,
    }
    else {
      breserve = time.compareTo(checkTime) >= 0 ? true : false,
    },

    if(service.user.reserve.containsKey(convertDateToString(time))) {
      _name = service.user.name,
    }
    else {
      _name = "예약 불가능",
    }
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
    Map reserve = service.academy.reserve;
    var store = FirebaseFirestore.instance;
    //var v = await store.collection("Academies").doc(service.academy.name).get();
    //var settings = await v.get("Settings");

    // 0 : 예약 가능
    // 1 : 예약 횟수 초과
    // 2 : 경고 누적
    // 3 : 예약 중복
    // 4 : 권한 없음
    int reserveState = 0;

    // step . 권한 확인
    Map members = service.academy.members;
    if(!members.containsKey(service.user.email)) {
      createSnackBar(context, "회원이 아닙니다. 회원 등록을 먼저 진행해주세요.");
      reserveTable._func();
      return;
    }

    // step 1. 예약 가능 횟수 체크
    if(service.academy.members[service.user.email]["Auth"] == 3) {
      if(!checkReserveCount(time)) {
        createSnackBar(context, "해당 날짜에 더이상 예약을 할 수 없습니다.");
        reserveTable._func();
        return;
      }
    }

    // step 2. 경고 여부 체크
    String denied = members[service.user.email]["Denied"];
    DateTime now = DateTime.now();

    String nowString = convertDateToString(now).substring(0,8);

    print(denied.compareTo(nowString));
    if(denied.compareTo("99999999") != 0 && denied.compareTo(nowString) > 0) {
      createSnackBar(context, "${denied.substring(0,4)}/${denied.substring(4,6)}/${denied.substring(6,8)}까지 예약이 제한되었습니다. 학원 담당자에게 문의해주세요.");
      reserveTable._func();
      return;
    }

    // step 3. 예약 중복
    String compareKey = convertDateToString(time).substring(0,12);
    for(String item in service.user.reserve.keys) {
      if(item.substring(0,12).compareTo(compareKey) == 0) {
        //reserveState = 3;
        createSnackBar(context, "동일 시각에 이미 예약이 있습니다.");
        reserveTable._func();
        return;
      }
    }

    if(members[service.user.email]["Auth"] == 2 && members[service.user.email]["Remain"] <= 0) {
        createSnackBar(context, "남은 이용권이 없습니다. 학원 관리자에게 문의해주세요.");
        reserveTable._func();
        return;
    }

    if(reserveState == 0) {

      if(members[service.user.email]["Auth"] == 2) {
        members[service.user.email]["Remain"] -=1 ;
      }

      reserve[convertDateToString(time)] = service.user.name;
      await store.collection("Academies").doc(service.academy.name).update(
        {
          "Reserve" : reserve,
          "Members" : members,
        }
      );

      var userReserve = service.user.reserve;
      userReserve[convertDateToString(time)] = service.academy.name;
      await store.collection("Users").doc(service.user.email).update(
        {"Reserve": userReserve}
      );
    }

    setState(() {
      breserve = reserveState == 0 ? false : true;
      createSnackBar(context, errormsg[reserveState]);
      reserveTable._func();
    });
  }

  void _showDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("예약하시겠습니까?"),
          actions: [
            TextButton(
              onPressed: () { 
                Navigator.of(context).pop();
                reserve();
                reserveTable._func();
              },
              child: const Text("예"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("아니오"),
            ),
          ]
        );
      }
    );
  }

  // Widget getLoadingIndicator() {
  //   return const AlertDialog(
  //     content: Center(
  //       child: SizedBox(
  //         width: 50,
  //         height: 50,
  //         child: CircularProgressIndicator(),
  //       )
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {

    return TextButton(
      onPressed: breserve ? _showDialog : null,
      child: Text(
        "${time.hour >= 10 ? "${time.hour}:00 ~ ${time.hour+1}:00" : 
          time.hour == 9 ? "0${time.hour}:00 ~ ${time.hour+1}:00" :
          "0${time.hour}:00 ~ 0${time.hour+1}:00"}\n${breserve ? "예약 가능" : _name}"
      ),
    );
  }
}

ReserveTable reserveTable = ReserveTable();

class ReserveTable {

  DateTime day;
  int open, close;

  late Function _func;

  List<ReserveButton> buttons = [];

  ReserveTable() :
    day = DateTime.now(),
    open = 0,
    close = 23;

  void init(Function func) {
    day = DateTime.now();
    open = service.academy.settings["Open"];
    close = service.academy.settings["Close"] - 1;

    _func = func;

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