import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../pages/acdemey_info_image.dart';
import 'c_global.dart';

class AppInfoWidget extends StatefulWidget {
  const AppInfoWidget({Key? key}) : super(key: key);

  @override
  State<AppInfoWidget> createState() => _AppInfoWidgetState();
}

class _AppInfoWidgetState extends State<AppInfoWidget> {
  
  List<String> itemLinks = [];
  Set<Image> imageList = {};

  Future<String> getImageURL() async {

    final ref = FirebaseStorage.instance.ref().child('YH');
    //final ref = FirebaseStorage.instance.ref().child('yholics_grey.jpeg');
    // 'gs://fir-withfluuter.appspot.com/yholics_grey.jpeg'
    // gs://fir-withfluuter.appspot.com/test/IMG_0136.png

    String downloadUrl = "";

    try{
      var items = await ref.listAll();
      
      for(var item in items.items) {
        downloadUrl = await item.getDownloadURL();

        imageList.add(Image(image: FirebaseImage(convertFromHTTPSToGS(downloadUrl))));
      }

      //downloadUrl = convertFromHTTPSToGS(downloadUrl);

      downloadUrl = "Success";
    }
    on FirebaseException catch (e) {
      downloadUrl = "Error : " + e.message.toString();
    }
    
    return Future(() => downloadUrl);
  }

  Future<String> saveTextFile() async {

    String result = "test";

    // final ref = FirebaseStorage.instance.ref().child('sampletext.txt');
    
    // try{ 
    //   await ref.putString("Why can't read it? Fxck");

    //   result = "Success";
    // }
    // on FirebaseException catch(e) {
    //   result = e.message.toString();
    // }
    

    // String data = 'asdfgasdgasgas';

    // try{
    //   await ref.putString(data, metadata: SettableMetadata(contentLanguage: 'en'));

    //   result = "Success";
    // }
    // on FirebaseException catch (e) {
    //   result = e.message.toString();
    // }
    
    return Future(() => result);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TEST"),),
      body: FutureBuilder(
        future: getImageURL(),
        //future: saveTextFile(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading");
          } else if (snapshot.hasError) {
            return const Text("Error");
          } else {
            //print(snapshot.data.toString());
            //return Image(image: FirebaseImage('gs://fir-withfluuter.appspot.com/yholics_blue.jpeg'));
            //return Image(image: FirebaseImage(snapshot.data.toString()));
            return ImageSliderPage(imagelist: imageList, height: double.infinity);
            //return Text(snapshot.data.toString());
          }
        },
      ),
    );
  }
}