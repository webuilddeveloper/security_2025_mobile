import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt_picker;

datePicker(
    {required TextEditingController controller,
    required String title,
    double fontSize = 13,
    required BuildContext context}) {
  return InkWell(
    onTap: () {
      dialogOpenPickerDate(context, controller);
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 15.000,
            fontFamily: 'Sarabun',
            color: Color(0xFFFF7514),
          ),
        ),
        Container(
          height: 45,
          child: TextField(
            controller: controller,
            style: TextStyle(
              color: Color(0xFF000070),
              fontWeight: FontWeight.normal,
              fontFamily: 'Sarabun',
              fontSize: 15.0,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFFC5DAFC),
              contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              hintText: "วันเดือนปีเกิด",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              errorStyle: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: 'Sarabun',
                fontSize: 10.0,
              ),
            ),
            enabled: false,
          ),
        )
      ],
    ),
  );
}

dialogOpenPickerDate(BuildContext context, TextEditingController controller) {
  dt_picker.DatePicker.showDatePicker(context,
      theme: dt_picker.DatePickerTheme(
        containerHeight: 210.0,
        itemStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF005C9E),
          fontWeight: FontWeight.normal,
          fontFamily: 'Sarabun',
        ),
        doneStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF005C9E),
          fontWeight: FontWeight.normal,
          fontFamily: 'Sarabun',
        ),
        cancelStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF005C9E),
          fontWeight: FontWeight.normal,
          fontFamily: 'Sarabun',
        ),
      ),
      showTitleActions: true,
      minTime: DateTime(1800, 1, 1),
      maxTime: DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day),
      onConfirm: (date) {
    // print('----- onConfirm -----' +
    //     date.year.toString() +
    //     date.month.toString() +
    //     date.day.toString());
    controller.text = date.day.toString() +
        '-' +
        date.month.toString() +
        '-' +
        date.year.toString();
    // controller.text = dateFormatGlobal(
    //     date.year.toString() + date.month.toString() + date.day.toString());
  },
      currentTime: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      locale: dt_picker.LocaleType.th);
}
