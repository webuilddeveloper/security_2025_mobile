import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/sso/list_content_horizontal_loading.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:security_2025_mobile_v3/shared/extension.dart';

// ignore: must_be_immutable
class ListContentHorizontalPrivilege extends StatefulWidget {
  ListContentHorizontalPrivilege(
      {Key? key,
      required this.title,
      required this.code,
      required this.model,
      required this.navigationList,
      required this.navigationForm})
      : super(key: key);

  final String code;
  final String title;
  final Future<dynamic> model;
  final Function() navigationList;
  final Function(String, dynamic) navigationForm;

  @override
  _ListContentHorizontalPrivilege createState() =>
      _ListContentHorizontalPrivilege();
}

class _ListContentHorizontalPrivilege
    extends State<ListContentHorizontalPrivilege> {
  late Future<dynamic> _futurePrivilege;

  @override
  void initState() {
    _futurePrivilege = post('${privilegeApi}read',
        {'skip': 0, 'limit': 100, 'category': widget.code});
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _futurePrivilege, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10.0),
                      margin: EdgeInsets.only(bottom: 5.0, top: 10.0),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
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
                        margin: EdgeInsets.only(bottom: 5.0, top: 10.0),
                        child: Text(
                          'ดูทั้งหมด',
                          style:
                              TextStyle(fontSize: 12.0, fontFamily: 'Sarabun'),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 200,
                  color: Colors.transparent,
                  child: renderCard(
                    widget.title,
                    widget.model,
                    widget.navigationForm,
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        } else {
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
                        fontSize: 18.0,
                        fontFamily: 'Sarabun',
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      widget.navigationList();
                    },
                    //   child: Container(
                    //       padding: EdgeInsets.only(right: 10.0),
                    //       margin: EdgeInsets.only(bottom: 5.0),
                    //       child: Image.asset(
                    //         'assets/images/double_arrow_right.png',
                    //         height: 15.0,
                    //       )),
                  ),
                ],
              ),
              Container(
                height: 200,
                color: Colors.transparent,
                child: renderCard(
                    widget.title, widget.model, widget.navigationForm),
              ),
            ],
          );
        }
      },
    );
  }
}

renderCard(String title, Future<dynamic> model, Function navigationForm) {
  return FutureBuilder<dynamic>(
    future: model, // function where you call your api
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      // AsyncSnapshot<Your object type>

      if (snapshot.hasData) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return myCard(
              index,
              snapshot.data.length,
              snapshot.data[index],
              context,
              navigationForm,
            );
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

renderCardList(String title, Future<dynamic> model, Function navigationForm) {
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: 10,
    itemBuilder: (context, index) {
      return ListContentHorizontalLoading();
    },
  );
}

myCard(int index, int lastIndex, dynamic model, BuildContext context,
    Function navigationForm) {
  return InkWell(
    onTap: () {
      navigationForm(model['code'], model);
    },
    child: Container(
      margin: index == 0
          ? EdgeInsets.only(left: 10.0, right: 5.0)
          : index == lastIndex - 1
              ? EdgeInsets.only(left: 5.0, right: 15.0)
              : EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(5),
          // color: Color(0xFF000070),
          color: Colors.transparent),
      width: 170.0,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 150.0,
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(5.0),
                topRight: const Radius.circular(5.0),
              ),
              color: Colors.white.withAlpha(220),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(model['imageUrl']),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 150.0),
            padding: EdgeInsets.all(5),
            alignment: Alignment.topLeft,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.only(
                bottomLeft: const Radius.circular(5.0),
                bottomRight: const Radius.circular(5.0),
              ),
              color: Color(0xFFFF7514),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 10,
                    color: Color(0xFFFFFFFF),
                    fontFamily: 'Sarabun',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  dateStringToDate(model['createDate']),
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 8,
                    fontFamily: 'Sarabun',
                    color: Color(0xFFFFFFFF),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
