import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'package:security_2025_mobile_v3/component/button_close_back.dart';
import 'package:security_2025_mobile_v3/component/gallery_view.dart';
import 'package:security_2025_mobile_v3/component/link_url_out.dart';
import 'package:security_2025_mobile_v3/pages/blank_page/blank_loading.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:security_2025_mobile_v3/shared/extension.dart';

class PrivilegeForm extends StatefulWidget {
  PrivilegeForm({Key? key, required this.code, this.model}) : super(key: key);
  final String code;
  final dynamic model;

  @override
  _PrivilegeDetailPageState createState() =>
      _PrivilegeDetailPageState(code: code);
}

class _PrivilegeDetailPageState extends State<PrivilegeForm> {
  _PrivilegeDetailPageState({required this.code});

  late Future<dynamic> _futureModel;
  // String _urlShared = '';
  String code;
  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];

  @override
  void initState() {
    super.initState();
    _futureModel = post(
        '${privilegeApi}read', {'skip': 0, 'limit': 1, 'code': widget.code});
  }

  Future<dynamic> readGallery() async {
    final result =
        await postObjectData('m/news/gallery/read', {'code': widget.code});

    if (result['status'] == 'S') {
      List data = [];
      List<ImageProvider> dataPro = [];

      for (var item in result['objectData']) {
        data.add(item['imageUrl']);

        dataPro.add((item['imageUrl'] != null
            ? NetworkImage(item['imageUrl'])
            : null) as ImageProvider<Object>);
      }
      setState(() {
        urlImage = data;
        urlImageProvider = dataPro;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: Colors.transparent,
    // ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<dynamic>(
        future: _futureModel, // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // AsyncSnapshot<Your object type>

          if (snapshot.hasData) {
            print(
                '------------------${snapshot.data.toString()}----------------');
            return myContent(snapshot.data[0]);
          } else {
            if (widget.model != null) {
              return myContent(widget.model);
            } else {
              return BlankLoading(
                width: null,
                height: null,
              );
            }
          }
        },
      ),
    );
  }

  myContent(dynamic model) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    List image = ['${model['imageUrl']}'];
    List<ImageProvider> imagePro = [
      if (model['imageUrl'] != null)
        NetworkImage(model['imageUrl'])
      else
        AssetImage('assets/default_image.png')
    ];
    // return Container();
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView(
        shrinkWrap: true,
        children: [
          Stack(
            children: [
              Container(
                child: ListView(
                  shrinkWrap: true, // 1st add
                  physics: ClampingScrollPhysics(), // 2nd
                  children: [
                    Container(
                      // width: 500.0,
                      color: Color(0xFFFFFFF),
                      child: GalleryView(
                        imageUrl: [...image, ...urlImage],
                        imageProvider: [...imagePro, ...urlImageProvider],
                      ),
                    ),
                    Container(
                      // color: Colors.green,
                      padding: EdgeInsets.only(
                        right: 10.0,
                        left: 10.0,
                      ),
                      margin: EdgeInsets.only(right: 50.0, top: 10.0),
                      child: Text(
                        '${model['title']}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'Sarabun',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 10,
                            left: 10,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: model['imageUrlCreateBy'] !=
                                        null
                                    ? NetworkImage(model['imageUrlCreateBy'])
                                    : null,
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model['createBy'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Sarabun',
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          dateStringToDate(
                                                  model['createDate']) +
                                              ' | ',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'Sarabun',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        Text(
                                          'เข้าชม ' +
                                              '${model['view']}' +
                                              ' ครั้ง',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontFamily: 'Sarabun',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        right: 10,
                        left: 10,
                      ),
                      child: new Html(
                        data: model['description'],
                        onLinkTap: (String? url, Map<String, String> attributes,
                            element) {
                          launch(url!);
                          //open URL in webview, or launch URL in browser, or any other logic here
                        },
                      ),

                      // HtmlView(
                      //   data: model['description'],
                      //   scrollable:
                      //       false, //false to use MarksownBody and true to use Marksown
                      // ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 80.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(color: Color(0xFFFF7514))),
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
                            onPressed: () {
                              launchURL(model['linkUrl']);
                            },
                            child: Text(
                              'อ่านข่าวต้นฉบับ',
                              style: TextStyle(
                                color: Color(0xFFFF7514),
                                fontFamily: 'Sarabun',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: statusBarHeight + 5,
                child: Container(
                  child: buttonCloseBack(context),
                ),
              ),
            ],
            // overflow: Overflow.clip,
          ),
        ],
      ),
    );
  }
}
