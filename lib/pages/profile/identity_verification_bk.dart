import 'dart:convert';
import 'package:security_2025_mobile_v3/widget/date_picker.dart';
import 'package:security_2025_mobile_v3/widget/textbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:security_2025_mobile_v3/pages/blank_page/dialog_fail.dart';
import 'package:security_2025_mobile_v3/pages/profile/policy_identity_verification.dart';
import 'package:security_2025_mobile_v3/pages/profile/user_information.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:security_2025_mobile_v3/widget/text_form_field.dart';

class IdentityVerificationPage extends StatefulWidget {
  @override
  _IdentityVerificationPageState createState() =>
      _IdentityVerificationPageState();
}

class _IdentityVerificationPageState extends State<IdentityVerificationPage> {
  final storage = new FlutterSecureStorage();

  late String _imageUrl;
  late String _code;
  late String _username;

  final _formKey = GlobalKey<FormState>();
  final _formOrganizationKey = GlobalKey<FormState>();

  List<dynamic> _itemSex = [
    {'title': 'ชาย', 'code': 'ชาย'},
    {'title': 'หญิง', 'code': 'หญิง'},
    {'title': 'ไม่ระบุเพศ', 'code': 'ไม่ระบุเพศ'}
  ];
  late String _selectedSex;

  List<dynamic> _itemProvince = [];
  late String _selectedProvince;

  List<dynamic> _itemDistrict = [];
  late String _selectedDistrict;

  List<dynamic> _itemSubDistrict = [];
  late String _selectedSubDistrict;

  List<dynamic> _itemPostalCode = [];
  late String _selectedPostalCode;

  List<dynamic> _itemOrganizationLv0 = [];

  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();
  final txtPrefixName = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtPhone = TextEditingController();
  final txtUsername = TextEditingController();
  final txtIdCard = TextEditingController();
  final txtLineID = TextEditingController();
  final txtOfficerCode = TextEditingController();
  final txtAddress = TextEditingController();
  final txtMoo = TextEditingController();
  final txtSoi = TextEditingController();
  final txtRoad = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TextEditingController txtDate = TextEditingController();

  late Future<dynamic> _futureProfile;

  late XFile _image;

  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;

  bool openOrganization = false;
  List<dynamic> _itemLv0 = [];
  late String _selectedLv0;
  late String _selectedTitleLv0;
  List<dynamic> _itemLv1 = [];
  late String _selectedLv1;
  late String _selectedTitleLv1;
  List<dynamic> _itemLv2 = [];
  late String _selectedLv2;
  late String _selectedTitleLv2;
  List<dynamic> _itemLv3 = [];
  late String _selectedLv3;
  late String _selectedTitleLv3;
  List<dynamic> _itemLv4 = [];
  late String _selectedLv4;
  late String _selectedTitleLv4;
  List<dynamic> _itemLv5 = [];
  late String _selectedLv5;
  late String _selectedTitleLv5;
  int totalLv = 0;

  List<dynamic> dataCountUnit = [];

  List<dynamic> dataPolicy = [];

  @override
  void initState() {
    _read();
    // getUser();
    // getOrganizationLv0();

    var now = new DateTime.now();
    setState(() {
      year = now.year;
      month = now.month;
      day = now.day;
      _selectedYear = now.year;
      _selectedMonth = now.month;
      _selectedDay = now.day;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, goBack, title: 'ยืนยันตัวตน', rightButton: null),
      backgroundColor: Color(0xFFFFFFFF),
      body: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          Container(
            color: Colors.white,
            child: FutureBuilder<dynamic>(
              future: _futureProfile,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  _bindingData(snapshot.data);
                  return _buildForm();
                } else if (snapshot.hasError)
                  return Center(
                    child: Container(
                      color: Colors.white,
                      child: dialogFail(context),
                    ),
                  );
                else
                  return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  _read() async {
    print('-----read()-----');
    //read profile
    var profileCode = await storage.read(key: 'profileCode3');
    if (profileCode != '' && profileCode != null)
      setState(() {
        _futureProfile = postDio('${registerApi}read', {'code': profileCode});
      });

    final result = await postObjectData("route/province/read", {});
    if (result['status'] == 'S') {
      setState(() {
        _itemProvince = result['objectData'];
      });
    }

    getProvince();
  }

  Future<Null> _bindingData(model) async {
    if (model[0]['birthDay'] != '') {
      if (isValidDate(model[0]['birthDay'])) {
        var date = model[0]['birthDay'];
        var year = date.substring(0, 4);
        var month = date.substring(4, 6);
        var day = date.substring(6, 8);
        DateTime todayDate = DateTime.parse(year + '-' + month + '-' + day);
        setState(() {
          _selectedYear = todayDate.year;
          _selectedMonth = todayDate.month;
          _selectedDay = todayDate.day;
          txtDate.text = DateFormat("dd-MM-yyyy").format(todayDate);
        });
      }
    }

    setState(() {
      _imageUrl = model[0]['imageUrl'];
      txtFirstName.text = model[0]['firstName'];
      txtLastName.text = model[0]['lastName'];
      txtEmail.text = model[0]['email'] ?? '';
      txtPhone.text = model[0]['phone'] ?? '';
      // _selectedPrefixName = result['objectData'][0]['prefixName'];
      _code = model[0]['code'] ?? '';
      txtPhone.text = model[0]['phone'] ?? '';
      txtUsername.text = model[0]['username'] ?? '';
      txtIdCard.text = model[0]['idcard'] ?? '';
      txtLineID.text = model[0]['lineID'] ?? '';
      txtOfficerCode.text = model[0]['officerCode'] ?? '';
      txtAddress.text = model[0]['address'] ?? '';
      txtMoo.text = model[0]['moo'] ?? '';
      txtSoi.text = model[0]['soi'] ?? '';
      txtRoad.text = model[0]['road'] ?? '';
      txtPrefixName.text = model[0]['prefixName'] ?? '';

      _selectedProvince = model[0]['provinceCode'] ?? '';
      _selectedDistrict = model[0]['amphoeCode'] ?? '';
      _selectedSubDistrict = model[0]['tambonCode'] ?? '';
      _selectedPostalCode = model[0]['postnoCode'] ?? '';
      _selectedSex = model[0]['sex'] ?? '';
    });

    // if (_selectedProvince != '') {
    //   getProvince();
    //   getDistrict();
    //   getSubDistrict();
    //   // setState(() {
    //   //   futureModel =
    //   getPostalCode();
    //   // });
    // } else {
    //   // setState(() {
    //   //   futureModel =
    //   getProvince();
    //   // });
    // }
  }

  _buildForm() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        children: [
          _buildOrganizationShowListPanel(),
          if (!openOrganization) _buildOrganizationAddPanel(),
          if (openOrganization) _buildOrganizationAddListPanel(),
          textbox(controller: txtUsername, title: 'Username', enabled: false),
          textbox(controller: txtPrefixName, title: '* คำนำหน้า'),
          textbox(controller: txtFirstName, title: '* ชื่อ'),
          textbox(controller: txtLastName, title: '* นามสกุล'),
        ],
      ),
    );
  }

