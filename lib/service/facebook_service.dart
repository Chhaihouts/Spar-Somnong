import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

var profileData;
var facebookLogin = FacebookLogin();

String name;
String email;
String imageUrl;
String facebookToken;

void initiateFacebookLogin() async {
  var facebookLoginResult =
      await facebookLogin.logInWithReadPermissions(['email']);

  switch (facebookLoginResult.status) {
    case FacebookLoginStatus.error:
      break;
    case FacebookLoginStatus.cancelledByUser:
      break;
    case FacebookLoginStatus.loggedIn:
      var accessToken = facebookLoginResult.accessToken.token;
      var facebookAuth =
          FacebookAuthProvider.getCredential(accessToken: accessToken);
      var authResult =
          await FirebaseAuth.instance.signInWithCredential(facebookAuth);
      authResult.user.getIdToken(refresh: true).then((onValue) {
        facebookToken = onValue.toString();
      });

      break;
  }
}
