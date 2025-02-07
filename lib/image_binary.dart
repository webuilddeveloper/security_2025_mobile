import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'shared/api_provider.dart';
import 'widget/header.dart';

class ImageBinaryPage extends StatefulWidget {
  @override
  _ImageBinaryPageState createState() => _ImageBinaryPageState();
}

class _ImageBinaryPageState extends State<ImageBinaryPage> {
  late Future<dynamic> future1Model;
  late Future<dynamic> future2Model;
  late Future<dynamic> future3Model;

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<dynamic>(
              future: future1Model,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                      image: new DecorationImage(
                          image: MemoryImage(test(snapshot.data))),
                      // image: MemoryImage(test(snapshot.data['bytes']))),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Container();
                } else {
                  return Container(
                    child: Text('loading'),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<dynamic>(
              future: future2Model,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                      image: new DecorationImage(
                          image: MemoryImage(test(snapshot.data))),
                      // image: MemoryImage(test(snapshot.data['bytes']))),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Container();
                } else {
                  return Container(
                    child: Text('loading'),
                  );
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<dynamic>(
              future: future3Model,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                      image: new DecorationImage(
                          image: MemoryImage(test(snapshot.data))),
                      // image: MemoryImage(test(snapshot.data['bytes']))),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Container();
                } else {
                  return Container(
                    child: Text('loading'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  _callRead() {
    // futureModel = postDioMessage2(server + 'imagebinary/read', {});
    // future1Model = getDio(
    //     'http://202.139.196.6:8088/khubdee-ptm/ptminternal/image1/0262061608726',
    //     '');

    // future2Model = getDio(
    //     'http://202.139.196.6:8088/khubdee-ptm/ptminternal/image2/0262061608726',
    //     '');

    // future3Model = getDio(
    //     'http://202.139.196.6:8088/khubdee-ptm/ptminternal/image3/0262061608726',
    //     '');

    future1Model = getDio('${serverMW}ptminternal/image1/0262061608726', '');

    future2Model = getDio('${serverMW}ptminternal/image2/0262061608726', '');

    future3Model = getDio('${serverMW}ptminternal/image3/0262061608726', '');
  }

  test(param) {
    List<int> bytesList = base64.decode(param);
    return bytesList;
  }
}
