import 'package:flutter/material.dart';

checkAvatar(BuildContext context, String? image) {
  if (image != null && image.isNotEmpty) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      backgroundImage: NetworkImage(image),
    );
  } else {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Image.asset(
        'assets/images/user_not_found.png',
        color: Theme.of(context).primaryColorLight,
      ),
    );
  }
}
