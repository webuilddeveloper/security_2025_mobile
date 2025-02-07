import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
// import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:security_2025_mobile_v3/component/gallery_view.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:security_2025_mobile_v3/shared/extension.dart';

// ignore: must_be_immutable
class ContentReporter extends StatefulWidget {
  ContentReporter({
    Key? key,
    required this.code,
    required this.url,
    this.model,
    required this.urlGallery,
  }) : super(key: key);

  final String code;
  final String url;
  final dynamic model;
  final String urlGallery;

  @override
  _ContentReporter createState() => _ContentReporter();
}

class _ContentReporter extends State<ContentReporter> {
  late Future<dynamic> _futureModel;

  // String _urlShared = '';
  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];

  Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
    _futureModel =
        post(widget.url, {'skip': 0, 'limit': 1, 'code': widget.code});

    readGallery();
    // sharedApi();
  }

  Future<dynamic> readGallery() async {
    final result =
        await postObjectData('m/Reporter/gallery/read', {'code': widget.code});

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

  // Future<dynamic> sharedApi() async {
  //   final result = await postObjectData('configulation/shared/read',
  //       {'skip': 0, 'limit': 1, 'code': widget.code});

  //   if (result['status'] == 's') {
  //     setState(() {
  //       _urlShared = result['objectData']['description'].toString();
  //     });
  //   }
  // }

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
          return myContentReporter(
            snapshot.data[0],
          ); //   return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // return Container();
          return myContentReporter(
            widget.model,
          );
          // return myContentReporter(widget.model);
        }
      },
    );
  }

  myContentReporter(dynamic model) {
    List image = [];
    List<ImageProvider> imagePro = [];
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
                    backgroundImage: '${model['imageUrlCreateBy']}' != null
                        ? NetworkImage('${model['imageUrlCreateBy']}')
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
                          '${model['firstName']} ${model['lastName']}',
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
          zoom: 16,
        ),
        // gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        //   new Factory<OneSequenceGestureRecognizer>(
        //     () => new EagerGestureRecognizer(),
        //   ),
        // ].toSet(),
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
        },
        markers: <google_maps.Marker>[
          google_maps.Marker(
            markerId: google_maps.MarkerId('1'),
            position: LatLng(lat, lng),
            icon: google_maps.BitmapDescriptor.defaultMarkerWithHue(
                google_maps.BitmapDescriptor.hueRed),
          ),
        ].toSet());
  }
}
