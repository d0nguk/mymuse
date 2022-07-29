import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'c_academy_data.dart';
import 'c_academybutton.dart';
import 'c_global.dart';

class FavoritedWidget extends StatefulWidget {
  final bool empty;
  const FavoritedWidget({Key? key, required this.empty}) : super(key: key);

  @override
  State<FavoritedWidget> createState() => _FavoritedWidgetState(empty);
}

class _FavoritedWidgetState extends State<FavoritedWidget> {

  bool empty;
  List<AcademyButton> buttons = [];

  _FavoritedWidgetState(this.empty);

  @override
  void setState(VoidCallback fn) {

    empty = service.user.favorited.isEmpty;

    super.setState(fn);
  }

  Future<String> getList() async {

    var store = FirebaseFirestore.instance;

    for (String item in service.user.favorited) {
      
      var v = await store.collection('Academies').doc(item).get();
      var name = await v.get("Name");
      var members = await v.get("Members");
      var reserve = await v.get("Reserve");
      var settings = await v.get("Settings");
      var searchlist = await v.get("SearchList");

      AcademyData academy = AcademyData(name, members, reserve, settings, searchlist);

      buttons.add(AcademyButton(
          name: academy.name,
          subject: academy.settings["Subject"],
          msg: academy.name
      ));
    }

    return Future(() => "Complete" );
  }

  Widget makeViewByList() {
    if(service.user.favorited.isEmpty) {
      return Text('There is no item');
      // return ListView(
      //   children: [
      //     AcademyButton(msg: 'My'),
      //     AcademyButton(msg: 'Name'),
      //     AcademyButton(msg: 'Is'),
      //     AcademyButton(msg: 'GimDonGuk'),
      //   ],
      // );
      // return FilledButton(hintText: Text('asdf'), func: addList, mainColor: Colors.purple);
    }
    else {
      return FutureBuilder(
        future: getList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            // 크기 조절하기
            return Center(
              child: Container(
                width: 100,
                height: 100,
                child: const CircularProgressIndicator()
              ),
            );
          } else if (snapshot.hasError) {
            return const Text('error');
          } else {
            return ListView(children: buttons);
          }
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return makeViewByList();
  }
}