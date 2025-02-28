import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/key_search.dart';
import 'package:security_2025_mobile_v3/component/tab_category.dart';
import 'package:security_2025_mobile_v3/pages/news/news_list_vertical.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart' as service;
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  String keySearch = "";
  String category = "";

  List<dynamic> allNewsData = []; // เก็บข้อมูลข่าวทั้งหมด
  bool isLoading = false;
  bool hasMoreData = true;        // ตัวแปรเก็บสถานะว่ามีข้อมูลให้โหลดเพิ่มหรือไม่

  int _currentPage = 0;
  int _newsLimit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // Helper method ที่ใช้รูปแบบเดียวกับหน้าแรก
  
  Future<dynamic> fetchNews({
    required int page,
    required int limit,
    String search = "",
    String cat = "",
  }) {
    final requestData = {
      'skip': page * limit,
      'limit': limit,
      'app': 'security',
      'keySearch': search,
      'category': cat,
    };

    // print("📌 Data ที่ส่งไป API: ${jsonEncode(requestData)}");

    return service.postDio('${service.newsApi}read', requestData);
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      isLoading = true;
      _currentPage = 0;
      allNewsData = [];
    });

    try {
      final response = await fetchNews(
        page: _currentPage,
        limit: _newsLimit,
        search: keySearch,
        cat: category,
      );

      setState(() {
        if (response is List) {
          allNewsData = response;
          hasMoreData = response.length >= _newsLimit;
        } else {
          allNewsData = [];
          hasMoreData = false;
        }
        isLoading = false;
      });

      _initNewsComponent();
    } catch (error) {
      setState(() {
        allNewsData = [];
        isLoading = false;
        hasMoreData = false;
      });
      print("❌ เกิดข้อผิดพลาด: $error");
    }
  }

  void _initNewsComponent() {
    news = NewsListVertical(
      site: "DDPM",
      model: Future.value(allNewsData), // ส่งข้อมูลที่มีอยู่แล้ว
      url: '${service.newsApi}read',
      urlGallery: '${service.newsGalleryApi}',
      title: '',
      urlComment: '',
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onLoading() async {
    if (!hasMoreData || isLoading) {
      _refreshController.loadComplete();
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final response = await fetchNews(
        page: nextPage,
        limit: _newsLimit,
        search: keySearch,
        cat: category,
      );

      if (response is List && response.isNotEmpty) {
        setState(() {
          allNewsData.addAll(response);
          _currentPage = nextPage;
          hasMoreData = response.length >= _newsLimit;
          isLoading = false;
        });

        // อัปเดต NewsListVertical ด้วยข้อมูลทั้งหมดที่มี
        _initNewsComponent();
      } else {
        setState(() {
          hasMoreData = false;
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        hasMoreData = false;
      });
      print("❌ เกิดข้อผิดพลาดในการโหลดข้อมูลเพิ่มเติม: $error");
    }

    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  void _resetSearch() {
    keySearch = "";
    category = "";
    _loadInitialData();
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
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              setState(() {
                hideSearch = !hideSearch;
                if (hideSearch) {
                  _resetSearch();
                }
              });
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
            canLoadingText: 'โหลดเพิ่มเติม',
            idleText: hasMoreData
                ? 'เลื่อนขึ้นเพื่อโหลดเพิ่มเติม'
                : 'ไม่มีข้อมูลเพิ่มเติม',
            noDataText: 'ไม่มีข้อมูลเพิ่มเติม',
            idleIcon: Icon(Icons.arrow_upward,
                color: hasMoreData ? Colors.grey : Colors.transparent),
          ),
          controller: _refreshController,
          onLoading: _onLoading,
          child: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: [
              SizedBox(height: 5),
              KeySearch(
                show: hideSearch,
                onKeySearchChange: (String val) {
                  keySearch = val;
                  _loadInitialData();
                },
              ),
              SizedBox(height: 5),
              CategorySelector(
                model: service.postCategory(
                  '${service.newsCategoryApi}read',
                  {
                    'skip': 0,
                    'limit': 10,
                    'app': 'security',
                  },
                ),
                onChange: (String val) {
                  category = val;
                  _loadInitialData();
                },
                site: '',
              ),
              SizedBox(height: 10),
              isLoading && allNewsData.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : allNewsData.isEmpty
                      ? Center(child: Text('ไม่พบข้อมูล'))
                      : news,
              if (isLoading && allNewsData.isNotEmpty)
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
