import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/pages/privilege/list_content_horizontal_privilege.dart';
import 'package:security_2025_mobile_v3/pages/privilege/list_content_horizontal_privlege_suggested.dart';
import 'package:security_2025_mobile_v3/pages/privilege/privilege_form.dart';
import 'package:security_2025_mobile_v3/pages/privilege/privilege_list.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:http/http.dart' as http;

class PrivilegeAllContent extends StatefulWidget {
  PrivilegeAllContent({Key? key}) : super(key: key);

  @override
  _PrivilegeAllContent createState() => _PrivilegeAllContent();
}

class _PrivilegeAllContent extends State<PrivilegeAllContent> {
  // final ScrollController _controller = ScrollController();
  bool hideSearch = true;
  late Future<dynamic> _futurePromotion;
  List<dynamic> listData = [];
  List<dynamic> category = [];
  // Future<dynamic> _futurePrivilegeCategory;

  @override
  void initState() {
    _futurePromotion = post(
        '${privilegeApi}read', {'skip': 0, 'limit': 10, 'isHighlight': true});
    // _futurePrivilegeCategory =
    //     post('${privilegeCategoryApi}read', {'skip': 0, 'limit': 100});
    categoryRead();
    super.initState();
  }

  Future<dynamic> categoryRead() async {
    var body = json.encode({
      "permission": "all",
      "skip": 0,
      "limit": 999 // integer value type
    });
    var response = await http.post(Uri.parse(privilegeCategoryApi + 'read'),
        body: body,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        });

    var data = json.decode(response.body);
    setState(() {
      category = data['objectData'];
    });

    if (category.length > 0) {
      for (int i = 0; i <= category.length - 1; i++) {
        var res = post('${privilegeApi}read',
            {'skip': 0, 'limit': 100, 'category': category[i]['code']});
        listData.add(res);
      }
    }
  }

  void goBack() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(), // 2nd
      children: [
        ListContentHorizontalPrivilegeSuggested(
          title: 'แนะนำ',
          url: knowledgeApi,
          model: _futurePromotion,
          urlComment: '',
          navigationList: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrivilegeList(
                  title: 'แนะนำ',
                  isHighlight: true,
                  keySearch: '',
                  category: '',
                ),
              ),
            );
          },
          navigationForm: (
            String code,
            dynamic model,
          ) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrivilegeForm(
                  code: code,
                  model: model,
                ),
              ),
            );
          },
        ),
        for (int i = 0; i < listData.length; i++)
          new ListContentHorizontalPrivilege(
            code: category[i]['code'],
            title: category[i]['title'],
            model: listData[i],
            navigationList: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivilegeList(
                    title: category[i]['title'],
                    category: category[i]['code'],
                    keySearch: '',
                    isHighlight: null,
                  ),
                ),
              );
            },
            navigationForm: (
              String code,
              dynamic model,
            ) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PrivilegeForm(
                    code: code,
                    model: model,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
