import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mymuse/custom_class/c_global.dart';
import 'package:mymuse/custom_class/c_user.dart';

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

  late String _academyType;
  late String _academySubject;

  late final Map<String, Map<String, dynamic>> _settings = Map();
  late final Map<String, Map<String, dynamic>> _settingsChanged = Map();

  late Map<String, Map<String, dynamic>> oldUser = Map();
  late Map<String, Map<String, dynamic>> changedUser = Map();
  final List<MapEntry<String, dynamic>> _listFromMap = [];
  
  late Map request = Map();
  List<MapEntry<String, dynamic>> requestList = [];

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

        _settings[_selectedAcademy] = Map();
        _settingsChanged[_selectedAcademy] = Map();

        _settings[_selectedAcademy]!.addAll(academySettings);
        _settingsChanged[_selectedAcademy]!.addAll(academySettings);
      }
      on FirebaseException catch (e){
        res = "${e.message}// on get settings";
      }
    }

    var store = FirebaseFirestore.instance;
    var v = await store.collection("Academies").doc(_selectedAcademy).get();

    if(!oldUser.containsKey(_selectedAcademy)) {
      try {
        var users = await v.get("Members");

        oldUser[_selectedAcademy] = Map();
        oldUser[_selectedAcademy]!.addAll(users);
        changedUser[_selectedAcademy] = Map();
        changedUser[_selectedAcademy]!.addAll(users);

        print(users);

        var req = await v.get("Request");

        request = req;
      }
      on FirebaseException catch(e) {
        res = "${e.message}// on get members";
      }
    }

    //_settingsChanged[_selectedAcademy]["Open"];

    _selectedStart = _settingsChanged[_selectedAcademy]!["Open"].toString();
    _selectedEnd = _settingsChanged[_selectedAcademy]!["Close"].toString();
    _academyType = _settingsChanged[_selectedAcademy]!["Type"].toString();
    _academySubject = _settingsChanged[_selectedAcademy]!["Subject"].toString();

    requestList.clear();
    for(dynamic item in request.entries) {
      requestList.add(item);
    }

    return Future(() => res);
  }

  void changeSettings() async {
    if(!mapEquals(_settings[_selectedAcademy], _settingsChanged[_selectedAcademy])) {
      var store = FirebaseFirestore.instance;
      await store.collection("Academies").doc(_selectedAcademy).update({
        "Settings" : _settingsChanged[_selectedAcademy],
      });

      setState(() {
        _settings.remove(_selectedAcademy);
        _settings[_selectedAcademy] = Map();
        _settings[_selectedAcademy]!.addAll(_settingsChanged[_selectedAcademy]!);
      });

      // ignore: use_build_context_synchronously
      createSnackBar(context, "?????????????????????!");
    }
    else {
      setState(() {
        _settingsChanged.remove(_selectedAcademy);
        _settingsChanged[_selectedAcademy] = Map();
        _settingsChanged[_selectedAcademy]!.addAll(_settings[_selectedAcademy]!);
      });

      createSnackBar(context, "?????? ????????? ????????????.");
    }
  }

  late String _selectedUserAuth;

  void manageUser() {

    changedUser[_selectedAcademy]!.remove(_selectedAcademy);
    for(var item in oldUser[_selectedAcademy]!.keys) {
      Map tmp = Map();

      tmp.addAll(oldUser[_selectedAcademy]![item]);
      changedUser[_selectedAcademy]![item] = tmp;
    }

    _listFromMap.clear();
    for(dynamic maps in changedUser[_selectedAcademy]!.keys) {
      // for(dynamic item in changedUser[_selectedAcademy]!.values) {
      //   print(item);
      // }
      _listFromMap.add(MapEntry(maps, changedUser[_selectedAcademy!]![maps]));
    }

    //changedUser[_selectedAcademy]!.addAll(oldUser[_selectedAcademy]!);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {

        //return StatefulBuilder(BuildContext _statefulBuilder, StateSetter _statefulSetState) {
        return StatefulBuilder(builder: (BuildContext _statefulBuilder, StateSetter _statefulSetState) {
          return AlertDialog(
            title: const Text("?????? ??????"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.grey,
                  width: 300,
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _listFromMap.length,
                    itemBuilder: (BuildContext _btx, int index) {

                      _selectedUserAuth = service.authList[_listFromMap[index].value["Auth"]];

                      return StatefulBuilder(
                        builder: (((_context, listTileSetState) {
                          return ListTile(
                            title: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: ExpansionTile(
                                  childrenPadding: const EdgeInsets.only(left: 10, right: 10),
                                  expandedAlignment: Alignment.centerLeft,
                                  title: Text("${_listFromMap[index].value["Name"]}"),
                                  subtitle: Text(service.authList[_listFromMap[index].value["Auth"]]),
                                  textColor: const Color.fromARGB(255, 222, 167, 232),
                                  iconColor: const Color.fromARGB(255, 222, 167, 232),
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // ListTile(
                                        //   title: Text("?????????\n- ${_listFromMap[index].key}", style: TextStyle(fontSize: 11)),
                                        // ),
                                        Text("?????????\n- ${_listFromMap[index].key}", style: const TextStyle(fontSize: 13), ),
                                        Text("?????? ??????\n- ${_listFromMap[index].value["Warning"]}???", style: const TextStyle(fontSize: 13), ),
                                        Text("?????? ??????\n- ${_listFromMap[index].value["Auth"] == 2 ? "${_listFromMap[index].value["Remain"]}???" : "???????????? ??????"}", style: const TextStyle(fontSize: 13), ),
                                        DropdownButton(
                                          //style: TextStyle(fontSize: 13),
                                          value: _selectedUserAuth,//service.authList[_listFromMap[index].value["Auth"]],
                                          items: service.authList.map(
                                            (value) =>  DropdownMenuItem(
                                              value: value,
                                              child: Text(value)
                                            )
                                          ).toList(),
                                          onChanged: (value) {
                                            listTileSetState(() {
                                              _selectedUserAuth = value.toString();
                                              //_listFromMap[index].value["Auth"] = service.authList.indexOf(value.toString());
                                              changedUser[_selectedAcademy]![_listFromMap[index].key]["Auth"] = service.authList.indexOf(value.toString());
                                            });
                                          },
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            FilledButton(hintText: const Text("!"), func: () { 
                                              addWarning(index, _statefulSetState);
                                            }, mainColor: Colors.blue, width: 60, height: 30),
                                            FilledButton(hintText: const Text("+"), func: () { 
                                              addCount(index, _statefulSetState);
                                            }, mainColor: Colors.blue, width: 60, height: 30),
                                            FilledButton(hintText: const Text("??????"), func: () { 
                                              saveMember(index, _context);
                                            }, mainColor: Colors.blue, width: 60, height: 30),
                                            //SizedBox(width: 20, height: 20, child: Container(color: Colors.red)),
                                            //SizedBox(width: 20, height: 20, child: Container(color: Colors.red)),
                                            //SizedBox(width: 20, height: 20, child: Container(color: Colors.red)),
                                          ],
                                        ),
                                        //Container(width: 500, height:500, color: Colors.red,)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })),
                      );
                    },
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('??????')
              ),
              // ElevatedButton(
              //   onPressed: () => Navigator.of(context).pop(),
              //   child: const Text('')
              // ),
            ],
          );
        });
      }
    );
  }

  //String _baseAuth = service.authList[3];
  String _selectedAuth = service.authList[3];

  void manageRequest() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return StatefulBuilder(
          builder: (BuildContext _statefulBuildContext, StateSetter setState1) {
            return AlertDialog(
            title: const Text("?????? ??????"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.grey,
                  width: 300,
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: requestList.length,
                    itemBuilder: (BuildContext _btx, int index) {
                      return ElevatedButton(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(padding: EdgeInsets.only(top:10)),
                            Text("${requestList[index].value}"),
                            Text(requestList[index].key),
                            DropdownButton(
                              value: _selectedAuth,
                              items: service.authList.map((value) =>  DropdownMenuItem(
                                value: value,
                                child: Text(value))
                              ).toList(),
                              onChanged: (value) {
                                setState1(() {
                                  _selectedAuth = value.toString();
                                });
                              },
                            )
                          ],
                        ),
                        onPressed: () {
                          showDialog(
                            context: context, 
                            barrierDismissible: false,
                            builder: (BuildContext context2) {
                              return StatefulBuilder(
                                builder: (BuildContext _context3, StateSetter setState2) {
                                  return AlertDialog(
                                    title: const Text("?????? ??????"),
                                    content: Text("?????? : ${requestList[index].value}\n????????? : ${requestList[index].key}\n?????? ?????? : ${_selectedAuth}\n????????? ?????????????????????????"),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () async {

                                          String email = requestList[index].key;

                                          var store = FirebaseFirestore.instance;
                                          var v = store.collection("Users").doc(email);
                                          var gets = await v.get();

                                          List<dynamic> fav = await gets.get("Favorited");
                                          fav.add(_selectedAcademy);

                                          await v.update({"Favorited" : fav});
                                          

                                          v = store.collection("Academies").doc(_selectedAcademy);
                                          gets = await v.get();

                                          Map req = await gets.get("Request");
                                          req.remove(email);

                                          Map members = await gets.get("Members");
                                          Map member = Map();

                                          member["Name"] = requestList[index].value;
                                          member["Auth"] = service.authList.indexOf(_selectedAuth);
                                          member["Denied"] = "99999999";
                                          member["Warning"] = 0;
                                          member["Reserve"] = [];
                                          member["Remain"] = 0;

                                          members[email] = member;

                                          await v.update({"Members" : members, "Request" : req});

                                          setState(() {
                                            request = req;
                                          });

                                          createSnackBar(context, "?????????????????????.");
                                          Navigator.of(_context3).pop();
                                          Navigator.of(context1).pop();
                                        },
                                        child: const Text('??????')
                                      ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          String email = requestList[index].key;

                                          var store = FirebaseFirestore.instance;
                                          var v = store.collection("Academies").doc(_selectedAcademy);
                                          var gets = await v.get();

                                          Map req = await gets.get("Request");
                                          req.remove(email);

                                          await v.update({"Request" : req});

                                          setState(() {
                                            request = req;
                                          });

                                          createSnackBar(context, "?????????????????????.");
                                          Navigator.of(_context3).pop();
                                          Navigator.of(context1).pop();
                                        },
                                        child: const Text('??????')
                                      ),
                                      ElevatedButton(
                                        onPressed: () => Navigator.of(context2).pop(),
                                        child: const Text('??????')
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context1).pop(),
                  child: const Text('??????')
                ),
              ],
            );
          }
        );
      }
    );
  }

  void addWarning(int index, StateSetter setter) {

    String email = _listFromMap[index].key;

    setter(() {
      changedUser[_selectedAcademy]![email]["Warning"] += 1;
    });
  }

  void addCount(int index, StateSetter setter) {
    String email = _listFromMap[index].key;

    setter(() {
      changedUser[_selectedAcademy]![email]["Remain"] += 1;
    });
  }

  void saveMember(int index, BuildContext _context) async {
    String email = _listFromMap[index].key;    
    Map value = _listFromMap[index].value;

    //print(mapEquals(value, oldUser[_selectedAcademy]![email]));

    if(mapEquals(value, oldUser[_selectedAcademy]![email])) {
      createSnackBar(context, "?????? ????????? ????????????.");

      changedUser[_selectedAcademy]!.remove(_selectedAcademy);
      for(var item in oldUser[_selectedAcademy]!.keys) {
        Map tmp = Map();
        
        tmp.addAll(oldUser[_selectedAcademy]![item]);
        changedUser[_selectedAcademy]![item] = tmp;
      }
    }
    else {
      createSnackBar(context, "?????? ????????? ?????????????????????.");

      oldUser[_selectedAcademy]!.remove(_selectedAcademy);
      for(var item in changedUser[_selectedAcademy]!.keys) {
        Map tmp = Map();
        
        tmp.addAll(changedUser[_selectedAcademy]![item]);
        oldUser[_selectedAcademy]![item] = tmp;
      }

      var store = FirebaseFirestore.instance;
      await store.collection("Academies").doc(_selectedAcademy).update({
        "Members" : oldUser[_selectedAcademy]
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("?????? ??????"),
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
                          child: Center(child: Text("??????")),
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
                                  _settingsChanged[_selectedAcademy]!["Open"] = int.parse(_selectedStart);
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
                          child: Center(child: Text("??????")),
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
                                  _settingsChanged[_selectedAcademy]!["Close"] = int.parse(_selectedEnd);;
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
                          child: Center(child: Text("??????")),
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
                          child: Center(child: Text("??????")),
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
                    hintText: const Text('?????? ??????'),
                    func: manageUser,
                    mainColor: MyApp.mainColor
                  ),

                  //const Padding(padding: EdgeInsets.only(top: 10),),
                  const Divider(color: Colors.black),

                  FilledButton(
                    width: 200,
                    hintText: const Text('?????? ??????'),
                    func: manageRequest,
                    mainColor: MyApp.mainColor
                  ),

                  //const Padding(padding: EdgeInsets.only(top: 10),),
                  const Divider(color: Colors.black),

                  FilledButton(
                    width: 200,
                    hintText: const Text('???????????? ??????'),
                    func: changeSettings,
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