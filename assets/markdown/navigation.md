**导航模块**

> 引入插件 [url_launcher](https://dart-pub.mirrors.sjtug.sjtu.edu.cn/packages/url_launcher)
>
> 导航开放平台查询各个导航需要的API（url）
>
> 如有需要做标转换的需自行转换
>
> 安卓手机调用苹果导航的时候需要做判断是否是苹果手机,不然会从浏览器吊起导航(高德导航)
>
> 判断[Platform.isIOS]

```dart
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
```

