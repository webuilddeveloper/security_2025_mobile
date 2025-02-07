import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:security_2025_mobile_v3/component/gallery_view.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:security_2025_mobile_v3/shared/extension.dart';

// ignore: must_be_immutable
class ContentPoi extends StatefulWidget {
  ContentPoi({
    Key? key,
    required this.code,
    required this.url,
    this.model,
    required this.urlGallery,
    required this.pathShare,
  }) : super(key: key);

  final String code;
  final String url;
  final dynamic model;
  final String urlGallery;
  final String pathShare;

  @override
  _ContentPoi createState() => _ContentPoi();
}

class _ContentPoi extends State<ContentPoi> {
  late Future<dynamic> _futureModel;

  String _urlShared = '';
  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];

  Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
    _futureModel = post(widget.url, {
      'skip': 0,
      'limit': 1,
      'code': widget.code,
      'latitude': 0.0,
      'longitude': 0.0
    });

    readGallery();
    sharedApi();
  }

  Future<dynamic> readGallery() async {
    final result =
        await postObjectData(widget.urlGallery, {'code': widget.code});

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

  Future<dynamic> sharedApi() async {
    await postConfigShare().then((result) => {
          if (result['status'] == 'S')
            {
              setState(() {
                _urlShared = result['objectData']['description'];
              }),
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.hasData) {
          // setState(() {
          //   urlImage = [snapshot.data[0].imageUrl];
          // });
          return myContentPoi(
            snapshot.data[0],
          ); //   return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasError) {
          return Container(
            height: 500,
            color: Colors.white,
            width: double.infinity,
          );
          // return myContentPoi(widget.model);
        } else {
          return myContentPoi(
            widget.model,
          );
        }
      },
    );
  }

  myContentPoi(dynamic model) {
    List image = ['${model['imageUrl']}'];
    List<ImageProvider> imagePro = [
      model['imageUrl'] != null
          ? NetworkImage(model['imageUrl'])
          : AssetImage('assets/images/placeholder.png') as ImageProvider<Object>
    ];
    return ListView(
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
                    backgroundImage: model['imageUrlCreateBy'] != null
                        ? NetworkImage(model['imageUrlCreateBy'])
                        : null,
                    // child: Image.network(
                    //     '${snapshot.data[0]['imageUrlCreateBy']}'),
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
                              dateStringToDate(model['createDate']) + ' | ',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Sarabun',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              'เข้าชม ' + '${model['view']}' + ' ครั้ง',
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
            Container(
              width: 74.0,
              height: 31.0,
              // decoration: BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage('assets/images/share.png'),
              //     )),
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  final RenderBox? box =
                      context.findRenderObject() as RenderBox?;
                  Share.share(
                    _urlShared +
                        widget.pathShare +
                        '${model['code']}' +
                        ' ${model['title']}',
                    subject: '${model['title']}',
                    sharePositionOrigin:
                        box!.localToGlobal(Offset.zero) & box.size,
                  );
                },
                child: Image.asset('assets/images/share.png'),
              ),
            )
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
          child: new html.Html(
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
        Padding(
          padding: const EdgeInsets.only(
            right: 10,
            left: 10,
          ),
          child: Text(
            'ที่ตั้ง',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'Sarabun',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 10,
            left: 10,
          ),
          child: Text(
            model['address'] != '' ? model['address'] : '-',
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'Sarabun',
            ),
          ),
        ),
        Container(
          height: 250,
          width: double.infinity,
          child: googleMap(
              model['latitude'] != ''
                  ? double.parse(model['latitude'])
                  : 13.8462512,
              model['longitude'] != ''
                  ? double.parse(model['longitude'])
                  : 100.5234803),
        ),
      ],
    );
  }

  googleMap(double lat, double lng) {
    return GoogleMap(
      myLocationEnabled: true,
      compassEnabled: true,
      tiltGesturesEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(lat, lng),
        zoom: 15,
      ),
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        new Factory<OneSequenceGestureRecognizer>(
          () => new EagerGestureRecognizer(),
        ),
      ].toSet(),
      onMapCreated: (GoogleMapController controller) {
        controller.moveCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
                southwest: LatLng(lat - 0.08, lng - 0.11),
                northeast: LatLng(lat + 0.08, lng + 0.08)),
            5.0,
          ),
        );
        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, lng), zoom: 16)));
        _mapController.complete(controller);
      },
      // onTap: _handleTap,
      markers: <Marker>[
        Marker(
          markerId: MarkerId('1'),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      ].toSet(),
    );
  }
}
