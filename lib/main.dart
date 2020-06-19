import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterbasics/page/index.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sentry/sentry.dart';
final SentryClient _sentry = new SentryClient(dsn: 'http://b1d8f0e6d2ae4ec188e125f05aecead0@172.16.1.241:9000/12');
Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  print("异常收集 error = $error");
  _sentry.captureException(
    exception: error,
    stackTrace: stackTrace,
  );
}
Future<Null> main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };
  runZoned<Future<void>>(() async {
    runApp(MyApp());
  }, onError: (error, stackTrace)  async {
    // Whenever an error occurs, call the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
    print(error);
    print(stackTrace);
//  await  _reportError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  bool backExitApp = false;
  @override
  Widget build(BuildContext context) {
    return OKToast(
        child:MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: WillPopScope(
            onWillPop: () async {
              if (backExitApp) {
                return true;
              } else {
                //todo 显示toast消息: 再点一次退出app
                showToast(
                  '再点一次退出',
                  radius: 2,
                  duration: Duration(seconds: 2),
                  dismissOtherToast: true,
                  backgroundColor: Color.fromRGBO(0, 0, 0, 0.6),
                );
                backExitApp = true;
                Future.delayed(
                  const Duration(seconds: 1),
                      () => backExitApp = false,
                );
                return false;
              }
            },
            child: PageIndex(),
          ) ,
        )
    );
  }
}
