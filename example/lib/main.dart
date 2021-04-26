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
        title: 'Peerstack Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(title: 'Peerstack Demo'),
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
  final peerstackPublicKey = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title ?? '',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 1,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Column(
            children: [
              Container(
                height: 60,
                margin: EdgeInsets.symmetric(horizontal: 60),
                child: CupertinoButton(
                  color: peerstackColor,
                  child: Center(
                    child: Text(
                      'Launch thePeer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    await PeerstackView(
                      data: ThePeerData(
                        amount: 10000,
                        firstName: 'Chiziaruhoma',
                        receiptUrl: 'api.codenka.com/payment',
                        publicKey: peerstackPublicKey,
                        userReference: 'chiziaruhoma@gmail.com',
                      ),
                      showLogs: true,
                      onClosed: () {
                        Navigator.pop(context);
                      },
                      onSuccess: () {
                        Navigator.pop(context);
                      },
                    ).show(context);
                  },
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}

final peerstackColor = Color(0xff1890ff);
