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
  final CalendarController calendarController;

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
  int lineCount;
  Map<DateModel, Object> extraDataMap; //自定义额外的数据
  CalendarConfiguration configuration;
  CalendarProvider calendarProvider;

  @override
  void initState() {
    super.initState();
    extraDataMap = widget.configuration.extraDataMap;
    calendarProvider = Provider.of<CalendarProvider>(context, listen: false);
    if (calendarProvider.calendarConfiguration.selectMode ==
        CalendarConstants.MODE_INTERVAL_SELECT) {
      ///区间选择时需要监听数据
      widget.calendarController.addOnCalendarSelectListener((dateModel) {
        ///处理calendarProvider.selectedDateList里面数据乱序问题
        List<DateModel> _listDate = calendarProvider.selectedDateList.toList();
        _listDate.sort(
            (left, right) => left.getDateTime().compareTo(right.getDateTime()));
        ///进行计算更改数据
        refreshDate(_listDate,dateModel);
      });
    }

    DateModel firstDayOfMonth =
        DateModel.fromDateTime(DateTime(widget.year, widget.month, 1));
    lineCount = DateUtil.getMonthViewLineCount(
        widget.year, widget.month, widget.configuration.offset);
    //第一帧后,添加监听，generation发生变化后，需要刷新整个日历
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      Provider.of<CalendarProvider>(context, listen: false)
          .generation
          .addListener(() async {
        extraDataMap = widget.configuration.extraDataMap;
        getItems().then((val) {
          calendarProvider.setMonthListCache(firstDayOfMonth, val);
        });
      });
    });
  }

  ///
  /// @param _listDate 选中数组
  /// @param dateModel 当前月份数组[主要用作判断是监听方法还是回调方法]
  /// @author 丁平
  /// created at 2020/6/23 16:44
  ///
  void refreshDate(List<DateModel> _listDate, [DateModel dateModel]) {
    DateModel _one = _listDate.first;
    DateModel _two = _listDate.last;
    ///计算相差月份
    int _oneM = _one.getDateTime().customDifference(_two.getDateTime());
    for (int i = 0; i <= _oneM; i++) {
      ///自动计算月份年份
      DateModel _firstDayOfMonth = DateModel.fromDateTime(DateTime(
          _one.year + (i > 12 ? 13 % 12 : 0),
          _one.month + (i > 12 ? i > 12 ? 13 % 12 : 0 : i),
          1));
      setDateModel(_firstDayOfMonth, _listDate,dateModel == null ? false : true).then((_list) {
        CacheData.getInstance().monthListCache[DateModel.fromDateTime(
                DateTime(_firstDayOfMonth.year, _firstDayOfMonth.month, 1))] =
            _list;

        ///判断是否是当前页,进行赋值刷新
        if ( dateModel != null && _firstDayOfMonth
                .getDateTime()
                .customDifference(dateModel.getDateTime()) ==
            0) {
          setState(() {});
        }
      });
    }
  }

  ///处理区间选择逻辑
  /// @param _one 月份第一天
  /// @param _dateList 月份list数据
  /// @param flag 判断是需要选中还是取消选中
  /// @author 丁平
  /// created at 2020/6/23 16:40
  ///
  Future<List<DateModel>> setDateModel(
      DateModel _one, List<DateModel> _dateList,[bool flag = true]) async {
    DateModel _firstDayOfMonth =
        DateModel.fromDateTime(DateTime(_one.year, _one.month, 1));
    List<DateModel> _items = List();
    ///如果没有数据时根据月份自动生成
    List<DateModel> _items_ =
        CacheData.getInstance().monthListCache[_firstDayOfMonth] ??
            await compute(initCalendarForMonthView, {
              'year': _firstDayOfMonth.year,
              'month': _firstDayOfMonth.month,
              'minSelectDate': widget.configuration.minSelectDate,
              'maxSelectDate': widget.configuration.maxSelectDate,
              'extraDataMap': extraDataMap,
              'offset': widget.configuration.offset
            });
    _items_.forEach((item) {
      item.isSelected = flag ?
          item.getDateTime().compareTo(_dateList.first.getDateTime()) >= 0 &&
              item.getDateTime().compareTo(_dateList.last.getDateTime()) <= 0 : false; ///判断是否在区间内
      item.isInterval = flag?
          item.getDateTime().compareTo(_dateList.first.getDateTime()) > 0 &&
              item.getDateTime().compareTo(_dateList.last.getDateTime()) < 0 : false;///判断是否在区间内进行更改颜色
      _items.add(item);
    });
    return _items;
  }

  ///根据月份生成正月数据
  Future<List<DateModel>> getItems() async {
    return compute(initCalendarForMonthView, {
      'year': widget.year,
      'month': widget.month,
      'minSelectDate': widget.configuration.minSelectDate,
      'maxSelectDate': widget.configuration.maxSelectDate,
      'extraDataMap': extraDataMap,
      'offset': widget.configuration.offset
    });
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
    configuration = calendarProvider.calendarConfiguration;
    DateModel _firstDayOfMonth =
        DateModel.fromDateTime(DateTime(widget.year, widget.month, 1));
    ///添加ValueListenableBuilder,是为了更改后自动刷新数据
    ///弊端 -  滑动太快会出现白屏
    return ValueListenableBuilder(
        valueListenable: calendarProvider.isNull,
        builder: (context, value, chile) {
          return calendarProvider.isNull.value
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: LoadingPage(),
                )
              : GridView.builder(
                  addAutomaticKeepAlives: true,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: configuration.verticalSpacing),
                  itemCount: CacheData.getInstance()
                          .monthListCache[_firstDayOfMonth]
                          ?.length ??
                      0,
                  itemBuilder: (context, index) {
                    DateModel dateModel = CacheData.getInstance()
                        .monthListCache[_firstDayOfMonth][index];
                    switch (configuration.selectMode) {
                      case CalendarConstants.MODE_MULTI_SELECT:
                        if (calendarProvider.selectedDateList
                            .contains(dateModel)) {
                          dateModel.isSelected = true;
                        } else {
                          dateModel.isSelected = false;
                        }
                        break;
                      case CalendarConstants.MODE_SINGLE_SELECT:
                        if (calendarProvider.selectDateModel == dateModel) {
                          dateModel.isSelected = true;
                        } else {
                          dateModel.isSelected = false;
                        }
                        break;
                      case CalendarConstants.MODE_INTERVAL_SELECT:
                        if (dateModel.isSelected == null) {
                          dateModel.isSelected = false;
                        }
                        break;
                    }
                    return ItemContainer(
                      dateModel: dateModel,
                        onChange : (_listDate) {
                          refreshDate(_listDate);
                       },
                      key: ObjectKey(
                          dateModel), //这里使用objectKey，保证可以刷新。原因1：跟flutter的刷新机制有关。原因2：statefulElement持有state。
                    );
                  });
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
  final ValueChanged onChange;
  const ItemContainer({
    Key key,
    this.dateModel,
    this.onChange,
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
      if (dateModel == calendarProvider.selectDateModel) {
        calendarProvider.lastClickItemState = this;
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

  void _onTap() {
    if (!dateModel.isInRange) {
      //多选回调
      if (configuration.selectMode == CalendarConstants.MODE_MULTI_SELECT) {
        configuration.multiSelectOutOfRange();
      }
      return;
    }
    calendarProvider.lastClickDateModel = dateModel;
    switch (configuration.selectMode) {
      case CalendarConstants.MODE_MULTI_SELECT:
        modeMultiSelect();
        break;
      case CalendarConstants.MODE_SINGLE_SELECT:
        modeSingleSelect();
        break;
      case CalendarConstants.MODE_INTERVAL_SELECT:
        _modelIntervalSelect();
        break;
    }
  }

  ///处理单选逻辑
  void modeSingleSelect() {
    ///判断是否是重复点击 || 根据是否可以点击下一月判断是否点击
    if (calendarProvider.isExceedNotClick &&
        calendarProvider.lastMont.month != dateModel.month) return;
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
  void modeMultiSelect() {
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
  void _modelIntervalSelect() {
    if(calendarProvider.selectedDateList.length == 2){
      widget.onChange(calendarProvider.selectedDateList.toList());
    }
    calendarProvider.selectDateModel = dateModel;
    calendarProvider.selectedDateList.add(dateModel);

    ///判断是否是第一次选择
    if (calendarProvider.lastClickItemState != null) {
      ///判断超过三条数据清空重选
      if (calendarProvider.selectedDateList.length > 2) {
        calendarProvider.selectedDateList.clear();
        calendarProvider.selectedDateList.add(dateModel);
      }

      ///判断第一次选择数据是否在第二次选择数据之后
      if (calendarProvider.lastClickItemState.dateModel
              .getDateTime()
              .compareTo(dateModel.getDateTime()) >
          0) {
        calendarProvider.selectedDateList.clear();
        if (calendarProvider.lastClickItemState != this) {
          calendarProvider.lastClickItemState?.refreshItem(false);
        }
        calendarProvider.selectedDateList.add(dateModel);
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
