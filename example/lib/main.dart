import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thepeer_flutter/thepeer_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      ),
      child: MaterialApp(
        title: 'Thepeer Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(title: 'Thepeer Demo'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          widget.title ?? '',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 60,
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: CupertinoButton(
                    color: thepeerColor,
                    child: Center(
                      child: Text(
                        'Launch Send',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      await ThepeerSendView(
                        data: ThePeerData(
                          publicKey:
                              "pspk_test_2aj8xasztf4domzd2nphinvzkvecpbuyxldkvr3pkuvko",
                          amount: 400000,
                          userReference: "73f03de5-1043-4ad1-bc2e-aa4d94ebee4f",
                          meta: {
                            'slug': 'F1rstm3ssag!ngSl0g',
                            'type': 'chat',
                            'paymentType': 'subscription',
                            'channel': 'thePeer',
                          },
                        ),
                        showLogs: true,
                        onClosed: () {
                          print('closed');
                          Navigator.pop(context);
                        },
                        onSuccess: (v) {
                          print(v.toString());
                          Navigator.pop(context);
                        },
                        onError: print,
                      ).show(context);
                    },
                  ),
                ),
                const SizedBox(height: 60),
                Container(
                  height: 60,
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: CupertinoButton(
                    color: Colors.black,
                    child: Center(
                      child: Text(
                        'Launch Direct Charge',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      await ThepeerDirectChargeView(
                        data: ThePeerData(
                          publicKey:
                              "pspk_test_2aj8xasztf4domzd2nphinvzkvecpbuyxldkvr3pkuvko",
                          amount: 400000,
                          userReference: "73f03de5-1043-4ad1-bc2e-aa4d94ebee4f",
                          meta: {
                            'slug': 'F1rstm3ssag!ngSl0g',
                            'type': 'chat',
                            'paymentType': 'subscription',
                            'channel': 'thePeer',
                          },
                        ),
                        showLogs: true,
                        onClosed: () {
                          print('closed');
                          Navigator.pop(context);
                        },
                        onSuccess: (v) {
                          print(v.toString());
                          Navigator.pop(context);
                        },
                        onError: print,
                      ).show(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

final thepeerColor = Color(0xff1890ff);
