import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/key_search.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:security_2025_mobile_v3/component/tab_category.dart';
import 'package:security_2025_mobile_v3/pages/warning/warning_list_vertical.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart' as service;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WarningList extends StatefulWidget {
  WarningList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _WarningList createState() => _WarningList();
}

class _WarningList extends State<WarningList> {
  late WarningListVertical warning;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  late String keySearch;
  late String category;
  int _limit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // _controller.addListener(_scrollListener);
    super.initState();

    warning = new WarningListVertical(
      // warning = new WarningListVertical(
      site: "DDPM",
      model: service
          .post('${service.warningApi}read', {'skip': 0, 'limit': _limit}),
      url: '${service.warningApi}read',
      urlComment: '${service.warningCommentApi}read',
      urlGallery: '${service.warningGalleryApi}', title: '',
    );
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      warning = new WarningListVertical(
        site: 'DDPM',
        model: service.post('${service.warningApi}read', {
          'skip': 0,
          'limit': _limit,
          "keySearch": keySearch,
          'category': category
        }),
        url: '${service.warningApi}read',
        urlGallery: '${service.warningGalleryApi}',
        title: '',
        urlComment: '',
      );
    });

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context, false);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => Menu(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: header(context, goBack, title: widget.title, rightButton: null),
      // AppBar(
      //   backgroundColor: Color(0xFF000070),
      //   elevation: 0.0,
      //   // leading: FlutterLogo(),
      //   leading: Container(
      //     height: 50,
      //     width: 50,
      //     margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
      //     child: Center(
      //         heightFactor: 37.5,
      //         widthFactor: 33.18,
      //         child: Image.asset(
      //           'assets/images/logo.png',
      //           fit: BoxFit.cover,
      //         )),
      //     decoration: BoxDecoration(
      //       borderRadius: new BorderRadius.only(
      //         topLeft: const Radius.circular(5.0),
      //         topRight: const Radius.circular(5.0),
      //       ),
      //       color: Color(0xFF000070),
      //     ),
      //   ),

      //   title: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [Text('Smart'), Text('SSO')],
      //   ),
      // ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
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
            physics: ScrollPhysics(),
            shrinkWrap: true,
            // controller: _controller,
            children: [
              // SubHeader(th: "ข่าวสารประชาสัมพันธ์", en: "Warning"),
              SizedBox(height: 5),
              CategorySelector(
                model: service.postCategory(
                  '${service.warningCategoryApi}read',
                  {'skip': 0, 'limit': 100},
                ),
                onChange: (String val) {
                  setState(
                    () {
                      category = val;
                      warning = new WarningListVertical(
                        site: 'DDPM',
                        model: service.post('${service.warningApi}read', {
                          'skip': 0,
                          'limit': _limit,
                          "category": category,
                          "keySearch": keySearch
                        }),
                        url: '${service.warningApi}read',
                        urlGallery: '${service.warningGalleryApi}',
                        title: '',
                        urlComment: '',
                      );
                    },
                  );
                },
                site: '',
              ),
              SizedBox(height: 5),
              KeySearch(
                show: hideSearch,
                onKeySearchChange: (String val) {
                  // warningList(context, service.post('${service.warningApi}read', {'skip': 0, 'limit': 100,"keySearch": val}),'');
                  setState(
                    () {
                      keySearch = val;
                      warning = new WarningListVertical(
                        site: 'DDPM',
                        model: service.post('${service.warningApi}read', {
                          'skip': 0,
                          'limit': _limit,
                          "keySearch": keySearch,
                          'category': category
                        }),
                        url: '${service.warningApi}read',
                        urlGallery: '${service.warningGalleryApi}',
                        title: '',
                        urlComment: '',
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 10),
              warning,
              // warningList(context, service.post('${service.warningApi}read', {'skip': 0, 'limit': 100}),''),
              // Expanded(
              //   child: warning,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
