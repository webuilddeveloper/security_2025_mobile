import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/tab_category.dart';
import 'package:security_2025_mobile_v3/pages/news/news_list_vertical.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart' as service;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:security_2025_mobile_v3/shared/api_provider.dart';

class NewsList extends StatefulWidget {
  NewsList({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _NewsList createState() => _NewsList();
}

class _NewsList extends State<NewsList> {
  late NewsListVertical news;
  int _newsLimit = 10; // จำนวนข่าวต่อหน้า
  int _currentNewsPage = 0; // หน้าปัจจุบัน

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();

    news = new NewsListVertical(
      site: "DDPM",
      model: postDio('${newsApi}read', {
        'skip': _currentNewsPage * _newsLimit,
        'limit': _newsLimit,
        'app': 'security',
      }),
      url: '${newsApi}read',
      urlComment: '${newsCommentApi}read',
      urlGallery: '${newsGalleryApi}',
      title: '',
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onLoading() async {
    final newModel = await postDio('${newsApi}read', {
      'skip': (_currentNewsPage + 1) * _newsLimit,
      'limit': _newsLimit,
      'app': 'security',
    });

    if (newModel.isEmpty) {
      _refreshController.loadNoData(); // บอกว่าไม่มีข้อมูลเพิ่มเติมแล้ว
    } else {
      setState(() {
        _currentNewsPage++;
        news = NewsListVertical(
          site: 'DDPM',
          model: newModel,
          url: '${newsApi}read',
          urlGallery: '${newsGalleryApi}',
          title: '',
          urlComment: '',
        );
      });

      _refreshController.loadComplete(); // โหลดเสร็จปกติ
    }
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
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.transparent,
            onPressed: () {
              Navigator.pop(context);
            },
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
              loadingText: 'กำลังโหลด...',
              canLoadingText: 'เลื่อนเพื่อโหลดเพิ่มเติม...',
              idleText: 'เลื่อนเพื่อโหลดเพิ่มเติม...',
              noDataText:
                  'ไม่มีข่าวเพิ่มเติมแล้ว', // เพิ่มข้อความเมื่อไม่มีข้อมูล
              idleIcon: Icon(Icons.arrow_upward, color: Colors.grey),
            ),
            controller: _refreshController,
            onLoading: _onLoading,
            child: ListView(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              children: [
                SizedBox(height: 15),
                CategorySelector(
                  model: service.postCategory(
                    '${service.newsCategoryApi}read',
                    {
                      'skip': 0,
                      'limit': 100,
                      'app': 'security',
                    },
                  ),
                  onChange: (String val) {
                    setState(() {
                      _currentNewsPage = 0;
                      news = NewsListVertical(
                        site: 'DDPM',
                        model: postDio('${newsApi}read', {
                          'skip': _currentNewsPage * _newsLimit,
                          'limit': _newsLimit,
                          'app': 'security',
                          'category': val,
                        }),
                        url: '${newsApi}read',
                        urlGallery: '${newsGalleryApi}',
                        title: '',
                        urlComment: '',
                      );
                    });
                  },
                  site: '',
                ),
                SizedBox(height: 10),
                news,
              ],
            ),
          )),
    );
  }
}
