import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/key_search.dart';
import 'package:security_2025_mobile_v3/pages/event_calendar/event_calendar_list_vertical.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EventCalendarList extends StatefulWidget {
  EventCalendarList({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _EventCalendarList createState() => _EventCalendarList();
}

class _EventCalendarList extends State<EventCalendarList> {
  late EventCalendarList eventCalendarList;
  late EventCalendarListVertical gridView;

  bool hideSearch = true;
  List<dynamic> listData = [];
  List<dynamic> category = [];
  bool isMain = true;
  String categorySelected = '';
  String keySearch = '';
  bool isHighlight = false;
  int _limit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    // _futureEventCalendarCategory =
    //     post('${eventCalendarCategoryApi}read', {'skip': 0, 'limit': 100});
    _read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: header(context, goBack, title: widget.title),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
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
            child: ListView(
              children: [
                SizedBox(
                  height: 5.0,
                ),
                _buildCategory(),
                SizedBox(
                  height: 10.0,
                ),
                KeySearch(
                  show: hideSearch,
                  onKeySearchChange: (String val) {
                    setState(() {
                      keySearch = val;
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                _buildList(),
                SizedBox(
                  height: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _read() async {
    var body = json.encode({
      "permission": "all",
      "skip": 0,
      "limit": 999 // integer value type
    });
    var response = await http.post(Uri.parse(eventCalendarCategoryApi + 'read'),
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        });

    var data = json.decode(response.body);
    setState(() {
      category = data['objectData'];
    });

    if (category.length > 0) {
      for (int i = 0; i <= category.length - 1; i++) {
        var res = post('${eventCalendarApi}read', {
          'skip': 0,
          'limit': 100,
          'category': category[i]['code'],
          'keySearch': keySearch
        });
        listData.add(res);
      }
    }
  }

  _buildList() {
    return gridView = new EventCalendarListVertical(
      site: 'DDPM',
      // model: post('${eventCalendarApi}read', {
      //   'skip': 0,
      //   'limit': _limit,
      //   'keySearch': keySearch,
      //   'isHighlight': isHighlight,
      //   'category': categorySelected
      // }),
      urlGallery: eventCalendarGalleryApi,
      urlComment: eventCalendarCommentApi,
      url: '${eventCalendarApi}read',
      title: '',
    );
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      gridView = EventCalendarListVertical(
        site: 'CIO',
        // model: post('${eventCalendarApi}read', {
        //   'skip': 0,
        //   'limit': _limit,
        //   'keySearch': keySearch != null ? keySearch : '',
        //   'isHighlight': isHighlight != null ? isHighlight : false,
        //   'category': categorySelected != null ? categorySelected : ''
        // }),
        urlGallery: eventCalendarGalleryApi,
        urlComment: eventCalendarCommentApi,
        url: '${eventCalendarApi}read',
        title: '',
      );
    });

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  _buildCategory() {
    return FutureBuilder<dynamic>(
      future: postCategory(
        '${eventCalendarCategoryApi}read',
        {'skip': 0, 'limit': 100},
      ), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>

        if (snapshot.hasData) {
          return Container(
            height: 45.0,
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: new BorderRadius.circular(6.0),
              color: Colors.white,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    if (snapshot.data[index]['code'] != '') {
                      setState(() {
                        // keySearch = '';
                        // isMain = false;
                        categorySelected = snapshot.data[index]['code'];
                      });
                    } else {
                      setState(() {
                        // isHighlight = true;
                        categorySelected = '';
                        isMain = true;
                      });
                    }
                    setState(() {
                      categorySelected = snapshot.data[index]['code'];
                      // selectedIndex = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: categorySelected == snapshot.data[index]['code']
                          ? Border(
                              bottom: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor))
                          : null,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 10.0,
                    ),
                    child: Text(
                      snapshot.data[index]['title'],
                      style: TextStyle(
                        color: categorySelected == snapshot.data[index]['code']
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        // decoration:
                        //     categorySelected == snapshot.data[index]['code']
                        //         ? TextDecoration.underline
                        //         : null,
                        fontSize:
                            categorySelected == snapshot.data[index]['code']
                                ? 15.0
                                : 13.0,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1.2,
                        fontFamily: 'Sarabun',
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Container(
            height: 45.0,
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            margin: EdgeInsets.symmetric(horizontal: 30.0),
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: new BorderRadius.circular(6.0),
              color: Colors.white,
            ),
          );
        }
      },
    );
  }
}
