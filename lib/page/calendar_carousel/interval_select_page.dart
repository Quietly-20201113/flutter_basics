import 'package:flutter/material.dart';
import 'package:flutterbasics/common/theme/app_theme.dart';
import 'package:flutterbasics/common/widget/custom_calendar/constants/constants.dart';
import 'package:flutterbasics/common/widget/custom_calendar/controller.dart';
import 'package:flutterbasics/common/widget/custom_calendar/model/date_model.dart';
import 'package:flutterbasics/common/widget/custom_calendar/widget/base_day_view.dart';
import 'package:flutterbasics/common/widget/custom_calendar/widget/base_week_bar.dart';
import 'package:flutterbasics/common/widget/custom_calendar/widget/calendar_view.dart';
import 'package:flutterbasics/common/utils/ImageHelper.dart';



class IntervalSelectPage extends StatefulWidget {
  IntervalSelectPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BlueStylePageState createState() => _BlueStylePageState();
}

class _BlueStylePageState extends State<IntervalSelectPage> {
  ValueNotifier<String> text;
  ValueNotifier<String> yearText;
  ValueNotifier<String> selectText;

  CalendarController controller;

  Map<DateModel, String> customExtraData = {};

  @override
  void initState() {
    super.initState();
    controller = new CalendarController(
        isExceedNotClick : true,
        selectMode : CalendarConstants.MODE_INTERVAL_SELECT,
        showMode: CalendarConstants.MODE_SHOW_MONTH_AND_WEEK,
        extraDataMap: customExtraData,
    );

    controller.addMonthChangeListener(
          (year, month) {
            print("几次首页 = ${DateTime(year,month)}");
        text.value = "$month月";
        yearText.value = "$year年";
            setState(() { });
      },

    );

    controller.addOnCalendarSelectListener((dateModel) {
      //刷新选择的时间
      selectText.value = "多选模式\n选中的时间:\n${controller.getMultiSelectCalendar().join("\n")}";
       setState(() { });
    });

    text = new ValueNotifier("${DateTime.now().month}月");
    yearText = new ValueNotifier("${DateTime.now().year}年");

    selectText = new ValueNotifier(
        "多选模式\n选中的时间:\n${controller.getMultiSelectCalendar().join("\n")}");
  }

  @override
  Widget build(BuildContext context) {
    var calendarWidget = CalendarViewWidget(
      verticalSpacing : 0.0,
      weekBarItemWidgetBuilder: () {
        return CustomStyleWeekBarItem();
      },
      dayWidgetBuilder: (dateModel) {
        return CustomStyleDayWidget(dateModel);
      },
      calendarController: controller,
      boxDecoration: BoxDecoration(
        color: AppTheme.rcColor.primaryFFFFFF,
      ),
    );

    return Container(
      child:  Column(
        children: <Widget>[
           Container(
             margin: EdgeInsets.symmetric(horizontal: 12.0),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                 Container(
                   alignment: Alignment.center,
                   color: AppTheme.rcColor.primaryFFFFFF,
                   height: 44.0,
                   child:  Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       GestureDetector(
                         child: Image.asset(ImageHelper.iconAssetsCommon('icon_left_arrow.png'), width: 18.0,height: 18.0,),
                         onTap: (){
                           controller.moveToPreviousYear();
                         },
                       ),
                       ValueListenableBuilder(
                           valueListenable: yearText,
                           builder: (context, value, child) {
                             return  Container(
                               alignment: Alignment.center,
                               width: 132.0,
                               child: Text(
                                 yearText.value,
                                 style: TextStyle(
                                     color: AppTheme.rcColor.primary606266,
                                     fontSize: AppTheme.rcColor.fontSize18
                                 ),
                               ),
                             );
                           }),
                       GestureDetector(
                         child: Image.asset(ImageHelper.iconAssetsCommon('icon_right_arrow.png'), width: 18.0,height: 18.0,),
                         onTap: (){
                           controller.moveToNextYear();
                         },
                       ),
                     ],
                   ),
                 ),
                 Container(
                   alignment: Alignment.center,
                   color: AppTheme.rcColor.primaryFFFFFF,
                   height: 44.0,
                   child:  Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[
                       GestureDetector(
                         child: Image.asset(ImageHelper.iconAssetsCommon('icon_left_arrow.png'), width: 18.0,height: 18.0,),
                         onTap: (){
                           controller.moveToPreviousMonth();
                         },
                       ),
                       ValueListenableBuilder(
                           valueListenable: text,
                           builder: (context, value, child) {
                             return  Container(
                               alignment: Alignment.center,
                               width: 132.0,
                               child: Text(
                                 text.value,
                                 style: TextStyle(
                                     color: AppTheme.rcColor.primary606266,
                                     fontSize: AppTheme.rcColor.fontSize18
                                 ),
                               ),
                             );
                           }),
                       GestureDetector(
                         child: Image.asset(ImageHelper.iconAssetsCommon('icon_right_arrow.png'), width: 18.0,height: 18.0,),
                         onTap: (){
                           controller.moveToNextMonth();
                         },
                       ),
                     ],
                   ),
                 ),
               ],
             ),
           ),
          calendarWidget,
          ValueListenableBuilder(
              valueListenable: selectText,
              builder: (context, value, child) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: new Text(selectText.value),
                );
              }),
        ],
      ),
    );
  }
}

