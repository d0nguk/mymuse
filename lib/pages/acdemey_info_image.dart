import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageSliderPage extends StatefulWidget {
  
   final Set<Image> imagelist;
   final double height;

   const ImageSliderPage({ Key? key,required this.imagelist,required this.height}) 
    : super(key: key);

  
  @override
  State<ImageSliderPage> createState() => _ImageSliderPageState(imagelist,height);
}

class _ImageSliderPageState extends State<ImageSliderPage> {
  Set<Image> imagelist;
  double height;

  _ImageSliderPageState(this.imagelist,this.height);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height : height,
        autoPlay: true
      ),
      items: imagelist.map((item) {
        return Builder(builder: (BuildContext context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal:10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1.0),
              child: item,
            ),
          );
        });
      }).toList(),
    );
  }
}