  //not use change use _buildForm
  _buildContentCard() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5.0),
            ),

            _buildOrganizationShowListPanel(),

            if (!openOrganization) _buildOrganizationAddPanel(),
            if (openOrganization) _buildOrganizationAddListPanel(),

            SizedBox(height: 5.0),
            Text(
              'ข้อมูลผู้ใช้งาน',
              style: TextStyle(
                fontSize: 18.00,
                fontFamily: 'Sarabun',
                fontWeight: FontWeight.w500,
                // color: Color(0xFFBC0611),
              ),
            ),
            SizedBox(height: 15.0),
            // labelTextFormField('* ชื่อผู้ใช้งาน'),
            textFormField(
              txtUsername,
              null,
              'ชื่อผู้ใช้งาน',
              'ชื่อผู้ใช้งาน',
              false,
              false,
              false,
            ),
            SizedBox(height: 15.0),
            Text(
              'ข้อมูลส่วนตัว',
              style: TextStyle(
                fontSize: 18.00,
                fontFamily: 'Sarabun',
                fontWeight: FontWeight.w500,
                // color: Color(0xFFBC0611),
              ),
            ),
            labelTextFormField('* คำนำหน้า'),
            textFormField(
              txtPrefixName,
              null,
              'คำนำหน้า',
              'คำนำหน้า',
              true,
              false,
              false,
            ),
            // new Container(
            //   width: 5000.0,
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 5,
            //     vertical: 0,
            //   ),
            //   decoration: BoxDecoration(
            //     color: Color(0xFFC5DAFC),
            //     borderRadius: BorderRadius.circular(
            //       10,
            //     ),
            //   ),
            //   // child: DropdownButtonHideUnderline(
            //   child: DropdownButtonFormField(
            //     decoration: InputDecoration(
            //       errorStyle: TextStyle(
            //         fontWeight: FontWeight.normal,
            //         fontFamily: 'Sarabun',
            //         fontSize: 10.0,
            //       ),
            //       enabledBorder: UnderlineInputBorder(
            //         borderSide: BorderSide(
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //     validator: (value) =>
            //         value == '' || value == null ? 'กรุณาเลือกคำนำหน้า' : null,
            //     hint: Text(
            //       'กรุณาเลือกคำนำหน้า',
            //       style: TextStyle(
            //         fontSize: 15.00,
            //         fontFamily: 'Sarabun',
            //       ),
            //     ),
            //     value: _selectedPrefixName != '' ? _selectedPrefixName : '',

            //     onChanged: (newValue) {
            //       setState(() {
            //         _selectedPrefixName = newValue;
            //       });
            //     },
            //     items: _itemPrefixName.map((prefixName) {
            //       return DropdownMenuItem(
            //         child: new Text(
            //           prefixName,
            //           style: TextStyle(
            //             fontSize: 15.00,
            //             fontFamily: 'Sarabun',
            //             color: Color(
            //               0xFF000070,
            //             ),
            //           ),
            //         ),
            //         value: prefixName,
            //       );
            //     }).toList(),
            //   ),
            //   // ),
            // ),
            labelTextFormField('* ชื่อ'),
            textFormField(
              txtFirstName,
              null,
              'ชื่อ',
              'ชื่อ',
              true,
              false,
              false,
            ),
            labelTextFormField('* นามสกุล'),
            textFormField(
              txtLastName,
              null,
              'นามสกุล',
              'นามสกุล',
              true,
              false,
              false,
            ),
            datePicker(
                controller: txtDate,
                title: '* วันเดือนปีเกิด',
                context: context),
            labelTextFormField('* รหัสประจำตัวประชาชน'),
            textFormIdCardField(
              txtIdCard,
              'รหัสประจำตัวประชาชน',
              'รหัสประจำตัวประชาชน',
              true,
            ),
            labelTextFormField('* อีเมล์'),
            textFormFieldNoValidator(
              txtEmail,
              'อีเมล์',
              false,
              false,
            ),
            // labelTextFormField('Line ID'),
            // textFormFieldNoValidator(
            //   txtLineID,
            //   'Line ID',
            //   true,
            //   false,
            // ),
            labelTextFormField('* รหัสสมาชิก'),
            textFormField(
              txtOfficerCode,
              null,
              'รหัสสมาชิก',
              'รหัสสมาชิก',
              true,
              false,
              false,
            ),
            labelTextFormField('* เบอร์โทรศัพท์ (10 หลัก)'),
            textFormPhoneField(
              txtPhone,
              'เบอร์โทรศัพท์ (10 หลัก)',
              'เบอร์โทรศัพท์ (10 หลัก)',
              true,
              false,
            ),
            labelTextFormField('* เพศ'),

            new Container(
              width: 5000.0,
              padding: EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 0,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFC5DAFC),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: _selectedSex != ''
                  ? DropdownButtonFormField(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Sarabun',
                          fontSize: 10.0,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      validator: (value) =>
                          value == '' || value == null ? 'กรุณาเลือกเพศ' : null,
                      hint: Text(
                        'เพศ',
                        style: TextStyle(
                          fontSize: 15.00,
                          fontFamily: 'Sarabun',
                        ),
                      ),
                      value: _selectedSex,
                      onChanged: (newValue) {
                        // setState(() {
                        //   _selectedSex = newValue;
                        // });
                      },
                      items: _itemSex.map((item) {
                        return DropdownMenuItem(
                          child: new Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Sarabun',
                              color: Color(
                                0xFF000070,
                              ),
                            ),
                          ),
                          value: item['code'],
                        );
                      }).toList(),
                    )
                  : DropdownButtonFormField(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Sarabun',
                          fontSize: 10.0,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      validator: (value) =>
                          value == '' || value == null ? 'กรุณาเลือกเพศ' : null,
                      hint: Text(
                        'เพศ',
                        style: TextStyle(
                          fontSize: 15.00,
                          fontFamily: 'Sarabun',
                        ),
                      ),
                      // value: _selectedSex,
                      onChanged: (newValue) {
                        // setState(() {
                        //   _selectedSex = newValue;
                        // });
                      },
                      items: _itemSex.map((item) {
                        return DropdownMenuItem(
                          child: new Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Sarabun',
                              color: Color(
                                0xFF000070,
                              ),
                            ),
                          ),
                          value: item['code'],
                        );
                      }).toList(),
                    ),
            ),
            labelTextFormField('ที่อยู่ปัจจุบัน'),
            textFormFieldNoValidator(
              txtAddress,
              'ที่อยู่ปัจจุบัน',
              true,
              false,
            ),
            labelTextFormField('หมู่ที่'),
            textFormFieldNoValidator(
              txtMoo,
              'หมู่ที่',
              true,
              false,
            ),
            labelTextFormField('ซอย'),
            textFormFieldNoValidator(
              txtSoi,
              'ซอย',
              true,
              false,
            ),
            labelTextFormField('ถนน'),
            textFormFieldNoValidator(
              txtRoad,
              'ถนน',
              true,
              false,
            ),
            labelTextFormField('* จังหวัด'),
            new Container(
              width: 5000.0,
              padding: EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 0,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFC5DAFC),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: (_selectedProvince != '')
                  ? DropdownButtonFormField(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Sarabun',
                          fontSize: 10.0,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      validator: (value) => value == '' || value == null
                          ? 'กรุณาเลือกจังหวัด'
                          : null,
                      hint: Text(
                        'จังหวัด',
                        style: TextStyle(
                          fontSize: 15.00,
                          fontFamily: 'Sarabun',
                        ),
                      ),
                      value: _selectedProvince,
                      onChanged: (newValue) {
                        // setState(() {
                        //   _selectedDistrict = "";
                        //   _itemDistrict = [];
                        //   _selectedSubDistrict = "";
                        //   _itemSubDistrict = [];
                        //   _selectedPostalCode = "";
                        //   _itemPostalCode = [];
                        //   _selectedProvince = newValue;
                        // });
                        getDistrict();
                      },
                      items: _itemProvince.map((item) {
                        return DropdownMenuItem(
                          child: new Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Sarabun',
                              color: Color(
                                0xFF000070,
                              ),
                            ),
                          ),
                          value: item['code'],
                        );
                      }).toList(),
                    )
                  : DropdownButtonFormField(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Sarabun',
                          fontSize: 10.0,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      validator: (value) => value == '' || value == null
                          ? 'กรุณาเลือกจังหวัด'
                          : null,
                      hint: Text(
                        'จังหวัด',
                        style: TextStyle(
                          fontSize: 15.00,
                          fontFamily: 'Sarabun',
                        ),
                      ),
                      onChanged: (newValue) {
                        // setState(() {
                        //   _selectedDistrict = "";
                        //   _itemDistrict = [];
                        //   _selectedSubDistrict = "";
                        //   _itemSubDistrict = [];
                        //   _selectedPostalCode = "";
                        //   _itemPostalCode = [];
                        //   _selectedProvince = newValue;
                        // });
                        getDistrict();
                      },
                      items: _itemProvince.map((item) {
                        return DropdownMenuItem(
                          child: new Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Sarabun',
                              color: Color(
                                0xFF000070,
                              ),
                            ),
                          ),
                          value: item['code'],
                        );
                      }).toList(),
                    ),
            ),
            labelTextFormField('* อำเภอ'),
            new Container(
              width: 5000.0,
              padding: EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 0,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFC5DAFC),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: (_selectedDistrict != '')
                  ? DropdownButtonFormField(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Sarabun',
                          fontSize: 10.0,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      validator: (value) => value == '' || value == null
                          ? 'กรุณาเลือกอำเภอ'
                          : null,
                      hint: Text(
                        'อำเภอ',
                        style: TextStyle(
                          fontSize: 15.00,
                          fontFamily: 'Sarabun',
                        ),
                      ),
                      value: _selectedDistrict,
                      onChanged: (newValue) {
                        // setState(() {
                        //   _selectedSubDistrict = "";
                        //   _itemSubDistrict = [];
                        //   _selectedPostalCode = "";
                        //   _itemPostalCode = [];
                        //   _selectedDistrict = newValue;
                        //   getSubDistrict();
                        // });
                      },
                      items: _itemDistrict.map((item) {
                        return DropdownMenuItem(
                          child: new Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Sarabun',
                              color: Color(
                                0xFF000070,
                              ),
                            ),
                          ),
                          value: item['code'],
                        );
                      }).toList(),
                    )
                  : DropdownButtonFormField(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Sarabun',
                          fontSize: 10.0,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      validator: (value) => value == '' || value == null
                          ? 'กรุณาเลือกอำเภอ'
                          : null,
                      hint: Text(
                        'อำเภอ',
                        style: TextStyle(
                          fontSize: 15.00,
                          fontFamily: 'Sarabun',
                        ),
                      ),
                      onChanged: (newValue) {
                        // setState(() {
                        //   _selectedSubDistrict = "";
                        //   _itemSubDistrict = [];
                        //   _selectedPostalCode = "";
                        //   _itemPostalCode = [];
                        //   _selectedDistrict = newValue;
                        //   getSubDistrict();
                        // });
                      },
                      items: _itemDistrict.map((item) {
                        return DropdownMenuItem(
                          child: new Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Sarabun',
                              color: Color(
                                0xFF000070,
                              ),
                            ),
                          ),
                          value: item['code'],
                        );
                      }).toList(),
                    ),
            ),
            labelTextFormField('* ตำบล'),
            new Container(
              width: 5000.0,
              padding: EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 0,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFC5DAFC),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: (_selectedSubDistrict != '')
                  ? DropdownButtonFormField(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Sarabun',
                          fontSize: 10.0,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      validator: (value) => value == '' || value == null
                          ? 'กรุณาเลือกตำบล'
                          : null,
                      hint: Text(
                        'ตำบล',
                        style: TextStyle(
                          fontSize: 15.00,
                          fontFamily: 'Sarabun',
                        ),
                      ),
                      value: _selectedSubDistrict,
                      onChanged: (newValue) {
                        // setState(() {
                        //   _selectedPostalCode = "";
                        //   _itemPostalCode = [];
                        //   _selectedSubDistrict = newValue;
                        //   getPostalCode();
                        // });
                      },
                      items: _itemSubDistrict.map((item) {
                        return DropdownMenuItem(
                          child: new Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Sarabun',
                              color: Color(
                                0xFF000070,
                              ),
                            ),
                          ),
                          value: item['code'],
                        );
                      }).toList(),
                    )
                  : DropdownButtonFormField(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Sarabun',
                          fontSize: 10.0,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      validator: (value) => value == '' || value == null
                          ? 'กรุณาเลือกตำบล'
                          : null,
                      hint: Text(
                        'ตำบล',
                        style: TextStyle(
                          fontSize: 15.00,
                          fontFamily: 'Sarabun',
                        ),
                      ),
                      onChanged: (newValue) {
                        // setState(() {
                        //   _selectedPostalCode = "";
                        //   _itemPostalCode = [];
                        //   _selectedSubDistrict = newValue;
                        //   getPostalCode();
                        // });
                      },
                      items: _itemSubDistrict.map((item) {
                        return DropdownMenuItem(
                          child: new Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Sarabun',
                              color: Color(
                                0xFF000070,
                              ),
                            ),
                          ),
                          value: item['code'],
                        );
                      }).toList(),
                    ),
            ),
            labelTextFormField('* รหัสไปรษณีย์'),
            new Container(
              width: 5000.0,
              padding: EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 0,
              ),
              decoration: BoxDecoration(
                color: Color(0xFFC5DAFC),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: (_selectedPostalCode != '')
                  ? DropdownButtonFormField(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Sarabun',
                          fontSize: 10.0,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      validator: (value) => value == '' || value == null
                          ? 'กรุณาเลือกรหัสไปรษณีย์'
                          : null,
                      hint: Text(
                        'รหัสไปรษณีย์',
                        style: TextStyle(
                          fontSize: 15.00,
                          fontFamily: 'Sarabun',
                        ),
                      ),
                      value: _selectedPostalCode,
                      onChanged: (newValue) {
                        // setState(() {
                        //   _selectedPostalCode = newValue;
                        // });
                      },
                      items: _itemPostalCode.map((item) {
                        return DropdownMenuItem(
                          child: new Text(
                            item['postCode'],
                            style: TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Sarabun',
                              color: Color(
                                0xFF000070,
                              ),
                            ),
                          ),
                          value: item['code'],
                        );
                      }).toList(),
                    )
                  : DropdownButtonFormField(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Sarabun',
                          fontSize: 10.0,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      validator: (value) => value == '' || value == null
                          ? 'กรุณาเลือกรหัสไปรษณีย์'
                          : null,
                      hint: Text(
                        'รหัสไปรษณีย์',
                        style: TextStyle(
                          fontSize: 15.00,
                          fontFamily: 'Sarabun',
                        ),
                      ),
                      onChanged: (newValue) {
                        // setState(() {
                        //   _selectedPostalCode = newValue;
                        // });
                      },
                      items: _itemPostalCode.map((item) {
                        return DropdownMenuItem(
                          child: new Text(
                            item['postCode'],
                            style: TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Sarabun',
                              color: Color(
                                0xFF000070,
                              ),
                            ),
                          ),
                          value: item['code'],
                        );
                      }).toList(),
                    ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.7,
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color(0xFFFF7514),
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    height: 40,
                    onPressed: () {
                      final form = _formKey.currentState;
                      if (form!.validate()) {
                        form.save();
                        submitUpdateUser();
                      }
                    },
                    child: new Text(
                      'บันทึกข้อมูล',
                      style: new TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Sarabun',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildOrganizationShowListPanel() {
    return Column(
      children: [
        for (var i = 0; i < dataCountUnit.length; i++)
          Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dataCountUnit[i]['titleLv0'].toString(),
                        style: TextStyle(
                          fontSize: 13.00,
                          fontFamily: 'Sarabun',
                          color: Color(
                            0xFF000070,
                          ),
                        ),
                        maxLines: 2,
                      ),
                      Text(
                        dataCountUnit[i]['titleLv1'].toString(),
                        style: TextStyle(
                          fontSize: 13.00,
                          fontFamily: 'Sarabun',
                          color: Color(
                            0xFF000070,
                          ),
                        ),
                        maxLines: 2,
                      ),
                      dataCountUnit[i]['titleLv2'] != '' &&
                              dataCountUnit[i]['titleLv2'] != null
                          ? Text(
                              dataCountUnit[i]['titleLv2'].toString(),
                              style: TextStyle(
                                fontSize: 13.00,
                                fontFamily: 'Sarabun',
                                color: Color(
                                  0xFF000070,
                                ),
                              ),
                              maxLines: 2,
                            )
                          : Container(),
                      dataCountUnit[i]['titleLv3'] != '' &&
                              dataCountUnit[i]['titleLv3'] != null
                          ? Text(
                              dataCountUnit[i]['titleLv3'].toString(),
                              style: TextStyle(
                                fontSize: 13.00,
                                fontFamily: 'Sarabun',
                                color: Color(
                                  0xFF000070,
                                ),
                              ),
                              maxLines: 2,
                            )
                          : Container(),
                      dataCountUnit[i]['titleLv4'] != '' &&
                              dataCountUnit[i]['titleLv4'] != null
                          ? Text(
                              dataCountUnit[i]['titleLv4'].toString(),
                              style: TextStyle(
                                fontSize: 13.00,
                                fontFamily: 'Sarabun',
                                color: Color(
                                  0xFF000070,
                                ),
                              ),
                              maxLines: 2,
                            )
                          : Container(),
                      dataCountUnit[i]['titleLv5'] != '' &&
                              dataCountUnit[i]['titleLv5'] != null
                          ? Text(
                              dataCountUnit[i]['titleLv5'].toString(),
                              style: TextStyle(
                                fontSize: 13.00,
                                fontFamily: 'Sarabun',
                                color: Color(
                                  0xFF000070,
                                ),
                              ),
                              maxLines: 2,
                            )
                          : Container(),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: TextButton(
                    onPressed: () => {
                      setState(() {
                        dataCountUnit.removeAt(i);
                      })
                    },
                    child: Column(
                      children: [
                        Icon(Icons.close),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(
                    0xFF000070,
                  ),
                  spreadRadius: 1,
                ),
              ],
              // border: Border.all(color: Colors.white.withAlpha(50)),
            ),
          ),
      ],
    );
  }

  _buildOrganizationAddPanel() {
    return TextButton(
      onPressed: () => {
        setState(() {
          openOrganization = !openOrganization;
        })
      },
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Icon(Icons.add),
              Text(
                '* เพิ่มหน่วยงาน',
                style: TextStyle(
                  fontSize: 15.00,
                  fontFamily: 'Sarabun',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFBC0611),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(0.0),
            child: Text(
              '(เพิ่มหน่วยงานอย่างน้อย 1 หน่วยงานในการยืนยันตัวตน)',
              style: TextStyle(
                fontSize: 11.00,
                fontFamily: 'Sarabun',
                fontWeight: FontWeight.w500,
                color: Color(0xFFBC0611),
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  _buildOrganizationAddListPanel() {
    return Container(
      child: Form(
        key: _formOrganizationKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: [
              new Container(
                width: 5000.0,
                padding: EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 0,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFC5DAFC),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: (_selectedLv0 != '')
                    ? DropdownButtonFormField(
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Sarabun',
                            fontSize: 10.0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        validator: (value) =>
                            value == '' || value == null ? 'โปรดระบุ' : null,
                        hint: Text(
                          'โปรดระบุ',
                          style: TextStyle(
                            fontSize: 15.00,
                            fontFamily: 'Sarabun',
                          ),
                        ),
                        value: _selectedLv0,
                        onChanged: (newValue) {
                          // print('-----$newValue-----');

                          var index = _itemLv0.indexWhere(
                            (item) => item['code'] == newValue,
                          );

                          // print(
                          //     '-----${_itemLv0[index]['title'].toString()}-----');
                          // print(
                          //     '-----${_itemLv0[index]['totalLv'].toString()}-----');

                          setState(() {
                            _selectedLv1 = "";
                            _itemLv1 = [];
                            _selectedLv2 = "";
                            _itemLv2 = [];
                            _selectedLv3 = "";
                            _itemLv3 = [];
                            _selectedLv4 = "";
                            _itemLv4 = [];
                            _selectedLv5 = "";
                            _itemLv5 = [];
                            _selectedLv0 = newValue as String;
                            _selectedTitleLv0 = _itemLv0[index]['title'];
                            totalLv = _itemLv0[index]['totalLv'];
                          });
                          getOrganizationLv1();
                        },
                        items: _itemLv0.map((item) {
                          return DropdownMenuItem(
                            child: new Text(
                              item['title'],
                              style: TextStyle(
                                fontSize: 15.00,
                                fontFamily: 'Sarabun',
                                color: Color(
                                  0xFF000070,
                                ),
                              ),
                            ),
                            value: item['code'],
                          );
                        }).toList(),
                      )
                    : DropdownButtonFormField(
                        decoration: InputDecoration(
                          errorStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Sarabun',
                            fontSize: 10.0,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        validator: (value) =>
                            value == '' || value == null ? 'โปรดระบุ' : null,
                        hint: Text(
                          'โปรดระบุ',
                          style: TextStyle(
                            fontSize: 15.00,
                            fontFamily: 'Sarabun',
                          ),
                        ),
                        onChanged: (newValue) {
                          var checkValue = _itemLv0.indexWhere(
                            (item) => item['code'] == newValue,
                          );

                          setState(() {
                            _selectedLv1 = "";
                            _itemLv1 = [];
                            _selectedLv2 = "";
                            _itemLv2 = [];
                            _selectedLv3 = "";
                            _itemLv3 = [];
                            _selectedLv4 = "";
                            _itemLv4 = [];
                            _selectedLv5 = "";
                            _itemLv5 = [];
                            _selectedLv0 = newValue as String;
                            _selectedTitleLv0 = _itemLv0[checkValue]['title'];
                            totalLv = _itemLv0[checkValue]['totalLv'];
                          });
                          getOrganizationLv1();
                        },
                        items: _itemLv0.map((item) {
                          return DropdownMenuItem(
                            child: new Text(
                              item['title'],
                              style: TextStyle(
                                fontSize: 15.00,
                                fontFamily: 'Sarabun',
                                color: Color(
                                  0xFF000070,
                                ),
                              ),
                            ),
                            value: item['code'],
                          );
                        }).toList(),
                      ),
              ),
              if (totalLv >= 1)
                SizedBox(
                  height: 5.0,
                ),
              if (totalLv >= 1)
                new Container(
                  width: 5000.0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 0,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFC5DAFC),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: (_selectedLv1 != '')
                      ? DropdownButtonFormField(
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Sarabun',
                              fontSize: 10.0,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          validator: (value) =>
                              value == '' || value == null ? 'โปรดระบุ' : null,
                          hint: Text(
                            'โปรดระบุ',
                            style: TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                          value: _selectedLv1,
                          onChanged: (newValue) {
                            var checkValue = _itemLv1.indexWhere(
                              (item) => item['code'] == newValue,
                            );

                            setState(() {
                              _selectedLv2 = "";
                              _itemLv2 = [];
                              _selectedLv3 = "";
                              _itemLv3 = [];
                              _selectedLv4 = "";
                              _itemLv4 = [];
                              _selectedLv5 = "";
                              _itemLv5 = [];
                              _selectedLv1 = newValue as String;
                              _selectedTitleLv1 = _itemLv1[checkValue]['title'];
                            });

                            getOrganizationLv2();
                          },
                          items: _itemLv1.map((item) {
                            return DropdownMenuItem(
                              child: new Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 15.00,
                                  fontFamily: 'Sarabun',
                                  color: Color(
                                    0xFF000070,
                                  ),
                                ),
                              ),
                              value: item['code'],
                            );
                          }).toList(),
                        )
                      : DropdownButtonFormField(
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Sarabun',
                              fontSize: 10.0,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          validator: (value) =>
                              value == '' || value == null ? 'โปรดระบุ' : null,
                          hint: Text(
                            'โปรดระบุ',
                            style: TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                          onChanged: (newValue) {
                            var checkValue = _itemLv1.indexWhere(
                              (item) => item['code'] == newValue,
                            );

                            setState(() {
                              _selectedLv2 = "";
                              _itemLv2 = [];
                              _selectedLv3 = "";
                              _itemLv3 = [];
                              _selectedLv4 = "";
                              _itemLv4 = [];
                              _selectedLv5 = "";
                              _itemLv5 = [];
                              _selectedLv1 = newValue as String;
                              _selectedTitleLv1 = _itemLv1[checkValue]['title'];
                            });

                            getOrganizationLv2();
                          },
                          items: _itemLv1.map((item) {
                            return DropdownMenuItem(
                              child: new Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 15.00,
                                  fontFamily: 'Sarabun',
                                  color: Color(
                                    0xFF000070,
                                  ),
                                ),
                              ),
                              value: item['code'],
                            );
                          }).toList(),
                        ),
                ),
              if (totalLv >= 2)
                SizedBox(
                  height: 5.0,
                ),
              if (totalLv >= 2)
                new Container(
                  width: 5000.0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 0,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFC5DAFC),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: (_selectedLv2 != '')
                      ? DropdownButtonFormField(
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Sarabun',
                              fontSize: 10.0,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          validator: (value) =>
                              value == '' || value == null ? 'โปรดระบุ' : null,
                          hint: Text(
                            'โปรดระบุ',
                            style: TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                          value: _selectedLv2,
                          onChanged: (newValue) {
                            var checkValue = _itemLv2.indexWhere(
                              (item) => item['code'] == newValue,
                            );

                            setState(() {
                              _selectedLv3 = "";
                              _itemLv3 = [];
                              _selectedLv4 = "";
                              _itemLv4 = [];
                              _selectedLv5 = "";
                              _itemLv5 = [];
                              _selectedLv2 = newValue as String;
                              _selectedTitleLv2 = _itemLv2[checkValue]['title'];
                            });

                            getOrganizationLv3();
                          },
                          items: _itemLv2.map((item) {
                            return DropdownMenuItem(
                              child: new Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 15.00,
                                  fontFamily: 'Sarabun',
                                  color: Color(
                                    0xFF000070,
                                  ),
                                ),
                              ),
                              value: item['code'],
                            );
                          }).toList(),
                        )
                      : DropdownButtonFormField(
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Sarabun',
                              fontSize: 10.0,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          validator: (value) =>
                              value == '' || value == null ? 'โปรดระบุ' : null,
                          hint: Text(
                            'โปรดระบุ',
                            style: TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                          onChanged: (newValue) {
                            var checkValue = _itemLv2.indexWhere(
                              (item) => item['code'] == newValue,
                            );

                            setState(() {
                              _selectedLv3 = "";
                              _itemLv3 = [];
                              _selectedLv4 = "";
                              _itemLv4 = [];
                              _selectedLv5 = "";
                              _itemLv5 = [];
                              _selectedLv2 = newValue as String;
                              _selectedTitleLv2 = _itemLv2[checkValue]['title'];
                            });

                            getOrganizationLv3();
                          },
                          items: _itemLv2.map((item) {
                            return DropdownMenuItem(
                              child: new Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 15.00,
                                  fontFamily: 'Sarabun',
                                  color: Color(
                                    0xFF000070,
                                  ),
                                ),
                              ),
                              value: item['code'],
                            );
                          }).toList(),
                        ),
                ),
              if (totalLv >= 3)
                SizedBox(
                  height: 5.0,
                ),
              if (totalLv >= 3)
                new Container(
                  width: 5000.0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 0,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFC5DAFC),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: (_selectedLv3 != '')
                      ? DropdownButtonFormField(
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Sarabun',
                              fontSize: 10.0,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          validator: (value) =>
                              value == '' || value == null ? 'โปรดระบุ' : null,
                          hint: Text(
                            'โปรดระบุ',
                            style: TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                          value: _selectedLv3,
                          onChanged: (newValue) {
                            var checkValue = _itemLv3.indexWhere(
                              (item) => item['code'] == newValue,
                            );

                            setState(() {
                              _selectedLv4 = "";
                              _itemLv4 = [];
                              _selectedLv5 = "";
                              _itemLv5 = [];
                              _selectedLv3 = newValue as String;
                              _selectedTitleLv3 = _itemLv3[checkValue]['title'];
                            });

                            getOrganizationLv4();
                          },
                          items: _itemLv3.map((item) {
                            return DropdownMenuItem(
                              child: new Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 15.00,
                                  fontFamily: 'Sarabun',
                                  color: Color(
                                    0xFF000070,
                                  ),
                                ),
                              ),
                              value: item['code'],
                            );
                          }).toList(),
                        )
                      : DropdownButtonFormField(
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Sarabun',
                              fontSize: 10.0,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          validator: (value) =>
                              value == '' || value == null ? 'โปรดระบุ' : null,
                          hint: Text(
                            'โปรดระบุ',
                            style: TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                          onChanged: (newValue) {
                            var checkValue = _itemLv3.indexWhere(
                              (item) => item['code'] == newValue,
                            );

                            setState(() {
                              _selectedLv4 = "";
                              _itemLv4 = [];
                              _selectedLv5 = "";
                              _itemLv5 = [];
                              _selectedLv3 = newValue as String;
                              _selectedTitleLv3 = _itemLv3[checkValue]['title'];
                            });

                            getOrganizationLv4();
                          },
                          items: _itemLv3.map((item) {
                            return DropdownMenuItem(
                              child: new Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 15.00,
                                  fontFamily: 'Sarabun',
                                  color: Color(
                                    0xFF000070,
                                  ),
                                ),
                              ),
                              value: item['code'],
                            );
                          }).toList(),
                        ),
                ),
              if (totalLv >= 4)
                SizedBox(
                  height: 5.0,
                ),
              if (totalLv >= 4)
                new Container(
                  width: 5000.0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 0,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFC5DAFC),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: (_selectedLv4 != '')
                      ? DropdownButtonFormField(
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Sarabun',
                              fontSize: 10.0,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          validator: (value) =>
                              value == '' || value == null ? 'โปรดระบุ' : null,
                          hint: Text(
                            'โปรดระบุ',
                            style: TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                          value: _selectedLv4,
                          onChanged: (newValue) {
                            var checkValue = _itemLv4.indexWhere(
                              (item) => item['code'] == newValue,
                            );

                            setState(() {
                              _selectedLv5 = "";
                              _itemLv5 = [];
                              _selectedLv4 = newValue as String;
                              _selectedTitleLv4 = _itemLv4[checkValue]['title'];
                            });

                            getOrganizationLv5();
                          },
                          items: _itemLv4.map((item) {
                            return DropdownMenuItem(
                              child: new Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 15.00,
                                  fontFamily: 'Sarabun',
                                  color: Color(
                                    0xFF000070,
                                  ),
                                ),
                              ),
                              value: item['code'],
                            );
                          }).toList(),
                        )
                      : DropdownButtonFormField(
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Sarabun',
                              fontSize: 10.0,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          validator: (value) =>
                              value == '' || value == null ? 'โปรดระบุ' : null,
                          hint: Text(
                            'โปรดระบุ',
                            style: TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                          onChanged: (newValue) {
                            var checkValue = _itemLv4.indexWhere(
                              (item) => item['code'] == newValue,
                            );

                            setState(() {
                              _selectedLv5 = "";
                              _itemLv5 = [];
                              _selectedLv4 = newValue as String;
                              _selectedTitleLv4 = _itemLv4[checkValue]['title'];
                            });

                            getOrganizationLv5();
                          },
                          items: _itemLv4.map((item) {
                            return DropdownMenuItem(
                              child: new Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 15.00,
                                  fontFamily: 'Sarabun',
                                  color: Color(
                                    0xFF000070,
                                  ),
                                ),
                              ),
                              value: item['code'],
                            );
                          }).toList(),
                        ),
                ),
              if (totalLv >= 5)
                SizedBox(
                  height: 5.0,
                ),
              if (totalLv >= 5)
                new Container(
                  width: 5000.0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 0,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFC5DAFC),
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                  child: (_selectedLv5 != '')
                      ? DropdownButtonFormField(
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Sarabun',
                              fontSize: 10.0,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          validator: (value) =>
                              value == '' || value == null ? 'โปรดระบุ' : null,
                          hint: Text(
                            'โปรดระบุ',
                            style: TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                          value: _selectedLv5,
                          onChanged: (newValue) {
                            var checkValue = _itemLv5.indexWhere(
                              (item) => item['code'] == newValue,
                            );

                            setState(() {
                              _selectedLv5 = newValue as String;
                              _selectedTitleLv5 = _itemLv5[checkValue]['title'];
                            });
                          },
                          items: _itemLv5.map((item) {
                            return DropdownMenuItem(
                              child: new Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 15.00,
                                  fontFamily: 'Sarabun',
                                  color: Color(
                                    0xFF000070,
                                  ),
                                ),
                              ),
                              value: item['code'],
                            );
                          }).toList(),
                        )
                      : DropdownButtonFormField(
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Sarabun',
                              fontSize: 10.0,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          validator: (value) =>
                              value == '' || value == null ? 'โปรดระบุ' : null,
                          hint: Text(
                            'โปรดระบุ',
                            style: TextStyle(
                              fontSize: 15.00,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                          onChanged: (newValue) {
                            var checkValue = _itemLv5.indexWhere(
                              (item) => item['code'] == newValue,
                            );

                            setState(() {
                              _selectedLv5 = newValue as String;
                              _selectedTitleLv5 = _itemLv5[checkValue]['title'];
                            });
                          },
                          items: _itemLv5.map((item) {
                            return DropdownMenuItem(
                              child: new Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 15.00,
                                  fontFamily: 'Sarabun',
                                  color: Color(
                                    0xFF000070,
                                  ),
                                ),
                              ),
                              value: item['code'],
                            );
                          }).toList(),
                        ),
                ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF000070),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 40,
                      onPressed: () {
                        final form = _formOrganizationKey.currentState;
                        if (form!.validate()) {
                          form.save();
                          submitAddOrganization();
                        }
                      },
                      child: new Text(
                        'เพิ่มข้อมูล',
                        style: new TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Sarabun',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xFF000070),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      height: 40,
                      onPressed: () {
                        setState(() {
                          openOrganization = false;
                          _selectedLv1 = "";
                          _itemLv1 = [];
                          _selectedLv2 = "";
                          _itemLv2 = [];
                          _selectedLv3 = "";
                          _itemLv3 = [];
                          _selectedLv4 = "";
                          _itemLv4 = [];
                          _selectedLv5 = "";
                          _itemLv5 = [];
                          _selectedLv0 = "";
                          totalLv = 0;
                        });
                      },
                      child: new Text(
                        'ยกเลิก',
                        style: new TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Sarabun',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Color(
                0xFF000070,
              ),
              spreadRadius: 1),
        ],
        border: Border.all(color: Colors.white.withAlpha(50)),
      ),
      // height: 50,
    );
  }

  Future<dynamic> getPolicy() async {
    final result = await postObjectData("m/policy/read", {
      "category": "application",
      "username": _username,
    });
    if (result['status'] == 'S') {
      if (result['objectData'].length > 0) {
        for (var i in result['objectData']) {
          result['objectData'][i].isActive = "";
          result['objectData'][i].agree = false;
          result['objectData'][i].noAgree = false;
        }
        setState(() {
          dataPolicy = result['objectData'];
        });
      }
    }
  }

  Future<dynamic> getOrganizationLv0() async {
    final result = await postObjectData("organization/category/read", {
      "category": "lv0",
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemLv0 = result['objectData'];
      });
    }
  }

  Future<dynamic> getOrganizationLv1() async {
    setState(() {
      _selectedLv1 = "";
      _selectedTitleLv1 = "";
      _itemLv1 = [];
    });

    final result = await postObjectData("organization/category/read", {
      "category": "lv1",
      "lv0": _selectedLv0,
    });

    if (result['status'] == 'S') {
      setState(() {
        _itemLv1 = result['objectData'];
      });
    }
  }

  Future<dynamic> getOrganizationLv2() async {
    final result = await postObjectData("organization/category/read", {
      "category": "lv2",
      "lv1": _selectedLv1,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemLv2 = result['objectData'];
      });
    }
  }

  Future<dynamic> getOrganizationLv3() async {
    final result = await postObjectData("organization/category/read", {
      "category": "lv3",
      "lv2": _selectedLv2,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemLv3 = result['objectData'];
      });
    }
  }

  Future<dynamic> getOrganizationLv4() async {
    final result = await postObjectData("organization/category/read", {
      "category": "lv4",
      "lv3": _selectedLv3,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemLv4 = result['objectData'];
      });
    }
  }

  Future<dynamic> getOrganizationLv5() async {
    final result = await postObjectData("organization/category/read", {
      "category": "lv5",
      "lv4": _selectedLv4,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemLv5 = result['objectData'];
      });
    }
  }

  Future<dynamic> getProvince() async {
    final result = await postObjectData("route/province/read", {});
    if (result['status'] == 'S') {
      setState(() {
        _itemProvince = result['objectData'];
      });
    }
  }

  Future<dynamic> getDistrict() async {
    final result = await postObjectData("route/district/read", {
      'province': _selectedProvince,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemDistrict = result['objectData'];
      });
    }
  }

  Future<dynamic> getSubDistrict() async {
    final result = await postObjectData("route/tambon/read", {
      'province': _selectedProvince,
      'district': _selectedDistrict,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemSubDistrict = result['objectData'];
      });
    }
  }

  Future<dynamic> getPostalCode() async {
    final result = await postObjectData("route/postcode/read", {
      'tambon': _selectedSubDistrict,
    });
    if (result['status'] == 'S') {
      setState(() {
        _itemPostalCode = result['objectData'];
      });
    }
  }

  bool isValidDate(String input) {
    try {
      final date = DateTime.parse(input);
      final originalFormatString = toOriginalFormatString(date);
      return input == originalFormatString;
    } catch (e) {
      return false;
    }
  }

  String toOriginalFormatString(DateTime dateTime) {
    final y = dateTime.year.toString().padLeft(4, '0');
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return "$y$m$d";
  }

  Future<dynamic> submitAddOrganization() async {
    if (dataCountUnit.length > 0) {
      var index = dataCountUnit.indexWhere(
        (c) =>
            c['lv0'] == _selectedLv0 &&
            c['lv1'] == _selectedLv1 &&
            c['lv2'] == _selectedLv2 &&
            c['lv3'] == _selectedLv3 &&
            c['lv4'] == _selectedLv4 &&
            c['lv5'] == _selectedLv5,
      );
      if (index == -1) {
        dataCountUnit.add({
          "lv0": _selectedLv0,
          "titleLv0": _selectedTitleLv0,
          "lv1": _selectedLv1,
          "titleLv1": _selectedTitleLv1,
          "lv2": _selectedLv2 ?? '',
          "titleLv2": _selectedTitleLv2 ?? '',
          "lv3": _selectedLv3 ?? '',
          "titleLv3": _selectedTitleLv3 ?? '',
          "lv4": _selectedLv4 ?? '',
          "titleLv4": _selectedTitleLv4 ?? '',
          "lv5": _selectedLv5 ?? '',
          "titleLv5": _selectedTitleLv5 ?? '',
          "status": "V",
        });

        this.setState(() {
          dataCountUnit = dataCountUnit;
          _selectedLv0 = "";
          _selectedTitleLv0 = "";
          _selectedLv1 = "";
          _selectedTitleLv1 = "";
          _selectedLv2 = "";
          _selectedTitleLv2 = "";
          _selectedLv3 = "";
          _selectedTitleLv3 = "";
          _selectedLv4 = "";
          _selectedTitleLv4 = "";
          _selectedLv5 = "";
          _selectedTitleLv5 = "";
          openOrganization = false;
          totalLv = 0;
        });
      } else {
        return showDialog(
          context: context,
          builder: (BuildContext context) => new CupertinoAlertDialog(
            title: new Text(
              'ข้อมูลซ้ำ กรุณาเลือกใหม่',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Sarabun',
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            content: Text(''),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: new Text(
                  "ตกลง",
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Sarabun',
                    color: Color(0xFF000070),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    } else {
      dataCountUnit.add({
        "lv0": _selectedLv0 ?? '',
        "titleLv0": _selectedTitleLv0 ?? '',
        "lv1": _selectedLv1 ?? '',
        "titleLv1": _selectedTitleLv1 ?? '',
        "lv2": _selectedLv2 ?? '',
        "titleLv2": _selectedTitleLv2 ?? '',
        "lv3": _selectedLv3 ?? '',
        "titleLv3": _selectedTitleLv3 ?? '',
        "lv4": _selectedLv4 ?? '',
        "titleLv4": _selectedTitleLv4 ?? '',
        "lv5": _selectedLv5 ?? '',
        "titleLv5": _selectedTitleLv5 ?? '',
        "status": "V",
      });

      this.setState(() {
        dataCountUnit = dataCountUnit;
        _selectedLv0 = "";
        _selectedTitleLv0 = "";
        _selectedLv1 = "";
        _selectedTitleLv1 = "";
        _selectedLv2 = "";
        _selectedTitleLv2 = "";
        _selectedLv3 = "";
        _selectedTitleLv3 = "";
        _selectedLv4 = "";
        _selectedTitleLv4 = "";
        _selectedLv5 = "";
        _selectedTitleLv5 = "";
        openOrganization = false;
        totalLv = 0;
      });
    }
  }

  Future<dynamic> submitUpdateUser() async {
    if (dataCountUnit.length == 0) {
      return showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(
            'กรุณาเพิ่มหน่วยงานอย่างน้อย 1 หน่วยงาน',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Sarabun',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Text(''),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: new Text(
                "ตกลง",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Sarabun',
                  color: Color(0xFF000070),
                  fontWeight: FontWeight.normal,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else {
      var codeLv0 = "";
      var codeLv1 = "";
      var codeLv2 = "";
      var codeLv3 = "";
      var codeLv4 = "";
      var codeLv5 = "";

      // var dataRow = dataCountUnit;
      for (var i in dataCountUnit) {
        if (codeLv0 != "") {
          codeLv0 = codeLv0 + "," + i['lv0'];
        } else {
          codeLv0 = i['lv0'];
        }

        if (codeLv1 != "") {
          codeLv1 = codeLv1 + "," + i['lv1'];
        } else {
          codeLv1 = i['lv1'];
        }

        if (codeLv2 != "") {
          codeLv2 = codeLv2 + "," + i['lv2'];
        } else {
          codeLv2 = i['lv2'];
        }

        if (codeLv3 != "") {
          codeLv3 = codeLv3 + "," + i['lv3'];
        } else {
          codeLv3 = i['lv3'];
        }

        if (codeLv4 != "") {
          codeLv4 = codeLv4 + "," + i['lv4'];
        } else {
          codeLv4 = i['lv4'];
        }
        if (codeLv5 != "") {
          codeLv5 = codeLv4 + "," + i['lv4'];
        } else {
          codeLv5 = i['lv4'];
        }
      }

      var index = dataCountUnit.indexWhere((c) => c['status'] != "A");

      var value = await storage.read(key: 'dataUserLoginDDPM');
      var user = json.decode(value!);
      user['imageUrl'] = _imageUrl ?? '';
      // user['prefixName'] = _selectedPrefixName ?? '';
      user['prefixName'] = txtPrefixName.text ?? '';
      user['firstName'] = txtFirstName.text ?? '';
      user['lastName'] = txtLastName.text ?? '';
      user['email'] = txtEmail.text ?? '';
      user['phone'] = txtPhone.text ?? '';

      user['birthDay'] = DateFormat("yyyyMMdd").format(
        DateTime(
          _selectedYear,
          _selectedMonth,
          _selectedDay,
        ),
      );
      user['sex'] = _selectedSex ?? '';
      user['address'] = txtAddress.text ?? '';
      user['soi'] = txtSoi.text ?? '';
      user['moo'] = txtMoo.text ?? '';
      user['road'] = txtRoad.text ?? '';
      user['tambon'] = '';
      user['amphoe'] = '';
      user['province'] = '';
      user['postno'] = '';
      user['tambonCode'] = _selectedSubDistrict ?? '';
      user['amphoeCode'] = _selectedDistrict ?? '';
      user['provinceCode'] = _selectedProvince ?? '';
      user['postnoCode'] = _selectedPostalCode ?? '';
      user['idcard'] = txtIdCard.text ?? '';
      user['officerCode'] = txtOfficerCode.text ?? '';
      user['linkAccount'] =
          user['linkAccount'] != null ? user['linkAccount'] : '';
      user['countUnit'] = json.encode(dataCountUnit);
      user['lv0'] = codeLv0;
      user['lv1'] = codeLv1;
      user['lv2'] = codeLv2;
      user['lv3'] = codeLv3;
      user['lv4'] = codeLv4;
      user['lv5'] = codeLv5;
      // user['status'] = "V";
      user['status'] = index == -1 ? user['status'] : "V";
      user['appleID'] = user['appleID'] != null ? user['appleID'] : "";

      final result = await postObjectData('m/Register/update', user);

      if (result['status'] == 'S') {
        await storage.write(
          key: 'dataUserLoginDDPM',
          value: jsonEncode(result['objectData']),
        );

        // if (index != -1) {
        //   final result = postObjectData(
        //     'm/Register/sendMail/verification',
        //     user,
        //   );
        // }

        if (dataPolicy.length > 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  PolicyIdentityVerificationPage(username: _username),
            ),
          );
        } else {
          return showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: CupertinoAlertDialog(
                  title: new Text(
                    'ยืนยันตัวตนเรียบร้อยแล้ว',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Sarabun',
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  content: Text(" "),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: new Text(
                        "ตกลง",
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Sarabun',
                          color: Color(0xFF000070),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      onPressed: () {
                        goBack();
                        // Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }
      } else {
        return showDialog(
          context: context,
          builder: (BuildContext context) => new CupertinoAlertDialog(
            title: new Text(
              'ยืนยันตัวตนไม่สำเร็จ',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Sarabun',
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            content: Text(
              result['message'],
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Sarabun',
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: new Text(
                  "ตกลง",
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Sarabun',
                    color: Color(0xFF000070),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    }
  }

  readStorage() async {
    var value = await storage.read(key: 'dataUserLoginDDPM');
    var user = json.decode(value!);

    if (user['code'] != '') {
      setState(() {
        _imageUrl = user['imageUrl'] ?? '';
        txtFirstName.text = user['firstName'] ?? '';
        txtLastName.text = user['lastName'] ?? '';
        txtEmail.text = user['email'] ?? '';
        txtPhone.text = user['phone'] ?? '';
        txtPrefixName.text = user['prefixName'] ?? '';
        // _selectedPrefixName = user['prefixName'];
        _code = user['code'];
      });

      if (user['birthDay'] != '') {
        var date = user['birthDay'];
        var year = date.substring(0, 4);
        var month = date.substring(4, 6);
        var day = date.substring(6, 8);
        DateTime todayDate = DateTime.parse(year + '-' + month + '-' + day);
        // DateTime todayDate = DateTime.parse(user['birthDay']);

        setState(() {
          _selectedYear = todayDate.year;
          _selectedMonth = todayDate.month;
          _selectedDay = todayDate.day;
          txtDate.text = DateFormat("dd-MM-yyyy").format(todayDate);
        });
      }
      // getUser();
    }
  }

  card() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(padding: EdgeInsets.all(15), child: _buildContentCard()),
    );
  }

  dropdownMenuItemHaveData(
    String _selected,
    List<dynamic> _item,
    String title,
  ) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontFamily: 'Sarabun',
          fontSize: 10.0,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      validator: (value) => value == null ? 'กรุณาเลือก' + title : null,
      hint: Text(
        title,
        style: TextStyle(
          fontSize: 15.00,
          fontFamily: 'Sarabun',
        ),
      ),
      value: _selected,
      onChanged: (newValue) {
        setState(() {
          _selected = newValue as String;
        });
      },
      items: _item.map((item) {
        return DropdownMenuItem(
          child: new Text(
            item['title'],
            style: TextStyle(
              fontSize: 15.00,
              fontFamily: 'Sarabun',
              color: Color(
                0xFF000070,
              ),
            ),
          ),
          value: item['code'],
        );
      }).toList(),
    );
  }

  dropdownMenuItemNoHaveData(
    String _selected,
    List<dynamic> _item,
    String title,
  ) {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        errorStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontFamily: 'Sarabun',
          fontSize: 10.0,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
      validator: (value) =>
          value == '' || value == null ? 'กรุณาเลือก' + title : null,
      hint: Text(
        title,
        style: TextStyle(
          fontSize: 15.00,
          fontFamily: 'Sarabun',
        ),
      ),
      // value: _selected,
      onChanged: (newValue) {
        setState(() {
          _selected = newValue as String;
        });
      },
      items: _item.map((item) {
        return DropdownMenuItem(
          child: new Text(
            item['title'],
            style: TextStyle(
              fontSize: 15.00,
              fontFamily: 'Sarabun',
              color: Color(
                0xFF000070,
              ),
            ),
          ),
          value: item['code'],
        );
      }).toList(),
    );
  }

  rowContentButton(String urlImage, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Container(
            child: new Padding(
              padding: EdgeInsets.all(5.0),
              child: Image.asset(
                urlImage,
                height: 5.0,
                width: 5.0,
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Color(0xFF0B5C9E),
            ),
            width: 30.0,
            height: 30.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.63,
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              title,
              style: new TextStyle(
                fontSize: 12.0,
                color: Color(0xFF000070),
                fontWeight: FontWeight.normal,
                fontFamily: 'Sarabun',
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Image.asset(
              "assets/icons/Group6232.png",
              height: 20.0,
              width: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  _imgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image!;
    });

    _upload();
  }

  _imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image!;
    });
    _upload();
  }

  void _upload() async {
    uploadImage(_image).then((res) {
      setState(() {
        _imageUrl = res;
      });
    }).catchError((err) {
      print(err);
    });
  }

  void _showPickerImage(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text(
                      'อัลบั้มรูปภาพ',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Sarabun',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text(
                    'กล้องถ่ายรูป',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Sarabun',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void goBack() async {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => UserInformationPage(),
      ),
      (Route<dynamic> route) => false,
    );
    // Navigator.pop(context, false);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => UserInformationPage(),
    //   ),
    // );
  }
}
