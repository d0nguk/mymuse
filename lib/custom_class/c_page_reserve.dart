import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'c_global.dart';
import 'c_reservebutton.dart';

class ReserveWidget extends StatefulWidget {
  const ReserveWidget({Key? key}) : super(key: key);

  @override
  State<ReserveWidget> createState() => _ReserveWidgetState();
}

class _ReserveWidgetState extends State<ReserveWidget> {

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  late ReserveTable res;
  late Map _reserveList;
  late int addDays;

  List<String> _roomList = [];
  dynamic _selectedRoom;

  @override
  void initState() {
    super.initState();

    addDays = service.authority <= 2 ? 21 : 14;

    _roomList = List.generate(service.room, (index) => "연습실${index+1}");
    _selectedRoom = _roomList[0];

    res = ReserveTable();
  }

  Future<String> getReserveList() async {

    var store = FirebaseFirestore.instance;
    var v = await store.collection("Academies").doc(service.academy).get();

    String res = "";

    try {
      _reserveList = await v.get("Reserve");

      service.curReserve = _reserveList;

      res = "Success";
    }
    on FirebaseException catch(e) {
      res = e.message.toString();
    }

    return Future(() => res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reserve"),
        actions: <Widget>[
          DropdownButton(
            value: _selectedRoom,
            items: _roomList.map((value) =>  DropdownMenuItem(
              value: value,
              child: Text(value))
            ).toList(),
            onChanged: (value) {
              setState(() {
                _selectedRoom = value;

                res.changeButtons(_selectedDay, _roomList.indexOf(value.toString()));
              });
            },
          )
        ],
      ),
      body: SafeArea(
        child:FutureBuilder(
          future: getReserveList(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData == null) {
              return Center(
                child: Container(
                  width: 100,
                  height: 100,
                  child: const CircularProgressIndicator()
                ),
              );
            }
            else if(snapshot.hasError) {
              return const Text("Load Failed");
            }
            else {
              if(snapshot.data.toString().compareTo("Success") != 0) {
                return Text(snapshot.data.toString());
              }
              else {
                return RefreshIndicator(
                  onRefresh: () async {
                    await getReserveList();

                    setState(() {
                      res.changeButtons(_selectedDay, _roomList.indexOf(_selectedRoom));
                    });

                    return Future<void>.delayed(const Duration(seconds: 0));
                  },
                  child: Column(
                    children: [
                      TableCalendar(
                        locale: 'ko-KR',
                        firstDay: DateTime.now(),
                        lastDay: DateTime.now().add(Duration(days: addDays)),
                        focusedDay: _focusedDay,
                        calendarFormat: CalendarFormat.twoWeeks,
                        headerStyle: const HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          leftChevronVisible: true,
                          rightChevronVisible: true,
                        ),
                        calendarStyle: const CalendarStyle(
                          outsideDaysVisible: false,
                        ),
                        availableGestures: AvailableGestures.none,
                        selectedDayPredicate: (day) {
                          return isSameDay(day, _selectedDay);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                
                            res.changeButtons(selectedDay, _roomList.indexOf(_selectedRoom));
                          });
                        },
                      ),
                      Expanded(
                        child: GridView(
                          //physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3,
                            mainAxisSpacing: 5.0,
                            crossAxisSpacing: 5.0,
                          ),
                          padding: const EdgeInsets.all(5),
                          children: res.getButtons(),
                        ),
                      ),
                    ],
                  ),
                );                
              }
            }
          }
        ),
      ),
    );
  }
}