import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:security_2025_mobile_v3/pages/cooperative/cooperative_list_vertical.dart';
import 'package:security_2025_mobile_v3/component/key_search.dart';
import 'package:security_2025_mobile_v3/component/tab_category.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CooperativeList extends StatefulWidget {
  CooperativeList({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _CooperativeList createState() => _CooperativeList();
}

class _CooperativeList extends State<CooperativeList> {
  late CooperativeListVertical gridView;
  final txtDescription = TextEditingController();
  bool hideSearch = true;
  late String keySearch;
  late String category;
  int _limit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // Future<dynamic> _futureCooperative;

  @override
  void initState() {
    super.initState();

    gridView = new CooperativeListVertical(
      site: 'DDPM',
      model: post('${cooperativeApi}read', {'skip': 0, 'limit': _limit}),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;

      gridView = new CooperativeListVertical(
        site: 'DDPM',
        model: post('${cooperativeApi}read', {
          'skip': 0,
          'limit': _limit,
          "keySearch": keySearch,
          'category': category
        }),
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
      appBar: header(context, goBack, title: 'วารสารสหกรณ์', rightButton: null),
      body: new GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
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
            children: [
              // SubHeader(th: 'คลังความรู้', en: 'Cooperative'),
              SizedBox(height: 5),
              CategorySelector(
                model: postCategory(
                  '${cooperativeCategoryApi}read',
                  {'skip': 0, 'limit': 100},
                ),
                onChange: (String val) {
                  setState(
                    () {
                      category = val;
                      gridView = new CooperativeListVertical(
                        site: 'DDPM',
                        model: post('${cooperativeApi}read',
                            {'skip': 0, 'limit': _limit, 'category': category}),
                      );
                    },
                  );
                },
                site: '',
              ),
              SizedBox(
                height: 5.0,
              ),
              KeySearch(
                show: hideSearch,
                onKeySearchChange: (String val) {
                  setState(
                    () {
                      keySearch = val;
                      gridView = new CooperativeListVertical(
                        site: 'DDPM',
                        model: post('${cooperativeApi}read', {
                          'skip': 0,
                          'limit': _limit,
                          'keySearch': keySearch,
                          'category': category
                        }),
                      );
                    },
                  );
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              gridView,
              // Expanded(
              //   flex: 1,
              //   child: gridView,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
