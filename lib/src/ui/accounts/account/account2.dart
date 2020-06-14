import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../models/app_state_model.dart';
import '../../../ui/accounts/settings/settings.dart';
import '../../../models/blocks_model.dart';
import '../../../models/post_model.dart';
//import 'package:rate_my_app/rate_my_app.dart';
import '../post_detail.dart';
import '../../../blocs/home_bloc.dart';
import 'dart:io' show Platform;
import '../login/login.dart';
import '../orders/order_list.dart';
import '../register.dart';
import '../wishlist.dart';
import '../../options.dart';
import '../address/customer_address.dart';
import '../currency.dart';
import '../language/language.dart';
import 'package:share/share.dart';
import '../try_demo.dart';

/*RateMyApp _rateMyApp = RateMyApp(
  preferencesPrefix: 'rateMyApp_',
  minDays: 7,
  minLaunches: 10,
  remindDays: 7,
  remindLaunches: 10,
);*/

class UserAccount extends StatefulWidget {
  final appStateModel = AppStateModel();

  UserAccount({Key key})
      : super(key: key);

  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          return CustomScrollView(
            slivers: <Widget>[
              (model.user?.id != null && model.user.id > 0)
                  ? buildLoggedInList(context)
                  : buildLoggedOutList(context),
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
          );
        });
  }

  SliverList buildLoggedOutList(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        ListTile(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Login())),
          leading: ExcludeSemantics(
              child: Icon(
            CupertinoIcons.padlock,
          )),
          title: Text(
              widget.appStateModel.blocks.localeText.signIn,
          ),
        ),
        Divider(height: 0.0),
        ListTile(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => RegisterForm())),
          leading: ExcludeSemantics(child: Icon(CupertinoIcons.person)),
          title: Text(
              widget.appStateModel.blocks.localeText.signUp,
          ),
        ),
        Divider(height: 0.0),
      ]),
    );
  }

  SliverList buildLoggedInList(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        ListTile(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WishList())),
          leading: ExcludeSemantics(child: Icon(CupertinoIcons.heart)),
          title: Text(
            widget.appStateModel.blocks.localeText.wishlist,
          ),
        ),
        Divider(height: 0.0),
        ListTile(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderList())),
          leading: ExcludeSemantics(child: Icon(CupertinoIcons.shopping_cart)),
          title: Text(
            widget.appStateModel.blocks.localeText.orders,
          ),
        ),
        Divider(height: 0.0),
        ListTile(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      CustomerAddress())),
          leading: ExcludeSemantics(child: Icon(CupertinoIcons.location)),
          title: Text(
            widget.appStateModel.blocks.localeText.address,
          ),
        ),
        Divider(height: 0.0),
      ]),
    );
  }

  SliverList buildCommonList(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Divider(height: 0.0),
        ListTile(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SettingsPage())),
          leading: ExcludeSemantics(child: Icon(CupertinoIcons.settings)),
          title: Text(
            widget.appStateModel.blocks.localeText.settings,
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
                          ExcludeSemantics(child: Icon(Icons.attach_money)),
                      title: Text(
                        widget.appStateModel.blocks.localeText.currency,
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
          leading: ExcludeSemantics(child: Icon(CupertinoIcons.share)),
          title: Text(
            widget.appStateModel.blocks.localeText.shareApp,
          ),
        ),
        Divider(height: 0.0),
      ]),
    );
  }

  SliverList buildLogoutList(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        ListTile(
          onTap: () => logout(),
          leading: ExcludeSemantics(
            child: RotatedBox(
              quarterTurns: 1,
              child: const Icon(IconData(0xf4ca,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage)),
            ),
          ),
          title: Text(
            widget.appStateModel.blocks.localeText.logout,
          ),
        ),
        Divider(height: 0.0),
      ]),
    );
  }

  SliverList buildOtherList(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        ListTile(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TryDemo())),
          leading: ExcludeSemantics(
              child: const Icon(IconData(0xf3a2,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage))),
          title: Text(
            'Test your site',
          ),
        ),
        Divider(height: 0.0),
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
