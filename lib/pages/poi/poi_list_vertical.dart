import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/pages/poi/poi_form.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';

class PoiListVertical extends StatefulWidget {
  PoiListVertical({Key? key, required this.model}) : super(key: key);

  final Future<dynamic> model;

  @override
  _PoiListVertical createState() => _PoiListVertical();
}

class _PoiListVertical extends State<PoiListVertical> {
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
        // AsyncSnapshot<Your object type>

        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container(
              height: 200,
              alignment: Alignment.center,
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
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1,
                ),
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PoiForm(
                            code: snapshot.data[index]['code'],
                            model: snapshot.data[index],
                            url: poiApi,
                            urlComment: poiCommentApi,
                            urlGallery: poiGalleryApi,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: index == 0
                          ? EdgeInsets.only(left: 5.0, right: 5.0)
                          : index == snapshot.data.length - 1
                              ? EdgeInsets.only(left: 5.0, right: 15.0)
                              : EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(5),
                        color: Colors.transparent,
                      ),
                      width: 170.0,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            height: 170.0,
                            // width: 170.0,
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(5.0),
                                topRight: const Radius.circular(5.0),
                              ),
                              color: Colors.grey.withAlpha(220),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                  snapshot.data[index]['imageUrl'],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 150.0),
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.topLeft,
                            height: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                bottomLeft: const Radius.circular(5.0),
                                bottomRight: const Radius.circular(5.0),
                              ),
                              color: Theme.of(context).primaryColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data[index]['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontFamily: 'Sarabun',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                Text(
                                  snapshot.data[index]['distance'] == null
                                      ? "ระยะห่าง - กิโลเมตร"
                                      : "ระยะห่าง " +
                                          snapshot.data[index]['distance']
                                              .toStringAsFixed(2) +
                                          " กิโลเมตร",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 8,
                                    fontFamily: 'Sarabun',
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
