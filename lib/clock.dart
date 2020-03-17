import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  static DateTime curTime = DateTime.now();

  String timeText = '${curTime.hour.toString().padLeft(2, '0')}:'
      '${curTime.minute.toString().padLeft(2, '0')}:'
      '${curTime.second.toString().padLeft(2, '0')}';

  Color btnTextColor = Colors.white38;
  Color disabledBtnTextColor = Colors.white38;
  Color enabledBtnTextColor = Colors.white;

  Function whichFormat = format24Hour;
  String currentTimeFormatStr = '24';

  ///pad the time
  static String padTime(String timeVal) => timeVal.padLeft(2, '0');

  ///updates the time
  void updateTime() async {
    setState(() {
      timeText = whichFormat();
    });
    await Future.delayed(const Duration(seconds: 1));
    updateTime();
  }

  ///wakelock button handler
  void wakeState() {
    setState(
      () {
        if (btnTextColor == enabledBtnTextColor) {
          Wakelock.disable();
          btnTextColor = disabledBtnTextColor;
        } else {
          Wakelock.enable();
          btnTextColor = enabledBtnTextColor;
        }
      },
    );
  }

  ///update time formatter
  Function updateTimeFormatter(String formatName) => formatName == '12' ? format12Hour : format24Hour;

  ///returns time as a string in 12 hour format
  static String format12Hour() {
    DateTime currentTime = DateTime.now();
    String currentHour = currentTime.hour.toString();
    String currentMinute = currentTime.minute.toString();
    String currentSecond = currentTime.second.toString();

    if (int.tryParse(currentHour) > 12) {
      currentHour = (int.tryParse(currentHour) - 12).toString();
    }

    currentHour = padTime(currentHour);
    currentMinute = padTime(currentMinute);
    currentSecond = padTime(currentSecond);

    return '$currentHour:$currentMinute:$currentSecond';
  }

  ///returns time as a string in 24 hour format
  static String format24Hour() {
    DateTime currentTime = DateTime.now();
    String currentHour = currentTime.hour.toString();
    String currentMinute = currentTime.minute.toString();
    String currentSecond = currentTime.second.toString();

    currentHour = padTime(currentHour);
    currentMinute = padTime(currentMinute);
    currentSecond = padTime(currentSecond);

    return '$currentHour:$currentMinute:$currentSecond';
  }

  @override
  void initState() {
    super.initState();
    updateTime();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: orientation == Orientation.portrait ? 30 : 18,
            child: Padding(
              padding: orientation == Orientation.portrait ? const EdgeInsets.only(top: 32.0) : const EdgeInsets.only(top: 64.0),
              child: Center(
                child: Text(
                  timeText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: orientation == Orientation.portrait ? 84 : 164,
                    fontFamily: 'Prism',
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: orientation == Orientation.portrait ? 2 : 3,
            child: Center(
              child: CupertinoSlidingSegmentedControl(
                backgroundColor: Colors.blueGrey.shade600,
              thumbColor: Colors.blueGrey.shade700,
              groupValue: currentTimeFormatStr,
              children: {
                '12': Container(
                  child: Center(
                    child: Text(
                      '12 Hours',
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
                '24': Container(
                  child: Center(
                    child: Text(
                      '24 Hours',
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
              },
              onValueChanged: (fmt) {
                  currentTimeFormatStr = fmt;
                  whichFormat = updateTimeFormatter(fmt);
              },
            )),
          ),
          Expanded(
            flex: 3,
            child: FlatButton(
              child: Text(
                'STAY AWAKE',
                style: TextStyle(
                  color: btnTextColor,
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                ),
              ),
              color: Colors.blueGrey.shade700,
              onPressed: wakeState,
            ),
          ),
        ],
      );
    });
  }
}