import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterbasics/common/widget/custom_calendar/controller.dart';
import 'package:flutterbasics/common/widget/loading_page/index.dart';
import 'package:provider/provider.dart';
import 'package:flutterbasics/common/widget/custom_calendar/cache_data.dart';
import 'package:flutterbasics/common/widget/custom_calendar/utils/date_util.dart';
import 'package:flutterbasics/common/widget/custom_calendar/calendar_provider.dart';
import 'package:flutterbasics/common/widget/custom_calendar/configuration.dart';
import 'package:flutterbasics/common/widget/custom_calendar/constants/constants.dart';
import 'package:flutterbasics/common/widget/custom_calendar/model/date_model.dart';
import 'package:flutterbasics/common/widget/custom_calendar/extension/date_extension.dart';

/* *
 * 月视图，显示整个月的日子
 */
class MonthView extends StatefulWidget {
  final int year;
  final int month;
  final int day;
  final CalendarController  calendarController;

  final CalendarConfiguration configuration;

  const MonthView({
    Key key,
    @required this.year,
    @required this.month,
    this.day,
    this.configuration,
    this.calendarController,
  }) : super(key: key);

  @override
  _MonthViewState createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView>
    with AutomaticKeepAliveClientMixin {
  List<DateModel> items = List();
  int lineCount;
  Map<DateModel, Object> extraDataMap; //自定义额外的数据
  CalendarConfiguration configuration;
  CalendarProvider calendarProvider;
  @override
  void initState() {
    super.initState();
    extraDataMap = widget.configuration.extraDataMap;
    calendarProvider = Provider.of<CalendarProvider>(context, listen: false);
    if(calendarProvider.calendarConfiguration.selectMode == CalendarConstants.MODE_INTERVAL_SELECT){
//      calendarProvider.lastMont.addListener((){
//
//        if(calendarProvider.selectedDateList.length == 2){
//          DateModel _one = calendarProvider.selectedDateList.first;
//          DateModel _two = calendarProvider.selectedDateList.last;
//          DateModel _last = DateModel.fromDateTime(DateTime(_one.year, _one.month, 1));
//          DateModel _first = DateModel.fromDateTime(DateTime(_two.year, _two.month, 1));
//          int _difference = _last.getDateTime().customDifference(_first.getDateTime());
//          if(_difference != 0){
//            print('时间差哦 = $_difference');
//          }
//        }
//
//      });
      widget.calendarController.addMonthChangeListener((year, month){
        print("能不能监听得到啊");
      });
    }

    DateModel firstDayOfMonth =
    DateModel.fromDateTime(DateTime(widget.year, widget.month, 1));
    if (CacheData.getInstance().monthListCache[firstDayOfMonth]?.isNotEmpty ==
        true) {
      items = CacheData.getInstance().monthListCache[firstDayOfMonth];
    } else {
      getItems().then((_) {
        CacheData.getInstance().monthListCache[firstDayOfMonth] = items;
      });
    }

    lineCount = DateUtil.getMonthViewLineCount(widget.year, widget.month, widget.configuration.offset);
    //第一帧后,添加监听，generation发生变化后，需要刷新整个日历
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      Provider.of<CalendarProvider>(context, listen: false)
          .generation
          .addListener(() async {
        extraDataMap = widget.configuration.extraDataMap;
        print("此处监听?");
        await getItems();
      });
    });
  }

  Future getItems() async {
    items = await compute(initCalendarForMonthView, {
      'year': widget.year,
      'month': widget.month,
      'minSelectDate': widget.configuration.minSelectDate,
      'maxSelectDate': widget.configuration.maxSelectDate,
      'extraDataMap': extraDataMap,
      'offset': widget.configuration.offset
    });
    setState(() {});
  }

  static Future<List<DateModel>> initCalendarForMonthView(Map map) async {
    return DateUtil.initCalendarForMonthView(
        map['year'], map['month'], DateTime.now(), DateTime.sunday,
        minSelectDate: map['minSelectDate'],
        maxSelectDate: map['maxSelectDate'],
        extraDataMap: map['extraDataMap'],
        offset: map['offset']);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print("_MonthViewState build == ${items.isEmpty }");
     configuration =
        calendarProvider.calendarConfiguration;

    return items.isEmpty ? Container(
      width: double.infinity,
      height: double.infinity,
      child:LoadingPage(),
    ) :  GridView.builder(
        addAutomaticKeepAlives: true,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, mainAxisSpacing: configuration.verticalSpacing),
        itemCount: items.isEmpty ? 0: items.length,
        itemBuilder: (context, index) {
          DateModel dateModel = items[index];
          switch(configuration.selectMode){
            case CalendarConstants.MODE_MULTI_SELECT :
              if (calendarProvider.selectedDateList.contains(dateModel)) {
                dateModel.isSelected = true;
              } else {
                dateModel.isSelected = false;
              }
              break;
            case CalendarConstants.MODE_SINGLE_SELECT :
              if (calendarProvider.selectDateModel == dateModel) {
                dateModel.isSelected = true;
              } else {
                dateModel.isSelected = false                                                                                                                                                               ;
              }
              break;
            case CalendarConstants.MODE_INTERVAL_SELECT :
              if( dateModel.isSelected  == null) {
                dateModel.isSelected = false;
              }
              break;
          }
          //判断是否被选择
//          if (configuration.selectMode == CalendarConstants.MODE_MULTI_SELECT) {
//
//          } else {
//
//          }
          return  ItemContainer(
            dateModel: dateModel,
              onTap :(val) async{
                setState(() {
                  items = val;
                });
          },
            key: ObjectKey(
                dateModel), //这里使用objectKey，保证可以刷新。原因1：跟flutter的刷新机制有关。原因2：statefulElement持有state。
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}

/* *
 * 多选模式，包装item，这样的话，就只需要刷新当前点击的item就行了，不需要刷新整个页面
 */
class ItemContainer extends StatefulWidget {
  final DateModel dateModel;
  final ValueChanged<List<DateModel>> onTap;

  const ItemContainer({
    Key key,
    this.dateModel,
    this.onTap,
  }) : super(key: key);

  @override
  ItemContainerState createState() => ItemContainerState();
}

class ItemContainerState extends State<ItemContainer> {
  DateModel dateModel;
  CalendarConfiguration configuration;
  CalendarProvider calendarProvider;
  ValueNotifier<bool> isSelected;

  @override
  void initState() {
    super.initState();
    dateModel = widget.dateModel;
    isSelected = ValueNotifier(dateModel.isSelected);
    calendarProvider = Provider.of<CalendarProvider>(context, listen: false);
    configuration = calendarProvider.calendarConfiguration;
    ///单选处理默认选中(多选后期处理)
    if (configuration.selectMode == CalendarConstants.MODE_SINGLE_SELECT) {
      if(dateModel == calendarProvider.selectDateModel){
        calendarProvider.lastClickItemState = this;
//        print(" calendarProvider.lastClickItemState = ${ calendarProvider.lastClickItemState.dateModel.isSelected}");
//        print(" calendarProvider.lastClickItemState = ${ calendarProvider.lastClickItemState.dateModel}");
//        _onTap();
      }
    }
//    先注释掉这段代码
//    WidgetsBinding.instance.addPostFrameCallback((callback) {
//      if (configuration.selectMode == CalendarConstants.MODE_SINGLE_SELECT &&
//          dateModel.isSelected) {
//        calendarProvider.lastClickItemState = this;
//      }
//    });
  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  /* *
   * 提供方法给外部，可以调用这个方法进行刷新item
   */
  void refreshItem(bool v) {
    /**
        Exception caught by gesture
        The following assertion was thrown while handling a gesture:
        setState() called after dispose()
     */
    if (mounted) {
      setState(() {
        dateModel.isSelected = v;
//        isSelected.value = !isSelected.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
//    LogUtil.log(TAG: this.runtimeType, message: "ItemContainerState build");
    return GestureDetector(
      //点击整个item都会触发事件
      behavior: HitTestBehavior.opaque,
      onTap: () {

        _onTap();
        //范围外不可点击

      },
      child: configuration.dayWidgetBuilder(dateModel),
    );
  }


  void _onTap(){
    if (!dateModel.isInRange) {
      //多选回调
      if (configuration.selectMode == CalendarConstants.MODE_MULTI_SELECT) {
        configuration.multiSelectOutOfRange();
      }
      return;
    }
    calendarProvider.lastClickDateModel = dateModel;
    switch(configuration.selectMode){
      case CalendarConstants.MODE_MULTI_SELECT :
        modeMultiSelect();
        break;
      case CalendarConstants.MODE_SINGLE_SELECT :
         modeSingleSelect();
        break;
      case CalendarConstants.MODE_INTERVAL_SELECT :
         modelIntervalSelect();
        break;
    }
  }

  ///处理单选逻辑
  void modeSingleSelect(){
    ///判断是否是重复点击 || 根据是否可以点击下一月判断是否点击
    if(calendarProvider.isExceedNotClick &&  calendarProvider.lastMont.month != dateModel.month)return;
    calendarProvider.selectDateModel = dateModel;
    if (configuration.calendarSelect != null) {
      configuration.calendarSelect(dateModel);
    }

    //单选需要刷新上一个item
    if (calendarProvider.lastClickItemState != this) {
      calendarProvider.lastClickItemState?.refreshItem(false);
      calendarProvider.lastClickItemState = this;
    }
    refreshItem(true);
  }
  ///处理多选逻辑
  void modeMultiSelect(){
    if (calendarProvider.selectedDateList.contains(dateModel)) {
      calendarProvider.selectedDateList.remove(dateModel);
    } else {
      //多选，判断是否超过限制，超过范围
      if (calendarProvider.selectedDateList.length ==
          configuration.maxMultiSelectCount) {
        if (configuration.multiSelectOutOfSize != null) {
          configuration.multiSelectOutOfSize();
        }
        return;
      }
      calendarProvider.selectedDateList.add(dateModel);
    }
    if (configuration.calendarSelect != null) {
      configuration.calendarSelect(dateModel);
    }

    //多选也可以弄这些单选的代码
    calendarProvider.selectDateModel = dateModel;
    refreshItem(!dateModel.isSelected);
  }
  ///区间选择逻辑
  void modelIntervalSelect(){
    calendarProvider.selectDateModel = dateModel;
    calendarProvider.selectedDateList.add(dateModel);
    ///判断是否是第一次选择
  if(calendarProvider.lastClickItemState != null){
    ///判断超过三条数据清空重选
    if(calendarProvider.selectedDateList.length > 2){
      calendarProvider.selectedDateList.clear();
      calendarProvider.selectedDateList.add(dateModel);
    }
    print("数据1 = ${calendarProvider.lastClickItemState.dateModel.getDateTime()}");
    print("数据2 = ${dateModel.getDateTime()}");
    ///判断第一次选择数据是否在第二次选择数据之后
   if(calendarProvider.lastClickItemState.dateModel.getDateTime().compareTo(dateModel.getDateTime()) <= 0){
     DateModel last = DateModel.fromDateTime(DateTime(dateModel.year, dateModel.month, 1));
     DateModel first = DateModel.fromDateTime(DateTime(calendarProvider.lastClickItemState.dateModel.year, calendarProvider.lastClickItemState.dateModel.month, 1));
   List<DateModel> _itemsFirst = List();
   CacheData.getInstance().monthListCache[last].forEach((item){
     if(item.getDateTime().compareTo(calendarProvider.lastClickItemState.dateModel.getDateTime()) >= 0 && item.getDateTime().compareTo(dateModel.getDateTime()) <= 0){
       item.isSelected = true;
     }
     _itemsFirst.add(item);
   });
   widget.onTap(_itemsFirst);

   }
    if (configuration.calendarSelect != null) {
      configuration.calendarSelect(dateModel);
    }
  }
    if (calendarProvider.lastClickItemState != this) {
      calendarProvider.lastClickItemState = this;
    }
    refreshItem(true);
  }

  @override
  void deactivate() {
//    LogUtil.log(
//        TAG: this.runtimeType, message: "ItemContainerState deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
//    LogUtil.log(TAG: this.runtimeType, message: "ItemContainerState dispose");
    super.dispose();
  }

  @override
  void didUpdateWidget(ItemContainer oldWidget) {
//    LogUtil.log(
//        TAG: this.runtimeType, message: "ItemContainerState didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }
}
