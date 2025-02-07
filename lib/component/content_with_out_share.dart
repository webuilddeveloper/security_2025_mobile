import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:security_2025_mobile_v3/component/carousel_form.dart';
import 'package:security_2025_mobile_v3/component/carousel_rotation.dart';
import 'package:security_2025_mobile_v3/component/link_url_in.dart';
import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/gallery_view.dart';
import 'package:security_2025_mobile_v3/component/link_url_out.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:security_2025_mobile_v3/shared/extension.dart';

// ignore: must_be_immutable
class ContentWithOutShare extends StatefulWidget {
  ContentWithOutShare({
    Key? key,
    required this.code,
    required this.url,
    this.model,
    required this.urlGallery,
    required this.urlRotation,
  }) : super(key: key);

  final String code;
  final String url;
  final dynamic model;
  final String urlGallery;
  final String urlRotation;

  @override
  _ContentWithOutShare createState() => _ContentWithOutShare();
}

class _ContentWithOutShare extends State<ContentWithOutShare> {
  late Future<dynamic> _futureModel;
  late Future<dynamic> _futureRotation;
  final storage = new FlutterSecureStorage();

  String _urlShared = '';
  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];

  @override
  void initState() {
    super.initState();
    initFunc();

    readGallery();
  }

  initFunc() async {
    _futureModel =
        postDio(widget.url, {'skip': 0, 'limit': 1, 'code': widget.code});
    _futureRotation = postDio(widget.urlRotation, {'limit': 10});
  }

  Future<dynamic> readGallery() async {
    final result = await postDio(widget.urlGallery, {'code': widget.code});

    // if (result['status'] == 'S') {
    List data = [];
    List<ImageProvider> dataPro = [];

    for (var item in result) {
      data.add(item['imageUrl']);

      dataPro.add(
        (item['imageUrl'] != null ? NetworkImage(item['imageUrl']) : null)
            as ImageProvider<Object>,
      );
    }
    setState(() {
      urlImage = data;
      urlImageProvider = dataPro;
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return myContentWithOutShare(
      widget.model,
    );
  }

  myContentWithOutShare(dynamic model) {
    List image = ['${model['imageUrl']}'];
    List<ImageProvider> imagePro = [
      model['imageUrl'] != null
          ? NetworkImage(model['imageUrl'])
          : AssetImage('assets/default_image.png') as ImageProvider<Object>
    ];
    return ListView(
      shrinkWrap: true, // 1st add
      physics: ClampingScrollPhysics(), // 2nd
      children: [
        Container(
          // width: 500.0,
          // color: Color(0xFFFFFFF),
          color: Colors.white,
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
              fontFamily: 'Kanit',
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(model['imageUrlCreateBy']),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${model['createBy']}',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 3,
                        ),
                        Row(
                          children: [
                            Text(
                              model['createDate'] != null
                                  ? dateStringToDate(model['createDate'])
                                  // + ' | '
                                  : '',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            // Text(
                            //   'เข้าชม ' + '${model['view']}' + ' ครั้ง',
                            //   style: TextStyle(
                            //     fontSize: 10,
                            //     fontFamily: 'Kanit',
                            //     fontWeight: FontWeight.w300,
                            //   ),
                            // ),
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
        Padding(
          padding: const EdgeInsets.only(
            right: 10,
            left: 10,
          ),
          child: new Html(
            data: model['description'],
            onLinkTap: (String? url, Map<String, String> attributes, element) {
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
        Container(
          height: 10,
        ),
        model['linkUrl'] != '' ? linkButton(model) : Container(),
        Container(
          height: 10,
        ),
        model['fileUrl'] != '' ? fileUrl(model) : Container(),
        SizedBox(height: 10),
        if (widget.urlRotation != '') _buildRotation()
      ],
    );
  }

  linkButton(dynamic model) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 45.0,
      padding: EdgeInsets.symmetric(horizontal: 80.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              color: Color(0xFF1B6CA8),
            ),
          ),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              launchURL('${model['linkUrl']}');
            },
            child: Text(
              '${model['textButton']}',
              style: TextStyle(
                color: Color(0xFF1B6CA8),
                fontFamily: 'Kanit',
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ),
    );
  }

  fileUrl(dynamic model) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          launchURL('${model['fileUrl']}');
        },
        child: Text(
          'เปิดเอกสารแนบ',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 14.0,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  _buildRotation() {
    return Container(
      // padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      child: CarouselRotation(
        model: _futureRotation,
        nav: (String path, String action, dynamic model, String code) {
          if (action == 'out') {
            launchInWebViewWithJavaScript(path);
            // launchURL(path);
          } else if (action == 'in') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CarouselForm(
                  code: code,
                  model: model,
                  url: mainBannerApi,
                  urlGallery: bannerGalleryApi,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
