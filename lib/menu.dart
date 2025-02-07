import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:security_2025_mobile_v3/component/material/check_avatar.dart';
import 'package:security_2025_mobile_v3/home.dart';
import 'package:security_2025_mobile_v3/pages/event_calendar/event_calendar_main.dart';
import 'package:security_2025_mobile_v3/pages/my_qr_code.dart';
import 'package:security_2025_mobile_v3/pages/notification/notification_list.dart';
import 'package:security_2025_mobile_v3/pages/profile/user_information.dart';

class Menu extends StatefulWidget {
  const Menu({
    Key? key,
    required this.pageIndex,
  }) : super(key: key);
  final int? pageIndex;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late DateTime currentBackPressTime;
  dynamic futureNotificationTire;
  int notiCount = 0;
  int _currentPage = 0;
  String _profileCode = '';
  String _imageProfile = '';
  bool hiddenMainPopUp = false;
  List<Widget> pages = <Widget>[];
  bool notShowOnDay = false;
  int _currentBanner = 0;

  var loadingModel = {
    'title': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _callRead();
    pages = <Widget>[
      // SizedBox(),
      // SizedBox(),
      // SizedBox(),
      HomePage(changePage: _changePage),
      EventCalendarMain(
        title: 'ปฏิทินกิจกรรม',
      ),
      NotificationList(
        title: 'แจ้งเตือน',
      ),
      UserInformationPage(),
      MyQrCode(changePage: _changePage),
      // MyCertificate(changePage: _changePage),
    ];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _changePage(index) {
    setState(() {
      _currentPage = index;
    });

    if (index == 0) {
      _callRead();
    }
  }

  onSetPage() {
    setState(() {
      _currentPage = widget.pageIndex ?? 0;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0 && _currentPage == 0) {
        _callRead();
      }

      _currentPage = index;
    });
  }

  _callRead() async {
    // var img = await DCCProvider.getImageProfile();
    // _readNotiCount();
    // setState(() => _imageProfile = img);
    // setState(() {
    //   if (_profileCode != '') {
    //     pages[4] = profilePage;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF1E1E1E),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: confirmExit,
          child: IndexedStack(
            index: _currentPage,
            children: pages,
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Future<bool> confirmExit() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      // Toast.show(
      //   'กดอีกครั้งเพื่อออก',
      //   context,
      //   duration: Toast.LENGTH_SHORT,
      //   gravity: Toast.BOTTOM,
      // );
      Fluttertoast.showToast(
        msg: 'กดอีกครั้งเพื่อออก',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget _buildBottomNavBar() {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
      child: Container(
        height: 66 + MediaQuery.of(context).padding.bottom,
        decoration: BoxDecoration(
          color: Colors.white,
          // gradient: LinearGradient(
          //   colors: [
          //     Theme.of(context).custom.f7cafce,
          //     Theme.of(context).custom.f796dc3
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF000000).withOpacity(0.10),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, -3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            _buildTap(
              0,
              'หน้าหลัก',
              Icons.home,
            ),
            _buildTap(1, 'ปฎิทิน', Icons.calendar_month_outlined),
            _buildTap(2, 'แจ้งเตือน', Icons.notifications),
            _buildTap(3, 'โปรไฟล์', Icons.person, isNetwork: true),
            // _buildTap(2, 'Re-Skill', Icons.qr_code_scanner),
          ],
        ),
      ),
    );
  }

  Widget _buildTap(
    int index,
    String title,
    IconData iconsData, {
    bool isNetwork = false,
    bool isIconsData = false,
    Key? key,
  }) {
    Color color = Color(0XFFA49E9E);
    if (_currentPage == index) {
      color = Color(0xFF252120);
    }

    return Flexible(
      key: key,
      flex: 1,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            radius: 60,
            splashColor: Theme.of(context).primaryColor.withOpacity(0.3),
            onTap: () {
              _onItemTapped(index);
              // postTrackClick("แท็บ$title");
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              // padding: EdgeInsets.all(10),
              // margin: EdgeInsets.all(10),
              decoration: _currentPage == index
                  ? BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFFFFF).withOpacity(0.50),
                          // spreadRadius: 0,
                          // blurRadius: 0,
                          // offset:
                          //     const Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    )
                  : null,
              // borderRadius: BorderRadius.circular(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isIconsData
                      ? isNetwork
                          ? Image.memory(
                              checkAvatar(context, _imageProfile),
                              fit: BoxFit.cover,
                              height: 30,
                              width: 30,
                              errorBuilder: (_, __, ___) => Image.asset(
                                "assets/images/profile_menu.png",
                                fit: BoxFit.fill,
                              ),
                            )
                          : Image.asset(
                              'assets/images/profile_menu.png',
                              height: 30,
                              width: 30,
                              color: color,
                            )
                      : Icon(
                          iconsData,
                          size: 30,
                          color: color,
                        ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 8.0,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.w400,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
