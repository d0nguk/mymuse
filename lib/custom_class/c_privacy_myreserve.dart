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

  late ReserveCancelTable _table;

  @override
  void initState() {
    super.initState();

    _table = ReserveCancelTable(_focusedDay);
  }

  Future<String> getReserveList() async {

    var store = FirebaseFirestore.instance;
    var v = await store.collection("Users").doc(service.user.email).get();

    var r = await v.get("Reserve");


    return Future(() => "Success");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                //DateTime tmp = convertStringToDate("202207111500_001");
                //return Text(tmp.toString());
                // return const Text("Success");

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

                            _table.changeButtons(_selectedDay);
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
                          children: _table.getButtons(),
                        ),
                      ),
                    ],
                  ),
                );

                // return RefreshIndicator(
                  //     child: GridView(
                  //     //physics: const NeverScrollableScrollPhysics(),
                  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //       crossAxisCount: 2,
                  //       childAspectRatio: 3,
                  //       mainAxisSpacing: 5.0,
                  //       crossAxisSpacing: 5.0,
                  //     ),
                  //     padding: const EdgeInsets.all(5),
                  //     children: _table.getButtons(),
                  //   ),
                  //   onRefresh: () async {
                  //     print("Refresh");
                  //     return Future<void>.delayed(const Duration(seconds: 0));
                  //   }
                  // );
              }
            },
          ),
        ),
      );
  }
}