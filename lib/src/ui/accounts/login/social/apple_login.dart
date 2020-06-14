import './../../../../models/app_state_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

class AppleLogin extends StatelessWidget {

  final appStateModel = AppStateModel();

  AppleLogin({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: StadiumBorder(),
      margin: EdgeInsets.all(4),
      color: Theme.of(context).brightness == Brightness.dark ? Color(0xFFFFFFFF) : Color(0xFF000000),
      child: Container(
        height: 50,
        width: 50,
        child: IconButton(
          //splashRadius: 25.0,
          icon: Icon(
            FontAwesomeIcons.apple,
            size: 20,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
          ),
          onPressed: () {
            appleLogIn(context);
          },
        ),
      ),
    );
  }

  appleLogIn(BuildContext context) async {
    if (await AppleSignIn.isAvailable()) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:

          var login = new Map<String, dynamic>();
          if(result.credential.email != null)
            login["email"] = result.credential.email;
          else login["email"] = result.credential.user;
          if(result.credential.fullName.givenName != null)
            login["name"] = result.credential.fullName.givenName;
          else login["name"] = '';

          bool status = await appStateModel.googleLogin(login);

          if (status) {
            Navigator.of(context).pop();
          }

          break; //All the required credentials
        case AuthorizationStatus.error:
          break;
        case AuthorizationStatus.cancelled:
          break;
      }
    } else {

    }
  }
}