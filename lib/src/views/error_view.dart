import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final Function reload;

  const ErrorView({Key? key, required this.reload});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: Container(
          width: 300,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Could not connect with Peerstack',
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoButton(
                  child: Text('Reload'),
                  color: Colors.blue,
                  onPressed: reload as void Function()?,
                ),
              ),
            ],
          ),
        ));
  }
}
