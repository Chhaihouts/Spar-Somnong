import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_kickstart/environment/config.dart';
import 'package:flutter_kickstart/environment/dev.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class AudioWidget extends StatefulWidget {
  final String path;
  final Function onPlayClick;

  AudioWidget(this.path, {this.onPlayClick});

  @override
  State<StatefulWidget> createState() {
    return _AudioState();
  }
}

class _AudioState extends State<AudioWidget> {
  bool _isPlaying = false;
  StreamSubscription _recorderSubscription;
  StreamSubscription _dbPeakSubscription;
  StreamSubscription _playerSubscription;
  FlutterSound flutterSound;

  String _playerTxt = '00:00';
  double _dbLevel;

  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;

  var appConfig = Config.fromJson(config);


  @override
  void initState() {
    print("path is ${widget.path}");
    flutterSound = new FlutterSound();
    flutterSound.setSubscriptionDuration(0.01);
    flutterSound.setDbPeakLevelUpdate(0.8);
    flutterSound.setDbLevelEnabled(true);
    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(0.0),
              child: Stack(
                children: [
                  Container(
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      leading: Container(
                        decoration: BoxDecoration(
                            color: Theme
                                .of(context)
                                .primaryColor,
                            shape: BoxShape.circle

                        ),
                        child: IconButton(
                            onPressed: _isPlaying
                                ? () => _stopPlayer()
                                : () => _startPlayer(),
                            iconSize: 14.0,
                            icon: _isPlaying
                                ? Icon(Icons.pause)
                                : Icon(Icons.play_arrow),
                            color: Colors.white),
                      ),
                      title: Container(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Padding(
                                child: Text(this._playerTxt, style: TextStyle(fontSize: 14),),
                                padding: EdgeInsets.all(2.0),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: LinearProgressIndicator(
                                value: 100.0 /
                                    160.0 *
                                    (this._dbLevel ?? 1) /
                                    100,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.green),
                                backgroundColor: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    flutterSound?.stopRecorder();
    _playerSubscription?.cancel();
    _playerSubscription = null;
    super.dispose();
  }

  _startPlayer() async {
    try {
      var uri = "${appConfig.baseUrl}/${widget.path}";
      String path = await flutterSound.startPlayer(
          Uri.encodeFull(uri)
      );
      await flutterSound.setVolume(1.0);

      _playerSubscription = flutterSound.onPlayerStateChanged.listen((e) {
        if (e != null) {
          sliderCurrentPosition = e.currentPosition;
          maxDuration = e.duration;

          DateTime date = new DateTime.fromMillisecondsSinceEpoch(
              e.currentPosition.toInt(),
              isUtc: true);
          String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
          this.setState(() {
            this._isPlaying = true;
            this._playerTxt = txt.substring(0, 8);
          });
        } else {
          setState(() {
            this._isPlaying = false;
          });
          _stopPlayer();
        }
      });
    } catch (err) {
      print('error: $err');
    }
  }

  _stopPlayer() async {
    print("stop player");
    try {
      String result = await flutterSound.stopPlayer();
      print('stopPlayer: $result');
      if (_playerSubscription != null) {
        _playerSubscription.cancel();
        _playerSubscription = null;
      }

      this.setState(() {
        this._isPlaying = false;
        this._playerTxt = '00:00:00';
      });
    } catch (err) {
      print('error: $err');
    }
  }

  _pausePlayer() async {
    String result = await flutterSound.pausePlayer();
    print('pausePlayer: $result');
  }

  _resumePlayer() async {
    String result = await flutterSound.resumePlayer();
    print('resumePlayer: $result');
  }
}
