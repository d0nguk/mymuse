import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../pages/acdemey_info_page.dart';
import 'c_global.dart';

class AcademyButton extends StatefulWidget {

  final String name;
  final String subject;
  final String msg;

  const AcademyButton({
    Key? key, 
    required this.name,
    required this.subject,
    required this.msg}) : super(key: key);

  @override
  State<AcademyButton> createState() => _AcademyButtonState(name, subject, msg);
}

class _AcademyButtonState extends State<AcademyButton> {

  String academyName;
  String subject;
  String msg;

  late String _iconURL;

  late Map _reserveList;

  late Image _icon;

  _AcademyButtonState(this.academyName, this.subject, this.msg);

  @override
  void initState() {
    super.initState();

    _iconURL = "";
  }

  Future<String> getIcon() async {

    final ref = FirebaseStorage.instance.ref().child('Academy/$academyName/icon.png');
    // final ref = FirebaseStorage.instance.ref().child('test/icon.png');
    
    String res = "";

    try {
      res = await ref.getDownloadURL();

      _iconURL = convertFromHTTPSToGS(res);
/*
      String constKey = "gs://fir-withfluuter.appspot.com/Academy/";
      if(_iconURL.substring(constKey.length, constKey.length+1).compareTo("%") == 0) {
        String urlFormatKey = _iconURL.substring(constKey.length);

        String decodeKey = decodeURLFormat(urlFormatKey);

        _iconURL = constKey + decodeKey;
      }
*/
      FirebaseImage fbImage = FirebaseImage(_iconURL);

      //await fbImage.getBytes();

      _icon = Image(image: fbImage);

      res = "Success";
    }
    on FirebaseException catch(e) {
      res = e.message.toString();
    }

    return Future(() => "Success");
  }

  InkWell getButton(bool bLoad) {
    return InkWell(
      onTap: () async {

        service.curAcademy = academyName;

        var store = FirebaseFirestore.instance;
        var v = await store.collection("Academies").doc(academyName).get();
        _reserveList = v.get("Reserve");
        var user = await v.get("Members");

        service.curAuthority = user[service.user.name]["Auth"];
        service.curRoom = await v.get("Settings")["Rooms"];

        //print(service.authority);

        service.curReserve = _reserveList;

        service.navigatorPush(context, TabPage());
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 206, 153, 215), width: 2),
          borderRadius: BorderRadius.circular(15),
          shape: BoxShape.rectangle,
        ),
        margin: const EdgeInsets.all(10),

        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              //padding: const EdgeInsetsDirectional.fromSTEB(12, 8, 12, 0),
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.only(left:10),
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                    ),
                    //child : const Text("asdf")//Image.asset('icon.png'),
                    //child : Image.asset('icon.png'),
                    // child: bLoad ? /*Image(image: FirebaseImage(_iconURL))*/ const Text("Success") : const Text("Null"),
                    child: bLoad ? _icon : const CircularProgressIndicator(),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(14, 0, 0, 0),
                        child: Text(academyName),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(14, 0, 0, 0),
                        child: Text(subject),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            /*
            const Divider(
              height: 3,
              thickness: 1,
              color: Color.fromARGB(255, 206, 153, 215)
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
              child: Row(
                children: const [
                  Icon(Icons.favorite_rounded, color: Color.fromARGB(255, 206, 153, 215),),
                  Padding(
                    padding: EdgeInsets.only(left:10),
                    child: Text('좋아요 수'),
                  ),
                  Padding(padding: EdgeInsets.only(left:20)),
                  Icon(Icons.mode_comment_outlined, color: Color.fromARGB(255, 206, 153, 215)),
                  Padding(
                    padding: EdgeInsets.only(left:10),
                    child: Text('리뷰 수'),
                  ),
                ],
              ),
            ),
            */
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getIcon(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if(!snapshot.hasData) {
          return getButton(false);
        }
        else if(snapshot.hasError) {
          print(snapshot.error.toString());
          return const Text("Error occured!");
        }
        else {
          //print(_iconURL);
          //return getButton(true);
          return getButton(true);
        }
      }
    );
  }
}