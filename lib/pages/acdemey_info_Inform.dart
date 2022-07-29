import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../custom_class/c_global.dart';

class TabInform extends StatefulWidget {
  
  const TabInform({Key? key}) : super(key: key);
  

  @override
  State<TabInform> createState() => _TabInformState();
}

class _TabInformState extends State<TabInform> {
  // Completer<NaverMapController> _controller = Completer();
  // MapType _mapType = MapType.Basic;
  _TabInformState();
  
  // void onMapCreated(NaverMapController controller) {
  //   if (_controller.isCompleted) _controller = Completer();
  //   _controller.complete(controller);
  // }

  // List<Marker> _markers = [];

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   OverlayImage.fromAssetImage(
    //     assetName: 'marker.png',
    //     devicePixelRatio: window.devicePixelRatio,
    //   ).then((image) {
    //     setState(() {
    //       _markers.add(Marker(
    //           markerId: 'id',
    //           position: LatLng(37.563600, 126.962370),
    //           captionText: "커스텀 아이콘",
    //           captionColor: Colors.indigo,
    //           captionTextSize: 20.0,
    //           alpha: 0.8,
    //           captionOffset: 30,
    //           icon: image,
    //           anchor: AnchorPoint(0.5, 1),
    //           width: 45,
    //           height: 45,
    //           infoWindow: '인포 윈도우'));
    //     });
    //   });
    // });
    super.initState();
  }

  Widget viewInformation(Map data) {
    return SingleChildScrollView(
      scrollDirection:Axis.vertical,
      child: Container(
        margin: EdgeInsets.only(left:10),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('학원명 : ${data['Name']}'),
            Text('대표 : ${data['Header']}'),
            Text('과목 : ${data['Subject']}'),
            Text('연락처 : ${data['Phone']}'),
          ],
        ),
      ),
    );
  }

  Map parseData(String data) {

    Map parsedData = Map();

    String name = data.substring(data.indexOf("이름 : "), data.indexOf("대표 : ")).substring(5);
    parsedData["Name"] = name;
    String header = data.substring(data.indexOf("대표 : "), data.indexOf("과목 : ")).substring(5);
    parsedData["Header"] = header;
    String subject = data.substring(data.indexOf("과목 : "), data.indexOf("연락처 : ")).substring(5);
    parsedData["Subject"] = subject;
    String phone = data.substring(data.indexOf("연락처 : ")).substring(6);
    parsedData["Phone"] = phone;

    return parsedData;
  }

  Future<String> getAcademyTextData() async {

    final ref = FirebaseStorage.instance.ref().child('Academy/${service.academy}/Info.txt');
    String res = "";

    try {
      final Uint8List? data = await ref.getData(1024*1024);
      res = utf8.decode(data!);
    }
    on FirebaseException catch(e) {
      print("error catch");
      res = e.message.toString();
    }

    return Future(() => res);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAcademyTextData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Text("Loading");
        } else if (snapshot.hasError) {
          return const Text("Error");
        } else {

          Map data = parseData(snapshot.data.toString());

          //return const Text("Test");

          return viewInformation(data);
        }
      },
    );
    //return viewInformation();
  }
}