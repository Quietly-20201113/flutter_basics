import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbasics/config/config.dart';
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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body : Container(
          color: Color(0XFFF2F2F2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
               padding: EdgeInsets.fromLTRB(0, Config.getStatusHeight(), 0, 0),
                color: Color(0XFF00CCA9),
                child: Container(
                  height: 54,
                  alignment: Alignment.center,
                  child: Text("内容列表",style: TextStyle(color: Colors.white,fontSize: 16),),
                ),
              ),
              SizedBox(height: 8,),
              _Container("导航功能",(){
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