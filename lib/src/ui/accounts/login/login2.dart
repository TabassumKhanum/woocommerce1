import './../../../models/app_state_model.dart';
import './../../accounts/login/buttons.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../color_override.dart';
import 'tabs/forgot_password.dart';
import 'tabs/login_tab.dart';
import 'tabs/register_tab.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController emailController = new TextEditingController();

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 4);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              return DefaultTabController(
                length: 4,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    LoginTab(
                        context: context,
                        model: model,
                        tabController: _tabController),
                    RegisterTab(
                        context: context,
                        model: model,
                        tabController: _tabController),
                    ForgotPassword(
                        context: context,
                        model: model,
                        emailController: emailController,
                        tabController: _tabController),
                    ResetPassword(
                        context: context,
                        model: model,
                        emailController: emailController,
                        tabController: _tabController),
                  ],
                ),
              ); //widget(child: buildCartStack(context, localTheme, model));
            },
          ),
        ),
      ),
    );
  }
}