import './../../../../models/app_state_model.dart';
import './../../../accounts/login/social/apple_login.dart';
import './../../../accounts/login/social/facebook_login.dart';
import './../../../accounts/login/social/google_login.dart';
import './../../../accounts/login/social/sms_login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../color_override.dart';
import '../buttons.dart';

class LoginTab extends StatefulWidget {

  LoginTab({
    Key key,
    @required this.context,
    @required this.model,
    @required this.tabController,
  }) : super(key: key);

  final BuildContext context;
  final AppStateModel model;
  final TabController tabController;

  @override
  _LoginTabState createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 60.0,
              child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).appBarTheme.iconTheme.color,),
                  onPressed: () =>
                      Navigator.pop(context)),
            ),
            Text(
              widget.model.blocks.localeText.account,
              style: Theme.of(context).textTheme.headline6.copyWith(
                fontWeight: FontWeight.w600
              ),
            ),
            const SizedBox(width: 16.0),
          ],
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: new Form(
              key: _formKey,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PrimaryColorOverride(
                    child: TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: widget.model.blocks.localeText.username,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return widget.model.blocks.localeText.pleaseEnterUsername;
                        }
                        return null;
                      },
                    ),
                  ),
                  PrimaryColorOverride(
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: widget.model.blocks.localeText.password,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return widget.model.blocks.localeText.pleaseEnterPassword;
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 24.0),
                  AccentButton(
                      onPressed: () => _login(),
                      showProgress: isLoading,
                      text: widget.model.blocks.localeText.signIn),
                  SizedBox(height: 12.0),
                  FlatButton(
                      onPressed: () {
                        widget.tabController.animateTo(2);
                      },
                      child: Text(widget.model.blocks.localeText.forgotPassword, style: Theme.of(context).textTheme.bodyText2)),
                  FlatButton(
                      padding: EdgeInsets.all(16.0),
                      onPressed: () {
                        widget.tabController.animateTo(1);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.model.blocks.localeText.dontHaveAnAccount, style: Theme.of(context).textTheme.bodyText2),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(widget.model.blocks.localeText.signUp, style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: Theme.of(context).buttonColor
                            )),
                          ),
                        ],
                      )),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GoogleLoginWidget(),
                        FacebookLoginWidget(),
                        //
                        AppleLogin(),
                        SmsLogin(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _login() async {
    var login = new Map<String, dynamic>();
    if (_formKey.currentState.validate()) {
      login["username"] = usernameController.text;
      login["password"] = passwordController.text;
      setState(() {
        isLoading = true;
      });
      bool status = await widget.model.login(login);
      setState(() {
        isLoading = false;
      });
      if (status) {
        Navigator.of(widget.context).pop();
      }
    }
  }
}