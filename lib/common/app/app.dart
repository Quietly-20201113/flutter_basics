import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutterbasics/common/theme/color_string.dart' as ColorMode;
class  App{
  /// 主题颜色字符串(默认)
  static String themeColorString = ColorMode.PRIMARY;

  /// 获取状态栏高度
  static double getStatusHeight() {
    return MediaQueryData.fromWindow(window).padding.top;
  }

  /// 获取屏幕尺寸
  /// params :BuildContext context
  /// return : Size size
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}