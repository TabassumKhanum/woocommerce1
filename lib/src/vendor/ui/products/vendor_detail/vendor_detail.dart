import 'dart:async';
import './../../../models/vendor_reviews_model.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../blocs/home_bloc.dart';
import '../../../../blocs/products_bloc.dart';
import '../../../../models/app_state_model.dart';
import '../../../../models/blocks_model.dart';
import '../../../../models/product_model.dart';
import '../../../../ui/blocks/banner_scroll_list.dart';
import '../../../../vendor/ui/products/vendor_detail/vendor_home.dart';
import '../../../../ui/products/product_grid/product_item.dart';
import '../../../../vendor/blocs/vendor_detail_bloc.dart';
import '../../../../vendor/blocs/vendor_products_bloc.dart';
import '../../../../vendor/models/vendor_details_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'location.dart';
import 'vendor_theme.dart';
import 'package:html/parser.dart' show parse;

class VendorDetails extends StatefulWidget {
  final vendorProductsBloc = VendorProductsBloc();
  final vendorDetailsBloc = VendorDetailBloc();
  final vendorId;
  final Store store;
  VendorDetails({Key key, this.vendorId, this.store})
      : super(key: key);

  @override
  _VendorDetailsState createState() => _VendorDetailsState();
}

class _VendorDetailsState extends State<VendorDetails>
    with SingleTickerProviderStateMixin {
  ScrollController _hideButtonController;
  var theme = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];

  final textStyle = TextStyle(
      fontFamily: 'Lexend_Deca', fontSize: 16, fontWeight: FontWeight.w400);
  var _isVisible;
  TabController _tabController;

  ScrollController _homeScrollController;
  ScrollController _allProductsScrollController;
  AppStateModel appStateModel = AppStateModel();

  ScrollController _reviewScrollController;

  @override
  initState() {
    super.initState();
    //theme..shuffle();
    widget.vendorDetailsBloc.filter['random'] = 'rand';
    widget.vendorProductsBloc.filter['vendor'] = widget.vendorId;
    widget.vendorDetailsBloc.filter['vendor'] = widget.vendorId;

    widget.vendorDetailsBloc.fetchHomeProducts();
    widget.vendorDetailsBloc.getDetails();
    widget.vendorProductsBloc.fetchAllProducts();
    widget.vendorDetailsBloc.getReviews();

    // fetch reviews

    _tabController = TabController(vsync: this, length: 4);
    _isVisible = true;

    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible)
          setState(() {
            _isVisible = false;
          });
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isVisible)
          setState(() {
            _isVisible = true;
          });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeData[theme[6]],
      child: Scaffold(
        body: Stack(children: <Widget>[
          Container(
            child: NestedScrollView(
              controller: _hideButtonController,
              headerSliverBuilder: (context, value) {
                return [
                  SliverAppBar(
                    expandedHeight: 140.0,
                    pinned: true,
                    //floating: true,
                    // snap: true,
                    titleSpacing: 5,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: StreamBuilder<VendorDetailsModel>(
                          stream: widget.vendorDetailsBloc.allVendorDetails,
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 20.0),
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 65),
                                        child: Container(
                                          // color: Colors.blue,
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          height: 60,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    radius: 20.0,
                                                    backgroundImage:
                                                        NetworkImage(snapshot
                                                            .data.store.icon),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 12,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    width: MediaQuery.of(context).size.width * 0.8,
                                                    child: Text(snapshot.data.store.name,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Lexend_Deca',
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          //color: Colors.theme.,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                      snapshot.data.store
                                                              .productsCount
                                                              .toString() +
                                                          ' Products',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Lexend_Deca',
                                                        fontSize: 12,
                                                        //color: Colors.grey,
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container();
                          }),
                    ),
                    title: Column(
                      children: <Widget>[],
                    ),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(90),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                          isScrollable: true,
                          controller: _tabController,
                          tabs: <Widget>[
                            Tab(
                              child: Text('Home'),
                            ),
                            Tab(
                              child: Text('All Products'),
                            ),
                            Tab(
                              child: Text('Reviews'),
                            ),
                            Tab(
                              child: Text('Contacts'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  VendorHome(vendorDetailsBloc: widget.vendorDetailsBloc),
                  StreamBuilder(
                      stream: widget.vendorProductsBloc.allProducts,
                      builder:
                          (context, AsyncSnapshot<List<Product>> snapshot) {
                        if (snapshot.hasData) {
                          return CustomScrollView(
                            controller: _allProductsScrollController,
                            slivers: buildLisOfBlocks(snapshot),
                          );
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else return Center(child: CircularProgressIndicator());
                      }),

                  //Reviews

                  StreamBuilder(
                    stream: widget.vendorDetailsBloc.allReviews,
                    builder:
                        (context, AsyncSnapshot<List<VendorReviews>> snapshot) {
                      return snapshot.hasData
                          ? CustomScrollView(
                              controller: _reviewScrollController,
                              slivers: [buildReviewsList(snapshot, context)])
                          : Container();
                    },
                  ),

                  StreamBuilder<VendorDetailsModel>(
                      stream: widget.vendorDetailsBloc.allVendorDetails,
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? Stack(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16.0, 0.0, 16.0, 20.0),
                                      child: LocationContainer(
                                          vendorDetailsBloc:
                                              widget.vendorDetailsBloc,
                                          store: snapshot.data.store),
                                    ),
                                    if (snapshot.data.store?.phone != null)
                                      FabCircularMenu(
                                        fabOpenIcon: Icon(Icons.chat_bubble, color: Theme.of(context).primaryIconTheme.color,),
                                        fabCloseIcon: Icon(Icons.close, color: Theme.of(context).primaryIconTheme.color,),
                                        child: Container(),
                                        ringColor: Theme.of(context).primaryColor,
                                        ringDiameter: 250.0,
                                        ringWidth: 100.0,
                                        options: <Widget>[
                                          snapshot.data.store?.email != null
                                              ? IconButton(
                                                  icon: Icon(Icons.mail, color: Theme.of(context).primaryIconTheme.color,),
                                                  onPressed: () {
                                                    openLink(snapshot
                                                        .data.store.email);
                                                  },
                                                  iconSize: 20.0,
                                                  color: Colors.black)
                                              : null,
                                          IconButton(
                                              icon: Icon(
                                                  FontAwesomeIcons.whatsapp, color: Theme.of(context).primaryIconTheme.color,),
                                              onPressed: () {
                                                final url = 'https://wa.me/' +
                                                    snapshot.data.store.phone;
                                                openLink(url);
                                              },
                                              iconSize: 20.0,
                                              color: Colors.black),
                                          IconButton(
                                              icon: Icon(Icons.message, color: Theme.of(context).primaryIconTheme.color,),
                                              onPressed: () {
                                                openLink('sms:' +
                                                    snapshot.data.store.phone);
                                              },
                                              iconSize: 20.0,
                                              color: Colors.black),
                                          IconButton(
                                              icon: Icon(Icons.call, color: Theme.of(context).primaryIconTheme.color,),
                                              onPressed: () {
                                                openLink('tel:' +
                                                    snapshot.data.store.phone);
                                              },
                                              iconSize: 20.0,
                                              color: Colors.black),
                                        ],
                                      )
                                    else
                                      Container(),
                                  ],
                                )
                            : Container();
                      }),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

  List<Widget> buildLisOfBlocks(AsyncSnapshot<List<Product>> snapshot) {
    List<Widget> list = new List<Widget>();

    if (snapshot.data != null) {
      list.add(ProductGrid(products: snapshot.data));
      /*list.add(SliverPadding(
          padding: EdgeInsets.all(0.0),
          sliver: SliverList(
              delegate: SliverChildListDelegate([
            Container(
                height: 60,
                child: StreamBuilder(
                    stream: widget.vendorProductsBloc.hasMoreItems,
                    builder: (context, AsyncSnapshot<bool> snapshot) {
                      return snapshot.hasData && snapshot.data == false
                          ? Center(
                              child: Text('No more products!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                          color: Theme.of(context)
                                              .primaryTextTheme
                                              .caption
                                              .color)))
                          : Center(child: CircularProgressIndicator());
                    }
                    //child: Center(child: CircularProgressIndicator())
                    ))
          ]))));*/
    }

    return list;
  }

  buildReviewsList(
      AsyncSnapshot<List<VendorReviews>> snapshot, BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildListTile(context, snapshot.data[index]),
              Divider(
                height: 0.0,
              ),
            ]);
      }, childCount: snapshot.data.length),
    );
  }

  buildListTile(context, VendorReviews comment) {
    return Container(
      padding: EdgeInsets.fromLTRB(22.0, 16.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 20.0,
                backgroundImage: AssetImage('lib/assets/images/icon1.jpg'),
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(comment.authorName,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w400)),
                          RatingBar(
                            initialRating: double.parse(comment.reviewRating),
                            itemSize: 15,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            ignoreGestures: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ],
                      ),
                      Text(timeago.format(comment.created),
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context).textTheme.caption.color))
                    ]),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Html(data: comment.reviewDescription),
        ],
      ),
    );
  }

  Future openLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
