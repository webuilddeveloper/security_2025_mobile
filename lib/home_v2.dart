import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:security_2025_mobile_v3/component/carousel_rotation.dart';
import 'package:security_2025_mobile_v3/component/material/check_avatar.dart';
import 'package:security_2025_mobile_v3/component/menu/build_verify_ticket.dart';
import 'package:security_2025_mobile_v3/component/menu/color_item.dart';
import 'package:security_2025_mobile_v3/component/menu/image_item.dart';
import 'package:security_2025_mobile_v3/component/v2/button_menu_full.dart';
import 'package:security_2025_mobile_v3/login.dart';
import 'package:security_2025_mobile_v3/pages/blank_page/blank_loading.dart';
import 'package:security_2025_mobile_v3/pages/blank_page/toast_fail.dart';
import 'package:security_2025_mobile_v3/pages/dispute_an_allegation.dart';
import 'package:security_2025_mobile_v3/pages/privilegeSpecial/privilege_special_list.dart';
import 'package:security_2025_mobile_v3/pages/reporter/reporter_main.dart';
import 'package:security_2025_mobile_v3/pages/warning/warning_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:security_2025_mobile_v3/component/carousel_banner.dart';
import 'package:security_2025_mobile_v3/pages/about_us/about_us_form.dart';
import 'package:security_2025_mobile_v3/pages/menu_grid_item.dart';
import 'package:security_2025_mobile_v3/pages/notification/notification_list.dart';
import 'package:security_2025_mobile_v3/pages/poi/poi_list.dart';
import 'package:security_2025_mobile_v3/pages/poll/poll_list.dart';
import 'package:security_2025_mobile_v3/pages/welfare/welfare_list.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:security_2025_mobile_v3/profile.dart';
import 'package:security_2025_mobile_v3/pages/contact/contact_list_category.dart';
import 'package:security_2025_mobile_v3/pages/news/news_list.dart';
import 'package:security_2025_mobile_v3/pages/privilege/privilege_main.dart';
import 'package:security_2025_mobile_v3/pages/profile/user_information.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:security_2025_mobile_v3/component/carousel_form.dart';
import 'pages/event_calendar/event_calendar_main.dart';
import 'pages/knowledge/knowledge_list.dart';
import 'pages/main_popup/dialog_main_popup.dart';

class HomePageV2 extends StatefulWidget {
  @override
  _HomePageV2State createState() => _HomePageV2State();
}

class _HomePageV2State extends State<HomePageV2> {
  final storage = new FlutterSecureStorage();
  late DateTime currentBackPressTime;

  late Future<dynamic> _futureBanner;
  late Future<dynamic> _futureProfile;
  late Future<dynamic> _futureMenu;
  late Future<dynamic> _futureRotation;
  late Future<dynamic> _futureAboutUs;
  late Future<dynamic> _futureMainPopUp;
  late Future<dynamic> _futureVerifyTicket;

  String profileCode = '';
  String currentLocation = '-';
  final seen = Set<String>();
  List unique = [];
  List imageLv0 = [];
  String test11 = '2';
  bool chkisCard = false;
  bool notShowOnDay = false;
  bool hiddenMainPopUp = false;
  bool checkDirection = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  LatLng latLng = LatLng(13.743989326935178, 100.53754006134743);

