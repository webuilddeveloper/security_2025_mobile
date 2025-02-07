import 'package:security_2025_mobile_v3/pages/reporter/reporter_disaster_list.dart';
import 'package:flutter/material.dart';

class ReporterListCategoryDisasterVertical extends StatefulWidget {
  ReporterListCategoryDisasterVertical({
    Key? key,
    required this.site,
    required this.model,
    required this.title,
    required this.url,
  }) : super(key: key);

  final String site;
  final Future<dynamic> model;
  final String title;
  final String url;

  @override
  _ReporterListCategoryDisasterVertical createState() =>
      _ReporterListCategoryDisasterVertical();
}

class _ReporterListCategoryDisasterVertical
    extends State<ReporterListCategoryDisasterVertical> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> items =
      List<String>.generate(10, (index) => "Item: ${++index}");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container(
              alignment: Alignment.center,
              height: 200,
              child: Text(
                'ไม่พบข้อมูล',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Sarabun',
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                ),
              ),
            );
          } else {
            return Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReporterDisasterList(
                            title: snapshot.data[index]['title'],
                            category: snapshot.data[index]['code'],
                            username: '',
                          ),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          margin: EdgeInsets.only(bottom: 5.0),
                          child: Column(
                            children: [
                              Container(
                                // height: 60.0,
                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.circular(5.0),
                                  color: Color(0xFFFFFFFF),
                                ),
                                padding: EdgeInsets.all(5.0),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  '${snapshot.data[index]['imageUrl']}'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          // color: Color(0xFF000070),
                                          alignment: Alignment.centerLeft,
                                          width: 40.0,
                                          height: 40.0,
                                          padding: EdgeInsets.all(5),
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.63,
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                            '${snapshot.data[index]['title']}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 16,
                                              fontFamily: 'Sarabun',
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.6),
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      // color: Colors.yellow,
                                      child: Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Color.fromRGBO(0, 0, 0, 0.5),
                                        size: 40.0,
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
                  );
                },
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}
