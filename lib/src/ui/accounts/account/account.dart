
import '../../../vendor/ui/products/vendor_detail/vendor_detail.dart';

import '../../../vendor/ui/orders/order_list.dart';
import '../../../vendor/ui/products/vendor_products/product_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';
import '../../../models/app_state_model.dart';
import '../../../ui/accounts/settings/settings.dart';
import '../../../models/post_model.dart';
import '../../../ui/accounts/address/customer_address.dart';
import '../../../ui/accounts/currency.dart';
import '../../../ui/accounts/language/language.dart';
import '../login/login.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../ui/accounts/orders/order_list.dart';
import '../../../ui/accounts/wishlist.dart';
import '../post_detail.dart';
import '../register.dart';
import 'dart:io' show Platform;
import '../try_demo.dart';


class UserAccount extends StatefulWidget {
  final appStateModel = AppStateModel();

  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.dark,
  );

  UserAccount({Key key}) : super(key: key);
  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  @override
  int _cIndex = 0;
  bool switchControl = false;

  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 130,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: ScopedModelDescendant<AppStateModel>(
                builder: (context, child, model) {
              if (model.loggedIn) {
                return Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              shape: BoxShape.circle),
                          child: IconButton(
                            icon: Icon(
                              Icons.person_outline,
                              size: 35,
                              color:
                                  Theme.of(context).accentTextTheme.title.color,
                            ),
                            onPressed: () => null,
                          )),
                      SizedBox(height: 5),
                      Text(widget.appStateModel.blocks.localeText.welcome,
                          style: TextStyle(fontWeight: FontWeight.w800))
                    ],
                  ),
                );
              } else {
                return Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).accentColor,
                                      shape: BoxShape.circle),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.person_outline,
                                      size: 35,
                                      color: Theme.of(context)
                                          .accentTextTheme
                                          .title
                                          .color,
                                    ),
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Login())),
                                  )),
                              SizedBox(height: 5),
                              Text(widget.appStateModel.blocks.localeText.signIn,
                                  style: TextStyle(fontWeight: FontWeight.w800))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.person_outline,
                                      size: 35,
                                      color: Theme.of(context)
                                          .accentTextTheme
                                          .title
                                          .color,
                                    ),
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterForm())),
                                  )),
                              SizedBox(height: 5),
                              Text(widget.appStateModel.blocks.localeText.signUp,
                                  style: TextStyle(fontWeight: FontWeight.w800))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 12, bottom: 10),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(widget.appStateModel.blocks.localeText.settings.toUpperCase(),
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w800)),
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.3,
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              leading: Icon(CupertinoIcons.settings),
              dense: true,
              title: Text(widget.appStateModel.blocks.localeText.settings,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  )),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
          ),
          ScopedModelDescendant<AppStateModel>(
              builder: (context, child, model) {
            if (model.blocks?.languages != null &&
                model.blocks.languages.length > 0) {
              return Column(
                children: <Widget>[
                  Container(
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      leading: Icon(Icons.mic_none),
                      dense: true,
                      title: Text(widget.appStateModel.blocks.localeText.language,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          )),
                      trailing: Container(
                        width: 140,
                        height: 40,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text('العربية',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Cairo')),
                              SizedBox(
                                width: 10,
                              ),
                              // Image.asset('assets/noon.png', width:30, height: 30,),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                              ),
                            ]),
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LanguagePage())),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 0.3,
                  ),
                ],
              );
            } else {
              return Container();
            }
          }),
          ScopedModelDescendant<AppStateModel>(
              builder: (context, child, model) {
            if (model.blocks?.currencies != null &&
                model.blocks.currencies.length > 0) {
              return Column(
                children: <Widget>[
                  Container(
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      dense: true,
                      leading: Icon(Icons.attach_money),
                      //dense: true,
                      title: Text(widget.appStateModel.blocks.localeText.currency,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          )),
                      trailing: Container(
                        width: 140,
                        height: 40,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(model.selectedCurrency,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'Cairo')),
                              SizedBox(
                                width: 10,
                              ),
                              // Image.asset('assets/noon.png', width:30, height: 30,),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                              ),
                            ]),
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CurrencyPage())),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 0.3,
                  ),
                ],
              );
            } else {
              return Container();
            }
          }),
          Divider(
            height: 1,
            thickness: 0.3,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 12, bottom: 10),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(widget.appStateModel.blocks.localeText.account.toUpperCase(),
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w800)),
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.3,
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              leading: Icon(CupertinoIcons.shopping_cart),
              dense: true,
              title: Text(widget.appStateModel.blocks.localeText.orders,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  )),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
              onTap: () {
                if (widget.appStateModel.user?.id != null &&
                    widget.appStateModel.user?.id != 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OrderList()));
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                }
              },
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.3,
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              leading: Icon(CupertinoIcons.heart),
              dense: true,
              title: Text(widget.appStateModel.blocks.localeText.wishlist,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  )),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
              onTap: () {
                if (widget.appStateModel.user?.id != null &&
                    widget.appStateModel.user?.id != 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WishList()));
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                }
              },
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.3,
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              leading: Icon(CupertinoIcons.location),
              dense: true,
              title: Text(widget.appStateModel.blocks.localeText.address,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  )),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
              onTap: () {
                if (widget.appStateModel.user?.id != null &&
                    widget.appStateModel.user?.id != 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CustomerAddress()));
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                }
              },
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.3,
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              dense: true,
              leading: Icon(CupertinoIcons.share),
              title: Text(widget.appStateModel.blocks.localeText.shareApp,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  )),
              trailing: Container(
                width: 70,
                height: 40,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 30,
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                    ]),
              ),
              onTap: () => _shareApp(),
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.3,
          ),
          Divider(
            height: 1,
            thickness: 0.3,
          ),
          ScopedModelDescendant<AppStateModel>(
              builder: (context, child, model) {
            if (model.loggedIn) {
              return Column(
                children: <Widget>[
                  Container(
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      dense: true,
                      leading: const Icon(IconData(0xf4ca,
                          fontFamily: CupertinoIcons.iconFont,
                          fontPackage: CupertinoIcons.iconFontPackage)),
                      title: Text(widget.appStateModel.blocks.localeText.logout,
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          )),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                      onTap: () => logout(),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 0.3,
                  ),
                ],
              );
            } else {
              return Container();
            }
          }),
          ScopedModelDescendant<AppStateModel>(
              builder: (context, child, model) {
            if (model.blocks != null &&
                model.blocks.pages.length != 0 &&
                model.blocks.pages[0].url.isNotEmpty) {
              return Column(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 12, bottom: 10),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          widget.appStateModel.blocks.localeText.info.toUpperCase(),
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w800)),
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: model.blocks.pages.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return model.blocks.pages[index].url.isNotEmpty
                            ? Column(
                                children: <Widget>[
                                  Container(
                                    color: Theme.of(context).cardColor,
                                    child: ListTile(
                                      dense: true,
                                      onTap: () {
                                        var post = Post();
                                        post.id = int.parse(
                                            model.blocks.pages[index].url);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PostDetail(post: post)));
                                      },
                                      leading: ExcludeSemantics(
                                        child: Icon(CupertinoIcons.info),
                                      ),
                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 15,
                                      ),
                                      title: Text(
                                        model.blocks.pages[index].title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(height: 0.0),
                                ],
                              )
                            : Container();
                      }),
                ],
              );
            } else {
              return Container();
            }
          }),





        ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              if (model.loggedIn && isVendor.contains(model.user.role)) {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 12, bottom: 10),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            'VENDOR',
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w800)),
                      ),
                    ),
                    Container(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .background,
                      child: ListTile(
                          dense: true,
                          leading: Icon(CupertinoIcons.bookmark),
                          //dense: true,
                          title: Text('Products',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              )),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                          onTap: () =>
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VendorProductList(vendorId: model.user.id.toString())))
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 0.3,
                    ),

                    Container(
                      color: Theme.of(context).colorScheme.background,
                      child: ListTile(
                          dense: true,
                          leading: Icon(CupertinoIcons.shopping_cart),
                          //dense: true,
                          title: Text(widget.appStateModel.blocks.localeText.orders,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              )),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      VendorOrderList(vendorId: model.user.id.toString())))
                      ),
                    ),

                    Divider(
                      height: 1,
                      thickness: 0.3,
                    ),

                    Container(
                      color: Theme.of(context).colorScheme.background,
                      child: ListTile(
                          dense: true,
                          leading: Icon(CupertinoIcons.info),
                          //dense: true,
                          title: Text(widget.appStateModel.blocks.localeText.info,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              )),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      VendorDetails(vendorId: model.user.id.toString() )))
                      ),
                    ),

                  ],
                );
              } else
                return Container();
            }),



          /*Padding(
            padding: const EdgeInsets.only(top: 20, left: 12, bottom: 10),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text('DEMO',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w800)),
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.3,
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              dense: true,
              leading: Icon(IconData(0xf3a2,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage)),
              //dense: true,
              title: Text(AppLocalizations.of(context).TryDemoForYourSite,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  )),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TryDemo())),
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.3,
          ),*/
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  //padding: EdgeInsets.only(top: 80,) ,
                  width: 220,
                  height: 40,
                  //color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.facebookF,
                          size: 22,
                          color: Colors.blueGrey,
                        ),
                        onPressed: () {
                          _onTapLink('https://www.facebook.com/');
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.twitter,
                          size: 22,
                          color: Colors.blueGrey,
                        ),
                        onPressed: () {
                          _onTapLink('https://www.twitter.com/');
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.instagram,
                          size: 22,
                          color: Colors.blueGrey,
                        ),
                        onPressed: () {
                          _onTapLink('https://www.instagra.com/');
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.linkedinIn,
                          size: 22,
                          color: Colors.blueGrey,
                        ),
                        onPressed: () {
                          _onTapLink('https://www.linkedin.com/');
                        },
                      )
                    ],
                  )),
            ),
          )
        ],
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

  _shareApp() {
    if (Platform.isIOS) {
      Share.share(widget.appStateModel.blocks.settings.shareAppIosLink);
    } else {
      Share.share(widget.appStateModel.blocks.settings.shareAppAndroidLink);
    }
  }

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

List<String> isVendor = [
  'seller',
  'wcfm_vendor',
  'dc_vendor'
];
