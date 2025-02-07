// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:dio/dio.dart';
// import 'dart:convert';

// final FacebookLogin facebookSignIn = new FacebookLogin();

// dynamic loginFacebook() async {
//   final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

//   switch (result.status) {
//     case FacebookLoginStatus.loggedIn:
//       // final FacebookAccessToken accessToken = result.accessToken;
//       // _showMessage('''
//       //  Logged in!

//       //  Token: ${accessToken.token}
//       //  User id: ${accessToken.userId}
//       //  Expires: ${accessToken.expires}
//       //  Permissions: ${accessToken.permissions}
//       //  Declined permissions: ${accessToken.declinedPermissions}
//       //  ''');

//       Dio dio = new Dio();
//       final token = result.accessToken.token;
//       final graphResponse = await dio.get(
//           'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
//       final profile = graphResponse.data;

//       // var obj = json.decode(profile);
//       // setState(() {
//       //   _facebookId = obj['id'];
//       // });
//       // print(obj['id']);

//       // _showMessage(profile);

//       return json.decode(profile);

//       break;
//     case FacebookLoginStatus.cancelledByUser:
//       return null;
//       // return 'Login cancelled by the user.';
//       // _showMessage('Login cancelled by the user.');
//       break;
//     case FacebookLoginStatus.error:
//       print(result.errorMessage);
//       return null;
//       // return 'Something went wrong with the login process.\n'
//       //     'Here\'s the error Facebook gave us: ${result.errorMessage}';
//       // _showMessage('Something went wrong with the login process.\n'
//       //     'Here\'s the error Facebook gave us: ${result.errorMessage}');
//       break;
//   }
// }

// String imageFacebook(String id) {
//   // new Image.network('https://graph.facebook.com/' + _facebookId + '/picture?type=large&width=720&height=720'),

//   return 'https://graph.facebook.com/' +
//       id +
//       '/picture?type=large&width=720&height=720';
// }

// void logoutFacebook() async {
//   print('----- Logout Facebook -----');
//   await facebookSignIn.logOut();
// }
