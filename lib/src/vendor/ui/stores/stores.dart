import 'dart:ui';

import './../../models/store_model.dart';
import './../../models/vendor_details_model.dart';
import './../../ui/products/vendor_detail/vendor_detail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'store_state_model.dart';

const double _scaffoldPadding = 10.0;
const double _minWidthPerColumn = 350.0 + _scaffoldPadding * 2;

class Stores extends StatefulWidget {
  final StoreStateModel model = StoreStateModel();
  @override
  _StoresState createState() => _StoresState();
}

class _StoresState extends State<Stores> {
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    super.initState();
    widget.model.getAllStores();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ScopedModel<StoreStateModel>(
            model: widget.model,
            child: ScopedModelDescendant<StoreStateModel>(
                builder: (context, child, model) {
              return model.stores != null
                  ? CustomScrollView(
                      controller: _scrollController,
                      slivers: buildListOfBlocks(model.stores),
                    )
                  : Center(child: CircularProgressIndicator());
            })));
  }

  List<Widget> buildListOfBlocks(List<StoreModel> stores) {
    List<Widget> list = new List<Widget>();
    list.add(PostVerticalScroll1(stores: stores));
    return list;
  }
}

class PostVerticalScroll1 extends StatelessWidget {
  final List<StoreModel> stores;
  PostVerticalScroll1({Key key, this.stores}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < _minWidthPerColumn
        ? 1
        : screenWidth ~/ _minWidthPerColumn;
    return SliverPadding(
      padding: const EdgeInsets.all(10.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 1.9,
          crossAxisCount: crossAxisCount,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return PostCard6(store: stores[index], index: index);
          },
          childCount: stores.length,
        ),
      ),
    );
  }
}

class PostCard6 extends StatelessWidget {
  final StoreModel store;
  final int index;
  PostCard6({Key key, this.store, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    Widget featuredImage = store.banner != null
        ? CachedNetworkImage(
            imageUrl: store.banner,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => Container(color: Colors.black12),
            errorWidget: (context, url, error) => Icon(Icons.error),
          )
        : Container();
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0)),
      ),
      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
      elevation: 1.0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openDetails(store, context),
        child: new Stack(
          children: <Widget>[
            featuredImage,
            new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
              child: new Container(
                decoration: new BoxDecoration(
                  color: Colors.purple,
                  gradient: new LinearGradient(
                      colors: [Colors.black54, Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: new Alignment(0.0, 0.0),
                      tileMode: TileMode.clamp),
                ),
              ),
            ),
            new Positioned(
              left: 10.0,
              bottom: 10.0,
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(store.icon),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 340,
                        child: new Text(store.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.white,
                            )),
                      ),
                      store.averageRating != null ? Row(
                        children: <Widget>[
                          RatingBar(
                            itemSize: 12.0,
                            initialRating: store.averageRating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                          SizedBox(
                            width: 6.0,
                          ),
                          Text(
                            '(' + store.ratingCount.toString() + ' Reviews)',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                                color: Colors.white),
                          ),
                        ],
                      ) : Container()
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  openDetails(StoreModel store, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return VendorDetails(
        vendorId: store.id.toString(),
      );
    }));
  }
}
