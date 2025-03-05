import 'dart:convert';
import 'package:security_2025_mobile_v3/pages/profile/user_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:security_2025_mobile_v3/pages/blank_page/dialog_fail.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:security_2025_mobile_v3/widget/text_form_field.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ConnectSocialPage extends StatefulWidget {
  @override
  _ConnectSocialPageState createState() => _ConnectSocialPageState();
}

class _ConnectSocialPageState extends State<ConnectSocialPage> {
  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  late String _facebookID;
  late String _appleID;
  late String _googleID;
  late String _lineID;
  late String _email;
  late String _imageUrl;
  late String _category;
  late String _code;
  late String _username;
  late String _password;
  late Map userProfile;

  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();

  bool showTxtPasswordOld = true;
  bool showTxtPassword = true;
  bool showTxtConPassword = true;
  bool _isOnlyWebLogin = false;

  bool showIsEdit = false;

  DateTime selectedDate = DateTime.now();
  TextEditingController dateCtl = TextEditingController();

  late Future<dynamic> futureModel;

  ScrollController scrollController = new ScrollController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtUsername.dispose();
    txtPassword.dispose();
    txtConPassword.dispose();
    super.dispose();
  }

  @override
  void initState() {
    readStorage();
    super.initState();
  }

  Future<dynamic> readUser() async {
    final result = await postObjectData("m/Register/read", {
      'code': _code,
    });

    if (result['status'] == 'S') {
      await storage.write(
        key: 'dataUserLoginDDPM',
        value: jsonEncode(result['objectData'][0]),
      );

      if (result['objectData'][0]['password'] == '') {
        setState(() {
          showIsEdit = true;
        });
      }

      setState(() {
        txtUsername.text = result['objectData'][0]['username'] ?? '';
        txtPassword.text = result['objectData'][0]['password'] ?? '';
        _imageUrl = result['objectData'][0]['imageUrl'] ?? '';
        _facebookID = result['objectData'][0]['facebookID'] ?? '';
        _appleID = result['objectData'][0]['appleID'] ?? '';
        _googleID = result['objectData'][0]['googleID'] ?? '';
        _lineID = result['objectData'][0]['lineID'] ?? '';
        _code = result['objectData'][0]['code'] ?? '';
      });
    }
  }

  Future<dynamic> submitUpdateUser() async {
    var value = await storage.read(key: 'dataUserLoginDDPM');
    var user = json.decode(value!);
    user['password'] = txtPassword.text;
    user['username'] = txtUsername.text;
    user['linkAccount'] =
        user['linkAccount'] == null ? '' : user['linkAccount'];

    final result = await postObjectData('m/Register/update', user);
    if (result['status'] == 'S') {
      await storage.write(
        key: 'dataUserLoginDDPM',
        value: jsonEncode(result['objectData']),
      );
      readStorage();

      return showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(
            'เชื่อมต่อบัญชีเรียบร้อยแล้ว',
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
                "ยกเลิก",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Sarabun',
                  color: Theme.of(context).primaryColor,
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
      return showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(
            'เชื่อมต่อบัญชีไม่สำเร็จ',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Sarabun',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: new Text(
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
                "ยกเลิก",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Sarabun',
                  color: Theme.of(context).primaryColor,
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

  Future<dynamic> submitConnectSocial() async {
    var value = await storage.read(key: 'dataUserLoginDDPM');
    var user = json.decode(value!);
    user['appleID'] = _appleID;
    user['googleID'] = _googleID;
    user['lineID'] = _lineID;
    user['facebookID'] = _facebookID;
    user['category'] = _category;

    final result = await postObjectData('m/Register/linkAccount/create', user);
    if (result['status'] == 'S') {
      await storage.write(
        key: 'dataUserLoginDDPM',
        value: jsonEncode(result['objectData']),
      );
      readStorage();

      return showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(
            'เชื่อมต่อบัญชีเรียบร้อยแล้ว',
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
                "ยกเลิก",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Sarabun',
                  color: Theme.of(context).primaryColor,
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
      return showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(
            'เชื่อมต่อบัญชีไม่สำเร็จ',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Sarabun',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: new Text(
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
                "ยกเลิก",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Sarabun',
                  color: Theme.of(context).primaryColor,
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

  Future<dynamic> submitUnLinkConnectSocial(String getCategory) async {
    var value = await storage.read(key: 'dataUserLoginDDPM');
    var user = json.decode(value!);
    user['category'] = getCategory;

    final result = await postObjectData('m/Register/linkAccount/delete', user);
    if (result['status'] == 'S') {
      await storage.write(
        key: 'dataUserLoginDDPM',
        value: jsonEncode(result['objectData']),
      );
      readStorage();
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => UserInformationPage(),
      //   ),
      // );

      return showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(
            'ยกเลิกการเชื่อมต่อบัญชีเรียบร้อยแล้ว',
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
                "ยกเลิก",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Sarabun',
                  color: Theme.of(context).primaryColor,
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
      return showDialog(
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(
            'ยกเลิกการเชื่อมต่อบัญชีไม่สำเร็จ',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Sarabun',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: new Text(
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
                "ยกเลิก",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Sarabun',
                  color: Theme.of(context).primaryColor,
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

  readStorage() async {
    var value = await storage.read(key: 'dataUserLoginDDPM');
    var user = json.decode(value!);

    if (user['code'] != '') {
      setState(() {
        _imageUrl = user['imageUrl'] ?? '';
        _facebookID = user['facebookID'] ?? '';
        _appleID = user['appleID'] ?? '';
        _googleID = user['googleID'] ?? '';
        _lineID = user['lineID'] ?? '';
        _code = user['code'] ?? '';
        _username = user['username'] ?? '';
        _password = user['password'] ?? '';
        txtUsername.text = user['username'] ?? '';
        txtPassword.text = user['password'] ?? '';
        futureModel = readUser();
      });
    }
  }

  //login line sdk
  void loginWithLine() async {
    try {
      final loginOption = LoginOption(
        _isOnlyWebLogin,
        'normal',
        requestCode: 8192,
      );

      final result = await LineSDK.instance.login(
        scopes: ["profile", "openid", "email"],
        option: loginOption,
      );

      final idToken = result.accessToken.idToken;
      final userEmail = (idToken != null)
          ? idToken['email'] != null
              ? idToken['email']
              : ''
          : '';

      setState(() {
        _email = userEmail.toString() ?? '';
        _category = 'line';
        _lineID = result.userProfile!.userId.toString();
      });
      submitConnectSocial();
    } on PlatformException catch (e) {
      switch (e.code.toString()) {
        case "CANCEL":
          print(
              "คุณยกเลิกการเข้าสู่ระบบ เมื่อสักครู่คุณกดยกเลิกการเข้าสู่ระบบ กรุณาเข้าสู่ระบบใหม่อีกครั้ง");
          break;
        case "AUTHENTICATION_AGENT_ERROR":
          print(
              "คุณไม่อนุญาติการเข้าสู่ระบบด้วย LINE เมื่อสักครู่คุณกดยกเลิกการเข้าสู่ระบบ กรุณาเข้าสู่ระบบใหม่อีกครั้ง");
          break;
        default:
          print(
              "เกิดข้อผิดพลาด เกิดข้อผิดพลาดไม่ทราบสาเหตุ กรุณาเข้าสู่ระบบใหม่อีกครั้ง" +
                  e.code.toString());
          break;
      }
    }
  }

  //login google
  Future<dynamic> loginWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    try {
      final result = await _googleSignIn.signIn();

      setState(() {
        _email = result?.email.toString() ?? '';
        _category = 'google';
        _googleID = result!.id.toString();
      });
      submitConnectSocial();
    } catch (err) {
      print(err);
    }
  }

  card() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(padding: EdgeInsets.all(15), child: contentCard()),
    );
  }

  contentCard() {
    double width = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          Container(
            height: 45.0,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFE2E2E2),
                  width: 1.0,
                ),
              ),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(0.0),
              ),
              child: rowContentButton(
                  "assets/logo/socials/facebook.png", "Facebook", _facebookID),
              onPressed: () => {
                if (_facebookID == '')
                  {
                    // loginWithFacebook(),
                  }
                else
                  {
                    submitUnLinkConnectSocial('facebook'),
                  }
              },
            ),
          ),
          Container(
            height: 45.0,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFE2E2E2),
                  width: 1.0,
                ),
              ),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(0.0),
              ),
              child: rowContentButton(
                  "assets/logo/socials/line.png", "Line", _lineID),
              onPressed: () => {
                if (_lineID == '')
                  {
                    loginWithLine(),
                  }
                else
                  {
                    submitUnLinkConnectSocial('line'),
                  }
              },
            ),
          ),
          Container(
            height: 45.0,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFE2E2E2),
                  width: 1.0,
                ),
              ),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.all(0.0),
              ),
              child: rowContentButton(
                  "assets/logo/socials/google.png", "Google", _googleID),
              onPressed: () => {
                if (_googleID == '')
                  {
                    loginWithGoogle(),
                  }
                else
                  {
                    submitUnLinkConnectSocial('google'),
                  }
              },
            ),
          ),
          Container(
            height: 45.0,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFE2E2E2),
                  width: 1.0,
                ),
              ),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: new Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Image.asset(
                        "assets/logo/logo.png",
                        height: 20.0,
                        width: 20.0,
                      ),
                    ),
                    width: 35.0,
                    height: 35.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    margin: EdgeInsets.only(left: 2.0, right: 10.0),
                    child: Text(
                      'เข้าใช้ด้วยบัญชี Smart Security',
                      style: new TextStyle(
                        fontSize: 14.0,
                        // color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Sarabun',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(children: <Widget>[]),
          Center(
            child: Container(
              width: width * 0.8,
              child: labelTextFormField('* ชื่อผู้ใช้งาน'),
            ),
          ),
          Center(
            child: Container(
              width: width * 0.8,
              child: textFormField(
                txtUsername,
                null,
                'ชื่อผู้ใช้งาน',
                'ชื่อผู้ใช้งาน',
                _username != '' ? false : true,
                false,
                false,
              ),
            ),
          ),
          Center(
            child: Container(
              width: width * 0.8,
              child: labelTextFormFieldPasswordOldNew('* รหัสผ่าน', true),
            ),
          ),
          Center(
            child: Container(
              width: width * 0.8,
              child: TextFormField(
                obscureText: showTxtPassword,
                style: TextStyle(
                  color: showIsEdit
                      ? Theme.of(context).primaryColor
                      : Colors.white,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Sarabun',
                  fontSize: 15.0,
                ),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      showTxtPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        showTxtPassword = !showTxtPassword;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: showIsEdit ? Color(0xFFC5DAFC) : Color(0xFF707070),
                  contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  hintText: 'รหัสผ่านใหม่',
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
                    return 'กรุณากรอกรหัสผ่านใหม่.';
                  }

                  String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,}$';
                  RegExp regex = new RegExp(pattern);
                  if (!regex.hasMatch(model)) {
                    return 'กรุณากรอกรูปแบบรหัสผ่านให้ถูกต้อง.';
                  }
                  return null;
                },
                controller: txtPassword,
                enabled: showIsEdit,
              ),
            ),
          ),
          if (showIsEdit)
            Center(
              child: Container(
                width: width * 0.8,
                child: labelTextFormField('* ยืนยันรหัสผ่าน'),
              ),
            ),
          if (showIsEdit)
            Center(
              child: Container(
                width: width * 0.8,
                child: TextFormField(
                  obscureText: showTxtConPassword,
                  style: TextStyle(
                    color: showIsEdit
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Sarabun',
                    fontSize: 15.0,
                  ),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        showTxtConPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          showTxtConPassword = !showTxtConPassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor:
                        showIsEdit ? Color(0xFFC5DAFC) : Color(0xFF707070),
                    contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    hintText: 'ยืนยันรหัสผ่านใหม่',
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
                      return 'กรุณากรอกยืนยันรหัสผ่านใหม่.';
                    }

                    if (model != txtPassword.text) {
                      return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
                    }

                    String pattern =
                        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,}$';
                    RegExp regex = new RegExp(pattern);
                    if (!regex.hasMatch(model)) {
                      return 'กรุณากรอกรูปแบบรหัสผ่านให้ถูกต้อง.';
                    }
                    return null;
                  },
                  controller: txtConPassword,
                  enabled: showIsEdit,
                ),
              ),
            ),
          if (showIsEdit)
            Center(
              child: Container(
                width: width * 0.6,
                margin: EdgeInsets.symmetric(vertical: 15.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).primaryColor,
                  child: MaterialButton(
                    // minWidth: MediaQuery.of(context).size.width,
                    height: 40,
                    onPressed: () {
                      final form = _formKey.currentState;
                      if (form!.validate()) {
                        form.save();
                        submitUpdateUser();
                      }
                    },
                    child: new Text(
                      'ยืนยัน',
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
    );
  }

  rowContentButton(String urlImage, String title, String getIDSocial) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: new Padding(
              padding: EdgeInsets.all(2.0),
              child: Image.asset(
                urlImage,
                height: 20.0,
                width: 20.0,
              ),
            ),
            width: 35.0,
            height: 35.0,
          ),
          Container(
            width: getIDSocial == ''
                ? MediaQuery.of(context).size.width * 0.65
                : MediaQuery.of(context).size.width * 0.50,
            margin: EdgeInsets.only(left: 2.0, right: 10.0),
            child: Text(
              title,
              style: new TextStyle(
                fontSize: 14.0,
                // color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.normal,
                fontFamily: 'Sarabun',
              ),
            ),
          ),
          Container(
            // width: MediaQuery.of(context).size.width * 0.63,
            margin: EdgeInsets.only(left: 0.0, right: 2.0),
            child: Text(
              getIDSocial == '' ? 'เชื่อมต่อ' : 'ยกเลิกการเชื่อมต่อ',
              style: new TextStyle(
                fontSize: 14.0,
                color: getIDSocial == '' ? Colors.blue : Color(0xFFFC4137),
                fontWeight: FontWeight.normal,
                fontFamily: 'Sarabun',
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: futureModel,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Container(
              color: Colors.white,
              child: dialogFail(context),
            ),
          );
        // return Center(child: Text('Error: ${snapshot.error}'));
        else
          return Scaffold(
            // appBar: header(context, goBack,
            //     title: 'การเชื่อมต่อ', rightButton: null),
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Center(
                child: Text(
                  'การเชื่อมต่อ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.transparent,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
              backgroundColor: Color(0XFFB03432),
            ),
            backgroundColor: Colors.white,
            body: Container(
              child: ListView(
                controller: scrollController,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                // padding: const EdgeInsets.all(10.0),
                children: <Widget>[
                  new Column(
                    // alignment: Alignment.topCenter,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.symmetric(
                          horizontal: 10.0,
                          // vertical: 10.0,
                        ),
                        child: contentCard(),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(top: 75.0),
                      //   child: card(),
                      // ),
                      // Container(
                      //   width: 150.0,
                      //   height: 150.0,
                      //   // decoration: ShapeDecoration(
                      //   //   shape: CircleBorder(),
                      //   //   color: Color(0xFFFC4137),
                      //   // ),
                      //   child: Padding(
                      //     padding: EdgeInsets.all(0.0),
                      //     child: DecoratedBox(
                      //       decoration: ShapeDecoration(
                      //         shape: CircleBorder(),
                      //         image: DecorationImage(
                      //           fit: BoxFit.cover,
                      //           image: _imageUrl != null
                      //               ? NetworkImage(_imageUrl)
                      //               : Image.asset("assets/logo/noImage.png"),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          );
      },
    );
  }
}
