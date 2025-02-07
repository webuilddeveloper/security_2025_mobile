import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/key_search.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:security_2025_mobile_v3/component/tab_category.dart';
import 'package:security_2025_mobile_v3/pages/welfare/welfare_list_vertical.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart' as service;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WelfareList extends StatefulWidget {
  WelfareList({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _WelfareList createState() => _WelfareList();
}

class _WelfareList extends State<WelfareList> {
  late WelfareListVertical welfare;
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

    welfare = new WelfareListVertical(
      site: "DDPM",
      model: service
          .post('${service.welfareApi}read', {'skip': 0, 'limit': _limit}),
      url: '${service.welfareApi}read', title: '', urlComment: '',
      urlGallery: '',
      // urlGallery: '${service.welfareGalleryApi}',
    );
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      welfare = new WelfareListVertical(
        // welfare = new WelfareListVertical(
        site: "DDPM",
        model: service.post('${service.welfareApi}read', {
          'skip': 0,
          'limit': _limit,
          'category': category,
          "keySearch": keySearch
        }),
        url: '${service.welfareApi}read', title: '', urlComment: '',
        urlGallery: '',
        // urlGallery: '${service.welfareGalleryApi}',
      );
    });

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context, false);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => Menu()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: header(context, goBack, title: 'สวัสดิการ', rightButton: null),
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
            idleIcon: Icon(
              Icons.arrow_upward,
              color: Colors.transparent,
            ),
          ),
          controller: _refreshController,
          onLoading: _onLoading,
          child: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            // controller: _controller,
            children: [
              // SubHeader(th: "ข่าวสารประชาสัมพันธ์", en: "Welfare"),
              SizedBox(height: 5),
              CategorySelector(
                model: service.postCategory(
                  '${service.welfareCategoryApi}read',
                  {'skip': 0, 'limit': 100},
                ),
                onChange: (String val) {
                  setState(
                    () {
                      category = val;
                      welfare = new WelfareListVertical(
                        site: 'DDPM',
                        model: service.post('${service.welfareApi}read', {
                          'skip': 0,
                          'limit': _limit,
                          "category": category,
                          "keySearch": keySearch
                        }),
                        url: '${service.welfareApi}read', title: '',
                        urlComment: '', urlGallery: '',
                        // urlGallery: '${service.welfareGalleryApi}',
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
                  // welfareList(context, service.post('${service.welfareApi}read', {'skip': 0, 'limit': 100,"keySearch": val}),'');
                  setState(
                    () {
                      keySearch = val;
                      welfare = new WelfareListVertical(
                        site: 'DDPM',
                        model: service.post('${service.welfareApi}read', {
                          'skip': 0,
                          'limit': _limit,
                          "keySearch": keySearch,
                          'category': category
                        }),
                        url: '${service.welfareApi}read',
                        urlGallery: '${service.welfareGalleryApi}',
                        title: '',
                        urlComment: '',
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 10),
              welfare,
              // welfareList(context, service.post('${service.welfareApi}read', {'skip': 0, 'limit': 100}),''),
              // Expanded(
              //   child: welfare,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
