//import './../../../../../l10n/gallery_localizations.dart';
import './../../../../models/app_state_model.dart';
import './../../../../models/register_model.dart';
import 'package:flutter/material.dart';

import '../../../color_override.dart';
import '../buttons.dart';

class RegisterTab extends StatefulWidget {
  const RegisterTab({
    Key key,
    @required this.context,
    @required this.model,
    @required this.tabController,
  }) : super(key: key);

  final BuildContext context;
  final AppStateModel model;
  final TabController tabController;

  @override
  _RegisterTabState createState() => _RegisterTabState();
}

class _RegisterTabState extends State<RegisterTab> {
  final _formKey = GlobalKey<FormState>();

  var _register = Register();

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
            widget.model.blocks.localeText.signIn,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(width: 16.0),
          ],
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  PrimaryColorOverride(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: widget.model.blocks.localeText.firstName,
                      ),
                      onSaved: (val) =>
                          setState(() => _register.firstName = val),
                      validator: (value) {
                        if (value.isEmpty) {
                          return widget.model.blocks.localeText.pleaseEnterFirstName;
                        }
                        return null;
                      },
                    ),
                  ),
                  PrimaryColorOverride(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: widget.model.blocks.localeText.lastName,
                      ),
                      onSaved: (val) =>
                          setState(() => _register.lastName = val),
                      validator: (value) {
                        if (value.isEmpty) {
                          return widget.model.blocks.localeText.pleaseEnterLastName;
                        }
                        return null;
                      },
                    ),
                  ),
                  PrimaryColorOverride(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: widget.model.blocks.localeText.phoneNumber,
                      ),
                      onSaved: (val) =>
                          setState(() => _register.phoneNumber = val),
                      validator: (value) {
                        if (value.isEmpty) {
                          return widget.model.blocks.localeText.pleaseEnterPhoneNumber;
                        }
                        return null;
                      },
                    ),
                  ),
                  PrimaryColorOverride(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: widget.model.blocks.localeText.email,
                      ),
                      onSaved: (val) => setState(() => _register.email = val),
                      validator: (value) {
                        if (value.isEmpty) {
                          return widget.model.blocks.localeText.pleaseEnterValidEmail;
                        }
                        return null;
                      },
                    ),
                  ),
                  PrimaryColorOverride(
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: widget.model.blocks.localeText.password,
                      ),
                      onSaved: (val) =>
                          setState(() => _register.password = val),
                      validator: (value) {
                        if (value.isEmpty) {
                          return widget.model.blocks.localeText.pleaseEnterPassword;
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 24.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      AccentButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              setState(() {
                                isLoading = true;
                              });
                              bool status = await widget.model
                                  .register(_register.toJson());
                              setState(() {
                                isLoading = false;
                              });
                              if (status) {
                                Navigator.of(context).pop();
                              }
                            }
                          },
                          showProgress: isLoading,
                          text: widget.model.blocks.localeText.signUp),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  FlatButton(
                      padding: EdgeInsets.all(16.0),
                      onPressed: () {
                        widget.tabController.animateTo(0);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.model.blocks.localeText.alreadyHaveAnAccount,
                              style: Theme.of(context).textTheme.bodyText2),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(widget.model.blocks.localeText.signIn,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        color: Theme.of(context).buttonColor)),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
