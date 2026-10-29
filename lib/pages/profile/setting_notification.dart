import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';

class SettingNotificationPage extends StatefulWidget {
  SettingNotificationPage({
    super.key,
    this.storage = const FlutterSecureStorage(),
    this.request = postObjectData,
  });

  final FlutterSecureStorage storage;
  final Future<dynamic> Function(String, dynamic) request;

  @override
  _SettingNotificationPageState createState() =>
      _SettingNotificationPageState();
}

class _SettingNotificationPageState extends State<SettingNotificationPage> {
  FlutterSecureStorage get storage => widget.storage;
  String _username = '';
  Map<String, dynamic> _savedData = {};
  bool _ready = false;
  bool _saving = false;
  String _loadError = '';

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
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    futureModel = readNotification();
  }

  bool _asBool(dynamic value, [bool fallback = false]) {
    if (value is bool) return value;
    if (value == 1 || value == '1' || value == 'true') return true;
    if (value == 0 || value == '0' || value == 'false') return false;
    return fallback;
  }

  Map<String, dynamic> _normalize(Map<String, dynamic> data,
          [Map<String, dynamic> fallback = const {}]) =>
      {
        ...fallback,
        ...data,
        'eventPage': _asBool(data['eventPage'], _asBool(fallback['eventPage'])),
        'contactPage':
            _asBool(data['contactPage'], _asBool(fallback['contactPage'])),
        'knowledgePage':
            _asBool(data['knowledgePage'], _asBool(fallback['knowledgePage'])),
        'mainPage': _asBool(data['mainPage'], _asBool(fallback['mainPage'])),
        'newsPage': _asBool(data['newsPage'], _asBool(fallback['newsPage'])),
        'poiPage': _asBool(data['poiPage'], _asBool(fallback['poiPage'])),
        'pollPage': _asBool(data['pollPage'], _asBool(fallback['pollPage'])),
        'privilegePage':
            _asBool(data['privilegePage'], _asBool(fallback['privilegePage'])),
        'reporterPage':
            _asBool(data['reporterPage'], _asBool(fallback['reporterPage'])),
        'welfarePage':
            _asBool(data['welfarePage'], _asBool(fallback['welfarePage'])),
        'cooperativeFormPage': _asBool(data['cooperativeFormPage'],
            _asBool(fallback['cooperativeFormPage'])),
        'warningPage':
            _asBool(data['warningPage'], _asBool(fallback['warningPage'])),
      };

  void _apply(Map<String, dynamic> data) {
    isSwitchedEventPage = data['eventPage'] as bool;
    isSwitchedContactPage = data['contactPage'] as bool;
    isSwitchedKnowledgePage = data['knowledgePage'] as bool;
    isSwitchedMainPage = data['mainPage'] as bool;
    isSwitchedNewsPage = data['newsPage'] as bool;
    isSwitchedPoiPage = data['poiPage'] as bool;
    isSwitchedPollPage = data['pollPage'] as bool;
    isSwitchedPrivilegePage = data['privilegePage'] as bool;
    isSwitchedReporterPage = data['reporterPage'] as bool;
    isSwitchedWelfarePage = data['welfarePage'] as bool;
    isSwitchedCooperativeFormPage = data['cooperativeFormPage'] as bool;
    isSwitchedWarningPage = data['warningPage'] as bool;
  }

  Future<dynamic> readNotification() async {
    _ready = false;
    _loadError = '';
    try {
      final value = await storage.read(key: 'dataUserLoginDDPM');
      final user = value == null || value.isEmpty ? null : jsonDecode(value);
      if (user is! Map ||
          user['username'] is! String ||
          (user['username'] as String).trim().isEmpty) {
        _loadError = 'ไม่พบข้อมูลผู้ใช้ กรุณาเข้าสู่ระบบอีกครั้ง';
        return;
      }
      _username = user['username'];
      final result = await widget.request('m/register/notification/read', {
        'username': _username,
      });
      if (result is! Map ||
          result['status'] != 'S' ||
          result['objectData'] is! Map) {
        _loadError = 'โหลดการตั้งค่าการแจ้งเตือนไม่สำเร็จ กรุณาลองใหม่';
        return;
      }
      final data = _normalize(Map<String, dynamic>.from(result['objectData']));
      // Retain server identifiers for update, with the authenticated username.
      data['username'] = _username;
      await storage.write(key: 'dataNotificationDDPM', value: jsonEncode(data));
      if (!mounted) return;
      _savedData = data;
      _apply(data);
      _ready = true;
    } catch (_) {
      _loadError = 'ไม่สามารถโหลดการตั้งค่าการแจ้งเตือนได้ กรุณาลองใหม่';
    }
  }

  Future<dynamic> updateNotication() async {
    if (!_ready || _saving) return;
    final data = <String, dynamic>{
      ..._savedData,
      'username': _username,
      'eventPage': isSwitchedEventPage,
      'contactPage': isSwitchedContactPage,
      'knowledgePage': isSwitchedKnowledgePage,
      'mainPage': isSwitchedMainPage,
      'newsPage': isSwitchedNewsPage,
      'poiPage': isSwitchedPoiPage,
      'pollPage': isSwitchedPollPage,
      'privilegePage': isSwitchedPrivilegePage,
      'reporterPage': isSwitchedReporterPage,
      'welfarePage': isSwitchedWelfarePage,
      'cooperativeFormPage': isSwitchedCooperativeFormPage,
      'warningPage': isSwitchedWarningPage,
    };
    setState(() => _saving = true);
    var serverSaved = false;
    try {
      final result =
          await widget.request('m/Register/notification/update', data);
      if (result is! Map || result['status'] != 'S') {
        throw StateError('Notification update failed');
      }
      // Some successful updates return only changed fields or no objectData.
      final response = result['objectData'];
      if (response != null && response is! Map) {
        throw const FormatException('Invalid notification settings');
      }
      final saved = _normalize(
          response == null ? {} : Map<String, dynamic>.from(response), data);
      saved['username'] = _username;
      _savedData = saved;
      serverSaved = true;
      await storage.write(
          key: 'dataNotificationDDPM', value: jsonEncode(saved));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          serverSaved
              ? 'บันทึกบนระบบแล้ว แต่เก็บค่าบนอุปกรณ์ไม่สำเร็จ กรุณาเปิดหน้านี้ใหม่'
              : 'บันทึกการตั้งค่าไม่สำเร็จ กรุณาลองใหม่',
        )));
      }
    } finally {
      if (mounted) {
        setState(() {
          _apply(_savedData);
          _saving = false;
        });
      }
    }
  }

  void goBack() {
    Navigator.pop(context);
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
              Expanded(
                child: Container(
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
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedMainPage,
                  onChanged: !_ready
                      ? null
                      : (value) {
                          // Keep enabled styling while saving; ignore extra taps
                          // before changing state to avoid overlapping writes.
                          if (_saving) return;
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
              Expanded(
                child: Container(
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
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedNewsPage,
                  onChanged: !_ready
                      ? null
                      : (value) {
                          // Keep enabled styling while saving; ignore extra taps
                          // before changing state to avoid overlapping writes.
                          if (_saving) return;
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
              Expanded(
                child: Container(
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
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedEventPage,
                  onChanged: !_ready
                      ? null
                      : (value) {
                          // Keep enabled styling while saving; ignore extra taps
                          // before changing state to avoid overlapping writes.
                          if (_saving) return;
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
              Expanded(
                child: Container(
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
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedContactPage,
                  onChanged: !_ready
                      ? null
                      : (value) {
                          // Keep enabled styling while saving; ignore extra taps
                          // before changing state to avoid overlapping writes.
                          if (_saving) return;
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
              Expanded(
                child: Container(
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
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedKnowledgePage,
                  onChanged: !_ready
                      ? null
                      : (value) {
                          // Keep enabled styling while saving; ignore extra taps
                          // before changing state to avoid overlapping writes.
                          if (_saving) return;
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
              Expanded(
                child: Container(
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
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedPrivilegePage,
                  onChanged: !_ready
                      ? null
                      : (value) {
                          // Keep enabled styling while saving; ignore extra taps
                          // before changing state to avoid overlapping writes.
                          if (_saving) return;
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
              Expanded(
                child: Container(
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
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedPoiPage,
                  onChanged: !_ready
                      ? null
                      : (value) {
                          // Keep enabled styling while saving; ignore extra taps
                          // before changing state to avoid overlapping writes.
                          if (_saving) return;
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
              Expanded(
                child: Container(
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
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedPollPage,
                  onChanged: !_ready
                      ? null
                      : (value) {
                          // Keep enabled styling while saving; ignore extra taps
                          // before changing state to avoid overlapping writes.
                          if (_saving) return;
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
              Expanded(
                child: Container(
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
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedReporterPage,
                  onChanged: !_ready
                      ? null
                      : (value) {
                          // Keep enabled styling while saving; ignore extra taps
                          // before changing state to avoid overlapping writes.
                          if (_saving) return;
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
              Expanded(
                child: Container(
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
              ),
              Container(
                height: 40.0,
                alignment: Alignment.centerRight,
                child: Switch(
                  value: isSwitchedWelfarePage,
                  onChanged: !_ready
                      ? null
                      : (value) {
                          // Keep enabled styling while saving; ignore extra taps
                          // before changing state to avoid overlapping writes.
                          if (_saving) return;
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
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0XFFB03432),
            foregroundColor: Colors.white,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: goBack,
            ),
            title: const Text(
              'ตั้งค่าการแจ้งเตือน',
              style: TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: Colors.white,
          body: snapshot.connectionState != ConnectionState.done
              ? const Center(child: CircularProgressIndicator())
              : !_ready
                  ? Center(
                      child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_loadError,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontFamily: 'Sarabun')),
                          TextButton(
                            onPressed: () => setState(() {
                              futureModel = readNotification();
                            }),
                            child: const Text('ลองใหม่'),
                          ),
                        ],
                      ),
                    ))
                  : Container(
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
