import 'package:flutter/material.dart';

/// 搜索时获取搜索词高亮
/// @param 
/// @return
/// @author 丁平
/// created at 2020/6/15 20:51
///
class SearchUtils {

  /// 获取高亮关键字文本
  static List<InlineSpan> getTitle(String source, String keyword) {
    List<InlineSpan> list = [];
    List<String> sourceList = [];
    List<String> temp = source?.split(keyword);
    temp?.forEach((s) {
      sourceList.add(s);
      sourceList.add(keyword);
    });
    if (sourceList.length > 0) sourceList.removeLast();
    sourceList?.forEach((v) {
      if(v.isEmpty) {
        return;
      }
      if (v == keyword) {
        list.add(TextSpan(
            text: keyword,
            style: TextStyle(
                color: Colors.red,
            )
        ),);
      } else {
        list.add(TextSpan(
            text: v,
            style: TextStyle(
            )
        ),);
      }
    });
    return list;
  }
}