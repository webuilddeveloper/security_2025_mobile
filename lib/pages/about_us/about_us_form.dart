import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:security_2025_mobile_v3/component/link_url_out.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class AboutUsForm extends StatefulWidget {
  AboutUsForm({Key? key, required this.model, required this.title})
      : super(key: key);
  final String title;
  final Future<dynamic> model;

  @override
  _AboutUsForm createState() => _AboutUsForm();
}

class _AboutUsForm extends State<AboutUsForm> {
  // final Set<Marker> _markers = {};
  Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
  }

  void goBack() async {
    Navigator.pop(context, false);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => Menu(),
    //   ),
    // );
  }

  void launchURLMap(String lat, String lng) async {
    String homeLat = lat;
    String homeLng = lng;

    final String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=" +
            homeLat +
            ',' +
            homeLng;

    final String encodedURl = Uri.encodeFull(googleMapslocationUrl);

    if (await canLaunch(encodedURl)) {
      await launch(encodedURl);
    } else {
      throw 'Could not launch $encodedURl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
          // return Center(
          //   child: Image.asset(
          //     "assets/background/login.png",
          //     fit: BoxFit.cover,
          //   ),
          // );
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else if (snapshot.hasData) {
            var lat = double.parse(snapshot.data['latitude'] != ''
                ? snapshot.data['latitude']
                : 0.0);
            var lng = double.parse(snapshot.data['longitude'] != ''
                ? snapshot.data['longitude']
                : 0.0);
            return Scaffold(
              appBar: header(context, goBack,
                  title: 'เกี่ยวกับเรา', rightButton: null),
              body: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overScroll) {
                  overScroll.disallowIndicator();
                  return false;
                },
                child: Container(
                  color: Colors.white,
                  child: ListView(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    // controller: _controller,
                    children: [
                      Stack(
                        children: [
                          Container(
                            // padding: EdgeInsets.only(top: 50),
                            // color: Colors.orange,
                            child: Image.network(
                              snapshot.data['imageBgUrl'],
                              height: 350.0,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                          // SubHeader(th: "เกี่ยวกับเรา", en: "About Us"),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                              top: 290.0,
                              left: 15.0,
                              right: 15.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            height: 120.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  // color: Colors.orange,
                                  padding: EdgeInsets.all(5.0),
                                  child: Image.network(
                                    snapshot.data['imageLogoUrl'],
                                    height: 90,
                                    width: 90,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 5.0, right: 5.0),
                                    child: Text(
                                      snapshot.data['title'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Sarabun',
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      rowData(
                        image: Image.asset(
                          "assets/logo/icons/Group56.png",
                        ),
                        title: snapshot.data['address'] ?? '',
                      ),
                      rowData(
                        image: Image.asset(
                          "assets/logo/icons/Path34.png",
                        ),
                        title: snapshot.data['telephone'] ?? '',
                        value: '${snapshot.data['telephone']}',
                        typeBtn: 'phone',
                      ),
                      rowData(
                        image: Image.asset(
                          "assets/logo/icons/Group62.png",
                        ),
                        title: snapshot.data['email'] ?? '',
                        value: '${snapshot.data['email']}',
                        typeBtn: 'email',
                      ),
                      rowData(
                        image: Image.asset(
                          "assets/logo/icons/Group369.png",
                        ),
                        title: snapshot.data['site'] ?? '',
                        value: '${snapshot.data['site']}',
                        typeBtn: 'link',
                      ),
                      rowData(
                        image: Image.asset(
                          "assets/logo/icons/Group356.png",
                        ),
                        title: snapshot.data['facebook'] ?? '',
                        value: '${snapshot.data['facebook']}',
                        typeBtn: 'link',
                      ),
                      rowData(
                        image: Image.asset(
                          "assets/logo/icons/youtube.png",
                        ),
                        title: snapshot.data['youtube'] ?? '',
                        value: '${snapshot.data['youtube']}',
                        typeBtn: 'link',
                      ),
                      rowData(
                        image: Image.asset(
                          "assets/logo/socials/Group331.png",
                        ),
                        title: snapshot.data['lineOfficial'] ?? '',
                        value: '${snapshot.data['lineOfficial']}',
                        typeBtn: 'link',
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      // googleMap(lat, lng),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: double.infinity,
                        child: googleMap(lat, lng),
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        color: Colors.transparent,
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width,
                              onPressed: () {
                                launchURLMap(lat.toString(), lng.toString());
                              },
                              child: Text(
                                'ตำแหน่ง Google Map',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: 'Sarabun',
                                  fontSize: 15.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return MaterialApp(
              title: "About Us",
              home: Scaffold(
                appBar: header(context, goBack,
                    title: 'เกี่ยวกับเรา', rightButton: null),
                body: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overScroll) {
                    overScroll.disallowIndicator();
                    return false;
                  },
                  child: ListView(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    // controller: _controller,
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 50),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            // color: Colors.orange,
                            child: Image.network('',
                                height: 350,
                                width: double.infinity,
                                fit: BoxFit.cover),
                          ),
                          // SubHeader(th: "เกี่ยวกับเรา", en: "About Us"),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                                top: 350.0, left: 15.0, right: 15.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            height: 120.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  // color: Colors.orange,
                                  padding: EdgeInsets.symmetric(vertical: 17.0),
                                  child: Image.asset(
                                    "assets/logo/logo.png",
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 10.0, right: 5.0),
                                    child: Text(
                                      'สหกรณ์ออมทรัพท์ตำรวจทางหลวง จำกัด',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'Sarabun',
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      rowData(
                        image: Image.asset(
                          "assets/logo/icons/Group56.png",
                        ),
                        title: '-',
                      ),
                      rowData(
                        image: Image.asset(
                          "assets/logo/icons/Path34.png",
                        ),
                        title: '-',
                      ),
                      rowData(
                        image: Image.asset(
                          "assets/logo/icons/Group62.png",
                        ),
                        title: '-',
                      ),
                      rowData(
                        image: Image.asset(
                          "assets/logo/icons/Group369.png",
                        ),
                        title: '-',
                      ),
                      rowData(
                        image: Image.asset(
                          "assets/logo/icons/Group356.png",
                        ),
                        title: '-',
                      ),
                      rowData(
                        image: Image.asset(
                          "assets/logo/icons/youtube.png",
                        ),
                        title: '-',
                      ),
                      rowData(
                        image: Image.asset(
                          "assets/logo/socials/Group331.png",
                        ),
                        title: '-',
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Container(
                        height: 300,
                        width: double.infinity,
                        child: googleMap(13.8462512, 100.5234803),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
      },
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
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        new Factory<OneSequenceGestureRecognizer>(
          () => new EagerGestureRecognizer(),
        ),
      ].toSet(),
      onMapCreated: (GoogleMapController controller) {
        controller.moveCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
                southwest: LatLng(lat - 0.05, lng - 0.08),
                northeast: LatLng(lat + 0.05, lng + 0.05)),
            5.0,
          ),
        );
        controller.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, lng), tilt: 10, zoom: 15)));
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

  Widget rowData({
    required Image image,
    String title = '',
    String value = '',
    String typeBtn = '',
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Container(
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15)),
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: image,
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => typeBtn != ''
                  ? typeBtn == 'email'
                      ? launchURL('mailto:' + value)
                      : typeBtn == 'phone'
                          ? launch('tel://' + value)
                          : typeBtn == 'link'
                              ? launchURL(value)
                              : null
                  : null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Sarabun',
                    fontSize: 10,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
