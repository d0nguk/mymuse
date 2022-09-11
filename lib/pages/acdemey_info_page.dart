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
              var v = await store.collection("Academies").doc(service.academy.name);

              var gets = await v.get();

              Map<String, dynamic> members = await gets.get("Members");

              //createSnackBar(context, members.keys.contains(service.user.email) ? "멤버입니다" : "멤버가 아닙니다.");

              if(!members.keys.contains(service.user.email)) {

                BuildContext mainContext = context;

                showDialog(
                  context: context, 
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("회원 등록"),
                      content: const Text("회원이 아닙니다.\n회원 신청을 하시겠습니까?"),
                      actions: [
                        ElevatedButton(
                          onPressed: () async {

                            Map request = Map();

                            if(request.keys.contains(service.user.email)) {
                              createSnackBar(mainContext, "승인 대기중입니다.");
                            }
                            else {
                              request[service.user.email] = service.user.name;
                              await v.update({"Request" : request});
                              
                              createSnackBar(mainContext, "회원 신청이 완료되었습니다. 승인을 기다려주세요.");
                            }

                            //req.add("test1");

                            Navigator.of(context).pop();
                          },
                          child: const Text('예')
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('아니오')
                        ),
                      ],
                    );
                  }
                );
              }
              else {
                createSnackBar(context, "등록된 회원입니다.");
              }

              /*

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
            */
            },
            child: const Icon(Icons.person_add_alt_1),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
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
          // Material(
          //   color: const Color(0xffff8989),
          //   child: InkWell(
          //     onTap: () {},
          //     child: const SizedBox(
          //       height: kToolbarHeight,
          //       width: 100,
          //       child: Center(
          //         child: Text(
          //           '리뷰',
          //           textAlign: TextAlign.center,
          //           style: TextStyle(
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
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