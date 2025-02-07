import 'package:security_2025_mobile_v3/home_v2.dart';
import 'package:security_2025_mobile_v3/pages/warning/warning_form.dart';
import 'package:security_2025_mobile_v3/pages/welfare/welfare_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:security_2025_mobile_v3/pages/blank_page/blank_loading.dart';
import 'package:security_2025_mobile_v3/pages/blank_page/toast_fail.dart';
import 'package:security_2025_mobile_v3/pages/event_calendar/event_calendar_form.dart';
import 'package:security_2025_mobile_v3/pages/knowledge/knowledge_form.dart';
import 'package:security_2025_mobile_v3/pages/news/news_form.dart';
import 'package:security_2025_mobile_v3/pages/poi/poi_form.dart';
import 'package:security_2025_mobile_v3/pages/poll/poll_form.dart';
import 'package:security_2025_mobile_v3/pages/privilege/privilege_form.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:security_2025_mobile_v3/shared/extension.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotificationList extends StatefulWidget {
  NotificationList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _NotificationList createState() => _NotificationList();
}

class _NotificationList extends State<NotificationList> {
  late Future<dynamic> _futureModel;

  @override
  void initState() {
    super.initState();

    setState(() {
      _futureModel = postDio(
        '${notificationApi}read',
        {'skip': 0, 'limit': 999},
      );
    });
  }

