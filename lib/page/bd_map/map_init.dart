import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bmfmap/BaiduMap/bmfmap_map.dart';
import 'package:flutter_bmfbase/BaiduMap/bmfmap_base.dart';
/// 创建地图
/// @param
/// @return
/// @author 丁平
/// created at 2020/8/5 14:27
///
class MapInit extends StatefulWidget {
  final BMFMapOptions mapOptions;
  ///画大头标
  final BMFMarker marker;
  ///多图标
  final List<BMFMarker> listMarker;
  ///画圆
  final BMFCircle circle;
  ///文字标签
  final BMFText bmfText;

  const MapInit( this.mapOptions,{Key key,this.marker,this.circle,this.listMarker = const [],this.bmfText}) : super(key: key);
  @override
  _MapInitState createState() => _MapInitState();
}

class _MapInitState extends State<MapInit> {
  BMFMapController myMapController;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: BMFMapWidget(
        onBMFMapCreated: (controller) {
          _onBMFMapCreated(controller);
        },
        mapOptions: widget.mapOptions,
      ),
    );
  }

  /// 创建完成回调
  void _onBMFMapCreated(BMFMapController controller) {
    myMapController = controller;

    /// 地图加载回调
    myMapController?.setMapDidLoadCallback(callback: () {
      print('mapDidLoad-地图加载完成');
      myMapController?.showUserLocation(true);
      if(ObjectUtil.isNotEmpty(widget.marker)){
        myMapController?.addMarker(widget.marker);
      }
      if(widget.listMarker.length > 0){
        myMapController?.addMarkers(widget.listMarker);
      }
      if(ObjectUtil.isNotEmpty(widget.bmfText)){
        myMapController?.addText(widget.bmfText);
      }
      if(ObjectUtil.isNotEmpty(widget.circle)){
        myMapController?.addCircle(widget.circle);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

