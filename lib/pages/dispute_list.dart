import 'package:security_2025_mobile_v3/pages/traffic_ticket_detail.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DisputeList extends StatefulWidget {
  DisputeList({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _DisputeListPageState createState() => _DisputeListPageState();
}

class _DisputeListPageState extends State<DisputeList> {
  final storage = new FlutterSecureStorage();
  late Future<dynamic> _futureModel;
  dynamic tempData;
  String profileCode = "";
  String idcard = "";

  int _limit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    _onLoading();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        () {
          Navigator.pop(context);
        },
        title: widget.title,
        rightButton: null,
      ),
      backgroundColor: Color(0xFFF5F8FB),
      body: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        // child: _screen(tempData),
        child: _futureBuilder(),
      ),
    );
  }

  _futureBuilder() {
    return FutureBuilder<dynamic>(
      future: _futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return _screen(snapshot.data['tickets']);
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  _screen(dynamic model) {
    return Column(
      children: [
        SizedBox(height: 10),
        Expanded(
          child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            footer: ClassicFooter(
              loadingText: ' ',
              canLoadingText: ' ',
              idleText: ' ',
              idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
            ),
            controller: _refreshController,
            onLoading: _onLoading,
            onRefresh: _onRefresh,
            child: ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: model.length,
              itemBuilder: (context, index) {
                return _item(model[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  _item(dynamic model) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrafficTicketDetail(
              cardID: model['citizenID'],
              ticketID: model['ticketNo'],
            ),
          ),
        );
      },
      child: Container(
        width: 350,
        margin: EdgeInsets.only(bottom: 10, left: 15, right: 15),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 0,
              blurRadius: 4,
              offset: Offset(1, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _textRow(
              title: 'วันที่กระทำความผิด',
              value: model['dateHappen'],
              titleColor: Color(0xFF9E9E9E),
            ),
            SizedBox(height: 8),
            _textRow(
              title: 'สถานที่เกิดเหตุ',
              value: model['place'],
              titleColor: Color(0xFF9E9E9E),
            ),
            SizedBox(height: 8),
            _textRow(
              title: 'เลขที่ใบสั่ง',
              value: model['ticketNo'],
              titleColor: Color(0xFF9E9E9E),
            ),
            SizedBox(height: 8),
            _textRow(
              title: 'หน่วยงานที่ออกใบสั่ง',
              value: model['orgNameTicket'],
              titleColor: Color(0xFF9E9E9E),
            ),
            SizedBox(height: 8),
            _line(),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xFF6F267B),
              ),
              child: Column(
                children: [
                  _textRow(
                    title: 'ข้อหา',
                    value: 'ค่าปรับ(บาท)',
                    titleColor: Colors.white,
                    valueColor: Colors.white,
                  ),
                  SizedBox(height: 8),
                  _textRow(
                    title: model['accuse1_CODE'],
                    value: model['fine1'],
                    titleColor: Colors.white,
                    valueColor: Colors.white,
                  ),
                  model['accuse2_CODE'] != null
                      ? SizedBox(height: 8)
                      : SizedBox(height: 0),
                  model['accuse2_CODE'] != null
                      ? _textRow(
                          title: model['accuse2_CODE'],
                          value: model['fine2'],
                          titleColor: Colors.white,
                          valueColor: Colors.white,
                        )
                      : Container(),
                  model['accuse3_CODE'] != null
                      ? SizedBox(height: 8)
                      : SizedBox(height: 0),
                  model['accuse3_CODE'] != null
                      ? _textRow(
                          title: model['accuse3_CODE'],
                          value: model['fine3'],
                          titleColor: Colors.white,
                          valueColor: Colors.white,
                        )
                      : Container(),
                  model['accuse4_CODE'] != null
                      ? SizedBox(height: 8)
                      : SizedBox(height: 0),
                  model['accuse4_CODE'] != null
                      ? _textRow(
                          title: model['accuse4_CODE'],
                          value: model['fine4'],
                          titleColor: Colors.white,
                          valueColor: Colors.white,
                        )
                      : Container(),
                  model['accuse5_CODE'] != null
                      ? SizedBox(height: 8)
                      : SizedBox(height: 0),
                  model['accuse5_CODE'] != null
                      ? _textRow(
                          title: model['accuse5_CODE'],
                          value: model['fine5'],
                          titleColor: Colors.white,
                          valueColor: Colors.white,
                        )
                      : Container(),
                  SizedBox(height: 10),
                  _line(),
                  _textRow(
                    title: 'ค่าปรับทั้งหมด',
                    value: model['ticketFine'],
                    titleColor: Colors.white,
                    valueColor: Colors.white,
                    valueSize: 25,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _line() {
    return Container(
      height: 2,
      margin: EdgeInsets.symmetric(vertical: 10),
      color: Color(0xFFEDF0F3),
    );
  }

  _textRow({
    String title = '',
    String value = '',
    Color titleColor = Colors.black,
    Color valueColor = Colors.black,
    double valueSize = 13,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Sarabun',
              fontSize: 13,
              color: titleColor,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontFamily: 'Sarabun',
              fontSize: valueSize,
              color: valueColor,
            ),
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }

  // function
  _read() async {
    // mock data
    // setState(() {
    //   tempData = [];
    //   for (var i = 1; i < _limit; i++) {
    //     setState(() {
    //       tempData.add({'title': i.toString()});
    //     });
    //   }
    // });

    profileCode = (await storage.read(key: 'profileCode3'))!;
    idcard = (await storage.read(key: 'idcard'))!;

    if (profileCode != '')
      setState(() {
        _futureModel = postDio('${serverMW}tickerDispute/searchTickerDispute', {
          "code": profileCode,
          "citizen": idcard,
          "createBy": profileCode,
          "updateBy": profileCode,
        });
      });
  }

  _onLoading() async {
    // setState(() {
    //   _limit = _limit + 2;
    // });
    _read();

    await Future.delayed(Duration(milliseconds: 2000));

    _refreshController.loadComplete();
  }

  void _onRefresh() async {
    // getCurrentUserData();
    // _getLocation();
    _read();

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    // _refreshController.loadComplete();
  }
}
