import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'c_global.dart';

class ReserveCancelButton extends StatefulWidget {

  final DateTime time;
  final bool init;
  final String academy;

  late ReserveCancelButtonState value;

  ReserveCancelButton({Key? key, required this.time, required this.init, required this.academy}) : super(key: key);

  @override
  //State<ReserveButton> createState() => ReserveButtonState(time, day);
  // ignore: no_logic_in_create_state
  State<ReserveCancelButton> createState() {
    value = ReserveCancelButtonState(time, init, academy);
    return value;
  }
}

class ReserveCancelButtonState extends State<ReserveCancelButton> {
  
  DateTime _time;
  bool _init;
  String _academy;

  ReserveCancelButtonState(this._time, this._init, this._academy);

  @override
  void initState() {
    super.initState();

    for(String item in service.user.reserve.keys) {
      if(item.substring(0,12).compareTo(convertDateToString(_time).substring(0,12)) == 0) {
        _academy = service.user.reserve[item];
        _time.add(Duration(seconds: int.parse(item.substring(13,16))));
      }
    }
  }

  void cancelReserve() async { 
    var store = FirebaseFirestore.instance;

    var v = await store.collection("Users").doc(service.user.email).get();

    Map userReserve = await v.get("Reserve");

    String removeKey = convertDateToString(_time);

    userReserve.remove(removeKey);
    
    print(userReserve);

    service.user.reserve.remove(removeKey);
    await store.collection("Users").doc(service.user.email).update(
      {"Reserve" : userReserve}
    );

    v = await store.collection("Academies").doc(_academy).get();

    Map academyReserve = await v.get("Reserve");
    academyReserve.remove(removeKey);

    await store.collection("Academies").doc(_academy).update(
      {"Reserve" : academyReserve}
    );

    setState(() {
      _academy = "NotReserve";
      createSnackBar(context, "예약이 취소되었습니다.");
    });
  }

  DateTime get getData => _time;

  set setData(String _data) => setState(() => {
    _time = convertStringToDate(_data.substring(0,16)),
    _academy = _data.substring(16),
  });

  set setInitialize(bool init) => _init = init;
  get init => _init;

  @override
  Widget build(BuildContext context) {

    return TextButton(
      onPressed: _academy.compareTo("NotReserve") != 0 ? cancelReserve : null,
      // style: ButtonStyle(
        
      // ),
      child: Text(
        ("${_academy}\n"
        + (_time.hour >= 10 ? "${_time.hour}:00 ~ ${_time.hour+1}:00" : 
          _time.hour == 9 ? "0${_time.hour}:00 ~ ${_time.hour+1}:00" :
          "0${_time.hour}:00 ~ 0${_time.hour+1}:00")),
      ),
    );
  }
}

class ReserveCancelTable {

  DateTime day;

  List<ReserveCancelButton> buttons = [];
  List<String> _reserveList = [];

  ReserveCancelTable(DateTime start) :
    day= start {
      generateButtons();
  }

  void generateButtons() {
    buttons = List.generate(
      24,
      (index) => ReserveCancelButton(
        time : DateTime(day.year, day.month, day.day, index, 0, 0),
        academy: "NotReserve",
        init : false,
        key: Key(index.toString()),
      ),
      growable: true
    );
  }

  void changeButtons(DateTime newDate) {

    day = newDate;

    String compareKey = convertDateToString(day);
    compareKey = compareKey.substring(0,8);

    _reserveList.clear();

    for(var item in service.user.reserve.keys) {
      if(item.substring(0,8).compareTo(compareKey) == 0) {
        _reserveList.add(item + service.user.reserve[item]);
      }
    }

    int index = 0;

    for(var item in buttons) {
      DateTime _newDate = DateTime(day.year, day.month, day.day, index, 0, 0);
      item.value.setData = convertDateToString(_newDate) + "NotReserve";
      ++index;
    }

    for(var reserve in _reserveList) {

      String _reserve = reserve.substring(0,12) + "_000";
      DateTime compareTime = convertStringToDate(_reserve);

      for(var item in buttons) {

        if(compareTime.compareTo(item.value.getData) == 0) {
          item.value.setData = reserve;
          break;
        }
      }
    }
  }

  List<ReserveCancelButton> getButtons() {
    return buttons;
  }
}