import './../../../shrine/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/app_state_model.dart';
import '../../../ui/accounts/settings/settings.dart';
import '../../../ui/accounts/settings/settings_list_item.dart';
import '../../../blocs/home_bloc.dart';
import '../../../models/blocks_model.dart';
import '../../../models/post_model.dart';
import '../../../ui/accounts/address/customer_address.dart';
import '../../../ui/accounts/currency.dart';
import '../../../ui/accounts/language/language.dart';
import '../login/login.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../ui/accounts/orders/order_list.dart';
import '../../../ui/accounts/wishlist.dart';
import '../../options.dart';
import '../post_detail.dart';
import '../register.dart';
import 'dart:io' show Platform;
import 'dart:collection';
import '../try_demo.dart';
//import 'package:flutter/dart:html';

class UserAccount extends StatefulWidget {
  final HomeBloc homeBloc;
  final appStateModel = AppStateModel();

  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.dark,
  );

  UserAccount({Key key, this.homeBloc}) : super(key: key);
  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  @override
  int _cIndex = 0;
  bool switchControl = false;

  Widget build(BuildContext context) {
    var borderDecoration = BoxDecoration(
        color: Theme.of(context).appBarTheme.color,
        borderRadius: new BorderRadius.all(Radius.circular(4.0)));

    var iconDecoration = BoxDecoration(
      color: Theme.of(context).accentColor.withOpacity(0.03),
      shape: BoxShape.circle,
    );

    var iconColor = Theme.of(context).accentColor.withOpacity(0.3);

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).focusColor.withOpacity(0.02),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 16.0,
              ),
              Card(
                elevation: 0.1,
                child: Column(
                  children: <Widget>[
                    Container(
                        padding:
                            EdgeInsets.only(top: 20.0, left: 20.0, bottom: 20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 70.0,
                              width: 70.0,
                              child: CircleAvatar(
                                backgroundColor: iconColor.withOpacity(0.03),
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: iconColor,
                                ),
                              ),
                            ),
                            SizedBox(width: 20.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Abdul Hakeem",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 18),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  "8073253788",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300, fontSize: 15),
                                ),
                                SizedBox(height: 5.0),
                                Text(
                                  "hakeem.nala@gmail.com",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300, fontSize: 15),
                                ),
                              ],
                            )
                          ],
                        )),
                    Divider(
                      height: 1,
                      thickness: 0.3,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Card(
                elevation: 0.1,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).appBarTheme.color,
                      child: ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WishList())),
                        leading: Container(
                            decoration: iconDecoration,
                            padding: EdgeInsets.all(6),
                            child: Icon(Icons.favorite, color: iconColor,)),
                        title: Text("My Wishlist"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 0.3,
                    ),
                    Container(
                      color: Theme.of(context).appBarTheme.color,
                      child: ListTile(
                        leading: Container(
                            decoration: iconDecoration,
                            padding: EdgeInsets.all(6),
                            child: Icon(Icons.shopping_basket, color: iconColor)),
                        title: Text("My Orders"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 0.3,
                    ),
                    Container(
                      color: Theme.of(context).appBarTheme.color,
                      child: ListTile(
                        leading: Container(
                            decoration: iconDecoration,
                            padding: EdgeInsets.all(6),
                            child: Icon(Icons.account_balance_wallet, color: iconColor,)),
                        title: Text("My Wallets"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Card(
                elevation: 0.1,
                child: Container(
                  //decoration: borderDecoration,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Container(
                            decoration: iconDecoration,
                            padding: EdgeInsets.all(6),
                            child: Icon(
                              Icons.notifications,
                              color: iconColor,
                            )),
                        title: Text("Notification"),
                        trailing: Switch(
                          value: switchControl,
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 0.3,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => SettingsPage()));
                        },
                        leading: Container(
                            decoration: iconDecoration,
                            padding: EdgeInsets.all(6),
                            child: Icon(Icons.settings, color: iconColor,)),
                        title: Text("Settings"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 0.3,
                      ),
                      ListTile(
                        onTap: () => logout(),
                        leading: Container(
                            decoration: iconDecoration,
                            padding: EdgeInsets.all(6),
                            child:  Icon(Icons.exit_to_app)),
                        title: Text("Logout"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _onTapLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _shareApp() {}


  void logout() async {
    widget.appStateModel.logout();
  }

  void toggleSwitch(bool value) {
    if (switchControl == false) {
      setState(() {
        switchControl = true;
      });
      // Put your code here which you want to execute on Switch ON event.

    } else {
      setState(() {
        switchControl = false;
      });
      // Put your code here which you want to execute on Switch OFF event.
    }
  }
}
