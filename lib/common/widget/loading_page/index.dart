import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutterbasics/common/theme/app_theme.dart';

class LoadingPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Center(
        child: SizedBox(
          height: 100.0,
          width: 100.0,
          child: Card(
            elevation: 0.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 50.0,
                  height: 50.0,
                  child:SpinKitFadingFour(
                    color:AppTheme.rcColor.primary00CCA9,
                    size: 30.0,
                      shape: BoxShape.rectangle
                  ) ,
                )
              ],
            ),
          ),
        )
    );
  }

}