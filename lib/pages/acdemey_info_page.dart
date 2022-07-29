import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../custom_class/c_global.dart';
import '../custom_class/c_page_reserve.dart';
import 'acdemey_info_Inform.dart';

class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with TickerProviderStateMixin {
  late TabController _tabController;

// ignore: non_constant_identifier_names
  Set<Image> Item = {
    Image.asset('assets/icon.png'),
    Image.asset('assets/icon.png'),
    Image.asset('assets/icon.png'),
  };

  late bool _favorited;

  @override
  void initState() {
    super.initState();

    _favorited = service.user.favorited.contains(service.academy.name);
  }

  void Reservation() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ReserveWidget()));
  }

  //  void Review()
  // {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => const ())
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(service.academy.name),
        actions: [
          InkWell(
            onTap: () async {

              var store = FirebaseFirestore.instance;
              var v = await store.collection("Users").doc(service.user.email).get();

              List<dynamic> favoritedList = await v.get("Favorited");

              if(_favorited) {
                favoritedList.remove(service.academy.name);
                service.user.favorited.remove(service.academy.name);
              }
              else {
                favoritedList.add(service.academy.name);
                service.user.favorited.add(service.academy.name);
              }

              await store.collection("Users").doc(service.user.email).update(
                {"Favorited" : favoritedList}
              );

              setState(() {
                _favorited = !_favorited;
                print(_favorited);
              });
            },
            child: Icon((_favorited ? Icons.favorite_rounded : Icons.favorite_border)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Align(
            //   alignment: Alignment.topLeft,
            //   child: FloatingActionButton(
            //     child: Icon(
            //       Icons.arrow_back,
            //     ),
            //     backgroundColor: Colors.purple,
            //     onPressed: () {
            //       Navigator.pop(context);
            //     }
            //   )
            // ),
            Padding(padding: EdgeInsets.only(top: 30)),
            //ImageSliderPage(imagelist: Item, height: 150),
            TabInform(),
          ],
        ),
      ),

      bottomNavigationBar: Row(
        children: [
          Material(
            color: const Color(0xffff8989),
            child: InkWell(
              onTap: () {},
              child: const SizedBox(
                height: kToolbarHeight,
                width: 100,
                child: Center(
                  child: Text(
                    '리뷰',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: const Color(0xffff8906),
              child: InkWell(
                onTap: Reservation,
                child: const SizedBox(
                  height: kToolbarHeight,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      '예약하기',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}