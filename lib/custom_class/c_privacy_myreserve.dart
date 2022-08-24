import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'c_global.dart';
import 'c_reservecancelbutton.dart';

class MyReserveWidget extends StatefulWidget {
  const MyReserveWidget({Key? key}) : super(key: key);

  @override
  State<MyReserveWidget> createState() => _MyReserveWidgetState();
}

class _MyReserveWidgetState extends State<MyReserveWidget> {
  
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  late bool _visible = false;

  @override
  void initState() {
    super.initState();

    reserveCancelTable.init(_focusedDay, setVisibility);
  }

  void setVisibility() {
    setState(() {
      _visible = !_visible;
    });
  }

  Future<String> getReserveList() async {

    var store = FirebaseFirestore.instance;
    var v = await store.collection("Users").doc(service.user.email).get();

    var r = await v.get("Reserve");


    return Future(() => "Success");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WillPopScope(
          child: Scaffold(
            appBar: AppBar(
              title: const Text("내 예약"),
            ),
            body: SafeArea(
              child: FutureBuilder(
                future: getReserveList(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.hasData == false) {
                    return CircularProgressIndicator();
                  }
                  else if(snapshot.hasError) {
                    return Text("Error");
                  }
                  else {
                    return RefreshIndicator(
                      onRefresh: () async {
        
                      },
                      child: Column(
                        children: [
                          TableCalendar(
                            locale: 'ko-KR',
                            firstDay: DateTime(2022,7,1),
                            lastDay: DateTime.now().add(const Duration(days: 14)),
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
                                reserveCancelTable.changeButtons(_selectedDay);
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
                              //children: res.getButtons(),
                              children: reserveCancelTable.getButtons(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          onWillPop: _visible ? () {
            return Future(() => false);
          } : null,
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