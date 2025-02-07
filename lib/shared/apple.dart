// import 'package:apple_sign_in/apple_sign_in.dart';

// Future<AuthorizationResult> loginApple() async {
//   final AuthorizationResult result = await AppleSignIn.performRequests([
//     AppleIdRequest(
//       requestedScopes: [
//         Scope.email,
//         Scope.fullName,
//       ],
//     )
//   ]);

//   switch (result.status) {
//     case AuthorizationStatus.authorized:
//       // setState(() {
//       //   _imageUrl = '';
//       //   _email = result.credential.email != null
//       //       ? result.credential.email.toString()
//       //       : '';
//       //   // _username = result.credential.email != null
//       //   //     ? result.credential.email.toString()
//       //   //     : result.credential.user.toString();
//       //   _username = result.credential.user.toString();
//       //   _password = '';
//       //   _category = 'apple';
//       //   _prefixName = '';
//       //   _firstName = result.credential.email != null
//       //       ? result.credential.email.toString()
//       //       : '';
//       //   _lastName = '';
//       //   _facebookID = '';
//       //   _lineID = '';
//       //   _appleID = result.credential.user.toString();
//       //   _googleID = '';
//       // });
//       // login();

//       return result;
//       break;
//     case AuthorizationStatus.error:
//       print("Sign in failed: ${result.error.localizedDescription}");
//       return result;
//       break;
//     case AuthorizationStatus.cancelled:
//       print('User cancelled');
//       return result;
//       break;
//     default:
//       return result;
//       break;
//   }
// }
