import 'package:flutter/material.dart';

header(
  BuildContext context,
  Function functionGoBack, {
  String title = '',
  bool isButtonLeft = true,
  bool isButtonRight = false,
  String imageRightButton = 'assets/images/task_list.png',
  required Function? rightButton,
  String menu = '',
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(50),
    child: AppBar(
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_header.png'),
            fit: BoxFit.cover,
          ),
        ),
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.centerLeft,
        //     end: Alignment.centerRight,
        //     colors: <Color>[
        //       Color(0xFFFF7900),
        //       Color(0xFFFF7900),
        //     ],
        //   ),
        // ),
      ),
      backgroundColor: Color(0xFFFF7900),
      elevation: 0.0,
      titleSpacing: 5,
      automaticallyImplyLeading: false,
      title: Text(
        // ignore: unnecessary_null_comparison
        title != null ? title : '',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.normal,
          fontFamily: 'Sarabun',
        ),
      ),
      leading: isButtonLeft
          ? InkWell(
              onTap: () => functionGoBack(),
              child: Container(
                padding: EdgeInsets.all(12),
                child: Image.asset(
                  "assets/icons/arrow_left_1.png",
                  color: Colors.white,
                ),
              ),
            )
          : null,
      actions: <Widget>[
        isButtonRight
            ? Container(
                child: Container(
                  child: Container(
                    width: 42.0,
                    height: 42.0,
                    margin: EdgeInsets.only(top: 6.0, right: 10.0, bottom: 6.0),
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => rightButton!(),
                      child: Image.asset(
                        imageRightButton,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    ),
  );
}
