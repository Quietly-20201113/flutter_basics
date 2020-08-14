import 'dart:async';


import 'package:flutter/material.dart';
import 'package:flutter_bmfmap/BaiduMap/bmfmap_map.dart';
import 'package:flutter_bmfbase/BaiduMap/bmfmap_base.dart';
import 'package:flutterbasics/common/theme/app_theme.dart';
import 'package:flutterbasics/common/utils/ImageHelper.dart';
import 'package:flutterbasics/page/bd_map/api/map_baidu_api.dart';
import 'package:flutterbasics/page/bd_map/map_init.dart';
import 'package:flutterbasics/page/widget/features/ConciseHeader.dart';


class BaiDuMapPage extends StatefulWidget {
  @override
  _BaiDuMapPageState createState() => _BaiDuMapPageState();
}

class _BaiDuMapPageState extends State<BaiDuMapPage> {
  BMFMapController myMapController;
  StreamSubscription<Map<String, Object>> _locationListener;
  List<BMFCoordinate> _list = [];
  BMFMapOptions mapOptions = BMFMapOptions(
      center: BMFCoordinate(25.10956,102.739425),
      zoomLevel: 20,
      mapPadding: BMFEdgeInsets(left: 30, top: 0, right: 30, bottom: 0));
 List<BMFMarker> _listBMFMarker;

  /// 创建BMFMarker
  BMFMarker marker = BMFMarker(
      position: BMFCoordinate(25.10956,102.739425),
      title: '我自己',
      identifier: 'flutter_marker',
      icon: ImageHelper.iconAssetsCommon('icon_map_me.png'));
  BMFCircle circle = BMFCircle(
      center: BMFCoordinate(25.10956,102.739425),
      radius: 50,
      width: 2,
      strokeColor:AppTheme.rcColor.primary00CCA9 ,
      fillColor: AppTheme.getOpacityColor(10, AppTheme.rcColor.primary00CCA9),
      lineDashType: BMFLineDashType.LineDashTypeSquare);
  BMFText bmfText = BMFText(
      text: '恒大金龙湾一期',
      position: BMFCoordinate(25.10956,102.739425),
      bgColor: AppTheme.rcColor.primary00CCA9,
      fontColor: AppTheme.rcColor.primaryFFFFFF,
      fontSize: 40,
      typeFace: BMFTypeFace( familyName: BMFFamilyName.sMonospace,
          textStype: BMFTextStyle.BOLD),
      alignY: BMFVerticalAlign.ALIGN_TOP,
      alignX: BMFHorizontalAlign.ALIGN_CENTER_HORIZONTAL,
      rotate: 0.0);

@override
  void initState() {
    // TODO: implement initState
  _listBMFMarker = _list.map((coordinate) => BMFMarker(
      position: coordinate,
      title: '我自己',
      identifier: 'flutter_marker',
      icon: ImageHelper.iconAssetsCommon('icon_map_me.png'))).toList();
      MapBaiDuApi.getMapSearch(25.10956,102.739425,'银行').then((value){
        print(value);
        print(value.toString());
      });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (null != _locationListener) {
      _locationListener.cancel(); // 停止定位
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ConciseHeader('地图示例'),
          Expanded(
              child:Stack(
                children: <Widget>[
                  MapInit( mapOptions,marker : marker,circle: circle,listMarker: _listBMFMarker,bmfText : bmfText),
                ],
              )
          )
        ],
      ),
    );
  }
}

