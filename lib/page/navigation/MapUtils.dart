import 'dart:io';
import 'dart:math' as Math;
import 'package:flutterbasics/enum/enum.dart';
import 'package:url_launcher/url_launcher.dart';
class MapUtils{

  /*
   * 根据包名检测某个APP是否安装
   * @param {*签名} targetUrl
   * @returns true|false
   */
  static Future<bool> isInstallByUrl(String targetUrl) async {
    return await canLaunch(targetUrl);
  }

  /*
  * 当前url都在各自开放平台API中查找的,如有问题请查找各自API文档
  * @param {*type} 导航app类型
  * @param {*toLat} 做标维度
  * @param {*toLng} 做标经度
  *  @returns
   */
  static String tunedUp(MapType type,{toLat,toLng}){
    String _url = "";
    switch(type){
      case MapType.AMAP:
      // TODO: Handle this case.
        _url = 'androidamap://navi?sourceApplication=我的app名&lat=$toLat&lon=$toLng&dev=0&style=2';
        break;
      case MapType.BAIDUMAP:
      // TODO: Handle this case.
        _url = 'baidumap://map/direction?origin=我的位置&destination=$toLat,$toLng&mode=driving&coord_type=bd09ll';
        break;
      case MapType.QQMAP:
      // TODO: Handle this case.
        _url = 'qqmap://map/routeplan?type=drive&fromcoord=CurrentLocation&tocoord=$toLat,$toLng&coord_type=1&policy=0';
        break;
      case MapType.APPLEMAP:
      // TODO: Handle this case.
        _url = 'http://maps.apple.com/?daddr=$toLat,$toLng';

        break;
    }
    return _url;
  }

  /*
  * @param {*url} 根据url吊起手机导航app
  * @returns
   */
  static void thirdPartyMap(String url) {
    if (canLaunch(url) != null) {
      launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /*
   * 百度坐标转腾讯/高德（传入经度、纬度）
   *  @param{bdLng} 经度
   *  @param{bdLat} 维度
   */
  static Map bdToGaoDe(double bdLng, double bdLat) {
    var xPi = Math.pi * 3000.0 / 180.0;
    var x = bdLng - 0.0065;
    var y = bdLat - 0.006;
    var z = Math.sqrt(x * x + y * y) - 0.00002 * Math.sin(y * xPi);
    var theta = Math.atan2(y, x) - 0.000003 * Math.cos(x * xPi);
    var gdLng = z * Math.cos(theta);
    var gdLat = z * Math.sin(theta);
    return {"lng": gdLng, "lat": gdLat};
  }

  /*
   * 腾讯/高德坐标转百度（传入经度、纬度）
   *  @param{gdLng} 经度
   *  @param{gdLat} 维度
   */
  static Map gdToBaiDu(double gdLng, double gdLat) {
    var xPi = Math.pi * 3000.0 / 180.0;
    var x = gdLng, y = gdLat;
    var z = Math.sqrt(x * x + y * y) + 0.00002 * Math.sin(y * xPi);
    var theta = Math.atan2(y, x) + 0.000003 * Math.cos(x * xPi);
    var bdLng = z * Math.cos(theta) + 0.0065;
    var bdLat = z * Math.sin(theta) + 0.006;
    return {"lng": bdLng, "lat": bdLat};
  }


}