  @override
  void initState() {
    _read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildHeader(),
      body: WillPopScope(child: _buildBackground(), onWillPop: confirmExit),
    );
  }

  Future<bool> confirmExit() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      toastFail(
        context,
        text: 'กดอีกครั้งเพื่อออก',
        color: Colors.black,
        fontColor: Colors.white,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  _buildBackground() {
    return Container(
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     colors: [
      //       Color(0xFFFF7900),
      //       Color(0xFFFF7900),
      //       Color(0xFFFFFFFF),
      //     ],
      //     begin: Alignment.topCenter,
      //     // end: new Alignment(1, 0.0),
      //     end: Alignment.bottomCenter,
      //   ),
      // ),
      child: _buildNotificationListener(),
    );
  }

  _buildNotificationListener() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overScroll) {
        overScroll.disallowIndicator();
        return false;
      },
      child: _buildSmartRefresher(),
    );
  }

  _buildSmartRefresher() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      header: WaterDropHeader(
        complete: Container(
          child: Text(''),
        ),
        completeDuration: Duration(milliseconds: 0),
      ),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("pull up load");
          } else if (mode == LoadStatus.loading) {
            body = Text("loading");
          } else if (mode == LoadStatus.failed) {
            body = Text("Load Failed!Click retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("release to load more");
          } else {
            body = Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: _buildMenu(),

      // Column(
      //   children: [
      //     // Container(
      //     //   height: (height * 25) / 100,
      //     //   child:

      //     SizedBox(
      //       height: 1.0,
      //     ),

      //     SizedBox(
      //       height: 1.0,
      //     ),

      // Container(
      //   height: 70.0,
      //   child: CardHorizontal(
      //     title: model[11]['title'] != '' ? model[11]['title'] : '',
      //     imageUrl: model[11]['imageUrl'],
      //     model: _futureMenu,
      //     userData: userData,
      //     subTitle: 'สำหรับสมาชิก',
      //     nav: () {
      //       // Navigator.push(
      //       //   context,
      //       //   MaterialPageRoute(
      //       //     builder: (context) => PrivilegeMain(
      //       //       title: model[11]['title'],
      //       //     ),
      //       //   ),
      //       // );
      //     },
      //   ),
      // ),
      //   ],
      // ),
      // ),
    );
  }

  _buildMenu() {
    return ListView(
      children: [
        Column(
          children: [
            _buildBanner(),
            _buildCurrentLocationBar(),
            _buildProfile(),
            _buildVerifyTicket(),
            _buildRotation(),
            SizedBox(height: 5),
            // _buildGridMenu1(),
            // SizedBox(height: 1),
            // _buildGridMenu2(),
            chkisCard == false ? _buildDispute(1) : Container(),
            SizedBox(height: 5),
            chkisCard == true ? _buildDispute(2) : Container(),
            _buildCardFirst(),
            _buildCardSecond(),
            _buildCardThird(),
            _buildRotation(),
            _buildFooter(),
          ],
        ),
      ],
    );
  }

  _buildHeader() {
    return PreferredSize(
      preferredSize: Size.fromHeight(40 + MediaQuery.of(context).padding.top),
      child: AppBar(
        flexibleSpace: Container(
          width: double.infinity,
          // height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bg_header.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.centerLeft,
                      height: 60,
                      child: Image.asset(
                        'assets/logo/bg_headlogo.png',
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationList(
                            title: 'แจ้งเตือน',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 30,
                      child: Image.asset('assets/icons/bell.png'),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      final msg = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserInformationPage(),
                        ),
                      );

                      if (!msg) {
                        _read();
                      }
                    },
                    child: FutureBuilder<dynamic>(
                      future: _futureProfile,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          if (profileCode == snapshot.data['code']) {
                            return Container(
                              height: 50,
                              padding: EdgeInsets.only(right: 10),
                              child: checkAvatar(
                                  context, '${snapshot.data['imageUrl']}'),
                            );
                          } else {
                            return Container(
                              height: 30,
                              child: Image.asset(
                                'assets/images/user_not_found.png',
                                color: Colors.white,
                              ),
                            );
                          }
                        } else if (snapshot.hasError) {
                          return BlankLoading(
                            width: null,
                            height: null,
                          );
                        } else {
                          return Container(
                            height: 30,
                            child: Image.asset(
                              'assets/images/user_not_found.png',
                              color: Colors.white,
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildDispute(int param) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DisputeAnAllegation(),
          ),
        );
      },
      child: Container(
        height: 120,
        padding: param == 1
            ? EdgeInsets.symmetric(horizontal: 25)
            : EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey,
          image: DecorationImage(
            // image: NetworkImage('${model['imageUrl']}'),
            image: AssetImage('assets/background/background_dispute.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: param == 1
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          'ยื่นอุทธรณ์ (Dispute)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0,
                            fontFamily: 'Sarabun',
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'กรมการขนส่งทางบกอำนวยความสะดวกให้ท่าน',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.0,
                            fontFamily: 'Sarabun',
                          ),
                          maxLines: 2,
                          // textAlign: TextAlign.center,
                        ),
                        // Text(
                        //   'สามารถตรวจสอบใบสั่งย้อนหลังได้สูงสุด 1 ปี',
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 13.0,
                        //     fontFamily: 'Sarabun',
                        //   ),
                        //   maxLines: 2,
                        //   textAlign: TextAlign.center,
                        // )
                      ],
                    ),
                  )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            text: 'ยื่นอุทธรณ์',
                            style: TextStyle(
                              color: Color(0xFF4E2B68),
                              fontSize: 20.0,
                              fontFamily: 'Sarabun',
                              fontWeight: FontWeight.bold,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '(Dispute)',
                                style: TextStyle(
                                  color: Color(0xFF4E2B68),
                                  fontSize: 13.0,
                                  fontFamily: 'Sarabun',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'กรมการขนส่งทางบกอำนวยความสะดวกให้ท่าน',
                          style: TextStyle(
                            color: Color(0xFF4E2B68),
                            fontSize: 13.0,
                            fontFamily: 'Sarabun',
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  _buildCardFirst() {
    return Container(
      height: 125,
      color: Colors.white,
      child: Row(
        children: [
          imageItem('', '', 'assets/background/news_background.png', 2,
              titleStart: true, callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsList(
                  title: 'ข่าวประชาสัมพันธ์',
                ),
              ),
            );
          }),
          colorItem(
              'สิทธิพิเศษ', '(Gift)', 'assets/icons/Icon_privileage.png', 1,
              callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrivilegeSpecialList(
                  title: 'สิทธิพิเศษ',
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  _buildCardSecond() {
    return Container(
      height: 125,
      color: Colors.white,
      child: Row(
        children: [
          colorItem('ปฏิทินกิจกรรม', '(Calendar)',
              'assets/icons/icon_calendar.png', 1,
              linearGradient: LinearGradient(
                colors: [
                  Color(0xFF7847AB),
                  Color(0xFF4E2B68),
                ],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ), callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventCalendarMain(
                  title: 'ปฏิทินกิจกรรม',
                ),
              ),
            );
          }),
          imageItem('ความรู้คู่การขับขี่', '(Driving Knowledge)',
              'assets/background/info_background.png', 2, callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KnowledgeList(
                  title: 'ความรู้คู่การขับขี่',
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  _buildCardThird() {
    return Container(
      height: 125,
      color: Colors.white,
      child: Row(
        children: [
          imageItem(
            'จุดบริการ',
            '(Service Station)',
            'assets/background/service_background.png',
            1,
            callback: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PoiList(
                    title: 'จุดบริการ',
                    latLng: latLng,
                  ),
                ),
              );
            },
          ),
          imageItem(
              'เบอร์โทรฉุกเฉิน', '(SOS)', 'assets/background/hotline.png', 1,
              callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactListCategory(
                  title: 'เบอร์โทรฉุกเฉิน',
                ),
              ),
            );
          }),
          colorItem(
              'ติดต่อเรา', '(Contact us)', 'assets/images/icon_info.png', 1,
              linearGradient: LinearGradient(
                colors: [
                  Color(0xFF281F37),
                  Color(0xFF281F37),
                ],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ), callback: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AboutUsForm(
                  model: _futureAboutUs,
                  title: 'ติดต่อเรา',
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  _buildVerifyTicket() {
    return VerifyTicket(
      model: _futureVerifyTicket,
    );
  }

  _buildBanner() {
    return CarouselBanner(
      model: _futureBanner,
      nav: (String path, String action, dynamic model, String code,
          String urlGallery) {
        if (action == 'out') {
          // launchInWebViewWithJavaScript(path);
          // launchURL(path);
          launch(path);
        } else if (action == 'in') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarouselForm(
                code: code,
                model: model,
                url: mainBannerApi,
                urlGallery: bannerGalleryApi,
              ),
            ),
          );
        }
      },
    );
  }

  _buildCurrentLocationBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          // color: Color(0xFF000070),
          // padding: EdgeInsets.symmetric(horizontal: 5),
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Icon(Icons.credit_card),
              Text(
                ' ใบอนุญาตขับขี่สาธารณะ',
                style: TextStyle(
                  fontFamily: 'Sarabun',
                  // fontSize: 10,
                  // color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Container(
          // color: Color(0xFF000070),
          // padding: EdgeInsets.symmetric(horizontal: 5),
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: 10),
          height: 40,
          child: Row(
            children: [
              Icon(
                Icons.pin_drop,
                color: Colors.orange[400],
              ),
              Text(
                // ' ' + currentLocation,
                'กรุงเทพมหานคร',
                style: TextStyle(
                  fontFamily: 'Sarabun', color: Colors.orange[400],
                  // fontSize: 10,
                  // color: Colors.white,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  _buildProfile() {
    return Profile(
      model: _futureProfile,
    );
  }

  _buildGridMenu1() {
    return FutureBuilder<dynamic>(
      future: _futureMenu, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: [
              MenuGridItem(
                title: snapshot.data[0]['title'],
                imageUrl: snapshot.data[0]['imageUrl'],
                isCenter: false,
                isPrimaryColor: true,
                nav: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventCalendarMain(
                        title: snapshot.data[0]['title'],
                      ),
                    ),
                  );
                  // if (checkDirection) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => EventCalendarMain(
                  //         title: snapshot.data[0]['title'],
                  //       ),
                  //     ),
                  //   );
                  // } else {
                  //   _showDialogDirection();
                  // }
                },
              ),
              MenuGridItem(
                title: snapshot.data[1]['title'] != ''
                    ? snapshot.data[1]['title']
                    : '',
                imageUrl: snapshot.data[1]['imageUrl'],
                subTitle: '',
                isCenter: true,
                isPrimaryColor: true,
                nav: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KnowledgeList(
                        title: snapshot.data[1]['title'],
                      ),
                    ),
                  );
                  // if (checkDirection) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => KnowledgeList(
                  //         title: snapshot.data[1]['title'],
                  //       ),
                  //     ),
                  //   );
                  // } else {
                  //   _showDialogDirection();
                  // }
                },
              ),
              MenuGridItem(
                title: snapshot.data[2]['title'] != ''
                    ? snapshot.data[2]['title']
                    : '',
                imageUrl: snapshot.data[2]['imageUrl'],
                subTitle: '',
                isCenter: false,
                isPrimaryColor: true,
                nav: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReporterMain(
                        title: snapshot.data[2]['title'],
                      ),
                    ),
                  );
                  // if (checkDirection) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => ReporterMain(
                  //         title: snapshot.data[2]['title'],
                  //       ),
                  //     ),
                  //   );
                  // } else {
                  //   _showDialogDirection();
                  // }
                },
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  _buildGridMenu2() {
    return FutureBuilder<dynamic>(
      future: _futureMenu, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: [
              MenuGridItem(
                title: snapshot.data[3]['title'] != ''
                    ? snapshot.data[3]['title']
                    : '',
                imageUrl: snapshot.data[3]['imageUrl'],
                subTitle: '',
                isCenter: false,
                isPrimaryColor: true,
                nav: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WarningList(
                        title: snapshot.data[3]['title'],
                      ),
                    ),
                  );
                  // if (checkDirection) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => WarningList(
                  //         title: snapshot.data[3]['title'],
                  //       ),
                  //     ),
                  //   );
                  // } else {
                  //   _showDialogDirection();
                  // }
                },
              ),
              MenuGridItem(
                title: snapshot.data[4]['title'] != ''
                    ? snapshot.data[4]['title']
                    : '',
                imageUrl: snapshot.data[4]['imageUrl'],
                subTitle: '',
                isCenter: true,
                isPrimaryColor: true,
                nav: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelfareList(
                        title: snapshot.data[4]['title'],
                      ),
                    ),
                  );
                  // if (checkDirection) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => WelfareList(
                  //         title: snapshot.data[4]['title'],
                  //       ),
                  //     ),
                  //   );
                  // } else {
                  //   _showDialogDirection();
                  // }
                },
              ),
              MenuGridItem(
                title: snapshot.data[5]['title'] != ''
                    ? snapshot.data[5]['title']
                    : '',
                imageUrl: snapshot.data[5]['imageUrl'],
                subTitle: '',
                isCenter: false,
                isPrimaryColor: true,
                nav: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsList(
                        title: snapshot.data[5]['title'],
                      ),
                    ),
                  );
                  // if (checkDirection) {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => NewsList(
                  //         title: snapshot.data[5]['title'],
                  //       ),
                  //     ),
                  //   );
                  // } else {
                  //   _showDialogDirection();
                  // }
                },
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  _buildRotation() {
    return CarouselRotation(
      model: _futureRotation,
      nav: (String path, String action, dynamic model, String code) {
        if (action == 'out') {
          // launchInWebViewWithJavaScript(path);
          // launchURL(path);
          launch(path);
        } else if (action == 'in') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CarouselForm(
                code: code,
                model: model,
                url: mainBannerApi,
                urlGallery: bannerGalleryApi,
              ),
            ),
          );
        }
      },
    );
  }

  _buildPrivilegeMenu() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3),
      child: FutureBuilder<dynamic>(
        future: _futureMenu, // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ButtonMenuFull(
              title: snapshot.data[7]['title'] != ''
                  ? snapshot.data[7]['title']
                  : '',
              imageUrl: snapshot.data[7]['imageUrl'],
              model: _futureMenu,
              subTitle: 'สำหรับสมาชิก',
              nav: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivilegeMain(
                      title: snapshot.data[7]['title'],
                      fromPolicy: false,
                    ),
                  ),
                );
                // if (!checkDirection) {
                //   _showDialogDirection();
                // } else if (_dataPolicy.length > 0) {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => PolicyPrivilege(
                //         title: snapshot.data[4]['title'],
                //         username: userData.username,
                //         fromPolicy: true,
                //       ),
                //     ),
                //   );
                // } else {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => PrivilegeMain(
                //         title: snapshot.data[7]['title'],
                //         fromPolicy: false,
                //       ),
                //     ),
                //   );
                // }
              },
              userData: null,
            );
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _buildContactMenu() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3),
      child: FutureBuilder<dynamic>(
        future: _futureMenu, // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ButtonMenuFull(
              title: snapshot.data[6]['title'] != ''
                  ? snapshot.data[6]['title']
                  : '',
              imageUrl: snapshot.data[6]['imageUrl'],
              model: _futureMenu,
              subTitle: 'สำหรับสมาชิก',
              nav: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactListCategory(
                      title: snapshot.data[6]['title'],
                    ),
                  ),
                );
                // if (checkDirection) {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => ContactListCategory(
                //         title: snapshot.data[6]['title'],
                //       ),
                //     ),
                //   );
                // } else {
                //   _showDialogDirection();
                // }
              },
              userData: null,
            );
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );

    ;
  }

  _buildPoiMenu() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3),
      child: FutureBuilder<dynamic>(
        future: _futureMenu, // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ButtonMenuFull(
              title: snapshot.data[8]['title'] != ''
                  ? snapshot.data[8]['title']
                  : '',
              imageUrl: snapshot.data[8]['imageUrl'],
              model: _futureMenu,
              subTitle: 'สำหรับสมาชิก',
              nav: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PoiList(
                      title: snapshot.data[8]['title'],
                      latLng: null,
                    ),
                  ),
                );
                // if (checkDirection) {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => PoiList(
                //         title: snapshot.data[8]['title'],
                //       ),
                //     ),
                //   );
                // } else {
                //   _showDialogDirection();
                // }
              },
              userData: null,
            );
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _buildPollMenu() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3),
      child: FutureBuilder<dynamic>(
        future: _futureMenu, // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ButtonMenuFull(
              title: snapshot.data[9]['title'] != ''
                  ? snapshot.data[9]['title']
                  : '',
              imageUrl: snapshot.data[9]['imageUrl'],
              model: _futureMenu,
              subTitle: 'สำหรับสมาชิก',
              nav: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PollList(
                      title: snapshot.data[9]['title'],
                    ),
                  ),
                );
                // if (checkDirection) {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => PollList(
                //         title: snapshot.data[9]['title'],
                //       ),
                //     ),
                //   );
                // } else {
                //   _showDialogDirection();
                // }
              },
              userData: null,
            );
          } else if (snapshot.hasError) {
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _buildFooter() {
    return Container(
      // height: 70,
      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
      child: Image.asset(
        'assets/background/background_mics_webuilds.png',
        fit: BoxFit.cover,
      ),
    );
  }

  _read() async {
    // print('-------------start response------------');

    _getLocation();

    //read profile
    profileCode = (await storage.read(key: 'profileCode3'))!;
    if (profileCode != '') {
      setState(() {
        _futureProfile = postDio(profileReadApi, {"code": profileCode});
      });
      _futureMenu = postDio('${menuApi}read', {'limit': 10});
      _futureBanner = postDio('${mainBannerApi}read', {'limit': 10});
      _futureRotation = postDio('${mainRotationApi}read', {'limit': 10});
      _futureMainPopUp = postDio('${mainPopupHomeApi}read', {'limit': 10});
      _futureAboutUs = postDio('${aboutUsApi}read', {});

      _futureVerifyTicket = postDio(getNotpaidTicketListApi, {
        "createBy": "createBy",
        "updateBy": "updateBy",
        "card_id": "",
        "plate1": "3กท",
        "plate2": "9771",
        "plate3": "00100",
        "ticket_id": ""
      });

      var _profile = await _futureProfile;
      setState(() {
        chkisCard = _profile["idcard"] != '' && _profile['idcard'] != null
            ? true
            : false;
      });
      // getMainPopUp();
      // _getLocation();
      // print('-------------end response------------');
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  getMainPopUp() async {
    var result =
        await post('${mainPopupHomeApi}read', {'skip': 0, 'limit': 100});

    if (result.length > 0) {
      var valueStorage = await storage.read(key: 'mainPopupDDPM');
      var dataValue;
      if (valueStorage != null) {
        dataValue = json.decode(valueStorage);
      } else {
        dataValue = null;
      }

      var now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);

      if (dataValue != null) {
        var index = dataValue.indexWhere(
          (c) =>
              // c['username'] == userData.username &&
              c['date'].toString() ==
                  DateFormat("ddMMyyyy").format(date).toString() &&
              c['boolean'] == "true",
        );

        if (index == -1) {
          this.setState(() {
            hiddenMainPopUp = false;
          });
          return showDialog(
            barrierDismissible: false, // close outside
            context: context,
            builder: (_) {
              return WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: MainPopupDialog(
                  model: _futureMainPopUp,
                  type: 'mainPopup',
                  url: '',
                  urlGallery: '',
                  username: '',
                ),
              );
            },
          );
        } else {
          this.setState(() {
            hiddenMainPopUp = true;
          });
        }
      } else {
        this.setState(() {
          hiddenMainPopUp = false;
        });
        return showDialog(
          barrierDismissible: false, // close outside
          context: context,
          builder: (_) {
            return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: MainPopupDialog(
                model: _futureMainPopUp,
                type: 'mainPopup',
                url: '',
                urlGallery: '',
                username: '',
              ),
            );
          },
        );
      }
    }
  }

  void _onRefresh() async {
    // getCurrentUserData();
    _read();

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    // _refreshController.loadComplete();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  _getLocation() async {
    // print('currentLocation');
    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.best);

    // // print('------ Position -----' + position.toString());

    // List<Placemark> placemarks = await placemarkFromCoordinates(
    //     position.latitude, position.longitude,
    //     localeIdentifier: 'th');
    // // print('----------' + placemarks.toString());

    // setState(() {
    //   latLng = LatLng(position.latitude, position.longitude);
    //   currentLocation = placemarks.first.administrativeArea;
    // });
  }

  // mainFooter() {
  //   double width = MediaQuery.of(context).size.width;
  //   double height = MediaQuery.of(context).size.height;
  //   return Container(
  //     height: height * 15 / 100,
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [
  //           Color(0xFFFF7514),
  //           Color(0xFFF7E834),
  //         ],
  //         begin: Alignment.topLeft,
  //         end: new Alignment(1, 0.0),
  //       ),
  //     ),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.max,
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Container(
  //           alignment: Alignment.center,
  //           child: Text(
  //             userData.status == 'N'
  //                 ? 'ท่านยังไม่ได้ยืนยันตัวตน กรุณายืนยันตัวตน'
  //                 : 'ยืนยันตัวตนแล้ว รอเจ้าหน้าที่ตรวจสอบข้อมูล',
  //             style: TextStyle(
  //               // color: Colors.white,
  //               fontFamily: 'Sarabun',
  //               fontSize: 13,
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: height * 1.5 / 100,
  //         ),
  //         userData.status == 'N'
  //             ? Container(
  //                 margin: EdgeInsets.symmetric(horizontal: width * 34 / 100),
  //                 height: height * 6 / 100,
  //                 child: Material(
  //                   elevation: 5.0,
  //                   borderRadius: BorderRadius.circular(10.0),
  //                   child: Container(
  //                     alignment: Alignment.center,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(5.0),
  //                       color: Theme.of(context).primaryColorDark,
  //                     ),
  //                     child: MaterialButton(
  //                       minWidth: MediaQuery.of(context).size.width,
  //                       onPressed: () {
  //                         Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                             builder: (context) => IdentityVerificationPage(),
  //                           ),
  //                         );
  //                       },
  //                       child: Text(
  //                         'ยืนยันตัวตน',
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontFamily: 'Sarabun',
  //                           fontSize: 13,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             : Container(),
  //       ],
  //     ),
  //   );
  // }
}
