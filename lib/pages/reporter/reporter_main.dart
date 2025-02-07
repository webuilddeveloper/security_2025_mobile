import 'dart:convert';
import 'package:security_2025_mobile_v3/pages/reporter/reporter_list_category.dart';
import 'package:security_2025_mobile_v3/pages/reporter/reporter_list_category_disaster.dart';
import 'package:security_2025_mobile_v3/pages/reporter/reporter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:security_2025_mobile_v3/pages/reporter/reporter_history_list.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ReporterMain extends StatefulWidget {
  ReporterMain({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _ReporterMain createState() => _ReporterMain();
}

class _ReporterMain extends State<ReporterMain> {
  final storage = new FlutterSecureStorage();

  bool hideSearch = true;
  final txtDescription = TextEditingController();
  late String keySearch;
  late String category;

  List<dynamic> _dataOrganization = [];
  String countReporter = '0';
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    read();
    super.initState();
  }

  read() async {
    var value = await storage.read(key: 'dataUserLoginDDPM');
    var data = json.decode(value!);

    setState(() {
      _dataOrganization =
          data['countUnit'] != '' ? json.decode(data['countUnit']) : [];
    });
    readCount();
    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    read();

    _refreshController.refreshCompleted();
  }

  Future<dynamic> readCount() async {
    final result = await postObjectData(
      'm/Reporter/count',
      {'organization': _dataOrganization},
    );

    if (result['status'] == 'S') {
      setState(() {
        countReporter = result['objectData']['reporter'];
      });
    }
  }

  void goBack() async {
    Navigator.pop(context, false);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => Menu()),
    // );
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(
    //     builder: (context) => Menu(),
    //   ),
    //   (Route<dynamic> route) => false,
    // );
  }

  void _handleHistory() async {
    var value = await storage.read(key: 'dataUserLoginDDPM');
    var user = json.decode(value!);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReporterHistoryList(
          title: 'ประวัติการแจ้งข่าว',
          username: user['username'],
        ),
      ),
    );
  }

  void _handleMap() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReporterMap(
          title: 'แผนที่ข่าว',
        ),
      ),
    );
  }

  void _handleReport() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReporterListCategory(
          title: 'แจ้งเหตุ / แจ้งข่าว',
        ),
      ),
    );
  }

  void _handleReportDisasterHistory() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReporterListCategoryDisaster(
          title: 'เหตุสาธารณภัย',
          key: null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: header(
        context,
        goBack,
        title: widget.title, rightButton: null,
        // isButtonRight: true,
        // rightButton: () => _handleClickMe(),
        // menu: 'reporter',
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: WaterDropHeader(
            complete: Container(
              child: Text(''),
            ),
            completeDuration: Duration(milliseconds: 0),
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: [
              Container(
                margin: EdgeInsets.all(10.0),
                child: Text(
                  'รายงานสาธารณภัย',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 25,
                    fontFamily: 'Sarabun',
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  for (var i = 0; i < _dataOrganization.length; i++)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "- " +
                                _dataOrganization[i]['titleLv0'].toString() +
                                " " +
                                _dataOrganization[i]['titleLv1'].toString() +
                                " " +
                                _dataOrganization[i]['titleLv2'].toString() +
                                " " +
                                _dataOrganization[i]['titleLv3'].toString() +
                                " " +
                                _dataOrganization[i]['titleLv4'].toString(),
                            // " " +
                            // _dataOrganization[i]['titleLv5'].toString() ?? '',
                            style: TextStyle(
                              fontSize: 13.00,
                              fontFamily: 'Sarabun',
                              color: Color(
                                0xFF000070,
                              ),
                            ),
                            maxLines: 5,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              InkWell(
                onTap: () {
                  _handleReportDisasterHistory();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                              'assets/background/reporter_total.png',
                            ),
                          ),
                        ),
                        height: 150.0,
                      ),
                      Container(
                        height: 150.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(
                              'assets/background/background_reporter_main.png',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 100.0,
                          left: 10.0,
                        ),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          countReporter,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 25,
                            fontFamily: 'Sarabun',
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 125.0,
                          left: 10.0,
                        ),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'เหตุสาธารณภัย',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            fontFamily: 'Sarabun',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        _handleReport();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3.3,
                        // margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                    'assets/background/reporter_news.png',
                                  ),
                                ),
                              ),
                              height: 200.0,
                            ),
                            Container(
                              height: 200.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                    'assets/background/background_reporter.png',
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 160.0,
                                left: 5.0,
                              ),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'แจ้งข่าว / แจ้งเหตุ',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontFamily: 'Sarabun',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 175.0,
                                left: 5.0,
                              ),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'เหตุสาธารณภัย',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 8,
                                  fontFamily: 'Sarabun',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _handleMap();
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        width: MediaQuery.of(context).size.width / 3.3,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                    'assets/background/reporter_map.png',
                                  ),
                                ),
                              ),
                              height: 200.0,
                            ),
                            Container(
                              height: 200.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                    'assets/background/background_reporter.png',
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 160.0,
                                left: 5.0,
                              ),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'แผนที่ข่าว',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontFamily: 'Sarabun',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 175.0,
                                left: 5.0,
                              ),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'เหตุสาธารณภัย',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 8,
                                  fontFamily: 'Sarabun',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _handleHistory();
                      },
                      child: Container(
                        // margin: EdgeInsets.symmetric(horizontal: 10.0),
                        width: MediaQuery.of(context).size.width / 3.3,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                    'assets/background/reporter_history.png',
                                  ),
                                ),
                              ),
                              height: 200.0,
                            ),
                            Container(
                              height: 200.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                    'assets/background/background_reporter.png',
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 160.0,
                                left: 5.0,
                              ),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'ประวัติการแจ้งข่าว',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                  fontFamily: 'Sarabun',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: 175.0,
                                left: 5.0,
                              ),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'เหตุสาธารณภัย',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 8,
                                  fontFamily: 'Sarabun',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
