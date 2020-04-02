import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Config{
  //获取状态栏高度
  static double getStatusHeight(){
    return MediaQueryData.fromWindow(window).padding.top;
  }
  //获取屏幕尺寸
  static Size getScreenSize(BuildContext context){
    return MediaQuery.of(context).size;
  }
}