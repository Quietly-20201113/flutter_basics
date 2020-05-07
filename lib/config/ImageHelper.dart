class ImageHelper {
  //处理静态图片
  static String wrapAssets(String url,{module = 'images'}) {
    return "assets/$module/$url";
  }
}