  checkNavigationPage(String page, dynamic model) {
    switch (page) {
      case 'newsPage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsForm(
                url: newsApi + 'read',
                code: model['reference'],
                model: model,
                urlComment: newsCommentApi,
                urlGallery: newsGalleryApi,
              ),
            ),
          ).then((value) => {
                setState(() {
                  _futureModel =
                      postDio('${notificationApi}read', {'limit': 999});
                })
              });
        }
        break;

      case 'eventPage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventCalendarForm(
                url: eventCalendarApi + 'read',
                code: model['reference'],
                model: model,
                urlComment: eventCalendarCommentApi,
                urlGallery: eventCalendarGalleryApi,
              ),
            ),
          ).then((value) => {
                setState(() {
                  _futureModel = postDio(
                      '${notificationApi}read', {'skip': 0, 'limit': 999});
                })
              });
        }
        break;

      case 'privilegePage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrivilegeForm(
                code: model['reference'],
                model: model,
              ),
            ),
          ).then((value) => {
                setState(() {
                  _futureModel = postDio(
                      '${notificationApi}read', {'skip': 0, 'limit': 999});
                })
              });
        }
        break;

      case 'knowledgePage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KnowledgeForm(
                code: model['reference'],
                model: model,
                urlComment: '',
              ),
            ),
          ).then((value) => {
                setState(() {
                  _futureModel = postDio(
                      '${notificationApi}read', {'skip': 0, 'limit': 999});
                })
              });
        }
        break;

      case 'poiPage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PoiForm(
                url: poiApi + 'read',
                code: model['reference'],
                model: model,
                urlComment: poiCommentApi,
                urlGallery: poiGalleryApi,
              ),
            ),
          ).then((value) => {
                setState(() {
                  _futureModel = postDio(
                      '${notificationApi}read', {'skip': 0, 'limit': 999});
                })
              });
        }
        break;

      case 'pollPage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PollForm(
                code: model['reference'],
                model: model,
                url: '',
                titleMenu: '',
                titleHome: '',
              ),
            ),
          ).then((value) => {
                setState(() {
                  _futureModel = postDio(
                      '${notificationApi}read', {'skip': 0, 'limit': 999});
                })
              });
        }
        break;

      case 'warningPage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WarningForm(
                code: model['reference'],
                model: model,
                url: '',
                urlComment: '',
                urlGallery: '',
              ),
            ),
          ).then((value) => {
                setState(() {
                  _futureModel = postDio(
                      '${notificationApi}read', {'skip': 0, 'limit': 999});
                })
              });
        }
        break;

      case 'welfarePage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WelfareForm(
                code: model['reference'],
                model: model,
                url: '',
                urlComment: '',
                urlGallery: '',
              ),
            ),
          ).then((value) => {
                setState(() {
                  _futureModel = postDio(
                      '${notificationApi}read', {'skip': 0, 'limit': 999});
                })
              });
        }
        break;

      case 'mainPage':
        {
          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePageV2(),
            ),
          ).then((value) => {
                setState(() {
                  _futureModel = postDio(
                      '${notificationApi}read', {'skip': 0, 'limit': 999});
                })
              });
        }
        break;

      default:
        {
          return toastFail(context, text: 'เกิดข้อผิดพลาด');
        }
        break;
    }
  }

  void goBack() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: header(
        context,
        () => goBack(),
        title: widget.title,
        isButtonLeft: false,
        isButtonRight: true,
        rightButton: () => _handleClickMe(),
        imageRightButton: 'assets/images/task_list.png',
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<dynamic>(
        future: _futureModel, // function where you call your api
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            // print('snapshot.data.length' + snapshot.data.length);
            if (snapshot.data.length > 0) {
              return ListView.builder(
                shrinkWrap: true, // 1st add
                physics: ClampingScrollPhysics(), // 2nd
                // scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return card(context, snapshot.data[index]);
                },
              );
            } else {
              return Container(
                width: width,
                margin: EdgeInsets.only(top: height * 30 / 100),
                child: Column(
                  children: [
                    Container(
                      height: 70,
                      width: width,
                      child: Image.asset(
                        'assets/logo/logo.png',
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 1 / 100),
                      alignment: Alignment.center,
                      width: width,
                      child: Text(
                        'ไม่พบข้อมูล',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Sarabun',
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          } else if (snapshot.hasError) {
            print('error-----');
            return Container(
              width: width,
              height: height,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _futureModel = postDio(
                        '${notificationApi}read', {'skip': 0, 'limit': 999});
                  });
                },
                child: Icon(Icons.refresh, size: 50.0, color: Colors.blue),
              ),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true, // 1st add
              physics: ClampingScrollPhysics(), // 2nd
              // scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return BlankLoading(
                  width: width,
                  height: height * 15 / 100,
                );
              },
            );
          }
        },
      ),
    );
  }

  card(BuildContext context, dynamic model) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () => {
        postAny('${notificationApi}update', {
          'category': '${model['category']}',
          "code": '${model['code']}'
        }).then((response) {
          if (response == 'S') {
            checkNavigationPage(model['category'], model);
          }
        })
      },
      child: Slidable(
        // fixflutter2 actionPane: SlidableDrawerActionPane(),
        // fixflutter2 actionExtentRatio: 0.25,

        child: Container(
          margin: EdgeInsets.symmetric(vertical: height * 0.2 / 100),
          height: (height * 15) / 100,
          width: width,
          decoration: BoxDecoration(
            color: model['status'] == 'A' ? Colors.white : Color(0xFFE7E7EE),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 1 / 100, vertical: height * 1.2 / 100),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: height * 0.7 / 100, right: width * 1 / 100),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(height * 1 / 100),
                        color:
                            model['status'] == 'A' ? Colors.white : Colors.red,
                      ),
                      height: height * 2 / 100,
                      width: height * 2 / 100,
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          '${model['title']}',
                          style: TextStyle(
                            fontSize: (height * 2) / 100,
                            fontFamily: 'Sarabun',
                            fontWeight: FontWeight.normal,
                            color: Color(0xFFFF7514),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 5 / 100, vertical: height * 1.5 / 100),
                child: Text(
                  '${dateStringToDate(model['createDate'])}',
                  style: TextStyle(
                    fontSize: (height * 1.7) / 100,
                    fontFamily: 'Sarabun',
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        // fixflutter2 secondaryActions: <Widget>[
        //   IconSlideAction(
        //     caption: 'Delete',
        //     color: Colors.red,
        //     icon: Icons.delete,
        //     onTap: () => {
        //       setState(() {
        //         postAny('${notificationApi}delete', {
        //           'category': '${model['category']}',
        //           "code": '${model['code']}'
        //         }).then((response) {
        //           if (response == 'S') {
        //             setState(() {
        //               _futureModel = postDio(
        //                   '${notificationApi}read', {'skip': 0, 'limit': 999});
        //             });
        //           }
        //         });
        //       })
        //     },
        //   ),
        // ],
      ),
    );
  }

  Future<void> _handleClickMe() async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          // title: Text('ตัวเลือก'),
          // message: Text(''),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(
                'อ่านทั้งหมด',
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Sarabun',
                  fontWeight: FontWeight.normal,
                  color: Colors.lightBlue,
                ),
              ),
              onPressed: () {
                setState(() {
                  postAny('${notificationApi}update', {}).then((response) {
                    if (response == 'S') {
                      setState(() {
                        _futureModel = postDio('${notificationApi}read',
                            {'skip': 0, 'limit': 999});
                      });
                    }
                  });
                });
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                'ลบทั้งหมด',
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Sarabun',
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                setState(() {
                  postAny('${notificationApi}delete', {}).then((response) {
                    if (response == 'S') {
                      setState(() {
                        _futureModel = postDio('${notificationApi}read',
                            {'skip': 0, 'limit': 999});
                      });
                    }
                  });
                });
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: Text('ยกเลิก',
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Sarabun',
                  fontWeight: FontWeight.normal,
                  color: Colors.lightBlue,
                )),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
