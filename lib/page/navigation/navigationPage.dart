import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutterbasics/config/config.dart';
import 'package:flutterbasics/enum/enum.dart';
import 'package:oktoast/oktoast.dart';
import 'MapUtils.dart';
class NavigationPage extends StatefulWidget{
  @override
  _NavigationPage createState() => _NavigationPage();
}

BoxDecoration decoration = BoxDecoration(
  color: Color(0XFF4DA4FF),
  borderRadius: BorderRadius.all(
      Radius.circular(8)),
);

double lat = 24.8739981500;
double lng = 102.8524483650;

class _NavigationPage extends State<NavigationPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(0, Config.getStatusHeight(), 0, 0),
            color: Color(0XFF00CCA9),
            child: Container(
              height: 54,
              alignment: Alignment.center,
              child: Text("导航样例",style: TextStyle(color: Colors.white,fontSize: 16),),
            ),
          ),
          Container(
            child: Wrap(
              children: <Widget>[
                _Container('腾讯地图',(){Goto(MapType.QQMAP,'你怕是么有装腾讯的地图``````');}),
                _Container('高德导航',(){ Goto(MapType.AMAP,'你怕是么有装高德导航``````');}),
                _Container('百度导航',(){Goto(MapType.BAIDUMAP,'你怕是么有装百度导航``````');}),
                _Container('苹果导航',(){Goto(MapType.APPLEMAP,'你怕是么有装苹果导航``````');}),
              ],
            ),
          ),
          Expanded(
            child: FlutterMarkdown(),
          )
        ],
      ),
    );
  }


  void Goto(MapType type,str) async {
    String url = MapUtils.tunedUp(type,toLat : lat,toLng:lng);
    bool flag = await  MapUtils.isInstallByUrl(url);
    if(flag){
      MapUtils.thirdPartyMap(url);
    }else{
      showToast(str);
    }
  }

  Widget _Container(name,GestureTapCallback onTap){
    return GestureDetector(
      child: Container(
        decoration: decoration,
        margin: EdgeInsets.all(10),
        alignment: Alignment.center,
        height: 50,
        width: 150,
        child: Text(name,style: TextStyle(color: Colors.white),),
      ),
      onTap: (){
        onTap();
      },
    );
  }



}

class FlutterMarkdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: rootBundle.loadString('assets/markdown/navigation.md'),
        builder: (BuildContext context,AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return Markdown(data: snapshot.data);
          }else{
            return Center(
              child: Text("加载中..."),
            );
          }
        },
      ),
    );
  }
}
