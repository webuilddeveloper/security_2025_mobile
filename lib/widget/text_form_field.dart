import 'package:flutter/material.dart';

labelTextFormFieldPasswordOldNew(String lable, bool showSubtitle) {
  return new Padding(
    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
    child: new Row(
      children: <Widget>[
        new Flexible(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                lable,
                style: TextStyle(
                  fontSize: 15.000,
                  fontFamily: 'Sarabun',
                  color: Color(0xFFCB0000),
                ),
              ),
              if (showSubtitle)
                Text(
                  '(รหัสผ่านต้องเป็นตัวอักษร a-z, A-Z และ 0-9 ความยาวขั้นต่ำ 6 ตัวอักษร)',
                  style: TextStyle(
                    fontSize: 10.00,
                    fontFamily: 'Sarabun',
                    color: Color(0xFFFF0000),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

textFormFieldPasswordOldNew(
  TextEditingController model,
  String modelMatch,
  String hintText,
  String validator,
  bool enabled,
  bool isPassword,
) {
  return TextFormField(
    obscureText: isPassword,
    style: TextStyle(
      color: enabled ? Color(0xFF000070) : Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Sarabun',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: enabled ? Color(0xFFC5DAFC) : Color(0xFF707070),
      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      hintText: hintText,
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
    validator: (model) {
      if (model!.isEmpty) {
        return 'กรุณากรอก' + validator + '.';
      }
      if (isPassword && model != modelMatch) {
        return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
      }

      if (isPassword) {
        String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,}$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบรหัสผ่านให้ถูกต้อง.';
        }
      }
      return null;
    },
    controller: model,
    enabled: enabled,
  );
}

labelTextFormFieldPassword(String lable) {
  return new Padding(
    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
    child: new Row(
      children: <Widget>[
        new Flexible(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                lable,
                style: TextStyle(
                  fontSize: 15.000,
                  fontFamily: 'Sarabun',
                ),
              ),
              Text(
                '(รหัสผ่านต้องเป็นตัวอักษร a-z, A-Z และ 0-9 ความยาวขั้นต่ำ 6 ตัวอักษร)',
                style: TextStyle(
                  fontSize: 10.00,
                  fontFamily: 'Sarabun',
                  color: Color(0xFFFF0000),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

labelTextFormField(String label) {
  return Padding(
    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 15.000,
        fontFamily: 'Sarabun',
        // color: Color(0xFFCB0000),
      ),
    ),
  );
}

textFormField(
  TextEditingController model,
  String? modelMatch,
  String hintText,
  String validator,
  bool enabled,
  bool isPassword,
  bool isEmail,
) {
  return TextField(
    obscureText: isPassword,
    style: TextStyle(
      color: enabled ? Color(0xFF000070) : Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Sarabun',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: enabled ? Color(0xFFC5DAFC) : Color(0xFF707070),
      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      hintText: hintText,
      // focusedBorder: UnderlineInputBorder(
      //   borderSide: BorderSide(color: Colors.amber, width: 0.5),
      // ),
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
    controller: model,
    enabled: enabled,
  );
}

textFormFieldNoValidator(
  TextEditingController model,
  String hintText,
  bool enabled,
  bool isEmail,
) {
  return TextFormField(
    style: TextStyle(
      color: enabled ? Color(0xFF000070) : Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Sarabun',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: enabled ? Color(0xFFC5DAFC) : Color(0xFF707070),
      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      hintText: hintText,
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
    validator: (model) {
      if (isEmail && model != "") {
        String pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(model!)) {
          return 'กรุณากรอกรูปแบบอีเมลให้ถูกต้อง.';
        }
      }
      return null;
      // return true;
    },
    controller: model,
    enabled: enabled,
  );
}

textFormPhoneField(
  TextEditingController model,
  String hintText,
  String validator,
  bool enabled,
  bool isPhone,
) {
  return TextFormField(
    keyboardType: TextInputType.number,
    style: TextStyle(
      color: enabled ? Color(0xFF000070) : Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Sarabun',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: enabled ? Color(0xFFC5DAFC) : Color(0xFF707070),
      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      hintText: hintText,
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
    validator: (model) {
      if (model!.isEmpty) {
        return 'กรุณากรอก' + validator + '.';
      }
      if (isPhone) {
        String pattern = r'(^(?:[+0]9)?[0-9]{9,10}$)';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบเบอร์ติดต่อให้ถูกต้อง.';
        }
      }
      return null;
    },
    controller: model,
    enabled: enabled,
  );
}

textFormIdCardField(
  TextEditingController model,
  String hintText,
  String validator,
  bool enabled,
) {
  return TextFormField(
    keyboardType: TextInputType.number,
    style: TextStyle(
      color: enabled ? Color(0xFF000070) : Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Sarabun',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: enabled ? Color(0xFFC5DAFC) : Color(0xFF707070),
      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      hintText: hintText,
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
    validator: (model) {
      if (model!.isEmpty) {
        return 'กรุณากรอก' + validator + '.';
      }

      String pattern = r'(^[0-9]\d{12}$)';
      RegExp regex = new RegExp(pattern);

      if (regex.hasMatch(model)) {
        if (model.length != 13) {
          return 'กรุณากรอกรูปแบบเลขบัตรประชาชนให้ถูกต้อง';
        } else {
          var sum = 0.0;
          for (var i = 0; i < 12; i++) {
            sum += double.parse(model[i]) * (13 - i);
          }
          if ((11 - (sum % 11)) % 10 != double.parse(model[12])) {
            return 'กรุณากรอกเลขบัตรประชาชนให้ถูกต้อง';
          } else {
            return null;
          }
        }
      } else {
        return 'กรุณากรอกรูปแบบเลขบัตรประชาชนให้ถูกต้อง';
      }
    },
    controller: model,
    enabled: enabled,
  );
}

textFormFieldEdit(
  TextEditingController model,
  String? modelMatch,
  String hintText,
  String validator,
  bool enabled,
  bool isPassword,
  bool isEmail,
  bool isUser, {
  required Function? onChanged,
}) {
  return TextFormField(
    obscureText: isPassword,
    style: TextStyle(
      color: enabled ? Color(0xFF1B6CA8) : Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      hintText: hintText,
      errorStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 10.0,
      ),
    ),
    validator: (model) {
      if (model!.isEmpty) {
        return 'กรุณากรอก ' + validator + '.';
      }
      // if (isPassword && model != modelMatch && modelMatch != null) {
      //   return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
      // }

      if (isUser) {
        String pattern = r'^[A-Za-z0-9]{4,20}$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบผู้ใช้ให้ถูกต้อง.';
        }
      }

      if (isPassword) {
        String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,}$';
        RegExp regex = new RegExp(pattern);
        // if (!regex.hasMatch(model)) {
        if (model.length < 6) {
          return 'กรุณากรอกรูปแบบรหัสผ่านให้ถูกต้อง.';
        }
      }
      if (isEmail) {
        String pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบอีเมลให้ถูกต้อง.';
        }
      }
      return null;
      // return true;
    },
    controller: model,
    onChanged: (value) => onChanged,
    enabled: enabled,
  );
}

labelTextFormFieldRequired(String labelReequired, String label) {
  return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
      child: Row(
        children: [
          Text(
            labelReequired,
            style: TextStyle(
              fontSize: 15.000,
              fontFamily: 'Kanit',
              color: Color(0xFFFF0000),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 15.000,
              fontFamily: 'Kanit',
            ),
          ),
        ],
      ));
}

textFormPhoneFieldEdit(
  TextEditingController model,
  String hintText,
  String validator,
  bool enabled,
  bool isPhone, {
  Function? onChanged,
}) {
  return TextFormField(
    keyboardType: TextInputType.number,
    style: TextStyle(
      color: enabled ? Color(0xFF1B6CA8) : Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      hintText: hintText,
      errorStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 10.0,
      ),
    ),
    validator: (model) {
      if (model!.isEmpty) {
        return 'กรุณากรอก' + validator + '.';
      }
      if (isPhone) {
        String pattern = r'(^(?:[+0]9)?[0-9]{9,10}$)';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบเบอร์ติดต่อให้ถูกต้อง.';
        }
      }
      return null;
    },
    onChanged: (value) => onChanged,
    controller: model,
    enabled: enabled,
  );
}

textFormLicenseField(
  TextEditingController model,
  String hintText,
  String validator,
  bool enabled,
  bool isPhone, {
  required Function onChanged,
}) {
  return TextFormField(
    keyboardType: TextInputType.number,
    style: TextStyle(
      color: enabled ? Color(0xFF000070) : Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: enabled ? Color(0xFFC5DAFC) : Color(0xFF707070),
      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      errorStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 10.0,
      ),
    ),
    validator: (model) {
      if (model!.isEmpty) {
        return 'กรุณากรอก' + validator + '.';
      }
      if (isPhone) {
        String pattern = r'(^(?:[+0]9)?[0-9]{4,99}$)';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบเลขที่ใบอนุญาตฯ';
        }
      }
      return null;
    },
    controller: model,
    onChanged: (value) => onChanged,
    enabled: enabled,
  );
}

textFormLicenseFieldEdit(
  TextEditingController model,
  String hintText,
  String validator,
  bool enabled,
  bool isPhone, {
  required Function? onChanged,
}) {
  return TextFormField(
    // keyboardType: TextInputType.number,
    style: TextStyle(
      color: enabled ? Color(0xFF1B6CA8) : Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      hintText: hintText,
      errorStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 10.0,
      ),
    ),
    validator: (model) {
      if (model!.isEmpty) {
        return 'กรุณากรอก' + validator + '.';
      }
      if (isPhone) {
        String pattern = r'(^(?:[+0]9)?[0-9]{4,99}$)';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(model)) {
          return 'กรุณากรอกรูปแบบเลขที่ใบอนุญาตฯ';
        }
      }
      return null;
    },
    controller: model,
    onChanged: (value) => onChanged,
    enabled: enabled,
  );
}

