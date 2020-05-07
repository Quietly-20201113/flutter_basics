import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbasics/config/config.dart';

/*
 * 简单的头部样例 ,嫌麻烦  弄出来了
 */
class ConciseHeader extends StatelessWidget{
  final String title;
  const ConciseHeader(this.title,{Key key, }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.fromLTRB(0, Config.getStatusHeight(), 0, 0),
      color: Color(0XFF00CCA9),
      child: Container(
        height: 54,
        alignment: Alignment.center,
        child: Text(title,style: TextStyle(color: Colors.white,fontSize: 16),),
      ),
    );
  }

}