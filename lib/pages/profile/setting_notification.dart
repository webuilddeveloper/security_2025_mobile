import 'dart:convert';
import 'package:security_2025_mobile_v3/pages/profile/user_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:security_2025_mobile_v3/pages/blank_page/dialog_fail.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';

class SettingNotificationPage extends StatefulWidget {
  @override
  _SettingNotificationPageState createState() =>
      _SettingNotificationPageState();
}

class _SettingNotificationPageState extends State<SettingNotificationPage> {
  final storage = new FlutterSecureStorage();

  late String _username;

  late Future<dynamic> futureModel;

  ScrollController scrollController = new ScrollController();

  bool isSwitchedEventPage = false;
  bool isSwitchedContactPage = false;
  bool isSwitchedKnowledgePage = false;
  bool isSwitchedMainPage = false;
  bool isSwitchedNewsPage = false;
  bool isSwitchedPoiPage = false;
  bool isSwitchedPollPage = false;
  bool isSwitchedPrivilegePage = false;
  bool isSwitchedReporterPage = false;
  bool isSwitchedWelfarePage = false;
  bool isSwitchedCooperativeFormPage = false;
  bool isSwitchedWarningPage = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    futureModel = readNotification();
    super.initState();
  }

  Future<dynamic> readNotification() async {
    var value = await storage.read(key: 'dataUserLoginDDPM');
    var user = json.decode(value!);
    if (user['code'] != '') {
      setState(() {
        _username = user['username'] ?? '';
      });
    }
    final result = await postObjectData('m/register/notification/read', {
      'username': _username,
    });

    if (result['status'] == 'S') {
      await storage.write(
        key: 'dataNotificationDDPM',
        value: jsonEncode(result['objectData']),
      );

      setState(() {
        isSwitchedEventPage = result['objectData']['eventPage'];
        isSwitchedContactPage = result['objectData']['contactPage'];
        isSwitchedKnowledgePage = result['objectData']['knowledgePage'];
        isSwitchedMainPage = result['objectData']['mainPage'];
        isSwitchedNewsPage = result['objectData']['newsPage'];
        isSwitchedPoiPage = result['objectData']['poiPage'];
        isSwitchedPollPage = result['objectData']['pollPage'];
        isSwitchedPrivilegePage = result['objectData']['privilegePage'];
        isSwitchedReporterPage = result['objectData']['reporterPage'];
        isSwitchedWelfarePage = result['objectData']['welfarePage'];
        isSwitchedCooperativeFormPage =
            result['objectData']['cooperativeFormPage'];
        isSwitchedWarningPage = result['objectData']['warningPage'];
      });
    }
  }

  Future<dynamic> updateNotication() async {
    var value = await storage.read(key: 'dataNotificationDDPM');
    var data = json.decode(value!);
    data['eventPage'] = isSwitchedEventPage;
    data['contactPage'] = isSwitchedContactPage;
    data['knowledgePage'] = isSwitchedKnowledgePage;
    data['mainPage'] = isSwitchedMainPage;
    data['newsPage'] = isSwitchedNewsPage;
    data['poiPage'] = isSwitchedPoiPage;
    data['pollPage'] = isSwitchedPollPage;
    data['privilegePage'] = isSwitchedPrivilegePage;
    data['reporterPage'] = isSwitchedReporterPage;
    data['welfarePage'] = isSwitchedWelfarePage;
    data['cooperativeFormPage'] = isSwitchedCooperativeFormPage;
    data['warningPage'] = isSwitchedWarningPage;

    final result = await postObjectData('m/Register/notification/update', data);

    if (result['status'] == 'S') {
      await storage.write(
        key: 'dataNotificationDDPM',
        value: jsonEncode(result['objectData']),
      );

      setState(() {
        isSwitchedEventPage = result['objectData']['eventPage:'] ?? '';
        isSwitchedContactPage = result['objectData']['contactPage:'] ?? '';
        isSwitchedKnowledgePage = result['objectData']['knowledgePage:'] ?? '';
        isSwitchedMainPage = result['objectData']['mainPage'] ?? '';
        isSwitchedNewsPage = result['objectData']['newsPage'] ?? '';
        isSwitchedPoiPage = result['objectData']['poiPage'] ?? '';
        isSwitchedPollPage = result['objectData']['pollPage'] ?? '';
        isSwitchedPrivilegePage = result['objectData']['privilegePage'] ?? '';
        isSwitchedReporterPage = result['objectData']['reporterPage'] ?? '';
        isSwitchedWelfarePage = result['objectData']['welfarePage'] ?? '';
        isSwitchedCooperativeFormPage =
            result['objectData']['cooperativeFormPage'] ?? '';
      });
    }
  }

  void goBack() async {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => UserInformationPage(),
      ),
      (Route<dynamic> route) => false,
    );
    // Navigator.pop(context, false);
    // // Navigator.of(context).push(
    // //   MaterialPageRoute(
    // //     builder: (context) => UserInformationPage(),
    // //   ),
    // // );
  }

  card() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(padding: EdgeInsets.all(10), child: contentCard()),
    );
  }

  contentCard() {
    return Column(
      // shrinkWrap: true,
      // physics: ClampingScrollPhysics(),
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFE2E2E2),
                width: 1.0,
              ),
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.73,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'ระบบแจ้งเตือน',
                  style: new TextStyle(
                    fontSize: 13.0,
                    //color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Sarabun',
                  ),
                ),
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedMainPage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedMainPage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFFFEE9E8),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFE2E2E2),
                width: 1.0,
              ),
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.73,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'สาธารณภัยในต่างแดน',
                  style: new TextStyle(
                    fontSize: 13.0,
                    //color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Sarabun',
                  ),
                ),
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedNewsPage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedNewsPage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFFFEE9E8),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFE2E2E2),
                width: 1.0,
              ),
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.73,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'แวดวงอาสา',
                  style: new TextStyle(
                    fontSize: 13.0,
                    //color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Sarabun',
                  ),
                ),
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedEventPage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedEventPage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFFFEE9E8),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFE2E2E2),
                width: 1.0,
              ),
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.73,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'อาสาฉุกเฉิน',
                  style: new TextStyle(
                    fontSize: 13.0,
                    //color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Sarabun',
                  ),
                ),
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedContactPage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedContactPage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFFFEE9E8),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFE2E2E2),
                width: 1.0,
              ),
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.73,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'อาสาควรรู้',
                  style: new TextStyle(
                    fontSize: 13.0,
                    //color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Sarabun',
                  ),
                ),
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedKnowledgePage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedKnowledgePage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFFFEE9E8),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFE2E2E2),
                width: 1.0,
              ),
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.73,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'สิทธิประโยชน์อาสา',
                  style: new TextStyle(
                    fontSize: 13.0,
                    //color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Sarabun',
                  ),
                ),
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedPrivilegePage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedPrivilegePage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFFFEE9E8),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFE2E2E2),
                width: 1.0,
              ),
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.73,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'สถานที่น่าสนใจ',
                  style: new TextStyle(
                    fontSize: 13.0,
                    //color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Sarabun',
                  ),
                ),
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedPoiPage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedPoiPage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFFFEE9E8),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFE2E2E2),
                width: 1.0,
              ),
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.73,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'แบบสอบถาม',
                  style: new TextStyle(
                    fontSize: 13.0,
                    //color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Sarabun',
                  ),
                ),
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedPollPage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedPollPage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFFFEE9E8),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFE2E2E2),
                width: 1.0,
              ),
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.73,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'อาสารายงาน',
                  style: new TextStyle(
                    fontSize: 13.0,
                    //color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Sarabun',
                  ),
                ),
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedReporterPage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedReporterPage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFFFEE9E8),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFE2E2E2),
                width: 1.0,
              ),
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.73,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  'สวัสดิการอาสา',
                  style: new TextStyle(
                    fontSize: 13.0,
                    //color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Sarabun',
                  ),
                ),
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedWelfarePage,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedWelfarePage = value;
                    });
                    updateNotication();
                  },
                  activeTrackColor: Color(0xFFFEE9E8),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  rowContentButton(String urlImage, String title) {
    return Container(
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
              //color: Theme.of(context).primaryColor,
            ),
            width: 30.0,
            height: 40.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.733,
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              title,
              style: new TextStyle(
                fontSize: 13.0,
                //color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.normal,
                fontFamily: 'Sarabun',
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Image.asset(
              "assets/logo/icons/Group6232.png",
              height: 20.0,
              width: 20.0,
            ),
          ),
        ],
      ),
    );
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
        else
          return Scaffold(
            appBar: header(context, goBack,
                title: 'ตั้งค่าการแจ้งเตือน', rightButton: null),
            backgroundColor: Colors.white,
            body: Container(
              child: ListView(
                controller: scrollController,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                // padding: EdgeInsets.only(top: 10),
                children: <Widget>[
                  new Column(
                    // alignment: Alignment.topCenter,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.symmetric(
                          horizontal: 5.0,
                          // vertical: 10.0,
                        ),
                        child: contentCard(),
                      ),
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
