import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/key_search.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:security_2025_mobile_v3/component/tab_category.dart';
import 'package:security_2025_mobile_v3/pages/poll/poll_list_vertical.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart' as service;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PollList extends StatefulWidget {
  PollList({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _PollList createState() => _PollList();
}

class _PollList extends State<PollList> {
  late PollListVertical poll;
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

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      poll = new PollListVertical(
        site: "DDPM",
        model: service
            .post('${service.pollApi}read', {'skip': 0, 'limit': _limit}),
        titleHome: widget.title,
        url: '${service.pollApi}read',
        urlGallery: service.pollGalleryApi,
        title: '',
        urlComment: '',
        callBack: () {},
      );
    });

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // _controller.addListener(_scrollListener);
    super.initState();

    poll = new PollListVertical(
      // poll = new PollListVertical(

      site: "DDPM",
      model:
          service.post('${service.pollApi}read', {'skip': 0, 'limit': _limit}),
      url: '${service.pollApi}read',
      urlGallery: service.pollGalleryApi,
      titleHome: widget.title,
      callBack: () => {_onLoading()}, title: '', urlComment: '',
    );
  }

  void goBack() async {
    Navigator.of(context).popUntil((route) => route.isFirst);
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
              // SubHeader(th: "ข่าวสารประชาสัมพันธ์", en: "Poll"),
              SizedBox(height: 5),
              CategorySelector(
                model: service.postCategory(
                  '${service.pollCategoryApi}read',
                  {'skip': 0, 'limit': 100},
                ),
                onChange: (String val) {
                  setState(
                    () {
                      category = val;
                      poll = new PollListVertical(
                        site: 'DDPM',
                        model: service.post('${service.pollApi}read',
                            {'skip': 0, 'limit': _limit, "category": category}),
                        url: '${service.pollApi}read',
                        title: widget.title,
                        titleHome: widget.title,
                        urlGallery: '${service.pollGalleryApi}',
                        callBack: () => {_onLoading()},
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
                  // pollList(context, service.post('${service.pollApi}read', {'skip': 0, 'limit': 100,"keySearch": val}),'');
                  setState(
                    () {
                      keySearch = val;
                      poll = new PollListVertical(
                        site: 'DDPM',
                        model: service.post('${service.pollApi}read', {
                          'skip': 0,
                          'limit': _limit,
                          "keySearch": keySearch,
                          'category': category
                        }),
                        url: '${service.pollApi}read',
                        urlGallery: '${service.pollGalleryApi}',
                        callBack: () => {_onLoading()},
                        title: '',
                        urlComment: '',
                        titleHome: '',
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 10),
              poll,
              // pollList(context, service.post('${service.pollApi}read', {'skip': 0, 'limit': 100}),''),
              // Expanded(
              //   child: poll,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
