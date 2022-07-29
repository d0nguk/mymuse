import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        //appBar: AppBar(title: Text('TestPage')),
        body: TabBarView(
          children: [
            Text('home'),
            Text('chat'),
            Text('my'),
          ],
        ),
        bottomNavigationBar: Container(
          color: Color.fromARGB(255, 189, 103, 204), //색상
          child: Container(
            height: 70,
            padding: EdgeInsets.only(bottom: 10, top: 5),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.purple,
              indicatorWeight: 4,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black38,
              labelStyle: TextStyle(
                  fontSize: 17,
                  //fontFamilyFallback: fontFamilyName('Yanolja')),
              ),
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.home,
                    size: 20,
                  ),
                  text: 'Home',
                ),
                Tab(
                  icon: Icon(
                    Icons.chat,
                    size: 20,
                  ),
                  text: 'Chat',
                ),
                Tab(
                  icon: Icon(
                    Icons.people,
                    size: 20,
                  ),
                  text: 'My',
                )
              ],
           ),
         ),
        ),
      ),
    );
  }
}