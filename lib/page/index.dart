import 'dart:math';

import 'package:expressions/expressions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbasics/common/app/app.dart';
import 'package:flutterbasics/page/bd_map/index.dart';
import 'package:flutterbasics/page/calendar_carousel/calendar_carouse_interval.dart';
import 'package:flutterbasics/page/calendar_carousel/index.dart';
import 'package:flutterbasics/page/customize_navigator/index.dart';
import 'package:flutterbasics/page/navigation/navigationPage.dart';

import 'dropdown/DropDownPage.dart';
// ignore: must_be_immutable
class PageIndex extends StatelessWidget{
  Alignment alignment = Alignment.center;
  double height = 62;
  BoxDecoration decoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(
        Radius.circular(24.0)),
  );

  void setData(){
    // Parse expression:
    Expression expression = Expression.parse("0 < 80 && 80 < 100");

    var context = {
      "x": pi / 5,
      "cos": cos,
      "sin": sin
    };

// Evaluate expression
    final evaluator = const ExpressionEvaluator();
    var r = evaluator.eval(expression, {});
    print("值 = $r");
  }


  @override
  Widget build(BuildContext context) {
    setData();
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body : Container(
          color: Color(0XFFF2F2F2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
               padding: EdgeInsets.fromLTRB(0, App.getStatusHeight(), 0, 0),
                color: Color(0XFF00CCA9),
                child: Container(
                  height: 54,
                  alignment: Alignment.center,
                  child: Text("内容列表",style: TextStyle(color: Colors.white,fontSize: 16),),
                ),
              ),
              SizedBox(height: 8,),
              Expanded(
                child: Column(
                  children: <Widget>[
                    _Container("导航功能",() async {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) =>  NavigationPage()),
                      );
                    }),
                    SizedBox(height: 8,),
                    _Container("复杂的搜索功能",(){
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) =>  DropDownPage()),
                      );
                    }),
                    SizedBox(height: 8,),
                    _Container("自定义路由",(){
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) =>  CustomizeNavigator()),
                      );
                    }),
                    SizedBox(height: 8,),
                    _Container("自定义单选日历",(){
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) =>  CalendarCarouselDP()),
                      );
                    }),
                    SizedBox(height: 8.0,),
                    _Container("自定义区间选日历",(){
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) =>  CalendarCarouseInterval()),
                      );
                    }),
                    SizedBox(height: 8.0,),
                    _Container("地图功能",(){
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) =>  BaiDuMapPage()),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }




  Widget _Container(name,GestureTapCallback onTap){
    return GestureDetector(
      child: Container(
        alignment:alignment,
        height: height,
        decoration: decoration,
        child:Text(name,style: TextStyle(color: Color(0XFF909399),fontSize: 16),),
      ),
      onTap: (){
        onTap();
      },
    );
  }
}