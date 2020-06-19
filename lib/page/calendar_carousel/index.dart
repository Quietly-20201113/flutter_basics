import 'package:flutter/material.dart';
import 'package:flutterbasics/page/calendar_carousel/blue_style_page.dart';
import 'package:flutterbasics/page/widget/features/ConciseHeader.dart';


class CalendarCarouselDP extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          ConciseHeader('日历单选样例'),
          Expanded(
            child:  BlueStylePage(),
          )
        ],
      ),
    );
  }
}
