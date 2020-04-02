import 'package:flutter/material.dart';
import 'package:flutterbasics/page/index.dart';
import 'package:oktoast/oktoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return OKToast(
        child:MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: PageIndex(),
        )
    );
  }
}
