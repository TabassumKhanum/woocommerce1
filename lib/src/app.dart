//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ui/home/drawer/drawer3.dart';
import 'ui/home/search.dart';
import 'models/app_state_model.dart';
import 'ui/accounts/account/account5.dart';
import 'ui/checkout/cart/cart.dart';
import 'ui/home/home.dart';
import 'ui/categories/categories.dart';
import 'ui/products/product_detail/product_detail.dart';
import 'vendor/ui/stores/stores.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {

  AppStateModel model = AppStateModel();

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    //_firebaseMessaging.requestNotificationPermissions();
  }

  void onTabTapped(int index) {
    print(model.blocks.localeText.account);
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [
      Home(),
      Categories(),
      //Deals(),
      //Stores(),
      CartPage(hideArrowButton: true),
      UserAccount(),
    ];

    List<Widget> _pageTitle = [
      /*Image.asset(
        'lib/assets/images/logo.png',
        width: 40.0,
        height: 30.0,
        fit: BoxFit.cover,
      ),*/
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'WC',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontFamily: 'Lexend_Deca',
              letterSpacing: 0.5,
              //color: Colors.amber,
              fontSize: 20,
            ),),
          Text(
            ' STORE',
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontFamily: 'Lexend_Deca',
                letterSpacing: 0.5,
                //color: Colors.redAccent,
                fontSize: 20
            ),),
        ],
      ),
    Text(model.blocks.localeText.category),
    //Text(model.blocks.localeText.deals),
    //Text(model.blocks.localeText.store),
    Text(model.blocks.localeText.cart),
    Text(model.blocks.localeText.account),
    ];

    return Scaffold(
        floatingActionButton: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              if (model.blocks?.settings?.enableHomeChat == 1 && _currentIndex == 0) {
                return FloatingActionButton(
                  onPressed: () => _openWhatsApp(
                      model.blocks.settings.whatsappNumber.toString()),
                  tooltip: 'Chat',
                  child: Icon(Icons.chat_bubble),
                );
              } else {
                return Container();
              }
            }),
      drawer: MyDrawer(),
      appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return RotatedBox(
                quarterTurns: 1,
                child: IconButton(
                  icon: Icon(FlutterIcons.bar_chart_2_fea),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                ),
              );
            },
          ),
        title: _pageTitle[_currentIndex],
          actions: [
            IconButton(
              icon: Icon(
                FlutterIcons.search_fea,
                semanticLabel: 'search',
              ),
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: SearchProducts(onProductClick));
              },
            )
          ]
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: buildBottomNavigationBar(context),
    );
  }

  onProductClick(product) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(
        product: product);
    }));
  }

  Future _openWhatsApp(String number) async {
    final url = 'https://wa.me/' + number;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  BottomNavigationBar buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: onTabTapped,
      backgroundColor: Theme.of(context).appBarTheme.color,
      //selectedItemColor: Theme.of(context).colorScheme.onPrimary,
      //unselectedItemColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.6),
      //showUnselectedLabels: false,
      //showSelectedLabels: false,
      elevation: 1.0,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).appBarTheme.color,
          icon: Icon(FlutterIcons.home_fea),//new Icon(CupertinoIcons.home),
          title: Text(
            model.blocks.localeText.home,
            style: TextStyle(
              fontSize: 12
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(FlutterIcons.grid_fea),
          title: Text(
            model.blocks.localeText.category,
            style: TextStyle(
              fontSize: 12
            ),
          ),
        ),
        /*BottomNavigationBarItem(
          icon: new Icon(IconData(0xf3e5,
              fontFamily: CupertinoIcons.iconFont,
              fontPackage: CupertinoIcons.iconFontPackage)),
          title: Text(
            AppLocalizations.of(context).deals,
          ),
        ),*/
        /*BottomNavigationBarItem(
          icon: new Icon(Icons.store),
          title: Text(
            AppLocalizations.of(context).stores,
          ),
        ),*/
        BottomNavigationBarItem(
          icon: Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Icon(FlutterIcons.shopping_cart_fea),
            ),
            new Positioned(
              // draw a red marble
              top: 0.0,
              right: 0.0,
              child: ScopedModelDescendant<AppStateModel>(builder: (context, child, model) {
                    if (model.count != 0) {
                      return Card(
                          elevation: 0,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          color: Colors.redAccent,
                          child: Container(
                              padding: EdgeInsets.all(2),
                              constraints: BoxConstraints(minWidth: 20.0),
                              child: Center(
                                  child: Text(
                                    model.count.toString(),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    backgroundColor: Colors.redAccent),
                              ))));
                    } else
                      return Container();
                  }),
            ),
          ]),
          title: Text(
            model.blocks.localeText.cart,
            style: TextStyle(
                fontSize: 12
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(FlutterIcons.user_fea),
          title: Text(
            model.blocks.localeText.account,
            style: TextStyle(
                fontSize: 12
            ),
          ),
        ),
      ],
    );
  }
}
