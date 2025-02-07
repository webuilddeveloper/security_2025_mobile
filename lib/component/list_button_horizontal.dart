import 'package:flutter/material.dart';

class ListButtonHorizontal extends StatefulWidget {
  ListButtonHorizontal(
      {Key? key,
      required this.title,
      required this.imageUrl,
      required this.model,
      required this.navigationList,
      required this.navigationForm,
      required this.buttonColor,
      required this.textColor,
      required this.buttonSize,
      required this.imageSize,
      required this.maxItem})
      : super(key: key);

  final String title;
  final String imageUrl;
  final Future<dynamic> model;
  final Color buttonColor;
  final Color textColor;
  final double buttonSize;
  final double imageSize;
  final int maxItem;
  final Function navigationList;
  final Function(String) navigationForm;

  @override
  _ListButtonHorizontal createState() => _ListButtonHorizontal();
}

class _ListButtonHorizontal extends State<ListButtonHorizontal> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: widget.model, // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.only(left: 15, right: 5.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFC5DAFC),
                                Color(0xFF000070),
                              ],
                              begin: Alignment.topLeft,
                              end: new Alignment(1, 0.0),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          height: 40,
                          width: 40,
                          child: Container(
                            child: Image.network(
                              widget.imageUrl,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              color: Color(0xFF000070),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: 'Sarabun',
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        widget.navigationList();
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(right: 15),
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(
                          'ดูทั้งหมด',
                          style: TextStyle(
                            color: Color(0xFFFFC324),
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: 'Sarabun',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.maxItem == 0
                        ? snapshot.data.length
                        : widget.maxItem,
                    itemBuilder: (context, index) {
                      return myCircle(
                          title: snapshot.data[index]['title'],
                          image: snapshot.data[index]['imageUrl'],
                          phone: snapshot.data[index]['phone'],
                          backgroundColor: widget.buttonColor,
                          textColor: widget.textColor,
                          buttonSize: widget.buttonSize,
                          imageSize: widget.imageSize,
                          navigationForm: widget.navigationForm);
                    },
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 15),
                      margin: EdgeInsets.only(bottom: 5),
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: Color(0xFF000070),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'Sarabun',
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        widget.navigationList();
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(right: 15),
                        margin: EdgeInsets.only(bottom: 5),
                        child: Text(
                          'ดูทั้งหมด',
                          style: TextStyle(
                            color: Color(0xFFFFC324),
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: 'Sarabun',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return myCircle(
                          backgroundColor: Colors.white,
                          textColor: Colors.white,
                          buttonSize: widget.buttonSize,
                          imageSize: widget.imageSize,
                          navigationForm: widget.navigationForm);
                    },
                  ),
                ),
              ],
            );
          }
        });
  }
}

myCircle(
    {String title = '',
    String image = '',
    String phone = '',
    required Color backgroundColor,
    required Color textColor,
    double buttonSize = 40.0,
    double imageSize = 40.0,
    required Function navigationForm}) {
  return Container(
    padding: EdgeInsets.all(5),
    child: Column(
      children: [
        InkWell(
          onTap: () {
            navigationForm(phone);
          },
          child: CircleAvatar(
              backgroundColor: backgroundColor,
              // radius: buttonSize,
              radius: 40,
              backgroundImage: NetworkImage(image)
              // child: image != ''
              //     ? Image.network(
              //         image,
              //         width: imageSize,
              //         height: imageSize,
              //       )
              //     : Container(
              //         width: imageSize,
              //         height: imageSize,
              //       ),
              ),
        ),
        Container(
          width: 85.0,
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: textColor,
              fontFamily: 'Sarabun',
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}
