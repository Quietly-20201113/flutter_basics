import 'dart:io';

import 'package:dio/dio.dart';

class MapBaiDuApi{
static const String baiduAK = '6xAGgNK254SGQWh1EIzqrBAlaadH08Ud';
  static Future<dynamic> getMapSearch(double lat,double lng,String title,[int radius = 2000]) async {
    Dio dio = new Dio();
   var response  = await  dio.get('http://api.map.baidu.com/place/v2/search?query=$title&location=$lat,$lng&radius=$radius&output=json&ak=$baiduAK');
   return response;
  }
}