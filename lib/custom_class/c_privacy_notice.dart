import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'c_global.dart';
import 'c_notice.dart';

class NoticeWidget extends StatefulWidget {
  const NoticeWidget({Key? key}) : super(key: key);

  @override
  State<NoticeWidget> createState() => _NoticeWidgetState();
}

class _NoticeWidgetState extends State<NoticeWidget> {

  List<Widget> tiles = [];
  List<Notice> notices = [];

  void setNoticeList() {
    for(var item in notices) {
      tiles.add(ExpansionTile(
        title: Text(item.head),
        subtitle: Text(service.getDateString(item.date.toDate())),
        textColor: const Color.fromARGB(255, 222, 167, 232),
        iconColor: const Color.fromARGB(255, 222, 167, 232),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(title: Text(item.body)),
            ],
          ),
        ],
      ));

      tiles.add(const Divider(color: Color.fromARGB(255, 222, 167, 232), height: 1, thickness: 2,));
    }
  }

  Future<String> getNotice() async {

    Notice notice;

    var store = FirebaseFirestore.instance;
    await store.collection("Notice").orderBy("TimeStamp", descending: true).get().then((value) {
      for(var item in value.docs) {
        notice = Notice.fromJson(item.data());

        notices.add(notice);
      }

      setNoticeList();
    },);

    return Future(() => 'Success');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("공지사항"),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder(
        future: getNotice(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData == false) {
            return const Text("Loading");
          }
          else if(snapshot.hasError) { 
            return const Text("Error");
          }
          else {
            return ListView(children: tiles,);
          }
        },
      )
    );
  }
}