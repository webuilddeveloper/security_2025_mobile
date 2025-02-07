import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/key_search.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:security_2025_mobile_v3/component/tab_category.dart';
import 'package:security_2025_mobile_v3/pages/fund/fund_list_vertical.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart' as service;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FundList extends StatefulWidget {
  FundList({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _FundList createState() => _FundList();
}

class _FundList extends State<FundList> {
  late FundListVertical fund;
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

    fund = new FundListVertical(
      site: "DDPM",
      model:
          service.post('${service.fundApi}read', {'skip': 0, 'limit': _limit}),
      url: '${service.fundApi}read',
      urlGallery: '${service.fundGalleryApi}',
      urlComment: '${service.fundCommentApi}',
      title: '',
    );
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      fund = new FundListVertical(
        // fund = new FundListVertical(
        site: "DDPM",
        model: service.post('${service.fundApi}read', {
          'skip': 0,
          'limit': _limit,
          'category': category,
          "keySearch": keySearch
        }),
        url: '${service.fundApi}read',
        urlComment: '${service.fundCommentApi}',
        urlGallery: '${service.fundGalleryApi}', title: '',
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
              // SubHeader(th: "ข่าวสารประชาสัมพันธ์", en: "Fund"),
              SizedBox(height: 5),
              CategorySelector(
                model: service.postCategory(
                  '${service.fundCategoryApi}read',
                  {'skip': 0, 'limit': 100},
                ),
                onChange: (String val) {
                  setState(
                    () {
                      category = val;
                      fund = new FundListVertical(
                        site: 'DDPM',
                        model: service.post('${service.fundApi}read', {
                          'skip': 0,
                          'limit': _limit,
                          "category": category,
                          "keySearch": keySearch
                        }),
                        url: '${service.fundApi}read',
                        urlGallery: '${service.fundGalleryApi}',
                        urlComment: '${service.fundCommentApi}',
                        title: '',
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
                  // fundList(context, service.post('${service.fundApi}read', {'skip': 0, 'limit': 100,"keySearch": val}),'');
                  setState(
                    () {
                      keySearch = val;
                      fund = new FundListVertical(
                        site: 'DDPM',
                        model: service.post('${service.fundApi}read', {
                          'skip': 0,
                          'limit': _limit,
                          "keySearch": keySearch,
                          'category': category
                        }),
                        url: '${service.fundApi}read',
                        urlGallery: '${service.fundGalleryApi}',
                        urlComment: '${service.fundCommentApi}',
                        title: '',
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 10),
              fund,
              // fundList(context, service.post('${service.fundApi}read', {'skip': 0, 'limit': 100}),''),
              // Expanded(
              //   child: fund,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
