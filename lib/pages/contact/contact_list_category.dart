import 'package:flutter/material.dart';
import 'package:security_2025_mobile_v3/component/carousel_banner.dart';
import 'package:security_2025_mobile_v3/component/carousel_form.dart';
import 'package:security_2025_mobile_v3/component/header.dart';
import 'package:security_2025_mobile_v3/component/link_url_in.dart';
import 'package:security_2025_mobile_v3/shared/api_provider.dart';
import 'package:security_2025_mobile_v3/pages/contact/contact_list_category_vertical.dart';

class ContactListCategory extends StatefulWidget {
  ContactListCategory({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _ContactListCategory createState() => _ContactListCategory();
}

class _ContactListCategory extends State<ContactListCategory> {
  late ContactListCategoryVertical contact;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  late String keySearch;
  late String category;

  late Future<dynamic> _futureBanner;
  late Future<dynamic> _futureCategoryContact;
  // final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _futureCategoryContact =
        post('${contactCategoryApi}read', {'skip': 0, 'limit': 999});
    _futureBanner = post('${contactBannerApi}read', {'skip': 0, 'limit': 50});

    // _controller.addListener(_scrollListener);
    super.initState();
    // contact = new ContactListCategoryVertical(
    //   site: "DDPM",
    //   model: service
    //       .post('${service.contactCategoryApi}read', {'skip': 0, 'limit': 100}),
    //   title: "",
    //   url: '${service.contactCategoryApi}read',
    // );
  }

  void goBack() async {
    Navigator.pop(context, true);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => Menu(),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, goBack, title: widget.title, rightButton: null),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: ListView(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          children: [
            CarouselBanner(
              model: _futureBanner,
              nav: (String path, String action, dynamic model, String code,
                  String urlGallery) {
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
                        url: contactBannerApi,
                        urlGallery: bannerGalleryApi,
                      ),
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 10),
            ContactListCategoryVertical(
              site: "DDPM",
              model: _futureCategoryContact,
              title: "",
              url: '${contactCategoryApi}read',
            ),
            // Expanded(
            //   child: contact,
            // ),
          ],
        ),
      ),
    );
  }
}