textFormFieldIsEmptyEdit(
  TextEditingController model,
  String? modelMatch,
  String hintText,
  String validator,
  bool enabled,
  bool isPassword,
  bool isEmail,
  bool isUser,
  bool isEmpty, {
  required Function? onChanged,
}) {
  return TextFormField(
    obscureText: isPassword,
    style: TextStyle(
      color: enabled ? Color(0xFF1B6CA8) : Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      hintText: hintText,
      errorStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 10.0,
      ),
    ),
    validator: (model) {
      if (isEmpty) {
        return 'กรุณากรอก ' + validator + '.';
      }
      // if (isPassword && model != modelMatch && modelMatch != null) {
      //   return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
      // }

      if (isUser) {
        String pattern = r'^[A-Za-z0-9]{4,20}$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(model!)) {
          return 'กรุณากรอกรูปแบบผู้ใช้ให้ถูกต้อง.';
        }
      }

      if (isPassword) {
        // if (!regex.hasMatch(model)) {
        if (model!.length < 6) {
          return 'กรุณากรอกรูปแบบรหัสผ่านให้ถูกต้อง.';
        }
      }
      if (isEmail) {
        String pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regex = new RegExp(pattern);
        if (!regex.hasMatch(model!)) {
          return 'กรุณากรอกรูปแบบอีเมลให้ถูกต้อง.';
        }
      }
      return null;
      // return true;
    },
    controller: model,
    onChanged: (value) => onChanged,
    enabled: enabled,
  );
}

