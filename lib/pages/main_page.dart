import 'package:flutter/material.dart';

import '../custom_class/c_global.dart';
import '../custom_class/c_page_favorited.dart';
import '../custom_class/c_page_privacy.dart';
import '../custom_class/c_page_search.dart';
import '../custom_class/c_welcometext.dart';

class MainPage extends StatefulWidget {

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  _MainPageState();

  bool emptyFavorited = false;

  @override
  void initState() {
    emptyFavorited = service.user.favorited.isEmpty;

    //service.printUserData();

    super.initState();
  }

  @override
  void setState(VoidCallback fn){
    emptyFavorited = service.user.favorited.isEmpty;

    super.setState(fn);
  }

  Widget getTab1() {
    return FavoritedWidget(empty: emptyFavorited);
  }

  Widget getTab2() {
    return SearchWidget();
  }

  Widget getTab3() {
    return PrivacyWidget();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
      length: 3,
      child: Scaffold(
        
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                // personal info
                Flexible(
                  //child: welcomeText(userName: user.name, email: user.email),
                  child: WelcomeText(userName: service.user.name,),
                  flex: 2,
                ),
        
                // tabbarview
                Flexible(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      // tab 1
                      getTab1(),
        
                      // tab2
                      //Text('search page'),
                      getTab2(),
        
                      // tab3
                      //Text('privacy page'),
                      getTab3(),
                    ],
                  ),
                  flex: 10
                ),
              ],
            ),
          ),
        ),

        bottomNavigationBar: Container(
          color: Color.fromARGB(255, 189, 103, 204),
          child: Container(
            height: 50,
            padding: EdgeInsets.only(bottom: 10),
            child: const TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.purple,
              indicatorWeight: 6,
              labelColor: Colors.white,
              unselectedLabelColor: Color.fromARGB(255, 54, 54, 54),
              labelStyle: TextStyle(
                fontSize: 10,
              ),
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.favorite_rounded,
                    size: 20,
                  ),
                  //text: '즐겨찾기',
                ),
                Tab(
                  icon: Icon(
                    Icons.search,
                    size: 20,
                  ),
                  //text: '검색',
                ),
                Tab(
                  icon: Icon(
                    Icons.more_horiz,
                    size: 20,
                  ),
                  //text: '',
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
