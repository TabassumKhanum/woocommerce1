import './../../../shrine/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../models/app_state_model.dart';
import '../../../ui/accounts/settings/settings.dart';
import '../../../models/blocks_model.dart';
import '../../../models/post_model.dart';
import '../post_detail.dart';
import '../../../blocs/home_bloc.dart';
import 'dart:io' show Platform;
import '../login/login2.dart';
import '../orders/order_list.dart';
import '../register.dart';
import '../wishlist.dart';
import '../../options.dart';
import '../address/customer_address.dart';
import '../currency.dart';
import '../language/language.dart';
import 'package:share/share.dart';
import '../try_demo.dart';

class UserAccount extends StatefulWidget {
  final appStateModel = AppStateModel();

  UserAccount({Key key})
      : super(key: key);

  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {

  var iconDecoration = BoxDecoration(
    color: shrinePink100.withOpacity(0.2),
    shape: BoxShape.circle,
  );

  var borderDecoration = BoxDecoration(
      color: shrinePink100,
      borderRadius: new BorderRadius.all(Radius.circular(4.0)));

  var iconColor = shrinePink100;

  @override
  Widget build(BuildContext context) {

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            return Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: CustomScrollView(
                slivers: <Widget>[
                  buildUserInfo(context, model),
                  buildLoggedInList(context, model),
                  buildCommonList(context),

                  ScopedModelDescendant<AppStateModel>(
                      builder: (context, child, model) {
                        if (model.blocks != null &&
                            model.blocks.pages.length != 0 &&
                            model.blocks.pages[0].url.isNotEmpty) {
                          return buildPageList(model.blocks.pages);
                        } else {
                          return SliverToBoxAdapter();
                        }
                      }),

                  (model.user?.id != null && model.user.id > 0)
                      ? buildLogoutList(context)
                      : SliverToBoxAdapter(),

                  buildOtherList(context),
                ],
              ),
            );
          }),
    );
  }

  buildUserInfo(BuildContext context, AppStateModel model) {
    return SliverPadding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Card(
            margin: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
            ),
            elevation: 0.0,
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 20.0, left: 20.0, bottom: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 70.0,
                          width: 70.0,
                          child: CircleAvatar(
                            backgroundColor: iconColor.withOpacity(0.2),
                            child: Icon(
                              FlutterIcons.user_fea,
                              size: 40,
                              color: iconColor,
                            ),
                          ),
                        ),
                        (model.user?.id != null && model.user.id > 0)
                            ? Row(
                              children: [
                                SizedBox(width: 20.0),
                                Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            (model.user.billing.firstName != '' && model.user.billing.lastName != '') ? Text(
                                  model.user.billing.firstName + ' ' + model.user.billing.lastName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600, fontSize: 18),
                                ) : null,
                            model.user.billing.phone != '' ? Column(
                                  children: [
                                    SizedBox(height: 5.0),
                                    Text(
                                      model.user.billing.phone,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300, fontSize: 15),
                                    ),
                                  ],
                                ) : null,
                            model.user.billing.email != '' ? Column(
                                  children: [
                                    SizedBox(height: 5.0),
                                    Text(
                                      model.user.billing.email,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300, fontSize: 15),
                                    ),
                                  ],
                                ) : null,
                          ],
                        ),
                              ],
                            ) : Container(child: FlatButton(
                          onPressed: () => Navigator.push(
                              context, MaterialPageRoute(builder: (context) => Login())),
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),)
                      ],
                    )),
                Divider(
                  height: 1,
                  thickness: 0.3,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  SliverPadding buildLoggedInList(BuildContext context, AppStateModel model) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 16.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Card(
            elevation: 0.0,
            margin: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
            ),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    if (model.user?.id != null && model.user.id > 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WishList()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Login()));
                    }
                  },
                  leading: Container(
                      decoration: iconDecoration,
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.favorite, color: iconColor)),
                  title: Text(
                    widget.appStateModel.blocks.localeText.wishlist,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Theme.of(context).focusColor,
                  ),
                ),
                Divider(height: 0.0),
                ListTile(
                  onTap: () {
                    if (model.user?.id != null && model.user.id > 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderList()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Login()));
                    }
                  },
                  leading: Container(
                      decoration: iconDecoration,
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.shopping_basket, color: iconColor)),
                  title: Text(
                      widget.appStateModel.blocks.localeText.orders,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Theme.of(context).focusColor,
                  ),
                ),
                Divider(height: 0.0),
                ListTile(
                  onTap: () {
                    if (model.user?.id != null && model.user.id > 0) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CustomerAddress()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Login()));
                    }
                  },
                  leading: Container(
                      decoration: iconDecoration,
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.location_on, color: iconColor)),
                  title: Text(
                      widget.appStateModel.blocks.localeText.address,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Theme.of(context).focusColor,
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  SliverPadding buildCommonList(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 16.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Divider(height: 0.0),
          Card(
            elevation: 0.0,
            margin: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: Column(
              children: [
                ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsPage())),
                  leading: Container(
                      decoration: iconDecoration,
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.settings, color: iconColor)),
                  title: Text(
                    widget.appStateModel.blocks.localeText.settings,
                  ),
                  trailing: Container(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Theme.of(context).focusColor,
                    ),
                  ),
                ),
                Divider(height: 0.0),
                ScopedModelDescendant<AppStateModel>(
                    builder: (context, child, model) {
                      if (model.blocks?.languages != null &&
                          model.blocks.languages.length > 0) {
                        return Column(
                          children: <Widget>[
                            ListTile(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LanguagePage())),
                              leading: ExcludeSemantics(
                                  child: const Icon((IconData(0xf38c,
                                      fontFamily: CupertinoIcons.iconFont,
                                      fontPackage: CupertinoIcons.iconFontPackage)))),
                              title: Text(
                                  widget.appStateModel.blocks.localeText.language,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: Theme.of(context).focusColor,
                              ),
                            ),
                            Divider(height: 0.0),
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
                            ListTile(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CurrencyPage())),
                              leading:
                              Container(
                                  decoration: iconDecoration,
                                  padding: EdgeInsets.all(6),
                                  child: Icon(Icons.attach_money, color: iconColor)),
                              title: Text(
                                  widget.appStateModel.blocks.localeText.currency,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: Theme.of(context).focusColor,
                              ),
                            ),
                            Divider(height: 0.0),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }),
                ListTile(
                  onTap: () => _shareApp(),
                  leading: Container(
                      decoration: iconDecoration,
                      padding: EdgeInsets.all(6),
                      child: Icon(Icons.share, color: iconColor)),
                  title: Text(
                      widget.appStateModel.blocks.localeText.shareApp,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Theme.of(context).focusColor,
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  SliverList buildLogoutList(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Card(
          elevation: 0.0,
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: ListTile(
            onTap: () => logout(),
            leading: Container(
                decoration: iconDecoration,
                padding: EdgeInsets.all(6),
                child: Icon(Icons.exit_to_app, color: iconColor)),
            title: Text(
              widget.appStateModel.blocks.localeText.logout,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 15,
                  color: Theme.of(context).focusColor,
            ),
          ),
        ),
        //Divider(height: 0.0),
      ]),
    );
  }

  SliverList buildOtherList(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Card(
          elevation: 0.0,
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TryDemo())),
            leading: Container(
                decoration: iconDecoration,
                padding: EdgeInsets.all(6),
                child: Icon(Icons.mobile_screen_share, color: iconColor)),
            title: Text(
              'Test your site',
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 15,
                color: Theme.of(context).focusColor,
            ),
          ),
        ),
        //Divider(height: 0.0),
      ]),
    );
  }

  void logout() async {
    widget.appStateModel.logout();
  }

  buildPageList(List<Child> pages) {
    return SliverPadding(
      padding: EdgeInsets.all(0.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return pages[index].url.isNotEmpty
                ? Column(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    var post = Post();
                    post.id = int.parse(pages[index].url);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PostDetail(post: post)));
                  },
                  leading: ExcludeSemantics(
                    child: Icon(CupertinoIcons.info),
                  ),
                  title: Text(pages[index].title,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                color: Theme.of(context).focusColor,
                  ),
                ),
                Divider(height: 0.0),
              ],
            )
                : Container();
          },
          childCount: pages.length,
        ),
      ),
    );
  }

  _shareApp() {
    if (Platform.isIOS) {
      //Add ios App link here
      Share.share(
          'check out thia app https://play.google.com/store/apps/details?id=com.mstoreapp.woocommerce');
    } else {
      //Add android app link here
      Share.share(
          'check out thia app https://play.google.com/store/apps/details?id=com.mstoreapp.woocommerce');
    }
  }

/*  rateApp() {
    _rateMyApp.showStarRateDialog(
      context,
      title: 'Rate this app',
      message:
          'You like this app ? Then take a little bit of your time to leave a rating :',
      onRatingChanged: (stars) {
        return [
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              print('Thanks for the ' +
                  (stars == null ? '0' : stars.round().toString()) +
                  ' star(s) !');
              // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
              _rateMyApp.doNotOpenAgain = true;
              _rateMyApp.save().then((v) => Navigator.pop(context));
            },
          ),
        ];
      },
      ignoreIOS: false,
      dialogStyle: DialogStyle(
        titleAlign: TextAlign.center,
        messageAlign: TextAlign.center,
        messagePadding: EdgeInsets.only(bottom: 20),
      ),
      starRatingOptions: StarRatingOptions(),
    );
  }*/
}
