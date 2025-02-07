import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/key_search.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:security_2025_mobile_v3/component/tab_category.dart';
import 'package:security_2025_mobile_v3/pages/news/news_list_vertical.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart' as service;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewsList extends StatefulWidget {
  NewsList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _NewsList createState() => _NewsList();
}

class _NewsList extends State<NewsList> {
  late NewsListVertical news;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  late String keySearch;
  late String category;
  int _limit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    news = new NewsListVertical(
      site: "DDPM",
      model: service.post('${service.newsApi}read', {
        'skip': 0,
        'limit': _limit,
        'app': 'security',
      }),
      url: '${service.newsApi}read',
      urlComment: '${service.newsCommentApi}read',
      urlGallery: '${service.newsGalleryApi}',
      title: '',
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      news = new NewsListVertical(
        site: 'DDPM',
        model: service.post('${service.newsApi}read', {
          'skip': 0,
          'limit': _limit,
          "keySearch": keySearch,
          'category': category
        }),
        url: '${service.newsApi}read',
        urlGallery: '${service.newsGalleryApi}',
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
              // SubHeader(th: "ข่าวสารประชาสัมพันธ์", en: "News"),
              SizedBox(height: 5),
              CategorySelector(
                model: service.postCategory(
                  '${service.newsCategoryApi}read',
                  {'skip': 0, 'limit': 100},
                ),
                onChange: (String val) {
                  setState(
                    () {
                      category = val;
                      news = new NewsListVertical(
                        site: 'DDPM',
                        model: service.post('${service.newsApi}read', {
                          'skip': 0,
                          'limit': _limit,
                          "category": category,
                          "keySearch": keySearch
                        }),
                        url: '${service.newsApi}read',
                        urlGallery: '${service.newsGalleryApi}',
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
                  // newsList(context, service.post('${service.newsApi}read', {'skip': 0, 'limit': 100,"keySearch": val}),'');
                  setState(
                    () {
                      keySearch = val;
                      news = new NewsListVertical(
                        site: 'DDPM',
                        model: service.post('${service.newsApi}read', {
                          'skip': 0,
                          'limit': _limit,
                          "keySearch": keySearch,
                          'category': category
                        }),
                        url: '${service.newsApi}read',
                        urlGallery: '${service.newsGalleryApi}',
                        title: '',
                        urlComment: '',
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 10),
              news,
              // newsList(context, service.post('${service.newsApi}read', {'skip': 0, 'limit': 100}),''),
              // Expanded(
              //   child: news,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
