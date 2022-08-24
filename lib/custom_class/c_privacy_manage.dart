import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mymuse/custom_class/c_global.dart';

import '../main.dart';
import 'c_filledbutton.dart';

class ManageTab extends StatefulWidget {
  const ManageTab({Key? key}) : super(key: key);

  @override
  State<ManageTab> createState() => _ManageTabState();
}

class _ManageTabState extends State<ManageTab> {

  List<String> _academyList = [];
  dynamic _selectedAcademy;

  List<String> _startList = [];
  dynamic _selectedStart;

  List<String> _endList = [];
  dynamic _selectedEnd;

  late Map _settings = Map();

  late String _academyType;
  late String _academySubject;

  late Map oldUser = Map();
  late Map changedUser = Map();
  List<MapEntry<String, dynamic>> _listFromMap = [];

  @override
  void initState() {
    super.initState();

    _academyList = service.user.manage;
    _selectedAcademy = _academyList[0];

    _startList = List.generate(24, (index) => "$index");
    _selectedStart = _startList[0];

    _endList = List.generate(24, (index) => "${index+1}");
    _selectedEnd = _endList[23];
  }

  Future<String> getAcademyInfo() async {

    String res = "Success";

    if(!_settings.containsKey(_selectedAcademy)) {
      var store = FirebaseFirestore.instance;
      var v = await store.collection("Academies").doc(_selectedAcademy).get();

      try{ 
        var academySettings = await v.get("Settings");

        _settings[_selectedAcademy] = academySettings;
      }
      on FirebaseException catch (e){
        res = "${e.message}// on get settings";
      }
    }

    if(!oldUser.containsKey(_selectedAcademy)) {
      var store = FirebaseFirestore.instance;
      var v = await store.collection("Academies").doc(_selectedAcademy).get();

      try {
        var users = await v.get("Members");

        oldUser[_selectedAcademy] = users;
      }
      on FirebaseException catch(e) {
        res = "${e.message}// on get members";
      }
    }

    _selectedStart = _settings[_selectedAcademy]["Open"].toString();
    _selectedEnd = _settings[_selectedAcademy]["Close"].toString();
    _academyType = _settings[_selectedAcademy]["Type"];
    _academySubject = _settings[_selectedAcademy]["Subject"];

    changedUser = oldUser[_selectedAcademy];

    _listFromMap.clear();
    for (dynamic item in changedUser.entries) {
      //print(item.runtimeType);
      _listFromMap.add(item);
    }

    return Future(() => res);
  }

  void testfunc() {
    createSnackBar(context, "ASDF");
  }

  void manageUser() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("유저 관리"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.grey,
                width: 300,
                height: 300,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _listFromMap.length,//_listFromMap.length,
                  itemBuilder: (BuildContext _btx, int index) {
                    return ListTile(
                      title: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ExpansionTile(
                            title: Text("${_listFromMap[index].key}"),
                            subtitle: Text("${service.authList[_listFromMap[index].value["Auth"]]}"),
                            textColor: const Color.fromARGB(255, 222, 167, 232),
                            iconColor: const Color.fromARGB(255, 222, 167, 232),
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(title: Text("${_listFromMap[index].key}의 상세 내용입니다")),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('가자')
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('싫어')
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("학원 관리"),
        actions: <Widget>[
          DropdownButton(
            value: _selectedAcademy,
            items: _academyList.map((value) =>  DropdownMenuItem(
              value: value,
              child: Text(value))
            ).toList(),
            onChanged: (value) {
              setState(() {
                _selectedAcademy = value;
              });
            },
          )
        ],
        backgroundColor: MyApp.mainColor,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getAcademyInfo(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData == false) {
              return const Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator()
                ),
              );
            }
            else if(snapshot.hasError) {
              return const Center(child: Text("Error Occured!"));
            }
            else {
              return Column(
                children: [
            
                  const Padding(padding: EdgeInsets.only(top: 10),),
                  
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 4,
                          child: Center(child: Text("시작")),
                        ),
                        Expanded(
                          flex: 6,
                          child: Center(
                            child: DropdownButton(
                              value: _selectedStart,
                              items: _startList.map((value) =>  DropdownMenuItem(
                                value: value,
                                child: Center(child: Text(value)))
                              ).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedStart = value;
                                });
                              },
                            ),
                          )
                        ),
                      ]
                    ),
                  ),
            
                  //const Padding(padding: EdgeInsets.only(top: 10),),
                  const Divider(color: Colors.black),
            
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 4,
                          child: Center(child: Text("종료")),
                        ),
                        Expanded(
                          flex: 6,
                          child: Center(
                            child: DropdownButton(
                              value: _selectedEnd,
                              items: _endList.map((value) =>  DropdownMenuItem(
                                value: value,
                                child: Center(child: Text(value)))
                              ).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedEnd = value;
                                });
                              },
                            ),
                          ),
                        )
                      ]
                    ),
                  ),

                  //const Padding(padding: EdgeInsets.only(top: 10),),
                  const Divider(color: Colors.black),
            
                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 4,
                          child: Center(child: Text("종류")),
                        ),
                        Expanded(
                          flex: 6,
                          child: Center(child: Text(_academyType)),
                        ),
                      ]
                    ),
                  ),

                  //const Padding(padding: EdgeInsets.only(top: 10),),
                  const Divider(color: Colors.black),

                  SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 4,
                          child: Center(child: Text("악기")),
                        ),
                        Expanded(
                          flex: 6,
                          child: Center(child: Text(_academySubject)),
                        ),
                      ]
                    ),
                  ),

                  //const Padding(padding: EdgeInsets.only(top: 10),),
                  const Divider(color: Colors.black),

                  FilledButton(
                    width: 200,
                    hintText: const Text('회원 관리'),
                    func: manageUser,
                    mainColor: MyApp.mainColor
                  ),

                  //const Padding(padding: EdgeInsets.only(top: 10),),
                  const Divider(color: Colors.black),

                  FilledButton(
                    width: 200,
                    hintText: const Text('변경사항 저장'),
                    func: testfunc,
                    mainColor: MyApp.mainColor
                  ),

                ],
              );
            }
          }
        ),
      ),
    );
  }
}

