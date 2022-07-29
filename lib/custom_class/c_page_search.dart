import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'c_academy_data.dart';
import 'c_academybutton.dart';
import 'c_debouncer.dart';
import 'c_inputfield.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {

  TextEditingController searchController = TextEditingController();
  List<AcademyData> academies = [];
  List<AcademyButton> buttons = [];
  final Debouncer _debouncer = Debouncer(1000);

  bool isSearch = false;
  String latestContent = "";

  @override
  void initState() {

    searchController.addListener(onSearchChanged);

    super.initState();
  }

  @override
  void dispose() {

    searchController.dispose();

    super.dispose();
  }

/*
  Future<String> getAcademyData() async {
    var store = FirebaseFirestore.instance;
    var snapshot = await store.collection('Academies').get().then((value) {
      var v = value;

      for (var item in v.docs) {
        var name = item.get('Name');
        var members = item.get('Members');
        var reserve = item.get('Reserve');
        var settings = item.get('Settings');
        var searchlist = item.get('SearchList');

        academies.add(SimpleAcademy(name, members, reserve, settings, searchlist));
      }

      setButtonList();
    });
    return Future(() => 'Complete');
  }
*/

  void setButtonList() {
    for (var item in academies) {
      buttons.add(getAcademyButton(item));
    }
  }

  ListView getList() {
    return ListView(children: buttons.length > 0 ? buttons : [Center(child: const Text("검색된 학원이 없습니다."))],);
  }

  AcademyButton getAcademyButton(AcademyData academy) {
    return AcademyButton(name: academy.name, subject: academy.settings["Subject"], msg: academy.name,);
  }

  void onSearchChanged() {
    //_debouncer.run( () => makeQuery() );
    _debouncer.run(() {
      setState(() {
        isSearch = searchController.text.isNotEmpty;
        latestContent = searchController.text;
      });
    },);
  }

  Future<String> makeQuery() async {

    String text = latestContent;

    if (text == "")
      return Future(() => 'TextValue Is Empty');

    var store = FirebaseFirestore.instance;
    bool flag = true;
    await store.collection('Academies').where('SearchList', arrayContains: text).get().then((value) {

      academies.clear();
      buttons.clear();

      if(value.docs.isEmpty == true) {
        flag = false;
        return;// Future(() => 'ResultValue Is Null');
      }

      for (var item in value.docs) {
        AcademyData academy = AcademyData.fromJson(item.data());
        academies.add(academy);
      }

      setButtonList();
    });

    return Future(() => flag.toString() );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex:2, 
          child : Column(
            children: [
              InputField(
                padding: const EdgeInsets.only(left: 10),
                margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                hintText: '검색할 학원 이름을 입력해주세요.',
                controller: searchController,
                type: TextInputType.text,
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),
              const Divider(
                height: 3,
                thickness: 1,
                color: Colors.white
              ),
              const Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
            ],
          ),
        ),
        Flexible(
          flex:9, 
          child : isSearch == false ? Text("검색어를 입력해주세요.") : FutureBuilder(
            future : makeQuery(),
            builder : (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.hasData == false) {
                return const CircularProgressIndicator();
              }
              else if(snapshot.hasError) {
                return const Text('error');
              }
              else {
                print(snapshot.data.toString());
                return getList();
              }      
            },
          )
        ),
      ],
    );

    /*

    */
  }
}