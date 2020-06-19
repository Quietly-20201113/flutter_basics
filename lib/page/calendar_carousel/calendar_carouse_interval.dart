import 'package:flutter/material.dart';
import 'package:flutterbasics/page/calendar_carousel/interval_select_page.dart';
import 'package:flutterbasics/page/widget/features/ConciseHeader.dart';

class CalendarCarouseInterval extends StatefulWidget {
  @override
  _CalendarCarouseIntervalState createState() => _CalendarCarouseIntervalState();
}

class _CalendarCarouseIntervalState extends State<CalendarCarouseInterval> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ConciseHeader('日历区间选择样例'),
          Expanded(
            child:IntervalSelectPage(),
          )
        ],
      ),
    );
  }
}
