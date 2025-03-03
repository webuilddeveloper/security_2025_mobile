import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/key_search.dart';
import 'package:security_2025_mobile_v3/component/tab_category.dart';
import 'package:security_2025_mobile_v3/pages/news/news_list_vertical.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart' as service;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';

class NewsList extends StatefulWidget {
  NewsList({
    super.key,
    required this.title,
  });

  final String title;

  @override
  _NewsList createState() => _NewsList();
}

class _NewsList extends State<NewsList> {
  NewsListVertical? news;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  String? keySearch;
  String? category;
  int _limit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    news = new NewsListVertical(
      site: "DDPM",
      model: postDio(
          '${newsApi}read', {'skip': 0, 'limit': _limit, 'app': 'security'}),
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
        model: postDio('${newsApi}read', {
          'skip': 0,
          'limit': _limit,
          "keySearch": keySearch,
          // 'category': category,
          'app': 'security',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Text(
            widget.title,
            // 'ข่าวประชาสัมพันธ์',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
        backgroundColor: Color(0XFFB03432),
      ),
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
              SizedBox(height: 30),
              CategorySelector(
                model: service.postCategory(
                  '${service.newsCategoryApi}read',
                  {'skip': 0, 'limit': 100, 'code': '20241028102515-482-400'},
                ),
                onChange: (String val) {
                  setState(
                    () {
                      // category = val;
                      news = new NewsListVertical(
                        site: 'DDPM',
                        model: postDio('${newsApi}read', {
                          'skip': 0,
                          'limit': _limit,
                          // "category": category,
                          'app': 'security',
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
              const SizedBox(height: 5),
              KeySearch(
                show: hideSearch,
                onKeySearchChange: (String val) {
                  // newsList(context, service.post('${service.newsApi}read', {'skip': 0, 'limit': 100,"keySearch": val}),'');
                  setState(
                    () {
                      keySearch = val;
                      news = new NewsListVertical(
                        site: 'DDPM',
                        model: postDio('${newsApi}read', {
                          'skip': 0,
                          'limit': _limit,
                          "keySearch": keySearch,
                          'app': 'security'
                          // 'category': category
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
              news!,
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
