import 'package:security_2025_mobile_v3/component/headerCalendar.dart';
import 'package:security_2025_mobile_v3/pages/event_calendar/calendar.dart';
import 'package:security_2025_mobile_v3/pages/event_calendar/event_calendar_list.dart';
import 'package:flutter/material.dart';

class EventCalendarMain extends StatefulWidget {
  EventCalendarMain({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _EventCalendarMain createState() => _EventCalendarMain();
}

class _EventCalendarMain extends State<EventCalendarMain> {
  bool showCalendar = false;
  @override
  void initState() {
    super.initState();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  void changeTab() async {
    // Navigator.pop(context, false);
    setState(() {
      showCalendar = !showCalendar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: headerCalendar(
        context,
        goBack,
        showCalendar,
        title: widget.title,
        rightButton: () => (), //changeTab(),
        showLeading: false,
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: showCalendar
            ? CalendarPage()
            : EventCalendarList(title: widget.title),
      ),
    );
  }
}