textFormIdCardFieldEdit(
  TextEditingController model,
  String hintText,
  String validator,
  bool enabled, {
  required Function? onChanged,
}) {
  return TextFormField(
    keyboardType: TextInputType.number,
    style: TextStyle(
      color: enabled ? Color(0xFF1B6CA8) : Color(0xFFFFFFFF),
      fontWeight: FontWeight.normal,
      fontFamily: 'Kanit',
      fontSize: 15.00,
    ),
    decoration: InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      hintText: hintText,
      errorStyle: TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 10.0,
      ),
    ),
    onChanged: (value) => onChanged,
    validator: (model) {
      if (model!.isEmpty) {
        return 'กรุณากรอก' + validator + '.';
      }

      String pattern = r'(^[0-9]\d{12}$)';
      RegExp regex = new RegExp(pattern);

      if (regex.hasMatch(model)) {
        if (model.length != 13) {
          return 'กรุณากรอกรูปแบบเลขบัตรประชาชนให้ถูกต้อง';
        } else {
          var sum = 0.0;
          for (var i = 0; i < 12; i++) {
            sum += double.parse(model[i]) * (13 - i);
          }
          if ((11 - (sum % 11)) % 10 != double.parse(model[12])) {
            return 'กรุณากรอกเลขบัตรประชาชนให้ถูกต้อง';
          } else {
            return null;
          }
        }
      } else {
        return 'กรุณากรอกรูปแบบเลขบัตรประชาชนให้ถูกต้อง';
      }
    },
    controller: model,
    enabled: enabled,
  );
}

dropdownSelect(
  String? selectedItem,
  Function(String?)? onChanged,
  String hintText,
  bool enabled,
  List<Map<String, String>> items,
) {
  return DropdownButtonFormField<String>(
    decoration: InputDecoration(
      filled: true,
      fillColor: enabled ? Color(0xFFC5DAFC) : Color(0xFF707070),
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
    ),
    value: selectedItem,
    onChanged: enabled
        ? (String? newValue) {
            // เรียกใช้ setState ภายในฟังก์ชัน onChanged
            onChanged?.call(newValue);
          }
        : null,
    items: items.map((Map<String, String> item) {
      return DropdownMenuItem<String>(
        value: item['id'],
        child: Text(item['name']!),
      );
    }).toList(),
  );
}
