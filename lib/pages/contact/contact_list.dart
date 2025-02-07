import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:security_2025_mobile_v3/component/key_search.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:security_2025_mobile_v3/pages/contact/contact_list_vertical.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ContactList extends StatefulWidget {
  ContactList({
    Key? key,
    required this.title,
    required this.code,
  }) : super(key: key);

  final String title;
  final String code;

  @override
  _ContactList createState() => _ContactList();
}

class _ContactList extends State<ContactList> {
  late ContactListVertical contact;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  late String keySearch;
  late String category;
  int _limit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late Future<dynamic> _futureContact;

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

    _futureContact = post('${contactApi}read',
        {'skip': 0, 'limit': _limit, 'category': widget.code});

    super.initState();
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;
      _futureContact = post('${contactApi}read', {
        'skip': 0,
        'limit': _limit,
        'category': widget.code,
        'keySearch': keySearch
      });

      contact = new ContactListVertical(
        site: "DDPM",
        model: _futureContact,
        title: "",
        url: '${contactApi}read',
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
              // SubHeader(th: widget.title, en: ""),
              SizedBox(height: 10),
              KeySearch(
                show: hideSearch,
                onKeySearchChange: (String val) {
                  setState(
                    () {
                      keySearch = val;
                      _futureContact = post('${contactApi}read', {
                        'skip': 0,
                        'limit': _limit,
                        'category': widget.code,
                        'keySearch': keySearch
                      });
                    },
                  );
                },
              ),
              SizedBox(height: 10),
              // CategorySelector(
              //   model: service.post(
              //     '${service.contactCategoryApi}read',
              //     {'skip': 0, 'limit': 100},
              //   ),
              //   onChange: (String val) {
              //     setState(() => {
              //           contact = new ContactListCategoryVertical(
              //             site: 'DDPM',
              //             model: service.post(
              //                 '${service.contactCategoryApi}read',
              //                 {'skip': 0, 'limit': 10, "category": val}),
              //             title: '',
              //             url: '${service.contactCategoryApi}read',
              //             // urlGallery: '${service.contactGalleryApi}',
              //           ),
              //         });
              //   },
              // ),
              ContactListVertical(
                site: "DDPM",
                model: _futureContact,
                title: "",
                url: '${contactApi}read',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
