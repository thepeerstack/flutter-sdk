import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final VoidCallback? reload;

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
          crossAxisAlignment: CrossAxisAlignment.center,
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
                child: Text(
                  'Reload',
                  style: TextStyle(fontSize: 14),
                ),
                color: Color(0xff1890ff),
                onPressed: reload 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
