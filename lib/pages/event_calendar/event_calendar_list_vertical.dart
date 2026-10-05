import 'dart:ui' show ImageFilter;
import 'package:security_2025_mobile_v3/pages/blank_page/blank_loading.dart';
import 'event_utils.dart';
import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/pages/blank_page/blank_data.dart';
import 'package:security_2025_mobile_v3/pages/event_calendar/event_calendar_form.dart';

class EventCalendarListVertical extends StatefulWidget {
  EventCalendarListVertical({
    Key? key,
    required this.site,
    this.keySearch = '',
    this.category = '',
    required this.title,
    required this.url,
    required this.urlComment,
    required this.urlGallery,
  }) : super(key: key);

  final String keySearch;
  final String category;
  final String site;
  final String title;
  final String url;
  final String urlComment;
  final String urlGallery;

  @override
  _EventCalendarListVertical createState() => _EventCalendarListVertical();
}

class _EventCalendarListVertical extends State<EventCalendarListVertical> {
  late Future<List<Map<String, dynamic>>> model;

  @override
  void initState() {
    super.initState();
    model = Future.value(_getMockData());
  }

  List<Map<String, dynamic>> _getMockData() {
    final query = widget.keySearch.trim().toLowerCase();
    return eventCalendarMock.where((event) {
      return (widget.category.isEmpty ||
              event['category'] == widget.category) &&
          (query.isEmpty ||
              '${event['title']} ${event['description']}'
                  .toLowerCase()
                  .contains(query));
    }).toList();
  }

  @override
  void didUpdateWidget(covariant EventCalendarListVertical oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.keySearch != widget.keySearch ||
        oldWidget.category != widget.category) {
      model = Future.value(_getMockData());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: model,
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
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
              padding: EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return myCard(index, snapshot.data![index], context);
                },
              ),
            );
          }
        } else {
          return blankGridData(context);
        }
      },
    );
  }

  Widget myCard(int index, Map<String, dynamic> model, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventCalendarForm(
              urlGallery: widget.urlGallery,
              urlComment: widget.urlComment,
              model: model,
              url: widget.url,
              code: model['code'],
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                height: 157.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    topRight: Radius.circular(5.0),
                  ),
                  color: Colors.white.withAlpha(220),
                ),
                width: double.infinity,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(5)),
                  child: model['imageUrl'] != null &&
                          model['imageUrl'].toString().isNotEmpty
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: ImageFiltered(
                                imageFilter:
                                    ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                                child: Image.network(
                                  model['imageUrl'],
                                  fit: BoxFit.cover,
                                  excludeFromSemantics: true,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const SizedBox.shrink(),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Container(
                                  color: Colors.black.withValues(alpha: 0.15)),
                            ),
                            Image.network(
                              model['imageUrl'],
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      : BlankLoading(
                          height: double.infinity, width: double.infinity),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.topLeft,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5.0),
                  bottomRight: Radius.circular(5.0),
                ),
                color: Colors.black.withAlpha(10),
              ),
              child: Text(
                model['title'],
                style: TextStyle(
                  fontSize: 10,
                  fontFamily: 'Sarabun',
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
