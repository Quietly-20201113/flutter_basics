
///日期自定义扩展方法
extension DateTimeExtension on DateTime{
  ///计算两个日期相差几月
     int customDifference(DateTime _last){
       int _fistY = this.year;
       int _fistM = this.month;

       int _lastY = _last.year;
       int _lastM = _last.month;
        ///懒得判断前后大小直接取绝对值
        int y = (_lastY - _fistY).abs() * 12;

        int m = (_lastM - _fistM).abs();

       return y+m;
    }
}
