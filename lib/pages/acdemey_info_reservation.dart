import 'package:flutter/material.dart';

final Item = {
  Image.asset('icon.png', width: 200, height: 100),
  Image.asset('icon.png', width: 200, height: 100),
  Image.asset('icon.png', width: 200, height: 100),
};

class ReservationPage extends StatelessWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: //Column(
        //children: [
      // ImageSliderPage(imagelist: Item, _height: 150),
      BodyLayout(),
     // ],
      //),
    );
  }
}

class BodyLayout extends StatelessWidget{
  const BodyLayout({Key? key}) : super(key: key);

  Widget _ReservationList(BuildContext context) 
  {
    Widget TimeTable = Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Card(
          child: ListTile(
            title: Text("Title"),
            subtitle: Text("SubTitle"),
          ),
        )
      ],
    ),
  );

  return ListView.builder(
    itemCount:4,
    itemBuilder: (context, index) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              TimeTable,
              TimeTable,
              TimeTable,
            ],
          ),
        ),
      );
    },
  );
  }

  @override
  Widget build(BuildContext context) {
    return  _ReservationList(context);
  }
}