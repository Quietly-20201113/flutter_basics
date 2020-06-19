import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbasics/common/app/app.dart';
import 'package:flutterbasics/common/theme/app_theme.dart';
import 'package:flutterbasics/common/utils/ImageHelper.dart';

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
      padding: EdgeInsets.only(top: App.getStatusHeight()),
      color: AppTheme.rcColor.primary00CCA9,
      child: Container(
        height: 44.0,
        alignment: Alignment.center,
        child:  Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Text(title,style: TextStyle(color: AppTheme.rcColor.primaryFFFFFF,fontSize: AppTheme.rcColor.fontSize16)),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(10.0, 10, 10, 10),
                  width:24.0 ,height: 24.0,
                  child: Image.asset(ImageHelper.iconAssetsCommon('icon_pop.png')),
                ),
              ),
            )
          ],
        ),
      )
    );
  }

}