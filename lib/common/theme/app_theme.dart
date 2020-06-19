import 'package:flutter/material.dart';
import 'package:flutterbasics/common/app/app.dart';
import 'package:flutterbasics/common/theme/color_string.dart' as ColorMode;
import 'package:flutterbasics/common/theme/skin_element.dart';

class AppTheme {
  static SkinElement rcColor = _getColor();

  /// 自动根据设计稿不透明度计算出具有透明度的颜色
  /// @param opacity 不透明度
  /// @param  color 颜色值
  /// @return color
  /// @author 丁平
  /// created at 2020/5/27 16:41
  static Color getOpacityColor(int opacity,Color color){
    ///根据不透明度计算成透明度
    double _percent = (opacity == 0 || opacity <0) ? 0 : (opacity / 100);
    int _length = color.value.toString().length;
    if(_length == 10 && _percent != 0){
      ///根据透明度计算成十六进制透明度
      String _hexadecimal = (_percent * 255).round().toRadixString(16);
      ///获取颜色value值并转成16进制
      String _intString = color.value.toRadixString(16).toString();

      ///获取传入的十六进制数
      String _hexadecimalColor = _intString.substring(2,_intString.length);
    return Color(_hexToInt('$_hexadecimal$_hexadecimalColor'));
    }
    return color;
  }
  
  /// 十六进制字符串转成int类型
  /// @param  hex 十六进制字符串
  /// @return int
  /// @author 丁平
  /// created at 2020/5/27 16:39
  ///
  static int _hexToInt(String hex) {
    int val = 0;
    int len = hex.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = hex.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("Invalid hexadecimal value");
      }
    }
    return val;
  }

  ///根据模式更换颜色
  static SkinElement _getColor(){
    switch(App.themeColorString){
      case ColorMode.PRIMARY :
        return SkinElement();
      case ColorMode.DIABLOMODE :
        return SkinElement();
      default :
        return SkinElement();
    }
  }


}