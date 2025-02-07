import 'package:security_2025_mobile_v3/pages/traffic_ticket_detail.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:security_2025_mobile_v3/shared/extension.dart';
import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TrafficTicketTMP extends StatefulWidget {
  @override
  _TrafficTicketTMPPageState createState() => _TrafficTicketTMPPageState();
}

class _TrafficTicketTMPPageState extends State<TrafficTicketTMP> {
  late Future<dynamic> futureModel;
  dynamic tempData;
  var categoryList = dynamic;

  int _limit = 10;
  int selectedCategory = 0;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    _read();
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
        title: 'ใบสั่งค้างชำระ (PTM)',
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
      future: futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return _screen(snapshot.data, snapshot.data.length);
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  _screen(dynamic model, int totalData) {
    return Column(
      children: [
        Container(
          color: Color(0xFFEDF0F3),
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ทั้งหมด',
                style: TextStyle(
                  fontFamily: 'Sarabun',
                  fontSize: 15,
                ),
              ),
              Text(
                totalData.toString() + ' รายการ',
                style: TextStyle(
                  fontFamily: 'Sarabun',
                  fontSize: 15,
                  color: Color(0xFFB1B1B1),
                ),
              ),
            ],
          ),
        ),
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
              cardID: model['card_ID'],
              ticketID: model['ticket_ID'],
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'วันที่กระทำความผิด',
                      style: TextStyle(
                        fontFamily: 'Sarabun',
                        fontSize: 13,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                    Text(
                      dateStringToDate(model['occur_DT']),
                      style: TextStyle(
                        fontFamily: 'Sarabun',
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
              ],
            ),
            _line(),
            _textRowExpanded(
              title: 'สถานที่เกิดเหตุ',
              value: model['place'],
              titleColor: Color(0xFF9E9E9E),
              spaceBetween: 60,
            ),
            _textRowExpanded(
              title: 'เลขที่ใบสั่ง',
              value: model['org_CODE'],
              titleColor: Color(0xFF9E9E9E),
              spaceBetween: 60,
            ),
            _textRowExpanded(
              title: 'หน่วยงานที่ออกใบสั่ง',
              value: model['org_ABBR'],
              titleColor: Color(0xFF9E9E9E),
              spaceBetween: 60,
            ),
            _line(),
            _textRowExpanded(
              title: 'ข้อหา',
              value: 'ค่าปรับ(บาท)',
              titleColor: Color(0xFF9E9E9E),
              valueColor: Color(0xFF9E9E9E),
            ),
            if (model['accuse1_CODE'] != null)
              _textRowExpanded(
                title: model['accuse1_CODE'],
                value: model['fine1'],
                valueColor: Color(0xFFFF7B06),
                expandedRight: false,
                spaceBetween: 60,
              ),
            if (model['accuse2_CODE'] != null)
              _textRowExpanded(
                title: model['accuse2_CODE'],
                value: model['fine2'],
                valueColor: Color(0xFFFF7B06),
                expandedRight: false,
                spaceBetween: 60,
              ),
            if (model['accuse3_CODE'] != null)
              _textRowExpanded(
                title: model['accuse3_CODE'],
                value: model['fine3'],
                valueColor: Color(0xFFFF7B06),
                expandedRight: false,
                spaceBetween: 60,
              ),
            if (model['accuse4_CODE'] != null)
              _textRowExpanded(
                title: model['accuse4_CODE'],
                value: model['fine4'],
                valueColor: Color(0xFFFF7B06),
                expandedRight: false,
                spaceBetween: 60,
              ),
            if (model['accuse5_CODE'] != null)
              _textRowExpanded(
                title: model['accuse5_CODE'],
                value: model['fine5'],
                valueColor: Color(0xFFFF7B06),
                expandedRight: false,
                spaceBetween: 60,
              ),
            _line(),
            _textRowExpanded(
              title: 'ค่าปรับทั้งหมด',
              value: model['fine_AMT'],
              valueColor: Color(0xFFFF7B06),
              valueSize: 20,
            ),
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

  _textRowExpanded({
    String title = '',
    String value = '',
    Color titleColor = Colors.black,
    Color valueColor = Colors.black,
    double valueSize = 13,
    bool expandedRight = true,
    double spaceBetween = 15,
  }) {
    return title != ''
        ? Container(
            margin: EdgeInsets.only(bottom: 8),
            child: expandedRight
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Sarabun',
                          fontSize: 13,
                          color: titleColor,
                        ),
                      ),
                      SizedBox(width: spaceBetween),
                      Expanded(
                        child: Text(
                          value,
                          style: TextStyle(
                            fontFamily: 'Sarabun',
                            fontSize: valueSize,
                            color: valueColor,
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontFamily: 'Sarabun',
                            fontSize: 13,
                            color: titleColor,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(width: spaceBetween),
                      Text(
                        value,
                        style: TextStyle(
                          fontFamily: 'Sarabun',
                          fontSize: valueSize,
                          color: valueColor,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
          )
        : Container();
  }

  // function
  _read() async {
    // getNotpaidTicketListApi
    futureModel = postDio(getNotpaidTicketListApi, {
      "createBy": "createBy",
      "updateBy": "updateBy",
      "card_id": "",
      "plate1": "3กท",
      "plate2": "9771",
      "plate3": "00100",
      "ticket_id": ""
    });
  }

  _onLoading() async {
    setState(() {
      _limit = _limit + 10;
    });
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
