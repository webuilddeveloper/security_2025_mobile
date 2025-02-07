import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt_picker;
import 'package:intl/intl.dart';

unfocus(context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

moneyFormat(String price) {
  if (price.length > 2) {
    var value = price;
    value = value.replaceAll(RegExp(r'\D'), '');
    value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
    return value;
  }
}

dateStringToDate(String date) {
  var year = date.substring(0, 4);
  var month = date.substring(4, 6);
  var day = date.substring(6, 8);
  // DateTime todayDate = DateTime.parse(year + '-' + month + '-' + day);
  // var onlyBuddhistYear = todayDate.yearInBuddhistCalendar;
  // fixflutter2 var formatter = DateFormat.yMMMMd();
  // var dateInBuddhistCalendarFormat =
  //     formatter.formatInBuddhistCalendarThai(todayDate);
  // return (dateInBuddhistCalendarFormat);
  return '$day-$month-$year';
}

dateStringToDateBirthDay(String date) {
  var year = date.substring(0, 4);
  var month = date.substring(4, 6);
  var day = date.substring(6, 8);
  DateTime todayDate = DateTime.parse(year + '-' + month + '-' + day);

  return (todayDate);
}

dateStringToDateStringFormat(String date, {String type = '/'}) {
  String result = '';
  if (date != '') {
    String yearString = date.substring(0, 4);
    var yearInt = int.parse(yearString);
    var year = yearInt + 543;
    var month = date.substring(4, 6);
    var day = date.substring(6, 8);
    result = day + type + month + type + year.toString();
  }

  return result;
}

// List<Identity> toListModel(List<dynamic> model) {
//   var list = new List<Identity>();
//   model.forEach((element) {
//     var m = new Identity();
//     m.code = element['code'] != null ? element['code'] : '';
//     m.title = element['title'] != null ? element['title'] : '';
//     m.description =
//         element['description'] != null ? element['description'] : '';
//     m.imageUrl = element['imageUrl'] != null ? element['imageUrl'] : '';
//     m.createBy = element['createBy'] != null ? element['createBy'] : '';
//     m.createDate = element['createDate'] != null ? element['createDate'] : '';
//     m.imageUrlCreateBy = element['imageUrlCreateBy'] != null ? element['imageUrlCreateBy'] : '';
//     list.add(m);
//   });

//   return list;
// }

// Identity toModel(dynamic model) {
//   var m = new Identity();
//   m.code = model['code'] != null ? model['code'] : '';
//   m.title = model['title'] != null ? model['title'] : '';
//   m.description = model['description'] != null ? model['description'] : '';
//   m.imageUrl = model['imageUrl'] != null ? model['imageUrl'] : '';
//   m.createBy = model['createBy'] != null ? model['createBy'] : '';
//   m.createDate = model['createDate'] != null ? model['createDate'] : '';
//   m.imageUrlCreateBy = model['imageUrlCreateBy'] != null ? model['imageUrlCreateBy'] : '';

//   return m;
// }

dialogDatePicker(
  BuildContext context, {
  required int year,
  required int month,
  required int day,
  required Function callback,
  required TextEditingController controller,
}) {
  var _selectedYear = 0;
  var _selectedMonth = 0;
  var _selectedDay = 0;
  dt_picker.DatePicker.showDatePicker(context,
      theme: dt_picker.DatePickerTheme(
        containerHeight: 210.0,
        itemStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF9A1120),
          fontWeight: FontWeight.normal,
          fontFamily: 'Sarabun',
        ),
        doneStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF9A1120),
          fontWeight: FontWeight.normal,
          fontFamily: 'Sarabun',
        ),
        cancelStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF9A1120),
          fontWeight: FontWeight.normal,
          fontFamily: 'Sarabun',
        ),
      ),
      showTitleActions: true,
      minTime: DateTime(1800, 1, 1),
      maxTime: DateTime(year, month, day), onConfirm: (date) {
    _selectedYear = date.year;
    _selectedMonth = date.month;
    _selectedDay = date.day;
    controller.value = TextEditingValue(
      text: DateFormat("dd-MM-yyyy").format(date),
    );
  },
      currentTime: DateTime(
        _selectedYear,
        _selectedMonth,
        _selectedDay,
      ),
      locale: dt_picker.LocaleType.th);
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
