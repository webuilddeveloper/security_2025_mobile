import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';

class CategorySelector extends StatefulWidget {
  CategorySelector(
      {Key? key,
      required this.site,
      required this.model,
      required this.onChange})
      : super(key: key);

//  final VoidCallback onTabCategory;
  final String? site;
  final Function(String) onChange;
  final Future<dynamic> model;

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>

        if (snapshot.hasData) {
          return Container(
            height: 45.0,
            padding: EdgeInsets.only(left: 3.0, right: 3.0),
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: new BorderRadius.circular(6.0),
              color: Colors.white,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    widget.onChange(snapshot.data[index]['code']);
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: index == selectedIndex
                          ? Border(
                              bottom: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).primaryColor))
                          : null,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 10.0,
                    ),
                    child: Text(
                      snapshot.data[index]['title'],
                      style: TextStyle(
                        color: index == selectedIndex
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        // decoration: index == selectedIndex
                        //     ? TextDecoration.underline
                        //     : null,
                        fontSize: index == selectedIndex ? 15.0 : 13.0,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1.2,
                        fontFamily: 'Sarabun',
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Container(
            height: 45.0,
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            margin: EdgeInsets.symmetric(horizontal: 0.0),
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              // borderRadius: new BorderRadius.circular(6.0),
              color: Colors.white,
            ),
          );
        }
      },
    );
  }
}

class CategorySelector2 extends StatefulWidget {
  CategorySelector2({
    Key? key,
    required this.site,
    required this.model,
    required this.onChange,
    required this.path,
    this.code = '',
    this.skip,
    this.limit,
  }) : super(key: key);

//  final VoidCallback onTabCategory;
  final String site;
  final Function(String, String) onChange;
  final Future<dynamic>? model;
  final String code;
  final String path;
  final dynamic skip;
  final dynamic limit;

  @override
  _CategorySelector2State createState() => _CategorySelector2State();
}

class _CategorySelector2State extends State<CategorySelector2> {
  dynamic res;
  String selectedIndex = '';
  String selectedTitleIndex = '';

  @override
  void initState() {
    res = postDioCategoryWeMart(widget.path, {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: res, // function where you call your api\
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.hasData) {
          return Wrap(
            children: snapshot.data
                .map<Widget>(
                  (c) => GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      widget.onChange(c['code'], c['title']);
                      setState(() {
                        selectedIndex = c['code'];
                        selectedTitleIndex = c['title'];
                      });
                    },
                    child: Container(
                      width: 85,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 10, bottom: 10),
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.circular(40),
                        color: c['code'] == selectedIndex
                            ? Color(0xFFFFFFFF).withOpacity(0.2)
                            : Colors.transparent,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: Text(
                        c['title'],
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          // decoration: index == selectedIndex
                          //     ? TextDecoration.underline
                          //     : null,
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1.2,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        } else {
          return Container(
            height: 25.0,
            // padding: EdgeInsets.only(left: 5.0, right: 5.0),
            // margin: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: new BorderRadius.circular(6.0),
              color: Colors.white,
            ),
          );
        }
      },
    );
  }
}

class CategorySelector2NoAll extends StatefulWidget {
  CategorySelector2NoAll({
    Key? key,
    required this.site,
    required this.model,
    required this.onChange,
    required this.path,
    this.code = '',
    this.skip,
    this.limit,
  }) : super(key: key);

//  final VoidCallback onTabCategory;
  final String site;
  final Function(String) onChange;
  final Future<dynamic> model;
  final String code;
  final String path;
  final dynamic skip;
  final dynamic limit;

  @override
  _CategorySelector2StateNoAll createState() => _CategorySelector2StateNoAll();
}

class _CategorySelector2StateNoAll extends State<CategorySelector2NoAll> {
  dynamic res;
  String selectedIndex = '';

  @override
  void initState() {
    res = postDioCategoryWeMartNoAll(
        widget.path, {'skip': widget.skip, 'limit': widget.limit});
    // selectedIndex = widget.code;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: res, // function where you call your api\
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.hasData) {
          return Container(
            height: 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    widget.onChange(snapshot.data[index]['code']);
                    setState(() {
                      selectedIndex = snapshot.data[index]['code'];
                    });
                  },
                  child: Container(
                    width: 85,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 10),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(40),
                      color: snapshot.data[index]['code'] == selectedIndex
                          ? Color(0xFF3F73E6)
                          : Colors.transparent,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.0,
                      // vertical: 5.0,
                    ),
                    child: Text(
                      snapshot.data[index]['title'],
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1.2,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Container(
            height: 25.0,
            // padding: EdgeInsets.only(left: 5.0, right: 5.0),
            // margin: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: new BorderRadius.circular(6.0),
              color: Colors.white,
            ),
          );
        }
      },
    );
  }
}
