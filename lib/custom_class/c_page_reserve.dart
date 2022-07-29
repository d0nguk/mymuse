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

  //late ReserveTable res;
  late Map _reserveList;
  late int addDays;
  late bool _visible = false;

  List<String> _roomList = [];
  dynamic _selectedRoom;

  @override
  void initState() {
    super.initState();

    addDays = service.academy.members[service.user.name]["Auth"] <= 2 ? 21 : 14;

    _roomList = List.generate(service.academy.settings["Rooms"], (index) => "연습실${index+1}");
    _selectedRoom = _roomList[0];

    //res = ReserveTable();
    reserveTable.init(setVisibility);
  }

  void setVisibility() {
    setState(() {
      _visible = !_visible;
    });
  }

  Future<String> getReserveList() async {

    var store = FirebaseFirestore.instance;
    //var v = await store.collection("Academies").doc(service.academy.name).get();
    var v = await store.collection("Academies").doc(service.academy.name).get();

    String result = "";

    try {
      _reserveList = await v.get("Reserve");

      service.academy.reserve = _reserveList;

      result = "Success";
    }
    on FirebaseException catch(e) {
      result = e.message.toString();
    }

    return Future(() => result);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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

                    reserveTable.changeButtons(_selectedDay, _roomList.indexOf(value.toString()));
                  });
                },
              )
            ],
          ),
          body: SafeArea(
            child:FutureBuilder(
              future: getReserveList(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot.hasData == false) {
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
                          reserveTable.changeButtons(_selectedDay, _roomList.indexOf(_selectedRoom));
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
                    
                                reserveTable.changeButtons(selectedDay, _roomList.indexOf(_selectedRoom));
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
                              children: reserveTable.getButtons(),
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
        ),
        Visibility(
          visible: _visible,
          child: Container(
            color: Colors.grey.withOpacity(0.5),
            child: const Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              )
            )
          )
        )
      ],
    );
  }
}