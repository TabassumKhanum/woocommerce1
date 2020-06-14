//import './../../../../../l10n/gallery_localizations.dart';
import './../../../../models/app_state_model.dart';
import './../../../../resources/api_provider.dart';
import 'package:flutter/material.dart';

import '../../../color_override.dart';
import '../buttons.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({
    Key key,
    @required this.context,
    @required this.model,
    @required this.emailController,
    @required this.tabController,
  }) : super(key: key);

  final BuildContext context;
  final AppStateModel model;
  final TextEditingController emailController;
  final TabController tabController;

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  final apiProvider = ApiProvider();

  //TextEditingController emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 60.0,
                child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).appBarTheme.iconTheme.color,
                    ),
                    onPressed: () {
                      setState(() {
                        isLoading = false;
                      });
                      widget.tabController.animateTo(0);
                    }),
              ),
              Text(
                'Login',
                style: Theme.of(context).textTheme.headline6,
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
                        controller: widget.emailController,
                        decoration: InputDecoration(
                          labelText: widget.model.blocks.localeText.email,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return widget.model.blocks.localeText.pleaseEnterValidEmail;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 24.0),
                    AccentButton(
                        onPressed: () => _sendOtp(),
                        showProgress: isLoading,
                        text: 'Send Otp'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _sendOtp() async {
    var data = new Map<String, dynamic>();
    if (_formKey.currentState.validate()) {
      data["email"] = widget.emailController.text;
      setState(() {
        isLoading = true;
      });
      final response = await apiProvider.postWithCookies(
          '/wp-admin/admin-ajax.php?action=mstore_flutter-email-otp', data);
      print(response.statusCode);
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200) {
        widget.tabController.animateTo(3);
      }
    }
  }
}

class ResetPassword extends StatefulWidget {
  ResetPassword({
    Key key,
    @required this.context,
    @required this.model,
    @required this.emailController,
    @required this.tabController,
  }) : super(key: key);

  final BuildContext context;
  final AppStateModel model;
  final TextEditingController emailController;
  final TabController tabController;

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  final apiProvider = ApiProvider();

  TextEditingController otpController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 60.0,
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).appBarTheme.iconTheme.color,
                  ),
                  onPressed: () {
                    setState(() {
                      isLoading = false;
                    });
                    widget.tabController.animateTo(0);
                  }),
            ),
            Text(
              widget.model.blocks.localeText.email,
              style: Theme.of(context).textTheme.headline6,
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
                      controller: otpController,
                      decoration: InputDecoration(
                        labelText: widget.model.blocks.localeText.otp,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return widget.model.blocks.localeText.pleaseEnterOtp;
                        }
                        return null;
                      },
                    ),
                  ),
                  PrimaryColorOverride(
                    child: TextFormField(
                      controller: newPasswordController,
                      decoration: InputDecoration(
                        labelText: widget.model.blocks.localeText.newPassword,
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
                      onPressed: () => _resetPassword(widget.model),
                      showProgress: isLoading,
                      text: widget.model.blocks.localeText.resetPassword),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _resetPassword(AppStateModel model) async {
    var data = new Map<String, dynamic>();
    if (_formKey.currentState.validate()) {
      data["email"] = widget.emailController.text;
      data["password"] = newPasswordController.text;
      data["otp"] = otpController.text;
      setState(() {
        isLoading = true;
      });
      print(data);
      final response = await apiProvider.postWithCookies(
          '/wp-admin/admin-ajax.php?action=mstore_flutter-reset-user-password',
          data);
      if (response.statusCode == 200) {
        widget.tabController.animateTo(0);
      }
      setState(() {
        isLoading = false;
      });
    }
    //TODO Call api to send otp
  }
}