class CustomStyleWeekBarItem extends BaseWeekBar {
  final List<String> weekList = ["一", "二", "三", "四", "五", "六", "七"];

  //可以直接重写build方法
  @override
  Widget build(BuildContext context) {
    List<Widget> children = List();
    var items = getWeekDayWidget();
    children.add(Row(
      children: items,
    ));
    children.add(SizedBox(height: 12.0,));
    return Column(
      children: children,
    );
  }

  @override
  Widget getWeekBarItem(int index) {
    return new Container(
      margin:EdgeInsets.symmetric(vertical: 12.0),
      child: new Center(
        child: new Text(
          weekList[index],
          style:TextStyle( color:AppTheme.rcColor.primary909399,fontSize: AppTheme.rcColor.fontSize14),
        ),
      ),
    );
  }
}

class CustomStyleDayWidget extends BaseCombineDayWidget {
  final CalendarController controller;
  CustomStyleDayWidget(DateModel dateModel, {this.controller}) : super(dateModel);

  final TextStyle normalTextStyle =
  TextStyle(
      color:AppTheme.rcColor.primary606266,
      fontSize: AppTheme.rcColor.fontSize18
  );

  final TextStyle _sunDay = TextStyle(
      color: AppTheme.rcColor.primaryC0C4CC,
      fontSize: AppTheme.rcColor.fontSize18
  );

  @override
  Widget getNormalWidget(DateModel dateModel) {
    return  dateModel.isCurrentMonth ? Container(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Text(
                    dateModel.day.toString(),
                    style: dateModel.isSunday? _sunDay : normalTextStyle,
                  ),
                ),
              )
              //公历
            ],
          ),
        ],
      ) ,
    ) : SizedBox();
  }

  @override
  Widget getSelectedWidget(DateModel dateModel) {
    return  dateModel.isCurrentMonth ?  Container(
      alignment: Alignment.center,
      decoration: new BoxDecoration(
//        shape: BoxShape.circle,
        color: dateModel.isInterval??false ?  AppTheme.getOpacityColor(30, AppTheme.rcColor.primary00CCA9) : AppTheme.rcColor.primary00CCA9,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //公历
              Expanded(
                child: Center(
                  child: Text(
                      dateModel.day.toString(),
                      style: TextStyle(
                          color: AppTheme.rcColor.primary606266,
                          fontSize: AppTheme.rcColor.fontSize18
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    ) : SizedBox();
  }

}
