import './../../../../models/app_state_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

class GoogleLoginWidget extends StatelessWidget {

  final appStateModel = AppStateModel();

  GoogleLoginWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: StadiumBorder(),
      margin: EdgeInsets.all(4),
      color: Color(0xFFEA4335),
      child: Container(
        height: 50,
        width: 50,
        child: Center(
          child: IconButton(
           // splashRadius: 25.0,
            icon: Icon(
              FontAwesomeIcons.google,
              size: 20,
              color: Colors.white,
            ),
            onPressed: () {
              _googleLogin(context);
            },
          ),
        ),
      ),
    );
  }

  void _googleLogin(BuildContext context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    var login = new Map<String, dynamic>();
    login["name"] = googleUser.displayName;
    login["email"] = googleUser.email;
    bool status = await appStateModel.googleLogin(login);
    if (status) {
      Navigator.of(context).pop();
    }
  }

}