import 'dart:async';

import 'package:flutter/material.dart';

class Count_Down extends StatefulWidget {
  @override
  _Count_DownState createState() => _Count_DownState();
}

class _Count_DownState extends State<Count_Down> {
  Timer _timer;
  int _start = 30;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.grey.shade100.withOpacity(0.2)
            ),
            child: IconButton(
                icon: new Image.asset(
                    'assets/images/ic_send_verifi.png'),
                iconSize: 28,
                onPressed: () {
                  startTimer();
                }
            ),
          ),
          Container(
            child: Text('$_start'),
          )
        ],
      ),
    );
  }
}
