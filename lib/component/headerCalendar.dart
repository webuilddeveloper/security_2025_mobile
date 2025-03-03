import 'package:flutter/material.dart';

headerCalendar(BuildContext context, Function functionGoBack, bool showCalendar,
    {String title = '',
    required Function rightButton,
    bool showLeading = true}) {
  return AppBar(
    centerTitle: true,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor,
          ],
        ),
      ),
    ),
    backgroundColor: Theme.of(context).primaryColor,
    elevation: 0.0,
    titleSpacing: 5,
    automaticallyImplyLeading: false,
    title: Text(
      // ignore: unnecessary_null_comparison
      title != null ? title : '',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        fontFamily: 'Sarabun',
        color: Colors.white,
      ),
    ),
    leading: showLeading
        ? InkWell(
            onTap: () => functionGoBack(),
            child: Container(
              child: Image.asset(
                "assets/images/arrow_left.png",
                color: Colors.white,
                width: 40,
                height: 40,
              ),
            ),
          )
        : null,
    actions: <Widget>[
      Container(
        child: Container(
          child: Container(
            width: 42.0,
            height: 42.0,
            margin: EdgeInsets.only(top: 6.0, right: 10.0, bottom: 6.0),
            padding: EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () => rightButton(),
              // child: Image.asset('assets/images/task_list.png'),
              child: showCalendar
                  ? Image.asset('assets/logo/icons/Group878.png')
                  : Image.asset('assets/images/task_list.png'),
            ),
          ),
        ),
      )
    ],
  );
}
