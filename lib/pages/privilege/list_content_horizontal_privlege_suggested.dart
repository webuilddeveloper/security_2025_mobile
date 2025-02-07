import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/sso/list_content_horizontal_loading.dart';

// ignore: must_be_immutable
class ListContentHorizontalPrivilegeSuggested extends StatefulWidget {
  ListContentHorizontalPrivilegeSuggested(
      {Key? key,
      required this.title,
      required this.url,
      required this.model,
      required this.urlComment,
      required this.navigationList,
      required this.navigationForm})
      : super(key: key);

  final String title;
  final String url;
  final Future<dynamic> model;
  final String urlComment;
  final Function() navigationList;
  final Function(String, dynamic) navigationForm;

  @override
  _ListContentHorizontalPrivilegeSuggested createState() =>
      _ListContentHorizontalPrivilegeSuggested();
}

class _ListContentHorizontalPrivilegeSuggested
    extends State<ListContentHorizontalPrivilegeSuggested> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10.0),
              margin: EdgeInsets.only(bottom: 5.0),
              child: Text(
                widget.title,
                style: TextStyle(
                  // color: Color(0xFF000070),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Sarabun',
                ),
              ),
            ),
            InkWell(
              onTap: () {
                widget.navigationList();
              },
              child: Container(
                  padding: EdgeInsets.only(right: 10.0),
                  margin: EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    'ดูทั้งหมด',
                    style: TextStyle(fontSize: 12.0, fontFamily: 'Sarabun'),
                  )
                  // Image.asset(
                  //   'assets/images/double_arrow_right.png',
                  //   height: 15.0,
                  // )
                  ),
            ),
          ],
        ),
        Container(
          height: 300,
          color: Colors.transparent,
          child: renderCard(
            widget.title,
            widget.url,
            widget.model,
            widget.urlComment,
            widget.navigationForm,
          ),
        ),
      ],
    );
  }
}

renderCard(String title, String url, Future<dynamic> model, String urlComment,
    Function navigationForm) {
  return FutureBuilder<dynamic>(
    future: model, // function where you call your api
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      // AsyncSnapshot<Your object type>

      if (snapshot.hasData) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return myCard(index, snapshot.data.length, snapshot.data[index],
                context, navigationForm);
          },
        );
        // } else if (snapshot.hasError) {
        //   return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, index) {
            return ListContentHorizontalLoading();
          },
        );
      }
    },
  );
}

myCard(int index, int lastIndex, dynamic model, BuildContext context,
    Function navigationForm) {
  return InkWell(
    onTap: () {
      navigationForm(model['code'], model);
    },
    child: Column(
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Color(0xFF000000)),
              margin: index == 0
                  ? EdgeInsets.only(left: 10.0, right: 5.0)
                  : index == lastIndex - 1
                      ? EdgeInsets.only(left: 5.0, right: 15.0)
                      : EdgeInsets.symmetric(horizontal: 5.0),
              // height: 334,
              width: 300.0,
              child: Column(
                children: [
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color(0xFFFF7514),
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(5.0),
                        topRight: const Radius.circular(5.0),
                      ),
                    ),
                    padding: EdgeInsets.all(5),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 5.0),
                          child: Text(
                            'โปรโมชันสัปดาห์นี้',
                            style: TextStyle(
                                fontFamily: 'Sarabun',
                                fontSize: 18.0,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Image.network(
                      '${model['imageUrl']}',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 45,
                    width: 350,
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      borderRadius: new BorderRadius.only(
                        bottomLeft: const Radius.circular(5.0),
                        bottomRight: const Radius.circular(5.0),
                      ),
                      color: Color(0xFFE2E2E2),
                      // color: Theme.of(context).primaryColorLight,
                    ),
                    padding: EdgeInsets.all(5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '${model['title']}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Sarabun',
                            fontSize: 13.0,
                          ),
                        ),
                        Text(
                          '${model['title']}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Sarabun',
                            fontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
