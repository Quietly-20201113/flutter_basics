import 'package:flutter/material.dart';
import 'package:flutterbasics/page/index.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sentry/sentry.dart';
final SentryClient sentry = new SentryClient(dsn: 'http://b1d8f0e6d2ae4ec188e125f05aecead0@172.16.1.241:9000/12');
void main() async {
  try {
    runApp(MyApp());
  } catch(error, stackTrace) {
    await sentry.captureException(
      exception: error,
      stackTrace: stackTrace,
    );
  }
}

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
