import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ReporterMap extends StatefulWidget {
  ReporterMap({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _ReporterMap createState() => _ReporterMap();
}

class _ReporterMap extends State<ReporterMap> {
  Completer<GoogleMapController> _mapController = Completer();

  final txtDescription = TextEditingController();
  bool hideSearch = true;
  String keySearch = '';
  String category = '';
  int _limit = 10;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late Future<dynamic> _futureReporter;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _futureReporter = post('${reporterApi}read', {'skip': 0, 'limit': 50});
  }

  void _onLoading() async {
    setState(() {
      _limit = _limit + 10;
      _futureReporter = post('${reporterApi}read', {
        'skip': 0,
        'limit': 50,
        // 'category': category,
        // "keySearch": keySearch
      });
    });

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context, false);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => Menu(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: header(context, goBack, title: widget.title, rightButton: null),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: SmartRefresher(
          enablePullDown: false,
          enablePullUp: true,
          footer: ClassicFooter(
            loadingText: ' ',
            canLoadingText: ' ',
            idleText: ' ',
            idleIcon: Icon(
              Icons.arrow_upward,
              color: Colors.transparent,
            ),
          ),
          controller: _refreshController,
          onLoading: _onLoading,
          child: ListView(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.only(bottom: 10.0),
                width: double.infinity,
                child: googleMap(_futureReporter),
              ),
            ],
          ),
        ),
      ),
    );
  }

  googleMap(modelData) {
    List<Marker> _markers = <Marker>[];

    return FutureBuilder<dynamic>(
      future: modelData, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            snapshot.data
                .map(
                  (item) => item['latitude'] != '' && item['longitude'] != ''
                      ? _markers.add(
                          Marker(
                            markerId: MarkerId(item['code']),
                            position: LatLng(
                              double.parse(item['latitude']),
                              double.parse(item['longitude']),
                            ),
                            infoWindow: InfoWindow(
                              title: item['title'].toString(),
                            ),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueRed,
                            ),
                          ),
                        )
                      : null,
                )
                .toList();
          }

          return GoogleMap(
            myLocationEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(13.743894, 100.538592),
              zoom: 7,
            ),
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              new Factory<OneSequenceGestureRecognizer>(
                () => new EagerGestureRecognizer(),
              ),
            ].toSet(),
            onMapCreated: (GoogleMapController controller) {
              _mapController.complete(controller);
            },
            markers: snapshot.data.length > 0
                ? _markers.toSet()
                : <Marker>[
                    Marker(
                      markerId: MarkerId('1'),
                      position: LatLng(0.00, 0.00),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed,
                      ),
                    ),
                  ].toSet(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
